import { supabase } from '@/lib/supabaseClient'
import { logActivity } from './progress.service'
import type { PersonalNote } from '@/types/database.types'

export async function listMyNotes(userId: string): Promise<PersonalNote[]> {
  const { data, error } = await supabase
    .from('personal_notes')
    .select('*')
    .eq('user_id', userId)
    .order('updated_at', { ascending: false })
  if (error) throw error
  return (data ?? []) as PersonalNote[]
}

export async function listNotesForLesson(
  userId: string,
  lessonId: string,
): Promise<PersonalNote[]> {
  const { data, error } = await supabase
    .from('personal_notes')
    .select('*')
    .eq('user_id', userId)
    .eq('lesson_id', lessonId)
    .order('created_at', { ascending: false })
  if (error) throw error
  return (data ?? []) as PersonalNote[]
}

export async function createNote(
  userId: string,
  lessonId: string,
  content: string,
): Promise<PersonalNote> {
  const { data, error } = await supabase
    .from('personal_notes')
    .insert({ user_id: userId, lesson_id: lessonId, content })
    .select()
    .single()
  if (error) throw error
  await logActivity(userId, 'note_created', { lesson_id: lessonId })
  return data as PersonalNote
}

export async function updateNote(
  noteId: string,
  patch: Partial<Pick<PersonalNote, 'content' | 'is_important'>>,
): Promise<void> {
  const { error } = await supabase.from('personal_notes').update(patch).eq('id', noteId)
  if (error) throw error
}

export async function deleteNote(noteId: string): Promise<void> {
  const { error } = await supabase.from('personal_notes').delete().eq('id', noteId)
  if (error) throw error
}
