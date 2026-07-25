-- 0012_concepts.sql
-- Fundamento de la Biblioteca de Conceptos (v1.1). Sin UI todavía —
-- esta migración solo prepara el terreno para v1.2 (vista completa) y
-- v1.3 (nivel de dominio). El contenido de un concepto es compartido
-- (como una lección: lo redacta admin, lo lee cualquier autenticada);
-- el nivel de dominio es personal de cada usuaria, por eso vive en una
-- tabla separada (concept_mastery), nunca como columna de concepts.

create table public.concepts (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique,
  what_is text,
  why_it_exists text,
  problem_it_solves text,
  when_to_use text,
  common_mistakes text,
  is_published boolean not null default false,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger trg_concepts_updated_at
  before update on public.concepts
  for each row execute function public.set_updated_at();
create index idx_concepts_published on public.concepts(is_published);
create index idx_concepts_slug on public.concepts(slug);

-- Relaciones concepto ↔ concepto (para "relaciones con otros conceptos").
-- Guardamos el par ordenado (from < to no se fuerza acá a propósito:
-- la relación puede tener una dirección semántica, ej. "RLS depende de
-- políticas", así que se modela dirigida, no simétrica).
create table public.concept_relations (
  id uuid primary key default gen_random_uuid(),
  from_concept_id uuid not null references public.concepts(id) on delete cascade,
  to_concept_id uuid not null references public.concepts(id) on delete cascade,
  relation_type text, -- ej. "depende de", "se relaciona con", "es un caso de"
  created_at timestamptz not null default now(),
  unique (from_concept_id, to_concept_id),
  constraint concept_relations_not_self check (from_concept_id <> to_concept_id)
);
create index idx_concept_relations_from on public.concept_relations(from_concept_id);
create index idx_concept_relations_to on public.concept_relations(to_concept_id);

-- Concepto ↔ lección (para "lecciones relacionadas" — y el lado inverso,
-- que una lección enlace al concepto en vez de reexplicarlo).
create table public.concept_lessons (
  id uuid primary key default gen_random_uuid(),
  concept_id uuid not null references public.concepts(id) on delete cascade,
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  unique (concept_id, lesson_id)
);
create index idx_concept_lessons_concept on public.concept_lessons(concept_id);
create index idx_concept_lessons_lesson on public.concept_lessons(lesson_id);

-- Concepto ↔ proyecto práctico (para "proyectos relacionados").
create table public.concept_projects (
  id uuid primary key default gen_random_uuid(),
  concept_id uuid not null references public.concepts(id) on delete cascade,
  project_id uuid not null references public.practical_projects(id) on delete cascade,
  unique (concept_id, project_id)
);
create index idx_concept_projects_concept on public.concept_projects(concept_id);

-- Recursos de un concepto (mismo patrón que lesson_resources).
create table public.concept_resources (
  id uuid primary key default gen_random_uuid(),
  concept_id uuid not null references public.concepts(id) on delete cascade,
  title text not null,
  url text not null,
  order_index integer not null default 0,
  created_at timestamptz not null default now()
);
create index idx_concept_resources_concept on public.concept_resources(concept_id);

-- Notas personales por concepto (mismo patrón que personal_notes por
-- lección, pero separado: un concepto no es una lección y no queremos
-- forzar lesson_id a ser nullable en una tabla que ya está en uso).
create table public.concept_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  concept_id uuid not null references public.concepts(id) on delete cascade,
  content text not null,
  is_important boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger trg_concept_notes_updated_at
  before update on public.concept_notes
  for each row execute function public.set_updated_at();
create index idx_concept_notes_user on public.concept_notes(user_id);
create index idx_concept_notes_concept on public.concept_notes(concept_id);

-- Nivel de dominio — PERSONAL de cada usuaria sobre cada concepto.
-- No es una propiedad del contenido (por eso no vive en `concepts`).
create type public.mastery_level as enum (
  'unknown',       -- No lo conozco
  'understand',    -- Lo entiendo
  'can_explain',   -- Lo puedo explicar
  'can_apply',     -- Lo puedo aplicar
  'can_teach'      -- Lo podría enseñar
);

create table public.concept_mastery (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  concept_id uuid not null references public.concepts(id) on delete cascade,
  level public.mastery_level not null default 'unknown',
  updated_at timestamptz not null default now(),
  unique (user_id, concept_id)
);
create trigger trg_concept_mastery_updated_at
  before update on public.concept_mastery
  for each row execute function public.set_updated_at();
create index idx_concept_mastery_user on public.concept_mastery(user_id);
