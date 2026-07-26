-- 0019_seed_seguridad_modulo1.sql
-- Módulo 1 de la Etapa 7 (Seguridad práctica): "Principios transversales".
-- Nota: Autenticación, Autorización, RLS y Validación de entradas YA están
-- desarrollados en profundidad en las Etapas 3 y 4 — no se duplican acá,
-- se enlazan al final de este archivo (Principio de reutilización).

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '23d19c30-654a-4e3c-accb-e787ccd9a97c', id, 'Principios transversales', 'Mínimo privilegio, protección de datos y manejo de secretos — ideas que atraviesan toda decisión de seguridad, ya vividas parcialmente en esta Academy.', 1, true
from public.courses where title = 'Seguridad proporcional al riesgo';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'bcb63561-b7ee-4129-838f-f25fc6ca1fd5',
  '23d19c30-654a-4e3c-accb-e787ccd9a97c',
  'Principio de mínimo privilegio',
  'Dar exactamente el acceso necesario, ni un poco más — la idea que explica por qué existen dos roles en esta Academy en vez de uno solo con todo el poder.',
  E'- Definir el principio de mínimo privilegio con tus propias palabras.\n- Identificar dónde ya se aplica en esta Academy.\n- Reconocer una situación donde violarlo tendría consecuencias reales.',
  E'El principio de mínimo privilegio dice: cada persona (o sistema) debería tener exactamente el acceso necesario para hacer su trabajo, ni más ni menos. No es "dar poco acceso por desconfianza" — es dar el acceso correcto, ajustado a lo que realmente hace falta.\n\nEsta Academy ya lo aplica de varias formas concretas:\n\n- El rol student puede leer contenido publicado y escribir sus propios datos — no puede tocar contenido académico ajeno.\n- El rol admin puede escribir contenido académico — pero ni siquiera admin tiene un "modo dios" que se salte RLS; sigue sujeto a las mismas políticas, solo que estas le dan más permisos donde corresponde.\n- La anon key del frontend nunca tiene el poder de la service role key — el frontend solo puede hacer lo que las políticas RLS permiten, nunca más.\n- El trigger handle_new_user() asigna automáticamente el rol student al registrarse, NUNCA el rol admin — ese privilegio mayor requiere una acción manual y deliberada.\n\nEste último ejemplo es clave: el rol más peligroso (admin) nunca se otorga por defecto ni automáticamente. Cada vez que alguien recibe privilegios adicionales en esta Academy, es una decisión explícita, nunca un accidente de configuración.',
  E'Si el trigger handle_new_user() asignara accidentalmente el rol admin en vez de student a cada usuaria nueva, cualquier persona que se registrara tendría acceso completo para editar o borrar todo el contenido académico — un ejemplo real de por qué el mínimo privilegio como default es tan importante.',
  E'Revisá la migración 0002_profiles_and_roles.sql y confirmá que handle_new_user() asigna explícitamente ''student'', nunca ''admin''. Pensá qué pasaría si ese valor estuviera mal escrito.',
  E'- Dar más acceso "por las dudas" o "para no tener que pedir permisos de nuevo después" — cada privilegio de más es una superficie de riesgo adicional.\n- Que el rol por defecto de un sistema nuevo sea el más poderoso, en vez del más restringido.\n- No revisar periódicamente si alguien todavía necesita un privilegio que se le dio hace tiempo para una tarea puntual ya terminada.',
  E'- [ ] Puedo definir el principio de mínimo privilegio con mis propias palabras.\n- [ ] Puedo señalar 2 ejemplos reales de este principio en esta Academy.\n- [ ] Confirmé que el rol por defecto al registrarse es student, nunca admin.',
  15, 'Intermedio', 'Flujo seguro de cambios: todo lo de este módulo, en la práctica diaria', 1, true
),
(
  '49220f4e-fc6f-42fe-ae86-6e8c765d21e1',
  '23d19c30-654a-4e3c-accb-e787ccd9a97c',
  'Protección de datos: no todo dato pesa igual',
  'Clasificar qué tan sensible es cada dato antes de decidir cómo protegerlo — el paso previo a escribir cualquier política RLS.',
  E'- Clasificar datos según su nivel de sensibilidad.\n- Identificar ejemplos de cada categoría dentro del modelo de datos de esta Academy.\n- Relacionar esta clasificación con las decisiones de RLS ya tomadas.',
  E'Antes de decidir CÓMO proteger un dato, hace falta decidir QUÉ TAN sensible es — no toda información merece el mismo nivel de cuidado. Una forma simple de clasificar:\n\n- Público: no importa quién lo vea (el título de una lección publicada).\n- Interno/personal: pertenece a una persona específica, no debería verse por otras (tus notas, tu progreso, tus proyectos).\n- Sensible: su exposición tendría consecuencias serias (contraseñas — que ni siquiera esta Academy guarda directamente, delegado a Supabase Auth; o, en otros contextos, datos financieros o de salud).\n\nEsta Academy no maneja datos de la categoría más sensible (no hay información financiera ni de salud), pero sí tiene datos personales que merecen protección real: tus notas, tus dudas, tu progreso, tus proyectos — todos protegidos con RLS filtrando por auth.uid() = user_id.\n\nEsta clasificación es lo que justifica por qué las políticas RLS de esta Academy no son todas iguales: el contenido académico (público, dentro de lo publicado) tiene políticas más permisivas de lectura; los datos personales tienen políticas estrictamente privadas. La clasificación viene primero; la política RLS es la consecuencia técnica de esa clasificación.',
  E'Si mañana esta Academy agregara un campo de "notas médicas" o "información financiera" (algo que hoy no tiene y probablemente nunca necesite), esos datos entrarían en la categoría más sensible, y ameritarían protecciones adicionales más allá de RLS estándar — posiblemente encriptación adicional a nivel de columna, algo que hoy ninguna tabla de esta Academy necesita.',
  E'Elegí 5 tablas de esta Academy y clasificá cada una como público/interno/sensible según el criterio de esta lección. Confirmá que la clasificación coincide con el nivel de protección que ya tienen sus políticas RLS.',
  E'- Aplicar la misma protección a todo dato sin distinguir su sensibilidad real — desperdicia esfuerzo en datos públicos y podría quedarse corto en datos realmente sensibles.\n- No reconocer cuándo un dato "aparentemente inocuo" en realidad es sensible en combinación con otros (por ejemplo, el email por sí solo es poco sensible, pero email + progreso + notas juntos arman un perfil detallado de una persona).\n- Clasificar datos una sola vez al diseñar el sistema y nunca revisar si esa clasificación sigue siendo correcta a medida que el sistema crece.',
  E'- [ ] Puedo clasificar un dato como público, interno o sensible.\n- [ ] Puedo justificar la clasificación de 5 tablas reales de esta Academy.\n- [ ] Puedo explicar por qué la clasificación viene antes de decidir la política RLS, no al revés.',
  15, 'Intermedio', 'Principio de mínimo privilegio', 2, true
),
(
  '49030a05-822d-497b-84ea-1ff0984b95e2',
  '23d19c30-654a-4e3c-accb-e787ccd9a97c',
  'Manejo de secretos',
  'Repaso enfocado de algo ya visto en la Etapa 3 (claves anon y service role), esta vez desde la pregunta general: ¿qué es un secreto, y dónde NO debería vivir nunca?',
  E'- Definir qué hace que un valor de configuración sea "secreto".\n- Repasar dónde viven (y dónde NO viven) los secretos de esta Academy.\n- Reconocer los lugares típicos donde los secretos se filtran por descuido.',
  E'Un secreto, en este contexto, es cualquier valor que si se filtrara le daría a alguien no autorizado acceso o poder que no debería tener — una contraseña, una clave de API privada, una service role key.\n\nEsta Academy ya definió con cuidado dónde viven sus secretos (ya visto en la Etapa 3, lección de claves anon y service role):\n\n- La anon key vive en .env, y NO es secreta en sentido estricto (es pública por diseño) — pero igual no se commitea, por prolijidad y para no acoplar el repo a un proyecto específico.\n- La service role key nunca vivió en ningún archivo de este proyecto — ni siquiera se necesitó hasta ahora.\n- Las contraseñas de las usuarias nunca se guardaron en ninguna tabla propia — viven encriptadas dentro de auth.users, gestionadas por Supabase Auth.\n\nLos lugares típicos donde los secretos se filtran, más allá de esta Academy: subir un .env real a un repo público sin darse cuenta, pegar una clave dentro del código en vez de leerla de una variable de entorno, o compartir capturas de pantalla que sin querer muestran una clave visible en la terminal.',
  E'El archivo .gitignore de esta Academy incluye .env explícitamente desde la Fase 2 — esa única línea es la que evita, de forma automática y sin que tengas que acordarte cada vez, que tu archivo de configuración real termine subido a GitHub por accidente.',
  E'Corré git log --all --full-history -- .env en tu proyecto (si devuelve vacío, es buena señal: significa que .env nunca fue parte del historial de Git, ni siquiera en un commit viejo).',
  E'- Pegar una clave directo en el código "solo por ahora, después la saco" — y olvidarse, dejándola commiteada permanentemente en el historial.\n- Compartir capturas de pantalla de la terminal o del editor sin revisar si hay alguna clave visible en ese momento.\n- Pensar que borrar un archivo con secretos del último commit los elimina del historial — si ya se subió alguna vez, sigue estando en commits anteriores hasta que se reescriba el historial deliberadamente.',
  E'- [ ] Puedo definir qué hace que un valor sea "secreto".\n- [ ] Puedo repasar dónde viven los secretos (y dónde no) en esta Academy.\n- [ ] Corrí la consulta al historial de Git y confirmé que .env nunca se subió.',
  10, 'Intermedio', 'Protección de datos: no todo dato pesa igual', 3, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'e6b0be6f-fc52-43bc-957e-58a61cd2673f',
  'bcb63561-b7ee-4129-838f-f25fc6ca1fd5',
  'Confirmá el rol por defecto',
  'Revisá la migración 0002 y confirmá, leyendo el código, que el rol asignado automáticamente al registrarse es student.',
  'evidence_link', 1
),
(
  'cbdb73f9-ff12-4717-ba0b-97835dcafd49',
  '49220f4e-fc6f-42fe-ae86-6e8c765d21e1',
  'Clasificá 5 tablas por sensibilidad',
  'Elegí 5 tablas de esta Academy y clasificá cada una como público, interno o sensible, justificando tu elección.',
  'short_answer', 1
),
(
  '41ea37a5-5794-48f1-b65f-c84bb2602ed6',
  '49030a05-822d-497b-84ea-1ff0984b95e2',
  'Confirmá que .env nunca se subió',
  'Corré git log --all --full-history -- .env en tu proyecto y confirmá que no aparece ningún resultado.',
  'evidence_link', 1
);

-- Este módulo trata mínimo privilegio, protección de datos y secretos —
-- todos ideas hermanas de RLS, ya documentado como concepto. Se enlaza acá
-- para reforzar la red de conocimiento (Principio de reutilización).
insert into public.concept_lessons (concept_id, lesson_id) values
  ('a1b6f9e2-3c4d-4e5f-8a9b-1c2d3e4f5a6b', 'bcb63561-b7ee-4129-838f-f25fc6ca1fd5'),
  ('a1b6f9e2-3c4d-4e5f-8a9b-1c2d3e4f5a6b', '49220f4e-fc6f-42fe-ae86-6e8c765d21e1');
