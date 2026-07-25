import { supabase } from '@/lib/supabaseClient'
import { logActivity } from './progress.service'
import type { LearningQuestion } from '@/types/database.types'

export async function listQuestionsForLesson(
  userId: string,
  lessonId: string,
): Promise<LearningQuestion[]> {
  const { data, error } = await supabase
    .from('learning_questions')
    .select('*')
    .eq('user_id', userId)
    .eq('lesson_id', lessonId)
    .order('created_at', { ascending: false })
  if (error) throw error
  return (data ?? []) as LearningQuestion[]
}

export async function createQuestion(
  userId: string,
  lessonId: string,
  question: string,
  context?: string,
): Promise<LearningQuestion> {
  const { data, error } = await supabase
    .from('learning_questions')
    .insert({ user_id: userId, lesson_id: lessonId, question, context: context ?? null })
    .select()
    .single()
  if (error) throw error
  await logActivity(userId, 'question_created', { lesson_id: lessonId })
  return data as LearningQuestion
}

export async function resolveQuestion(questionId: string, answerFound: string): Promise<void> {
  const { error } = await supabase
    .from('learning_questions')
    .update({ status: 'resolved', answer_found: answerFound, resolved_at: new Date().toISOString() })
    .eq('id', questionId)
  if (error) throw error
}
