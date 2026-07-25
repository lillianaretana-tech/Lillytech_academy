-- 0009_rls_exercises_and_progress.sql

alter table public.exercises enable row level security;
create policy "exercises: read if lesson published"
  on public.exercises for select
  using (
    public.is_admin(auth.uid())
    or exists (
      select 1 from public.lessons l
      where l.id = exercises.lesson_id and l.is_published = true
    )
  );
create policy "exercises: admin write"
  on public.exercises for insert
  with check (public.is_admin(auth.uid()));
create policy "exercises: admin update"
  on public.exercises for update
  using (public.is_admin(auth.uid()))
  with check (public.is_admin(auth.uid()));
create policy "exercises: admin delete"
  on public.exercises for delete
  using (public.is_admin(auth.uid()));

alter table public.exercise_responses enable row level security;
create policy "exercise_responses: own select"
  on public.exercise_responses for select
  using (auth.uid() = user_id or public.is_admin(auth.uid()));
create policy "exercise_responses: own insert"
  on public.exercise_responses for insert
  with check (auth.uid() = user_id);
create policy "exercise_responses: own update"
  on public.exercise_responses for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
create policy "exercise_responses: own delete"
  on public.exercise_responses for delete
  using (auth.uid() = user_id);

alter table public.enrollments enable row level security;
create policy "enrollments: own select"
  on public.enrollments for select
  using (auth.uid() = user_id or public.is_admin(auth.uid()));
create policy "enrollments: own insert"
  on public.enrollments for insert
  with check (auth.uid() = user_id);
create policy "enrollments: own delete"
  on public.enrollments for delete
  using (auth.uid() = user_id);

alter table public.lesson_progress enable row level security;
create policy "lesson_progress: own select"
  on public.lesson_progress for select
  using (auth.uid() = user_id or public.is_admin(auth.uid()));
create policy "lesson_progress: own insert"
  on public.lesson_progress for insert
  with check (auth.uid() = user_id);
create policy "lesson_progress: own update"
  on public.lesson_progress for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
