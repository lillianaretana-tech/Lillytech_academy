-- 0006_activity_certificates_settings.sql

create table public.learning_activity (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  event_type text not null,
  metadata jsonb,
  created_at timestamptz not null default now()
);
create index idx_learning_activity_user_id on public.learning_activity(user_id);
create index idx_learning_activity_created_at on public.learning_activity(created_at desc);

create table public.certificates (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  path_id uuid references public.learning_paths(id) on delete set null,
  stage_id uuid references public.stages(id) on delete set null,
  code text not null unique,
  completion_percentage numeric(5,2) not null check (completion_percentage between 0 and 100),
  issued_at timestamptz not null default now(),
  constraint certificates_path_or_stage check (path_id is not null or stage_id is not null)
);
create index idx_certificates_user_id on public.certificates(user_id);

create table public.application_settings (
  key text primary key,
  value text not null,
  updated_at timestamptz not null default now()
);
create trigger trg_application_settings_updated_at
  before update on public.application_settings
  for each row execute function public.set_updated_at();
