# Seguridad

## Principio general

RLS (Row Level Security) activado en todas las tablas desde la primera migración. No hay ninguna política `USING (true)` sin justificación — donde el contenido es público (rutas/etapas/cursos/módulos/lecciones publicadas), la condición es explícita: `is_published = true OR is_admin(auth.uid())`.

## Función `is_admin()`

Las políticas que necesitan verificar si el usuario es admin usan la función `public.is_admin(uuid)`, marcada `SECURITY DEFINER`. Esto evita:

- Recursión infinita al consultar `user_roles` desde dentro de una política sobre la propia `user_roles`.
- Repetir la misma subconsulta en cada política (más fácil de mantener y de auditar).

## Reglas por tipo de dato

- **Contenido académico** (rutas, etapas, cursos, módulos, lecciones, recursos, ejercicios): lectura pública para autenticados solo si `is_published = true`; toda escritura reservada a admin.
- **Progreso y datos personales** (`lesson_progress`, `personal_notes`, `learning_questions`, `exercise_responses`, `practical_projects`, `enrollments`, `learning_activity`, `certificates`): cada usuario solo puede ver y modificar sus propias filas (`auth.uid() = user_id`). Admin puede leer (no escribir) donde tiene sentido auditar progreso.
- **Configuración de la app** (`application_settings`): exclusiva de admin.

## Claves y secretos

- La **anon key** de Supabase es pública por diseño — se usa en el frontend, y la seguridad real la da RLS, no el secreto de esa key.
- La **service role key** nunca se usa en el frontend. Este proyecto no la necesita para el MVP; si en el futuro hace falta (por ejemplo, para una función administrativa que deba saltarse RLS), debe vivir solo en un backend/Edge Function, nunca en `src/`.
- El archivo `.env` está en `.gitignore` — nunca se sube al repo, aunque su contenido no sea "secreto" en sentido estricto.

## Registro y roles

Al registrarse, el trigger `handle_new_user()` crea automáticamente el perfil y asigna el rol `student`. El rol `admin` **nunca** se asigna automáticamente — se otorga manualmente corriendo SQL directo:

```sql
insert into public.user_roles (user_id, role)
values ('<tu-user-id>', 'admin');
```

Esto es intencional: es la única acción de "dar privilegios de administración" en todo el sistema, y queda fuera del flujo automático a propósito.

## Qué falta (no es parte del MVP)

- No hay límite de intentos de login (rate limiting) configurado explícitamente — Supabase Auth ya trae protecciones básicas, pero no se ajustó nada específico.
- No hay auditoría detallada de cambios en contenido académico (quién editó qué lección y cuándo) más allá de `updated_at`. Se puede agregar más adelante con una tabla de auditoría si hace falta.
