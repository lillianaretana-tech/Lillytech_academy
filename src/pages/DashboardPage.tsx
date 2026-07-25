import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '@/features/auth/hooks/useAuth'
import { loadDashboard, type DashboardData } from '@/services/dashboard.service'
import { enrollInPath } from '@/services/progress.service'

const eventLabels: Record<string, string> = {
  lesson_started: 'Iniciaste una lección',
  lesson_completed: 'Completaste una lección',
  note_created: 'Creaste una nota',
  project_updated: 'Actualizaste un proyecto',
}

export function DashboardPage() {
  const { user } = useAuth()
  const [data, setData] = useState<DashboardData | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [enrolling, setEnrolling] = useState(false)

  async function refresh() {
    if (!user) return
    setLoading(true)
    setError(null)
    try {
      setData(await loadDashboard(user.id))
    } catch (e) {
      setError(e instanceof Error ? e.message : 'No se pudo cargar el dashboard.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    refresh()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user?.id])

  async function handleEnroll() {
    if (!user || !data?.activePathId) return
    setEnrolling(true)
    try {
      await enrollInPath(user.id, data.activePathId)
      await refresh()
    } finally {
      setEnrolling(false)
    }
  }

  if (loading) {
    return <p className="text-sm text-ink-soft">Cargando tu progreso…</p>
  }

  if (error) {
    return (
      <div className="card">
        <p className="text-sm text-rust">{error}</p>
      </div>
    )
  }

  if (!data || !data.activePathTitle) {
    return (
      <div>
        <h1 className="mb-1 font-display text-2xl font-semibold text-ink">Dashboard</h1>
        <div className="card mt-4">
          <p className="text-sm text-ink-soft">
            Todavía no hay ninguna ruta publicada. Si ya corriste el seed inicial, revisá que
            la ruta "Desarrollo de Aplicaciones LillyTech" tenga <code>is_published = true</code>.
          </p>
        </div>
      </div>
    )
  }

  return (
    <div>
      <h1 className="mb-1 font-display text-2xl font-semibold text-ink">Dashboard</h1>
      <p className="mb-6 text-sm text-ink-soft">Tu avance en {data.activePathTitle}.</p>

      <div className="grid grid-cols-1 gap-4 md:grid-cols-4">
        <div className="card">
          <p className="text-xs uppercase tracking-wide text-ink-soft">Avance general</p>
          <p className="mt-1 font-display text-3xl font-semibold text-brass-dark">
            {data.percentComplete}%
          </p>
          <div className="mt-3 h-2 w-full overflow-hidden rounded-full bg-paper-muted">
            <div
              className="h-full rounded-full bg-brass transition-all"
              style={{ width: `${data.percentComplete}%` }}
            />
          </div>
        </div>

        <div className="card">
          <p className="text-xs uppercase tracking-wide text-ink-soft">Lecciones completadas</p>
          <p className="mt-1 font-display text-3xl font-semibold text-ink">
            {data.completedLessons}
            <span className="text-base font-normal text-ink-soft"> / {data.totalLessons}</span>
          </p>
        </div>

        <div className="card">
          <p className="text-xs uppercase tracking-wide text-ink-soft">En progreso</p>
          <p className="mt-1 font-display text-3xl font-semibold text-ink">
            {data.inProgressLessons}
          </p>
        </div>

        <div className="card">
          <p className="text-xs uppercase tracking-wide text-ink-soft">Tiempo estudiado</p>
          <p className="mt-1 font-display text-3xl font-semibold text-ink">
            {formatStudiedTime(data.studiedMinutes)}
          </p>
        </div>
      </div>

      <div className="mt-6 grid grid-cols-1 gap-4 md:grid-cols-2">
        <div className="card">
          <p className="mb-2 text-sm font-semibold text-ink">Próxima lección recomendada</p>
          {data.nextLesson ? (
            <>
              <p className="text-sm text-ink">{data.nextLesson.title}</p>
              {data.nextLesson.summary && (
                <p className="mt-1 text-xs text-ink-soft">{data.nextLesson.summary}</p>
              )}
              <Link to={`/lesson/${data.nextLesson.id}`} className="btn-primary mt-3 text-xs">
                Continuar
              </Link>
            </>
          ) : (
            <p className="text-sm text-ink-soft">
              ¡Completaste todas las lecciones publicadas de esta ruta!
            </p>
          )}
          {!data.recentActivity.length && (
            <button
              onClick={handleEnroll}
              disabled={enrolling}
              className="btn-secondary mt-3 text-xs"
            >
              {enrolling ? 'Inscribiendo…' : 'Inscribirme formalmente en esta ruta'}
            </button>
          )}
        </div>

        <div className="card">
          <p className="mb-2 text-sm font-semibold text-ink">Actividad reciente</p>
          {data.recentActivity.length === 0 ? (
            <p className="text-sm text-ink-soft">
              Todavía no hay actividad registrada — arrancá una lección para verla acá.
            </p>
          ) : (
            <ul className="flex flex-col gap-2">
              {data.recentActivity.map((event) => (
                <li key={event.id} className="text-xs text-ink-soft">
                  {eventLabels[event.event_type] ?? event.event_type} —{' '}
                  {new Date(event.created_at).toLocaleDateString('es-CR', {
                    day: '2-digit',
                    month: 'short',
                    hour: '2-digit',
                    minute: '2-digit',
                  })}
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>
    </div>
  )
}

function formatStudiedTime(minutes: number): string {
  if (minutes < 60) return `${minutes} min`
  const hours = Math.floor(minutes / 60)
  const rest = minutes % 60
  return rest === 0 ? `${hours} h` : `${hours} h ${rest} min`
}
