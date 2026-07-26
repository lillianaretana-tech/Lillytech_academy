-- 0026_seed_producto_etapa10_completa.sql
-- Etapa 10 completa (Gestión de productos digitales): 3 módulos, 12 lecciones.
-- Todo el contenido usa el propio LillyTech Academy (y su Plan Evolutivo)
-- como caso de estudio, además de otros proyectos LillyTech donde aplica.

-- ============ MÓDULO 1: Definir el problema ============

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '65acbaaa-be94-463a-9f00-393a45b88369', id, 'Definir el problema', 'Identificación de problemas, requisitos, MVP e historias de usuario — la parte del trabajo de producto que pasa antes de escribir código.', 1, true
from public.courses where title = 'De la idea al producto';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'ef5e763e-2fc4-432b-874d-5ac8a6fc65cc',
  '65acbaaa-be94-463a-9f00-393a45b88369',
  'Identificación de problemas',
  'Antes de "¿qué construyo?" viene "¿qué problema real tengo?" — la pregunta que dio origen a esta misma Academy.',
  E'- Distinguir un problema real de una solución disfrazada de problema.\n- Repasar el problema real que dio origen a LillyTech Academy.\n- Practicar identificar el problema detrás de una idea de producto propia.',
  E'Un error común al empezar un producto es partir de una solución ("quiero hacer una app de X") sin haber articulado primero el problema real que esa solución resolvería. "Quiero una plataforma de cursos" es una solución; "no tengo dónde organizar todo lo que voy aprendiendo, y se me olvida o se dispersa entre notas sueltas" es el problema real.\n\nEsta Academy nació exactamente así: el documento original del proyecto no empezó pidiendo "una plataforma de e-learning" — empezó articulando un problema concreto: aprender tecnología de forma práctica, con un objetivo específico (comprender el porqué de las decisiones técnicas, no memorizar, para poder diseñar mejores soluciones y trabajar con IA de igual a igual). La plataforma fue la solución elegida DESPUÉS de tener claro el problema.\n\nUna forma simple de comprobar si tenés un problema real bien identificado: si pudieras resolver el problema sin construir nada (por ejemplo, con una libreta de papel), ¿serviría, aunque sea de forma incómoda? Si la respuesta es sí, tenés un problema real; la tecnología solo lo hace más práctico.',
  E'Si a esta Academy le hubieras pedido "quiero un CRUD de cursos" sin el problema de fondo (comprensión profunda, conexión entre proyectos reales, memoria acumulada de años), hoy tendrías una lista de lecciones sin biblioteca de conceptos, sin bitácora, sin nivel de dominio — funcionalidades que existen precisamente porque respondían al problema real, no a la idea genérica de "plataforma de cursos".',
  E'Elegí una idea de producto que tengas en mente (para LillyTech o para otro contexto) y escribí el problema real detrás, sin mencionar ninguna solución técnica todavía.',
  E'- Empezar a diseñar la solución antes de tener claro el problema, llevando a funcionalidades que "suenan bien" pero no resuelven nada concreto.\n- Confundir un deseo con un problema estructurado.\n- No validar si el problema es real preguntando si una solución no técnica ya lo resolvería, aunque sea mal.',
  E'- [ ] Puedo distinguir un problema real de una solución disfrazada de problema.\n- [ ] Puedo articular el problema real detrás de LillyTech Academy, sin mencionar la plataforma en sí.\n- [ ] Practiqué esta identificación con una idea propia.',
  15, 'Fundamentos', 'Automatización con IA: cierre de la Etapa 9', 1, true
),
(
  'eb32ca5f-961c-4e2e-8a4b-34dd675bb9aa',
  '65acbaaa-be94-463a-9f00-393a45b88369',
  'Requisitos',
  'Traducir un problema en necesidades concretas y verificables — el puente entre "qué necesito" y "qué se va a construir".',
  E'- Explicar qué es un requisito y en qué se diferencia de una idea vaga.\n- Distinguir requisitos funcionales de no funcionales.\n- Identificar requisitos reales en el documento original de esta Academy.',
  E'Un requisito es una necesidad concreta y verificable — algo que podés confirmar que se cumplió o no, a diferencia de una idea vaga como "que sea fácil de usar" (¿fácil según qué criterio?).\n\nHay dos tipos principales: requisitos funcionales (qué debe HACER el sistema) y requisitos no funcionales (cómo debe COMPORTARSE el sistema — responsive, sin errores de compilación, RLS impidiendo ver datos ajenos).\n\nEl documento original de esta Academy tenía requisitos funcionales muy concretos en su sección de "Criterios de aceptación del MVP": una usuaria pueda registrarse, pueda crear notas, pueda ver su dashboard — cada uno verificable con un sí/no. También tenía requisitos no funcionales explícitos: la aplicación debe compilar correctamente, RLS impida consultar datos privados de otra persona. Ambos tipos son necesarios: los funcionales dicen qué construir, los no funcionales dicen qué calidad exigirle a esa construcción.',
  E'"RLS impida consultar datos privados de otra persona" es un requisito no funcional perfecto: es verificable, no depende de opinión, y quedó efectivamente cumplido desde la primera migración de este proyecto.',
  E'Elegí una funcionalidad futura de esta Academy (por ejemplo, exportar certificados a PDF) y escribí 2 requisitos funcionales y 1 no funcional para esa funcionalidad.',
  E'- Escribir requisitos vagos e imposibles de verificar.\n- Confundir un requisito con una implementación específica.\n- Olvidar los requisitos no funcionales, enfocándose solo en funcionalidades visibles.',
  E'- [ ] Puedo explicar la diferencia entre requisito funcional y no funcional.\n- [ ] Puedo encontrar 3 requisitos reales del documento original de esta Academy.\n- [ ] Escribí requisitos propios para una funcionalidad futura.',
  15, 'Fundamentos', 'Identificación de problemas', 2, true
),
(
  'f4b25e20-da3f-40a5-a71d-4084da4690db',
  '65acbaaa-be94-463a-9f00-393a45b88369',
  'MVP',
  'El producto más chico que ya resuelve el problema real — no "la versión incompleta de lo que realmente quiero", sino una decisión deliberada de alcance.',
  E'- Definir MVP correctamente, distinguiéndolo de "versión barata" o "a medio hacer".\n- Repasar cómo se definió el MVP de esta Academy en 5 fases concretas.\n- Identificar qué quedó deliberadamente fuera del MVP y por qué.',
  E'MVP (Producto Mínimo Viable) no significa "lo más barato posible" ni "una versión rota que se arregla después" — significa el conjunto más chico de funcionalidades que ya resuelve el problema real de forma completa, dejando fuera todo lo que no es esencial para esa primera validación.\n\nEl MVP de esta Academy se definió con fases muy concretas: Fase 1 (planificación), Fase 2 (scaffold + auth), Fase 3 (base de datos), Fase 4 (experiencia de estudiante), Fase 5 (administración). Cada fase agregaba lo mínimo necesario para seguir siendo útil.\n\nLo que quedó explícitamente FUERA del MVP, documentado en docs/ROADMAP.md: exportación de certificados a PDF, upload de archivos como evidencia, modo oscuro, multiusuario/multiempresa real. Ninguna de estas ausencias fue un descuido — cada una fue una decisión consciente de que no eran esenciales para que el producto ya resolviera el problema central.',
  E'La Biblioteca de Conceptos (v1.2) no estaba en el MVP original de 5 fases — se agregó después, cuando quedó claro que era la pieza que más faltaba para el objetivo real de "segunda memoria". El MVP no incluye todo lo que el producto eventualmente tendrá, solo lo mínimo para empezar a ser útil de verdad.',
  E'Repasá docs/ROADMAP.md y encontrá la sección "Después del MVP" — elegí un ítem y explicá por qué tiene sentido que haya quedado fuera del MVP original.',
  E'- Confundir MVP con "versión de baja calidad".\n- Agregar funcionalidades "porque estaría bueno tenerlas" en el MVP, perdiendo el foco en lo esencial.\n- No revisar si algo dejado fuera del MVP ya se volvió necesario.',
  E'- [ ] Puedo definir MVP correctamente, distinguiéndolo de "versión incompleta".\n- [ ] Puedo nombrar las 5 fases del MVP original de esta Academy.\n- [ ] Puedo explicar por qué al menos 2 funcionalidades quedaron fuera del MVP a propósito.',
  15, 'Fundamentos', 'Requisitos', 3, true
),
(
  '3ffa991f-f93e-43f8-85c5-ecfd00d93cc4',
  '65acbaaa-be94-463a-9f00-393a45b88369',
  'Historias de usuario',
  'Una forma simple de escribir requisitos desde la perspectiva de quien los va a usar — "como [rol], quiero [acción], para [beneficio]".',
  E'- Escribir una historia de usuario con el formato estándar.\n- Reescribir un requisito de esta Academy como historia de usuario.\n- Distinguir una historia de usuario de una simple lista de funcionalidades.',
  E'Una historia de usuario es una forma de expresar un requisito centrada en la persona que lo necesita: "Como [rol], quiero [acción], para [beneficio]". El foco en el "para qué" es lo que la distingue de una simple lista de features.\n\nAlgunos requisitos de esta Academy, reescritos como historias de usuario:\n\n"Como estudiante, quiero marcar una lección como completada, para ver reflejado mi avance real en el Dashboard."\n\n"Como administradora, quiero enlazar un concepto a una lección, para no tener que reexplicar el mismo contenido en varios lugares."\n\n"Como estudiante, quiero registrar un proyecto práctico, para conectar lo que aprendo con el trabajo real que ya hago."\n\nNotá que cada historia tiene un rol específico, una acción concreta, y un beneficio que explica el POR QUÉ.',
  E'La historia "Como administradora, quiero enlazar un concepto a una lección, para no tener que reexplicar el mismo contenido en varios lugares" es literalmente el Principio de reutilización del conocimiento del Plan Evolutivo, expresado en formato de historia de usuario.',
  E'Elegí 2 funcionalidades reales de esta Academy y reescribilas como historias de usuario completas, con rol, acción y beneficio.',
  E'- Escribir historias sin el beneficio, perdiendo el valor de explicitar el POR QUÉ.\n- Usar un rol demasiado genérico cuando el sistema tiene roles distintos con necesidades distintas.\n- Confundir una historia de usuario con una tarea técnica de implementación.',
  E'- [ ] Puedo escribir una historia de usuario con el formato completo.\n- [ ] Reescribí 2 funcionalidades reales de esta Academy como historias de usuario.\n- [ ] Puedo explicar por qué el "para qué" es la parte más importante.',
  10, 'Fundamentos', 'MVP', 4, true
);

-- ============ MÓDULO 2: Planificar y documentar ============

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '3dfe3e97-0e5e-49a3-84b7-1cb3e421432e', id, 'Planificar y documentar', 'Priorización, roadmap, pruebas con usuarios y documentación — cómo se ordena y se deja registro del trabajo de producto.', 2, true
from public.courses where title = 'De la idea al producto';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '8391d920-c2b6-44c0-b1c1-157354480607',
  '3dfe3e97-0e5e-49a3-84b7-1cb3e421432e',
  'Priorización',
  'No todo lo que hace falta puede hacerse a la vez — cómo el Plan Evolutivo de esta Academy decidió qué versión iba antes de cuál, y por qué.',
  E'- Explicar por qué priorizar es distinto de simplemente listar tareas por orden de preferencia.\n- Repasar el criterio de priorización usado en el Plan Evolutivo de esta Academy.\n- Practicar priorizar un conjunto de funcionalidades propio.',
  E'Priorizar no es simplemente "hacer primero lo que más me gusta" — es decidir el orden correcto considerando dependencias reales y el valor que cada cosa aporta.\n\nEl Plan Evolutivo de esta Academy es un ejemplo directo: aunque la Biblioteca de Conceptos era la Prioridad 1 explícita, el plan reordenó técnicamente el trabajo (v1.1 como fundamento, v1.2 como la biblioteca completa) porque sin el fundamento de datos, la biblioteca completa no podía construirse. El buscador global, pedido como Prioridad 3, se puso deliberadamente AL FINAL de la secuencia técnica (v1.5) porque un buscador que solo busca en 2 de 7 fuentes de contenido no cumplía lo que realmente se pedía.\n\nEsto ilustra el principio central de priorización: el orden de preferencia y el orden técnico correcto no siempre coinciden — priorizar bien significa reconciliar ambos, explicando claramente por qué el orden final no es simplemente el mismo que se pidió originalmente.',
  E'Cuando se reordenaron las prioridades P1-P5 en v1.1 a v1.6, el documento no ocultó el reordenamiento — lo explicó explícitamente. Priorizar bien incluye comunicar por qué el orden cambia, no solo decidirlo en silencio.',
  E'Tomá 4 funcionalidades pendientes de cualquiera de tus proyectos y ordenalas considerando tanto tu preferencia como las dependencias técnicas reales entre ellas.',
  E'- Priorizar solo por preferencia personal, ignorando dependencias técnicas.\n- No comunicar por qué el orden final difiere del orden de preferencia original.\n- Re-priorizar constantemente sin terminar nada.',
  E'- [ ] Puedo explicar la diferencia entre orden de preferencia y orden técnico de dependencias.\n- [ ] Puedo dar un ejemplo real del Plan Evolutivo donde ambos órdenes no coincidieron.\n- [ ] Practiqué priorizar 4 funcionalidades propias.',
  15, 'Intermedio', 'Historias de usuario', 1, true
),
(
  'c9e1516c-974c-4a7a-a301-ca1c49f9838e',
  '3dfe3e97-0e5e-49a3-84b7-1cb3e421432e',
  'Roadmap',
  'Un plan visible de hacia dónde va el producto — el que esta Academy mantiene vivo y actualizado en docs/ROADMAP.md.',
  E'- Explicar qué es un roadmap y qué problema resuelve tenerlo documentado.\n- Repasar cómo docs/ROADMAP.md se mantuvo actualizado a lo largo de este proyecto.\n- Distinguir un roadmap de una simple lista de tareas pendientes.',
  E'Un roadmap es una vista de alto nivel de hacia dónde va un producto — qué está hecho, qué sigue, y por qué en ese orden. Se diferencia de una lista de tareas en que comunica DIRECCIÓN, no solo pendientes sueltos.\n\nEsta Academy mantiene su roadmap en dos documentos complementarios: docs/ROADMAP.md y docs/PLAN_EVOLUTIVO.md. Ambos se actualizaron activamente durante el proyecto — cada vez que se completaba una fase o versión, el documento correspondiente se marcaba como completada.\n\nEsto es lo que distingue un roadmap vivo de uno decorativo: si hoy revisaras esos documentos, reflejan con precisión el estado real del proyecto, no una foto vieja de una intención pasada.',
  E'La sección "Después del MVP" de docs/ROADMAP.md hace algo que muchos roadmaps olvidan: documenta explícitamente qué NO se va a hacer todavía, y por qué — igual de valioso que documentar qué sí se va a hacer.',
  E'Abrí docs/ROADMAP.md y docs/PLAN_EVOLUTIVO.md de esta Academy y confirmá que ambos reflejan con precisión el estado actual.',
  E'- Escribir un roadmap una vez y nunca actualizarlo.\n- Confundir un roadmap con una lista de tareas técnicas sin relato de dirección.\n- No documentar qué queda deliberadamente fuera de alcance.',
  E'- [ ] Puedo explicar qué es un roadmap y en qué se diferencia de una lista de tareas.\n- [ ] Confirmé que los roadmaps de esta Academy reflejan el estado real actual.\n- [ ] Puedo explicar por qué documentar lo fuera de alcance es tan valioso como lo planeado.',
  10, 'Intermedio', 'Priorización', 2, true
),
(
  'aec32fd1-a221-49c2-a28c-05f73548a0ca',
  '3dfe3e97-0e5e-49a3-84b7-1cb3e421432e',
  'Pruebas con usuarios',
  'En un producto de una sola usuaria, la "prueba con usuarios" sos vos misma — y ya la hiciste, cada vez que confirmaste con una captura que algo funcionaba.',
  E'- Explicar qué es una prueba con usuarios y qué busca descubrir.\n- Reconocer que las verificaciones que ya hiciste en este proyecto fueron, en esencia, pruebas con usuaria real.\n- Identificar qué cambiaría si esta Academy tuviera usuarias además de vos.',
  E'Probar con usuarios significa poner el producto frente a personas reales y observar cómo lo usan, qué les confunde, qué esperaban que pasara y no pasó. El objetivo es descubrir problemas de uso real que quien construye, por estar tan cerca del producto, no ve.\n\nEn esta Academy, cada verificación que hiciste ya fue, en esencia, una prueba de usuario: cuando confirmaste con captura que el Dashboard mostraba el progreso correcto, cuando notaste que faltaba la pantalla de registro, cuando reportaste que una lección tardaba en cargar la primera vez — todo eso es exactamente el tipo de información que una prueba de usuario busca descubrir.\n\nSi esta Academy sumara una segunda estudiante real, esa persona no tendría el contexto que vos tenés sobre por qué las cosas están hechas así — probaría el producto "a ciegas", revelando problemas de usabilidad que vos, conociendo el sistema por dentro, quizás nunca notarías.',
  E'El momento en que se confundió el mensaje de instrucción con contenido real y se pegó en el campo "Resumen" de una lección fue, sin quererlo, una prueba de usabilidad real: reveló que el flujo de copiar y pegar contenido campo por campo era propenso a este tipo de error.',
  E'Pensá en un momento de este proyecto donde algo no funcionó como esperabas al usar la app. Describí qué esperabas que pasara y qué pasó en realidad.',
  E'- Pensar que "probar con usuarios" solo aplica a productos con muchas usuarias externas.\n- No prestarle atención a momentos de confusión propia durante el uso.\n- Confundir "yo ya lo probé, funciona" con una prueba real hecha por alguien sin el contexto interno.',
  E'- [ ] Puedo explicar qué busca descubrir una prueba con usuarios.\n- [ ] Puedo identificar un momento real de este proyecto que funcionó como prueba de usuario informal.\n- [ ] Puedo explicar qué cambiaría con una segunda estudiante real.',
  15, 'Intermedio', 'Roadmap', 3, true
),
(
  '9685699e-892c-4e01-91ec-69ce10540958',
  '3dfe3e97-0e5e-49a3-84b7-1cb3e421432e',
  'Documentación de producto',
  'Más allá de la documentación técnica (ya vista en la Etapa 9) — la documentación que explica el producto en sí: para quién es, qué resuelve, cómo se usa.',
  E'- Distinguir documentación técnica de documentación de producto.\n- Identificar dónde vive cada tipo de documentación en esta Academy.\n- Reconocer para quién está pensada cada una.',
  E'La Etapa 9 ya cubrió documentación técnica. Esta lección distingue un tipo distinto: documentación de PRODUCTO — no explica CÓMO está construido el sistema por dentro, sino QUÉ ES el producto, para quién, y cómo usarlo.\n\nEn esta Academy, ambos tipos conviven pero tienen audiencias distintas: README.md, ARCHITECTURE.md, DATABASE.md son documentación técnica. En cambio, la propia descripción del propósito del proyecto es documentación de producto — comunica el propósito y el valor, sin un solo detalle técnico.\n\nUn producto que solo tiene documentación técnica pero ninguna de producto es difícil de explicar a alguien que no necesita saber cómo está construido por dentro.',
  E'Si le mostraras ARCHITECTURE.md a alguien que solo quiere saber "qué hace esta app", esa persona no encontraría respuesta útil ahí — necesitaría algo más parecido a una introducción de propósito, sin jerga técnica.',
  E'Escribí un párrafo de documentación de producto (no técnica) para esta Academy, en 3-4 líneas.',
  E'- Tener solo documentación técnica y ninguna de producto.\n- Mezclar ambos tipos en un solo documento, confundiendo a las dos audiencias distintas.\n- Descuidar la documentación de producto asumiendo que "ya se entiende".',
  E'- [ ] Puedo distinguir documentación técnica de documentación de producto.\n- [ ] Puedo identificar un ejemplo de cada tipo en esta Academy.\n- [ ] Escribí un párrafo de documentación de producto propia.',
  10, 'Intermedio', 'Pruebas con usuarios', 4, true
);

-- ============ MÓDULO 3: Convertirlo en negocio ============

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '9f1b2bcb-2925-4854-91d8-94df8c033458', id, 'Convertirlo en negocio', 'Precios, SaaS, white label y soporte — lo que habría que pensar si algún proyecto LillyTech se convirtiera en un producto para otros.', 3, true
from public.courses where title = 'De la idea al producto';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '12dba9ba-3c42-40e4-b43d-c80d8c8b9ec8',
  '9f1b2bcb-2925-4854-91d8-94df8c033458',
  'Precios',
  'Cómo se decide cuánto cobrar por un producto digital — conceptual, ya que esta Academy no cobra nada, pero relevante para otros proyectos LillyTech con potencial comercial.',
  E'- Explicar las estrategias básicas de precio para productos digitales.\n- Reconocer que el precio comunica algo más que "cuánto cuesta producirlo".\n- Aplicar el criterio a un proyecto LillyTech con potencial comercial real.',
  E'Poner precio a un producto digital no es simplemente "sumar el costo de producción más una ganancia" — el costo marginal de que una persona más use un software ya construido es casi cero, así que el precio se decide por el VALOR que el producto aporta a quien lo usa.\n\nAlgunas estrategias comunes: precio por usuario/mes, precio único por licencia, freemium, precio por volumen de uso. La elección depende de cómo el cliente percibe el valor.\n\nEsta Academy no cobra nada. Pero el criterio aplica directo a otros proyectos LillyTech con potencial de convertirse en producto: si se ofrecieran a otras empresas, el precio debería reflejar el valor que le genera a esa empresa, no simplemente lo que costó construirlo.',
  E'Si decidieras ofrecer un sistema de control operativo como servicio a otras empresas, el precio no debería basarse en cuántas horas llevó programarlo sino en cuánto tiempo o dinero le ahorra a esa empresa tenerlo automatizado.',
  E'Elegí uno de tus proyectos con potencial comercial y describí qué estrategia de precio usarías y por qué, pensando en el valor que aporta, no en el costo de construcción.',
  E'- Poner precio basándose solo en el costo de desarrollo.\n- Elegir una estrategia sin pensar cómo se relaciona el valor con el volumen de uso.\n- No considerar que el precio también comunica posicionamiento.',
  E'- [ ] Puedo nombrar 3 estrategias comunes de precio para productos digitales.\n- [ ] Puedo explicar por qué el precio se basa en valor, no solo en costo.\n- [ ] Apliqué el criterio a uno de mis proyectos.',
  15, 'Intermedio', 'Documentación de producto', 1, true
),
(
  '41d42da8-cbe1-4e97-916d-a565751670cd',
  '9f1b2bcb-2925-4854-91d8-94df8c033458',
  'SaaS',
  'Software como servicio — el modelo que convertiría cualquier proyecto LillyTech de "herramienta que uso yo" a "producto que otros pagan por usar".',
  E'- Definir qué es SaaS y en qué se diferencia de software instalado tradicionalmente.\n- Repasar la conexión con arquitectura multiempresa, ya vista en la Etapa 4.\n- Evaluar qué le faltaría a esta Academy para ser un SaaS real.',
  E'SaaS (Software as a Service) es un modelo donde el software vive en la infraestructura del proveedor, se accede por navegador, y se paga típicamente por suscripción.\n\nEsto ya se conectó en la Etapa 4 con arquitectura multiempresa: un SaaS real que sirve a múltiples organizaciones necesita esa capa extra de aislamiento. Esta Academy es multiusuario, pero no multiempresa — sería el primer cambio de arquitectura necesario si se convirtiera en SaaS.\n\nMás allá de la arquitectura, convertirse en SaaS agregaría necesidades nuevas: facturación recurrente, gestión de suscripciones, soporte a clientes. Ninguna de estas piezas existe hoy en esta Academy, y está bien que no existan — no son necesarias para su propósito actual.',
  E'Si LillyTech Academy se convirtiera en un SaaS educativo real, cada tabla de contenido personal necesitaría, además del user_id que ya tiene, una forma de saber a qué organización pertenece esa usuaria — un cambio de esquema real.',
  E'Escribí 3 cambios técnicos concretos que necesitaría esta Academy para convertirse en un SaaS multiempresa real.',
  E'- Pensar que SaaS es solo "cobrar por el software" sin considerar cambios de arquitectura y soporte.\n- Construir para multiempresa desde el día uno en un proyecto que no lo necesita.\n- No planificar la facturación como parte central del modelo.',
  E'- [ ] Puedo definir SaaS y distinguirlo de software instalado tradicional.\n- [ ] Puedo conectar SaaS con la necesidad de arquitectura multiempresa.\n- [ ] Identifiqué 3 cambios técnicos concretos.',
  15, 'Intermedio', 'Precios', 2, true
),
(
  'f6114461-4c70-4ddc-8171-0a17b1595d76',
  '9f1b2bcb-2925-4854-91d8-94df8c033458',
  'White label',
  'Un producto que otras empresas pueden poner bajo su propia marca — un paso más allá de SaaS.',
  E'- Definir white label y en qué se diferencia de un SaaS con marca propia.\n- Identificar qué necesitaría esta Academy para ser ofrecida como white label.\n- Reconocer las implicancias técnicas de personalización por cliente.',
  E'White label es un producto que se ofrece a otras empresas para que lo usen bajo SU PROPIA marca — el cliente final ni siquiera sabe que fue construido por otra empresa. Es un paso más allá de SaaS: cada organización puede personalizar apariencia, dominio, y a veces funcionalidad.\n\nSi algún proyecto LillyTech se ofreciera como white label, cada cliente necesitaría su propio dominio, sus propios colores y logo. El hecho de que esta Academy ya centralice sus colores de marca en un solo archivo de configuración facilitaría técnicamente ese tipo de personalización, aunque no fue el motivo original.\n\nEste es el nivel más alto de complejidad de los tres modelos vistos en este módulo — cada nivel agrega capas reales de trabajo técnico y de producto.',
  E'El hecho de que esta Academy ya centralice sus colores de marca (brass, ink, paper) en tailwind.config.js, en vez de tenerlos repetidos por componentes, es justamente el tipo de decisión que facilitaría una futura personalización por cliente.',
  E'Pensá en un proyecto con potencial de venderse a distintas empresas. Describí qué elementos necesitarían personalizarse por cliente si se ofreciera como white label.',
  E'- Confundir SaaS multiempresa con white label.\n- Subestimar el trabajo técnico real de soportar personalización por cliente.\n- Ofrecer white label sin tener primero resuelto multiempresa.',
  E'- [ ] Puedo definir white label y distinguirlo de SaaS con marca propia.\n- [ ] Puedo explicar por qué los tokens de marca centralizados facilitarían personalización futura.\n- [ ] Identifiqué qué necesitaría personalizarse en un proyecto propio.',
  15, 'Intermedio', 'SaaS', 3, true
),
(
  '7c6ac48e-1f0c-4eee-90cb-c10ce92634da',
  '9f1b2bcb-2925-4854-91d8-94df8c033458',
  'Soporte y continuidad: cierre de la Etapa 10',
  'Qué pasa con un producto DESPUÉS de lanzado — el trabajo que sigue siendo necesario aunque ya "esté terminado", y el cierre integrador de toda la etapa.',
  E'- Explicar por qué un producto "terminado" sigue necesitando trabajo continuo.\n- Repasar cómo esta Academy ya practica continuidad con su Plan Evolutivo.\n- Cerrar la Etapa 10 conectando las 12 piezas vistas en un ciclo completo de producto.',
  E'Ningún producto real queda "terminado" — necesita soporte (resolver problemas que surgen en uso real) y continuidad (seguir evolucionando). Esta Academy ya practica continuidad de forma explícita: pasó por Fases 1-5, después v1.1 a v1.6, con una visión v2/v3 documentada para el futuro.\n\nSoporte, en el contexto de esta Academy, se ve distinto a soporte de un producto con clientes externos: cada vez que algo falló, hubo un proceso de diagnóstico y corrección — la misma función que cumpliría un equipo de soporte, aplicada a una sola usuaria.\n\nEsta lección cierra la Etapa 10 completa: identificar el problema real lleva a definir requisitos y MVP; priorizar y documentar mantiene el trabajo ordenado; y si el producto creciera hacia un negocio real, precios, SaaS y white label son los escalones de esa evolución — pero soporte y continuidad son lo que mantiene el producto vivo después del lanzamiento inicial.',
  E'El Plan Evolutivo de esta Academy, con su visión de largo plazo hacia un Asistente de Aprendizaje IA, es en sí mismo un compromiso de continuidad — una declaración de que el producto va a seguir recibiendo atención, no solo un documento que se archiva.',
  E'Escribí una reflexión de cierre: de las 12 piezas de esta etapa, ¿cuáles ya practicás activamente en LillyTech Academy, y cuáles serían nuevas si quisieras convertir otro proyecto en un producto real?',
  E'- Pensar que un producto "está terminado" cuando el código compila y funciona.\n- No dejar ninguna visión de futuro documentada.\n- Aplicar el mismo nivel de proceso formal de producto a un proyecto personal que no lo necesita al mismo nivel.',
  E'- [ ] Puedo explicar por qué un producto nunca está "completamente terminado".\n- [ ] Puedo identificar cómo esta Academy ya practica soporte y continuidad.\n- [ ] Escribí mi reflexión de cierre sobre las 12 piezas de esta etapa.',
  20, 'Intermedio', 'White label', 4, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  '4d455399-79f8-4829-a93f-8a2f180e52eb',
  'ef5e763e-2fc4-432b-874d-5ac8a6fc65cc',
  'Articulá un problema real',
  'Elegí una idea de producto propia y escribí el problema real detrás, sin mencionar ninguna solución técnica todavía.',
  'short_answer', 1
),
(
  '337f86f7-930c-4c1f-a1af-351f2bacd803',
  'eb32ca5f-961c-4e2e-8a4b-34dd675bb9aa',
  'Escribí requisitos para una funcionalidad futura',
  'Para "exportar certificados a PDF", escribí 2 requisitos funcionales y 1 no funcional.',
  'short_answer', 1
),
(
  '85a3a0ad-f814-4b27-b02b-c0c1f1b51ed6',
  'f4b25e20-da3f-40a5-a71d-4084da4690db',
  'Analizá lo que quedó fuera del MVP',
  'Elegí un ítem de "Después del MVP" en docs/ROADMAP.md y explicá por qué tiene sentido que haya quedado fuera.',
  'short_answer', 1
),
(
  '5cda2c22-418e-4ec5-bee9-9c7d2c750ba7',
  '3ffa991f-f93e-43f8-85c5-ecfd00d93cc4',
  'Reescribí 2 funcionalidades como historias de usuario',
  'Elegí 2 funcionalidades reales de esta Academy y escribilas con el formato completo de historia de usuario.',
  'short_answer', 1
),
(
  '41c8d664-1c8b-464e-82a8-ecb61287b4b6',
  '8391d920-c2b6-44c0-b1c1-157354480607',
  'Priorizá 4 funcionalidades propias',
  'Tomá 4 funcionalidades pendientes de un proyecto propio y ordenalas considerando preferencia y dependencias técnicas.',
  'short_answer', 1
),
(
  'aedfb198-f7da-492f-8f12-b9d2f7ff8820',
  'c9e1516c-974c-4a7a-a301-ca1c49f9838e',
  'Confirmá la precisión de los roadmaps',
  'Revisá docs/ROADMAP.md y docs/PLAN_EVOLUTIVO.md y confirmá que ambos reflejan el estado actual real de la Academy.',
  'checklist', 1
),
(
  '1db77015-6bbb-459e-85bb-f5e1b81ab776',
  'aec32fd1-a221-49c2-a28c-05f73548a0ca',
  'Recordá un momento de prueba informal',
  'Describí un momento real de este proyecto donde algo no funcionó como esperabas usando la app, y qué reveló eso.',
  'short_answer', 1
),
(
  '75c176be-99a7-499e-b445-a809f13f0b36',
  '9685699e-892c-4e01-91ec-69ce10540958',
  'Escribí documentación de producto',
  'Escribí un párrafo de 3-4 líneas explicando qué es LillyTech Academy, para alguien que nunca vio el código.',
  'short_answer', 1
),
(
  '7a9032ba-728b-430c-8e26-35f4953cdf8d',
  '12dba9ba-3c42-40e4-b43d-c80d8c8b9ec8',
  'Definí una estrategia de precio',
  'Para uno de tus proyectos con potencial comercial, describí qué estrategia de precio usarías y por qué.',
  'short_answer', 1
),
(
  '2d2d2ddf-fe18-444b-b4a0-5a795acc13fc',
  '41d42da8-cbe1-4e97-916d-a565751670cd',
  'Identificá cambios técnicos para SaaS',
  'Escribí 3 cambios técnicos concretos que necesitaría esta Academy para convertirse en un SaaS multiempresa real.',
  'short_answer', 1
),
(
  '36988d2e-0931-44c8-96e3-d8db8cbcaba3',
  'f6114461-4c70-4ddc-8171-0a17b1595d76',
  'Diseñá una personalización white label',
  'Para un proyecto propio, describí qué elementos necesitarían personalizarse por cliente si se ofreciera como white label.',
  'short_answer', 1
),
(
  '03e4b941-2329-47ba-93dd-c19d80c7aef8',
  '7c6ac48e-1f0c-4eee-90cb-c10ce92634da',
  'Reflexión final de la etapa',
  'Escribí tu reflexión sobre cuáles de las 12 piezas de esta etapa ya practicás en LillyTech Academy y cuáles serían nuevas para otro proyecto.',
  'long_answer', 1
);
