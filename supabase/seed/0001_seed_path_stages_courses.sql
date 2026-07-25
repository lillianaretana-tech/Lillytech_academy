-- 0001_seed_path_stages_courses.sql
-- Ruta inicial "Desarrollo de Aplicaciones LillyTech" con sus 11 etapas
-- y un curso por etapa. Los cursos quedan is_published = false hasta que
-- tengan contenido real cargado (evita mostrar cursos vacíos a la estudiante).

insert into public.learning_paths (id, title, description, is_published, order_index)
values (
  'b0cfb7cf-057d-429b-9fe0-486058889509',
  'Desarrollo de Aplicaciones LillyTech',
  'Ruta central de aprendizaje: de fundamentos de bases de datos hasta IA aplicada, aprendiendo con los proyectos reales de LillyTech (OnboardFlow, Safety Academy, Wordyssey y los que siguen).',
  true,
  0
);

insert into public.stages (id, path_id, title, description, order_index, is_published) values
  ('04b82db6-e1d9-4528-b5d2-95a286ddcffd', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'Fundamentos de bases de datos', 'Cómo piensa una base de datos: tablas, registros, claves y relaciones.', 1, true),
  ('ea80d5d8-9d1c-40ba-8dfd-21b1af7ab4eb', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'SQL', 'El lenguaje para consultar y modificar datos: de SELECT a transacciones.', 2, false),
  ('698ecb60-078e-437c-87aa-2270922753d2', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'Supabase', 'Auth, Row Level Security, Storage, Realtime y el resto del stack que ya usás en tus proyectos.', 3, false),
  ('c4bb3904-27e3-4ac4-b049-2158efc0bfb6', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'Arquitectura de aplicaciones', 'Frontend, backend, API, estado, sesiones y cómo se conecta todo.', 4, false),
  ('66aa0856-7c4b-441a-9065-879963dfe071', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'Desarrollo frontend', 'HTML, CSS, JS/TS y React aplicados a interfaces reales.', 5, false),
  ('4e5a202d-f72a-4a68-888d-cc53b21499c3', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'Git y GitHub', 'Control de versiones, branches, pull requests y flujo seguro de cambios.', 6, false),
  ('df520e7b-1718-494d-b422-08c1dbad4243', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'Seguridad práctica', 'Autenticación, autorización, RLS y manejo responsable de secretos.', 7, false),
  ('6596c873-140b-4ea9-8b6c-b121efb6a5a6', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'APIs y automatización', 'REST, webhooks, Make y automatización de procesos.', 8, false),
  ('ca64df10-69ad-4750-adfa-69e5813b48cd', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'Inteligencia artificial aplicada', 'Prompts técnicos, revisión de código generado y automatización con IA.', 9, false),
  ('bcdf4e72-5cb1-47e4-a658-b08f89dd472f', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'Gestión de productos digitales', 'MVP, historias de usuario, roadmap, precios y continuidad.', 10, false),
  ('d2e3be96-b5b3-4ff8-ae02-c1fe554b3f4d', 'b0cfb7cf-057d-429b-9fe0-486058889509', 'DevOps básico', 'Entornos, builds, deploy en Vercel, monitoreo y rollback.', 11, false);

insert into public.courses (id, stage_id, title, description, order_index, is_published) values
  ('f2deb3e7-5355-4e2d-bfcd-a63eee7cc382', '04b82db6-e1d9-4528-b5d2-95a286ddcffd', 'Cómo piensa una base de datos', 'Curso introductorio de la Etapa 1, con las 3 primeras lecciones completas.', 1, true),
  ('693d80c7-de35-4321-8048-970ff2aae3b3', 'ea80d5d8-9d1c-40ba-8dfd-21b1af7ab4eb', 'SQL desde cero hasta consultas de diagnóstico', 'Estructura del curso creada — contenido de lecciones pendiente de redactar.', 1, false),
  ('c67de672-715a-467c-b303-6b0edc9f4245', '698ecb60-078e-437c-87aa-2270922753d2', 'Supabase en profundidad', 'Estructura del curso creada — contenido de lecciones pendiente de redactar.', 1, false),
  ('ab21a9df-2a2d-4921-9be0-468753c26201', 'c4bb3904-27e3-4ac4-b049-2158efc0bfb6', 'Cómo se arma una aplicación real', 'Estructura del curso creada — contenido de lecciones pendiente de redactar.', 1, false),
  ('c34b2eb5-2d72-43c5-bbaa-5b3face2f6e8', '66aa0856-7c4b-441a-9065-879963dfe071', 'React aplicado a proyectos LillyTech', 'Estructura del curso creada — contenido de lecciones pendiente de redactar.', 1, false),
  ('f6eee0e1-f9a8-4c70-be9a-047fdfa632a1', '4e5a202d-f72a-4a68-888d-cc53b21499c3', 'Git y GitHub sin miedo', 'Estructura del curso creada — contenido de lecciones pendiente de redactar.', 1, false),
  ('668c648f-5bab-4e77-8253-eec4b9a79a5a', 'df520e7b-1718-494d-b422-08c1dbad4243', 'Seguridad proporcional al riesgo', 'Estructura del curso creada — contenido de lecciones pendiente de redactar.', 1, false),
  ('4e557269-4770-4c23-84f7-83c16dc48438', '6596c873-140b-4ea9-8b6c-b121efb6a5a6', 'APIs, webhooks y Make en la práctica', 'Estructura del curso creada — contenido de lecciones pendiente de redactar.', 1, false),
  ('47f5358b-2e7e-44f0-a3ed-1e1ada5d133a', 'ca64df10-69ad-4750-adfa-69e5813b48cd', 'IA como parte del flujo de trabajo', 'Estructura del curso creada — contenido de lecciones pendiente de redactar.', 1, false),
  ('e15047b1-e65a-4529-8cdb-9f0f3490d899', 'bcdf4e72-5cb1-47e4-a658-b08f89dd472f', 'De la idea al producto', 'Estructura del curso creada — contenido de lecciones pendiente de redactar.', 1, false),
  ('dc4f67f4-850b-471d-abc1-6c0d1a3b2684', 'd2e3be96-b5b3-4ff8-ae02-c1fe554b3f4d', 'Desplegar y mantener sin sustos', 'Estructura del curso creada — contenido de lecciones pendiente de redactar.', 1, false);
