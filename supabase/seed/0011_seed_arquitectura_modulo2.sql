-- 0011_seed_arquitectura_modulo2.sql
-- Módulo 2 de la Etapa 4 (Arquitectura de aplicaciones): "Estado y sesión".

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '539e674d-6262-49af-a7e6-e2ea3f6f328a', id, 'Estado y sesión', 'Estado de la aplicación, sesiones, autenticación, autorización y flujo de datos — cómo la app recuerda quién sos y qué te muestra.', 2, true
from public.courses where title = 'Cómo se arma una aplicación real';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'dee409b6-b908-40ba-b82f-9fe465d9065f',
  '539e674d-6262-49af-a7e6-e2ea3f6f328a',
  'Estado de la aplicación',
  'Los datos que el frontend mantiene "en memoria" mientras lo usás — distintos de los datos guardados en la base de datos, y con una vida mucho más corta.',
  E'- Explicar qué es el estado de una aplicación frontend.\n- Distinguir entre estado local de un componente y estado compartido entre varias pantallas.\n- Identificar ejemplos de estado en esta Academy.',
  E'El estado de una aplicación es la información que el frontend guarda temporalmente mientras corre, en la memoria del navegador — no en la base de datos. Se pierde apenas cerrás la pestaña o recargás la página (a menos que se guarde explícitamente en otro lado, como localStorage o, en este proyecto, en la propia base de datos).\n\nEn React, el estado vive dentro de componentes, usando useState — por ejemplo, en LessonPage.tsx de esta Academy, el estado guarda temporalmente las notas cargadas, el texto que estás escribiendo en el campo de nueva nota, si se está guardando o no. Ese estado desaparece si salís de la lección y volvés a entrar — por eso, apenas se monta el componente, vuelve a pedir los datos reales a la base de datos.\n\nHay estado "local" (solo le importa a un componente específico, como el texto de un formulario mientras lo escribís) y estado "compartido" entre varias pantallas (como la sesión de la usuaria logueada, que necesitan conocer el sidebar, el guard de rutas, y cualquier pantalla que muestre el email). En esta Academy, ese estado compartido vive en el AuthProvider (contexto de React), no repetido en cada componente por separado.',
  E'Cuando escribís una nota nueva en LessonPage antes de guardarla, ese texto vive solo en el estado local del componente (useState) — si recargás la página en ese momento, se pierde, porque todavía no llegó a la base de datos. Recién al hacer clic en "Agregar nota" ese texto se convierte en un dato real, persistido.',
  E'Abrí src/pages/LessonPage.tsx y contá cuántas veces aparece useState — cada una es una pieza de estado distinta que el componente mantiene mientras está montado.',
  E'- Confundir estado (temporal, en memoria) con datos persistidos (guardados en la base de datos) — son cosas con vidas completamente distintas.\n- Duplicar estado que en realidad debería ser compartido (por ejemplo, cada componente manejando su propia copia de "quién está logueada" en vez de usar el contexto compartido).\n- Esperar que el estado sobreviva a un refresh de página sin haberlo guardado en ningún lado persistente.',
  E'- [ ] Puedo explicar qué es el estado de una aplicación con mis propias palabras.\n- [ ] Puedo distinguir estado local de estado compartido con un ejemplo de esta Academy.\n- [ ] Puedo predecir qué pasa con el estado de un formulario si recargás la página antes de guardar.',
  15, 'Fundamentos', 'JSON: el idioma común entre sistemas', 1, true
),
(
  'cd878bc3-0802-4a48-ad77-1317016081dc',
  '539e674d-6262-49af-a7e6-e2ea3f6f328a',
  'Sesiones: cómo la app recuerda que estás logueada',
  'Por qué no tenés que volver a escribir tu contraseña cada vez que recargás la página — y qué es exactamente lo que persiste entre una visita y otra.',
  E'- Explicar qué es una sesión y qué la diferencia del estado normal de la app.\n- Entender cómo Supabase Auth persiste la sesión entre recargas de página.\n- Reconocer qué pasa cuando una sesión expira o se cierra.',
  E'Una sesión es la prueba de que ya te autenticaste, guardada de forma que sobrevive a un refresh de página (a diferencia del estado normal, que ya vimos que se pierde). Técnicamente, es el JWT que ya estudiaste en la Etapa 3 — Supabase Auth lo guarda en el almacenamiento local del navegador automáticamente.\n\nEn esta Academy, el AuthProvider (src/features/auth/hooks/useAuth.tsx) llama a supabase.auth.getSession() apenas se monta la app — eso recupera la sesión guardada, si existe, sin que tengas que loguearte de nuevo. Si no hay sesión guardada (o expiró), getSession() devuelve null, y el ProtectedRoute te redirige a /login.\n\nUna sesión no dura para siempre: tiene una expiración, después de la cual Supabase Auth intenta renovarla automáticamente en segundo plano (mientras tengas conexión) usando un "refresh token" — vos no lo notás, simplemente seguís logueada. Si el refresh también falla (por ejemplo, si cerraste sesión explícitamente, o si pasó demasiado tiempo), ahí sí te pide loguearte de nuevo.',
  E'Cuando cerraste el Codespace y volviste horas después, no tuviste que volver a escribir tu email y contraseña en esta Academy — la sesión guardada en el navegador seguía siendo válida, y el AuthProvider la recuperó automáticamente al recargar.',
  E'Cerrá sesión desde el botón de esta Academy, y confirmá que te redirige a /login. Volvé a loguearte, y esta vez recargá la página (F5) sin cerrar sesión — confirmá que seguís logueada, sin que te pida las credenciales de nuevo.',
  E'- Pensar que "sesión" y "estado de React" son lo mismo — la sesión sobrevive a un refresh, el estado normal no.\n- No manejar el caso de sesión expirada en el código (esta Academy lo resuelve delegando en ProtectedRoute, que redirige a /login si session es null).\n- Asumir que cerrar la pestaña del navegador "cierra sesión" — no lo hace, la sesión persiste hasta que expire o hasta un signOut() explícito.',
  E'- [ ] Puedo explicar qué es una sesión y en qué se diferencia del estado normal.\n- [ ] Puedo explicar qué pasa cuando recargo la página estando logueada.\n- [ ] Probé cerrar sesión y confirmé la redirección a /login.',
  15, 'Fundamentos', 'Estado de la aplicación', 2, true
),
(
  '873e824c-8cb2-44eb-b855-a9f07c59c5dc',
  '539e674d-6262-49af-a7e6-e2ea3f6f328a',
  'Autenticación: probar quién sos',
  'La pregunta "¿sos quien decís ser?" — y por qué esta Academy nunca implementó esa lógica por su cuenta, sino que se la delegó completa a Supabase Auth.',
  E'- Definir autenticación con tus propias palabras.\n- Explicar por qué delegar la autenticación a un servicio especializado es una buena práctica, no un atajo.\n- Repasar el flujo completo de autenticación de esta Academy.',
  E'Autenticación es el proceso de verificar que alguien es quien dice ser — típicamente probando algo que solo esa persona debería saber (una contraseña) o tener (acceso a un correo, un teléfono).\n\nEsta Academy nunca implementó su propia lógica de "verificar contraseña" — hubiera significado guardar contraseñas de forma segura (con hashing correcto), manejar recuperación de contraseña, protección contra ataques de fuerza bruta, y mucho más. En cambio, delega todo esto a Supabase Auth, un servicio especializado y probado en producción por muchísimos proyectos.\n\nEl flujo completo en esta Academy: LoginPage.tsx recolecta email y contraseña → llama a signIn() del AuthProvider → que llama a supabase.auth.signInWithPassword() → Supabase Auth verifica las credenciales contra lo que guarda en auth.users → si son correctas, devuelve una sesión con JWT → el AuthProvider la guarda y la app entera reacciona (ProtectedRoute deja de redirigir a /login).\n\nEsto es una decisión de arquitectura importante: no reinventar la autenticación, delegarla a algo especializado, y enfocar el esfuerzo propio en la autorización (el siguiente tema), que sí es específica de cada aplicación.',
  E'Si esta Academy hubiera implementado su propia autenticación desde cero, cada uno de los riesgos de seguridad de manejar contraseñas (filtración, ataques de diccionario, recuperación insegura) sería un problema tuyo que resolver — con Supabase Auth, ese riesgo lo asume un equipo especializado que se dedica solo a eso.',
  E'Repasá src/features/auth/hooks/useAuth.tsx y encontrá la línea exacta donde se llama a supabase.auth.signInWithPassword — esa es la frontera exacta entre "tu código" y "el servicio de autenticación".',
  E'- Intentar implementar autenticación propia "para tener más control", subestimando la complejidad real de hacerlo de forma segura.\n- Confundir autenticación con autorización — probar quién sos no es lo mismo que decidir qué podés hacer (eso viene en la próxima lección).\n- No delegar en absoluto y guardar contraseñas en texto plano en una tabla propia — un error de seguridad grave y evitable.',
  E'- [ ] Puedo definir autenticación con mis propias palabras.\n- [ ] Puedo explicar por qué delegar en Supabase Auth es una decisión de arquitectura válida, no un atajo.\n- [ ] Puedo trazar el flujo completo desde el formulario de login hasta la sesión guardada.',
  15, 'Fundamentos', 'Sesiones: cómo la app recuerda que estás logueada', 3, true
),
(
  '41560c5d-e4b7-48bc-974e-bb86d1ac5ce3',
  '539e674d-6262-49af-a7e6-e2ea3f6f328a',
  'Autorización: qué podés hacer, ya sabiendo quién sos',
  'La pregunta que viene después de autenticación — y la que sí es específica de cada aplicación, por eso esta Academy la construyó a medida con RLS.',
  E'- Definir autorización y explicar en qué se diferencia de autenticación.\n- Identificar dónde vive la lógica de autorización en esta Academy.\n- Reconocer por qué autorización no se puede delegar de forma tan genérica como autenticación.',
  E'Si autenticación responde "¿sos quien decís ser?", autorización responde la pregunta siguiente: "ya sabiendo quién sos, ¿qué se te permite hacer?". Son dos preguntas distintas, y confundirlas es un error común: podés estar perfectamente autenticada (Supabase Auth confirmó que sos vos) y aun así no tener permiso para hacer algo específico (como editar una lección, si no sos admin).\n\nA diferencia de la autenticación, la autorización SÍ es específica de cada aplicación — no existe un servicio genérico de "autorización para cualquier app", porque las reglas dependen completamente de qué hace tu app. En esta Academy, la autorización vive principalmente en dos lugares:\n\n1. Las políticas RLS de Postgres — la capa real e infranqueable, la que decide qué filas puede leer o escribir cada quien, sin importar qué diga el frontend.\n2. El componente AdminRoute — una capa de conveniencia en el frontend, que redirige a alguien sin rol admin lejos de las pantallas de Administración, para una mejor experiencia (no como medida de seguridad real, esa la da RLS).\n\nEsta distinción entre "seguridad real" (RLS) y "conveniencia de interfaz" (AdminRoute) es la idea central de esta lección: si alguien sin rol admin lograra, de alguna forma, cargar el componente de Administración saltándose el guard del frontend, igual no podría escribir nada, porque RLS lo bloquearía en la base de datos.',
  E'AdminRoute redirige a una estudiante lejos de /admin si intenta entrar por la URL directamente — pero incluso si ese guard no existiera, la política lessons: admin write seguiría rechazando cualquier intento de esa estudiante de crear o editar una lección, porque la autorización real vive en la base de datos, no en el router de React.',
  E'Iniciá sesión con una cuenta que NO tenga rol admin (o revisá qué pasaría) e intentá entrar a /admin escribiendo la URL directo en el navegador. Confirmá que te redirige, y pensá qué pasaría si en cambio intentaras hacer un INSERT directo a la tabla lessons desde la consola del navegador.',
  E'- Confundir autenticación con autorización, tratándolas como si fueran el mismo paso.\n- Confiar en un guard de frontend (como AdminRoute) como si fuera la protección real, en vez de una simple conveniencia de UX.\n- No implementar autorización real (RLS) y depender solo de ocultar botones — la vulnerabilidad más común en apps mal arquitecturadas.',
  E'- [ ] Puedo explicar la diferencia entre autenticación y autorización, con un ejemplo propio.\n- [ ] Puedo señalar dónde vive la autorización real en esta Academy (no la de conveniencia de UI).\n- [ ] Entiendo por qué RLS es la protección real y AdminRoute es solo experiencia de usuario.',
  20, 'Intermedio', 'Autenticación: probar quién sos', 4, true
),
(
  '045a3004-98cd-4750-9ee6-68fcb5c9154a',
  '539e674d-6262-49af-a7e6-e2ea3f6f328a',
  'Flujo de datos: seguir un dato de punta a punta',
  'Cómo trazar el camino completo de un dato, desde que hacés clic hasta que queda guardado y vuelve a mostrarse — uniendo todo lo visto en este módulo.',
  E'- Trazar el flujo completo de un dato en una acción real de esta Academy.\n- Identificar cada capa por la que pasa: componente, servicio, API, RLS, base de datos, y de vuelta.\n- Usar este ejercicio como repaso integrador de toda la Etapa 4.',
  E'Esta lección no introduce ningún concepto nuevo — es un ejercicio de trazar, capa por capa, qué pasa exactamente cuando hacés clic en "Marcar como completada" en una lección de esta Academy:\n\n1. El componente LessonPage.tsx llama a handleMarkCompleted(), que ejecuta un handler local.\n2. Ese handler llama a setLessonStatus(user.id, lessonId, ''completed'') del servicio progress.service.ts.\n3. El servicio arma un pedido con supabase.from(''lesson_progress'').update({...}) — esto es la capa de API que ya viste.\n4. supabase-js convierte eso en un pedido HTTP hacia PostgREST.\n5. PostgREST recibe el pedido, y antes de tocar cualquier fila, Postgres evalúa la política RLS lesson_progress: own update — esto es autorización real, no confía en que el frontend "ya verificó" nada.\n6. Si la política lo permite, el UPDATE se ejecuta, y el trigger trg_lesson_progress_updated_at actualiza updated_at automáticamente.\n7. La función también llama a logActivity(), que hace otro pedido completo (mismo camino: servicio → API → RLS → base de datos) para insertar una fila en learning_activity.\n8. De vuelta en el frontend, el componente actualiza su estado local (setStatus(''completed'')) para reflejar el cambio en pantalla sin tener que recargar toda la página.\n\nSeguir este camino completo, capa por capa, es la mejor forma de entender cómo se conectan realmente frontend, backend (Supabase), autorización (RLS) y estado — todos los temas de este módulo, trabajando juntos en una sola acción.',
  E'Este mismo flujo (componente → servicio → API → RLS → base de datos → estado local actualizado) se repite, con variaciones, en cada acción de esta Academy: crear una nota, registrar una duda, cambiar el nivel de dominio de un concepto. Una vez que entendés un flujo completo, reconocés el patrón en todos los demás.',
  E'Elegí otra acción de esta Academy (por ejemplo, "crear una nota") y tratá de escribir vos misma, paso a paso, el mismo tipo de lista que se armó arriba para "marcar como completada".',
  E'- Pensar en el frontend y la base de datos como si estuvieran "directamente conectados", sin las capas intermedias (servicio, API, RLS) que realmente existen.\n- Saltarse mentalmente el paso de autorización al trazar un flujo, asumiendo que "si el frontend lo pidió, se hace" — RLS puede rechazarlo igual.\n- No notar que una sola acción de la usuaria (como completar una lección) puede disparar más de un flujo de datos completo (el UPDATE de progreso y el INSERT de actividad, en este caso).',
  E'- [ ] Puedo trazar de memoria el flujo completo de "marcar lección como completada".\n- [ ] Puedo identificar en qué paso exacto interviene la autorización (RLS).\n- [ ] Trazé por mi cuenta el flujo de otra acción distinta de esta Academy.',
  20, 'Intermedio', 'Autorización: qué podés hacer, ya sabiendo quién sos', 5, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  '33b76430-5ebd-4b51-8c8c-c1deae175b1b',
  'dee409b6-b908-40ba-b82f-9fe465d9065f',
  'Contá los useState de una página',
  'Abrí LessonPage.tsx y contá cuántas piezas de estado distintas maneja con useState. Anotá qué representa cada una.',
  'short_answer', 1
),
(
  '4a53fef8-6151-4b1e-a7ef-ea8672bf34d3',
  'cd878bc3-0802-4a48-ad77-1317016081dc',
  'Probá la persistencia de sesión',
  'Cerrá sesión, volvé a loguearte, y recargá la página sin cerrar sesión. Confirmá que seguís logueada y describí qué esperabas que pasara.',
  'short_answer', 1
),
(
  '1154de46-18bd-47ca-8802-d9166c431a6f',
  '873e824c-8cb2-44eb-b855-a9f07c59c5dc',
  'Encontrá la frontera de autenticación',
  'En useAuth.tsx, encontrá la línea exacta donde se llama a signInWithPassword y explicá qué pasa antes y después de esa línea.',
  'short_answer', 1
),
(
  '308a51be-c3f3-48d6-8bed-ee68344dbdc6',
  '41560c5d-e4b7-48bc-974e-bb86d1ac5ce3',
  'Distinguí autorización real de conveniencia de UI',
  'Explicá, con tus palabras, qué pasaría si AdminRoute no existiera pero las políticas RLS de admin sí. ¿La app seguiría siendo segura?',
  'short_answer', 1
),
(
  '8de6ef5e-a0e0-4e93-b62e-9351826f61a8',
  '045a3004-98cd-4750-9ee6-68fcb5c9154a',
  'Trazá tu propio flujo de datos',
  'Elegí una acción distinta de esta Academy (crear una nota, registrar una duda, cambiar nivel de dominio) y escribí el flujo completo, capa por capa, como se hizo en la lección para "marcar como completada".',
  'long_answer', 1
);
