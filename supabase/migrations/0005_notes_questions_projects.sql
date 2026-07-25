-- 0005_notes_questions_projects.sql

create table public.personal_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  content text not null,
  is_important boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger trg_personal_notes_updated_at
  before update on public.personal_notes
  for each row execute function public.set_updated_at();
create index idx_personal_notes_user_id on public.personal_notes(user_id);
create index idx_personal_notes_lesson_id on public.personal_notes(lesson_id);

create type public.question_status as enum ('pending', 'resolved');

create table public.learning_questions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  question text not null,
  context text,
  status public.question_status not null default 'pending',
  answer_found text,
  resolved_at timestamptz,
  created_at timestamptz not null default now()
);
create index idx_learning_questions_user_id on public.learning_questions(user_id);
create index idx_learning_questions_lesson_id on public.learning_questions(lesson_id);

create type public.project_status as enum ('planned', 'in_progress', 'completed', 'on_hold');

create table public.practical_projects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  description text,
  status public.project_status not null default 'planned',
  technologies text[],
  problem_solved text,
  learnings text,
  repo_url text,
  app_url text,
  started_at date,
  finished_at date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger trg_practical_projects_updated_at
  before update on public.practical_projects
  for each row execute function public.set_updated_at();
create index idx_practical_projects_user_id on public.practical_projects(user_id);

create table public.project_lessons (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.practical_projects(id) on delete cascade,
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  unique (project_id, lesson_id)
);
create index idx_project_lessons_project_id on public.project_lessons(project_id);
