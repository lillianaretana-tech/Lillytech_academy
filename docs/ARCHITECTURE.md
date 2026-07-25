# Arquitectura

## Visión general

```
┌─────────────────┐        ┌──────────────────────┐
│  React + TS      │  fetch │  Supabase             │
│  (Vite, Vercel)  │──────▶│  Postgres + Auth + RLS │
└─────────────────┘        └──────────────────────┘
```

Sin backend propio: Supabase cubre base de datos, autenticación y autorización (vía RLS). No hace falta un servidor intermedio para el MVP.

## Frontend

- **Vite** como bundler — build rápido, sin configuración innecesaria.
- **React + TypeScript** — tipado en todo el flujo de datos, desde Supabase hasta los componentes.
- **React Router** — enrutamiento con dos guards: `ProtectedRoute` (requiere sesión) y `AdminRoute` (requiere rol admin).
- **Tailwind CSS** — utilidades + tokens de marca (Tinta & Latón) definidos en `tailwind.config.js`.

## Organización por dominio, no por tipo técnico

`src/features/` agrupa lógica por dominio (ej. `auth`), en vez de tener toda la lógica de negocio mezclada en componentes o en un solo archivo gigante. A medida que se agreguen `lessons`, `notes`, `projects`, etc. en las próximas fases, cada uno tendrá su propia carpeta con hooks y llamadas a Supabase relacionadas.

## Estado

- **Estado de sesión**: contexto de React (`AuthProvider` en `features/auth/hooks/useAuth.tsx`), sin librería externa de estado global — no hace falta para este tamaño de app.
- **Estado remoto** (rutas, lecciones, progreso): se consulta directo a Supabase desde hooks por dominio. No hay capa de caché adicional en el MVP; se puede evaluar algo como TanStack Query si el volumen de datos lo justifica más adelante.

## Flujo de autorización

1. El usuario inicia sesión → Supabase Auth devuelve una sesión con JWT.
2. El JWT viaja en cada request a Postgres vía PostgREST.
3. Postgres evalúa las políticas RLS usando `auth.uid()` extraído del JWT.
4. El frontend nunca decide qué datos puede ver el usuario — solo pide, y la base de datos filtra. La UI oculta botones de admin por comodidad visual, pero la seguridad real está en las políticas (ver `SECURITY.md`).

## Por qué no hay backend propio

El MVP no necesita lógica de servidor que no pueda expresarse como política RLS o función de Postgres (RPC). Si en el futuro aparece una necesidad real de lógica privilegiada (por ejemplo, generar el PDF de un certificado con la service role key), eso se resuelve con una Supabase Edge Function — no con un servidor Node adicional.
