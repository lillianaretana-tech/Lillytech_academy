-- 0007_seed_supabase_modulo2.sql
-- Módulo 2 de la Etapa 3 (Supabase): "Seguridad y acceso a datos".
-- Usa subquery por título para encontrar el curso — evita el problema de
-- ids fijos que ya nos pasó una vez con la Etapa 2.

insert into public.modules (id, course_id, title, description, order_index, is_published)
select 'e9b2b437-84fd-43c7-89ef-0cab53966397', id, 'Seguridad y acceso a datos', 'Usuarios, RLS en la práctica, policies, claves del proyecto y buenas prácticas de seguridad.', 2, true
from public.courses where title = 'Supabase en profundidad';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '3c7323c5-1834-488c-8f73-1384aa70eea1',
  'e9b2b437-84fd-43c7-89ef-0cab53966397',
  'Usuarios: de auth.users al panel de Authentication',
  'La diferencia entre las usuarias de tu aplicación y las colaboradoras que tienen acceso al proyecto Supabase en sí — dos conceptos de "usuario" que conviene no mezclar.',
  E'- Distinguir entre usuarias de la app (auth.users) y colaboradoras del proyecto Supabase.\n- Usar el panel Authentication → Users para gestionar cuentas manualmente.\n- Reconocer cuándo conviene crear un usuario a mano desde el dashboard en vez de por registro.',
  E'Hay dos tipos de "usuario" que conviene no confundir en Supabase:\n\n1. Usuarias de tu aplicación: las personas que se registran en tu app (en esta Academy, vos misma). Viven en auth.users, y ya las estudiamos en la Etapa 3 anterior.\n\n2. Colaboradoras del proyecto: personas con acceso al dashboard de supabase.com para ese proyecto específico (Settings → Team) — pueden ver código, correr SQL, cambiar configuración. Esto es completamente independiente de auth.users. Si en el futuro sumás a alguien que te ayude con el desarrollo de LillyTech, a esa persona la invitarías acá, no la registrarías como "estudiante".\n\nDentro del panel Authentication → Users, podés ver, buscar, y crear usuarias de tu app manualmente (sin que se registren ellas mismas) — es lo que probablemente usaste al principio de este proyecto para probar el login antes de que existiera la pantalla de registro.',
  E'Cuando creaste tu primer usuario de LillyTech Academy antes de que armáramos la pantalla de /signup, lo hiciste manual desde Authentication → Users → "Add user" — eso creó una fila en auth.users exactamente igual a como lo haría alguien registrándose por su cuenta.',
  E'Andá a Authentication → Users en tu dashboard y confirmá que tu usuario aparece ahí. Después, en Project Settings → Team, mirá quién tiene acceso de colaboradora al proyecto (probablemente solo vos, por ahora).',
  E'- Confundir "invitar a alguien al proyecto Supabase" con "registrar a alguien como usuaria de la app" — son paneles y propósitos distintos.\n- Dar acceso de colaboradora del proyecto a alguien que solo necesitaba ser usuaria de la app (le darías más permisos de los que necesita).\n- Olvidar que crear un usuario manual desde el dashboard no dispara los mismos flujos de bienvenida por email que un registro real.',
  E'- [ ] Puedo explicar la diferencia entre un usuario de mi app y una colaboradora del proyecto Supabase.\n- [ ] Sé dónde crear un usuario manual desde el dashboard.\n- [ ] Sé dónde gestionar quién tiene acceso al proyecto en sí.',
  10, 'Fundamentos', 'Authentication y la tabla auth.users', 1, true
),
(
  '048b743f-4326-45f4-b655-b6f87690cdb6',
  'e9b2b437-84fd-43c7-89ef-0cab53966397',
  'Activar RLS en una tabla nueva, paso a paso',
  'La mecánica concreta de encender Row Level Security en una tabla propia — qué comando corrés, qué cambia inmediatamente, y qué pasa si te olvidás.',
  E'- Activar RLS en una tabla con ALTER TABLE ... ENABLE ROW LEVEL SECURITY.\n- Explicar qué pasa con una tabla que tiene RLS activado pero cero políticas.\n- Reconocer esto como la mecánica detrás del concepto RLS ya estudiado.',
  E'Ya viste qué es y por qué existe Row Level Security en la ficha de ese concepto en tu Biblioteca — esta lección es la parte práctica: el comando exacto que lo activa.\n\nALTER TABLE public.mi_tabla ENABLE ROW LEVEL SECURITY;\n\nEsto es literalmente lo primero que hace cada una de las 11 migraciones de RLS de esta Academy, tabla por tabla. Un detalle importante que ya se menciona en los errores comunes del concepto RLS, pero que vale repetir en la práctica: una tabla con RLS activado y CERO políticas creadas queda completamente bloqueada — nadie puede leer ni escribir nada, ni siquiera vos como admin, hasta que agregues al menos una política. Esto es intencional: el default seguro es "nadie ve nada" hasta que se diga explícitamente lo contrario.\n\nPor eso, en las migraciones de esta Academy, el ALTER TABLE ... ENABLE ROW LEVEL SECURITY siempre va seguido inmediatamente de al menos una política CREATE POLICY — nunca se deja una tabla "a medias".',
  E'Si mañana creás una tabla nueva (por ejemplo, para una futura funcionalidad de certificados en PDF), y corrés el CREATE TABLE pero te olvidás del ALTER TABLE ... ENABLE ROW LEVEL SECURITY, esa tabla queda completamente abierta — cualquier usuaria autenticada podría leer y escribir cualquier fila. Es el error de seguridad más común y más grave en proyectos Supabase nuevos.',
  E'En el SQL Editor: SELECT relname, relrowsecurity FROM pg_class WHERE relname IN (''concepts'', ''lesson_progress'', ''application_settings''); — confirmá que las tres muestran relrowsecurity = true.',
  E'- Crear una tabla nueva y olvidarse de activar RLS — queda expuesta por defecto (a diferencia de lo que mucha gente asume).\n- Activar RLS pero no agregar ninguna política, dejando la tabla inutilizable sin darse cuenta de por qué "no aparece nada".\n- Pensar que RLS se activa solo, automáticamente, al crear la tabla — no es así, es un paso explícito.',
  E'- [ ] Puedo escribir el comando exacto para activar RLS en una tabla.\n- [ ] Puedo explicar qué pasa con una tabla que tiene RLS activado sin ninguna política.\n- [ ] Confirmé con una consulta que RLS está activo en al menos 3 tablas de mi proyecto.',
  10, 'Intermedio', 'Row Level Security (RLS)', 2, true
),
(
  '305b6d78-335c-44bd-8a05-c7d128786ad8',
  'e9b2b437-84fd-43c7-89ef-0cab53966397',
  'Escribir políticas: USING vs WITH CHECK',
  'La diferencia entre las dos condiciones que puede tener una política — una controla qué podés ver, la otra qué podés escribir — y por qué confundirlas es el error más común al escribir RLS.',
  E'- Explicar la diferencia entre USING y WITH CHECK.\n- Escribir una política que permita solo leer y escribir los propios datos.\n- Reconocer cuándo hace falta una política separada por operación (select/insert/update/delete) y cuándo alcanza con FOR ALL.',
  E'Una política (CREATE POLICY) tiene hasta dos condiciones distintas:\n\n- USING: se evalúa para filas que YA EXISTEN — decide qué filas podés ver (SELECT) o cuáles podés tocar en un UPDATE/DELETE.\n- WITH CHECK: se evalúa sobre la fila NUEVA o MODIFICADA — decide si el dato que estás por escribir es válido.\n\ncreate policy "personal_notes: own select"\n  on public.personal_notes for select\n  using (auth.uid() = user_id);\n\ncreate policy "personal_notes: own insert"\n  on public.personal_notes for insert\n  with check (auth.uid() = user_id);\n\nEn un INSERT no hay fila "existente" que filtrar (por eso INSERT nunca usa USING) — solo importa si la fila nueva es válida, por eso usa WITH CHECK. En un UPDATE, en cambio, aplican los dos: USING decide qué filas podés llegar a actualizar, y WITH CHECK decide si el resultado final de esa actualización sigue siendo válido (por ejemplo, que no le cambies el user_id a la nota de otra persona).\n\nCuando la misma condición sirve para leer y escribir, se puede usar FOR ALL en vez de escribir 4 políticas separadas — pero cuando la lógica difiere por operación (como en el contenido académico: leer es más permisivo que escribir), conviene una política por operación, como hicimos en las migraciones de esta Academy.',
  E'La política "lessons: admin update" que ya existe en esta Academy usa tanto USING como WITH CHECK con la misma condición (public.is_admin(auth.uid())) — porque tanto "quién puede llegar a tocar esta fila" como "el resultado final sigue siendo válido" dependen de lo mismo: que quien edita sea admin.',
  E'En el SQL Editor: SELECT policyname, cmd, qual, with_check FROM pg_policies WHERE tablename = ''personal_notes''; — vas a ver, para cada política, qué hay en la columna qual (equivalente a USING) y en with_check.',
  E'- Usar solo USING en una política de INSERT (no funciona — INSERT necesita WITH CHECK, no tiene filas existentes que filtrar con USING).\n- Pensar que USING y WITH CHECK son sinónimos — controlan momentos distintos: "qué existe" vs "qué se puede escribir".\n- Escribir with check (true) por comodidad, permitiendo que cualquiera inserte cualquier dato con cualquier user_id.',
  E'- [ ] Puedo explicar la diferencia entre USING y WITH CHECK con mis propias palabras.\n- [ ] Puedo escribir una política de INSERT usando WITH CHECK correctamente.\n- [ ] Puedo consultar pg_policies para ver el detalle de una política existente.',
  20, 'Intermedio', 'Activar RLS en una tabla nueva, paso a paso', 3, true
),
(
  '8191d96a-e846-4dfe-b6da-f9ccfb6fc23b',
  'e9b2b437-84fd-43c7-89ef-0cab53966397',
  'Claves anon y service role',
  'Las dos claves principales de un proyecto Supabase — una es segura de exponer, la otra nunca debería salir de un entorno controlado.',
  E'- Explicar la diferencia entre la anon key y la service role key.\n- Reconocer por qué la anon key puede vivir en el frontend sin problema.\n- Entender qué pasaría si la service role key se filtrara accidentalmente.',
  E'Cada proyecto Supabase tiene (entre otras) dos claves principales:\n\n- anon key: pensada para usarse en el frontend, es pública por diseño. No es "secreta" en el sentido de esconderla — cualquiera que abra las herramientas de desarrollador de tu navegador puede verla. Su seguridad no depende de mantenerla oculta, sino de que todas las tablas tengan RLS bien configurado. Es la que usa esta Academy en .env como VITE_SUPABASE_ANON_KEY.\n\n- service role key: se salta TODAS las políticas RLS — actúa como superusuaria de la base de datos. Nunca debe usarse en código que corra en el navegador de la usuaria, porque expondría acceso total a todos los datos de todas las personas, sin ningún filtro. Solo debería usarse en un entorno de servidor controlado (por ejemplo, una Edge Function) para tareas administrativas puntuales que necesiten saltarse RLS a propósito.\n\nEsta Academy, hasta ahora, no necesita la service role key en ningún lado — todo el MVP funciona con la anon key más políticas RLS bien escritas. Eso es una señal de buen diseño: cuantas menos veces necesites saltarte RLS, más simple y más segura queda la arquitectura.',
  E'El archivo src/lib/supabaseClient.ts de esta Academy solo lee VITE_SUPABASE_ANON_KEY — nunca la service role key. Si alguna vez ves un VITE_SUPABASE_SERVICE_ROLE_KEY en un archivo .env pensado para el frontend, es una señal de alerta: esa clave no debería estar ahí.',
  E'Andá a Project Settings → API en tu dashboard de Supabase y mirá las dos claves. Confirmá que la que está en tu archivo .env de esta Academy es la anon (public), no la service_role (secret).',
  E'- Poner la service role key en un archivo .env que se sube a Git o que corre en el navegador — expone acceso total a la base de datos.\n- Pensar que la anon key "también hay que esconderla" — no hace falta, su seguridad viene de RLS, no del secreto.\n- Usar la service role key para "resolver rápido" un problema de permisos, en vez de arreglar la política RLS que estaba mal escrita.',
  E'- [ ] Puedo explicar la diferencia entre anon key y service role key.\n- [ ] Confirmé que mi .env usa la anon key, no la service role.\n- [ ] Puedo explicar por qué esta Academy no necesita la service role key todavía.',
  15, 'Intermedio', 'Escribir políticas: USING vs WITH CHECK', 4, true
),
(
  'fd22c709-021d-41a5-be81-e99646dfc6c2',
  'e9b2b437-84fd-43c7-89ef-0cab53966397',
  'Buenas prácticas de seguridad, en conjunto',
  'Cómo se ven, juntas, todas las piezas de seguridad que ya estudiaste — un repaso aplicado a esta misma Academy, tabla por tabla.',
  E'- Repasar, integradas, las piezas de seguridad ya vistas: RLS, policies, claves.\n- Auditar una tabla real de esta Academy usando lo aprendido.\n- Formular el principio de "seguridad proporcional al riesgo" con tus propias palabras.',
  E'Esta lección no introduce conceptos nuevos — junta los que ya viste en un checklist aplicado. La seguridad de un proyecto Supabase bien hecho se apoya en estas piezas, todas presentes en esta Academy:\n\n1. RLS activado en toda tabla que tenga datos sensibles o por usuaria (ya lo confirmaste en la Lección 2 de este módulo).\n2. Políticas con condiciones reales, nunca using (true) sin justificar (repasá el concepto RLS en tu Biblioteca de Conceptos, sección "Errores comunes").\n3. USING y WITH CHECK usados correctamente según la operación (Lección 3).\n4. La service role key fuera del frontend, siempre (Lección 4).\n5. Principio de mínimo privilegio: cada política da exactamente el acceso necesario, ni más ni menos — por eso una estudiante no puede escribir contenido académico, y un admin sí.\n\nUn principio final, que ya se aplicó en el diseño de esta Academy sin nombrarlo explícitamente: la seguridad debe ser proporcional al riesgo. No hace falta la misma paranoia para proteger application_settings (config general) que para proteger datos personales — pero tampoco hay que relajar la seguridad de datos sensibles "para que sea más simple". El balance correcto depende de qué se protege, no de una regla única para todo.',
  E'Si comparás las políticas de learning_paths (contenido público para autenticados) con las de personal_notes (estrictamente privadas), vas a ver niveles de restricción distintos — no porque una tabla "importe menos", sino porque el tipo de dato que protegen es distinto. Esa es la seguridad proporcional al riesgo, aplicada.',
  E'Elegí 3 tablas de esta Academy (por ejemplo lesson_progress, learning_paths, application_settings) y para cada una respondé: ¿quién puede leer?, ¿quién puede escribir?, ¿por qué esas reglas tienen sentido para ese tipo de dato específico?',
  E'- Aplicar el mismo nivel de restricción a toda tabla "por las dudas", sin pensar el riesgo real de cada una.\n- Relajar la seguridad de una tabla sensible porque "complica el desarrollo" — la complejidad de RLS bien escrita es mucho menor que el costo de una filtración de datos.\n- Tratar la seguridad como un paso final en vez de una decisión de diseño desde el principio (como se hizo en esta Academy, con RLS desde la primera migración).',
  E'- [ ] Puedo auditar una tabla real y explicar sus reglas de acceso.\n- [ ] Puedo explicar "seguridad proporcional al riesgo" con un ejemplo propio.\n- [ ] Repasé el concepto RLS en la Biblioteca de Conceptos con esta lección como contexto adicional.',
  15, 'Intermedio', 'Claves anon y service role', 5, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  '6045459d-2c4e-4516-9bd3-023403728bc5',
  '3c7323c5-1834-488c-8f73-1384aa70eea1',
  'Confirmá tu usuario en el dashboard',
  'Andá a Authentication → Users en Supabase y confirmá que tu propio usuario aparece con el email correcto.',
  'evidence_link', 1
),
(
  'cbf18674-9cb7-429a-8938-374f2079e805',
  '048b743f-4326-45f4-b655-b6f87690cdb6',
  'Confirmá RLS activo en 3 tablas',
  'Corré la consulta a pg_class sugerida en la lección y confirmá que relrowsecurity = true en al menos 3 tablas.',
  'evidence_link', 1
),
(
  '9922bb64-773a-4124-b6c0-82080dbd044c',
  '305b6d78-335c-44bd-8a05-c7d128786ad8',
  'Encontrá un ejemplo real de USING y WITH CHECK juntos',
  'Buscá en las migraciones de esta Academy una política que use USING y WITH CHECK a la vez, y explicá por qué necesitaba las dos.',
  'short_answer', 1
),
(
  'fcc825df-7cb7-41c9-a787-3ff4c77e7704',
  '8191d96a-e846-4dfe-b6da-f9ccfb6fc23b',
  'Confirmá qué clave usás',
  'Revisá tu archivo .env y confirmá que la clave que aparece ahí es la anon key, comparándola con lo que ves en Project Settings → API.',
  'checklist', 1
),
(
  'b87cd1dd-eb67-4176-beda-54885d4607ee',
  'fd22c709-021d-41a5-be81-e99646dfc6c2',
  'Auditá 3 tablas propias',
  'Elegí 3 tablas de esta Academy y documentá, para cada una, quién puede leer y quién puede escribir, según sus políticas RLS reales.',
  'long_answer', 1
);

-- Estas 4 lecciones tratan RLS en profundidad — se enlazan al concepto ya
-- existente en vez de reexplicar qué es (Principio de reutilización).
insert into public.concept_lessons (concept_id, lesson_id) values
  ('a1b6f9e2-3c4d-4e5f-8a9b-1c2d3e4f5a6b', '048b743f-4326-45f4-b655-b6f87690cdb6'),
  ('a1b6f9e2-3c4d-4e5f-8a9b-1c2d3e4f5a6b', '305b6d78-335c-44bd-8a05-c7d128786ad8'),
  ('a1b6f9e2-3c4d-4e5f-8a9b-1c2d3e4f5a6b', '8191d96a-e846-4dfe-b6da-f9ccfb6fc23b'),
  ('a1b6f9e2-3c4d-4e5f-8a9b-1c2d3e4f5a6b', 'fd22c709-021d-41a5-be81-e99646dfc6c2');
