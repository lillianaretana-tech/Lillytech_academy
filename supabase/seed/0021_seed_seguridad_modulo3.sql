-- 0021_seed_seguridad_modulo3.sql
-- Módulo 3 de la Etapa 7 (Seguridad práctica): "Cuando algo falla" — cierra la Etapa 7 completa.

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '1a01f481-a5fb-491c-af82-441708cecd88', id, 'Cuando algo falla', 'Auditoría, recuperación, y el cierre integrador de toda la etapa: seguridad proporcional al riesgo.', 3, true
from public.courses where title = 'Seguridad proporcional al riesgo';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'c2a1fb7b-121d-4ef6-9d91-16f0fe1eb4bd',
  '1a01f481-a5fb-491c-af82-441708cecd88',
  'Auditoría: reconstruir qué pasó',
  'Cómo saber, después de los hechos, quién hizo qué y cuándo — parcialmente ya presente en esta Academy, con una limitación real que vale la pena reconocer.',
  E'- Explicar qué es auditoría en el contexto de seguridad.\n- Identificar qué rastro de auditoría ya existe en esta Academy.\n- Reconocer la limitación real que ya está documentada en el roadmap.',
  E'Auditoría es la capacidad de reconstruir, después de que algo pasó, quién hizo qué y cuándo — útil tanto para diagnosticar problemas como para detectar comportamiento indebido.\n\nEsta Academy tiene auditoría parcial, en dos formas:\n\n1. updated_at en casi todas las tablas (mantenido automáticamente por triggers) — te dice CUÁNDO se modificó algo por última vez, aunque no quién ni qué cambió exactamente.\n2. learning_activity (la Bitácora) — registra eventos específicos de aprendizaje (lección completada, nota creada), con quién y cuándo, pero no cubre TODO tipo de cambio en el sistema.\n\nLa limitación real, ya reconocida en docs/SECURITY.md de este mismo proyecto: "No hay auditoría detallada de cambios en contenido académico (quién editó qué lección y cuándo) más allá de updated_at." Es decir, si mañana una lección apareciera con contenido distinto al que recordás, updated_at te diría CUÁNDO cambió, pero no un historial de qué decía antes ni quién lo cambió — porque hoy sos la única admin, esa limitación tiene bajo impacto real, pero vale la pena tenerla presente si el proyecto creciera.',
  E'Si notaras que una lección tiene contenido distinto al que recordás haber escrito, hoy podrías consultar updated_at para saber cuándo cambió por última vez — pero no hay una tabla de "versiones anteriores de lecciones" que te muestre exactamente qué decía antes del cambio. Esa seria una mejora de auditoría real, si alguna vez hiciera falta.',
  E'Corré SELECT title, updated_at FROM lessons ORDER BY updated_at DESC LIMIT 5; y confirmá que podés ver cuáles fueron las últimas lecciones modificadas y cuándo.',
  E'- Pensar que updated_at es "suficiente auditoría" — te dice cuándo, no qué cambió específicamente ni por qué.\n- No revisar nunca la Bitácora como fuente de auditoría, perdiendo información que ya existe y está disponible.\n- Sobreinvertir en auditoría exhaustiva para un proyecto de una sola administradora, cuando el riesgo real de necesitarla es bajo (conectado con la próxima lección).',
  E'- [ ] Puedo explicar qué es auditoría y para qué sirve.\n- [ ] Puedo identificar los dos mecanismos de auditoría parcial que ya existen en esta Academy.\n- [ ] Puedo explicar la limitación real ya documentada en SECURITY.md.',
  15, 'Intermedio', 'Seguridad del backend: donde vive la garantía real', 1, true
),
(
  '2395b1c4-3417-432a-8ba2-0516c22c84c5',
  '1a01f481-a5fb-491c-af82-441708cecd88',
  'Recuperación: volver de un desastre',
  'Repaso enfocado de algo ya visto en la Etapa 3 (backups), esta vez desde la pregunta completa: si algo se rompe de verdad, ¿qué pasos concretos seguirías para recuperarte?',
  E'- Enumerar las capas de recuperación disponibles para esta Academy.\n- Distinguir qué tipo de desastre resuelve cada capa.\n- Escribir un plan simple de recuperación propio.',
  E'Ya viste, en la Etapa 3, que Supabase hace backups automáticos, y que las migraciones en GitHub funcionan como una segunda red de seguridad estructural. Esta lección junta ambas ideas en un plan de recuperación completo, pensando en distintos tipos de desastre:\n\n- Si accidentalmente borrás datos con un DELETE mal escrito: el backup automático de Supabase (según tu plan) podría restaurar un punto anterior — con la pérdida de cualquier cambio posterior a ese backup.\n- Si perdés acceso al proyecto Supabase entero (por ejemplo, un problema de cuenta): tus migraciones y seeds en GitHub te permiten reconstruir toda la estructura y el contenido educativo en un proyecto nuevo — aunque perderías el progreso real de estudio, que solo vive en la base de datos.\n- Si perdés tu Codespace o tu computadora: el código está seguro en GitHub, no depende de ningún dispositivo específico.\n- Si accidentalmente subís un secreto a Git: la recuperación ahí no es solo técnica (borrar el archivo) sino de seguridad (rotar la clave expuesta, porque una vez que estuvo en el historial, hay que asumir que pudo haber sido vista).\n\nUn buen plan de recuperación no es "nunca me va a pasar" — es saber, de antemano, qué harías en cada escenario, para no tener que improvisar en el momento de más estrés.',
  E'El día del error de course_id en las migraciones, la "recuperación" fue simple porque Postgres deshizo automáticamente todo el script fallido — pero si hubiera sido un error después de un COMMIT exitoso, la recuperación real habría dependido de tener un backup reciente o de poder reconstruir el dato manualmente desde las migraciones y seeds documentados.',
  E'Escribí, sin ejecutar nada, qué harías paso a paso si mañana borraras accidentalmente toda la tabla concepts con un DELETE sin WHERE.',
  E'- No tener ningún plan pensado de antemano, dejando la primera reacción ante un desastre real como pura improvisación bajo estrés.\n- Confiar en una sola capa de recuperación (solo backups, o solo Git) sin considerar qué tipo de desastre cada una NO resuelve.\n- No rotar una clave expuesta accidentalmente, asumiendo que "nadie la vio" sin ninguna evidencia real de eso.',
  E'- [ ] Puedo enumerar las capas de recuperación disponibles para esta Academy.\n- [ ] Puedo explicar qué tipo de desastre resuelve cada una y cuál no.\n- [ ] Escribí un plan simple para el escenario de "borré una tabla por error".',
  15, 'Intermedio', 'Auditoría: reconstruir qué pasó', 2, true
),
(
  'a6b74771-8f35-44dd-b04c-19a164ee91b7',
  '1a01f481-a5fb-491c-af82-441708cecd88',
  'Seguridad proporcional al riesgo: cierre de la Etapa 7',
  'El hilo que conecta todas las decisiones de seguridad de esta Academy — repasado ahora con la vista completa de toda la etapa detrás.',
  E'- Repasar el principio de seguridad proporcional al riesgo, ya mencionado en la Etapa 3.\n- Conectar las 12 piezas de esta etapa (las ya vistas antes y las de este módulo) en un solo criterio coherente.\n- Cerrar la Etapa 7 con una autoevaluación de seguridad de esta Academy.',
  E'Este principio ya apareció, sin cerrarse del todo, en la Etapa 3: "no hace falta la misma paranoia para proteger application_settings que para proteger datos personales, pero tampoco hay que relajar la seguridad de datos sensibles para que sea más simple". Ahora que viste las 12 piezas completas de esta etapa, esta lección las une:\n\n- Autenticación y autorización (Etapa 4): la base de "quién sos" y "qué podés hacer".\n- RLS (Etapa 3): el mecanismo técnico que hace cumplir la autorización, sin excepciones.\n- Validación de entradas (Etapa 5): asegurar que los datos en sí mismos tengan sentido.\n- Mínimo privilegio: dar exactamente el acceso necesario, nunca de más.\n- Protección de datos: clasificar antes de proteger, no toda información pesa igual.\n- Manejo de secretos: saber qué es secreto y dónde nunca debe vivir.\n- Seguridad del frontend y del backend: cada capa con su responsabilidad real, sin confundirlas.\n- Auditoría y recuperación: qué pasa DESPUÉS de que algo salió mal, no solo cómo prevenirlo.\n\nTodas estas piezas, juntas, no buscan la seguridad "máxima posible" — buscan la seguridad correcta para el riesgo real de este proyecto en este momento. Esta Academy protege con cuidado real los datos personales (notas, progreso, proyectos) porque son sensibles y personales, pero no invierte en, por ejemplo, autenticación de dos factores o auditoría exhaustiva de cada cambio — porque el riesgo real de un proyecto de una sola usuaria no lo justifica todavía. El día que el contexto cambie (más usuarias, datos más sensibles), este mismo criterio dice exactamente cuándo y por qué habría que invertir más.',
  E'Comparando esta Academy con, por ejemplo, un sistema bancario real: un banco necesitaría autenticación de dos factores, auditoría exhaustiva de cada transacción, y probablemente separación de ambientes estricta — no porque "sea mejor" en abstracto, sino porque su riesgo real (dinero de terceros, regulaciones legales) lo exige. Esta Academy no necesita ese nivel, y agregarlo sería sobreingeniería, no prudencia.',
  E'Escribí una autoevaluación breve: de las 12 piezas de esta etapa, ¿cuáles considerás que esta Academy tiene bien resueltas, y cuáles dejarías como pendientes conscientes (no urgentes) para cuando el contexto cambie?',
  E'- Buscar "la seguridad perfecta" en abstracto, sin anclarla al riesgo real del proyecto — no existe un nivel de seguridad correcto universal, solo el correcto para cada contexto.\n- Relajar la seguridad de lo que sí es sensible "para simplificar", confundiendo proporcionalidad con descuido.\n- No revisar periódicamente si el contexto de riesgo cambió, quedándose con decisiones de seguridad que fueron correctas en el pasado pero ya no lo son.',
  E'- [ ] Puedo explicar el principio de seguridad proporcional al riesgo con mis propias palabras.\n- [ ] Puedo nombrar las 12 piezas de esta etapa y cómo se conectan.\n- [ ] Escribí mi propia autoevaluación de seguridad de esta Academy.',
  20, 'Intermedio', 'Recuperación: volver de un desastre', 3, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'd66a9bce-60cc-40c0-b1ce-faf16be7d97b',
  'c2a1fb7b-121d-4ef6-9d91-16f0fe1eb4bd',
  'Consultá las últimas modificaciones',
  'Corré la consulta a lessons ordenada por updated_at y confirmá qué lecciones se modificaron más recientemente.',
  'evidence_link', 1
),
(
  '2bfd89b5-79de-4629-bced-2dcd85a7a80f',
  '2395b1c4-3417-432a-8ba2-0516c22c84c5',
  'Escribí tu plan de recuperación',
  'Para el escenario "borré la tabla concepts por error", escribí paso a paso qué harías para recuperarte.',
  'long_answer', 1
),
(
  '8370fbf5-09db-4033-bfe6-ce33c1a8a263',
  'a6b74771-8f35-44dd-b04c-19a164ee91b7',
  'Autoevaluación de seguridad',
  'Repasá las 12 piezas de esta etapa y escribí cuáles considerás bien resueltas en esta Academy, y cuáles quedan como pendientes conscientes.',
  'long_answer', 1
);
