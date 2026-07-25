-- 0007_rls_profiles_and_roles.sql

-- Función SECURITY DEFINER: evita recursión de políticas al consultar
-- user_roles desde dentro de otras políticas (y desde la política de
-- user_roles sobre sí misma).
create or replace function public.is_admin(check_user_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.user_roles
    where user_id = check_user_id and role = 'admin'
  );
$$;

alter table public.profiles enable row level security;

create policy "profiles: select own"
  on public.profiles for select
  using (auth.uid() = id);

create policy "profiles: update own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy "profiles: admin select all"
  on public.profiles for select
  using (public.is_admin(auth.uid()));

alter table public.user_roles enable row level security;

create policy "user_roles: select own"
  on public.user_roles for select
  using (auth.uid() = user_id);

create policy "user_roles: admin select all"
  on public.user_roles for select
  using (public.is_admin(auth.uid()));

create policy "user_roles: admin manage"
  on public.user_roles for all
  using (public.is_admin(auth.uid()))
  with check (public.is_admin(auth.uid()));
