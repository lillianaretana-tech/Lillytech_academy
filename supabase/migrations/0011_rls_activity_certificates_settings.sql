-- 0011_rls_activity_certificates_settings.sql

alter table public.learning_activity enable row level security;
create policy "learning_activity: own select"
  on public.learning_activity for select
  using (auth.uid() = user_id or public.is_admin(auth.uid()));
create policy "learning_activity: own insert"
  on public.learning_activity for insert
  with check (auth.uid() = user_id);

alter table public.certificates enable row level security;
create policy "certificates: own select"
  on public.certificates for select
  using (auth.uid() = user_id or public.is_admin(auth.uid()));
-- Los certificados se emiten por lógica de la aplicación (o RPC) al
-- completar una ruta/etapa, no por escritura libre desde el cliente.
create policy "certificates: own insert"
  on public.certificates for insert
  with check (auth.uid() = user_id);

alter table public.application_settings enable row level security;
create policy "application_settings: admin all"
  on public.application_settings for all
  using (public.is_admin(auth.uid()))
  with check (public.is_admin(auth.uid()));
