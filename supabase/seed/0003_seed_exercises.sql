-- 0003_seed_exercises.sql

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  gen_random_uuid(),
  'e80d1fc0-2da1-4d99-9f76-132de0f075e3',
  'Identificá una base de datos en tu propio trabajo',
  E'Elegí uno de tus sistemas (Vacaciones, Inventario, Wordyssey, Facilities, el que quieras) y escribí en 3-4 líneas: qué información vive en su base de datos, y qué pasaría si esa información viviera en un Excel compartido en vez de en Supabase.',
  'short_answer',
  1
),
(
  gen_random_uuid(),
  '7a516b13-4df4-4f05-846e-e32ab9decf0a',
  'Diseñá una tabla en papel',
  E'Elegí un concepto de un proyecto propio (por ejemplo "sitio", "tarea" o "candidato") y escribí una lista de columnas para esa tabla, indicando qué tipo de dato tendría cada una (texto, número, fecha, verdadero/falso). No hace falta SQL todavía — es un ejercicio de diseño en papel.',
  'short_answer',
  1
),
(
  gen_random_uuid(),
  '43df9ad0-ccf7-4283-b609-d5f84753784e',
  'Encontrá la clave primaria en un proyecto real',
  E'Abrí (o recordá) una tabla de Supabase de alguno de tus proyectos ya construidos. Identificá cuál es su clave primaria y confirmá que es un UUID generado automáticamente. Si encontrás una tabla que no sigue esta convención, anotalo — puede ser una oportunidad de mejora.',
  'evidence_link',
  1
);
