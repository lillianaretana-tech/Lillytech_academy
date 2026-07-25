import { supabase } from '@/lib/supabaseClient'
import type {
  Course,
  CourseModule,
  Lesson,
  LearningPath,
  Stage,
  Profile,
  LessonProgressRow,
  LessonResource,
  Concept,
  ConceptRelation,
  ConceptResource,
} from '@/types/database.types'

// Estas consultas traen TODO (publicado o no) — son exclusivas del panel
// admin. RLS ya garantiza que solo un admin puede leerlas/escribirlas;
// esta capa no duplica esa validación, confía en la base de datos.

export async function adminListPaths(): Promise<LearningPath[]> {
  const { data, error } = await supabase
    .from('learning_paths')
    .select('*')
    .order('order_index', { ascending: true })
  if (error) throw error
  return (data ?? []) as LearningPath[]
}

export async function adminCreatePath(
  input: Pick<LearningPath, 'title' | 'description' | 'order_index'>,
): Promise<LearningPath> {
  const { data, error } = await supabase
    .from('learning_paths')
    .insert(input)
    .select()
    .single()
  if (error) throw error
  return data as LearningPath
}

export async function adminUpdatePath(id: string, patch: Partial<LearningPath>): Promise<void> {
  const { error } = await supabase.from('learning_paths').update(patch).eq('id', id)
  if (error) throw error
}

export async function adminDeletePath(id: string): Promise<void> {
  const { error } = await supabase.from('learning_paths').delete().eq('id', id)
  if (error) throw error
}

export async function adminListStages(pathId: string): Promise<Stage[]> {
  const { data, error } = await supabase
    .from('stages')
    .select('*')
    .eq('path_id', pathId)
    .order('order_index', { ascending: true })
  if (error) throw error
  return (data ?? []) as Stage[]
}

export async function adminCreateStage(
  input: Pick<Stage, 'path_id' | 'title' | 'description' | 'order_index'>,
): Promise<Stage> {
  const { data, error } = await supabase.from('stages').insert(input).select().single()
  if (error) throw error
  return data as Stage
}

export async function adminUpdateStage(id: string, patch: Partial<Stage>): Promise<void> {
  const { error } = await supabase.from('stages').update(patch).eq('id', id)
  if (error) throw error
}

export async function adminDeleteStage(id: string): Promise<void> {
  const { error } = await supabase.from('stages').delete().eq('id', id)
  if (error) throw error
}

export async function adminListCourses(stageId: string): Promise<Course[]> {
  const { data, error } = await supabase
    .from('courses')
    .select('*')
    .eq('stage_id', stageId)
    .order('order_index', { ascending: true })
  if (error) throw error
  return (data ?? []) as Course[]
}

export async function adminCreateCourse(
  input: Pick<Course, 'stage_id' | 'title' | 'description' | 'order_index'>,
): Promise<Course> {
  const { data, error } = await supabase.from('courses').insert(input).select().single()
  if (error) throw error
  return data as Course
}

export async function adminUpdateCourse(id: string, patch: Partial<Course>): Promise<void> {
  const { error } = await supabase.from('courses').update(patch).eq('id', id)
  if (error) throw error
}

export async function adminDeleteCourse(id: string): Promise<void> {
  const { error } = await supabase.from('courses').delete().eq('id', id)
  if (error) throw error
}

export async function adminListModules(courseId: string): Promise<CourseModule[]> {
  const { data, error } = await supabase
    .from('modules')
    .select('*')
    .eq('course_id', courseId)
    .order('order_index', { ascending: true })
  if (error) throw error
  return (data ?? []) as CourseModule[]
}

export async function adminCreateModule(
  input: Pick<CourseModule, 'course_id' | 'title' | 'description' | 'order_index'>,
): Promise<CourseModule> {
  const { data, error } = await supabase.from('modules').insert(input).select().single()
  if (error) throw error
  return data as CourseModule
}

export async function adminUpdateModule(id: string, patch: Partial<CourseModule>): Promise<void> {
  const { error } = await supabase.from('modules').update(patch).eq('id', id)
  if (error) throw error
}

export async function adminDeleteModule(id: string): Promise<void> {
  const { error } = await supabase.from('modules').delete().eq('id', id)
  if (error) throw error
}

export async function adminListLessons(moduleId: string): Promise<Lesson[]> {
  const { data, error } = await supabase
    .from('lessons')
    .select('*')
    .eq('module_id', moduleId)
    .order('order_index', { ascending: true })
  if (error) throw error
  return (data ?? []) as Lesson[]
}

export type NewLessonInput = Pick<Lesson, 'module_id' | 'title' | 'order_index'> &
  Partial<
    Pick<
      Lesson,
      | 'summary'
      | 'objectives'
      | 'content'
      | 'example'
      | 'practical_application'
      | 'common_mistakes'
      | 'checklist'
      | 'estimated_minutes'
      | 'level'
      | 'prerequisites'
    >
  >

export async function adminCreateLesson(input: NewLessonInput): Promise<Lesson> {
  const { data, error } = await supabase.from('lessons').insert(input).select().single()
  if (error) throw error
  return data as Lesson
}

export async function adminUpdateLesson(id: string, patch: Partial<Lesson>): Promise<void> {
  const { error } = await supabase.from('lessons').update(patch).eq('id', id)
  if (error) throw error
}

export async function adminDeleteLesson(id: string): Promise<void> {
  const { error } = await supabase.from('lessons').delete().eq('id', id)
  if (error) throw error
}

export async function adminListLessonResources(lessonId: string): Promise<LessonResource[]> {
  const { data, error } = await supabase
    .from('lesson_resources')
    .select('*')
    .eq('lesson_id', lessonId)
    .order('order_index', { ascending: true })
  if (error) throw error
  return (data ?? []) as LessonResource[]
}

export async function adminAddLessonResource(
  lessonId: string,
  title: string,
  url: string,
  orderIndex: number,
): Promise<LessonResource> {
  const { data, error } = await supabase
    .from('lesson_resources')
    .insert({ lesson_id: lessonId, title, url, order_index: orderIndex })
    .select()
    .single()
  if (error) throw error
  return data as LessonResource
}

export async function adminDeleteLessonResource(id: string): Promise<void> {
  const { error } = await supabase.from('lesson_resources').delete().eq('id', id)
  if (error) throw error
}

// ---- Biblioteca de Conceptos (v1.2) ----

function slugify(title: string): string {
  return title
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '') // quita acentos
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '')
}

export async function adminListConcepts(): Promise<Concept[]> {
  const { data, error } = await supabase
    .from('concepts')
    .select('*')
    .order('title', { ascending: true })
  if (error) throw error
  return (data ?? []) as Concept[]
}

export async function adminGetConcept(id: string): Promise<Concept | null> {
  const { data, error } = await supabase.from('concepts').select('*').eq('id', id).maybeSingle()
  if (error) throw error
  return data as Concept | null
}

export async function adminCreateConcept(title: string): Promise<Concept> {
  const baseSlug = slugify(title)
  // Evita choques de slug si ya existe uno igual — le agrega un sufijo corto.
  let slug = baseSlug
  const { data: existing } = await supabase.from('concepts').select('slug').eq('slug', slug)
  if (existing && existing.length > 0) slug = `${baseSlug}-${Date.now().toString(36)}`

  const { data, error } = await supabase
    .from('concepts')
    .insert({ title, slug })
    .select()
    .single()
  if (error) throw error
  return data as Concept
}

export async function adminUpdateConcept(id: string, patch: Partial<Concept>): Promise<void> {
  const { error } = await supabase.from('concepts').update(patch).eq('id', id)
  if (error) throw error
}

export async function adminDeleteConcept(id: string): Promise<void> {
  const { error } = await supabase.from('concepts').delete().eq('id', id)
  if (error) throw error
}

export async function adminListAllConceptRelations(
  conceptId: string,
): Promise<(ConceptRelation & { toTitle?: string; fromTitle?: string })[]> {
  const [{ data: outgoing, error: outError }, { data: incoming, error: inError }] =
    await Promise.all([
      supabase
        .from('concept_relations')
        .select('*, concepts!concept_relations_to_concept_id_fkey(title)')
        .eq('from_concept_id', conceptId),
      supabase
        .from('concept_relations')
        .select('*, concepts!concept_relations_from_concept_id_fkey(title)')
        .eq('to_concept_id', conceptId),
    ])
  if (outError) throw outError
  if (inError) throw inError
  const out = ((outgoing ?? []) as any[]).map((r) => ({ ...r, toTitle: r.concepts?.title }))
  const inc = ((incoming ?? []) as any[]).map((r) => ({ ...r, fromTitle: r.concepts?.title }))
  return [...out, ...inc] as (ConceptRelation & { toTitle?: string; fromTitle?: string })[]
}

export async function adminAddConceptRelation(
  fromConceptId: string,
  toConceptId: string,
  relationType: string,
): Promise<void> {
  const { error } = await supabase
    .from('concept_relations')
    .insert({ from_concept_id: fromConceptId, to_concept_id: toConceptId, relation_type: relationType })
  if (error) throw error
}

export async function adminDeleteConceptRelation(id: string): Promise<void> {
  const { error } = await supabase.from('concept_relations').delete().eq('id', id)
  if (error) throw error
}

export async function adminListConceptResources(conceptId: string): Promise<ConceptResource[]> {
  const { data, error } = await supabase
    .from('concept_resources')
    .select('*')
    .eq('concept_id', conceptId)
    .order('order_index', { ascending: true })
  if (error) throw error
  return (data ?? []) as ConceptResource[]
}

export async function adminAddConceptResource(
  conceptId: string,
  title: string,
  url: string,
  orderIndex: number,
): Promise<ConceptResource> {
  const { data, error } = await supabase
    .from('concept_resources')
    .insert({ concept_id: conceptId, title, url, order_index: orderIndex })
    .select()
    .single()
  if (error) throw error
  return data as ConceptResource
}

export async function adminDeleteConceptResource(id: string): Promise<void> {
  const { error } = await supabase.from('concept_resources').delete().eq('id', id)
  if (error) throw error
}

export async function adminListConceptLessons(conceptId: string): Promise<Lesson[]> {
  const { data, error } = await supabase
    .from('concept_lessons')
    .select('id, lesson:lessons(*)')
    .eq('concept_id', conceptId)
  if (error) throw error
  return ((data ?? []) as unknown as { lesson: Lesson }[]).map((r) => r.lesson).filter(Boolean)
}

export async function adminLinkConceptLesson(conceptId: string, lessonId: string): Promise<void> {
  const { error } = await supabase
    .from('concept_lessons')
    .insert({ concept_id: conceptId, lesson_id: lessonId })
  if (error && error.code !== '23505') throw error
}

export async function adminUnlinkConceptLesson(conceptId: string, lessonId: string): Promise<void> {
  const { error } = await supabase
    .from('concept_lessons')
    .delete()
    .eq('concept_id', conceptId)
    .eq('lesson_id', lessonId)
  if (error) throw error
}

// Todas las lecciones publicadas o no, para el selector de "enlazar lección"
// en el editor de conceptos.
export async function adminListAllLessonsFlat(): Promise<(Lesson & { pathTitle: string })[]> {
  const { data, error } = await supabase
    .from('lessons')
    .select('*, modules(course_id, courses(stage_id, stages(path_id, learning_paths(title))))')
    .order('title', { ascending: true })
  if (error) throw error
  return ((data ?? []) as any[]).map((row) => ({
    ...row,
    pathTitle: row.modules?.courses?.stages?.learning_paths?.title ?? '',
  }))
}

// Progreso de todas las estudiantes (solo admin puede leer, vía RLS).
export interface StudentProgressSummary {
  userId: string
  fullName: string | null
  completedLessons: number
  inProgressLessons: number
}

export async function adminListStudentProgress(): Promise<StudentProgressSummary[]> {
  const [{ data: profiles, error: profilesError }, { data: progress, error: progressError }] =
    await Promise.all([
      supabase.from('profiles').select('*'),
      supabase.from('lesson_progress').select('*'),
    ])
  if (profilesError) throw profilesError
  if (progressError) throw progressError

  const progressRows = (progress ?? []) as LessonProgressRow[]
  const byUser = new Map<string, LessonProgressRow[]>()
  for (const row of progressRows) {
    const list = byUser.get(row.user_id) ?? []
    list.push(row)
    byUser.set(row.user_id, list)
  }

  return ((profiles ?? []) as Profile[]).map((profile) => {
    const rows = byUser.get(profile.id) ?? []
    return {
      userId: profile.id,
      fullName: profile.full_name,
      completedLessons: rows.filter((r) => r.status === 'completed').length,
      inProgressLessons: rows.filter((r) => r.status === 'in_progress').length,
    }
  })
}
