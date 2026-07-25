import { useEffect, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { useAuth } from '@/features/auth/hooks/useAuth'
import { globalSearch, type GlobalSearchResults } from '@/services/search.service'
import type { PersonalNote, ConceptNote } from '@/types/database.types'

function isConceptNote(note: PersonalNote | ConceptNote): note is ConceptNote {
  return 'concept_id' in note
}

export function SearchPage() {
  const { user } = useAuth()
  const [searchParams, setSearchParams] = useSearchParams()
  const query = searchParams.get('q') ?? ''
  const [input, setInput] = useState(query)
  const [results, setResults] = useState<GlobalSearchResults | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    async function run() {
      if (!user || !query.trim()) {
        setResults(null)
        return
      }
      setLoading(true)
      setResults(await globalSearch(user.id, query.trim()))
      setLoading(false)
    }
    run()
  }, [query, user?.id])

  function handleSearch() {
    setSearchParams(input.trim() ? { q: input.trim() } : {})
  }

  const totalResults = results
    ? results.concepts.length +
      results.lessons.length +
      results.notes.length +
      results.questions.length +
      results.projects.length
    : 0

  return (
    <div>
      <h1 className="mb-1 font-display text-2xl font-semibold text-ink">Buscar</h1>
      <p className="mb-4 text-sm text-ink-soft">
        Un solo lugar para encontrar conceptos, lecciones, notas, dudas y proyectos.
      </p>

      <div className="mb-6 flex max-w-lg gap-2">
        <input
          className="input-field"
          placeholder="Buscar en toda tu Academia…"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
          autoFocus
        />
        <button onClick={handleSearch} className="btn-primary text-xs">
          Buscar
        </button>
      </div>

      {!query.trim() ? (
        <p className="text-sm text-ink-soft">Escribí algo para empezar a buscar.</p>
      ) : loading ? (
        <p className="text-sm text-ink-soft">Buscando…</p>
      ) : totalResults === 0 ? (
        <p className="text-sm text-ink-soft">Ningún resultado para "{query}".</p>
      ) : (
        <div className="flex flex-col gap-6">
          {results!.concepts.length > 0 && (
            <ResultGroup title="Conceptos">
              {results!.concepts.map((c) => (
                <Link key={c.id} to={`/concepts/${c.id}`} className="block hover:text-brass">
                  {c.title}
                </Link>
              ))}
            </ResultGroup>
          )}

          {results!.lessons.length > 0 && (
            <ResultGroup title="Lecciones">
              {results!.lessons.map((l) => (
                <Link key={l.id} to={`/lesson/${l.id}`} className="block hover:text-brass">
                  {l.title}
                </Link>
              ))}
            </ResultGroup>
          )}

          {results!.notes.length > 0 && (
            <ResultGroup title="Notas">
              {results!.notes.map((n) => (
                <Link
                  key={n.id}
                  to={isConceptNote(n) ? `/concepts/${n.concept_id}` : `/lesson/${n.lesson_id}`}
                  className="block hover:text-brass"
                >
                  {n.content.slice(0, 100)}
                  {n.content.length > 100 ? '…' : ''}
                </Link>
              ))}
            </ResultGroup>
          )}

          {results!.questions.length > 0 && (
            <ResultGroup title="Dudas">
              {results!.questions.map((q) => (
                <Link key={q.id} to={`/lesson/${q.lesson_id}`} className="block hover:text-brass">
                  {q.question}
                </Link>
              ))}
            </ResultGroup>
          )}

          {results!.projects.length > 0 && (
            <ResultGroup title="Proyectos">
              {results!.projects.map((p) => (
                <Link key={p.id} to="/projects" className="block hover:text-brass">
                  {p.name}
                </Link>
              ))}
            </ResultGroup>
          )}
        </div>
      )}
    </div>
  )
}

function ResultGroup({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="card">
      <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-brass-dark">{title}</p>
      <div className="flex flex-col gap-2 text-sm text-ink">{children}</div>
    </div>
  )
}
