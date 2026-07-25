-- 0013_rls_concepts.sql
-- Mismo criterio que el resto: contenido publicado legible por
-- cualquier autenticada, escritura solo admin. Notas y nivel de
-- dominio son personales, mismo patrón que personal_notes/lesson_progress.

alter table public.concepts enable row level security;
create policy "concepts: read published"
  on public.concepts for select
  using (is_published = true or public.is_admin(auth.uid()));
create policy "concepts: admin write"
  on public.concepts for insert
  with check (public.is_admin(auth.uid()));
create policy "concepts: admin update"
  on public.concepts for update
  using (public.is_admin(auth.uid()))
  with check (public.is_admin(auth.uid()));
create policy "concepts: admin delete"
  on public.concepts for delete
  using (public.is_admin(auth.uid()));

alter table public.concept_relations enable row level security;
create policy "concept_relations: read if concepts published"
  on public.concept_relations for select
  using (
    public.is_admin(auth.uid())
    or exists (
      select 1 from public.concepts c
      where c.id = concept_relations.from_concept_id and c.is_published = true
    )
  );
create policy "concept_relations: admin write"
  on public.concept_relations for insert
  with check (public.is_admin(auth.uid()));
create policy "concept_relations: admin delete"
  on public.concept_relations for delete
  using (public.is_admin(auth.uid()));

alter table public.concept_lessons enable row level security;
create policy "concept_lessons: read if concept published"
  on public.concept_lessons for select
  using (
    public.is_admin(auth.uid())
    or exists (
      select 1 from public.concepts c
      where c.id = concept_lessons.concept_id and c.is_published = true
    )
  );
create policy "concept_lessons: admin write"
  on public.concept_lessons for insert
  with check (public.is_admin(auth.uid()));
create policy "concept_lessons: admin delete"
  on public.concept_lessons for delete
  using (public.is_admin(auth.uid()));

alter table public.concept_projects enable row level security;
create policy "concept_projects: own select"
  on public.concept_projects for select
  using (
    exists (
      select 1 from public.practical_projects p
      where p.id = concept_projects.project_id and p.user_id = auth.uid()
    )
  );
create policy "concept_projects: own insert"
  on public.concept_projects for insert
  with check (
    exists (
      select 1 from public.practical_projects p
      where p.id = concept_projects.project_id and p.user_id = auth.uid()
    )
  );
create policy "concept_projects: own delete"
  on public.concept_projects for delete
  using (
    exists (
      select 1 from public.practical_projects p
      where p.id = concept_projects.project_id and p.user_id = auth.uid()
    )
  );

alter table public.concept_resources enable row level security;
create policy "concept_resources: read if concept published"
  on public.concept_resources for select
  using (
    public.is_admin(auth.uid())
    or exists (
      select 1 from public.concepts c
      where c.id = concept_resources.concept_id and c.is_published = true
    )
  );
create policy "concept_resources: admin write"
  on public.concept_resources for insert
  with check (public.is_admin(auth.uid()));
create policy "concept_resources: admin delete"
  on public.concept_resources for delete
  using (public.is_admin(auth.uid()));

alter table public.concept_notes enable row level security;
create policy "concept_notes: own select"
  on public.concept_notes for select
  using (auth.uid() = user_id);
create policy "concept_notes: own insert"
  on public.concept_notes for insert
  with check (auth.uid() = user_id);
create policy "concept_notes: own update"
  on public.concept_notes for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
create policy "concept_notes: own delete"
  on public.concept_notes for delete
  using (auth.uid() = user_id);

alter table public.concept_mastery enable row level security;
create policy "concept_mastery: own select"
  on public.concept_mastery for select
  using (auth.uid() = user_id or public.is_admin(auth.uid()));
create policy "concept_mastery: own insert"
  on public.concept_mastery for insert
  with check (auth.uid() = user_id);
create policy "concept_mastery: own update"
  on public.concept_mastery for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
