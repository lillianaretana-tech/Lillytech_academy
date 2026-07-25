import { useEffect, useState, type FormEvent } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { supabase } from '@/lib/supabaseClient'
import {
  adminUpdateLesson,
  adminListLessonResources,
  adminAddLessonResource,
  adminDeleteLessonResource,
} from '@/services/admin.service'
import type { Lesson, LessonResource } from '@/types/database.types'

const textFields: { key: keyof Lesson; label: string; rows: number }[] = [
  { key: 'summary', label: 'Resumen', rows: 2 },
  { key: 'objectives', label: 'Objetivos (una línea por objetivo)', rows: 4 },
  { key: 'content', label: 'Explicación', rows: 8 },
  { key: 'example', label: 'Ejemplo', rows: 4 },
  { key: 'practical_application', label: 'Aplicación práctica', rows: 4 },
  { key: 'common_mistakes', label: 'Errores comunes', rows: 4 },
  { key: 'checklist', label: 'Lista de comprobación', rows: 4 },
]

export function AdminLessonEditPage() {
  const { lessonId } = useParams<{ lessonId: string }>()
  const navigate = useNavigate()
  const [lesson, setLesson] = useState<Lesson | null>(null)
  const [resources, setResources] = useState<LessonResource[]>([])
  const [newResourceTitle, setNewResourceTitle] = useState('')
  const [newResourceUrl, setNewResourceUrl] = useState('')
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [saved, setSaved] = useState(false)

  useEffect(() => {
    async function load() {
      if (!lessonId) return
      setLoading(true)
      const { data } = await supabase.from('lessons').select('*').eq('id', lessonId).maybeSingle()
      setLesson(data as Lesson | null)
      setResources(await adminListLessonResources(lessonId))
      setLoading(false)
    }
    load()
  }, [lessonId])

  async function handleAddResource() {
    if (!lessonId || !newResourceTitle.trim() || !newResourceUrl.trim()) return
    const resource = await adminAddLessonResource(
      lessonId,
      newResourceTitle.trim(),
      newResourceUrl.trim(),
      resources.length,
    )
    setResources((prev) => [...prev, resource])
    setNewResourceTitle('')
    setNewResourceUrl('')
  }

  async function handleDeleteResource(id: string) {
    await adminDeleteLessonResource(id)
    setResources((prev) => prev.filter((r) => r.id !== id))
  }

  function updateField<K extends keyof Lesson>(key: K, value: Lesson[K]) {
    if (!lesson) return
    setLesson({ ...lesson, [key]: value })
    setSaved(false)
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    if (!lesson) return
    setSaving(true)
    try {
      await adminUpdateLesson(lesson.id, {
        title: lesson.title,
        summary: lesson.summary,
        objectives: lesson.objectives,
        content: lesson.content,
        example: lesson.example,
        practical_application: lesson.practical_application,
        common_mistakes: lesson.common_mistakes,
        checklist: lesson.checklist,
        estimated_minutes: lesson.estimated_minutes,
        level: lesson.level,
        prerequisites: lesson.prerequisites,
        is_published: lesson.is_published,
      })
      setSaved(true)
    } finally {
      setSaving(false)
    }
  }

  if (loading) return <p className="text-sm text-ink-soft">Cargando lección…</p>

  if (!lesson) {
    return (
      <div className="card">
        <p className="text-sm text-ink-soft">No se encontró esta lección.</p>
        <Link to="/admin" className="btn-secondary mt-3 inline-flex text-xs">
          Volver a Administración
        </Link>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-3xl pb-16">
      <Link to="/admin" className="text-xs text-ink-soft hover:text-brass">
        ← Volver a Administración
      </Link>

      <form onSubmit={handleSubmit} className="mt-2 flex flex-col gap-4">
        <div>
          <label className="mb-1 block text-xs font-medium text-ink-soft">Título</label>
          <input
            className="input-field font-display text-lg"
            value={lesson.title}
            onChange={(e) => updateField('title', e.target.value)}
            required
          />
        </div>

        <div className="grid grid-cols-1 gap-3 md:grid-cols-3">
          <div>
            <label className="mb-1 block text-xs font-medium text-ink-soft">Nivel</label>
            <input
              className="input-field"
              value={lesson.level ?? ''}
              onChange={(e) => updateField('level', e.target.value)}
            />
          </div>
          <div>
            <label className="mb-1 block text-xs font-medium text-ink-soft">
              Duración estimada (min)
            </label>
            <input
              type="number"
              className="input-field"
              value={lesson.estimated_minutes ?? ''}
              onChange={(e) => updateField('estimated_minutes', Number(e.target.value) || null)}
            />
          </div>
          <div>
            <label className="mb-1 block text-xs font-medium text-ink-soft">Prerrequisitos</label>
            <input
              className="input-field"
              value={lesson.prerequisites ?? ''}
              onChange={(e) => updateField('prerequisites', e.target.value)}
            />
          </div>
        </div>

        {textFields.map((field) => (
          <div key={field.key}>
            <label className="mb-1 block text-xs font-medium text-ink-soft">{field.label}</label>
            <textarea
              className="input-field"
              rows={field.rows}
              value={(lesson[field.key] as string) ?? ''}
              onChange={(e) => updateField(field.key, e.target.value as never)}
            />
          </div>
        ))}

        <div>
          <label className="mb-2 block text-xs font-medium text-ink-soft">
            Recursos relacionados
          </label>
          <div className="flex flex-col gap-2">
            {resources.map((resource) => (
              <div
                key={resource.id}
                className="flex items-center justify-between rounded-md bg-paper-muted px-3 py-2"
              >
                <a
                  href={resource.url}
                  target="_blank"
                  rel="noreferrer"
                  className="text-sm text-brass hover:underline"
                >
                  {resource.title}
                </a>
                <button
                  type="button"
                  onClick={() => handleDeleteResource(resource.id)}
                  className="text-xs text-ink-soft hover:text-rust"
                >
                  Eliminar
                </button>
              </div>
            ))}
            <div className="flex gap-2">
              <input
                className="input-field"
                placeholder="Título del recurso"
                value={newResourceTitle}
                onChange={(e) => setNewResourceTitle(e.target.value)}
              />
              <input
                className="input-field"
                placeholder="URL"
                value={newResourceUrl}
                onChange={(e) => setNewResourceUrl(e.target.value)}
              />
              <button type="button" onClick={handleAddResource} className="btn-secondary text-xs">
                Agregar
              </button>
            </div>
          </div>
        </div>

        <label className="flex items-center gap-2 text-sm text-ink">
          <input
            type="checkbox"
            checked={lesson.is_published}
            onChange={(e) => updateField('is_published', e.target.checked)}
          />
          Publicada (visible para estudiantes)
        </label>

        <div className="flex items-center gap-3">
          <button type="submit" disabled={saving} className="btn-primary">
            {saving ? 'Guardando…' : 'Guardar cambios'}
          </button>
          {saved && <span className="text-xs text-sage">Guardado.</span>}
          <button type="button" onClick={() => navigate('/admin')} className="btn-secondary">
            Volver
          </button>
        </div>
      </form>
    </div>
  )
}
