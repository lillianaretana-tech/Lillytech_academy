import { supabase } from '@/lib/supabaseClient'
import { logActivity } from './progress.service'
import type {
  Concept,
  ConceptRelation,
  ConceptResource,
  ConceptNote,
  Lesson,
  PracticalProject,
  ConceptMastery,
  MasteryLevel,
} from '@/types/database.types'

export async function listPublishedConcepts(): Promise<Concept[]> {
  const { data, error } = await supabase
    .from('concepts')
    .select('*')
    .eq('is_published', true)
    .order('title', { ascending: true })
  if (error) throw error
  return (data ?? []) as Concept[]
}

export async function getConcept(conceptId: string): Promise<Concept | null> {
  const { data, error } = await supabase
    .from('concepts')
    .select('*')
    .eq('id', conceptId)
    .maybeSingle()
  if (error) throw error
  return data as Concept | null
}

export async function getConceptBySlug(slug: string): Promise<Concept | null> {
  const { data, error } = await supabase
    .from('concepts')
    .select('*')
    .eq('slug', slug)
    .maybeSingle()
  if (error) throw error
  return data as Concept | null
}

// Relaciones salientes (este concepto → otros) y entrantes (otros → este),
// porque la relación es dirigida — un concepto puede "depender de" otro,
// y eso se lee distinto según el lado desde el que se mire.
export interface ConceptWithRelations {
  outgoing: (ConceptRelation & { toConcept: Concept })[]
  incoming: (ConceptRelation & { fromConcept: Concept })[]
}

export async function getConceptRelations(conceptId: string): Promise<ConceptWithRelations> {
  const [{ data: outgoing, error: outError }, { data: incoming, error: inError }] =
    await Promise.all([
      supabase
        .from('concept_relations')
        .select('*, toConcept:concepts!concept_relations_to_concept_id_fkey(*)')
        .eq('from_concept_id', conceptId),
      supabase
        .from('concept_relations')
        .select('*, fromConcept:concepts!concept_relations_from_concept_id_fkey(*)')
        .eq('to_concept_id', conceptId),
    ])
  if (outError) throw outError
  if (inError) throw inError
  return {
    outgoing: (outgoing ?? []) as unknown as (ConceptRelation & { toConcept: Concept })[],
    incoming: (incoming ?? []) as unknown as (ConceptRelation & { fromConcept: Concept })[],
  }
}

export async function getConceptLessons(conceptId: string): Promise<Lesson[]> {
  const { data, error } = await supabase
    .from('concept_lessons')
    .select('lesson:lessons(*)')
    .eq('concept_id', conceptId)
  if (error) throw error
  return ((data ?? []) as unknown as { lesson: Lesson }[])
    .map((row) => row.lesson)
    .filter(Boolean)
}

export async function getLessonConcepts(lessonId: string): Promise<Concept[]> {
  const { data, error } = await supabase
    .from('concept_lessons')
    .select('concept:concepts(*)')
    .eq('lesson_id', lessonId)
  if (error) throw error
  return ((data ?? []) as unknown as { concept: Concept }[])
    .map((row) => row.concept)
    .filter((c) => c && c.is_published)
}

export async function getConceptProjects(
  conceptId: string,
  userId: string,
): Promise<PracticalProject[]> {
  const { data, error } = await supabase
    .from('concept_projects')
    .select('project:practical_projects(*)')
    .eq('concept_id', conceptId)
  if (error) throw error
  return ((data ?? []) as unknown as { project: PracticalProject }[])
    .map((row) => row.project)
    .filter((p) => p && p.user_id === userId)
}

export async function getConceptResources(conceptId: string): Promise<ConceptResource[]> {
  const { data, error } = await supabase
    .from('concept_resources')
    .select('*')
    .eq('concept_id', conceptId)
    .order('order_index', { ascending: true })
  if (error) throw error
  return (data ?? []) as ConceptResource[]
}

export async function listConceptNotes(
  userId: string,
  conceptId: string,
): Promise<ConceptNote[]> {
  const { data, error } = await supabase
    .from('concept_notes')
    .select('*')
    .eq('user_id', userId)
    .eq('concept_id', conceptId)
    .order('created_at', { ascending: false })
  if (error) throw error
  return (data ?? []) as ConceptNote[]
}

export async function createConceptNote(
  userId: string,
  conceptId: string,
  content: string,
): Promise<ConceptNote> {
  const { data, error } = await supabase
    .from('concept_notes')
    .insert({ user_id: userId, concept_id: conceptId, content })
    .select()
    .single()
  if (error) throw error
  return data as ConceptNote
}

export async function deleteConceptNote(noteId: string): Promise<void> {
  const { error } = await supabase.from('concept_notes').delete().eq('id', noteId)
  if (error) throw error
}

// Nivel de dominio — personal por usuaria y concepto (v1.3).
export async function getConceptMastery(
  userId: string,
  conceptId: string,
): Promise<ConceptMastery | null> {
  const { data, error } = await supabase
    .from('concept_mastery')
    .select('*')
    .eq('user_id', userId)
    .eq('concept_id', conceptId)
    .maybeSingle()
  if (error) throw error
  return data as ConceptMastery | null
}

export async function listMyMastery(userId: string): Promise<ConceptMastery[]> {
  const { data, error } = await supabase
    .from('concept_mastery')
    .select('*')
    .eq('user_id', userId)
  if (error) throw error
  return (data ?? []) as ConceptMastery[]
}

export async function setConceptMastery(
  userId: string,
  conceptId: string,
  level: MasteryLevel,
): Promise<void> {
  const { error } = await supabase
    .from('concept_mastery')
    .upsert({ user_id: userId, concept_id: conceptId, level }, { onConflict: 'user_id,concept_id' })
  if (error) throw error
  await logActivity(userId, 'concept_mastery_updated', { concept_id: conceptId, level })
}
