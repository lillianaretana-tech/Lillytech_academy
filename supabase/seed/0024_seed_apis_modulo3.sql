-- 0024_seed_apis_modulo3.sql
-- Módulo 3 de la Etapa 8 (APIs y automatización): "Automatización robusta" — cierra la Etapa 8 completa.

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '5fadd9ee-f76d-4cb3-8f16-e6a8ecb63890', id, 'Automatización robusta', 'Automatización de procesos, reintentos y registro de eventos — lo que separa una automatización frágil de una confiable.', 3, true
from public.courses where title = 'APIs, webhooks y Make en la práctica';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '19c12389-d887-4b8e-a4b6-9085223d0de0',
  '5fadd9ee-f76d-4cb3-8f16-e6a8ecb63890',
  'Automatización de procesos: quitar pasos manuales repetitivos',
  'La idea general detrás de automatizar — no "hacer magia", sino identificar un paso manual que se repite siempre igual, y hacer que un sistema lo haga por vos.',
  E'- Definir qué hace que un proceso sea candidato a automatización.\n- Identificar automatización ya presente en esta Academy (triggers) frente a la manual que todavía queda.\n- Reconocer un proceso manual repetitivo de otro proyecto propio que podría automatizarse.',
  E'Un proceso es buen candidato a automatización cuando cumple tres condiciones: se repite (no es un caso único), sigue siempre la misma lógica (no requiere juicio humano caso por caso), y consume tiempo humano que podría dedicarse a otra cosa.\n\nEsta Academy ya tiene automatización real, sin necesitar Make ni ningún servicio externo — los triggers que ya estudiaste en la Etapa 3 son automatización pura: crear el profile y asignar el rol student al registrarse, actualizar updated_at en cada modificación. Ningún humano tiene que acordarse de hacer esas dos cosas — el sistema las hace solo, siempre, sin falta.\n\nLo que todavía es manual en esta Academy: redactar contenido nuevo (no debería automatizarse — necesita criterio humano real, no es un proceso repetitivo mecánico), y cargar ese contenido vía SQL Editor (esto sí podría automatizarse parcialmente en el futuro, por ejemplo con un script que tome un archivo markdown con cierto formato y genere el SQL automáticamente, en vez de escribirlo a mano cada vez).\n\nLa habilidad clave de esta lección: distinguir qué SÍ conviene automatizar (repetitivo, mecánico, sin juicio) de qué NO conviene (creativo, que requiere criterio, poco frecuente) — automatizar lo incorrecto agrega complejidad sin ahorrar el tiempo que importa.',
  E'El proceso de convertir el contenido de una lección en un INSERT SQL, que hicimos juntas manualmente varias veces en este proyecto, sigue siempre el mismo patrón — sería un candidato razonable a automatizar con un script, mientras que la REDACCIÓN del contenido en sí (que sí requiere pensar, ejemplificar, conectar con conceptos) no debería automatizarse de la misma forma.',
  E'Pensá en un proceso manual y repetitivo de otro de tus proyectos (por ejemplo, generar un resumen mensual de asistencia) y evaluá si cumple las tres condiciones de esta lección para ser un buen candidato a automatización.',
  E'- Automatizar procesos que en realidad necesitan juicio humano caso por caso, perdiendo calidad por ganar velocidad donde no correspondía.\n- No automatizar algo genuinamente repetitivo y mecánico, gastando tiempo humano en algo que un trigger o un script podría resolver.\n- Pensar que "automatización" siempre significa herramientas externas como Make — un trigger de Postgres, como ya viste, también es automatización real.',
  E'- [ ] Puedo nombrar las 3 condiciones que hacen a un proceso buen candidato a automatización.\n- [ ] Puedo identificar 2 automatizaciones ya reales en esta Academy (los triggers).\n- [ ] Evalué un proceso manual real de otro proyecto contra esas 3 condiciones.',
  15, 'Intermedio', 'Make: automatizar sin escribir un backend a medida', 1, true
),
(
  '09bd94fd-0fb6-49cb-bd1a-e6bf22b110a1',
  '5fadd9ee-f76d-4cb3-8f16-e6a8ecb63890',
  'Reintentos: qué hacer cuando el otro sistema no responde',
  'Ninguna integración es perfecta — internet falla, servicios se caen. Reintentar con criterio es lo que distingue una automatización robusta de una frágil.',
  E'- Explicar por qué las integraciones necesitan una estrategia de reintentos.\n- Entender la idea de "backoff exponencial" a nivel conceptual.\n- Reconocer qué operaciones NO deberían reintentarse sin cuidado (idempotencia).',
  E'Cualquier pedido a un sistema externo puede fallar por motivos temporales: el otro servicio está momentáneamente caído, hay un problema de red, un límite de uso se excedió por un momento. Una automatización robusta no se rinde ante el primer fallo — reintenta, pero con criterio.\n\nUna estrategia común es el backoff exponencial: si el primer intento falla, esperás un poco antes de reintentar (por ejemplo, 1 segundo); si vuelve a fallar, esperás más (2 segundos, después 4, después 8) — dándole tiempo al sistema externo para recuperarse, en vez de bombardearlo con reintentos inmediatos que podrían empeorar el problema.\n\nHay un cuidado importante antes de reintentar cualquier cosa: idempotencia — si reintentás una operación que YA se aplicó (por ejemplo, un POST que creó una fila, pero la respuesta se perdió por un problema de red antes de confirmarte que funcionó), un reintento simple podría crear la fila DOS VECES. Las operaciones de lectura (GET) son seguras de reintentar siempre; las de escritura necesitan más cuidado — por ejemplo, diseñar la operación para que sea segura de repetir (un UPSERT en vez de un INSERT simple, como ya usa el servicio de ejercicios de esta Academy).',
  E'El upsertResponse() del servicio exercises.service.ts de esta Academy usa upsert (insertar o actualizar si ya existe) en vez de un insert simple — eso lo hace naturalmente seguro de reintentar: si por algún motivo esa llamada se ejecutara dos veces, el resultado final sería el mismo, no una fila duplicada.',
  E'Buscá en el código de esta Academy otro lugar donde se use upsert en vez de insert, y explicá por qué esa elección hace esa operación más segura de reintentar.',
  E'- Reintentar inmediatamente y sin límite ante cualquier fallo, pudiendo empeorar un problema de sobrecarga en el sistema externo.\n- Reintentar operaciones no idempotentes (como un INSERT simple) sin ningún resguardo, arriesgando duplicados si el reintento coincide con que la operación original sí se había aplicado.\n- No tener ningún límite de reintentos, quedando en un bucle infinito si el problema no es temporal sino permanente.',
  E'- [ ] Puedo explicar por qué las integraciones necesitan una estrategia de reintentos.\n- [ ] Puedo explicar la idea de backoff exponencial.\n- [ ] Puedo explicar qué es idempotencia y por qué importa antes de reintentar una escritura.',
  15, 'Intermedio', 'Automatización de procesos: quitar pasos manuales repetitivos', 2, true
),
(
  '823b21c6-37bf-4e47-a7ae-3533ce231195',
  '5fadd9ee-f76d-4cb3-8f16-e6a8ecb63890',
  'Registro de eventos: dejar rastro de lo que pasó',
  'Repaso final de la etapa: por qué toda automatización debería dejar un rastro de qué hizo, aunque nadie lo mire nunca — hasta el día que sí haga falta.',
  E'- Explicar por qué una automatización debería registrar sus propias acciones.\n- Repasar cómo esta Academy ya hace esto con la Bitácora.\n- Cerrar la Etapa 8 conectando automatización con la idea de auditoría ya vista en la Etapa 7.',
  E'Esta lección cierra la etapa conectándola con algo ya visto: la Etapa 7 habló de auditoría como "reconstruir qué pasó, después de los hechos". Cuando el que actúa no es una persona sino una automatización (un trigger, un escenario de Make, un webhook procesado), esa necesidad de rastro es todavía más importante — porque no hay una persona que "recuerde" haber hecho la acción; si no queda registrado, es como si nunca hubiera pasado.\n\nEsta Academy ya registra eventos automáticos en learning_activity — cada vez que logActivity() se llama (al completar una lección, crear una nota, registrar una duda, cambiar un nivel de dominio), queda una fila con quién, qué tipo de evento, y cuándo. Esto no es casualidad: fue una decisión deliberada, para que la Bitácora (v1.4) tuviera datos reales desde el principio, en vez de una función vacía.\n\nSi mañana esta Academy tuviera integraciones reales con sistemas externos (un webhook entrante, un escenario de Make disparando cambios), la misma disciplina aplicaría: cada automatización debería dejar su propio rastro — qué recibió, qué hizo, si tuvo éxito o falló — para que cuando algo salga mal (y eventualmente algo sale mal), haya información real para diagnosticar, en vez de un silencio total sobre qué pasó.',
  E'Si un futuro webhook de Make actualizara datos de esta Academy automáticamente, la buena práctica sería que esa función también llamara a logActivity() con un evento tipo "automation_sync", igual que ya hacen setLessonStatus() y createProject() — así la Bitácora reflejaría también lo que hicieron los sistemas automáticos, no solo lo que hiciste vos manualmente.',
  E'Corré SELECT event_type, COUNT(*) FROM learning_activity GROUP BY event_type; y confirmá qué tipos de eventos ya se están registrando automáticamente en tu propia actividad de estudio.',
  E'- Construir una automatización sin ningún registro de lo que hizo, quedando "a ciegas" el día que algo falle silenciosamente.\n- Registrar demasiado detalle sensible en el registro de eventos (por ejemplo, contenido completo de una contraseña) — el registro también debe respetar los principios de protección de datos ya vistos.\n- Pensar que el registro de eventos es solo para depurar errores — también sirve para entender patrones de uso a lo largo del tiempo, como ya hace la Bitácora de esta Academy con tu propio aprendizaje.',
  E'- [ ] Puedo explicar por qué una automatización debería registrar sus propias acciones.\n- [ ] Puedo conectar esta idea con la auditoría ya vista en la Etapa 7.\n- [ ] Corrí la consulta de conteo de eventos y confirmé qué tipos ya se registran en mi propia actividad.',
  15, 'Intermedio', 'Reintentos: qué hacer cuando el otro sistema no responde', 3, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'f313d510-e1c4-4244-8db6-f38e38992537',
  '19c12389-d887-4b8e-a4b6-9085223d0de0',
  'Evaluá un proceso manual de otro proyecto',
  'Elegí un proceso manual y repetitivo de otro de tus proyectos LillyTech y evaluá si cumple las 3 condiciones para ser candidato a automatización.',
  'short_answer', 1
),
(
  '023953e4-568c-4385-a7b9-1f9da421ae6b',
  '09bd94fd-0fb6-49cb-bd1a-e6bf22b110a1',
  'Encontrá otro uso de upsert',
  'Buscá en el código de esta Academy otro lugar (además de exercises.service.ts) donde se use upsert, y explicá por qué esa elección importa para reintentos.',
  'short_answer', 1
),
(
  '1c01b183-896e-41c8-b009-f4fe81e117bf',
  '823b21c6-37bf-4e47-a7ae-3533ce231195',
  'Contá tus propios tipos de evento',
  'Corré la consulta GROUP BY sobre learning_activity y anotá qué tipos de evento ya tenés registrados, y cuántos de cada uno.',
  'evidence_link', 1
);
