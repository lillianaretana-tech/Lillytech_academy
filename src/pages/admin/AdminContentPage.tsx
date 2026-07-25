import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import {
  adminListPaths,
  adminCreatePath,
  adminUpdatePath,
  adminDeletePath,
  adminListStages,
  adminCreateStage,
  adminUpdateStage,
  adminDeleteStage,
  adminListCourses,
  adminCreateCourse,
  adminUpdateCourse,
  adminDeleteCourse,
  adminListModules,
  adminCreateModule,
  adminUpdateModule,
  adminDeleteModule,
  adminListLessons,
  adminCreateLesson,
  adminDeleteLesson,
} from '@/services/admin.service'
import type { LearningPath, Stage, Course, CourseModule, Lesson } from '@/types/database.types'

// Panel de administración de contenido: rutas > etapas > cursos > módulos > lecciones.
// La edición de contenido largo de una lección vive en /admin/lessons/:id — acá
// solo se crean/renombran/publican/ordenan/eliminan.

export function AdminContentPage() {
  const [paths, setPaths] = useState<LearningPath[]>([])
  const [loading, setLoading] = useState(true)
  const [openPathId, setOpenPathId] = useState<string | null>(null)

  async function refreshPaths() {
    setLoading(true)
    setPaths(await adminListPaths())
    setLoading(false)
  }

  useEffect(() => {
    refreshPaths()
  }, [])

  const [newPathTitle, setNewPathTitle] = useState('')

  async function handleCreatePath() {
    if (!newPathTitle.trim()) return
    await adminCreatePath({
      title: newPathTitle.trim(),
      description: '',
      order_index: paths.length,
    })
    setNewPathTitle('')
    await refreshPaths()
  }

  return (
    <div>
      <div className="mb-4 flex items-center justify-between">
        <div>
          <h1 className="font-display text-2xl font-semibold text-ink">Administración</h1>
          <p className="text-sm text-ink-soft">Rutas, etapas, cursos, módulos y lecciones.</p>
        </div>
        <div className="flex gap-2">
          <Link to="/admin/progress" className="btn-secondary text-xs">
            Ver progreso
          </Link>
        </div>
      </div>

      <div className="card mb-4 flex gap-2">
        <input
          className="input-field"
          placeholder="Nombre de una nueva ruta de aprendizaje"
          value={newPathTitle}
          onChange={(e) => setNewPathTitle(e.target.value)}
        />
        <button onClick={handleCreatePath} className="btn-primary text-xs">
          Crear ruta
        </button>
      </div>

      {loading ? (
        <p className="text-sm text-ink-soft">Cargando…</p>
      ) : (
        <div className="flex flex-col gap-3">
          {paths.map((path) => (
            <PathRow
              key={path.id}
              path={path}
              isOpen={openPathId === path.id}
              onToggle={() => setOpenPathId(openPathId === path.id ? null : path.id)}
              onChanged={refreshPaths}
            />
          ))}
        </div>
      )}
    </div>
  )
}

function PathRow({
  path,
  isOpen,
  onToggle,
  onChanged,
}: {
  path: LearningPath
  isOpen: boolean
  onToggle: () => void
  onChanged: () => void
}) {
  const [editing, setEditing] = useState(false)
  const [title, setTitle] = useState(path.title)
  const [description, setDescription] = useState(path.description ?? '')

  async function handleSave() {
    await adminUpdatePath(path.id, { title, description })
    setEditing(false)
    onChanged()
  }

  async function handleTogglePublish() {
    await adminUpdatePath(path.id, { is_published: !path.is_published })
    onChanged()
  }

  async function handleDelete() {
    if (!confirm(`¿Eliminar la ruta "${path.title}" y todo su contenido? Esta acción no se puede deshacer.`))
      return
    await adminDeletePath(path.id)
    onChanged()
  }

  return (
    <div className="card">
      <div className="flex items-center justify-between gap-3">
        <button onClick={onToggle} className="flex-1 text-left">
          {editing ? (
            <input
              className="input-field"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              onClick={(e) => e.stopPropagation()}
            />
          ) : (
            <p className="text-sm font-semibold text-ink">{path.title}</p>
          )}
        </button>
        <PublishBadge isPublished={path.is_published} onClick={handleTogglePublish} />
      </div>

      {editing && (
        <textarea
          className="input-field mt-2"
          rows={2}
          value={description}
          onChange={(e) => setDescription(e.target.value)}
        />
      )}

      <div className="mt-2 flex gap-3 text-xs">
        {editing ? (
          <button onClick={handleSave} className="text-brass hover:underline">
            Guardar
          </button>
        ) : (
          <button onClick={() => setEditing(true)} className="text-ink-soft hover:text-brass">
            Editar
          </button>
        )}
        <button onClick={handleDelete} className="text-ink-soft hover:text-rust">
          Eliminar
        </button>
      </div>

      {isOpen && <StageManager pathId={path.id} />}
    </div>
  )
}

function StageManager({ pathId }: { pathId: string }) {
  const [stages, setStages] = useState<Stage[]>([])
  const [loading, setLoading] = useState(true)
  const [openStageId, setOpenStageId] = useState<string | null>(null)
  const [newTitle, setNewTitle] = useState('')

  async function refresh() {
    setLoading(true)
    setStages(await adminListStages(pathId))
    setLoading(false)
  }

  useEffect(() => {
    refresh()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pathId])

  async function handleCreate() {
    if (!newTitle.trim()) return
    await adminCreateStage({
      path_id: pathId,
      title: newTitle.trim(),
      description: '',
      order_index: stages.length + 1,
    })
    setNewTitle('')
    await refresh()
  }

  async function handleTogglePublish(stage: Stage) {
    await adminUpdateStage(stage.id, { is_published: !stage.is_published })
    await refresh()
  }

  async function handleDelete(stage: Stage) {
    if (!confirm(`¿Eliminar la etapa "${stage.title}"?`)) return
    await adminDeleteStage(stage.id)
    await refresh()
  }

  return (
    <div className="mt-4 border-t border-ink/10 pt-4">
      <div className="mb-2 flex gap-2">
        <input
          className="input-field text-xs"
          placeholder="Nueva etapa…"
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
        />
        <button onClick={handleCreate} className="btn-secondary text-xs">
          Agregar
        </button>
      </div>

      {loading ? (
        <p className="text-xs text-ink-soft">Cargando etapas…</p>
      ) : (
        <div className="flex flex-col gap-2 pl-2">
          {stages.map((stage) => (
            <div key={stage.id} className="rounded-md border border-ink/10 p-2">
              <div className="flex items-center justify-between gap-2">
                <button
                  onClick={() => setOpenStageId(openStageId === stage.id ? null : stage.id)}
                  className="flex-1 text-left text-xs font-medium text-ink"
                >
                  {stage.order_index}. {stage.title}
                </button>
                <PublishBadge isPublished={stage.is_published} onClick={() => handleTogglePublish(stage)} />
                <button
                  onClick={() => handleDelete(stage)}
                  className="text-xs text-ink-soft hover:text-rust"
                >
                  Eliminar
                </button>
              </div>
              {openStageId === stage.id && <CourseManager stageId={stage.id} />}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

function CourseManager({ stageId }: { stageId: string }) {
  const [courses, setCourses] = useState<Course[]>([])
  const [loading, setLoading] = useState(true)
  const [openCourseId, setOpenCourseId] = useState<string | null>(null)
  const [newTitle, setNewTitle] = useState('')

  async function refresh() {
    setLoading(true)
    setCourses(await adminListCourses(stageId))
    setLoading(false)
  }

  useEffect(() => {
    refresh()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [stageId])

  async function handleCreate() {
    if (!newTitle.trim()) return
    await adminCreateCourse({
      stage_id: stageId,
      title: newTitle.trim(),
      description: '',
      order_index: courses.length + 1,
    })
    setNewTitle('')
    await refresh()
  }

  async function handleTogglePublish(course: Course) {
    await adminUpdateCourse(course.id, { is_published: !course.is_published })
    await refresh()
  }

  async function handleDelete(course: Course) {
    if (!confirm(`¿Eliminar el curso "${course.title}"?`)) return
    await adminDeleteCourse(course.id)
    await refresh()
  }

  return (
    <div className="mt-3 border-t border-ink/10 pt-3">
      <div className="mb-2 flex gap-2">
        <input
          className="input-field text-xs"
          placeholder="Nuevo curso…"
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
        />
        <button onClick={handleCreate} className="btn-secondary text-xs">
          Agregar
        </button>
      </div>

      {loading ? (
        <p className="text-xs text-ink-soft">Cargando cursos…</p>
      ) : (
        <div className="flex flex-col gap-2 pl-2">
          {courses.map((course) => (
            <div key={course.id} className="rounded-md border border-ink/10 p-2">
              <div className="flex items-center justify-between gap-2">
                <button
                  onClick={() => setOpenCourseId(openCourseId === course.id ? null : course.id)}
                  className="flex-1 text-left text-xs font-medium text-ink"
                >
                  {course.title}
                </button>
                <PublishBadge isPublished={course.is_published} onClick={() => handleTogglePublish(course)} />
                <button
                  onClick={() => handleDelete(course)}
                  className="text-xs text-ink-soft hover:text-rust"
                >
                  Eliminar
                </button>
              </div>
              {openCourseId === course.id && <ModuleManager courseId={course.id} />}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

function ModuleManager({ courseId }: { courseId: string }) {
  const [modules, setModules] = useState<CourseModule[]>([])
  const [loading, setLoading] = useState(true)
  const [openModuleId, setOpenModuleId] = useState<string | null>(null)
  const [newTitle, setNewTitle] = useState('')

  async function refresh() {
    setLoading(true)
    setModules(await adminListModules(courseId))
    setLoading(false)
  }

  useEffect(() => {
    refresh()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [courseId])

  async function handleCreate() {
    if (!newTitle.trim()) return
    await adminCreateModule({
      course_id: courseId,
      title: newTitle.trim(),
      description: '',
      order_index: modules.length + 1,
    })
    setNewTitle('')
    await refresh()
  }

  async function handleTogglePublish(mod: CourseModule) {
    await adminUpdateModule(mod.id, { is_published: !mod.is_published })
    await refresh()
  }

  async function handleDelete(mod: CourseModule) {
    if (!confirm(`¿Eliminar el módulo "${mod.title}"?`)) return
    await adminDeleteModule(mod.id)
    await refresh()
  }

  return (
    <div className="mt-3 border-t border-ink/10 pt-3">
      <div className="mb-2 flex gap-2">
        <input
          className="input-field text-xs"
          placeholder="Nuevo módulo…"
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
        />
        <button onClick={handleCreate} className="btn-secondary text-xs">
          Agregar
        </button>
      </div>

      {loading ? (
        <p className="text-xs text-ink-soft">Cargando módulos…</p>
      ) : (
        <div className="flex flex-col gap-2 pl-2">
          {modules.map((mod) => (
            <div key={mod.id} className="rounded-md border border-ink/10 p-2">
              <div className="flex items-center justify-between gap-2">
                <button
                  onClick={() => setOpenModuleId(openModuleId === mod.id ? null : mod.id)}
                  className="flex-1 text-left text-xs font-medium text-ink"
                >
                  {mod.title}
                </button>
                <PublishBadge isPublished={mod.is_published} onClick={() => handleTogglePublish(mod)} />
                <button onClick={() => handleDelete(mod)} className="text-xs text-ink-soft hover:text-rust">
                  Eliminar
                </button>
              </div>
              {openModuleId === mod.id && <LessonManager moduleId={mod.id} />}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

function LessonManager({ moduleId }: { moduleId: string }) {
  const [lessons, setLessons] = useState<Lesson[]>([])
  const [loading, setLoading] = useState(true)
  const [newTitle, setNewTitle] = useState('')

  async function refresh() {
    setLoading(true)
    setLessons(await adminListLessons(moduleId))
    setLoading(false)
  }

  useEffect(() => {
    refresh()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [moduleId])

  async function handleCreate() {
    if (!newTitle.trim()) return
    await adminCreateLesson({
      module_id: moduleId,
      title: newTitle.trim(),
      order_index: lessons.length + 1,
    })
    setNewTitle('')
    await refresh()
  }

  async function handleDelete(lesson: Lesson) {
    if (!confirm(`¿Eliminar la lección "${lesson.title}"?`)) return
    await adminDeleteLesson(lesson.id)
    await refresh()
  }

  return (
    <div className="mt-3 border-t border-ink/10 pt-3">
      <div className="mb-2 flex gap-2">
        <input
          className="input-field text-xs"
          placeholder="Nueva lección… (el contenido se edita después)"
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
        />
        <button onClick={handleCreate} className="btn-secondary text-xs">
          Agregar
        </button>
      </div>

      {loading ? (
        <p className="text-xs text-ink-soft">Cargando lecciones…</p>
      ) : (
        <div className="flex flex-col gap-1 pl-2">
          {lessons.map((lesson) => (
            <div
              key={lesson.id}
              className="flex items-center justify-between gap-2 rounded-md px-2 py-1 hover:bg-paper-muted"
            >
              <Link to={`/admin/lessons/${lesson.id}`} className="flex-1 text-xs text-ink hover:text-brass">
                {lesson.title}
              </Link>
              <span
                className={`text-[10px] ${lesson.is_published ? 'text-sage' : 'text-ink-soft'}`}
              >
                {lesson.is_published ? 'Publicada' : 'Borrador'}
              </span>
              <button onClick={() => handleDelete(lesson)} className="text-xs text-ink-soft hover:text-rust">
                Eliminar
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

function PublishBadge({ isPublished, onClick }: { isPublished: boolean; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className={`whitespace-nowrap rounded-full px-2 py-0.5 text-[10px] font-medium ${
        isPublished ? 'bg-sage/20 text-sage' : 'bg-paper-muted text-ink-soft'
      }`}
    >
      {isPublished ? 'Publicado' : 'Borrador'}
    </button>
  )
}
