import { useEffect, useState, type FormEvent } from 'react'
import { useAuth } from '@/features/auth/hooks/useAuth'
import {
  listMyProjects,
  createProject,
  updateProject,
  deleteProject,
} from '@/services/projects.service'
import type { PracticalProject, ProjectStatus } from '@/types/database.types'

const statusLabels: Record<ProjectStatus, string> = {
  planned: 'Planificado',
  in_progress: 'En progreso',
  completed: 'Completado',
  on_hold: 'En pausa',
}

export function ProjectsPage() {
  const { user } = useAuth()
  const [projects, setProjects] = useState<PracticalProject[]>([])
  const [loading, setLoading] = useState(true)
  const [showForm, setShowForm] = useState(false)
  const [saving, setSaving] = useState(false)

  const [name, setName] = useState('')
  const [description, setDescription] = useState('')
  const [repoUrl, setRepoUrl] = useState('')
  const [appUrl, setAppUrl] = useState('')

  async function refresh() {
    if (!user) return
    setLoading(true)
    setProjects(await listMyProjects(user.id))
    setLoading(false)
  }

  useEffect(() => {
    refresh()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user?.id])

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    if (!user || !name.trim()) return
    setSaving(true)
    try {
      await createProject(user.id, {
        name: name.trim(),
        description: description.trim() || undefined,
        status: 'planned',
        repo_url: repoUrl.trim() || undefined,
        app_url: appUrl.trim() || undefined,
      })
      setName('')
      setDescription('')
      setRepoUrl('')
      setAppUrl('')
      setShowForm(false)
      await refresh()
    } finally {
      setSaving(false)
    }
  }

  async function handleStatusChange(project: PracticalProject, status: ProjectStatus) {
    await updateProject(project.id, { status })
    setProjects((prev) => prev.map((p) => (p.id === project.id ? { ...p, status } : p)))
  }

  async function handleDelete(id: string) {
    await deleteProject(id)
    setProjects((prev) => prev.filter((p) => p.id !== id))
  }

  return (
    <div>
      <div className="mb-4 flex items-center justify-between">
        <div>
          <h1 className="font-display text-2xl font-semibold text-ink">Proyectos prácticos</h1>
          <p className="text-sm text-ink-soft">Dónde aplicaste lo aprendido.</p>
        </div>
        <button onClick={() => setShowForm((v) => !v)} className="btn-primary text-xs">
          {showForm ? 'Cancelar' : 'Nuevo proyecto'}
        </button>
      </div>

      {showForm && (
        <form onSubmit={handleSubmit} className="card mb-6 flex flex-col gap-3">
          <input
            className="input-field"
            placeholder="Nombre del proyecto (ej. OnboardFlow)"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
          <textarea
            className="input-field"
            rows={2}
            placeholder="Descripción breve"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
          />
          <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
            <input
              className="input-field"
              placeholder="Enlace al repositorio (opcional)"
              value={repoUrl}
              onChange={(e) => setRepoUrl(e.target.value)}
            />
            <input
              className="input-field"
              placeholder="Enlace a la aplicación (opcional)"
              value={appUrl}
              onChange={(e) => setAppUrl(e.target.value)}
            />
          </div>
          <button type="submit" disabled={saving} className="btn-primary self-start text-xs">
            {saving ? 'Guardando…' : 'Registrar proyecto'}
          </button>
        </form>
      )}

      {loading ? (
        <p className="text-sm text-ink-soft">Cargando proyectos…</p>
      ) : projects.length === 0 ? (
        <div className="card">
          <p className="text-sm text-ink-soft">
            Todavía no registraste ningún proyecto práctico.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
          {projects.map((project) => (
            <div key={project.id} className="card">
              <div className="mb-2 flex items-start justify-between">
                <p className="text-sm font-semibold text-ink">{project.name}</p>
                <button
                  onClick={() => handleDelete(project.id)}
                  className="text-xs text-ink-soft hover:text-rust"
                >
                  Eliminar
                </button>
              </div>
              {project.description && (
                <p className="mb-3 text-xs text-ink-soft">{project.description}</p>
              )}
              <div className="mb-3 flex flex-wrap gap-3 text-xs">
                {project.repo_url && (
                  <a href={project.repo_url} target="_blank" rel="noreferrer" className="text-brass hover:underline">
                    Repositorio
                  </a>
                )}
                {project.app_url && (
                  <a href={project.app_url} target="_blank" rel="noreferrer" className="text-brass hover:underline">
                    Aplicación
                  </a>
                )}
              </div>
              <select
                className="input-field text-xs"
                value={project.status}
                onChange={(e) => handleStatusChange(project, e.target.value as ProjectStatus)}
              >
                {Object.entries(statusLabels).map(([value, label]) => (
                  <option key={value} value={value}>
                    {label}
                  </option>
                ))}
              </select>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
