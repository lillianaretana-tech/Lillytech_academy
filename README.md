# LillyTech Learning Academy

Academia personal de aprendizaje para LillyTech: rutas, etapas, cursos, módulos y lecciones con progreso, notas, dudas, ejercicios, proyectos prácticos y certificados internos.

**Estado actual: v1.6 completa — toda la estructura del plan evolutivo está construida.** Buscador global (`/search`, accesible desde cualquier pantalla) sobre conceptos, lecciones, notas y proyectos. Dashboard ampliado con indicadores de aprendizaje (conceptos aprendidos, dudas resueltas, notas creadas, proyectos, progreso por etapa). De acá en más, el trabajo que sigue es cargar contenido real — ver `docs/PLAN_EVOLUTIVO.md` para la visión futura (v2/v3, Asistente de Aprendizaje IA) cuando haya volumen suficiente.

## Requisitos

- Node.js 18+
- Una cuenta de Supabase (ya tenés el proyecto conectado)

## Instalación local

```bash
npm install
cp .env.example .env   # y pega tus valores reales (ver abajo)
npm run dev
```

## Variables de entorno

Creá un archivo `.env` en la raíz (nunca se sube a Git — está en `.gitignore`) con:

```
VITE_SUPABASE_URL=https://tu-proyecto.supabase.co
VITE_SUPABASE_ANON_KEY=tu-anon-key-publica
```

La anon key es pública por diseño (se usa en el frontend), pero igual no se commitea para no acoplar el repo a un proyecto Supabase específico. La seguridad real de los datos la da Row Level Security (RLS) en la base, no el ocultamiento de esta key — ver `docs/SECURITY.md` cuando exista (Fase 3).

## Configurar la base de datos

1. Entrá al SQL Editor de tu proyecto Supabase (`rpvhdfvxroxdlagixupv`).
2. Corré, en orden, cada archivo de `supabase/migrations/` (del `0001` al `0013`).
3. Corré, en orden, cada archivo de `supabase/seed/` (del `0001` al `0004`).
   A partir de `0005`, revisá primero el encabezado de cada archivo — algunos quedan documentados ahí pero ya fueron cargados a mano desde `/admin` y no deben volver a correrse sobre una base de datos que ya tiene ese contenido (solo harían falta si reconstruís la base desde cero).
4. Para que tu propio usuario tenga permisos de administradora, después de registrarte en la app corré:
   ```sql
   insert into public.user_roles (user_id, role)
   values ('<tu-user-id-de-auth.users>', 'admin');
   ```
   (Tu `user_id` lo ves en Authentication → Users dentro de Supabase.)

Detalle completo en `docs/DATABASE.md`.

## Scripts

- `npm run dev` — entorno de desarrollo
- `npm run build` — build de producción (verifica TypeScript primero)
- `npm run preview` — sirve el build localmente
- `npm run lint` — ESLint

## Estructura del proyecto

```
src/
├── components/     # UI reutilizable (aún vacío, se llena en Fase 4)
├── pages/          # Vistas de ruta
├── layouts/        # AppLayout (sidebar + topbar), AuthLayout
├── features/       # Lógica agrupada por dominio (hoy: auth)
├── hooks/          # Hooks compartidos
├── services/       # Acceso a Supabase por dominio (se llena en Fase 3/4)
├── lib/            # Cliente de Supabase
├── types/          # Tipos del modelo de datos
├── utils/          # Utilidades
├── routes/         # Definición de rutas + guards
└── styles/         # Tailwind + tokens de marca
supabase/
├── migrations/     # SQL versionado (Fase 3)
└── seed/           # Datos iniciales (Fase 3)
docs/               # Documentación técnica (se completa por fase)
```

## Roles

MVP con dos roles posibles por usuario, vía tabla `user_roles` (Fase 3): `admin` y `student`. La misma persona puede tener ambos.

## Despliegue

Pensado para Vercel: build estático de Vite. Falta configurar cuando definas el dominio/subdominio.

## Roadmap de fases

Ver `IMPLEMENTATION_PLAN.md` en la raíz del repo para el plan completo y el orden de fases.

## Limitaciones actuales (Fase 2)

- No hay tablas en Supabase todavía — el login funciona contra Auth, pero la consulta a `user_roles` en `useAuth` va a fallar en silencio hasta la Fase 3 (es esperado, no es un bug).
- No hay contenido académico real todavía.
- Panel admin es un placeholder.
