-- 0004_exercises_and_progress.sql

create type public.exercise_type as enum (
  'short_answer', 'long_answer', 'checklist', 'practical', 'evidence_link'
);

create table public.exercises (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  title text not null,
  instructions text not null,
  type public.exercise_type not null default 'short_answer',
  order_index integer not null default 0,
  created_at timestamptz not null default now()
);
create index idx_exercises_lesson_id on public.exercises(lesson_id);

create table public.exercise_responses (
  id uuid primary key default gen_random_uuid(),
  exercise_id uuid not null references public.exercises(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  response_text text,
  evidence_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (exercise_id, user_id)
);
create trigger trg_exercise_responses_updated_at
  before update on public.exercise_responses
  for each row execute function public.set_updated_at();
create index idx_exercise_responses_user_id on public.exercise_responses(user_id);

create table public.enrollments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  path_id uuid not null references public.learning_paths(id) on delete cascade,
  enrolled_at timestamptz not null default now(),
  unique (user_id, path_id)
);
create index idx_enrollments_user_id on public.enrollments(user_id);

create type public.lesson_status as enum (
  'not_started', 'in_progress', 'completed', 'needs_review'
);

create table public.lesson_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  status public.lesson_status not null default 'not_started',
  started_at timestamptz,
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  unique (user_id, lesson_id)
);
create trigger trg_lesson_progress_updated_at
  before update on public.lesson_progress
  for each row execute function public.set_updated_at();
create index idx_lesson_progress_user_id on public.lesson_progress(user_id);
create index idx_lesson_progress_lesson_id on public.lesson_progress(lesson_id);
