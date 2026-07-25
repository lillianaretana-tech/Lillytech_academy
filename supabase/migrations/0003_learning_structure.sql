-- 0003_learning_structure.sql
-- Jerarquía: learning_paths → stages → courses → modules → lessons → lesson_resources

create table public.learning_paths (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  is_published boolean not null default false,
  order_index integer not null default 0,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger trg_learning_paths_updated_at
  before update on public.learning_paths
  for each row execute function public.set_updated_at();
create index idx_learning_paths_published on public.learning_paths(is_published);

create table public.stages (
  id uuid primary key default gen_random_uuid(),
  path_id uuid not null references public.learning_paths(id) on delete cascade,
  title text not null,
  description text,
  order_index integer not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger trg_stages_updated_at
  before update on public.stages
  for each row execute function public.set_updated_at();
create index idx_stages_path_id on public.stages(path_id);

create table public.courses (
  id uuid primary key default gen_random_uuid(),
  stage_id uuid not null references public.stages(id) on delete cascade,
  title text not null,
  description text,
  order_index integer not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger trg_courses_updated_at
  before update on public.courses
  for each row execute function public.set_updated_at();
create index idx_courses_stage_id on public.courses(stage_id);

create table public.modules (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references public.courses(id) on delete cascade,
  title text not null,
  description text,
  order_index integer not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger trg_modules_updated_at
  before update on public.modules
  for each row execute function public.set_updated_at();
create index idx_modules_course_id on public.modules(course_id);

create table public.lessons (
  id uuid primary key default gen_random_uuid(),
  module_id uuid not null references public.modules(id) on delete cascade,
  title text not null,
  summary text,
  objectives text,
  content text,
  example text,
  practical_application text,
  common_mistakes text,
  checklist text,
  estimated_minutes integer,
  level text,
  prerequisites text,
  order_index integer not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger trg_lessons_updated_at
  before update on public.lessons
  for each row execute function public.set_updated_at();
create index idx_lessons_module_id on public.lessons(module_id);
create index idx_lessons_published on public.lessons(is_published);

create table public.lesson_resources (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  title text not null,
  url text not null,
  order_index integer not null default 0,
  created_at timestamptz not null default now()
);
create index idx_lesson_resources_lesson_id on public.lesson_resources(lesson_id);
