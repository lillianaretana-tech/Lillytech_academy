import { supabase } from '@/lib/supabaseClient'
import type { Exercise, ExerciseResponse } from '@/types/database.types'

export async function listExercisesForLesson(lessonId: string): Promise<Exercise[]> {
  const { data, error } = await supabase
    .from('exercises')
    .select('*')
    .eq('lesson_id', lessonId)
    .order('order_index', { ascending: true })
  if (error) throw error
  return (data ?? []) as Exercise[]
}

export async function listMyResponsesForLesson(
  userId: string,
  lessonId: string,
): Promise<ExerciseResponse[]> {
  const { data, error } = await supabase
    .from('exercise_responses')
    .select('*, exercises!inner(lesson_id)')
    .eq('user_id', userId)
    .eq('exercises.lesson_id', lessonId)
  if (error) throw error
  return (data ?? []) as unknown as ExerciseResponse[]
}

export async function upsertResponse(
  userId: string,
  exerciseId: string,
  patch: { response_text?: string | null; evidence_url?: string | null },
): Promise<void> {
  const { error } = await supabase
    .from('exercise_responses')
    .upsert(
      { user_id: userId, exercise_id: exerciseId, ...patch },
      { onConflict: 'exercise_id,user_id' },
    )
  if (error) throw error
}
