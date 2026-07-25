import { supabase } from '@/lib/supabaseClient'
import type {
  Concept,
  Lesson,
  PersonalNote,
  ConceptNote,
  LearningQuestion,
  PracticalProject,
} from '@/types/database.types'

export interface GlobalSearchResults {
  concepts: Concept[]
  lessons: Lesson[]
  notes: (PersonalNote | ConceptNote)[]
  questions: LearningQuestion[]
  projects: PracticalProject[]
}

// RLS ya se encarga de los límites de visibilidad (publicado/propio) —
// esta capa solo agrega el texto de búsqueda encima.
export async function globalSearch(userId: string, query: string): Promise<GlobalSearchResults> {
  const q = `%${query}%`

  const [concepts, lessons, personalNotes, conceptNotes, questions, projects] = await Promise.all([
    supabase.from('concepts').select('*').or(`title.ilike.${q},what_is.ilike.${q}`).limit(10),
    supabase.from('lessons').select('*').or(`title.ilike.${q},summary.ilike.${q}`).limit(10),
    supabase
      .from('personal_notes')
      .select('*')
      .eq('user_id', userId)
      .ilike('content', q)
      .limit(10),
    supabase
      .from('concept_notes')
      .select('*')
      .eq('user_id', userId)
      .ilike('content', q)
      .limit(10),
    supabase
      .from('learning_questions')
      .select('*')
      .eq('user_id', userId)
      .ilike('question', q)
      .limit(10),
    supabase
      .from('practical_projects')
      .select('*')
      .eq('user_id', userId)
      .or(`name.ilike.${q},description.ilike.${q}`)
      .limit(10),
  ])

  if (concepts.error) throw concepts.error
  if (lessons.error) throw lessons.error
  if (personalNotes.error) throw personalNotes.error
  if (conceptNotes.error) throw conceptNotes.error
  if (questions.error) throw questions.error
  if (projects.error) throw projects.error

  return {
    concepts: (concepts.data ?? []) as Concept[],
    lessons: (lessons.data ?? []) as Lesson[],
    notes: [
      ...((personalNotes.data ?? []) as PersonalNote[]),
      ...((conceptNotes.data ?? []) as ConceptNote[]),
    ],
    questions: (questions.data ?? []) as LearningQuestion[],
    projects: (projects.data ?? []) as PracticalProject[],
  }
}
