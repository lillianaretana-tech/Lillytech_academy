import { useEffect, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { adminListConcepts, adminCreateConcept, adminDeleteConcept } from '@/services/admin.service'
import type { Concept } from '@/types/database.types'

export function AdminConceptsPage() {
  const navigate = useNavigate()
  const [concepts, setConcepts] = useState<Concept[]>([])
  const [loading, setLoading] = useState(true)
  const [newTitle, setNewTitle] = useState('')
  const [creating, setCreating] = useState(false)

  async function refresh() {
    setLoading(true)
    setConcepts(await adminListConcepts())
    setLoading(false)
  }

  useEffect(() => {
    refresh()
  }, [])

  async function handleCreate() {
    if (!newTitle.trim()) return
    setCreating(true)
    try {
      const concept = await adminCreateConcept(newTitle.trim())
      setNewTitle('')
      await refresh()
      navigate(`/admin/concepts/${concept.id}`)
    } finally {
      setCreating(false)
    }
  }

  async function handleDelete(concept: Concept) {
    if (!confirm(`¿Eliminar el concepto "${concept.title}"? Se eliminan también sus relaciones, recursos y enlaces a lecciones.`))
      return
    await adminDeleteConcept(concept.id)
    await refresh()
  }

  return (
    <div>
      <Link to="/admin" className="text-xs text-ink-soft hover:text-brass">
        ← Volver a Administración
      </Link>
      <div className="mb-4 mt-2 flex items-center justify-between">
        <div>
          <h1 className="font-display text-2xl font-semibold text-ink">Biblioteca de Conceptos</h1>
          <p className="text-sm text-ink-soft">
            Tu segunda memoria — cada concepto se explica una sola vez acá, y se enlaza desde
            lecciones y proyectos en vez de reexplicarlo.
          </p>
        </div>
      </div>

      <div className="card mb-4 flex gap-2">
        <input
          className="input-field"
          placeholder="Nombre del nuevo concepto (ej. Row Level Security)"
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
        />
        <button onClick={handleCreate} disabled={creating} className="btn-primary text-xs">
          {creating ? 'Creando…' : 'Crear concepto'}
        </button>
      </div>

      {loading ? (
        <p className="text-sm text-ink-soft">Cargando…</p>
      ) : concepts.length === 0 ? (
        <div className="card">
          <p className="text-sm text-ink-soft">Todavía no hay conceptos creados.</p>
        </div>
      ) : (
        <div className="flex flex-col gap-2">
          {concepts.map((concept) => (
            <div
              key={concept.id}
              className="card flex items-center justify-between gap-3"
            >
              <Link to={`/admin/concepts/${concept.id}`} className="flex-1 text-sm text-ink hover:text-brass">
                {concept.title}
              </Link>
              <span
                className={`text-xs ${concept.is_published ? 'text-sage' : 'text-ink-soft'}`}
              >
                {concept.is_published ? 'Publicado' : 'Borrador'}
              </span>
              <button
                onClick={() => handleDelete(concept)}
                className="text-xs text-ink-soft hover:text-rust"
              >
                Eliminar
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
