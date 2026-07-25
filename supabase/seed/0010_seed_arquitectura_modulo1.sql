-- 0010_seed_arquitectura_modulo1.sql
-- Módulo 1 de la Etapa 4 (Arquitectura de aplicaciones): "Las piezas de una aplicación".

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '7c412c24-6391-499d-8250-43c8e641561a', id, 'Las piezas de una aplicación', 'Frontend, backend, base de datos, API y JSON — los bloques básicos, con esta misma Academy como ejemplo de cada uno.', 1, true
from public.courses where title = 'Cómo se arma una aplicación real';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'aa317157-f6c9-4ef7-a97e-a1a12f06ff9b',
  '7c412c24-6391-499d-8250-43c8e641561a',
  'Frontend: lo que la usuaria ve y toca',
  'La parte de una aplicación que corre en el navegador de quien la usa — la que arma la interfaz, reacciona a clics, y le pide datos a alguien más cuando los necesita.',
  E'- Definir qué es el frontend con tus propias palabras.\n- Identificar las tecnologías de frontend usadas en esta Academy.\n- Distinguir qué decisiones le corresponden al frontend y cuáles no.',
  E'El frontend es la parte de una aplicación que corre directamente en el navegador (o el teléfono) de quien la usa. Es responsable de: mostrar la interfaz, capturar lo que la persona hace (clics, texto escrito), y reaccionar mostrando cambios — pero, en una arquitectura bien hecha, NO es responsable de decidir qué datos son válidos ni quién puede ver qué (eso es autorización, y vive del lado del servidor/base de datos, como ya viste con RLS).\n\nEsta Academy usa React + TypeScript + Tailwind como stack de frontend, corriendo dentro de Vite. Cada archivo en src/pages/ es una pantalla; src/layouts/ arma la estructura general (sidebar, topbar); src/components/ (hoy casi vacío) sería para piezas reutilizables entre pantallas.\n\nUna forma útil de pensar el frontend: es una "ventana" hacia los datos reales, que viven en otro lado (la base de datos). El frontend pide, muestra, y vuelve a pedir cuando algo cambia — pero la fuente de verdad nunca es el frontend mismo.',
  E'Cuando abrís la Biblioteca de esta Academy, el componente LibraryPage.tsx arma toda la interfaz (etapas desplegables, buscador, badges de estado) pero no decide qué lecciones existen — eso lo pide a Supabase con getPathTree(), y solo muestra lo que le llega de vuelta.',
  E'Abrí src/pages/DashboardPage.tsx en tu Codespace y contá cuántas líneas son "mostrar cosas en pantalla" (JSX) versus cuántas son lógica de negocio real — vas a notar que la mayoría de la lógica pesada vive en los servicios (src/services/), no en el componente de la página.',
  E'- Poner lógica de negocio importante (como decidir si alguien puede ver un dato) solo en el frontend — cualquiera puede saltarse esa validación con las herramientas de desarrollador.\n- Confundir "se ve bien en la pantalla" con "está bien hecho" — el frontend puede verse perfecto y estar mal arquitecturado por debajo.\n- Pensar que el frontend "sabe" cosas que en realidad solo está mostrando porque se las pidió a otro sistema.',
  E'- [ ] Puedo definir qué es el frontend sin usar la palabra "interfaz" en la definición.\n- [ ] Puedo nombrar las tecnologías de frontend que usa esta Academy.\n- [ ] Puedo explicar por qué la autorización no debería vivir solo en el frontend.',
  15, 'Fundamentos', 'Variables de entorno: configuración que no vive en el código', 1, true
),
(
  'cebc02c6-8d2c-42ea-9b5d-88538613c460',
  '7c412c24-6391-499d-8250-43c8e641561a',
  'Backend: quién decide de verdad',
  'La parte de una aplicación que aplica las reglas reales — y por qué esta Academy casi no tiene backend propio, y aun así funciona seguro.',
  E'- Definir qué es el backend y qué responsabilidades le corresponden.\n- Explicar por qué esta Academy no tiene un servidor Node/Express propio.\n- Reconocer qué partes de Supabase están cumpliendo el rol de backend acá.',
  E'El backend es la parte de una aplicación que corre en un servidor (no en el navegador de la usuaria), y que es responsable de aplicar las reglas que sí importan: qué datos son válidos, quién puede ver o modificar qué, y la lógica de negocio central.\n\nMuchas aplicaciones tienen un backend "a medida" — un servidor Node.js, Python, o similar, escrito específicamente para esa app. Esta Academy NO tiene eso: no hay ningún servidor propio corriendo código tuyo. En cambio, Supabase cumple el rol de backend de forma genérica: PostgREST expone automáticamente cada tabla como API, y las políticas RLS son literalmente las "reglas de negocio" aplicadas al nivel de la base de datos, en vez de en un servidor intermedio escrito a mano.\n\nEsto no es una simplificación insegura — es una arquitectura válida y cada vez más común (a veces llamada "backend as a service" o BaaS). La diferencia con un backend tradicional es dónde vive la lógica: en vez de código de servidor que vos escribís y mantenés, es configuración declarativa (políticas SQL) que la base de datos misma hace cumplir.',
  E'Cuando una estudiante intenta editar una lección sin ser admin, no hay ningún código de "backend" tuyo que la detenga y le diga que no puede — es la política lessons: admin update, evaluada directamente por Postgres, la que rechaza el UPDATE antes de que llegue a tocar ninguna fila.',
  E'Repasá la carpeta de este proyecto: buscá si existe algún archivo tipo server.js, app.py, o una carpeta /api con lógica de servidor propia. No vas a encontrar ninguno — confirmá que efectivamente toda la "lógica de backend" vive en las migraciones SQL (funciones, triggers, políticas).',
  E'- Pensar que "no tener backend propio" significa "no tener backend" — Supabase SÍ cumple ese rol, solo que de forma distinta a un servidor tradicional.\n- Poner lógica de negocio crítica en el frontend "porque no hay backend a mano" — la respuesta correcta es una política RLS o una función RPC, no una validación de React.\n- Subestimar cuánta lógica real ya vive en las 13 migraciones de esta Academy, por no llamarla "backend" explícitamente.',
  E'- [ ] Puedo definir qué es el backend y qué responsabilidades le corresponden.\n- [ ] Puedo explicar por qué esta Academy no necesita un servidor Node/Express propio.\n- [ ] Puedo señalar qué parte de Supabase cumple cada responsabilidad típica de un backend.',
  15, 'Fundamentos', 'Frontend: lo que la usuaria ve y toca', 2, true
),
(
  'eb792e9f-7045-451b-a30d-e53aca1f706c',
  '7c412c24-6391-499d-8250-43c8e641561a',
  'Base de datos: la única fuente de verdad',
  'Por qué, entre frontend, backend y base de datos, la base de datos es la pieza que decide qué es verdad cuando hay dudas.',
  E'- Explicar por qué la base de datos es "la fuente de verdad" en una arquitectura típica.\n- Reconocer qué pasa cuando frontend y base de datos "no están de acuerdo".\n- Repasar cómo esto se conecta con lo ya visto de bases de datos y SQL.',
  E'Ya estudiaste en profundidad qué es una base de datos (Etapa 1) y cómo consultarla (Etapa 2) — esta lección es sobre su ROL dentro de la arquitectura completa, no sobre su funcionamiento interno.\n\nEn cualquier aplicación con más de una capa (frontend + backend, o frontend + Supabase como en este caso), puede pasar que el frontend "crea" algo que en realidad no es cierto — por ejemplo, si tu app mostrara el Dashboard con datos guardados en el estado de React desde hace un rato, pero mientras tanto la base de datos cambió (otra pestaña completó una lección). La base de datos es la única fuente de verdad: si hay una discrepancia entre lo que el frontend "cree" y lo que dice la base de datos, gana la base de datos, siempre.\n\nPor eso el patrón correcto es: el frontend nunca "inventa" ni "calcula" datos que en realidad deberían venir de una consulta real — refleja lo que la base de datos dice, y cuando algo cambia, vuelve a preguntar (o usa Realtime, que ya viste, para enterarse sola).',
  E'Si abrís esta Academy en dos pestañas del navegador, completás una lección en una, y volvés a la otra sin refrescar, el Dashboard de la segunda pestaña seguiría mostrando el número viejo hasta que vuelvas a cargar esa pantalla — porque el estado de React en esa pestaña quedó desactualizado respecto a la base de datos real. Esto no es un bug: es la naturaleza de "la base de datos es la fuente de verdad, el frontend refleja con cierto retraso".',
  E'Abrí dos pestañas con esta Academy logueada, completá una lección en una pestaña, y confirmá en la otra que el Dashboard no cambia hasta que lo recargues — eso demuestra en vivo la lección de esta página.',
  E'- Guardar en el frontend un dato "calculado" que después se desincroniza de la base de datos real, sin ningún mecanismo para refrescarlo.\n- Confiar en el estado de React como si fuera la fuente de verdad, cuando en realidad es solo una copia temporal de lo que decía la base de datos en el último momento en que se consultó.\n- No distinguir entre "el frontend muestra algo distinto" (posible desactualización normal) y "la base de datos tiene el dato mal" (un problema real de datos).',
  E'- [ ] Puedo explicar por qué la base de datos es la fuente de verdad, no el frontend.\n- [ ] Puedo predecir qué pasaría si dos pestañas del navegador muestran datos distintos temporalmente.\n- [ ] Puedo conectar esta idea con lo ya aprendido sobre bases de datos en la Etapa 1.',
  10, 'Fundamentos', 'Backend: quién decide de verdad', 3, true
),
(
  'e9830423-385c-4247-adbb-f3efda959f1f',
  '7c412c24-6391-499d-8250-43c8e641561a',
  'API: el contrato entre frontend y datos',
  'Cómo el frontend le pide cosas a la base de datos sin tener que "hablar SQL" directamente — y por qué eso es justo lo que hace supabase-js por vos.',
  E'- Definir qué es una API con tus propias palabras.\n- Explicar por qué el frontend nunca ejecuta SQL directo contra la base de datos.\n- Reconocer la API automática que Supabase genera para cada tabla.',
  E'Una API (interfaz de programación de aplicaciones) es un "contrato" que define cómo dos sistemas se comunican — qué se le puede pedir a quién, con qué formato, y qué se recibe de vuelta. El frontend nunca escribe SQL directo contra la base de datos (ni debería poder hacerlo) — en cambio, hace pedidos a través de una API, que internamente sí sabe traducir eso a SQL.\n\nEn esta Academy, cuando escribís supabase.from(''lessons'').select(''*'').eq(''is_published'', true), no estás escribiendo SQL — estás usando la librería supabase-js, que arma un pedido HTTP hacia la API automática que PostgREST genera para cada tabla de tu proyecto. PostgREST recibe ese pedido, lo traduce a SQL real (aplicando también las políticas RLS correspondientes), y te devuelve el resultado como JSON.\n\nEsta capa de API es justamente lo que hace posible que el frontend nunca necesite (ni pueda) ejecutar comandos SQL arbitrarios contra tu base de datos — solo puede hacer las operaciones que la API expone, filtradas siempre por lo que RLS permite.',
  E'Cuando en el SQL Editor corriste SELECT * FROM concepts;, eso fue SQL directo, con tu identidad de administradora del proyecto. Cuando tu app hace supabase.from(''concepts'').select(''*'') desde el navegador de una estudiante, eso pasa por la API con la identidad de esa usuaria — dos caminos completamente distintos hacia el mismo dato, con protecciones distintas.',
  E'Abrí las herramientas de desarrollador de tu navegador (F12), pestaña Network, mientras navegás por la Biblioteca de esta Academy — vas a ver pedidos HTTP reales hacia tu proyecto Supabase, con las respuestas en formato JSON.',
  E'- Pensar que supabase-js "es magia" en vez de reconocerlo como una capa de API sobre HTTP y SQL reales, visibles si mirás la pestaña Network.\n- Confundir la API automática de PostgREST con un backend a medida — expone operaciones genéricas (select, insert, update, delete) filtradas por RLS, no lógica de negocio custom (para eso están las funciones RPC).\n- Intentar ejecutar SQL directo desde el frontend — la API no lo permite, y es una protección de seguridad, no una limitación a evitar.',
  E'- [ ] Puedo definir qué es una API con mis propias palabras.\n- [ ] Puedo explicar por qué el frontend nunca ejecuta SQL directo.\n- [ ] Confirmé, mirando la pestaña Network del navegador, un pedido real hacia la API de Supabase.',
  15, 'Fundamentos', 'Base de datos: la única fuente de verdad', 4, true
),
(
  '761c99dd-90d1-4725-907c-451580437bb4',
  '7c412c24-6391-499d-8250-43c8e641561a',
  'JSON: el idioma común entre sistemas',
  'El formato de texto que usan el frontend y la API para entenderse — más simple de lo que parece, y ya lo estuviste leyendo sin saberlo.',
  E'- Leer y entender un objeto JSON simple.\n- Explicar por qué JSON es el formato elegido para la comunicación entre frontend y API.\n- Relacionar los tipos de datos de JSON con los tipos de columnas de Postgres.',
  E'JSON (JavaScript Object Notation) es un formato de texto para representar datos estructurados — pares de clave y valor, listas, texto, números, booleanos y nulos. Es el formato que usa la API de Supabase para responderle a tu frontend, y el que vos misma armás cuando hacés un insert():\n\n{\n  "id": "a1b6f9e2-3c4d-4e5f-8a9b-1c2d3e4f5a6b",\n  "title": "Row Level Security (RLS)",\n  "is_published": true,\n  "created_at": "2026-07-24T10:30:00Z"\n}\n\nEsto se parece bastante a un objeto de JavaScript porque de ahí sale el nombre — pero JSON es más estricto: las claves siempre van entre comillas dobles, no admite comentarios, y no admite funciones ni valores undefined.\n\n¿Por qué JSON y no otro formato? Porque es liviano, fácil de leer para humanos, y prácticamente todos los lenguajes de programación (JavaScript, Python, y el propio Postgres con su tipo jsonb) saben leerlo y escribirlo sin traducción especial. Cuando PostgREST te devuelve el resultado de un SELECT, lo convierte de filas de Postgres a un array de objetos JSON — eso es literalmente lo que recibís en data cuando hacés await supabase.from(...).select().',
  E'La columna metadata de la tabla learning_activity de esta Academy es de tipo jsonb — literalmente JSON guardado dentro de Postgres, usado para datos flexibles como { "lesson_id": "..." } que varían según el tipo de evento, sin necesitar una columna separada para cada posible campo.',
  E'En las herramientas de desarrollador del navegador (Network), abrí el detalle de un pedido a Supabase y mirá la respuesta — vas a ver JSON real, con la misma forma que las filas que ya conocés de tus tablas.',
  E'- Confundir JSON con un objeto de JavaScript (se parecen mucho, pero JSON es texto, y tiene reglas más estrictas — por ejemplo, no se pueden usar comillas simples para las claves).\n- Intentar meter una función o undefined dentro de un JSON — no es válido en ese formato.\n- No reconocer que jsonb en Postgres es, literalmente, JSON guardado y consultable dentro de la base de datos.',
  E'- [ ] Puedo leer un objeto JSON simple y explicar su estructura.\n- [ ] Puedo explicar por qué JSON es un buen formato para la comunicación entre frontend y API.\n- [ ] Puedo identificar la columna jsonb de esta Academy y para qué se usa.',
  10, 'Fundamentos', 'API: el contrato entre frontend y datos', 5, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  '598d338a-1a19-4cd5-bf51-6e9a24dc7d84',
  'aa317157-f6c9-4ef7-a97e-a1a12f06ff9b',
  'Contá JSX vs lógica en una página',
  'Abrí src/pages/DashboardPage.tsx y estimá qué porcentaje del archivo es JSX (interfaz) versus lógica real. Compará con lo que esperabas.',
  'short_answer', 1
),
(
  'fc8f56a1-017a-4409-bfa4-78bbaf4c6682',
  'cebc02c6-8d2c-42ea-9b5d-88538613c460',
  'Encontrá dónde vive cada responsabilidad de backend',
  'Para "validar que un dato es correcto" y "decidir quién puede verlo", identificá en qué archivo o migración de esta Academy vive esa lógica.',
  'short_answer', 1
),
(
  '36b1bf55-6427-4eb1-bb06-951c6094f3fe',
  'eb792e9f-7045-451b-a30d-e53aca1f706c',
  'Probá la desincronización entre pestañas',
  'Abrí dos pestañas logueadas en esta Academy, completá una lección en una, y confirmá que la otra no se actualiza hasta refrescar. Describí qué viste.',
  'short_answer', 1
),
(
  'ad9ab512-28f0-49c7-83fe-5f590d40d9b7',
  'e9830423-385c-4247-adbb-f3efda959f1f',
  'Mirá un pedido real a la API',
  'Con las herramientas de desarrollador abiertas (pestaña Network), navegá por la Biblioteca y encontrá un pedido hacia tu proyecto Supabase. Anotá la URL y el método (GET).',
  'evidence_link', 1
),
(
  'ff9d426f-b58d-4903-b1a1-1f10c2d77c39',
  '761c99dd-90d1-4725-907c-451580437bb4',
  'Leé un JSON real de esta Academy',
  'En la misma pestaña Network, abrí la respuesta de un pedido a la tabla concepts y explicá, en tus palabras, la estructura del JSON que ves.',
  'short_answer', 1
);
