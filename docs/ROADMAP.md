# Roadmap

## Completado

- **Fase 1** — Diagnóstico y planificación (`IMPLEMENTATION_PLAN.md`)
- **Fase 2** — Base del proyecto: scaffold Vite+React+TS+Tailwind, auth, rutas protegidas, layout responsive
- **Fase 3** — Base de datos: 18 tablas, RLS completo, seed con ruta inicial + 3 lecciones reales
- **Fase 4** — Experiencia de estudiante: Dashboard con progreso real, Biblioteca navegable (ruta → etapa → curso → módulo → lección), vista de lección completa (contenido, ejercicios, notas, dudas, marcar completada), Notas con búsqueda, Proyectos prácticos con CRUD. Se agregó también la pantalla de registro (`/signup`) que había quedado pendiente en la Fase 2.
- **Fase 5** — Administración: CRUD completo de rutas/etapas/cursos/módulos (crear, renombrar, publicar/despublicar, eliminar con confirmación) directo desde `/admin`, con árbol desplegable. Las lecciones se crean rápido desde el árbol y se editan a fondo en `/admin/lessons/:id` (todos los campos de contenido). Vista de progreso de estudiantes en `/admin/progress`.

## Próximo

- **Fase 6** — Certificados y actividad: historial de eventos, generación de certificados con código único, vista imprimible.
- **Fase 6** — Certificados y actividad: historial de eventos, generación de certificados con código único, vista imprimible.
- **Fase 7** — Pruebas y documentación final.

## Después del MVP (fuera de alcance actual)

- Exportación de certificados a PDF real.
- Upload de archivos/capturas como evidencia de ejercicios (hoy solo enlace).
- Modo oscuro (la arquitectura de Tailwind ya lo deja preparado con `darkMode: 'class'`).
- Multiusuario/multiempresa real (hoy la app asume una sola estudiante-administradora, pero el modelo de datos ya soporta múltiples usuarios vía RLS).
- Contenido completo redactado para las 10 etapas restantes (hoy solo la Etapa 1 tiene lecciones completas; el resto tiene estructura de curso/módulo lista pero sin contenido).
