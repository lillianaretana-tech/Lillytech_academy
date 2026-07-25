-- 0006_seed_sql_modulo3.sql
-- Módulo 3 de la Etapa 2 (SQL): "Consultas avanzadas" — JOIN, GROUP BY y
-- funciones de agregación, vistas, transacciones, índices, consultas de
-- diagnóstico. Corré este archivo completo de una sola vez en el SQL Editor.

insert into public.modules (id, course_id, title, description, order_index, is_published) values
  ('350688ac-c0c0-473f-b03a-4a07e8215765', '693d80c7-de35-4321-8048-970ff2aae3b3', 'Consultas avanzadas', 'JOIN, agregaciones, vistas, transacciones, índices y diagnóstico — lo que se necesita para consultas del mundo real.', 3, true);

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'd30a02e9-b867-433c-abc7-77e8ad6b40dc',
  '350688ac-c0c0-473f-b03a-4a07e8215765',
  'Combinar tablas con JOIN',
  'Cómo traer datos de dos o más tablas relacionadas en una sola consulta — la operación que hace que las relaciones (claves foráneas) sirvan para algo.',
  E'- Escribir un INNER JOIN entre dos tablas relacionadas.\n- Explicar la diferencia entre INNER JOIN y LEFT JOIN.\n- Reconocer cuándo una consulta necesita un JOIN en vez de dos SELECT separados.',
  E'Un JOIN combina filas de dos tablas según una condición de igualdad, casi siempre entre una clave foránea y la clave primaria que referencia:\n\nSELECT lessons.title, modules.title as modulo\nFROM lessons\nJOIN modules ON lessons.module_id = modules.id;\n\nEsto es un INNER JOIN (el default): solo trae filas donde existe coincidencia en ambas tablas. Si una lección tuviera un module_id que no existe (no debería pasar, gracias a la foreign key), esa fila no aparecería.\n\nUn LEFT JOIN trae todas las filas de la tabla de la izquierda, tengan o no coincidencia en la derecha:\n\nSELECT stages.title, courses.title\nFROM stages\nLEFT JOIN courses ON courses.stage_id = stages.id;\n\nCon LEFT JOIN, una etapa sin ningún curso todavía aparece en el resultado, con NULL en las columnas de courses. Con INNER JOIN, esa etapa desaparecería del resultado por completo — diferencia enorme cuando lo que necesitás es justamente detectar "qué etapas no tienen cursos todavía".',
  E'El servicio getPathTree() de esta Academy hace exactamente esto en varios pasos (aunque con supabase-js en vez de JOIN escrito a mano): trae etapas, después para cada una sus cursos, después módulos, después lecciones — reconstruyendo del lado de JavaScript lo que un JOIN bien escrito podría traer en una sola consulta SQL.',
  E'En el SQL Editor: SELECT courses.title, stages.title as etapa FROM courses JOIN stages ON courses.stage_id = stages.id; — deberías ver cada curso junto al nombre de su etapa. Después probá cambiarlo a LEFT JOIN desde stages y notá si cambia algo (no debería, porque ya cargaste al menos un curso por etapa).',
  E'- Olvidar la condición ON — sin ella, Postgres devuelve el producto cartesiano (todas las combinaciones posibles), que casi nunca es lo que se buscaba.\n- Usar INNER JOIN cuando se necesitaba LEFT JOIN, perdiendo silenciosamente las filas sin coincidencia.\n- No calificar el nombre de columna cuando existe en ambas tablas (ej. title existe en lessons y en modules) — hay que escribir lessons.title explícitamente.',
  E'- [ ] Puedo escribir un INNER JOIN entre dos tablas relacionadas.\n- [ ] Puedo explicar con un ejemplo la diferencia entre INNER JOIN y LEFT JOIN.\n- [ ] Puedo identificar cuándo el resultado de un JOIN sin ON sería un producto cartesiano.',
  20, 'Intermedio', 'Eliminar filas con DELETE', 1, true
),
(
  '96eb876c-de16-4bbc-a8b2-92c460290761',
  '350688ac-c0c0-473f-b03a-4a07e8215765',
  'Agrupar y resumir datos con GROUP BY',
  'Cómo pasar de "todas las filas" a "un resumen por categoría" — cuántas lecciones completadas tiene cada estudiante, cuántos proyectos por estado, etc.',
  E'- Escribir una consulta con GROUP BY y una función de agregación (COUNT, SUM, AVG).\n- Entender por qué las columnas del SELECT deben coincidir con las del GROUP BY (o ser agregaciones).\n- Usar HAVING para filtrar sobre el resultado ya agrupado.',
  E'GROUP BY junta filas que comparten un valor en una columna, y las funciones de agregación (COUNT, SUM, AVG, MAX, MIN) resumen esos grupos:\n\nSELECT status, COUNT(*) as cantidad\nFROM lesson_progress\nGROUP BY status;\n\nEsto devuelve una fila por cada valor distinto de status, con la cantidad de filas que tenía cada uno — exactamente lo que necesitarías para la vista de "Progreso de estudiantes" del panel admin de esta Academy, si quisieras el resumen calculado en SQL en vez de en JavaScript.\n\nRegla importante: en el SELECT solo podés poner columnas que estén en el GROUP BY, o funciones de agregación sobre otras columnas — Postgres no adivina qué valor mostrar de una columna que no agrupaste y no agregaste.\n\nSi necesitás filtrar sobre el resultado ya agrupado (por ejemplo, "solo estudiantes con más de 5 lecciones completadas"), no se usa WHERE — se usa HAVING, porque WHERE se evalúa antes de agrupar y HAVING después:\n\nSELECT user_id, COUNT(*) as completadas\nFROM lesson_progress\nWHERE status = ''completed''\nGROUP BY user_id\nHAVING COUNT(*) > 5;',
  E'La función adminListStudentProgress() de esta Academy hoy hace el conteo de lecciones completadas por estudiante en JavaScript, recorriendo arrays. Esa misma lógica, escrita en SQL con GROUP BY, sería más corta y más eficiente para volúmenes grandes de datos — un ejemplo real de cómo la misma necesidad se puede resolver en distintas capas.',
  E'En el SQL Editor: SELECT status, COUNT(*) FROM lesson_progress GROUP BY status; — deberías ver cuántas lecciones tenés en cada estado (completed, in_progress, not_started si existiera fila, needs_review).',
  E'- Poner en el SELECT una columna que no está ni en el GROUP BY ni dentro de una función de agregación — Postgres directamente rechaza la consulta con error.\n- Usar WHERE cuando hacía falta HAVING (filtrar sobre el resultado agrupado, no sobre las filas originales).\n- Olvidar que COUNT(*) cuenta filas, mientras que COUNT(columna) no cuenta los NULL de esa columna — pueden dar números distintos.',
  E'- [ ] Puedo escribir un GROUP BY con al menos una función de agregación.\n- [ ] Puedo explicar por qué el SELECT está limitado a columnas agrupadas o agregadas.\n- [ ] Puedo explicar la diferencia entre WHERE y HAVING con un ejemplo.',
  20, 'Intermedio', 'Combinar tablas con JOIN', 2, true
),
(
  '956fcad9-8807-4f01-ba6a-b4664590c758',
  '350688ac-c0c0-473f-b03a-4a07e8215765',
  'Vistas: consultas guardadas con nombre',
  'Cómo guardar una consulta compleja bajo un nombre, para no reescribirla cada vez y para que otras partes del sistema la usen como si fuera una tabla más.',
  E'- Crear una vista simple con CREATE VIEW.\n- Explicar en qué se parece y en qué se diferencia una vista de una tabla normal.\n- Reconocer cuándo conviene una vista en vez de repetir la misma consulta en varios lugares.',
  E'Una vista es una consulta SELECT guardada bajo un nombre, que después podés consultar como si fuera una tabla:\n\nCREATE VIEW student_summary AS\nSELECT user_id, COUNT(*) as lecciones_completadas\nFROM lesson_progress\nWHERE status = ''completed''\nGROUP BY user_id;\n\nSELECT * FROM student_summary WHERE lecciones_completadas > 3;\n\nLa vista no guarda datos propios — cada vez que la consultás, Postgres vuelve a ejecutar el SELECT de adentro. Por eso una vista siempre refleja el estado actual de las tablas base, nunca queda "desactualizada".\n\n¿Cuándo conviene? Cuando la misma consulta compleja (con varios JOIN o GROUP BY) se repite en múltiples lugares del código — en vez de copiar y pegar el SQL cada vez, lo definís una sola vez como vista y consultás la vista.',
  E'Si esta Academy necesitara mostrar "resumen de progreso por estudiante" en tres pantallas distintas (Dashboard, Administración → Progreso, y un futuro reporte), en vez de escribir la misma lógica de agregación tres veces en JavaScript, se podría crear una vista una sola vez en Postgres y consultarla desde las tres pantallas — coherente con el Principio de reutilización del conocimiento, aplicado a código en vez de a contenido.',
  E'En el SQL Editor, probá crear una vista simple: CREATE VIEW published_lesson_count AS SELECT module_id, COUNT(*) as cantidad FROM lessons WHERE is_published = true GROUP BY module_id; — y después SELECT * FROM published_lesson_count;.',
  E'- Pensar que una vista "guarda" los datos como una copia — no lo hace, solo guarda la consulta.\n- Crear vistas para consultas que se usan una sola vez — el beneficio de una vista está en la reutilización, no tiene sentido para algo puntual.\n- No considerar el rendimiento: una vista sobre una consulta muy pesada sigue siendo pesada cada vez que se consulta (existen las vistas materializadas para ese caso, fuera del alcance de esta lección).',
  E'- [ ] Puedo crear una vista simple con CREATE VIEW.\n- [ ] Puedo explicar por qué una vista no duplica datos.\n- [ ] Puedo dar un ejemplo propio de cuándo usaría una vista en vez de repetir SQL.',
  15, 'Intermedio', 'Agrupar y resumir datos con GROUP BY', 3, true
),
(
  'd49decfa-b590-4a98-8b06-e7a25f7fc33d',
  '350688ac-c0c0-473f-b03a-4a07e8215765',
  'Transacciones: todo o nada',
  'Cómo agrupar varios cambios para que se apliquen todos juntos o ninguno — evitando que un error a mitad de camino deje la base de datos en un estado inconsistente.',
  E'- Explicar qué es una transacción y qué problema resuelve.\n- Usar BEGIN, COMMIT y ROLLBACK.\n- Reconocer una situación real donde varios cambios deberían ir dentro de la misma transacción.',
  E'Una transacción agrupa varias instrucciones SQL para que se apliquen como una sola unidad: o se aplican todas, o no se aplica ninguna. Se abre con BEGIN, se confirma con COMMIT (todo queda guardado), o se deshace con ROLLBACK (todo se descarta, como si nunca hubiera pasado):\n\nBEGIN;\nUPDATE lesson_progress SET status = ''completed'' WHERE id = ''...'';\nINSERT INTO learning_activity (user_id, event_type) VALUES (''...'', ''lesson_completed'');\nCOMMIT;\n\n¿Por qué importa? Imaginá que el UPDATE se ejecuta bien, pero el INSERT falla por algún motivo (por ejemplo, una restricción). Sin transacción, quedarías con el progreso marcado como completado pero sin el registro correspondiente en la bitácora — un estado inconsistente. Con una transacción, si el INSERT falla, todo el bloque se revierte automáticamente (o vos podés forzar el ROLLBACK), y el UPDATE tampoco queda aplicado.\n\nEsto es exactamente lo que hace setLessonStatus() en esta Academy conceptualmente: actualiza el progreso Y registra la actividad. Hoy están como dos llamadas separadas desde JavaScript (no en una transacción real de Postgres), lo cual es una simplificación válida para el MVP, pero una versión más robusta podría envolver ambas escrituras en una sola transacción vía una función RPC.',
  E'Pensá en tu Control de vacaciones: si "aprobar una solicitud" implica actualizar el estado de la solicitud Y descontar días del saldo de la persona, ambas escrituras deberían ir en la misma transacción — si el descuento de saldo fallara, no querés que la solicitud quede marcada como aprobada sin haber descontado los días.',
  E'En el SQL Editor: BEGIN; luego un SELECT cualquiera para confirmar que estás "dentro" de la transacción, y ROLLBACK; para deshacer sin haber cambiado nada. Practicá también BEGIN; UPDATE ...; COMMIT; con un cambio real y de bajo riesgo, como actualizar un application_settings de prueba.',
  E'- Abrir una transacción con BEGIN y olvidarse de cerrarla con COMMIT o ROLLBACK — deja conexiones colgadas y bloqueos innecesarios.\n- Pensar que una transacción "deshace" cambios ya confirmados con COMMIT — una vez que hiciste COMMIT, ya no hay vuelta atrás con ROLLBACK.\n- No usar transacciones en operaciones que claramente deberían ir juntas, arriesgándose a estados inconsistentes.',
  E'- [ ] Puedo explicar qué problema resuelve una transacción, con un ejemplo propio.\n- [ ] Puedo usar BEGIN, COMMIT y ROLLBACK correctamente.\n- [ ] Puedo identificar, en un proyecto real, una operación que debería ir dentro de una transacción.',
  20, 'Intermedio', 'Vistas: consultas guardadas con nombre', 4, true
),
(
  'b19b3b46-9a96-4a68-b4bb-538805847eec',
  '350688ac-c0c0-473f-b03a-4a07e8215765',
  'Índices: por qué algunas consultas son más rápidas que otras',
  'Cómo Postgres encuentra filas rápido sin recorrer toda la tabla — y por qué ya hay varios índices trabajando en la base de datos de esta Academy sin que lo hayas notado.',
  E'- Explicar con una analogía qué es un índice.\n- Reconocer cuándo una columna es buena candidata para tener un índice.\n- Identificar los índices que ya existen en las tablas de esta Academy.',
  E'Un índice es una estructura extra que Postgres mantiene sobre una columna (o varias), pensada para encontrar filas rápido sin tener que revisar la tabla entera. Es exactamente igual a un índice de un libro: en vez de leer página por página buscando un tema, vas directo a la página que el índice te indica.\n\nSin índice, buscar por lesson_id en una tabla de 100.000 filas de lesson_progress implicaría revisar las 100.000 filas una por una (un "table scan"). Con un índice sobre lesson_id, Postgres puede saltar directo a las filas relevantes.\n\nEsta Academy ya tiene índices creados desde las migraciones — por ejemplo, create index idx_lesson_progress_lesson_id on public.lesson_progress(lesson_id); (migración 0004). Se crearon a propósito sobre las columnas que sabíamos que se iban a consultar seguido (sobre todo foreign keys usadas en WHERE o JOIN).\n\nLos índices no son gratis: aceleran las lecturas pero hacen un poco más lentas las escrituras (cada INSERT/UPDATE también tiene que actualizar el índice), y ocupan espacio en disco. Por eso no se indexa cualquier columna "por las dudas" — se indexan las que realmente se usan para filtrar o unir seguido.',
  E'idx_lessons_module_id, que ya existe en esta Academy, es lo que hace rápida la consulta listLessonsForModule() cada vez que la Biblioteca necesita mostrar las lecciones de un módulo — sin ese índice, con muchas lecciones acumuladas en dos años de uso, esa consulta se iría poniendo cada vez más lenta.',
  E'En el SQL Editor: SELECT indexname, tablename FROM pg_indexes WHERE schemaname = ''public'' ORDER BY tablename; — vas a ver la lista completa de índices que ya existen en tu base de datos, incluyendo los que creamos en las migraciones.',
  E'- Pensar que hay que indexar todas las columnas "para que todo sea rápido" — eso hace las escrituras más lentas sin necesidad, si esas columnas no se consultan seguido.\n- No indexar una columna que sí se usa constantemente en WHERE o JOIN, dejando esa consulta lenta a propósito por desconocimiento.\n- Confundir un índice con una copia de los datos — el índice no duplica la información completa, solo un mapa para encontrarla rápido.',
  E'- [ ] Puedo explicar qué es un índice con una analogía propia.\n- [ ] Puedo listar los índices existentes en mi base de datos con una consulta a pg_indexes.\n- [ ] Puedo explicar por qué no conviene indexar cualquier columna sin criterio.',
  15, 'Intermedio', 'Transacciones: todo o nada', 5, true
),
(
  'ce5abac6-7db4-4273-ba37-2994757aef4f',
  '350688ac-c0c0-473f-b03a-4a07e8215765',
  'Consultas de diagnóstico',
  'Cómo preguntarle a la propia base de datos qué está pasando adentro — qué tablas existen, qué políticas RLS hay activas, qué consulta se está por ejecutar y qué tan rápido.',
  E'- Usar EXPLAIN para ver cómo Postgres va a ejecutar una consulta.\n- Consultar el catálogo del sistema para listar tablas, columnas y políticas RLS existentes.\n- Adoptar el hábito de diagnosticar antes de asumir que algo "está roto".',
  E'Postgres guarda metadata de sí mismo en tablas especiales del sistema (el "catálogo"), que podés consultar con SQL normal. Algunas consultas de diagnóstico que ya usamos en esta Academy, sin llamarlas por ese nombre:\n\n-- Ver todas las políticas RLS de una tabla\nSELECT * FROM pg_policies WHERE tablename = ''lesson_progress'';\n\n-- Ver si RLS está activado en una tabla\nSELECT relname, relrowsecurity FROM pg_class WHERE relname = ''lesson_progress'';\n\n-- Ver cómo Postgres va a ejecutar una consulta (usa índice o no)\nEXPLAIN SELECT * FROM lessons WHERE module_id = ''...'';\n\nEXPLAIN es especialmente útil cuando una consulta se siente lenta: te muestra el "plan de ejecución" — si Postgres está usando un índice (Index Scan) o revisando toda la tabla (Seq Scan). Un Seq Scan sobre una tabla grande, en una consulta que se repite seguido, es una señal de que falta un índice.',
  E'Cuando algo "no aparece" en esta Academy (por ejemplo, una lección que debería verse pero no se ve), el primer diagnóstico no es asumir que el código de React está roto — es correr SELECT * FROM pg_policies WHERE tablename = ''lessons''; para confirmar que la política de lectura permite verla, y SELECT is_published FROM lessons WHERE id = ''...''; para confirmar el estado real del dato.',
  E'En el SQL Editor: SELECT * FROM pg_policies WHERE tablename = ''concepts''; — deberías ver las 4 políticas que armamos para esa tabla en la migración 0013. Después probá EXPLAIN SELECT * FROM lessons WHERE module_id = ''36a2cbe9-8f2a-44b9-bac2-4ab5aeafcccb'';.',
  E'- Asumir que un problema es "del código" sin antes revisar qué dice la base de datos directamente.\n- No saber que existen tablas de catálogo como pg_policies o pg_class — son las que responden preguntas sobre la estructura misma de la base.\n- Ignorar el resultado de EXPLAIN cuando muestra un Seq Scan en una consulta que se repite todo el tiempo.',
  E'- [ ] Puedo consultar pg_policies para ver las políticas RLS de una tabla.\n- [ ] Puedo correr un EXPLAIN y distinguir un Index Scan de un Seq Scan.\n- [ ] Adopté el hábito de diagnosticar con SQL antes de asumir que el problema está en el código.',
  20, 'Intermedio', 'Índices: por qué algunas consultas son más rápidas que otras', 6, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'a2114bde-6cbc-4745-8501-59a8076ce4f5',
  'd30a02e9-b867-433c-abc7-77e8ad6b40dc',
  'Escribí un JOIN propio',
  'Escribí una consulta que combine lessons y modules mostrando el título de la lección junto al título de su módulo. Corrélo en el SQL Editor y confirmá el resultado.',
  'short_answer', 1
),
(
  '56f2db8e-b71c-410c-8e4e-574e12389325',
  '96eb876c-de16-4bbc-a8b2-92c460290761',
  'Contá tus propias lecciones completadas',
  'Escribí una consulta con GROUP BY que cuente cuántas lecciones completaste, agrupado por status. Compará el resultado con lo que ves en tu Dashboard.',
  'short_answer', 1
),
(
  'ab4322ff-22c7-43e5-af62-058341c701b3',
  '956fcad9-8807-4f01-ba6a-b4664590c758',
  'Diseñá una vista útil para vos',
  'Describí (sin necesidad de crearla si no querés tocar la base) una vista que te resultaría útil para tu propio seguimiento de estudio. ¿Qué consulta guardaría?',
  'short_answer', 1
),
(
  '64a3ee92-cfba-4a63-9ace-ab30f36646c6',
  'd49decfa-b590-4a98-8b06-e7a25f7fc33d',
  'Identificá una operación que necesita transacción',
  'Pensá en uno de tus propios proyectos (Vacaciones, Inventario, etc.) y describí una operación que debería envolverse en una transacción porque implica más de un cambio relacionado.',
  'short_answer', 1
),
(
  '3ca58641-e221-4e7e-8324-c89221c28239',
  'b19b3b46-9a96-4a68-b4bb-538805847eec',
  'Listá los índices de tu proyecto',
  'Corré SELECT indexname, tablename FROM pg_indexes WHERE schemaname = ''public''; y contá cuántos índices ya existen en tu base de datos.',
  'evidence_link', 1
),
(
  'fe556059-e5ca-4cad-a4b9-9008f9f1a3a7',
  'ce5abac6-7db4-4273-ba37-2994757aef4f',
  'Diagnosticá una tabla real',
  'Elegí una tabla de esta Academy y corré SELECT * FROM pg_policies WHERE tablename = ''tu_tabla'';. Anotá cuántas políticas tiene y qué hace cada una, en tus propias palabras.',
  'short_answer', 1
);

-- La lección de "Consultas de diagnóstico" usa pg_policies extensamente para
-- inspeccionar RLS — se enlaza al concepto ya existente en vez de reexplicar
-- qué es RLS acá (Principio de reutilización del conocimiento).
insert into public.concept_lessons (concept_id, lesson_id) values
  ('a1b6f9e2-3c4d-4e5f-8a9b-1c2d3e4f5a6b', 'ce5abac6-7db4-4273-ba37-2994757aef4f');
