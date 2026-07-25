import { supabase } from '@/lib/supabaseClient'
import type { PracticalProject, ProjectStatus } from '@/types/database.types'

export async function listMyProjects(userId: string): Promise<PracticalProject[]> {
  const { data, error } = await supabase
    .from('practical_projects')
    .select('*')
    .eq('user_id', userId)
    .order('updated_at', { ascending: false })
  if (error) throw error
  return (data ?? []) as PracticalProject[]
}

export interface NewProjectInput {
  name: string
  description?: string
  status: ProjectStatus
  technologies?: string[]
  problem_solved?: string
  learnings?: string
  repo_url?: string
  app_url?: string
  started_at?: string
  finished_at?: string
}

export async function createProject(
  userId: string,
  input: NewProjectInput,
): Promise<PracticalProject> {
  const { data, error } = await supabase
    .from('practical_projects')
    .insert({ user_id: userId, ...input })
    .select()
    .single()
  if (error) throw error
  return data as PracticalProject
}

export async function updateProject(
  projectId: string,
  patch: Partial<NewProjectInput>,
): Promise<void> {
  const { error } = await supabase.from('practical_projects').update(patch).eq('id', projectId)
  if (error) throw error
}

export async function deleteProject(projectId: string): Promise<void> {
  const { error } = await supabase.from('practical_projects').delete().eq('id', projectId)
  if (error) throw error
}
