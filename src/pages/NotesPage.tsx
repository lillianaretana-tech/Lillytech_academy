import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '@/features/auth/hooks/useAuth'
import { listMyNotes, updateNote, deleteNote } from '@/services/notes.service'
import type { PersonalNote } from '@/types/database.types'

export function NotesPage() {
  const { user } = useAuth()
  const [notes, setNotes] = useState<PersonalNote[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')

  useEffect(() => {
    async function load() {
      if (!user) return
      setLoading(true)
      setNotes(await listMyNotes(user.id))
      setLoading(false)
    }
    load()
  }, [user?.id])

  const filtered = useMemo(() => {
    if (!search.trim()) return notes
    const q = search.toLowerCase()
    return notes.filter((n) => n.content.toLowerCase().includes(q))
  }, [notes, search])

  async function toggleImportant(note: PersonalNote) {
    await updateNote(note.id, { is_important: !note.is_important })
    setNotes((prev) =>
      prev.map((n) => (n.id === note.id ? { ...n, is_important: !n.is_important } : n)),
    )
  }

  async function handleDelete(id: string) {
    await deleteNote(id)
    setNotes((prev) => prev.filter((n) => n.id !== id))
  }

  return (
    <div>
      <h1 className="mb-1 font-display text-2xl font-semibold text-ink">Notas</h1>
      <p className="mb-4 text-sm text-ink-soft">Todas tus notas personales, por lección.</p>

      <input
        className="input-field mb-4 max-w-sm"
        placeholder="Buscar en tus notas…"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />

      {loading ? (
        <p className="text-sm text-ink-soft">Cargando notas…</p>
      ) : filtered.length === 0 ? (
        <div className="card">
          <p className="text-sm text-ink-soft">
            {notes.length === 0
              ? 'Todavía no tenés notas. Se crean desde cualquier lección.'
              : 'Ninguna nota coincide con esa búsqueda.'}
          </p>
        </div>
      ) : (
        <div className="flex flex-col gap-3">
          {filtered
            .slice()
            .sort((a, b) => Number(b.is_important) - Number(a.is_important))
            .map((note) => (
              <div key={note.id} className="card flex items-start justify-between gap-4">
                <div>
                  <p className="text-sm text-ink">{note.content}</p>
                  <div className="mt-2 flex items-center gap-3 text-xs text-ink-soft">
                    <Link to={`/lesson/${note.lesson_id}`} className="hover:text-brass">
                      Ver lección
                    </Link>
                    <span>
                      {new Date(note.updated_at).toLocaleDateString('es-CR', {
                        day: '2-digit',
                        month: 'short',
                      })}
                    </span>
                  </div>
                </div>
                <div className="flex flex-shrink-0 flex-col items-end gap-2">
                  <button
                    onClick={() => toggleImportant(note)}
                    className={`text-xs ${note.is_important ? 'text-brass' : 'text-ink-soft'} hover:text-brass`}
                  >
                    {note.is_important ? '★ Importante' : '☆ Marcar importante'}
                  </button>
                  <button
                    onClick={() => handleDelete(note.id)}
                    className="text-xs text-ink-soft hover:text-rust"
                  >
                    Eliminar
                  </button>
                </div>
              </div>
            ))}
        </div>
      )}
    </div>
  )
}
