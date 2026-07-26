-- 0023_seed_apis_modulo2.sql
-- Módulo 2 de la Etapa 8 (APIs y automatización): "Conectar sistemas externos".

insert into public.modules (id, course_id, title, description, order_index, is_published)
select 'a9d8854b-2bc9-4ef3-b68d-ebb7cf5d0139', id, 'Conectar sistemas externos', 'Webhooks, integraciones y Make — cómo sistemas distintos (incluidos varios de tus otros proyectos LillyTech) se avisan entre sí sin que nadie tenga que estar mirando.', 2, true
from public.courses where title = 'APIs, webhooks y Make en la práctica';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'ff292e11-d3ba-4696-895a-797fc4193927',
  'a9d8854b-2bc9-4ef3-b68d-ebb7cf5d0139',
  'Webhooks: que te avisen en vez de estar preguntando',
  'La diferencia entre preguntar todo el tiempo "¿pasó algo?" y que el otro sistema te avise apenas algo pase — la misma idea de fondo que ya viste con Realtime, aplicada entre sistemas distintos.',
  E'- Explicar qué es un webhook y qué problema resuelve.\n- Distinguir un webhook de una API que consultás vos misma (polling).\n- Relacionar la idea de webhook con lo ya visto sobre Realtime en Supabase.',
  E'Un webhook es, en esencia, una API "al revés": en vez de que vos le preguntes a un sistema "¿pasó algo nuevo?" repetidamente (polling), le decís de antemano "avisame vos apenas pase X, mandándome un pedido HTTP a esta URL" — y ese sistema cumple, mandándote la información apenas ocurre el evento, sin que tengas que estar consultando.\n\nEsta idea ya la viste, con otro nombre, en la lección de Realtime de la Etapa 3: la diferencia entre "preguntar todo el tiempo" y "que me avisen cuando pase algo" es exactamente la misma, solo que Realtime aplica esa idea DENTRO de tu propio proyecto Supabase (te avisa tu propia base de datos), y un webhook aplica la misma idea ENTRE sistemas distintos y externos entre sí (un sistema de pagos te avisa que se completó un cobro, un formulario externo te avisa que alguien lo llenó).\n\nEsta Academy no usa webhooks hoy — no hay ningún sistema externo que necesite avisarle nada. Pero es exactamente el tipo de mecanismo que usan tus otros proyectos LillyTech cuando se conectan con Make (próxima lección): por ejemplo, si Bruno''s Wordyssey necesitara avisar a algún sistema externo cuando alguien completa un logro, un webhook sería la forma estándar de hacerlo.',
  E'Si Safety Academy tuviera que notificar a un sistema externo cada vez que se completa una capacitación (por ejemplo, para generar un certificado en otra plataforma), la forma correcta sería configurar un webhook: Safety Academy manda un pedido HTTP a una URL del otro sistema apenas ocurre el evento, en vez de que el otro sistema esté consultando "¿ya se completó?" cada cierto tiempo.',
  E'No hay ejercicio con esta Academy (no usa webhooks) — la aplicación práctica es conceptual: para uno de tus otros proyectos (Inventario, Facilities), pensá un evento real que podría disparar un webhook hacia algún sistema externo.',
  E'- Usar polling (preguntar todo el tiempo) cuando un webhook sería más eficiente y más inmediato — desperdicia recursos consultando "¿pasó algo?" con más frecuencia de la necesaria.\n- No validar que un webhook entrante realmente viene de quien dice venir — los webhooks suelen incluir alguna firma o secreto para verificar su autenticidad, y omitir esa verificación es un riesgo de seguridad.\n- Confundir webhook con API normal — un webhook es información que TE MANDAN sin que la pidas en el momento; una API normal es información que VOS PEDÍS activamente.',
  E'- [ ] Puedo explicar qué es un webhook y en qué se diferencia de una API normal.\n- [ ] Puedo relacionar la idea de webhook con lo ya visto sobre Realtime.\n- [ ] Identifiqué un evento real de otro de mis proyectos que podría disparar un webhook.',
  15, 'Intermedio', 'Métodos HTTP: los verbos de la conversación', 1, true
),
(
  '536ac2ff-bf7f-443b-a982-a90da1e0bb12',
  'a9d8854b-2bc9-4ef3-b68d-ebb7cf5d0139',
  'Integraciones: cuando dos sistemas necesitan hablar',
  'La idea general detrás de "conectar" dos productos distintos — antes de entrar en la herramienta específica (Make) que hace esto en varios de tus proyectos.',
  E'- Explicar qué es una integración entre sistemas.\n- Reconocer los tres ingredientes típicos de cualquier integración.\n- Identificar integraciones reales (o posibles) en el ecosistema LillyTech.',
  E'Una integración es cualquier forma de hacer que dos sistemas independientes (que no fueron diseñados como una sola aplicación) trabajen juntos, compartiendo datos o disparando acciones entre sí. Casi toda integración tiene estos ingredientes:\n\n1. Un origen: el sistema donde ocurre el evento o vive el dato (por ejemplo, un formulario de Google Forms).\n2. Un destino: el sistema que necesita enterarse o recibir ese dato (por ejemplo, una hoja de cálculo, o una tabla de Supabase).\n3. Un mecanismo de conexión: cómo el origen le pasa la información al destino — puede ser un webhook (ya visto), una API que alguien consulta periódicamente, o una herramienta intermedia como Make (próxima lección) que orquesta todo el proceso sin que tengas que programar el "pegamento" vos misma.\n\nEsta Academy, como proyecto personal, no tiene integraciones externas hoy. Pero el ecosistema LillyTech en general sí las necesita: por ejemplo, si Control de Asistencia necesitara enviar un resumen semanal por email, eso sería una integración entre tu base de datos (origen) y un servicio de envío de correos (destino), probablemente orquestada por Make.',
  E'Si quisieras que, cada vez que completás una etapa entera en esta Academy, se te enviara automáticamente un email de felicitación, eso sería una integración: origen (esta Academy, evento "etapa completada"), destino (tu bandeja de entrada), mecanismo (probablemente Make, escuchando cambios en la tabla lesson_progress o learning_activity).',
  E'Pensá en uno de tus proyectos reales (Control de Asistencia, Inventario, Pedido mensual) y describí una integración que ya existe o que sería útil: cuál es el origen, cuál el destino, y qué mecanismo la conectaría.',
  E'- Intentar programar manualmente cada integración desde cero, cuando una herramienta como Make ya resuelve el "pegamento" entre sistemas sin escribir código.\n- No pensar en qué pasa si el destino de una integración está caído o no responde (tema que se retoma en la lección de reintentos).\n- Diseñar integraciones sin considerar los tres ingredientes básicos (origen, destino, mecanismo), llevando a soluciones más confusas de lo necesario.',
  E'- [ ] Puedo explicar qué es una integración con los tres ingredientes básicos.\n- [ ] Puedo describir una integración real o posible de uno de mis proyectos LillyTech.\n- [ ] Puedo distinguir origen, destino y mecanismo en ese ejemplo.',
  15, 'Intermedio', 'Webhooks: que te avisen en vez de estar preguntando', 2, true
),
(
  '3225afde-8dc5-4093-b190-c14320202ff2',
  'a9d8854b-2bc9-4ef3-b68d-ebb7cf5d0139',
  'Make: automatizar sin escribir un backend a medida',
  'La herramienta que ya usás (o podrías usar) en otros proyectos LillyTech para conectar sistemas sin programar el pegamento entre ellos.',
  E'- Explicar qué tipo de problema resuelve Make.\n- Entender la estructura básica de un escenario de Make (trigger + acciones).\n- Reconocer cuándo una automatización se beneficiaría de Make en vez de código a medida.',
  E'Make (antes conocido como Integromat) es una herramienta de automatización visual: te permite conectar distintos servicios (Google Sheets, Gmail, Supabase, y cientos más) armando "escenarios" sin escribir código — arrastrás y conectás bloques que representan disparadores (triggers) y acciones.\n\nUn escenario típico de Make tiene esta forma: "cuando pase X en el Sistema A (trigger), hacé Y en el Sistema B (acción)". Por ejemplo: "cuando se agregue una fila nueva en esta tabla de Supabase (trigger), enviá un email con esos datos (acción)".\n\nLa ventaja frente a escribir ese mismo pegamento en código propio: no necesitás mantener un servidor corriendo 24/7 esperando el evento, no necesitás preocuparte por reintentos ni por la infraestructura — Make se encarga de la parte operativa, vos solo definís el flujo. La desventaja: menos control fino que escribir tu propio código, y depender de un servicio externo con sus propios límites y costos según el volumen de uso.\n\nEsta Academy no usa Make hoy, pero es exactamente la herramienta que mencionaste en el plan original del proyecto para automatización de procesos en otros sistemas LillyTech — el lugar natural para, por ejemplo, conectar un formulario de solicitud de vacaciones con una notificación automática a quien aprueba.',
  E'Si en tu Control de vacaciones quisieras que, cada vez que se aprueba una solicitud, se actualice automáticamente una hoja de cálculo de resumen mensual, un escenario de Make con trigger "fila actualizada en Supabase con estado=aprobado" y acción "agregar fila en Google Sheets" resolvería eso sin que tuvieras que escribir ni una línea de código de backend.',
  E'Sin necesidad de crear una cuenta real en Make, describí cómo se vería un escenario para automatizar algo de uno de tus proyectos: cuál sería el trigger exacto, y cuál la acción resultante.',
  E'- Intentar reemplazar con Make automatizaciones que en realidad necesitan lógica compleja y específica — Make es potente para flujos simples y directos, no para reemplazar un backend completo.\n- No considerar los límites de uso (cantidad de operaciones por mes) del plan de Make elegido, algo que puede volverse un costo real si el volumen crece.\n- Crear escenarios complejos y frágiles sin documentar qué hacen, dejando una "caja negra" difícil de mantener después.',
  E'- [ ] Puedo explicar qué tipo de problema resuelve Make.\n- [ ] Puedo describir la estructura trigger + acción de un escenario.\n- [ ] Diseñé (sin implementar) un escenario real para uno de mis proyectos.',
  15, 'Intermedio', 'Integraciones: cuando dos sistemas necesitan hablar', 3, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'c8f770af-e091-4802-bfbb-e996d993512f',
  'ff292e11-d3ba-4696-895a-797fc4193927',
  'Identificá un webhook posible',
  'Para uno de tus proyectos LillyTech, describí un evento real que podría disparar un webhook hacia un sistema externo.',
  'short_answer', 1
),
(
  'a493ab1f-f157-4fdd-b449-4a91b00d1e08',
  '536ac2ff-bf7f-443b-a982-a90da1e0bb12',
  'Describí una integración con sus 3 ingredientes',
  'Elegí una integración real o posible de tus proyectos y describí su origen, destino y mecanismo de conexión.',
  'short_answer', 1
),
(
  'c4dfc72e-3107-4389-a69e-2d8f23a74fa8',
  '3225afde-8dc5-4093-b190-c14320202ff2',
  'Diseñá un escenario de Make',
  'Describí un escenario completo de Make para uno de tus proyectos: trigger exacto y acción resultante.',
  'short_answer', 1
);
