import { supabase } from '@/lib/supabaseClient'
import type {
  Course,
  CourseModule,
  Lesson,
  LearningPath,
  Stage,
  Profile,
  LessonProgressRow,
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
