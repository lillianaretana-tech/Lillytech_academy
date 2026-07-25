-- 0004_seed_first_concept.sql
-- Primer concepto real de la Biblioteca de Conceptos (v1.2), enlazado a
-- la lección de Claves primarias como ejemplo del Principio de
-- reutilización del conocimiento en acción.

insert into public.concepts (id, title, slug, what_is, why_it_exists, problem_it_solves, when_to_use, common_mistakes, is_published) values
(
  'a1b6f9e2-3c4d-4e5f-8a9b-1c2d3e4f5a6b',
  'Row Level Security (RLS)',
  'row-level-security-rls',
  E'Un mecanismo de PostgreSQL que filtra automáticamente las filas que una consulta puede ver o modificar, según reglas (políticas) definidas por tabla — sin que el código de la aplicación tenga que acordarse de filtrar nada.',
  E'Existe porque confiar en que el frontend "no muestre" datos ajenos no es seguridad real — cualquiera con las herramientas de desarrollador del navegador puede llamar a la API directo. RLS mueve la regla de "quién puede ver qué" a la base de datos, donde no se puede saltar.',
  E'Resuelve el problema de que múltiples usuarias compartan las mismas tablas (por ejemplo, todas las estudiantes de LillyTech Academy comparten la tabla lesson_progress) sin poder ver ni modificar los datos de las demás — sin tener que duplicar tablas por usuaria ni filtrar "a mano" en cada consulta del frontend.',
  E'Siempre que una tabla contenga datos que pertenecen a usuarias distintas y no deban mezclarse (progreso, notas, proyectos), o contenido que solo cierto rol debería poder escribir (rutas, lecciones — solo admin).',
  E'- Confiar solo en ocultar botones en el frontend, sin activar RLS en la tabla — la tabla sigue expuesta si alguien llama a la API directo.\n- Escribir una política USING (true) "para que funcione" sin pensar la condición real — eso equivale a no tener RLS.\n- Olvidar activar RLS en una tabla nueva (en Postgres, RLS está desactivado por defecto hasta que se ejecuta ALTER TABLE ... ENABLE ROW LEVEL SECURITY).',
  true
);

-- Nota: no se enlaza todavía a ninguna lección — la Etapa 3 (Supabase),
-- que es donde correspondería, todavía no tiene lecciones con contenido
-- real. Cuando se carguen, se enlazan desde /admin/concepts/:id.
