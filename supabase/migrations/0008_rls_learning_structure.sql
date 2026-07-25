-- 0008_rls_learning_structure.sql
-- Regla general: contenido publicado es legible por cualquier usuario
-- autenticado; contenido no publicado y toda escritura, solo admin.

alter table public.learning_paths enable row level security;
create policy "learning_paths: read published"
  on public.learning_paths for select
  using (is_published = true or public.is_admin(auth.uid()));
create policy "learning_paths: admin write"
  on public.learning_paths for insert
  with check (public.is_admin(auth.uid()));
create policy "learning_paths: admin update"
  on public.learning_paths for update
  using (public.is_admin(auth.uid()))
  with check (public.is_admin(auth.uid()));
create policy "learning_paths: admin delete"
  on public.learning_paths for delete
  using (public.is_admin(auth.uid()));

alter table public.stages enable row level security;
create policy "stages: read published"
  on public.stages for select
  using (is_published = true or public.is_admin(auth.uid()));
create policy "stages: admin write"
  on public.stages for insert
  with check (public.is_admin(auth.uid()));
create policy "stages: admin update"
  on public.stages for update
  using (public.is_admin(auth.uid()))
  with check (public.is_admin(auth.uid()));
create policy "stages: admin delete"
  on public.stages for delete
  using (public.is_admin(auth.uid()));

alter table public.courses enable row level security;
create policy "courses: read published"
  on public.courses for select
  using (is_published = true or public.is_admin(auth.uid()));
create policy "courses: admin write"
  on public.courses for insert
  with check (public.is_admin(auth.uid()));
create policy "courses: admin update"
  on public.courses for update
  using (public.is_admin(auth.uid()))
  with check (public.is_admin(auth.uid()));
create policy "courses: admin delete"
  on public.courses for delete
  using (public.is_admin(auth.uid()));

alter table public.modules enable row level security;
create policy "modules: read published"
  on public.modules for select
  using (is_published = true or public.is_admin(auth.uid()));
create policy "modules: admin write"
  on public.modules for insert
  with check (public.is_admin(auth.uid()));
create policy "modules: admin update"
  on public.modules for update
  using (public.is_admin(auth.uid()))
  with check (public.is_admin(auth.uid()));
create policy "modules: admin delete"
  on public.modules for delete
  using (public.is_admin(auth.uid()));

alter table public.lessons enable row level security;
create policy "lessons: read published"
  on public.lessons for select
  using (is_published = true or public.is_admin(auth.uid()));
create policy "lessons: admin write"
  on public.lessons for insert
  with check (public.is_admin(auth.uid()));
create policy "lessons: admin update"
  on public.lessons for update
  using (public.is_admin(auth.uid()))
  with check (public.is_admin(auth.uid()));
create policy "lessons: admin delete"
  on public.lessons for delete
  using (public.is_admin(auth.uid()));

alter table public.lesson_resources enable row level security;
create policy "lesson_resources: read if lesson published"
  on public.lesson_resources for select
  using (
    public.is_admin(auth.uid())
    or exists (
      select 1 from public.lessons l
      where l.id = lesson_resources.lesson_id and l.is_published = true
    )
  );
create policy "lesson_resources: admin write"
  on public.lesson_resources for insert
  with check (public.is_admin(auth.uid()));
create policy "lesson_resources: admin update"
  on public.lesson_resources for update
  using (public.is_admin(auth.uid()))
  with check (public.is_admin(auth.uid()));
create policy "lesson_resources: admin delete"
  on public.lesson_resources for delete
  using (public.is_admin(auth.uid()));
