-- 0008_seed_supabase_modulo3.sql
-- Módulo 3 de la Etapa 3 (Supabase): "Funciones y datos en tiempo real".

insert into public.modules (id, course_id, title, description, order_index, is_published)
select 'c6b523ba-c5f7-453d-9c6e-25ef3bae7bb2', id, 'Funciones y datos en tiempo real', 'Funciones PostgreSQL, RPC, triggers, Storage y Realtime — lo que ya usamos y lo que todavía no.', 3, true
from public.courses where title = 'Supabase en profundidad';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '3fd3bac9-6839-443f-98d9-d094968c5542',
  'c6b523ba-c5f7-453d-9c6e-25ef3bae7bb2',
  'Funciones PostgreSQL',
  'Cómo empaquetar lógica que corre dentro de la base de datos misma, no en el código de tu app — ya usada dos veces en esta Academy sin que lo notaras como "una función".',
  E'- Explicar qué es una función de PostgreSQL y en qué se diferencia de una función de JavaScript.\n- Leer la definición de una función ya existente en esta Academy.\n- Reconocer cuándo conviene lógica en una función de base de datos en vez de en el frontend.',
  E'Una función de PostgreSQL (a veces llamada "stored procedure" en otros motores) es un bloque de lógica que vive y corre dentro de la base de datos, escrito generalmente en SQL o en PL/pgSQL (un lenguaje procedural que agrega if/else, loops, variables sobre SQL).\n\nEsta Academy ya tiene dos funciones reales, creadas en las migraciones:\n\ncreate or replace function public.set_updated_at()\nreturns trigger\nlanguage plpgsql\nas $$\nbegin\n  new.updated_at = now();\n  return new;\nend;\n$$;\n\nEsta actualiza automáticamente el campo updated_at de cualquier fila que se modifique — se reutiliza en más de 10 tablas distintas, en vez de repetir la misma lógica en cada una.\n\ncreate or replace function public.is_admin(check_user_id uuid)\nreturns boolean\nlanguage sql\nsecurity definer\nas $$\n  select exists (select 1 from public.user_roles where user_id = check_user_id and role = ''admin'');\n$$;\n\nEsta encapsula "¿esta persona es admin?" en un solo lugar, reutilizado en decenas de políticas RLS.\n\n¿Por qué poner lógica acá en vez de en JavaScript? Porque corre más cerca de los datos (más rápido para ciertas operaciones), y porque cuando la usan las políticas RLS, necesita ejecutarse dentro de la base de datos misma — no puede depender de código del frontend, que ni siquiera está disponible en ese contexto.',
  E'Sin la función is_admin(), cada una de las más de 20 políticas RLS de esta Academy que dicen "o sos admin" tendría que repetir la subconsulta completa a user_roles — con la función, se escribe una vez y se reutiliza en todas. Es el mismo Principio de reutilización del conocimiento, aplicado a código en vez de a contenido educativo.',
  E'En el SQL Editor: SELECT proname, prosrc FROM pg_proc WHERE proname IN (''is_admin'', ''set_updated_at'');. Vas a ver el código fuente real de ambas funciones, tal como quedaron guardadas en tu base de datos.',
  E'- Pensar que una función de PostgreSQL es lo mismo que una función de JavaScript "pero en SQL" — corre en un contexto distinto, con distintas capacidades y limitaciones.\n- Duplicar lógica en varias políticas en vez de extraerla a una función reutilizable, como se hizo con is_admin().\n- No usar security definer cuando hace falta (una función que necesita leer datos que la usuaria que la invoca no podría leer directamente).',
  E'- [ ] Puedo explicar qué es una función de PostgreSQL con mis propias palabras.\n- [ ] Puedo leer la definición de is_admin() y explicar qué hace.\n- [ ] Puedo dar un ejemplo de cuándo convendría crear una función nueva reutilizable.',
  15, 'Intermedio', 'Buenas prácticas de seguridad, en conjunto', 1, true
),
(
  'c593a99a-57da-4677-86c3-14f3a630d81a',
  'c6b523ba-c5f7-453d-9c6e-25ef3bae7bb2',
  'RPC: llamar funciones desde el frontend',
  'Cómo tu app React puede ejecutar una función de PostgreSQL directamente, para lógica que no encaja en un simple SELECT/INSERT/UPDATE.',
  E'- Explicar qué significa RPC (Remote Procedure Call) en el contexto de Supabase.\n- Reconocer cuándo una operación necesita RPC en vez de las operaciones CRUD normales de supabase-js.\n- Identificar un caso real (aunque no implementado todavía) donde esta Academy se beneficiaría de un RPC.',
  E'RPC significa "llamada a procedimiento remoto" — en Supabase, es la forma de invocar una función de PostgreSQL directamente desde tu app, con supabase.rpc(''nombre_funcion'', { parametros }).\n\nHasta ahora, todo lo que hace esta Academy usa las operaciones normales: .select(), .insert(), .update(), .delete(). Eso alcanza para la mayoría de los casos. RPC entra en juego cuando necesitás:\n\n- Lógica que involucra varias tablas en una sola operación atómica (relacionado con la lección de transacciones que ya viste en SQL).\n- Cálculos que conviene hacer en la base de datos, no trayendo todos los datos al frontend para calcularlos ahí.\n- Operaciones que necesitan permisos elevados de forma controlada (una función security definer, como is_admin(), pero pensada para ser llamada directamente, no solo usada dentro de políticas).\n\nUn ejemplo hipotético para esta Academy: la generación de un certificado (Fase 6 pendiente) podría ser una función RPC que, en una sola llamada atómica, calcula el % de avance, genera el código único, e inserta la fila en certificates — todo en el servidor, sin que el frontend tenga que orquestar tres pasos separados que podrían fallar a mitad de camino.',
  E'Si en el futuro generás certificados, en vez de que tu componente React haga tres llamadas separadas (calcular %, generar código, insertar fila), lo ideal sería una función generate_certificate(path_id) que hagas con supabase.rpc(''generate_certificate'', { path_id: ''...'' }) — una sola llamada, una sola transacción, sin estados intermedios inconsistentes si algo falla.',
  E'En el SQL Editor, mirá la definición de is_admin(): SELECT prosrc FROM pg_proc WHERE proname = ''is_admin'';. Aunque hoy se usa solo dentro de políticas, técnicamente también podrías llamarla por RPC: SELECT public.is_admin(auth.uid());.',
  E'- Usar RPC para todo, incluso operaciones simples que ya resuelve bien un .select() o .insert() normal — agrega complejidad innecesaria.\n- No usar RPC cuando hacía falta, forzando al frontend a orquestar varios pasos que deberían ser atómicos.\n- Olvidar los permisos de ejecución de la función (GRANT EXECUTE) — una función puede existir pero no estar autorizada para que el rol autenticado la invoque por RPC.',
  E'- [ ] Puedo explicar qué es RPC en una frase.\n- [ ] Puedo identificar un caso real donde RPC sería mejor que operaciones CRUD normales.\n- [ ] Sé cómo se vería la llamada desde el frontend con supabase.rpc().',
  15, 'Intermedio', 'Funciones PostgreSQL', 2, true
),
(
  'a7b1cc8b-757e-4b96-9864-2fbcb01fd176',
  'c6b523ba-c5f7-453d-9c6e-25ef3bae7bb2',
  'Triggers: código que se dispara solo',
  'Cómo hacer que la base de datos reaccione automáticamente a un cambio — ya usado dos veces en esta Academy para cosas que ni tu frontend ni vos tienen que recordar hacer a mano.',
  E'- Explicar qué es un trigger y cuándo se dispara.\n- Leer la definición de un trigger ya existente en esta Academy.\n- Distinguir entre lógica que conviene en un trigger vs. lógica que conviene en el código de la app.',
  E'Un trigger es una regla que le dice a Postgres "cuando pase X en esta tabla, ejecutá automáticamente esta función" — sin que ningún cliente (tu app, el SQL Editor, cualquier otra cosa) tenga que acordarse de dispararlo.\n\nEsta Academy ya tiene dos tipos de trigger funcionando:\n\n1. trg_lessons_updated_at (y sus equivalentes en otras 10 tablas): se dispara BEFORE UPDATE, y llama a la función set_updated_at() que ya viste. Nadie en el código de la app se acuerda de actualizar updated_at manualmente — Postgres lo hace solo, siempre, sin excepción.\n\n2. trg_on_auth_user_created: se dispara AFTER INSERT en auth.users (es decir, cada vez que alguien se registra), y llama a handle_new_user(), que crea el profile y asigna el rol student. Esto es lo que hace posible que el registro "simplemente funcione" sin que tu componente SignupPage tenga que hacer tres llamadas separadas después de crear la cuenta.\n\nLa gran ventaja de un trigger sobre "acordarse de hacerlo en el código": es imposible olvidarlo. Si alguna vez se te ocurre insertar una fila directo por SQL Editor sin pasar por tu app, el trigger se dispara igual, porque vive en la base de datos, no en el frontend.',
  E'Gracias al trigger trg_on_auth_user_created, cuando creaste usuarias manuales desde el dashboard de Supabase (Authentication → Add user) en vez de por el formulario de registro de tu app, esas usuarias igual recibieron su profile y su rol student automáticamente — el trigger no le importa por dónde entró la fila nueva a auth.users.',
  E'En el SQL Editor: SELECT tgname, tgrelid::regclass FROM pg_trigger WHERE tgname LIKE ''trg_%'';. Vas a ver la lista completa de triggers que ya existen en tu base de datos.',
  E'- Poner en un trigger lógica que debería vivir en el frontend (como mostrar un mensaje de error a la usuaria) — un trigger no puede "hablarle" a la interfaz.\n- No poner en un trigger algo que sí debería estar ahí (como la asignación de rol al registrarse), obligando al código de la app a acordarse de hacerlo manualmente cada vez.\n- Crear triggers en cascada que se disparan entre sí sin pensar el orden — puede generar comportamientos difíciles de predecir.',
  E'- [ ] Puedo explicar qué es un trigger y cuándo se ejecuta.\n- [ ] Puedo listar los triggers existentes en mi base de datos con una consulta.\n- [ ] Puedo explicar por qué trg_on_auth_user_created hace que el registro "funcione solo".',
  15, 'Intermedio', 'RPC: llamar funciones desde el frontend', 3, true
),
(
  '8e18b137-be82-4c43-8fd2-49a5f1c117b6',
  'c6b523ba-c5f7-453d-9c6e-25ef3bae7bb2',
  'Storage: guardar archivos, no solo filas',
  'El servicio de Supabase para imágenes, PDFs y otros archivos — que esta Academy todavía no usa, pero que necesitará el día que quiera exportar certificados en PDF.',
  E'- Explicar en qué se diferencia Storage de una tabla normal de la base de datos.\n- Entender el concepto de "bucket" y por qué también tiene sus propias políticas de acceso.\n- Identificar dónde encajaría Storage en el roadmap futuro de esta Academy.',
  E'Hasta ahora todo lo que guardamos son filas de texto, números y fechas — pero un archivo (una imagen, un PDF) no es eso. Storage es el servicio de Supabase pensado específicamente para archivos binarios.\n\nLos archivos se organizan en "buckets" (como carpetas de alto nivel) — por ejemplo, podrías tener un bucket certificates-pdfs y otro avatars. Cada bucket puede ser público (cualquiera con el link puede ver el archivo) o privado (requiere autenticación), y al igual que las tablas, tiene sus propias políticas de acceso — el mismo concepto de RLS que ya estudiaste, aplicado a archivos en vez de a filas.\n\nEsta Academy todavía no usa Storage para nada — lo dejamos anotado desde el plan original como pendiente para cuando quieras: exportar certificados a PDF real (hoy solo se genera el registro en la tabla certificates, sin el archivo en sí), o permitir subir capturas como evidencia de ejercicios (hoy solo se acepta un link).',
  E'El campo avatar_url de la tabla profiles de esta Academy hoy es un simple texto (pensado para guardar la URL de una imagen) — pero todavía no hay ningún lugar en la app donde subas esa imagen. Si quisieras esa función, subirías el archivo a un bucket de Storage, y guardarías la URL resultante en ese mismo campo avatar_url que ya existe.',
  E'Entrá al dashboard de Supabase → Storage, y mirá si ya tenés algún bucket creado (probablemente no todavía). Fijate la diferencia visual entre esa sección y el Table Editor — son dos sistemas de almacenamiento distintos dentro del mismo proyecto.',
  E'- Guardar el archivo completo (la imagen en sí) como una columna de una tabla — Postgres no está pensado para eso; Storage sí.\n- Crear un bucket público para datos que en realidad son sensibles, sin pensar las políticas de acceso.\n- Confundir la URL de un archivo (que sí podés guardar en una tabla) con el archivo en sí (que vive en Storage).',
  E'- [ ] Puedo explicar qué es un bucket y para qué sirve.\n- [ ] Entiendo que Storage tiene sus propias políticas de acceso, igual que las tablas.\n- [ ] Puedo identificar al menos un caso futuro de esta Academy donde haría falta Storage.',
  10, 'Intermedio', 'Triggers: código que se dispara solo', 4, true
),
(
  '7b35c796-538f-4a95-9c9e-8c35d70c5ece',
  'c6b523ba-c5f7-453d-9c6e-25ef3bae7bb2',
  'Realtime: recibir cambios sin recargar la página',
  'Cómo suscribirte a cambios en una tabla y enterarte al instante, sin que la app tenga que estar preguntando "¿hay algo nuevo?" todo el tiempo.',
  E'- Explicar qué problema resuelve Realtime frente a simplemente volver a consultar (refetch) cada tanto.\n- Entender la idea de "suscribirse" a cambios de una tabla.\n- Identificar un caso real donde esta Academy se beneficiaría de Realtime.',
  E'Hoy, cada vez que esta Academy necesita datos actualizados, hace una consulta nueva (por ejemplo, cuando volvés al Dashboard, se vuelve a pedir todo desde cero). Eso funciona bien para una sola usuaria trabajando sola, como es el caso actual.\n\nRealtime resuelve un problema distinto: cuando varias personas (o varias pestañas) podrían estar mirando los mismos datos al mismo tiempo, y quiere enterarse de cambios sin refrescar manualmente ni estar preguntando cada pocos segundos "¿cambió algo?" (polling). En vez de eso, te "suscribís" a una tabla, y Supabase te avisa en el momento exacto en que algo cambia:\n\nsupabase\n  .channel(''cambios-en-progreso'')\n  .on(''postgres_changes'', { event: ''UPDATE'', schema: ''public'', table: ''lesson_progress'' }, (payload) => {\n    // reaccionar al cambio en vivo\n  })\n  .subscribe();\n\nEsta Academy no usa Realtime hoy porque el MVP asume una sola usuaria-administradora trabajando — no hay necesidad de "enterarse en vivo" de cambios que hiciste vos misma en otra pestaña. Se volvería relevante recién si esto se convirtiera en multiusuario real (mencionado como fuera de alcance en el roadmap), por ejemplo si quisieras ver en vivo el progreso de otra persona estudiando al mismo tiempo que vos.',
  E'Si en el futuro LillyTech Academy tuviera una segunda estudiante real, y ambas quisieran ver un ranking de progreso compartido actualizándose solo, Realtime sería la pieza que evita que cada una tenga que refrescar la página para ver el avance de la otra.',
  E'No hace falta implementar nada — la aplicación práctica de esta lección es conceptual: pensá en cuál de las pantallas de esta Academy (Dashboard, Biblioteca, Administración → Progreso) se beneficiaría más de actualizarse en vivo si hubiera más de una persona usándola a la vez, y por qué.',
  E'- Usar Realtime para todo "porque suena moderno", cuando un simple refetch al volver a una pantalla ya resuelve el caso de uso real.\n- No activar Realtime en una tabla que sí lo necesitaría (hay que habilitarlo explícitamente por tabla en el dashboard).\n- Olvidar que las suscripciones de Realtime también respetan RLS — no vas a recibir eventos de filas que igual no podrías leer por política.',
  E'- [ ] Puedo explicar la diferencia entre refetch manual y una suscripción Realtime.\n- [ ] Puedo describir la forma general de un canal de Realtime con supabase-js.\n- [ ] Puedo identificar un escenario futuro de esta Academy donde Realtime aportaría valor real.',
  10, 'Intermedio', 'Storage: guardar archivos, no solo filas', 5, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  '4c2eb4b6-cbf8-4dc2-92e6-1f75b60c719b',
  '3fd3bac9-6839-443f-98d9-d094968c5542',
  'Leé el código fuente de una función real',
  'Corré SELECT prosrc FROM pg_proc WHERE proname = ''is_admin''; y explicá en tus palabras, línea por línea, qué hace.',
  'short_answer', 1
),
(
  'c8e092dd-9d68-4ff7-8f45-06ed4cc8fbae',
  'c593a99a-57da-4677-86c3-14f3a630d81a',
  'Diseñá un RPC futuro',
  'Describí cómo se vería (parámetros, qué haría adentro) una función RPC para generar un certificado, cuando llegues a esa fase del proyecto.',
  'short_answer', 1
),
(
  '12e667f4-3bdb-487a-b16e-0d3c69dd0001',
  'a7b1cc8b-757e-4b96-9864-2fbcb01fd176',
  'Listá todos tus triggers',
  'Corré la consulta a pg_trigger sugerida en la lección y contá cuántos triggers ya existen en tu base de datos.',
  'evidence_link', 1
),
(
  'a080ed1d-0037-40b8-9d8b-c7a1d1968e87',
  '8e18b137-be82-4c43-8fd2-49a5f1c117b6',
  'Explorá Storage en tu dashboard',
  'Entrá a la sección Storage de tu proyecto Supabase y describí qué verías si creases un bucket nuevo llamado avatars.',
  'short_answer', 1
),
(
  '7465b7ca-84e2-4e35-9ea7-2450dbd252b9',
  '7b35c796-538f-4a95-9c9e-8c35d70c5ece',
  'Identificá un caso de uso futuro',
  'Elegí una pantalla de esta Academy y explicá si se beneficiaría de Realtime en un escenario multiusuario, y por qué sí o por qué no.',
  'short_answer', 1
);
