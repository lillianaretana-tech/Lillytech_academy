import { useEffect, useState } from 'react'
import { useAuth } from '@/features/auth/hooks/useAuth'
import { supabase } from '@/lib/supabaseClient'
import type { LearningActivity } from '@/types/database.types'

const eventLabels: Record<string, string> = {
  lesson_started: 'Iniciaste una lección',
  lesson_completed: 'Completaste una lección',
  note_created: 'Creaste una nota',
  question_created: 'Registraste una duda',
  project_updated: 'Actualizaste un proyecto',
  concept_mastery_updated: 'Actualizaste tu nivel de dominio de un concepto',
}

const eventFilters = [
  { value: 'all', label: 'Todo' },
  { value: 'lesson_started', label: 'Lecciones iniciadas' },
  { value: 'lesson_completed', label: 'Lecciones completadas' },
]

export function BitacoraPage() {
  const { user } = useAuth()
  const [events, setEvents] = useState<LearningActivity[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('all')

  useEffect(() => {
    async function load() {
      if (!user) return
      setLoading(true)
      const { data } = await supabase
        .from('learning_activity')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false })
        .limit(200)
      setEvents((data ?? []) as LearningActivity[])
      setLoading(false)
    }
    load()
  }, [user?.id])

  const filtered = filter === 'all' ? events : events.filter((e) => e.event_type === filter)

  // Agrupa por día para que se lea como diario, no como log plano.
  const groupedByDay = filtered.reduce<Record<string, LearningActivity[]>>((acc, event) => {
    const day = new Date(event.created_at).toLocaleDateString('es-CR', {
      weekday: 'long',
      day: '2-digit',
      month: 'long',
    })
    acc[day] = acc[day] ?? []
    acc[day].push(event)
    return acc
  }, {})

  return (
    <div>
      <h1 className="mb-1 font-display text-2xl font-semibold text-ink">Bitácora</h1>
      <p className="mb-4 text-sm text-ink-soft">
        Tu diario de aprendizaje — cómo fuiste avanzando, día por día.
      </p>

      <div className="mb-4 flex gap-2">
        {eventFilters.map((f) => (
          <button
            key={f.value}
            onClick={() => setFilter(f.value)}
            className={`rounded-full px-3 py-1 text-xs ${
              filter === f.value ? 'bg-brass text-paper' : 'bg-paper-muted text-ink-soft'
            }`}
          >
            {f.label}
          </button>
        ))}
      </div>

      {loading ? (
        <p className="text-sm text-ink-soft">Cargando bitácora…</p>
      ) : Object.keys(groupedByDay).length === 0 ? (
        <div className="card">
          <p className="text-sm text-ink-soft">Todavía no hay actividad registrada.</p>
        </div>
      ) : (
        <div className="flex flex-col gap-6">
          {Object.entries(groupedByDay).map(([day, dayEvents]) => (
            <div key={day}>
              <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-brass-dark">
                {day}
              </p>
              <div className="flex flex-col gap-1 border-l-2 border-ink/10 pl-4">
                {dayEvents.map((event) => (
                  <div key={event.id} className="text-sm text-ink">
                    <span className="text-ink-soft">
                      {new Date(event.created_at).toLocaleTimeString('es-CR', {
                        hour: '2-digit',
                        minute: '2-digit',
                      })}
                    </span>{' '}
                    — {eventLabels[event.event_type] ?? event.event_type}
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
