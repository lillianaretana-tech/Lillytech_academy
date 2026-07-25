import { supabase } from '@/lib/supabaseClient'
import { listPublishedPaths, getPathTree } from './learningStructure.service'
import { listMyEnrollments, listMyProgress } from './progress.service'
import type { Lesson, LearningActivity } from '@/types/database.types'

export interface DashboardData {
  activePathTitle: string | null
  activePathId: string | null
  totalLessons: number
  completedLessons: number
  inProgressLessons: number
  percentComplete: number
  studiedMinutes: number
  nextLesson: (Lesson & { moduleId: string }) | null
  recentActivity: LearningActivity[]
}

export async function loadDashboard(userId: string): Promise<DashboardData> {
  const [paths, enrollments, progress] = await Promise.all([
    listPublishedPaths(),
    listMyEnrollments(userId),
    listMyProgress(userId),
  ])

  const empty: DashboardData = {
    activePathTitle: null,
    activePathId: null,
    totalLessons: 0,
    completedLessons: 0,
    inProgressLessons: 0,
    percentComplete: 0,
    studiedMinutes: 0,
    nextLesson: null,
    recentActivity: [],
  }

  // La "ruta activa" es la primera en la que la estudiante está inscrita;
  // si no hay inscripciones todavía, usamos la primera ruta publicada
  // solo para mostrar contenido, sin asumir inscripción.
  const activePathId = enrollments[0]?.path_id ?? paths[0]?.id ?? null
  if (!activePathId) return empty

  const tree = await getPathTree(activePathId)
  if (!tree) return empty

  const allLessons: (Lesson & { moduleId: string })[] = []
  for (const stage of tree.stages) {
    for (const course of stage.courses) {
      for (const mod of course.modules) {
        for (const lesson of mod.lessons) {
          allLessons.push({ ...lesson, moduleId: mod.id })
        }
      }
    }
  }

  const progressByLesson = new Map(progress.map((p) => [p.lesson_id, p]))
  const completedLessons = allLessons.filter(
    (l) => progressByLesson.get(l.id)?.status === 'completed',
  ).length
  const inProgressLessons = allLessons.filter(
    (l) => progressByLesson.get(l.id)?.status === 'in_progress',
  ).length

  const studiedMinutes = allLessons
    .filter((l) => progressByLesson.get(l.id)?.status === 'completed')
    .reduce((acc, l) => acc + (l.estimated_minutes ?? 0), 0)

  const nextLesson =
    allLessons.find((l) => {
      const status = progressByLesson.get(l.id)?.status ?? 'not_started'
      return status !== 'completed'
    }) ?? null

  const { data: activity } = await supabase
    .from('learning_activity')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })
    .limit(5)

  return {
    activePathTitle: tree.title,
    activePathId: tree.id,
    totalLessons: allLessons.length,
    completedLessons,
    inProgressLessons,
    percentComplete:
      allLessons.length === 0 ? 0 : Math.round((completedLessons / allLessons.length) * 100),
    studiedMinutes,
    nextLesson,
    recentActivity: (activity ?? []) as LearningActivity[],
  }
}
