-- 0001_extensions_and_helpers.sql
-- Extensiones necesarias y función reutilizable para mantener updated_at.

create extension if not exists "pgcrypto";

-- Función genérica que se usa como trigger BEFORE UPDATE en todas las tablas
-- que tienen updated_at, para no repetir la lógica en cada una.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
