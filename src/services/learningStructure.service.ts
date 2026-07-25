import { supabase } from '@/lib/supabaseClient'
import type {
  Course,
  CourseModule,
  Lesson,
  LearningPath,
  Stage,
} from '@/types/database.types'

export async function listPublishedPaths(): Promise<LearningPath[]> {
  const { data, error } = await supabase
    .from('learning_paths')
    .select('*')
    .eq('is_published', true)
    .order('order_index', { ascending: true })

  if (error) throw error
  return (data ?? []) as LearningPath[]
}

export async function getPath(pathId: string): Promise<LearningPath | null> {
  const { data, error } = await supabase
    .from('learning_paths')
    .select('*')
    .eq('id', pathId)
    .maybeSingle()

  if (error) throw error
  return data as LearningPath | null
}

export async function listStagesForPath(pathId: string): Promise<Stage[]> {
  const { data, error } = await supabase
    .from('stages')
    .select('*')
    .eq('path_id', pathId)
    .eq('is_published', true)
    .order('order_index', { ascending: true })

  if (error) throw error
  return (data ?? []) as Stage[]
}

export async function listCoursesForStage(stageId: string): Promise<Course[]> {
  const { data, error } = await supabase
    .from('courses')
    .select('*')
    .eq('stage_id', stageId)
    .eq('is_published', true)
    .order('order_index', { ascending: true })

  if (error) throw error
  return (data ?? []) as Course[]
}

export async function listModulesForCourse(courseId: string): Promise<CourseModule[]> {
  const { data, error } = await supabase
    .from('modules')
    .select('*')
    .eq('course_id', courseId)
    .eq('is_published', true)
    .order('order_index', { ascending: true })

  if (error) throw error
  return (data ?? []) as CourseModule[]
}

export async function listLessonsForModule(moduleId: string): Promise<Lesson[]> {
  const { data, error } = await supabase
    .from('lessons')
    .select('*')
    .eq('module_id', moduleId)
    .eq('is_published', true)
    .order('order_index', { ascending: true })

  if (error) throw error
  return (data ?? []) as Lesson[]
}

export async function getLesson(lessonId: string): Promise<Lesson | null> {
  const { data, error } = await supabase
    .from('lessons')
    .select('*')
    .eq('id', lessonId)
    .maybeSingle()

  if (error) throw error
  return data as Lesson | null
}

export async function listLessonResources(lessonId: string) {
  const { data, error } = await supabase
    .from('lesson_resources')
    .select('*')
    .eq('lesson_id', lessonId)
    .order('order_index', { ascending: true })
  if (error) throw error
  return data ?? []
}

// Trae la ruta completa (etapas > cursos > módulos > lecciones) en pocas
// consultas, para armar la vista de Biblioteca sin N+1 por cada nivel.
export interface PathTree extends LearningPath {
  stages: (Stage & {
    courses: (Course & {
      modules: (CourseModule & { lessons: Lesson[] })[]
    })[]
  })[]
}

export async function getPathTree(pathId: string): Promise<PathTree | null> {
  const path = await getPath(pathId)
  if (!path) return null

  const stages = await listStagesForPath(pathId)

  const stagesWithCourses = await Promise.all(
    stages.map(async (stage) => {
      const courses = await listCoursesForStage(stage.id)
      const coursesWithModules = await Promise.all(
        courses.map(async (course) => {
          const modules = await listModulesForCourse(course.id)
          const modulesWithLessons = await Promise.all(
            modules.map(async (mod) => {
              const lessons = await listLessonsForModule(mod.id)
              return { ...mod, lessons }
            }),
          )
          return { ...course, modules: modulesWithLessons }
        }),
      )
      return { ...stage, courses: coursesWithModules }
    }),
  )

  return { ...path, stages: stagesWithCourses }
}
