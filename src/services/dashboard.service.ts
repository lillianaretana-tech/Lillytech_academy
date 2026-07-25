import { supabase } from '@/lib/supabaseClient'
import { listPublishedPaths, getPathTree } from './learningStructure.service'
import { listMyEnrollments, listMyProgress } from './progress.service'
import type { Lesson, LearningActivity } from '@/types/database.types'

export interface StageProgress {
  stageTitle: string
  total: number
  completed: number
}

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
  conceptsLearned: number
  questionsResolved: number
  notesCreated: number
  projectsCount: number
  progressByStage: StageProgress[]
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
    conceptsLearned: 0,
    questionsResolved: 0,
    notesCreated: 0,
    projectsCount: 0,
    progressByStage: [],
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

  const progressByStage: StageProgress[] = tree.stages.map((stage) => {
    const stageLessons = stage.courses.flatMap((c) => c.modules.flatMap((m) => m.lessons))
    const completed = stageLessons.filter(
      (l) => progressByLesson.get(l.id)?.status === 'completed',
    ).length
    return { stageTitle: stage.title, total: stageLessons.length, completed }
  })

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

  const [
    { count: conceptsLearned },
    { count: questionsResolved },
    { count: personalNotesCount },
    { count: conceptNotesCount },
    { count: projectsCount },
  ] = await Promise.all([
    supabase
      .from('concept_mastery')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId)
      .in('level', ['can_apply', 'can_teach']),
    supabase
      .from('learning_questions')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId)
      .eq('status', 'resolved'),
    supabase
      .from('personal_notes')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId),
    supabase
      .from('concept_notes')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId),
    supabase
      .from('practical_projects')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', userId),
  ])

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
    conceptsLearned: conceptsLearned ?? 0,
    questionsResolved: questionsResolved ?? 0,
    notesCreated: (personalNotesCount ?? 0) + (conceptNotesCount ?? 0),
    projectsCount: projectsCount ?? 0,
    progressByStage,
  }
}
