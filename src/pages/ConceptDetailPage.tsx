import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { useAuth } from '@/features/auth/hooks/useAuth'
import {
  getConcept,
  getConceptRelations,
  getConceptLessons,
  getConceptProjects,
  getConceptResources,
  listConceptNotes,
  createConceptNote,
  deleteConceptNote,
  getConceptMastery,
  setConceptMastery,
  type ConceptWithRelations,
} from '@/services/concepts.service'
import type {
  Concept,
  Lesson,
  PracticalProject,
  ConceptResource,
  ConceptNote,
  MasteryLevel,
} from '@/types/database.types'

export function ConceptDetailPage() {
  const { conceptId } = useParams<{ conceptId: string }>()
  const { user } = useAuth()

  const [concept, setConcept] = useState<Concept | null>(null)
  const [relations, setRelations] = useState<ConceptWithRelations | null>(null)
  const [lessons, setLessons] = useState<Lesson[]>([])
  const [projects, setProjects] = useState<PracticalProject[]>([])
  const [resources, setResources] = useState<ConceptResource[]>([])
  const [notes, setNotes] = useState<ConceptNote[]>([])
  const [mastery, setMastery] = useState<MasteryLevel>('unknown')
  const [savingMastery, setSavingMastery] = useState(false)
  const [newNote, setNewNote] = useState('')
  const [savingNote, setSavingNote] = useState(false)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function load() {
      if (!conceptId || !user) return
      setLoading(true)
      const [conceptData, relationsData, lessonsData, projectsData, resourcesData, notesData, masteryData] =
        await Promise.all([
          getConcept(conceptId),
          getConceptRelations(conceptId),
          getConceptLessons(conceptId),
          getConceptProjects(conceptId, user.id),
          getConceptResources(conceptId),
          listConceptNotes(user.id, conceptId),
          getConceptMastery(user.id, conceptId),
        ])
      setConcept(conceptData)
      setRelations(relationsData)
      setLessons(lessonsData)
      setProjects(projectsData)
      setResources(resourcesData)
      setNotes(notesData)
      setMastery(masteryData?.level ?? 'unknown')
      setLoading(false)
    }
    load()
  }, [conceptId, user?.id])

  async function handleAddNote() {
    if (!user || !conceptId || !newNote.trim()) return
    setSavingNote(true)
    try {
      const note = await createConceptNote(user.id, conceptId, newNote.trim())
      setNotes((prev) => [note, ...prev])
      setNewNote('')
    } finally {
      setSavingNote(false)
    }
  }

  async function handleDeleteNote(id: string) {
    await deleteConceptNote(id)
    setNotes((prev) => prev.filter((n) => n.id !== id))
  }

  async function handleMasteryChange(level: MasteryLevel) {
    if (!user || !conceptId) return
    setSavingMastery(true)
    try {
      await setConceptMastery(user.id, conceptId, level)
      setMastery(level)
    } finally {
      setSavingMastery(false)
    }
  }

  if (loading) return <p className="text-sm text-ink-soft">Cargando concepto…</p>

  if (!concept) {
    return (
      <div className="card">
        <p className="text-sm text-ink-soft">No se encontró este concepto.</p>
        <Link to="/concepts" className="btn-secondary mt-3 inline-flex text-xs">
          Volver a Conceptos
        </Link>
      </div>
    )
  }

  return (
    <div className="mx-auto flex max-w-3xl flex-col gap-6 pb-16">
      <div>
        <Link to="/concepts" className="text-xs text-ink-soft hover:text-brass">
          ← Volver a Conceptos
        </Link>
        <h1 className="mt-2 font-display text-2xl font-semibold text-ink">{concept.title}</h1>
        <MasteryPicker value={mastery} onChange={handleMasteryChange} disabled={savingMastery} />
      </div>

      {concept.what_is && (
        <Section title="Qué es">
          <MultilineText text={concept.what_is} />
        </Section>
      )}
      {concept.why_it_exists && (
        <Section title="Por qué existe">
          <MultilineText text={concept.why_it_exists} />
        </Section>
      )}
      {concept.problem_it_solves && (
        <Section title="Qué problema resuelve">
          <MultilineText text={concept.problem_it_solves} />
        </Section>
      )}
      {concept.when_to_use && (
        <Section title="Cuándo utilizarlo">
          <MultilineText text={concept.when_to_use} />
        </Section>
      )}
      {concept.common_mistakes && (
        <Section title="Errores comunes">
          <MultilineText text={concept.common_mistakes} />
        </Section>
      )}

      {relations && (relations.outgoing.length > 0 || relations.incoming.length > 0) && (
        <Section title="Relaciones con otros conceptos">
          <div className="flex flex-col gap-1">
            {relations.outgoing.map((rel) => (
              <Link
                key={rel.id}
                to={`/concepts/${rel.toConcept.id}`}
                className="text-sm text-ink hover:text-brass"
              >
                {rel.relation_type ?? 'se relaciona con'} → <strong>{rel.toConcept.title}</strong>
              </Link>
            ))}
            {relations.incoming.map((rel) => (
              <Link
                key={rel.id}
                to={`/concepts/${rel.fromConcept.id}`}
                className="text-sm text-ink hover:text-brass"
              >
                <strong>{rel.fromConcept.title}</strong> {rel.relation_type ?? 'se relaciona con'} →
                este concepto
              </Link>
            ))}
          </div>
        </Section>
      )}

      {lessons.length > 0 && (
        <Section title="Lecciones relacionadas">
          <ul className="flex flex-col gap-1">
            {lessons.map((lesson) => (
              <li key={lesson.id}>
                <Link to={`/lesson/${lesson.id}`} className="text-sm text-brass hover:underline">
                  {lesson.title}
                </Link>
              </li>
            ))}
          </ul>
        </Section>
      )}

      {projects.length > 0 && (
        <Section title="Proyectos relacionados">
          <ul className="flex flex-col gap-1">
            {projects.map((project) => (
              <li key={project.id} className="text-sm text-ink">
                {project.name}
              </li>
            ))}
          </ul>
        </Section>
      )}

      {resources.length > 0 && (
        <Section title="Recursos">
          <ul className="flex flex-col gap-1">
            {resources.map((resource) => (
              <li key={resource.id}>
                <a
                  href={resource.url}
                  target="_blank"
                  rel="noreferrer"
                  className="text-sm text-brass hover:underline"
                >
                  {resource.title}
                </a>
              </li>
            ))}
          </ul>
        </Section>
      )}

      <Section title="Notas personales">
        <div className="flex flex-col gap-2">
          <textarea
            className="input-field"
            rows={2}
            placeholder="Escribí una nota sobre este concepto…"
            value={newNote}
            onChange={(e) => setNewNote(e.target.value)}
          />
          <button
            onClick={handleAddNote}
            disabled={savingNote || !newNote.trim()}
            className="btn-secondary self-start text-xs"
          >
            {savingNote ? 'Guardando…' : 'Agregar nota'}
          </button>
          {notes.map((note) => (
            <div
              key={note.id}
              className="flex items-start justify-between rounded-md bg-paper-muted p-2"
            >
              <p className="text-sm text-ink">{note.content}</p>
              <button
                onClick={() => handleDeleteNote(note.id)}
                className="ml-3 text-xs text-ink-soft hover:text-rust"
              >
                Eliminar
              </button>
            </div>
          ))}
        </div>
      </Section>
    </div>
  )
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="card">
      <p className="mb-2 text-sm font-semibold text-ink">{title}</p>
      {children}
    </div>
  )
}

function MultilineText({ text }: { text: string }) {
  return (
    <div className="flex flex-col gap-1 text-sm text-ink-soft">
      {text.split('\n').map((line, i) => (
        <p key={i}>{line}</p>
      ))}
    </div>
  )
}

const masteryLevels: { value: MasteryLevel; label: string }[] = [
  { value: 'unknown', label: 'No lo conozco' },
  { value: 'understand', label: 'Lo entiendo' },
  { value: 'can_explain', label: 'Lo puedo explicar' },
  { value: 'can_apply', label: 'Lo puedo aplicar' },
  { value: 'can_teach', label: 'Lo podría enseñar' },
]

function MasteryPicker({
  value,
  onChange,
  disabled,
}: {
  value: MasteryLevel
  onChange: (level: MasteryLevel) => void
  disabled: boolean
}) {
  const currentIndex = masteryLevels.findIndex((l) => l.value === value)
  return (
    <div className="mt-3">
      <p className="mb-1 text-xs font-medium text-ink-soft">Tu nivel de dominio</p>
      <div className="flex flex-wrap gap-1">
        {masteryLevels.map((level, i) => (
          <button
            key={level.value}
            type="button"
            disabled={disabled}
            onClick={() => onChange(level.value)}
            className={`rounded-full px-3 py-1 text-xs transition-colors ${
              i <= currentIndex && value !== 'unknown'
                ? 'bg-brass text-paper'
                : i === currentIndex
                  ? 'bg-paper-muted text-ink-soft ring-1 ring-brass'
                  : 'bg-paper-muted text-ink-soft hover:bg-brass/10'
            }`}
          >
            {level.label}
          </button>
        ))}
      </div>
    </div>
  )
}
