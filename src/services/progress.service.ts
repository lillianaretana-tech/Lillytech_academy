import { supabase } from '@/lib/supabaseClient'
import type { Enrollment, LessonProgressRow, LessonStatus } from '@/types/database.types'

export async function listMyEnrollments(userId: string): Promise<Enrollment[]> {
  const { data, error } = await supabase.from('enrollments').select('*').eq('user_id', userId)
  if (error) throw error
  return (data ?? []) as Enrollment[]
}

export async function enrollInPath(userId: string, pathId: string): Promise<void> {
  const { error } = await supabase
    .from('enrollments')
    .insert({ user_id: userId, path_id: pathId })
  // Si ya estaba inscrita, el índice único devuelve error 23505 — lo ignoramos.
  if (error && error.code !== '23505') throw error
}

export async function listMyProgress(userId: string): Promise<LessonProgressRow[]> {
  const { data, error } = await supabase
    .from('lesson_progress')
    .select('*')
    .eq('user_id', userId)
  if (error) throw error
  return (data ?? []) as LessonProgressRow[]
}

export async function getLessonProgress(
  userId: string,
  lessonId: string,
): Promise<LessonProgressRow | null> {
  const { data, error } = await supabase
    .from('lesson_progress')
    .select('*')
    .eq('user_id', userId)
    .eq('lesson_id', lessonId)
    .maybeSingle()
  if (error) throw error
  return data as LessonProgressRow | null
}

export async function setLessonStatus(
  userId: string,
  lessonId: string,
  status: LessonStatus,
): Promise<void> {
  const existing = await getLessonProgress(userId, lessonId)

  const now = new Date().toISOString()
  const patch: Partial<LessonProgressRow> = { status }
  if (status === 'in_progress' && !existing?.started_at) patch.started_at = now
  if (status === 'completed') patch.completed_at = now

  if (existing) {
    const { error } = await supabase
      .from('lesson_progress')
      .update(patch)
      .eq('user_id', userId)
      .eq('lesson_id', lessonId)
    if (error) throw error
  } else {
    const { error } = await supabase.from('lesson_progress').insert({
      user_id: userId,
      lesson_id: lessonId,
      status,
      started_at: status === 'in_progress' || status === 'completed' ? now : null,
      completed_at: status === 'completed' ? now : null,
    })
    if (error) throw error
  }

  await logActivity(userId, status === 'completed' ? 'lesson_completed' : 'lesson_started', {
    lesson_id: lessonId,
  })
}

export async function logActivity(
  userId: string,
  eventType: string,
  metadata: Record<string, unknown> = {},
): Promise<void> {
  const { error } = await supabase
    .from('learning_activity')
    .insert({ user_id: userId, event_type: eventType, metadata })
  // El historial no debería romper el flujo principal si falla — solo lo logueamos.
  if (error) console.error('No se pudo registrar actividad:', error.message)
}
