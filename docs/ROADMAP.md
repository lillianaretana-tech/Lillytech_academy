# Roadmap

## Completado

- **Fase 1** — Diagnóstico y planificación (`IMPLEMENTATION_PLAN.md`)
- **Fase 2** — Base del proyecto: scaffold Vite+React+TS+Tailwind, auth, rutas protegidas, layout responsive
- **Fase 3** — Base de datos: 18 tablas, RLS completo, seed con ruta inicial + 3 lecciones reales

## Próximo

- **Fase 4** — Experiencia de estudiante: Dashboard funcional, Biblioteca navegable, vista de lección completa, notas, dudas, ejercicios, proyectos prácticos — todo conectado a Supabase real.
- **Fase 5** — Administración: panel admin con CRUD completo de contenido, orden, publicación, consulta de progreso.
- **Fase 6** — Certificados y actividad: historial de eventos, generación de certificados con código único, vista imprimible.
- **Fase 7** — Pruebas y documentación final.

## Después del MVP (fuera de alcance actual)

- Exportación de certificados a PDF real.
- Upload de archivos/capturas como evidencia de ejercicios (hoy solo enlace).
- Modo oscuro (la arquitectura de Tailwind ya lo deja preparado con `darkMode: 'class'`).
- Multiusuario/multiempresa real (hoy la app asume una sola estudiante-administradora, pero el modelo de datos ya soporta múltiples usuarios vía RLS).
- Contenido completo redactado para las 10 etapas restantes (hoy solo la Etapa 1 tiene lecciones completas; el resto tiene estructura de curso/módulo lista pero sin contenido).
