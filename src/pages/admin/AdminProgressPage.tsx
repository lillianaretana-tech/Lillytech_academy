import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { adminListStudentProgress, type StudentProgressSummary } from '@/services/admin.service'

export function AdminProgressPage() {
  const [rows, setRows] = useState<StudentProgressSummary[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    adminListStudentProgress()
      .then(setRows)
      .finally(() => setLoading(false))
  }, [])

  return (
    <div>
      <Link to="/admin" className="text-xs text-ink-soft hover:text-brass">
        ← Volver a Administración
      </Link>
      <h1 className="mb-1 mt-2 font-display text-2xl font-semibold text-ink">
        Progreso de estudiantes
      </h1>
      <p className="mb-6 text-sm text-ink-soft">
        Lecciones completadas y en progreso, por persona registrada.
      </p>

      {loading ? (
        <p className="text-sm text-ink-soft">Cargando…</p>
      ) : rows.length === 0 ? (
        <div className="card">
          <p className="text-sm text-ink-soft">Todavía no hay estudiantes registradas.</p>
        </div>
      ) : (
        <div className="card overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead>
              <tr className="border-b border-ink/10 text-xs uppercase tracking-wide text-ink-soft">
                <th className="pb-2">Estudiante</th>
                <th className="pb-2">Completadas</th>
                <th className="pb-2">En progreso</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => (
                <tr key={row.userId} className="border-b border-ink/5 last:border-0">
                  <td className="py-2 text-ink">{row.fullName ?? 'Sin nombre'}</td>
                  <td className="py-2 text-ink-soft">{row.completedLessons}</td>
                  <td className="py-2 text-ink-soft">{row.inProgressLessons}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
