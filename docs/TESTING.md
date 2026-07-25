# Pruebas

No hay suite automatizada en el MVP (no se justifica su costo todavía). Esta guía es para pruebas manuales — se completa a fondo en la Fase 7, pero podés usar esta checklist ya mismo después de aplicar las migraciones.

## Autenticación

- [ ] Registrar un usuario nuevo → se crea automáticamente su fila en `profiles` y su rol `student` en `user_roles`.
- [ ] Iniciar sesión con credenciales correctas → redirige a `/dashboard`.
- [ ] Iniciar sesión con credenciales incorrectas → muestra error, no rompe la app.
- [ ] Cerrar sesión → vuelve a `/login`, no se puede navegar a rutas protegidas.
- [ ] Solicitar recuperación de contraseña → no revela si el correo existe o no en el mensaje mostrado.
- [ ] Recargar la página estando logueada → la sesión persiste (no pide login de nuevo).

## Permisos (RLS)

- [ ] Un usuario `student` no puede ver `personal_notes`, `learning_questions`, `practical_projects` de otro usuario, ni siquiera manipulando la consulta desde el cliente.
- [ ] Un usuario `student` no puede insertar/editar/eliminar contenido académico (rutas, etapas, cursos, módulos, lecciones).
- [ ] Un usuario `student` no ve contenido con `is_published = false`.
- [ ] Un usuario con rol `admin` (asignado manualmente por SQL) sí puede ver y editar contenido no publicado, y ve el enlace "Administración" en el menú.
- [ ] Intentar asignarse el rol `admin` a uno mismo desde el cliente (sin ser ya admin) falla.

## Navegación

- [ ] Todos los enlaces del menú (Dashboard, Biblioteca, Proyectos, Notas, y Admin si corresponde) cargan sin error de consola.
- [ ] Una ruta que no existe muestra la página 404, no una pantalla en blanco.
- [ ] Entrar a `/admin` sin ser admin redirige a `/dashboard`, no muestra error feo.

## Responsive

- [ ] En escritorio se ve el sidebar fijo a la izquierda.
- [ ] En móvil (~375px de ancho) el sidebar se reemplaza por el botón "Menú" y el menú desplegable.
- [ ] Los formularios de login/recuperación son usables en pantalla chica sin scroll horizontal.

## Datos

- [ ] Después del seed, la ruta "Desarrollo de Aplicaciones LillyTech" aparece con sus 11 etapas.
- [ ] Las 3 lecciones de la Etapa 1 (Qué es una base de datos / Tablas, filas y columnas / Claves primarias) tienen contenido completo, no placeholder.
- [ ] Los cursos de las etapas 2 a 11 existen pero están marcados `is_published = false` — no deberían aparecer para un usuario `student` hasta que se publiquen con contenido real.
