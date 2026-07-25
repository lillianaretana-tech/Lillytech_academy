-- 0010_rls_notes_questions_projects.sql

alter table public.personal_notes enable row level security;
create policy "personal_notes: own select"
  on public.personal_notes for select
  using (auth.uid() = user_id);
create policy "personal_notes: own insert"
  on public.personal_notes for insert
  with check (auth.uid() = user_id);
create policy "personal_notes: own update"
  on public.personal_notes for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
create policy "personal_notes: own delete"
  on public.personal_notes for delete
  using (auth.uid() = user_id);

alter table public.learning_questions enable row level security;
create policy "learning_questions: own select"
  on public.learning_questions for select
  using (auth.uid() = user_id);
create policy "learning_questions: own insert"
  on public.learning_questions for insert
  with check (auth.uid() = user_id);
create policy "learning_questions: own update"
  on public.learning_questions for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
create policy "learning_questions: own delete"
  on public.learning_questions for delete
  using (auth.uid() = user_id);

alter table public.practical_projects enable row level security;
create policy "practical_projects: own select"
  on public.practical_projects for select
  using (auth.uid() = user_id);
create policy "practical_projects: own insert"
  on public.practical_projects for insert
  with check (auth.uid() = user_id);
create policy "practical_projects: own update"
  on public.practical_projects for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
create policy "practical_projects: own delete"
  on public.practical_projects for delete
  using (auth.uid() = user_id);

alter table public.project_lessons enable row level security;
create policy "project_lessons: own select"
  on public.project_lessons for select
  using (
    exists (
      select 1 from public.practical_projects p
      where p.id = project_lessons.project_id and p.user_id = auth.uid()
    )
  );
create policy "project_lessons: own insert"
  on public.project_lessons for insert
  with check (
    exists (
      select 1 from public.practical_projects p
      where p.id = project_lessons.project_id and p.user_id = auth.uid()
    )
  );
create policy "project_lessons: own delete"
  on public.project_lessons for delete
  using (
    exists (
      select 1 from public.practical_projects p
      where p.id = project_lessons.project_id and p.user_id = auth.uid()
    )
  );
