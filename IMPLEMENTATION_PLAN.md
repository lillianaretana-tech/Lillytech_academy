# LillyTech Learning Academy — Plan de Implementación

**Fase actual:** 1 — Diagnóstico y Planificación
**Fecha:** 2026-07-24
**Estado:** Pendiente de revisión y autorización para pasar a Fase 2

---

## 1. Diagnóstico del entorno de trabajo

El directorio de este contenedor está **vacío** — no hay proyecto previo, ni repo clonado, ni archivos de configuración de Vite/React/Supabase. Esto es un sandbox limpio, no tiene visibilidad de tus repos reales en GitHub (por ejemplo `LillianaRV_automatizaciones-html` u otros).

Dos caminos posibles:

1. **Trabajar aquí, en este sandbox**, generar el proyecto completo, y al final entregarte los archivos para que tú los subas a un repo nuevo en tu GitHub.
2. **Trabajar directamente sobre un repo tuyo** — pero para eso necesitaría que me pases el contenido del repo (o lo clonaras tú y me compartieras los archivos), ya que no tengo acceso a red/GitHub desde este contenedor.

Dado que no tengo acceso a internet en este entorno (sin egress), la opción realista es la 1: construyo todo el código aquí, te lo entrego como archivos descargables, y tú lo subes a un repo nuevo (`lillytech-learning-academy` o el nombre que prefieras) y conectas Vercel/Supabase desde tu lado.

**No voy a tocar ningún proyecto Supabase existente tuyo.** No tengo tus credenciales ni las voy a inventar — cuando llegue el momento de correr migraciones reales, te las entrego como archivos `.sql` para que tú las apliques en el proyecto Supabase que decidas (nuevo, dedicado a la Academy).

---

## 2. Arquitectura técnica propuesta

- **Frontend:** React + TypeScript + Vite
- **Estilos:** Tailwind CSS (rápido de mantener, encaja con "sin exceso de animaciones" y con tu identidad LillyTech vía tokens de color/tipografía)
- **Enrutamiento:** React Router
- **Backend:** Supabase (Postgres + Auth + RLS + Storage para futuros PDFs de certificados)
- **Estado remoto:** Supabase JS client + hooks propios (sin Redux, no hace falta para este MVP)
- **Despliegue:** Compatible con Vercel (build estático de Vite)
- **Autenticación:** Supabase Auth (email + password para el MVP; magic link se puede evaluar después)

No se añade backend propio (Node/Express) — Supabase cubre todo lo necesario (DB, Auth, RLS, RPC si hace falta lógica en servidor).

---

## 3. Estructura de carpetas propuesta

```
lillytech-learning-academy/
├── src/
│   ├── components/       # UI reutilizable (Button, Card, ProgressBar, Modal...)
│   ├── pages/             # Vistas de ruta (Dashboard, Library, LessonView, AdminPaths...)
│   ├── layouts/           # AppLayout (sidebar + topbar), AuthLayout
│   ├── features/          # Lógica agrupada por dominio: auth, learning-paths, lessons,
│   │                       #   notes, questions, exercises, projects, certificates, admin
│   ├── hooks/              # useAuth, useProgress, useLessons, etc.
│   ├── services/           # Acceso a Supabase (paths.service.ts, lessons.service.ts...)
│   ├── lib/                 # supabaseClient.ts, constantes
│   ├── types/               # Tipos TS generados/manuales del modelo de datos
│   ├── utils/                # formatDate, calcProgress, etc.
│   ├── routes/               # Definición de rutas + guards (ProtectedRoute, AdminRoute)
│   └── styles/                 # Tailwind config, tokens LillyTech
├── supabase/
│   ├── migrations/            # SQL versionado
│   └── seed/                   # Datos iniciales (ruta + etapas + lecciones)
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DATABASE.md
│   ├── SECURITY.md
│   ├── ROADMAP.md
│   └── TESTING.md
├── .env.example
├── README.md
└── IMPLEMENTATION_PLAN.md
```

Cada feature (`features/lessons`, `features/notes`, etc.) agrupa sus propios componentes, hooks y llamadas a Supabase relacionadas — así se evita un `App.tsx` gigante y los archivos quedan por dominio, no por tipo técnico únicamente.

---

## 4. Modelo de datos inicial (resumen — el detalle completo va en `docs/DATABASE.md` y en las migraciones SQL)

Jerarquía académica:
```
learning_paths → stages → courses → modules → lessons → exercises
```

Tablas del MVP:

| Tabla | Propósito |
|---|---|
| `profiles` | Datos de perfil ligados a `auth.users` |
| `user_roles` | Rol(es) por usuario: admin / student |
| `learning_paths` | Rutas de aprendizaje (ej. "Desarrollo de Aplicaciones LillyTech") |
| `stages` | Etapas dentro de una ruta |
| `courses` | Cursos dentro de una etapa |
| `modules` | Módulos dentro de un curso |
| `lessons` | Lecciones dentro de un módulo (contenido completo) |
| `lesson_resources` | Enlaces/recursos adjuntos a una lección |
| `exercises` | Ejercicios asociados a una lección |
| `exercise_responses` | Respuestas de la estudiante a un ejercicio |
| `enrollments` | Relación estudiante ↔ ruta (inscripción) |
| `lesson_progress` | Estado de avance por lección y por usuario |
| `personal_notes` | Notas personales por lección |
| `learning_questions` | Dudas registradas por lección |
| `practical_projects` | Proyectos prácticos de la estudiante |
| `project_lessons` | Relación N:N proyecto ↔ lecciones |
| `learning_activity` | Historial/bitácora de eventos |
| `certificates` | Certificados generados |
| `application_settings` | Configuración general de la app |

Todas con `id UUID DEFAULT gen_random_uuid()`, `created_at`, `updated_at` (con trigger), `created_by` donde aplique, banderas de `is_active`/`is_published` donde aplique, campos `order_index` para ordenar contenido, FKs con `ON DELETE` bien definido, e índices sobre las FKs más consultadas (`lesson_progress(user_id, lesson_id)`, etc.).

RLS: activado desde la primera migración, sin `USING (true)` salvo en contenido publicado de lectura pública para usuarios autenticados (rutas/etapas/cursos/módulos/lecciones `is_published = true`). Todo el detalle de políticas va en `docs/SECURITY.md`.

---

## 5. Orden exacto de implementación

1. **Fase 2 — Base del proyecto:** scaffold Vite+React+TS, Tailwind, cliente Supabase, rutas, layout general (sidebar + topbar), autenticación (login/logout/recuperación), `ProtectedRoute`.
2. **Fase 3 — Base de datos:** migraciones SQL completas de las 18 tablas, triggers `updated_at`, políticas RLS, seed con la ruta inicial (11 etapas, 1 curso por etapa, módulos de ejemplo, 3 lecciones completas de la Etapa 1).
3. **Fase 4 — Experiencia de estudiante:** Dashboard, Biblioteca, vista de lección completa, notas, dudas, ejercicios, proyectos prácticos.
4. **Fase 5 — Administración:** panel admin con CRUD de rutas/etapas/cursos/módulos/lecciones, orden, publicar/despublicar, consulta de progreso.
5. **Fase 6 — Certificados y actividad:** historial, generación de certificados con código único, vista imprimible básica.
6. **Fase 7 — Pruebas y documentación:** pruebas manuales de auth/permisos/navegación/responsive, validación de RLS, documentación final.

Cada fase se entrega, se revisa contigo, y solo se avanza a la siguiente con tu ok — como pediste en las reglas de trabajo.

---

## 6. Decisiones que requieren tu autorización

- **Proyecto Supabase:** ¿creas uno nuevo dedicado a la Academy, o quieres que use un nombre/convención específica? Yo no puedo crear el proyecto por ti (no tengo tus credenciales ni acceso), así que en el momento de configurar `.env` vas a necesitar pegar tu propia `SUPABASE_URL` y `SUPABASE_ANON_KEY`.
- **Repositorio Git:** ¿nombre exacto del repo en tu GitHub? ¿lo creas tú vacío y yo te entrego el código para que lo subas, o prefieres otro flujo?
- **Autenticación:** ¿solo email/password para el MVP, o quieres dejar la puerta abierta a login con Google desde ya (aunque no se implemente todavía)?
- **Dominio/Vercel:** ¿ya tienes idea de subdominio (algo tipo `academy.lillytech.com`) o eso se define después?
- **Nombre visual/branding:** ¿reutilizamos exactamente la paleta Tinta & Latón (Fraunces + IBM Plex Sans, brass/ink/sage/rust/paper) que ya usas en el portal LillyTech, o quieres algo levemente distinto para diferenciar la Academy visualmente de los otros productos?

No voy a asumir nada de esto — cuando lleguemos a cada punto, me detengo y pregunto antes de decidir por ti.

---

## 7. Riesgos y simplificaciones sugeridas para el MVP

- **Certificados en PDF real:** en el MVP solo se genera el *registro* del certificado (código, fecha, %). La exportación a PDF queda para una fase posterior — ya lo dice el spec, lo confirmo para que no se te olvide al revisar el resultado.
- **Archivos/capturas como evidencia de ejercicios:** en el MVP solo se soporta enlace a evidencia (URL), no upload de archivos. Subir a Supabase Storage es sencillo de añadir después, pero suma complejidad de entrada (validación de tipo/tamaño, políticas de storage) que no es crítica para validar el flujo de aprendizaje.
- **Roles:** en el MVP la misma persona (tú) tendrá ambos roles simultáneamente vía `user_roles`. La separación completa admin/estudiante con distintos usuarios se prueba mejor una vez el flujo esté validado contigo.
- **Multiusuario/SaaS:** la arquitectura queda preparada (RLS por `user_id`, tablas ya normalizadas) pero no se implementa multiempresa ni facturación en este MVP — eso es Fase 10 del roadmap conceptual, no de este entregable.
- **Riesgo real más grande:** el volumen de contenido pedido (11 etapas con listas extensas de subtemas) es mucho para "seed real, no Lorem Ipsum". Voy a cargar contenido completo y real solo para las 3 lecciones pedidas explícitamente (Etapa 1) y crear cursos/módulos de ejemplo para el resto de etapas con estructura correcta pero contenido placeholder claramente marcado — así no se sacrifica calidad por volumen. El resto de lecciones se van llenando progresivamente, ya sea por ti manualmente desde el panel admin o pidiéndome que las redacte por etapa.

---

## 8. Siguiente paso

Quedo aquí, en Fase 1, esperando tu revisión. Si me confirmas los puntos de la sección 6 (o me dices "seguí con lo por defecto donde no importa"), paso a Fase 2 y empiezo a generar el scaffold del proyecto.
