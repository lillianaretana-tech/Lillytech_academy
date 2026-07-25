import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { listPublishedConcepts } from '@/services/concepts.service'
import type { Concept } from '@/types/database.types'

export function ConceptsLibraryPage() {
  const [concepts, setConcepts] = useState<Concept[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')

  useEffect(() => {
    listPublishedConcepts()
      .then(setConcepts)
      .finally(() => setLoading(false))
  }, [])

  const filtered = useMemo(() => {
    if (!search.trim()) return concepts
    const q = search.toLowerCase()
    return concepts.filter(
      (c) =>
        c.title.toLowerCase().includes(q) ||
        (c.what_is ?? '').toLowerCase().includes(q) ||
        (c.problem_it_solves ?? '').toLowerCase().includes(q),
    )
  }, [concepts, search])

  return (
    <div>
      <h1 className="mb-1 font-display text-2xl font-semibold text-ink">Biblioteca de Conceptos</h1>
      <p className="mb-4 text-sm text-ink-soft">
        Tu segunda memoria — cada concepto explicado una sola vez, conectado a lecciones y proyectos.
      </p>

      <input
        className="input-field mb-4 max-w-sm"
        placeholder="Buscar un concepto…"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />

      {loading ? (
        <p className="text-sm text-ink-soft">Cargando conceptos…</p>
      ) : filtered.length === 0 ? (
        <div className="card">
          <p className="text-sm text-ink-soft">
            {concepts.length === 0
              ? 'Todavía no hay conceptos publicados — se cargan desde Administración → Conceptos.'
              : `Ningún concepto coincide con "${search}".`}
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
          {filtered.map((concept) => (
            <Link
              key={concept.id}
              to={`/concepts/${concept.id}`}
              className="card hover:bg-paper-muted"
            >
              <p className="text-sm font-semibold text-ink">{concept.title}</p>
              {concept.what_is && (
                <p className="mt-1 line-clamp-2 text-xs text-ink-soft">{concept.what_is}</p>
              )}
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
