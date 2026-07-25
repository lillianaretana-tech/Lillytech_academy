import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '@/features/auth/hooks/useAuth'
import { listPublishedPaths, getPathTree, type PathTree } from '@/services/learningStructure.service'
import { listMyProgress } from '@/services/progress.service'
import type { LearningPath, LessonProgressRow } from '@/types/database.types'

export function LibraryPage() {
  const { user } = useAuth()
  const [paths, setPaths] = useState<LearningPath[]>([])
  const [selectedTree, setSelectedTree] = useState<PathTree | null>(null)
  const [progress, setProgress] = useState<LessonProgressRow[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [openStageId, setOpenStageId] = useState<string | null>(null)
  const [search, setSearch] = useState('')

  useEffect(() => {
    async function load() {
      if (!user) return
      setLoading(true)
      setError(null)
      try {
        const list = await listPublishedPaths()
        setPaths(list)
        if (list[0]) {
          const [tree, prog] = await Promise.all([
            getPathTree(list[0].id),
            listMyProgress(user.id),
          ])
          setSelectedTree(tree)
          setProgress(prog)
          setOpenStageId(tree?.stages[0]?.id ?? null)
        }
      } catch (e) {
        setError(e instanceof Error ? e.message : 'No se pudo cargar la biblioteca.')
      } finally {
        setLoading(false)
      }
    }
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user?.id])

  const progressByLesson = new Map(progress.map((p) => [p.lesson_id, p.status]))

  const searchResults = useMemo(() => {
    if (!search.trim() || !selectedTree) return null
    const q = search.toLowerCase()
    const matches: { lesson: (typeof selectedTree.stages)[number]['courses'][number]['modules'][number]['lessons'][number]; stageTitle: string }[] = []
    for (const stage of selectedTree.stages) {
      for (const course of stage.courses) {
        for (const mod of course.modules) {
          for (const lesson of mod.lessons) {
            const haystack = `${lesson.title} ${lesson.summary ?? ''}`.toLowerCase()
            if (haystack.includes(q)) matches.push({ lesson, stageTitle: stage.title })
          }
        }
      }
    }
    return matches
  }, [search, selectedTree])

  if (loading) return <p className="text-sm text-ink-soft">Cargando biblioteca…</p>

  if (error) {
    return (
      <div className="card">
        <p className="text-sm text-rust">{error}</p>
      </div>
    )
  }

  if (paths.length === 0 || !selectedTree) {
    return (
      <div>
        <h1 className="mb-1 font-display text-2xl font-semibold text-ink">Biblioteca</h1>
        <div className="card mt-4">
          <p className="text-sm text-ink-soft">
            Todavía no hay rutas publicadas — corré el seed inicial o publicá contenido desde
            Administración.
          </p>
        </div>
      </div>
    )
  }

  return (
    <div>
      <h1 className="mb-1 font-display text-2xl font-semibold text-ink">{selectedTree.title}</h1>
      <p className="mb-4 text-sm text-ink-soft">{selectedTree.description}</p>

      <input
        className="input-field mb-4 max-w-sm"
        placeholder="Buscar una lección…"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />

      {searchResults ? (
        <div className="flex flex-col gap-2">
          {searchResults.length === 0 ? (
            <p className="text-sm text-ink-soft">Ninguna lección coincide con "{search}".</p>
          ) : (
            searchResults.map(({ lesson, stageTitle }) => {
              const status = progressByLesson.get(lesson.id) ?? 'not_started'
              return (
                <Link
                  key={lesson.id}
                  to={`/lesson/${lesson.id}`}
                  className="card flex items-center justify-between hover:bg-paper-muted"
                >
                  <div>
                    <p className="text-sm text-ink">{lesson.title}</p>
                    <p className="text-xs text-ink-soft">{stageTitle}</p>
                  </div>
                  <StatusBadge status={status} />
                </Link>
              )
            })
          )}
        </div>
      ) : (
        <div className="flex flex-col gap-3">
        {selectedTree.stages.map((stage) => {
          const isOpen = openStageId === stage.id
          const totalLessonsInStage = stage.courses.reduce(
            (acc, c) => acc + c.modules.reduce((a, m) => a + m.lessons.length, 0),
            0,
          )
          return (
            <div key={stage.id} className="card">
              <button
                onClick={() => setOpenStageId(isOpen ? null : stage.id)}
                className="flex w-full items-center justify-between text-left"
              >
                <div>
                  <p className="text-sm font-semibold text-ink">{stage.title}</p>
                  <p className="text-xs text-ink-soft">{stage.description}</p>
                </div>
                <span className="text-xs text-brass">
                  {totalLessonsInStage} lección{totalLessonsInStage !== 1 ? 'es' : ''}
                </span>
              </button>

              {isOpen && (
                <div className="mt-4 flex flex-col gap-4 border-t border-ink/10 pt-4">
                  {stage.courses.length === 0 && (
                    <p className="text-xs text-ink-soft">
                      Esta etapa todavía no tiene cursos publicados.
                    </p>
                  )}
                  {stage.courses.map((course) => (
                    <div key={course.id}>
                      <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-brass-dark">
                        {course.title}
                      </p>
                      {course.modules.map((mod) => (
                        <div key={mod.id} className="mb-3 pl-2">
                          <p className="mb-1 text-xs font-medium text-ink-soft">{mod.title}</p>
                          <ul className="flex flex-col gap-1">
                            {mod.lessons.map((lesson) => {
                              const status = progressByLesson.get(lesson.id) ?? 'not_started'
                              return (
                                <li key={lesson.id}>
                                  <Link
                                    to={`/lesson/${lesson.id}`}
                                    className="flex items-center justify-between rounded-md px-2 py-1.5 text-sm text-ink hover:bg-paper-muted"
                                  >
                                    <span>{lesson.title}</span>
                                    <StatusBadge status={status} />
                                  </Link>
                                </li>
                              )
                            })}
                          </ul>
                        </div>
                      ))}
                    </div>
                  ))}
                </div>
              )}
            </div>
          )
        })}
        </div>
      )}
    </div>
  )
}

function StatusBadge({ status }: { status: string }) {
  const map: Record<string, { label: string; className: string }> = {
    not_started: { label: 'Sin empezar', className: 'text-ink-soft' },
    in_progress: { label: 'En progreso', className: 'text-brass-dark' },
    completed: { label: 'Completada', className: 'text-sage' },
    needs_review: { label: 'Repasar', className: 'text-rust' },
  }
  const entry = map[status] ?? map.not_started
  return <span className={`text-xs ${entry.className}`}>{entry.label}</span>
}
