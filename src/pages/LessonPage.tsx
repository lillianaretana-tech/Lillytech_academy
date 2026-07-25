import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { useAuth } from '@/features/auth/hooks/useAuth'
import { getLesson } from '@/services/learningStructure.service'
import { getLessonProgress, setLessonStatus } from '@/services/progress.service'
import { listNotesForLesson, createNote, deleteNote } from '@/services/notes.service'
import { listQuestionsForLesson, createQuestion } from '@/services/questions.service'
import { listExercisesForLesson, listMyResponsesForLesson, upsertResponse } from '@/services/exercises.service'
import type {
  Lesson,
  LessonStatus,
  PersonalNote,
  LearningQuestion,
  Exercise,
  ExerciseResponse,
} from '@/types/database.types'

export function LessonPage() {
  const { lessonId } = useParams<{ lessonId: string }>()
  const { user } = useAuth()

  const [lesson, setLesson] = useState<Lesson | null>(null)
  const [status, setStatus] = useState<LessonStatus>('not_started')
  const [notes, setNotes] = useState<PersonalNote[]>([])
  const [questions, setQuestions] = useState<LearningQuestion[]>([])
  const [exercises, setExercises] = useState<Exercise[]>([])
  const [responses, setResponses] = useState<ExerciseResponse[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const [newNote, setNewNote] = useState('')
  const [newQuestion, setNewQuestion] = useState('')
  const [savingNote, setSavingNote] = useState(false)
  const [savingQuestion, setSavingQuestion] = useState(false)

  async function loadAll() {
    if (!user || !lessonId) return
    setLoading(true)
    setError(null)
    try {
      const [lessonData, progressData, notesData, questionsData, exercisesData, responsesData] =
        await Promise.all([
          getLesson(lessonId),
          getLessonProgress(user.id, lessonId),
          listNotesForLesson(user.id, lessonId),
          listQuestionsForLesson(user.id, lessonId),
          listExercisesForLesson(lessonId),
          listMyResponsesForLesson(user.id, lessonId),
        ])
      setLesson(lessonData)
      setStatus(progressData?.status ?? 'not_started')
      setNotes(notesData)
      setQuestions(questionsData)
      setExercises(exercisesData)
      setResponses(responsesData)

      // Si es la primera vez que abre la lección, la marca en progreso automáticamente.
      if (!progressData) {
        await setLessonStatus(user.id, lessonId, 'in_progress')
        setStatus('in_progress')
      }
    } catch (e) {
      setError(e instanceof Error ? e.message : 'No se pudo cargar la lección.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadAll()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user?.id, lessonId])

  async function handleMarkCompleted() {
    if (!user || !lessonId) return
    await setLessonStatus(user.id, lessonId, 'completed')
    setStatus('completed')
  }

  async function handleAddNote() {
    if (!user || !lessonId || !newNote.trim()) return
    setSavingNote(true)
    try {
      const note = await createNote(user.id, lessonId, newNote.trim())
      setNotes((prev) => [note, ...prev])
      setNewNote('')
    } finally {
      setSavingNote(false)
    }
  }

  async function handleDeleteNote(id: string) {
    await deleteNote(id)
    setNotes((prev) => prev.filter((n) => n.id !== id))
  }

  async function handleAddQuestion() {
    if (!user || !lessonId || !newQuestion.trim()) return
    setSavingQuestion(true)
    try {
      const q = await createQuestion(user.id, lessonId, newQuestion.trim())
      setQuestions((prev) => [q, ...prev])
      setNewQuestion('')
    } finally {
      setSavingQuestion(false)
    }
  }

  async function handleResponseChange(exerciseId: string, text: string) {
    if (!user) return
    setResponses((prev) => {
      const existing = prev.find((r) => r.exercise_id === exerciseId)
      if (existing) {
        return prev.map((r) => (r.exercise_id === exerciseId ? { ...r, response_text: text } : r))
      }
      return [
        ...prev,
        {
          id: crypto.randomUUID(),
          exercise_id: exerciseId,
          user_id: user.id,
          response_text: text,
          evidence_url: null,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        },
      ]
    })
  }

  async function handleSaveResponse(exerciseId: string) {
    if (!user) return
    const response = responses.find((r) => r.exercise_id === exerciseId)
    await upsertResponse(user.id, exerciseId, {
      response_text: response?.response_text ?? '',
      evidence_url: response?.evidence_url ?? null,
    })
  }

  if (loading) return <p className="text-sm text-ink-soft">Cargando lección…</p>

  if (error) {
    return (
      <div className="card">
        <p className="text-sm text-rust">{error}</p>
      </div>
    )
  }

  if (!lesson) {
    return (
      <div className="card">
        <p className="text-sm text-ink-soft">No se encontró esta lección.</p>
        <Link to="/library" className="btn-secondary mt-3 inline-flex text-xs">
          Volver a la Biblioteca
        </Link>
      </div>
    )
  }

  return (
    <div className="mx-auto flex max-w-3xl flex-col gap-6 pb-16">
      <div>
        <Link to="/library" className="text-xs text-ink-soft hover:text-brass">
          ← Volver a la Biblioteca
        </Link>
        <div className="mt-2 flex items-start justify-between gap-4">
          <div>
            <h1 className="font-display text-2xl font-semibold text-ink">{lesson.title}</h1>
            {lesson.summary && <p className="mt-1 text-sm text-ink-soft">{lesson.summary}</p>}
          </div>
          <StatusPill status={status} />
        </div>
        <div className="mt-3 flex flex-wrap gap-3 text-xs text-ink-soft">
          {lesson.level && <span>Nivel: {lesson.level}</span>}
          {lesson.estimated_minutes && <span>{lesson.estimated_minutes} min</span>}
          {lesson.prerequisites && <span>Requiere: {lesson.prerequisites}</span>}
        </div>
      </div>

      {lesson.objectives && (
        <Section title="Objetivos">
          <MultilineText text={lesson.objectives} />
        </Section>
      )}

      {lesson.content && (
        <Section title="Explicación">
          <MultilineText text={lesson.content} />
        </Section>
      )}

      {lesson.example && (
        <Section title="Ejemplo">
          <MultilineText text={lesson.example} />
        </Section>
      )}

      {lesson.practical_application && (
        <Section title="Aplicación práctica">
          <MultilineText text={lesson.practical_application} />
        </Section>
      )}

      {lesson.common_mistakes && (
        <Section title="Errores comunes">
          <MultilineText text={lesson.common_mistakes} />
        </Section>
      )}

      {lesson.checklist && (
        <Section title="Lista de comprobación">
          <MultilineText text={lesson.checklist} />
        </Section>
      )}

      {exercises.length > 0 && (
        <Section title="Ejercicios prácticos">
          <div className="flex flex-col gap-4">
            {exercises.map((ex) => {
              const response = responses.find((r) => r.exercise_id === ex.id)
              return (
                <div key={ex.id} className="rounded-md border border-ink/10 p-3">
                  <p className="text-sm font-medium text-ink">{ex.title}</p>
                  <p className="mt-1 text-xs text-ink-soft">{ex.instructions}</p>
                  <textarea
                    className="input-field mt-2"
                    rows={3}
                    placeholder={ex.type === 'evidence_link' ? 'Pegá el enlace de evidencia…' : 'Tu respuesta…'}
                    value={response?.response_text ?? ''}
                    onChange={(e) => handleResponseChange(ex.id, e.target.value)}
                    onBlur={() => handleSaveResponse(ex.id)}
                  />
                </div>
              )
            })}
          </div>
        </Section>
      )}

      <Section title="Notas personales">
        <div className="flex flex-col gap-2">
          <textarea
            className="input-field"
            rows={2}
            placeholder="Escribí una nota sobre esta lección…"
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
            <div key={note.id} className="flex items-start justify-between rounded-md bg-paper-muted p-2">
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

      <Section title="Dudas">
        <div className="flex flex-col gap-2">
          <textarea
            className="input-field"
            rows={2}
            placeholder="¿Qué te quedó sin claro de esta lección?"
            value={newQuestion}
            onChange={(e) => setNewQuestion(e.target.value)}
          />
          <button
            onClick={handleAddQuestion}
            disabled={savingQuestion || !newQuestion.trim()}
            className="btn-secondary self-start text-xs"
          >
            {savingQuestion ? 'Guardando…' : 'Registrar duda'}
          </button>
          {questions.map((q) => (
            <div key={q.id} className="rounded-md bg-paper-muted p-2">
              <p className="text-sm text-ink">{q.question}</p>
              <p className="mt-1 text-xs text-ink-soft">
                {q.status === 'resolved' ? 'Resuelta' : 'Pendiente'}
              </p>
            </div>
          ))}
        </div>
      </Section>

      {status !== 'completed' && (
        <button onClick={handleMarkCompleted} className="btn-primary self-start">
          Marcar como completada
        </button>
      )}
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

function StatusPill({ status }: { status: LessonStatus }) {
  const map: Record<LessonStatus, { label: string; className: string }> = {
    not_started: { label: 'Sin empezar', className: 'bg-paper-muted text-ink-soft' },
    in_progress: { label: 'En progreso', className: 'bg-brass/15 text-brass-dark' },
    completed: { label: 'Completada', className: 'bg-sage/20 text-sage' },
    needs_review: { label: 'Requiere repaso', className: 'bg-rust/15 text-rust' },
  }
  const entry = map[status]
  return (
    <span className={`whitespace-nowrap rounded-full px-3 py-1 text-xs font-medium ${entry.className}`}>
      {entry.label}
    </span>
  )
}
