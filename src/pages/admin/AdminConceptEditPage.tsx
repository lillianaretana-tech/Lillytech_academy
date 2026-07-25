import { useEffect, useState, type FormEvent } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import {
  adminGetConcept,
  adminUpdateConcept,
  adminListConcepts,
  adminListAllConceptRelations,
  adminAddConceptRelation,
  adminDeleteConceptRelation,
  adminListConceptResources,
  adminAddConceptResource,
  adminDeleteConceptResource,
  adminListConceptLessons,
  adminListAllLessonsFlat,
  adminLinkConceptLesson,
  adminUnlinkConceptLesson,
} from '@/services/admin.service'
import type { Concept, ConceptResource, ConceptRelation, Lesson } from '@/types/database.types'

const textFields: { key: keyof Concept; label: string; rows: number }[] = [
  { key: 'what_is', label: 'Qué es', rows: 4 },
  { key: 'why_it_exists', label: 'Por qué existe', rows: 4 },
  { key: 'problem_it_solves', label: 'Qué problema resuelve', rows: 4 },
  { key: 'when_to_use', label: 'Cuándo utilizarlo', rows: 3 },
  { key: 'common_mistakes', label: 'Errores comunes', rows: 4 },
]

export function AdminConceptEditPage() {
  const { conceptId } = useParams<{ conceptId: string }>()
  const navigate = useNavigate()
  const [concept, setConcept] = useState<Concept | null>(null)
  const [allConcepts, setAllConcepts] = useState<Concept[]>([])
  const [relations, setRelations] = useState<(ConceptRelation & { toTitle?: string; fromTitle?: string })[]>([])
  const [resources, setResources] = useState<ConceptResource[]>([])
  const [linkedLessons, setLinkedLessons] = useState<Lesson[]>([])
  const [allLessons, setAllLessons] = useState<(Lesson & { pathTitle: string })[]>([])
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [saved, setSaved] = useState(false)

  const [relatedConceptId, setRelatedConceptId] = useState('')
  const [relationType, setRelationType] = useState('se relaciona con')
  const [resourceTitle, setResourceTitle] = useState('')
  const [resourceUrl, setResourceUrl] = useState('')
  const [lessonToLink, setLessonToLink] = useState('')

  async function loadAll() {
    if (!conceptId) return
    setLoading(true)
    const [c, all, rel, res, linked, lessons] = await Promise.all([
      adminGetConcept(conceptId),
      adminListConcepts(),
      adminListAllConceptRelations(conceptId),
      adminListConceptResources(conceptId),
      adminListConceptLessons(conceptId),
      adminListAllLessonsFlat(),
    ])
    setConcept(c)
    setAllConcepts(all.filter((x) => x.id !== conceptId))
    setRelations(rel)
    setResources(res)
    setLinkedLessons(linked)
    setAllLessons(lessons)
    setLoading(false)
  }

  useEffect(() => {
    loadAll()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [conceptId])

  function updateField<K extends keyof Concept>(key: K, value: Concept[K]) {
    if (!concept) return
    setConcept({ ...concept, [key]: value })
    setSaved(false)
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    if (!concept) return
    setSaving(true)
    try {
      await adminUpdateConcept(concept.id, {
        title: concept.title,
        what_is: concept.what_is,
        why_it_exists: concept.why_it_exists,
        problem_it_solves: concept.problem_it_solves,
        when_to_use: concept.when_to_use,
        common_mistakes: concept.common_mistakes,
        is_published: concept.is_published,
      })
      setSaved(true)
    } finally {
      setSaving(false)
    }
  }

  async function handleAddRelation() {
    if (!conceptId || !relatedConceptId) return
    await adminAddConceptRelation(conceptId, relatedConceptId, relationType)
    await loadAll()
  }

  async function handleDeleteRelation(id: string) {
    await adminDeleteConceptRelation(id)
    setRelations((prev) => prev.filter((r) => r.id !== id))
  }

  async function handleAddResource() {
    if (!conceptId || !resourceTitle.trim() || !resourceUrl.trim()) return
    const resource = await adminAddConceptResource(
      conceptId,
      resourceTitle.trim(),
      resourceUrl.trim(),
      resources.length,
    )
    setResources((prev) => [...prev, resource])
    setResourceTitle('')
    setResourceUrl('')
  }

  async function handleDeleteResource(id: string) {
    await adminDeleteConceptResource(id)
    setResources((prev) => prev.filter((r) => r.id !== id))
  }

  async function handleLinkLesson() {
    if (!conceptId || !lessonToLink) return
    await adminLinkConceptLesson(conceptId, lessonToLink)
    await loadAll()
    setLessonToLink('')
  }

  async function handleUnlinkLesson(lessonId: string) {
    if (!conceptId) return
    await adminUnlinkConceptLesson(conceptId, lessonId)
    setLinkedLessons((prev) => prev.filter((l) => l.id !== lessonId))
  }

  if (loading) return <p className="text-sm text-ink-soft">Cargando concepto…</p>

  if (!concept) {
    return (
      <div className="card">
        <p className="text-sm text-ink-soft">No se encontró este concepto.</p>
        <Link to="/admin/concepts" className="btn-secondary mt-3 inline-flex text-xs">
          Volver a Conceptos
        </Link>
      </div>
    )
  }

  const linkedLessonIds = new Set(linkedLessons.map((l) => l.id))
  const availableLessons = allLessons.filter((l) => !linkedLessonIds.has(l.id))

  return (
    <div className="mx-auto max-w-3xl pb-16">
      <Link to="/admin/concepts" className="text-xs text-ink-soft hover:text-brass">
        ← Volver a Conceptos
      </Link>

      <form onSubmit={handleSubmit} className="mt-2 flex flex-col gap-4">
        <div>
          <label className="mb-1 block text-xs font-medium text-ink-soft">Título</label>
          <input
            className="input-field font-display text-lg"
            value={concept.title}
            onChange={(e) => updateField('title', e.target.value)}
            required
          />
          <p className="mt-1 text-xs text-ink-soft">slug: {concept.slug}</p>
        </div>

        {textFields.map((field) => (
          <div key={field.key}>
            <label className="mb-1 block text-xs font-medium text-ink-soft">{field.label}</label>
            <textarea
              className="input-field"
              rows={field.rows}
              value={(concept[field.key] as string) ?? ''}
              onChange={(e) => updateField(field.key, e.target.value as never)}
            />
          </div>
        ))}

        <label className="flex items-center gap-2 text-sm text-ink">
          <input
            type="checkbox"
            checked={concept.is_published}
            onChange={(e) => updateField('is_published', e.target.checked)}
          />
          Publicado (visible para estudiantes)
        </label>

        <div className="flex items-center gap-3">
          <button type="submit" disabled={saving} className="btn-primary">
            {saving ? 'Guardando…' : 'Guardar cambios'}
          </button>
          {saved && <span className="text-xs text-sage">Guardado.</span>}
          <button type="button" onClick={() => navigate('/admin/concepts')} className="btn-secondary">
            Volver
          </button>
        </div>
      </form>

      <div className="mt-8 flex flex-col gap-6">
        <div className="card">
          <p className="mb-2 text-sm font-semibold text-ink">Relaciones con otros conceptos</p>
          <div className="flex flex-col gap-1">
            {relations.map((rel) => (
              <div key={rel.id} className="flex items-center justify-between text-xs text-ink-soft">
                <span>
                  {rel.toTitle
                    ? `${rel.relation_type ?? 'se relaciona con'} → ${rel.toTitle}`
                    : `${rel.fromTitle} ${rel.relation_type ?? 'se relaciona con'} → este`}
                </span>
                <button onClick={() => handleDeleteRelation(rel.id)} className="hover:text-rust">
                  Eliminar
                </button>
              </div>
            ))}
          </div>
          <div className="mt-3 flex flex-col gap-2 sm:flex-row">
            <select
              className="input-field text-xs"
              value={relatedConceptId}
              onChange={(e) => setRelatedConceptId(e.target.value)}
            >
              <option value="">Elegí un concepto…</option>
              {allConcepts.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.title}
                </option>
              ))}
            </select>
            <input
              className="input-field text-xs"
              placeholder="Tipo de relación (ej. depende de)"
              value={relationType}
              onChange={(e) => setRelationType(e.target.value)}
            />
            <button onClick={handleAddRelation} className="btn-secondary text-xs">
              Enlazar
            </button>
          </div>
        </div>

        <div className="card">
          <p className="mb-2 text-sm font-semibold text-ink">Lecciones relacionadas</p>
          <div className="flex flex-col gap-1">
            {linkedLessons.map((lesson) => (
              <div key={lesson.id} className="flex items-center justify-between text-xs">
                <span className="text-ink-soft">{lesson.title}</span>
                <button onClick={() => handleUnlinkLesson(lesson.id)} className="text-ink-soft hover:text-rust">
                  Desenlazar
                </button>
              </div>
            ))}
          </div>
          <div className="mt-3 flex gap-2">
            <select
              className="input-field text-xs"
              value={lessonToLink}
              onChange={(e) => setLessonToLink(e.target.value)}
            >
              <option value="">Elegí una lección…</option>
              {availableLessons.map((l) => (
                <option key={l.id} value={l.id}>
                  {l.pathTitle ? `${l.pathTitle} — ${l.title}` : l.title}
                </option>
              ))}
            </select>
            <button onClick={handleLinkLesson} className="btn-secondary text-xs">
              Enlazar
            </button>
          </div>
        </div>

        <div className="card">
          <p className="mb-2 text-sm font-semibold text-ink">Recursos</p>
          <div className="flex flex-col gap-2">
            {resources.map((resource) => (
              <div
                key={resource.id}
                className="flex items-center justify-between rounded-md bg-paper-muted px-3 py-2"
              >
                <a href={resource.url} target="_blank" rel="noreferrer" className="text-sm text-brass hover:underline">
                  {resource.title}
                </a>
                <button onClick={() => handleDeleteResource(resource.id)} className="text-xs text-ink-soft hover:text-rust">
                  Eliminar
                </button>
              </div>
            ))}
            <div className="flex gap-2">
              <input
                className="input-field"
                placeholder="Título del recurso"
                value={resourceTitle}
                onChange={(e) => setResourceTitle(e.target.value)}
              />
              <input
                className="input-field"
                placeholder="URL"
                value={resourceUrl}
                onChange={(e) => setResourceUrl(e.target.value)}
              />
              <button onClick={handleAddResource} className="btn-secondary text-xs">
                Agregar
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
