-- 0005_seed_sql_modulo2.sql
-- Módulo 2 de la Etapa 2 (SQL): "Modificar datos" — INSERT, UPDATE, DELETE.
--
-- ESTADO: este contenido ya fue cargado MANUALMENTE desde /admin antes de
-- que este archivo existiera. NO lo corras sobre la base de datos actual
-- — crearía un módulo y lecciones duplicadas con IDs distintos.
-- Se conserva acá únicamente como respaldo/documentación del contenido,
-- y sería necesario solo si alguna vez se reconstruye la base desde cero.

insert into public.modules (id, course_id, title, description, order_index, is_published) values
  ('36a2cbe9-8f2a-44b9-bac2-4ab5aeafcccb', '693d80c7-de35-4321-8048-970ff2aae3b3', 'Modificar datos', 'INSERT, UPDATE y DELETE — las tres instrucciones que cambian lo que hay guardado.', 2, true);

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'a2729b9a-0278-4fc4-bac0-2e2f58498ccf',
  '36a2cbe9-8f2a-44b9-bac2-4ab5aeafcccb',
  'Agregar filas con INSERT',
  'La instrucción que crea una fila nueva en una tabla — el otro lado de SELECT: en vez de leer, escribís.',
  E'- Escribir un INSERT especificando columnas y valores.\n- Entender qué pasa con las columnas que no se mencionan en el INSERT.\n- Reconocer cuándo INSERT falla por violar una restricción (unique, not null, foreign key).',
  E'INSERT agrega una fila nueva a una tabla. La forma básica nombra las columnas y después los valores, en el mismo orden:\n\nINSERT INTO practical_projects (user_id, name, status)\nVALUES (''uuid-de-la-usuaria'', ''OnboardFlow'', ''completed'');\n\nLas columnas que no mencionás toman su valor por defecto: si la tabla tiene DEFAULT gen_random_uuid() en id, se genera solo; si una columna tiene DEFAULT now() en created_at, se llena solo; si una columna no tiene default y es NOT NULL (como muchas de las que armamos en las migraciones), el INSERT falla si no la incluís.\n\nCada vez que tu app llama a supabase.from(''practical_projects'').insert({...}), eso genera exactamente este tipo de instrucción por debajo — con la diferencia de que RLS revisa, antes de dejarlo pasar, si a esa usuaria se le permite insertar ahí.',
  E'Cuando registraste un proyecto práctico desde la página "Proyectos" de esta Academy, tu navegador mandó algo equivalente a este INSERT. El formulario de React solo junta los datos — quien realmente los guarda es este INSERT, corriendo del lado del servidor de Supabase.',
  E'En el SQL Editor, probá insertar una fila de prueba en application_settings: INSERT INTO application_settings (key, value) VALUES (''test_key'', ''test_value''); Confirmá con un SELECT que apareció.',
  E'- Escribir los valores en un orden distinto al de las columnas listadas.\n- Olvidar comillas simples en valores de texto.\n- No revisar las restricciones de la tabla antes de insertar — un INSERT que viola una FK falla con un error de integridad referencial.',
  E'- [ ] Puedo escribir un INSERT completo especificando columnas y valores.\n- [ ] Entiendo qué pasa con una columna que tiene DEFAULT y no la incluyo en el INSERT.\n- [ ] Puedo explicar qué es una violación de restricción y dar un ejemplo.',
  15, 'Fundamentos', 'Ordenar resultados con ORDER BY', 1, true
),
(
  '086eb6d4-8906-44b2-bf5f-0d7ebefec97d',
  '36a2cbe9-8f2a-44b9-bac2-4ab5aeafcccb',
  'Modificar filas con UPDATE',
  'La instrucción que cambia valores en filas que ya existen — la que más cuidado exige, porque un WHERE mal puesto puede modificar mucho más de lo que querías.',
  E'- Escribir un UPDATE con SET y WHERE.\n- Explicar por qué un UPDATE sin WHERE es una de las operaciones más peligrosas en SQL.\n- Reconocer el patrón "SELECT primero, UPDATE después" como hábito de seguridad.',
  E'UPDATE cambia el valor de una o más columnas en las filas que cumplen una condición:\n\nUPDATE lesson_progress\nSET status = ''completed'', completed_at = now()\nWHERE user_id = ''uuid-de-la-usuaria'' AND lesson_id = ''uuid-de-la-leccion'';\n\nSET define qué columnas cambian. WHERE define qué filas se ven afectadas — si te olvidás el WHERE, el UPDATE se aplica a TODAS las filas de la tabla, sin excepción, sin aviso.\n\nPor eso el hábito profesional es: antes de correr un UPDATE, correr el SELECT equivalente con la misma condición, mirar qué filas aparecen, y solo después convertir ese SELECT en UPDATE.\n\nCada vez que tu app marca una lección como completada, por debajo corre un UPDATE como el de arriba — filtrado siempre por user_id y lesson_id específicos, nunca "todas las filas".',
  E'Cuando marcaste como completada una lección en esta misma Academy, el código ejecutó un UPDATE sobre lesson_progress filtrado por tu user_id y el id de esa lección exacta — no tocó el progreso de ninguna otra lección ni de ninguna otra persona.',
  E'En el SQL Editor: primero SELECT * FROM application_settings WHERE key = ''test_key''; y confirmá la fila. Recién ahí UPDATE application_settings SET value = ''valor_actualizado'' WHERE key = ''test_key'';. Verificá el cambio con otro SELECT.',
  E'- Correr UPDATE tabla SET columna = valor; sin WHERE — actualiza absolutamente todas las filas.\n- Escribir una condición WHERE que coincide con más filas de las pensadas.\n- No verificar el resultado después — Postgres dice cuántas filas fueron afectadas, y si ese número no es el esperado, es una alerta inmediata.',
  E'- [ ] Puedo escribir un UPDATE con SET y WHERE correctamente.\n- [ ] Puedo explicar por qué UPDATE sin WHERE es peligroso, con mis propias palabras.\n- [ ] Adopté el hábito de correr el SELECT equivalente antes de un UPDATE real.',
  15, 'Fundamentos', 'Agregar filas con INSERT', 2, true
),
(
  'e29c037e-6328-4539-836b-d8136fa1afb2',
  '36a2cbe9-8f2a-44b9-bac2-4ab5aeafcccb',
  'Eliminar filas con DELETE',
  'La instrucción que borra filas — irreversible salvo backups, y con el mismo riesgo que UPDATE si se olvida el WHERE.',
  E'- Escribir un DELETE con WHERE.\n- Entender qué es ON DELETE CASCADE y por qué borrar una fila puede borrar otras en cascada.\n- Explicar la diferencia entre borrar datos y "desactivarlos" (soft delete).',
  E'DELETE elimina filas completas de una tabla:\n\nDELETE FROM personal_notes WHERE id = ''uuid-de-la-nota'';\n\nIgual que con UPDATE, el WHERE evita el desastre: sin condición borra todas las filas de todas las usuarias.\n\nAlgo que ya usamos en las migraciones: ON DELETE CASCADE. Cuando una FK tiene esa opción (por ejemplo, lesson_id references lessons(id) on delete cascade en personal_notes), le decimos a Postgres "si se borra la lección, borrá también todas las notas que apuntan a ella" — evita que queden filas huérfanas.\n\nPor eso cuando en el panel admin borrás una lección, eso dispara (vía CASCADE) el borrado de sus ejercicios, recursos y progreso relacionado — no es magia, es consecuencia directa de cómo se diseñaron las foreign keys.\n\nUna alternativa a borrar de verdad es el "soft delete": en vez de DELETE, UPDATE tabla SET is_active = false. Esta Academy usa ese patrón con is_published en el contenido académico.',
  E'Cuando eliminás una etapa desde Administración, el botón "Eliminar" ejecuta un DELETE FROM stages WHERE id = ... — y por las foreign keys con ON DELETE CASCADE, eso arrastra el borrado de todos los cursos, módulos y lecciones que colgaban de esa etapa. Por eso el confirm() antes de borrar no es un capricho.',
  E'En el SQL Editor: DELETE FROM application_settings WHERE key = ''test_key''; para limpiar la fila de prueba. Confirmá con un SELECT que ya no aparece.',
  E'- Correr DELETE FROM tabla; sin WHERE — borra la tabla entera.\n- No pensar en las consecuencias de ON DELETE CASCADE antes de borrar una fila "padre".\n- Usar DELETE cuando en realidad hacía falta un soft delete, perdiendo información que podría haber sido útil conservar.',
  E'- [ ] Puedo escribir un DELETE con WHERE correctamente.\n- [ ] Puedo explicar qué es ON DELETE CASCADE con un ejemplo de esta Academy.\n- [ ] Puedo explicar cuándo conviene un soft delete en vez de un DELETE real.',
  15, 'Fundamentos', 'Modificar filas con UPDATE', 3, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'aa2262b1-5629-43dc-8096-90dc71452422',
  'a2729b9a-0278-4fc4-bac0-2e2f58498ccf',
  'Insertá y confirmá',
  'En el SQL Editor, insertá una fila de prueba en application_settings y confirmá con un SELECT que aparece. Pegá acá el resultado que viste.',
  'short_answer', 1
),
(
  '2061b16d-dfa2-4016-8a92-fe0945a8cb05',
  '086eb6d4-8906-44b2-bf5f-0d7ebefec97d',
  'Practicá el hábito SELECT-antes-de-UPDATE',
  'Elegí una tabla cualquiera de tu proyecto, escribí un SELECT con una condición WHERE, y describí qué UPDATE harías con esa misma condición sin llegar a ejecutarlo. El objetivo es el hábito, no el resultado.',
  'short_answer', 1
),
(
  'fdb26825-9fbb-4976-8114-96969bc86805',
  'e29c037e-6328-4539-836b-d8136fa1afb2',
  'Encontrá un ON DELETE CASCADE real',
  'Revisá las migraciones de esta Academy (supabase/migrations/) y encontrá al menos una foreign key con ON DELETE CASCADE. Explicá en tus palabras qué pasaría si se borrara la fila "padre".',
  'short_answer', 1
);
