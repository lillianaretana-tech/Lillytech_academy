-- 0022_seed_apis_modulo1.sql
-- Módulo 1 de la Etapa 8 (APIs y automatización): "Cómo hablan los sistemas".
-- Nota: "Qué es una API" ya está cubierto en Etapa 4 — se enlaza, no se duplica.

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '50bc3e99-0efd-40d8-a451-b3563794c7d3', id, 'Cómo hablan los sistemas', 'REST y métodos HTTP — el vocabulario común que ya usás cada vez que esta Academy habla con Supabase.', 1, true
from public.courses where title = 'APIs, webhooks y Make en la práctica';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '93ae864e-00fc-435a-86b1-1f68d4eb708f',
  '50bc3e99-0efd-40d8-a451-b3563794c7d3',
  'REST: un estilo común para diseñar APIs',
  'Las convenciones que hacen que la API de Supabase (y la de casi todo internet) se sienta predecible, aunque nunca hayas leído su documentación completa.',
  E'- Explicar qué es REST y qué problema resuelve como convención.\n- Identificar los recursos (URLs) que ya usa la API de esta Academy.\n- Reconocer por qué PostgREST genera una API "RESTful" automáticamente.',
  E'REST (Representational State Transfer) no es una tecnología ni una librería — es un estilo, un conjunto de convenciones para diseñar APIs de forma predecible. La idea central: cada URL representa un "recurso" (una cosa, como una lección o un concepto), y usás verbos HTTP estándar para operar sobre ese recurso, en vez de inventar una URL distinta para cada acción posible.\n\nEsta Academy usa una API REST sin que hayas tenido que diseñarla vos misma: PostgREST (la capa de API automática de Supabase) genera un endpoint por cada tabla siguiendo exactamente estas convenciones. La tabla lessons queda expuesta como el recurso /lessons, y las acciones sobre ella (leer, crear, modificar, borrar) se hacen con verbos HTTP distintos sobre esa misma URL, no con URLs separadas como /getLessons, /createLesson, /deleteLesson.\n\nEsto es lo que hace que aprender la API de un proyecto Supabase nuevo sea rápido: si entendés REST una vez, ya sabés más o menos qué esperar de cualquier tabla nueva, sin tener que leer documentación específica para cada una.',
  E'Cuando supabase-js hace supabase.from(''lessons'').select(), por debajo eso se traduce a un pedido GET hacia algo como https://tu-proyecto.supabase.co/rest/v1/lessons — el nombre de la tabla se convierte literalmente en el recurso de la URL, siguiendo la convención REST.',
  E'Con las herramientas de desarrollador abiertas (pestaña Network), navegá por la Biblioteca de esta Academy y encontrá la URL exacta de un pedido a la tabla lessons. Confirmá que el nombre de la tabla aparece directo en la URL.',
  E'- Pensar que REST es un protocolo o tecnología específica — es un estilo de convenciones, implementable en cualquier lenguaje o herramienta.\n- Diseñar APIs con URLs por acción (/getLessons, /createLesson) en vez de por recurso (/lessons con distintos verbos) — funciona, pero no sigue la convención REST y es menos predecible para quien la consume.\n- No aprovechar que, al seguir REST, la API se vuelve más fácil de aprender para cualquiera familiarizado con la convención.',
  E'- [ ] Puedo explicar qué es REST como conjunto de convenciones, no como tecnología.\n- [ ] Puedo encontrar la URL de un recurso real de esta Academy en la pestaña Network.\n- [ ] Puedo explicar por qué PostgREST genera una API REST automáticamente para cada tabla.',
  15, 'Intermedio', 'Seguridad proporcional al riesgo: cierre de la Etapa 7', 1, true
),
(
  '7ebceaa8-cf91-4f55-86d2-55b7b42bf67e',
  '50bc3e99-0efd-40d8-a451-b3563794c7d3',
  'Métodos HTTP: los verbos de la conversación',
  'GET, POST, PATCH, DELETE — los cuatro verbos que ya usás sin pensarlo cada vez que leés, creás, modificás o borrás algo en esta Academy.',
  E'- Explicar qué representa cada método HTTP principal.\n- Relacionar cada operación de supabase-js con su método HTTP correspondiente.\n- Reconocer qué método corresponde a una acción específica antes de mirarlo en la documentación.',
  E'HTTP define varios "métodos" (o verbos) que indican qué tipo de operación se quiere hacer sobre un recurso. Los cuatro que más vas a ver:\n\n- GET: leer datos, sin modificar nada. Cada .select() de esta Academy genera un GET.\n- POST: crear algo nuevo. Cada .insert() genera un POST.\n- PATCH (o PUT): modificar algo que ya existe. Cada .update() genera un PATCH.\n- DELETE: eliminar algo. Cada .delete() genera un DELETE.\n\nEsta correspondencia no es casualidad — es exactamente cómo PostgREST traduce las operaciones de supabase-js a pedidos HTTP reales. Cuando en admin.service.ts llamás a adminDeleteLesson(), por debajo eso termina siendo un pedido DELETE hacia /rest/v1/lessons?id=eq.algún-id.\n\nUna propiedad importante de GET: se espera que sea "seguro" — no debería tener efectos secundarios que cambien datos. Por eso RLS trata las políticas de SELECT de forma separada de las de INSERT/UPDATE/DELETE: leer y escribir son operaciones con implicaciones de seguridad distintas, y los métodos HTTP reflejan exactamente esa distinción.',
  E'Cuando marcás una lección como completada en esta Academy, la operación real es un PATCH (porque setLessonStatus hace un .update() sobre una fila existente) — no un POST, porque no estás creando una fila nueva, estás modificando el registro de progreso que ya existía.',
  E'Con la pestaña Network abierta, completá una lección de esta Academy y buscá el pedido correspondiente. Confirmá que el método que aparece es PATCH, no POST ni GET.',
  E'- Usar GET para algo que modifica datos — rompe la expectativa de que GET es "seguro" y puede generar errores sutiles con cachés o reintentos automáticos.\n- Confundir POST (crear) con PATCH (modificar) — son operaciones con intención distinta, aunque ambas "cambian" datos.\n- No revisar el método real de un pedido al diagnosticar un problema, perdiendo información que ayudaría a entender qué operación falló exactamente.',
  E'- [ ] Puedo nombrar los 4 métodos HTTP principales y qué representa cada uno.\n- [ ] Puedo relacionar cada método con su operación equivalente de supabase-js.\n- [ ] Confirmé, en la pestaña Network, el método real usado al completar una lección.',
  15, 'Intermedio', 'REST: un estilo común para diseñar APIs', 2, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'ee5ce365-1d94-4fe0-8bbe-c8a98d5e593a',
  '93ae864e-00fc-435a-86b1-1f68d4eb708f',
  'Encontrá un recurso REST real',
  'Con la pestaña Network abierta, navegá la Biblioteca y anotá la URL exacta de un pedido a la tabla lessons.',
  'evidence_link', 1
),
(
  'f6919009-a9f5-45ac-99bd-a99f91bead4b',
  '7ebceaa8-cf91-4f55-86d2-55b7b42bf67e',
  'Confirmá el método de un PATCH real',
  'Completá una lección y confirmá, en la pestaña Network, que el pedido usa método PATCH.',
  'evidence_link', 1
);
