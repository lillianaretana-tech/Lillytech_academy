# Base de datos

## Jerarquía académica

```
learning_paths → stages → courses → modules → lessons → exercises
                                              └→ lesson_resources
```

## Tablas

| Tabla | Propósito | Filas visibles para estudiante |
|---|---|---|
| `profiles` | Perfil ligado a `auth.users` | Solo la propia |
| `user_roles` | Rol admin/student por usuario | Solo el propio |
| `learning_paths` | Rutas de aprendizaje | Solo publicadas |
| `stages` | Etapas de una ruta | Solo publicadas |
| `courses` | Cursos de una etapa | Solo publicados |
| `modules` | Módulos de un curso | Solo publicados |
| `lessons` | Lecciones (contenido completo) | Solo publicadas |
| `lesson_resources` | Recursos/enlaces de una lección | Si la lección está publicada |
| `exercises` | Ejercicios de una lección | Si la lección está publicada |
| `exercise_responses` | Respuestas de la estudiante | Solo las propias |
| `enrollments` | Inscripción estudiante ↔ ruta | Solo las propias |
| `lesson_progress` | Avance por lección y usuario | Solo el propio |
| `personal_notes` | Notas por lección | Solo las propias |
| `learning_questions` | Dudas por lección | Solo las propias |
| `practical_projects` | Proyectos prácticos | Solo los propios |
| `project_lessons` | Relación proyecto ↔ lección | Solo si el proyecto es propio |
| `learning_activity` | Bitácora de eventos | Solo la propia |
| `certificates` | Certificados emitidos | Solo los propios |
| `application_settings` | Configuración general | Solo admin |
| `concepts` | Ficha de concepto (Biblioteca de Conceptos, v1.1+) | Solo publicados |
| `concept_relations` | Relación dirigida entre dos conceptos | Si el concepto origen está publicado |
| `concept_lessons` | Relación concepto ↔ lección | Si el concepto está publicado |
| `concept_projects` | Relación concepto ↔ proyecto práctico | Solo si el proyecto es propio |
| `concept_resources` | Recursos de un concepto | Si el concepto está publicado |
| `concept_notes` | Notas personales por concepto | Solo las propias |
| `concept_mastery` | Nivel de dominio personal por concepto (v1.3) | Solo el propio |

## Migraciones

Están en `supabase/migrations/`, numeradas y pensadas para correr en orden:

1. `0001_extensions_and_helpers.sql` — extensión pgcrypto + función `set_updated_at()`
2. `0002_profiles_and_roles.sql` — `profiles`, `user_roles`, alta automática al registrarse
3. `0003_learning_structure.sql` — jerarquía académica
4. `0004_exercises_and_progress.sql` — ejercicios, respuestas, inscripciones, progreso
5. `0005_notes_questions_projects.sql` — notas, dudas, proyectos prácticos
6. `0006_activity_certificates_settings.sql` — historial, certificados, configuración
7. `0007_rls_profiles_and_roles.sql` — función `is_admin()` + RLS de perfiles/roles
8. `0008_rls_learning_structure.sql` — RLS de la jerarquía académica
9. `0009_rls_exercises_and_progress.sql` — RLS de ejercicios/progreso
10. `0010_rls_notes_questions_projects.sql` — RLS de notas/dudas/proyectos
11. `0011_rls_activity_certificates_settings.sql` — RLS de historial/certificados/config
12. `0012_concepts.sql` — esquema de la Biblioteca de Conceptos (v1.1): `concepts`, relaciones, notas y nivel de dominio
13. `0013_rls_concepts.sql` — RLS de la Biblioteca de Conceptos

## Seed

En `supabase/seed/`, correr después de las migraciones:

1. `0001_seed_path_stages_courses.sql` — ruta + 11 etapas + 1 curso por etapa
2. `0002_seed_modules_and_lessons.sql` — módulos de ejemplo + 3 lecciones completas (Etapa 1)
3. `0003_seed_exercises.sql` — un ejercicio por cada una de las 3 lecciones
4. `0004_seed_first_concept.sql` — primer concepto real de la Biblioteca de Conceptos (v1.2)

## Cómo correrlo

Opción simple (SQL Editor de Supabase): pegar y ejecutar cada archivo de `migrations/` en orden, y después cada archivo de `seed/` en orden.

Opción CLI (si instalás Supabase CLI en tu máquina):

```bash
supabase link --project-ref rpvhdfvxroxdlagixupv
supabase db push
```

## Regenerar tipos TypeScript

Una vez aplicadas las migraciones:

```bash
npx supabase gen types typescript --project-id rpvhdfvxroxdlagixupv > src/types/database.types.ts
```

Esto reemplaza el archivo de tipos manual que se usó en la Fase 2.
