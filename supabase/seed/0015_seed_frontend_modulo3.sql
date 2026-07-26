-- 0015_seed_frontend_modulo3.sql
-- Módulo 3 de la Etapa 5 (Desarrollo frontend): "Calidad de interfaz" — cierra la Etapa 5 completa.

insert into public.modules (id, course_id, title, description, order_index, is_published)
select 'f5574387-0492-484b-b745-779d9398bbf4', id, 'Calidad de interfaz', 'Validación, manejo de errores, diseño responsive y accesibilidad — lo que separa una interfaz que funciona de una que funciona bien para cualquiera.', 3, true
from public.courses where title = 'React aplicado a proyectos LillyTech';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '2a5b050a-2fa4-494f-9e7d-d6e3b77dc05e',
  'f5574387-0492-484b-b745-779d9398bbf4',
  'Validación: antes de confiar en un dato',
  'Cómo esta Academy revisa que un dato tenga sentido antes de enviarlo — y por qué esa revisión ocurre en más de un lugar a la vez, no solo en el frontend.',
  E'- Explicar qué es validación y distinguirla de autorización (ya vista en la Etapa 4).\n- Identificar validación real en un formulario de esta Academy.\n- Entender por qué la validación del frontend NO reemplaza las restricciones de la base de datos.',
  E'Validación es revisar que un dato tenga la forma y el contenido esperado antes de usarlo — un email con formato de email, una contraseña con longitud mínima, un campo obligatorio que no esté vacío. Es distinta de autorización (¿quién puede hacer esto?) — validación pregunta ¿este dato en sí mismo tiene sentido?, sin importar quién lo esté enviando.\n\nEsta Academy valida en el frontend usando atributos nativos de HTML, combinados con React:\n\n<input type="email" required />\n<input type="password" required minLength={6} />\n\nEl navegador mismo rechaza el envío del formulario si estos atributos no se cumplen, sin que haga falta JavaScript extra para los casos simples. Esto da una respuesta inmediata a la usuaria, sin esperar ningún viaje a la base de datos.\n\nPero acá está el punto central de la lección: esta validación de frontend es una comodidad de experiencia de usuaria, NO una garantía de seguridad — cualquiera podría saltarse el formulario y mandar un pedido directo a la API sin esos atributos. Por eso esta Academy también valida en la base de datos, con restricciones reales: NOT NULL en columnas obligatorias, CHECK en certificates para que completion_percentage esté entre 0 y 100, tipos enum que solo aceptan valores válidos (como lesson_status). Esa es la validación que realmente no se puede saltar — el mismo patrón de "frontend como conveniencia, base de datos como garantía real" que ya viste con autorización y RLS.',
  E'El campo password del formulario de registro tiene minLength={6} en el frontend (SignupPage.tsx) — pero eso no impide, por ejemplo, que Supabase Auth mismo tenga sus propias reglas mínimas de contraseña del lado del servidor, independientes de lo que el formulario de React exija visualmente.',
  E'Abrí SignupPage.tsx y encontrá los atributos de validación en cada input (required, minLength, type="email"). Después buscá el constraint CHECK en la migración de certificates y compará: son dos validaciones del mismo tipo de idea, en capas distintas.',
  E'- Confiar solo en la validación del frontend, sin restricciones equivalentes en la base de datos — deja la puerta abierta a datos inválidos si alguien evita el formulario.\n- Validar en el frontend con reglas más laxas que las que la base de datos realmente exige, generando errores confusos cuando el INSERT falla por una restricción que el formulario no anticipó.\n- No dar feedback claro a la usuaria cuando la validación falla, dejando que un error críptico de la base de datos llegue crudo a la pantalla.',
  E'- [ ] Puedo explicar qué es validación y en qué se diferencia de autorización.\n- [ ] Puedo encontrar validación de frontend en un formulario real de esta Academy.\n- [ ] Puedo encontrar una restricción equivalente en la base de datos (NOT NULL, CHECK, o enum).',
  15, 'Intermedio', 'Formularios: capturar lo que la usuaria escribe', 1, true
),
(
  'fe69a7a7-bb10-45af-a4d5-4643aecbfe37',
  'f5574387-0492-484b-b745-779d9398bbf4',
  'Manejo de errores: cuando algo sale mal',
  'Qué le muestra esta Academy a la usuaria cuando una consulta falla — en vez de una pantalla en blanco o un mensaje críptico de la base de datos.',
  E'- Explicar por qué el manejo de errores es parte del diseño de una interfaz, no un extra.\n- Leer el patrón try/catch usado en los servicios de esta Academy.\n- Reconocer la diferencia entre un error mostrado a la usuaria y uno solo logueado para diagnóstico.',
  E'Cualquier pedido a una base de datos puede fallar: sin conexión, una política RLS que rechaza la operación, una restricción violada. Manejo de errores es decidir qué pasa en ese caso — y hacerlo bien es tan parte del diseño de una pantalla como decidir qué mostrar cuando todo sale bien.\n\nEsta Academy sigue un patrón consistente en casi todas sus páginas:\n\nasync function loadAll() {\n  setLoading(true)\n  setError(null)\n  try {\n    const data = await getLesson(lessonId)\n    setLesson(data)\n  } catch (e) {\n    setError(e instanceof Error ? e.message : ''No se pudo cargar la lección.'')\n  } finally {\n    setLoading(false)\n  }\n}\n\nSi la promesa falla (el await getLesson lanza una excepción), el catch la atrapa y guarda un mensaje en el estado error, que la interfaz muestra en vez de una pantalla en blanco o un crash. El finally garantiza que loading se apague siempre, haya salido bien o mal.\n\nUna distinción importante: no todo error necesita mostrarse a la usuaria. En progress.service.ts, la función logActivity() usa console.error() en vez de lanzar el error hacia arriba — porque si falla el registro de bitácora, no tiene sentido interrumpir el flujo principal (como completar una lección) por un problema en una función secundaria de historial.',
  E'El error transitorio "No se pudo cargar la lección" que viste después de correr una migración nueva es exactamente este patrón funcionando: el catch atrapó el error real de PostgREST y lo mostró de forma legible, en vez de dejar que la página se rompiera sin explicación.',
  E'Buscá el patrón try/catch/finally en al menos dos servicios distintos de esta Academy (por ejemplo, DashboardPage.tsx y LibraryPage.tsx) y compará cómo cada uno decide qué mensaje mostrar en el catch.',
  E'- No envolver una llamada async en try/catch, dejando que un error no manejado rompa toda la pantalla sin ningún mensaje útil.\n- Mostrarle a la usuaria un error técnico crudo (como el mensaje exacto de Postgres) en vez de traducirlo a algo comprensible.\n- Usar el mismo manejo de error (interrumpir todo) para fallas críticas y para fallas secundarias que no deberían bloquear el flujo principal.',
  E'- [ ] Puedo explicar el patrón try/catch/finally usado en esta Academy.\n- [ ] Puedo encontrar un caso donde un error se loguea pero no se muestra a la usuaria, y explicar por qué tiene sentido.\n- [ ] Puedo distinguir un error que debería detener el flujo de uno que no.',
  15, 'Intermedio', 'Validación: antes de confiar en un dato', 2, true
),
(
  'f1ea30ea-7eff-4b42-988c-f80c2052e0bc',
  'f5574387-0492-484b-b745-779d9398bbf4',
  'Diseño responsive: la misma app, distintas pantallas',
  'Cómo esta Academy se ve bien tanto en tu computadora como en el teléfono, sin ser dos aplicaciones distintas.',
  E'- Explicar qué es diseño responsive y por qué importa.\n- Leer las clases responsive de Tailwind usadas en AppLayout.\n- Identificar el breakpoint que esta Academy usa para pasar de vista móvil a escritorio.',
  E'Diseño responsive significa que la misma interfaz se adapta al tamaño de pantalla disponible, en vez de tener una versión "de escritorio" y otra "de móvil" completamente separadas y mantenidas por separado.\n\nTailwind (que ya usa esta Academy) maneja esto con prefijos de breakpoint en las clases: una clase sin prefijo aplica siempre, y con el prefijo md: aplica solo a partir de cierto ancho de pantalla (768px por defecto):\n\n<aside className="hidden w-64 flex-shrink-0 ... md:flex md:flex-col">\n\nEsta línea real de AppLayout.tsx dice: "por defecto, escondé este elemento (hidden) — pero a partir del breakpoint md, mostralo como flex". Es exactamente cómo el sidebar de esta Academy aparece en pantallas grandes y desaparece en el teléfono, reemplazado por el menú hamburguesa que sí se muestra solo en pantallas chicas (md:hidden en el header móvil).\n\nLa idea clave: no son dos interfaces distintas con código duplicado — es la MISMA interfaz, con clases que activan o desactivan comportamientos según el ancho disponible. Todo vive en el mismo archivo AppLayout.tsx.',
  E'Cuando probaste esta Academy en el navegador con la ventana angosta (o en el teléfono), viste el menú "Menú" en vez del sidebar fijo — eso es exactamente hidden md:flex y md:hidden trabajando juntos en el mismo componente, sin ningún código separado para "versión móvil".',
  E'Abrí las herramientas de desarrollador del navegador, activá el modo responsive (ícono de teléfono/tablet), y probá angostar la ventana de esta Academy hasta ver el sidebar transformarse en el menú móvil. Anotá en qué ancho aproximado ocurre el cambio.',
  E'- Construir vistas de escritorio y móvil como componentes totalmente separados, duplicando lógica y arriesgando que se desincronicen con el tiempo.\n- No probar nunca en tamaños de pantalla intermedios (tablets), asumiendo que solo existen "computadora" y "teléfono".\n- Usar unidades fijas en píxeles para todo, en vez de aprovechar utilidades responsive que ya manejan la adaptación por vos.',
  E'- [ ] Puedo explicar qué es diseño responsive.\n- [ ] Puedo leer una clase con prefijo md: y explicar qué hace.\n- [ ] Probé el cambio de sidebar a menú móvil angostando la ventana del navegador.',
  10, 'Intermedio', 'Manejo de errores: cuando algo sale mal', 3, true
),
(
  '8b7201fa-a5d0-4cb1-8bfe-a69271de60b0',
  'f5574387-0492-484b-b745-779d9398bbf4',
  'Accesibilidad básica: que cualquiera pueda usarla',
  'Pequeñas decisiones que hacen que una interfaz funcione también para quien navega con teclado o con un lector de pantalla — y que ya empezaron a estar presentes en esta Academy.',
  E'- Explicar qué es accesibilidad y por qué es parte del diseño, no un agregado opcional.\n- Identificar prácticas de accesibilidad ya presentes en esta Academy.\n- Reconocer al menos una mejora de accesibilidad pendiente en este mismo proyecto.',
  E'Accesibilidad es diseñar y construir para que la interfaz funcione también para personas que no interactúan "de la forma típica" — navegando solo con teclado, usando un lector de pantalla, con baja visión, o con dificultad para hacer clics precisos.\n\nAlgunas prácticas ya presentes en esta Academy, sin nombrarlas explícitamente hasta ahora:\n\n- Usar <button> real en vez de <div onClick> (ya visto en la lección de HTML de este módulo) — un lector de pantalla anuncia un botón como botón, y es alcanzable con la tecla Tab, algo que un <div> no ofrece gratis.\n- El atributo aria-label="Abrir menú" en el botón hamburguesa del menú móvil (AppLayout.tsx) — describe la función del botón para quien no puede verlo, ya que el ícono solo no dice nada a un lector de pantalla.\n- Etiquetas <label htmlFor="email"> conectadas a su <input id="email"> correspondiente en los formularios de login y registro — permite que un lector de pantalla anuncie correctamente qué campo es cada uno.\n\nUna mejora pendiente real: los badges de estado (StatusBadge, StatusPill) transmiten el estado solo con color (verde para completada, gris para sin empezar) — alguien con daltonismo podría no distinguir la diferencia. Agregar también un ícono o mantener siempre el texto visible (como ya se hace) ayuda a no depender únicamente del color.',
  E'El aria-label="Abrir menú" en el botón hamburguesa de esta Academy existe justamente porque ese botón solo tiene el texto "Menú" — sin ese atributo, en un ícono puramente visual, un lector de pantalla no tendría ninguna forma de anunciar qué hace ese botón.',
  E'Navegá esta Academy usando solo el teclado (Tab para moverte, Enter para activar) sin tocar el mouse. Confirmá si podés llegar al botón de cerrar sesión y activarlo sin problemas.',
  E'- Comunicar información importante solo con color, sin texto o ícono de respaldo (el caso real de los badges de estado de esta Academy).\n- Usar <div> o <span> con onClick para algo que funcionalmente es un botón, perdiendo navegación por teclado gratis.\n- No probar nunca la navegación solo con teclado, asumiendo que "todos usan mouse".',
  E'- [ ] Puedo explicar qué es accesibilidad y por qué importa.\n- [ ] Puedo encontrar al menos un aria-label o htmlFor ya presente en esta Academy.\n- [ ] Probé navegar la app solo con teclado y anoté qué tan bien funcionó.',
  15, 'Intermedio', 'Diseño responsive: la misma app, distintas pantallas', 4, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'cf2cfee8-dbd2-46d5-b327-eb4313d90611',
  '2a5b050a-2fa4-494f-9e7d-d6e3b77dc05e',
  'Compará validación de frontend y de base de datos',
  'Encontrá un atributo de validación en un formulario (required, minLength) y una restricción equivalente en una migración (NOT NULL, CHECK). Explicá cómo se complementan.',
  'short_answer', 1
),
(
  '201013f4-0e55-4b84-bd8a-d86f216317db',
  'fe69a7a7-bb10-45af-a4d5-4643aecbfe37',
  'Encontrá dos manejos de error distintos',
  'Buscá un caso donde el error se muestra a la usuaria y otro donde solo se loguea con console.error. Explicá por qué cada uno se maneja así.',
  'short_answer', 1
),
(
  '0cc4e779-1027-4e6b-b41b-05c5ac2fb372',
  'f1ea30ea-7eff-4b42-988c-f80c2052e0bc',
  'Encontrá el punto de quiebre responsive',
  'Con las herramientas de desarrollador en modo responsive, angostá la ventana hasta que el sidebar se convierta en menú móvil. Anotá el ancho aproximado donde ocurre.',
  'evidence_link', 1
),
(
  '9fec653d-4d1a-4840-9bff-7ebe2392309c',
  '8b7201fa-a5d0-4cb1-8bfe-a69271de60b0',
  'Navegá solo con teclado',
  'Probá usar esta Academy sin mouse, solo con Tab y Enter, durante al menos un minuto. Anotá qué funcionó bien y qué te resultó difícil o imposible.',
  'short_answer', 1
);
