// Tipos manuales iniciales del modelo de datos.
// En la Fase 3, tras crear las migraciones reales, esto se puede regenerar con:
//   npx supabase gen types typescript --project-id <tu-project-id> > src/types/database.types.ts
// Por ahora se mantiene a mano para poder tipar el resto del scaffold.

export type AppRole = 'admin' | 'student'
export type LessonStatus = 'not_started' | 'in_progress' | 'completed' | 'needs_review'
export type ProjectStatus = 'planned' | 'in_progress' | 'completed' | 'on_hold'
export type QuestionStatus = 'pending' | 'resolved'

export interface Profile {
  id: string
  full_name: string | null
  avatar_url: string | null
  created_at: string
  updated_at: string
}

export interface UserRole {
  id: string
  user_id: string
  role: AppRole
  created_at: string
}

export interface LearningPath {
  id: string
  title: string
  description: string | null
  is_published: boolean
  order_index: number
  created_by: string | null
  created_at: string
  updated_at: string
}

export interface Stage {
  id: string
  path_id: string
  title: string
  description: string | null
  order_index: number
  is_published: boolean
  created_at: string
  updated_at: string
}

export interface Course {
  id: string
  stage_id: string
  title: string
  description: string | null
  order_index: number
  is_published: boolean
  created_at: string
  updated_at: string
}

export interface CourseModule {
  id: string
  course_id: string
  title: string
  description: string | null
  order_index: number
  is_published: boolean
  created_at: string
  updated_at: string
}

export interface Lesson {
  id: string
  module_id: string
  title: string
  summary: string | null
  objectives: string | null
  content: string | null
  example: string | null
  practical_application: string | null
  common_mistakes: string | null
  checklist: string | null
  estimated_minutes: number | null
  level: string | null
  prerequisites: string | null
  order_index: number
  is_published: boolean
  created_at: string
  updated_at: string
}

export interface LessonResource {
  id: string
  lesson_id: string
  title: string
  url: string
  order_index: number
  created_at: string
}

export interface Exercise {
  id: string
  lesson_id: string
  title: string
  instructions: string
  type: 'short_answer' | 'long_answer' | 'checklist' | 'practical' | 'evidence_link'
  order_index: number
  created_at: string
}

export interface ExerciseResponse {
  id: string
  exercise_id: string
  user_id: string
  response_text: string | null
  evidence_url: string | null
  created_at: string
  updated_at: string
}

export interface Enrollment {
  id: string
  user_id: string
  path_id: string
  enrolled_at: string
}

export interface LessonProgressRow {
  id: string
  user_id: string
  lesson_id: string
  status: LessonStatus
  started_at: string | null
  completed_at: string | null
  updated_at: string
}

export interface PersonalNote {
  id: string
  user_id: string
  lesson_id: string
  content: string
  is_important: boolean
  created_at: string
  updated_at: string
}

export interface LearningQuestion {
  id: string
  user_id: string
  lesson_id: string
  question: string
  context: string | null
  status: QuestionStatus
  answer_found: string | null
  resolved_at: string | null
  created_at: string
}

export interface PracticalProject {
  id: string
  user_id: string
  name: string
  description: string | null
  status: ProjectStatus
  technologies: string[] | null
  problem_solved: string | null
  learnings: string | null
  repo_url: string | null
  app_url: string | null
  started_at: string | null
  finished_at: string | null
  created_at: string
  updated_at: string
}

export interface ProjectLesson {
  id: string
  project_id: string
  lesson_id: string
}

export interface LearningActivity {
  id: string
  user_id: string
  event_type: string
  metadata: Record<string, unknown> | null
  created_at: string
}

export interface Certificate {
  id: string
  user_id: string
  path_id: string | null
  stage_id: string | null
  code: string
  completion_percentage: number
  issued_at: string
}

export interface ApplicationSetting {
  key: string
  value: string
  updated_at: string
}

export type MasteryLevel = 'unknown' | 'understand' | 'can_explain' | 'can_apply' | 'can_teach'

export interface Concept {
  id: string
  title: string
  slug: string
  what_is: string | null
  why_it_exists: string | null
  problem_it_solves: string | null
  when_to_use: string | null
  common_mistakes: string | null
  is_published: boolean
  created_by: string | null
  created_at: string
  updated_at: string
}

export interface ConceptRelation {
  id: string
  from_concept_id: string
  to_concept_id: string
  relation_type: string | null
  created_at: string
}

export interface ConceptLesson {
  id: string
  concept_id: string
  lesson_id: string
}

export interface ConceptProject {
  id: string
  concept_id: string
  project_id: string
}

export interface ConceptResource {
  id: string
  concept_id: string
  title: string
  url: string
  order_index: number
  created_at: string
}

export interface ConceptNote {
  id: string
  user_id: string
  concept_id: string
  content: string
  is_important: boolean
  created_at: string
  updated_at: string
}

export interface ConceptMastery {
  id: string
  user_id: string
  concept_id: string
  level: MasteryLevel
  updated_at: string
}

// Placeholder mínimo del tipo Database para el cliente de Supabase.
// Se reemplaza por el tipo generado automáticamente en la Fase 3.
export interface Database {
  public: {
    Tables: Record<string, { Row: Record<string, unknown> }>
  }
}
