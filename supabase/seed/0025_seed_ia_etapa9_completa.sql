-- 0025_seed_ia_etapa9_completa.sql
-- Etapa 9 completa (Inteligencia artificial aplicada): 3 módulos, 9 lecciones,
-- en un solo archivo — todo el contenido de esta etapa habla literalmente
-- de cómo se construyó esta misma Academy, en tiempo real, con vos y Claude.

-- ============ MÓDULO 1: Diseñar con IA ============

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '78f787d2-1d73-4bf2-83f1-a49063239b59', id, 'Diseñar con IA', 'Uso de IA para diseñar aplicaciones, prompts técnicos, uso responsable de agentes — el mismo proceso que ya viviste construyendo esta Academy.', 1, true
from public.courses where title = 'IA como parte del flujo de trabajo';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'e259f2ec-f9dc-4164-b142-deeeb3c78c0b',
  '78f787d2-1d73-4bf2-83f1-a49063239b59',
  'Uso de IA para diseñar aplicaciones',
  'Cómo un asistente de IA puede ayudarte a pensar arquitectura, no solo a escribir código — exactamente lo que pasó en la Fase 1 de este proyecto.',
  E'- Explicar en qué momentos de un proyecto la IA aporta más valor diseñando, no solo codificando.\n- Repasar cómo se usó IA para planificar la arquitectura de esta Academy antes de escribir una sola línea.\n- Reconocer que el criterio final de diseño sigue siendo humano, aunque la IA proponga opciones.',
  E'Usar IA para diseñar una aplicación significa pedirle ayuda ANTES de escribir código: para pensar qué tablas hacen falta, qué arquitectura conviene, qué riesgos existen — no solo para generar funciones sueltas.\n\nEsta Academy es un ejemplo real de esto, documentado en su propio repositorio: la Fase 1 del proyecto (ver IMPLEMENTATION_PLAN.md) consistió exactamente en esto — pedirle a Claude que propusiera la arquitectura técnica, la estructura de carpetas, el modelo de datos inicial y el orden de implementación, ANTES de generar ningún archivo de código. Ese documento no lo escribiste vos sola línea por línea — surgió de una conversación donde vos diste el contexto (qué querías construir, para qué, con qué restricciones) y la IA propuso una estructura concreta, que después revisaste y aprobaste antes de seguir.\n\nEl criterio final siguió siendo tuyo en todo momento: por ejemplo, cuando definiste que el nivel de dominio (v1.3) debía ser personal y no una propiedad del contenido, esa fue una decisión de diseño tuya, que la IA implementó técnicamente después — la IA propone y ejecuta, pero las decisiones de qué es correcto para TU proyecto las seguís tomando vos.',
  E'El archivo docs/PLAN_EVOLUTIVO.md de esta Academy es un ejemplo directo: vos definiste las 5 prioridades (Biblioteca de Conceptos, Bitácora, Buscador, Indicadores, Nivel de dominio) y el principio de reutilización del conocimiento; la IA propuso el orden técnico de versiones (v1.1 a v1.6) basándose en las dependencias reales entre esas piezas — un ejemplo de diseño colaborativo, no de "la IA decide todo" ni de "la IA solo escribe lo que se le dicta letra por letra".',
  E'Abrí IMPLEMENTATION_PLAN.md en tu propio repositorio y releélo con esta lección en mente: identificá qué partes fueron tu visión original (la filosofía, el propósito) y qué partes fueron la propuesta técnica de la IA (la estructura de carpetas, el modelo de datos).',
  E'- Pedirle a la IA que "programe algo" sin darle contexto de arquitectura primero, perdiendo la oportunidad de que ayude a pensar antes de ejecutar.\n- Aceptar una propuesta de arquitectura sin entenderla ni cuestionarla — el objetivo de esta etapa entera es que entiendas el porqué, no solo que funcione.\n- Pensar que "usar IA para diseñar" significa que la IA decide sola — las decisiones de negocio y de producto siguen siendo tuyas.',
  E'- [ ] Puedo explicar la diferencia entre pedirle a la IA que "codifique" y pedirle que "ayude a diseñar".\n- [ ] Releí IMPLEMENTATION_PLAN.md identificando qué fue tu visión y qué fue propuesta técnica.\n- [ ] Puedo dar un ejemplo real donde vos tomaste la decisión final sobre una propuesta de la IA.',
  15, 'Intermedio', 'Registro de eventos: dejar rastro de lo que pasó', 1, true
),
(
  'c365bdcc-323a-4c5a-a87c-48cc2c8dfca5',
  '78f787d2-1d73-4bf2-83f1-a49063239b59',
  'Prompts técnicos',
  'Cómo pedirle algo a una IA de forma que la respuesta sea útil de verdad — con ejemplos reales de este mismo proyecto, buenos y mejorables.',
  E'- Identificar los ingredientes de un prompt técnico efectivo: contexto, objetivo, restricciones.\n- Comparar un prompt vago con uno específico, usando pedidos reales de este proyecto.\n- Escribir un prompt propio para una tarea técnica real.',
  E'Un prompt técnico efectivo generalmente incluye: contexto (qué es el proyecto, qué existe ya), un objetivo claro (qué se necesita específicamente), y restricciones (qué no se debe romper, qué convenciones seguir).\n\nCompará dos formas de pedir lo mismo en este proyecto: "hacé un módulo de SQL" es vago — no dice qué lecciones, con qué profundidad, ni cómo conectarlo con lo que ya existe. En cambio, un pedido como el que efectivamente se usó — "el Módulo 3 de SQL, con JOIN, GROUP BY, vistas, transacciones, índices y diagnóstico, con ejemplos anclados en esta misma Academy, siguiendo el mismo formato de las lecciones anteriores" — da contexto (el formato ya establecido), objetivo específico (los 6 subtemas exactos) y restricción implícita (mantener consistencia con lo anterior).\n\nUna práctica que ya usaste sin nombrarla: pedir contenido "listo para pegar y correr" en vez de "una idea general de contenido" — eso es una restricción de formato explícita, que cambió radicalmente qué tan útil era cada respuesta.',
  E'Cuando pediste "sigamos con el módulo 3" en vez de reexplicar todo el contexto cada vez, eso funcionó porque el contexto ya estaba establecido en la conversación — un prompt técnico efectivo no siempre necesita repetir todo desde cero, si el contexto acumulado ya lo cubre.',
  E'Elegí una tarea técnica pendiente de otro de tus proyectos y escribí un prompt completo para pedírsela a una IA, incluyendo contexto, objetivo específico y al menos una restricción.',
  E'- Pedir algo vago ("mejorá esto") sin especificar qué "mejor" significa en ese contexto.\n- No dar restricciones importantes (formato esperado, qué no tocar), obligando a corregir después lo que se podría haber evitado pidiendo bien desde el principio.\n- Repetir contexto innecesario cuando la conversación ya lo tiene, alargando el pedido sin necesidad.',
  E'- [ ] Puedo nombrar los 3 ingredientes de un prompt técnico efectivo.\n- [ ] Puedo comparar un prompt vago con uno específico usando ejemplos de este proyecto.\n- [ ] Escribí un prompt propio completo para una tarea real pendiente.',
  15, 'Intermedio', 'Uso de IA para diseñar aplicaciones', 2, true
),
(
  '0fc357da-b8e2-492d-be30-e8c12b77049c',
  '78f787d2-1d73-4bf2-83f1-a49063239b59',
  'Uso responsable de agentes',
  'Las reglas de trabajo que este mismo proyecto definió desde el principio — límites explícitos para lo que un agente de IA puede y no puede hacer sin tu autorización.',
  E'- Repasar las reglas de trabajo definidas al inicio de este proyecto.\n- Explicar por qué esas reglas existen antes de que algo salga mal, no después.\n- Reconocer un momento real de este proyecto donde esas reglas se respetaron.',
  E'Un agente de IA que puede escribir código, correr comandos, y modificar archivos necesita límites explícitos — no por desconfianza genérica, sino porque las consecuencias de una acción mal ejecutada (borrar datos, romper producción) pueden ser reales y costosas.\n\nEsta Academy definió, en el documento original del proyecto, reglas concretas: "no tocar producción sin autorización", "no ejecutar migraciones destructivas sin autorización", "no aplicar cambios irreversibles automáticamente", "detenerse cuando se necesiten credenciales o decisiones de negocio". Estas reglas no se escribieron después de un problema — se definieron ANTES de empezar, como parte del contrato de trabajo entre vos y la IA.\n\nUn ejemplo real de estas reglas en acción: cuando pasaste las credenciales de Supabase, el trabajo continuó respetando "no conectarte a proyectos existentes sin autorización" — se confirmó explícitamente que el proyecto estaba "limpio para esto" antes de generar cualquier migración. Otro ejemplo: nunca se ejecutó ningún SQL directamente contra tu base de datos real desde el lado de la IA — todo el SQL se entregó para que VOS lo corrieras, manteniendo el control humano sobre cada cambio real a la base de datos.',
  E'Cuando se encontró el problema del course_id desactualizado en las migraciones, la respuesta no fue "reescribir el pasado" silenciosamente — se explicó el problema, se propuso una solución (subquery por título), y quedó documentado en el propio archivo por qué se hizo ese cambio. Transparencia sobre errores, no ocultamiento.',
  E'Buscá las "Reglas de trabajo" originales de este proyecto (probablemente las tengas guardadas de la conversación inicial) y elegí una que te parezca especialmente importante. Explicá con un ejemplo real de este proyecto cómo se respetó.',
  E'- Darle a un agente de IA acceso irrestricto sin ningún límite explícito, confiando en que "seguramente no va a hacer nada malo".\n- No definir con anticipación qué necesita autorización explícita (credenciales, decisiones de negocio, cambios irreversibles) — definirlo después de un problema es tarde.\n- Pensar que "usar IA de forma responsable" es solo responsabilidad de quien construye la IA — también es responsabilidad de quien la dirige, estableciendo límites claros desde el principio.',
  E'- [ ] Puedo nombrar 3 reglas de trabajo definidas al inicio de este proyecto.\n- [ ] Puedo dar un ejemplo real donde esas reglas se respetaron en la práctica.\n- [ ] Puedo explicar por qué esas reglas se definieron antes de empezar, no después de un problema.',
  15, 'Intermedio', 'Prompts técnicos', 3, true
);

-- ============ MÓDULO 2: Código generado ============

insert into public.modules (id, course_id, title, description, order_index, is_published)
select 'ef9954ad-98ff-463c-97aa-17bab54a6aaa', id, 'Código generado', 'Generación y revisión de código, y diagnóstico de errores — cómo tratar el código que escribe una IA con el mismo criterio que el propio.', 2, true
from public.courses where title = 'IA como parte del flujo de trabajo';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '39a6618d-3ded-4ae6-aa1e-2d8e165dc796',
  'ef9954ad-98ff-463c-97aa-17bab54a6aaa',
  'Generación y revisión de código',
  'Todo el código de esta Academy fue generado por IA — y toda la calidad real vino de que cada pieza se probó antes de darla por buena.',
  E'- Explicar por qué generar código es solo la mitad del trabajo.\n- Repasar el flujo real de esta Academy: generar, subir, correr, verificar.\n- Reconocer la diferencia entre "código que compila" y "código que se probó funcionando".',
  E'Generar código con IA es rápido — la parte que realmente construye calidad es la revisión y verificación posterior. Todo el frontend, todas las migraciones, todos los servicios de esta Academy fueron generados por IA, pero ninguno se dio por bueno hasta probarse funcionando de verdad: corriendo npm run dev, verificando en el navegador, confirmando en la base de datos real.\n\nHubo momentos concretos en este proyecto donde la generación por sí sola NO alcanzó: el error de sintaxis con comillas simples sin escapar en un seed SQL, el course_id desactualizado, el error de compilación transitorio por caché de esquema. En los tres casos, el patrón fue el mismo: generar, intentar correr, encontrar el problema real (no hipotético), corregir, volver a intentar. La revisión no fue un paso opcional al final — fue parte constante del proceso.\n\nEsto es aplicable a cualquier código generado por IA, en cualquier proyecto: la IA puede producir algo sintácticamente válido y aun así estar mal para tu caso específico (referenciar un id que ya no existe, olvidar un caso límite) — la única forma de saberlo es probarlo contra la realidad, no solo leerlo y asumir que está bien.',
  E'El bug de comillas sin escapar en el seed de Arquitectura Módulo 1 (donde código de ejemplo con comillas simples cortaba el string SQL) es un ejemplo perfecto: el archivo se veía completo y razonable, pero solo al intentar correrlo contra Supabase real apareció el error — la revisión visual sola no lo hubiera detectado tan rápido como el intento real de ejecución.',
  E'Elegí cualquier archivo de código de esta Academy que no hayas revisado en detalle todavía, y leélo línea por línea explicando qué hace cada parte — la misma disciplina de revisión que se aplicó al construir el proyecto.',
  E'- Aceptar código generado por IA sin probarlo contra el sistema real, confiando en que "se ve bien".\n- Probar solo una vez y dar por sentado que va a seguir funcionando siempre, sin considerar casos límite.\n- Pensar que revisar código generado por IA es menos importante que revisar código escrito a mano — el riesgo de error es el mismo, viene de otro lado (falta de contexto específico de tu proyecto), pero existe igual.',
  E'- [ ] Puedo explicar por qué generar código es solo la mitad del trabajo.\n- [ ] Puedo nombrar un caso real de este proyecto donde la revisión encontró un problema que la generación sola no hubiera detectado.\n- [ ] Revisé línea por línea un archivo de código que no conocía en detalle.',
  15, 'Intermedio', 'Uso responsable de agentes', 1, true
),
(
  'cbbf205d-123e-4497-be2f-37680565503b',
  'ef9954ad-98ff-463c-97aa-17bab54a6aaa',
  'Revisión de código generado',
  'Qué mirar específicamente al revisar código que no escribiste vos misma — una checklist concreta, no solo "leerlo y ver si se ve bien".',
  E'- Aplicar una checklist concreta de revisión a código generado por IA.\n- Distinguir errores de sintaxis (el compilador los detecta) de errores de lógica (requieren pensar).\n- Practicar revisión real sobre un archivo de esta Academy.',
  E'"Revisar código" sin más especificación es vago. Una checklist más concreta, aplicable a cualquier código generado (por IA o por una persona):\n\n1. ¿Compila/corre sin errores? (lo más básico, pero no alcanza).\n2. ¿Hace lo que se pidió, específicamente? (no solo "algo parecido").\n3. ¿Maneja los casos donde algo puede salir mal? (datos vacíos, errores de red, permisos insuficientes).\n4. ¿Sigue las convenciones ya establecidas en el resto del proyecto? (nombres, estructura, estilo).\n5. ¿Hay algo que se ve razonable pero en realidad no se probó contra el sistema real?\n\nLos puntos 1 y 2 son relativamente fáciles de verificar. Los puntos 3, 4 y 5 requieren más criterio y conocimiento del contexto específico del proyecto — es exactamente el tipo de revisión que se hizo en esta Academy cada vez que se probó una funcionalidad nueva en el navegador antes de darla por terminada, no solo confiar en que el código "se veía bien".',
  E'Cuando revisaste el Dashboard después de que se agregara la tarjeta de "Tiempo estudiado", no alcanzó con que el código compilara — hizo falta ver en el navegador que el número mostrado (15 min) coincidiera con la realidad (la duración real de la única lección completada), confirmando que la lógica, no solo la sintaxis, estaba correcta.',
  E'Elegí un componente de esta Academy y aplicá la checklist de 5 puntos de esta lección. Anotá qué tan bien pasa cada punto.',
  E'- Detenerse en el punto 1 (compila) y asumir que eso significa que todo está bien.\n- No verificar las convenciones del resto del proyecto, generando código que funciona pero no encaja con el estilo ya establecido.\n- Confiar en la apariencia del código sin haberlo probado contra datos y escenarios reales.',
  E'- [ ] Puedo aplicar la checklist de 5 puntos a un ejemplo real.\n- [ ] Puedo distinguir un error de sintaxis de un error de lógica.\n- [ ] Practiqué revisión real sobre un componente de esta Academy.',
  15, 'Intermedio', 'Generación y revisión de código', 2, true
),
(
  'cba7a253-8c73-4a9c-895d-53f72a566e22',
  'ef9954ad-98ff-463c-97aa-17bab54a6aaa',
  'Diagnóstico de errores',
  'El método real que se usó en este proyecto cada vez que algo falló — leer el mensaje de error real, no adivinar la causa.',
  E'- Aplicar un método sistemático de diagnóstico ante un error real.\n- Repasar 2 diagnósticos reales de este proyecto, paso a paso.\n- Reconocer la diferencia entre "adivinar" y "diagnosticar con evidencia".',
  E'Diagnosticar un error bien sigue un método simple pero disciplinado: leer el mensaje de error completo (no solo la primera línea), identificar exactamente qué operación falló, buscar evidencia real (no adivinar), y recién ahí proponer una solución.\n\nDos diagnósticos reales de este proyecto, paso a paso:\n\n1. El error "insert or update on table modules violates foreign key constraint... Key (course_id)=(...) is not present in table courses" — el mensaje decía EXACTAMENTE cuál era el problema (un course_id que no existía). El diagnóstico no fue adivinar, fue correr SELECT id, title FROM courses WHERE title ILIKE ''%SQL%''; para confirmar cuál era el id REAL, con evidencia, antes de corregir el script.\n\n2. El error "No se pudo cargar la lección" que aparecía una vez y se resolvía con un refresh — acá el diagnóstico correcto fue reconocer el PATRÓN (falla una vez, justo después de una migración nueva, se resuelve solo) en vez de asumir que era un bug de código permanente. El patrón mismo era la evidencia de una causa distinta (caché de esquema de PostgREST).\n\nEn ambos casos, el error real y el patrón de cuándo ocurre fueron más útiles que cualquier suposición apresurada.',
  E'Si en el primer caso se hubiera "adivinado" la solución sin correr la consulta de verificación (por ejemplo, asumiendo que el problema era otra cosa), se habría perdido tiempo corrigiendo algo que no era la causa real — la evidencia (la consulta SQL) fue lo que llevó directo a la solución correcta.',
  E'La próxima vez que veas un error real en cualquiera de tus proyectos, aplicá este método: leé el mensaje completo, identificá la operación exacta que falló, buscá evidencia (una consulta, un log) antes de proponer una solución.',
  E'- Adivinar la causa de un error sin leer el mensaje completo, perdiendo información que ya estaba ahí explícitamente.\n- Aplicar la primera solución que se te ocurre sin confirmar que ataca la causa real.\n- No reconocer patrones (¿siempre falla igual? ¿solo a veces? ¿después de qué acción?) que son evidencia valiosa por sí mismos.',
  E'- [ ] Puedo describir el método de diagnóstico de 4 pasos.\n- [ ] Puedo explicar, paso a paso, cómo se diagnosticó el error de course_id de este proyecto.\n- [ ] Apliqué este método a un error real de otro de mis proyectos.',
  15, 'Intermedio', 'Revisión de código generado', 3, true
);

-- ============ MÓDULO 3: Más allá del código ============

insert into public.modules (id, course_id, title, description, order_index, is_published)
select 'ea680ace-7b7d-484d-9312-4aff9ca76742', id, 'Más allá del código', 'Documentación con IA, pruebas asistidas por IA y automatización con IA — cierra la Etapa 9 completa.', 3, true
from public.courses where title = 'IA como parte del flujo de trabajo';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '37020856-7ef3-4246-8d30-b05e16460e1d',
  'ea680ace-7b7d-484d-9312-4aff9ca76742',
  'Documentación con IA',
  'Casi toda la documentación de esta Academy (README, ARCHITECTURE, SECURITY, este mismo contenido educativo) fue generada por IA — y sigue siendo tan válida como cualquier documentación, mientras se mantenga actualizada.',
  E'- Explicar las ventajas y riesgos de generar documentación con IA.\n- Repasar qué documentos de esta Academy fueron generados así.\n- Reconocer el riesgo real: documentación que queda desactualizada respecto al código.',
  E'Generar documentación con IA tiene una ventaja clara: reduce la fricción de escribir explicaciones extensas, algo que muchas veces se posterga indefinidamente "para después" en proyectos reales. Esta Academy tiene documentación completa (README.md, docs/ARCHITECTURE.md, docs/DATABASE.md, docs/SECURITY.md, docs/ROADMAP.md, docs/TESTING.md, docs/GITHUB_SETUP.md, docs/PLAN_EVOLUTIVO.md, y todo el contenido educativo de esta misma Biblioteca) generada de esta forma.\n\nEl riesgo real, y que ya se vivió en este proyecto: la documentación puede quedar desactualizada si el código cambia y el documento no se actualiza junto con él. Por ejemplo, README.md tuvo que actualizarse varias veces a lo largo de este proyecto ("Fase 5 completa" → "v1.1 completa" → "v1.6 completa") — cada vez que se avanzaba de versión, hacía falta recordar actualizar también la documentación, no solo el código. Si eso se hubiera olvidado en algún punto, hoy tendrías un README que describe un estado viejo del proyecto, generando confusión.\n\nLa práctica correcta: tratar la actualización de documentación como parte del mismo cambio que actualiza el código, no como una tarea separada y opcional que se hace "cuando haya tiempo".',
  E'Cada vez que se completó una versión nueva de este proyecto (v1.1 a v1.6), se actualizó docs/PLAN_EVOLUTIVO.md marcándola como "✅ COMPLETADA" en el mismo momento, no como una tarea aparte para después — eso es lo que mantuvo ese documento confiable a lo largo de todo el proyecto.',
  E'Abrí README.md de esta Academy y confirmá que la sección "Estado actual" describe con precisión lo que realmente existe hoy en el proyecto (todas las etapas cargadas, todas las versiones completadas).',
  E'- Generar documentación una vez y nunca volver a actualizarla, dejando que se desincronice silenciosamente del código real.\n- Confiar ciegamente en documentación generada sin verificar que describe con precisión lo que el sistema realmente hace.\n- Tratar la documentación como un lujo opcional en vez de parte integral de cada cambio real al proyecto.',
  E'- [ ] Puedo nombrar 3 documentos de esta Academy generados con ayuda de IA.\n- [ ] Puedo explicar el riesgo real de documentación desactualizada.\n- [ ] Confirmé que README.md describe con precisión el estado actual real del proyecto.',
  15, 'Intermedio', 'Diagnóstico de errores', 1, true
),
(
  '2d0a98b7-0aab-4bef-b7f3-b23bf8b43ed4',
  'ea680ace-7b7d-484d-9312-4aff9ca76742',
  'Pruebas asistidas por IA',
  'Cómo usar IA para diseñar y correr pruebas, en un proyecto que hoy no tiene ninguna prueba automatizada — y por qué eso es una decisión razonable, no un descuido.',
  E'- Explicar la diferencia entre pruebas automatizadas y pruebas manuales asistidas.\n- Repasar docs/TESTING.md como ejemplo de checklist de pruebas generada con IA.\n- Reconocer cuándo esta Academy empezaría a necesitar pruebas automatizadas reales.',
  E'Pruebas asistidas por IA pueden tomar dos formas muy distintas: generar pruebas automatizadas (código que verifica código, corriendo solo) o generar checklists de prueba MANUAL bien pensadas (una lista de qué probar y cómo, que una persona ejecuta).\n\nEsta Academy usa la segunda forma: docs/TESTING.md es una checklist completa de pruebas manuales (autenticación, permisos RLS, navegación, responsive, datos) generada con ayuda de IA, pensada para que vos (o cualquiera) la sigas paso a paso verificando que todo funciona. No hay ni un solo archivo de test automatizado (como Jest o Vitest) en este proyecto — fue una decisión explícita, no un olvido: "No hay suite automatizada en el MVP (no se justifica su costo todavía)", dice el propio documento.\n\n¿Cuándo cambiaría esta decisión? Cuando el costo de NO tener pruebas automatizadas supere el costo de escribirlas y mantenerlas — típicamente, cuando el proyecto tenga más gente tocando el código (el riesgo de que alguien rompa algo sin darse cuenta sube), o cuando el volumen de funcionalidades sea tan grande que probar todo manualmente cada vez se vuelva impráctico. Hoy, con una sola desarrolladora y una checklist manual clara, el balance sigue siendo razonable tal como está.',
  E'La próxima vez que agregues una funcionalidad grande a esta Academy, sería natural pedirle a una IA que actualice docs/TESTING.md con los nuevos casos a probar — el mismo patrón que ya se siguió, manteniendo la checklist viva y relevante en vez de un documento fijo desde el día uno.',
  E'Abrí docs/TESTING.md y ejecutá manualmente al menos 3 de los ítems de la checklist contra tu propia Academy real, confirmando que efectivamente pasan.',
  E'- Confundir "tener una checklist de pruebas manuales" con "no tener pruebas" — son formas distintas de testing, ambas legítimas según el contexto.\n- No actualizar la checklist de pruebas cuando se agregan funcionalidades nuevas, dejándola incompleta.\n- Posponer indefinidamente la decisión de agregar pruebas automatizadas sin ninguna señal concreta que la dispare, ni en un sentido ni en el otro.',
  E'- [ ] Puedo explicar la diferencia entre pruebas automatizadas y checklists de prueba manual.\n- [ ] Ejecuté al menos 3 ítems reales de docs/TESTING.md contra mi Academy.\n- [ ] Puedo identificar la señal futura que justificaría agregar pruebas automatizadas.',
  15, 'Intermedio', 'Documentación con IA', 2, true
),
(
  '4368533b-a348-4606-b9a0-dfe2f0cb83f8',
  'ea680ace-7b7d-484d-9312-4aff9ca76742',
  'Automatización con IA: cierre de la Etapa 9',
  'El repaso final: todo lo automatizado en este proyecto (código, contenido, documentación) pasó siempre por revisión humana antes de aplicarse de verdad — el patrón que cierra toda la etapa.',
  E'- Repasar todos los tipos de automatización con IA vistos en este proyecto.\n- Identificar el patrón común: generación asistida, siempre con verificación humana antes de aplicar.\n- Cerrar la Etapa 9 con una reflexión sobre qué tan lejos podría llegar esto en el futuro (conectando con la visión del Asistente de Aprendizaje IA).',
  E'Esta lección cierra la etapa uniendo todo lo visto: en este proyecto, la IA ayudó a automatizar la generación de arquitectura (Módulo 1), de código (Módulo 2), y de documentación y contenido (este módulo) — pero en NINGÚN caso ese contenido se aplicó a un sistema real sin que vos lo revisaras y ejecutaras primero. Cada migración SQL la corriste vos en el SQL Editor. Cada archivo de código lo subiste vos con git push. Cada decisión de negocio (qué publicar, cómo organizar los módulos, si dividir el módulo de 6 lecciones) la tomaste vos.\n\nEste patrón —generación asistida por IA, aplicación siempre bajo control y verificación humana— es la misma idea que ya viste en Uso responsable de agentes, ahora vista en retrospectiva sobre las 9 etapas completas de contenido que ya construiste. No es casualidad que se haya sostenido de principio a fin: fue una decisión consciente, no un accidente.\n\nMirando hacia adelante: el documento docs/PLAN_EVOLUTIVO.md de esta Academy ya menciona una visión futura, el "Asistente de Aprendizaje IA" (v2/v3, todavía sin construir) — un asistente que respondería preguntas usando exclusivamente tu propio conocimiento acumulado en esta Academy. Cuando eso se construya, va a seguir necesitando el mismo patrón: generación asistida, con vos manteniendo el criterio final sobre qué es correcto para tu propio aprendizaje.',
  E'Repasá mentalmente las últimas etapas de contenido cargadas en esta Academy (Git, Seguridad, APIs) — en cada una, el patrón fue idéntico: contenido generado, revisado por vos (a veces corrigiendo errores reales, como los de comillas sin escapar), y solo entonces cargado a la base de datos real.',
  E'Escribí una reflexión breve: de todo lo que construiste en este proyecto con ayuda de IA, ¿qué parte sentís que fue más "tuya" (decisión, criterio) y qué parte más "de la IA" (ejecución, generación)? ¿Cambió esa proporción a lo largo del proyecto?',
  E'- Pensar que "usar IA" significa ceder todo el criterio — el patrón de este proyecto muestra lo contrario: más automatización no significó menos control, significó más terreno cubierto con el mismo nivel de revisión.\n- No reconocer el propio trabajo de revisión y decisión como una habilidad real que se está desarrollando (justamente el objetivo declarado de esta Academy: "comprender profundamente el porqué de las decisiones técnicas").\n- Suponer que este patrón de trabajo (generar + revisar + aplicar) se vuelve innecesario con el tiempo — sigue siendo la base incluso para el futuro Asistente de Aprendizaje IA.',
  E'- [ ] Puedo describir el patrón común de generación + revisión + aplicación usado en todo este proyecto.\n- [ ] Puedo dar un ejemplo real de cada uno de los 3 módulos de esta etapa.\n- [ ] Escribí mi reflexión sobre qué tan tuyo fue el criterio a lo largo de este proyecto.',
  20, 'Intermedio', 'Pruebas asistidas por IA', 3, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'ad383b29-fcd8-4ddc-9512-fbeb52ee21cf',
  'e259f2ec-f9dc-4164-b142-deeeb3c78c0b',
  'Releé el plan de implementación original',
  'Abrí IMPLEMENTATION_PLAN.md e identificá qué partes fueron tu visión y qué partes fueron propuesta técnica de la IA.',
  'short_answer', 1
),
(
  '8e556504-fcfa-4934-b55f-420116b25a73',
  'c365bdcc-323a-4c5a-a87c-48cc2c8dfca5',
  'Escribí un prompt técnico completo',
  'Para una tarea pendiente de otro proyecto, escribí un prompt con contexto, objetivo específico y al menos una restricción.',
  'long_answer', 1
),
(
  '0b559294-40c7-41f1-b8e0-a1397c3ccfd1',
  '0fc357da-b8e2-492d-be30-e8c12b77049c',
  'Encontrá una regla de trabajo respetada',
  'Elegí una regla de trabajo original de este proyecto y describí un ejemplo real donde se respetó en la práctica.',
  'short_answer', 1
),
(
  'c95440b8-3957-42eb-b7dd-965851df33d1',
  '39a6618d-3ded-4ae6-aa1e-2d8e165dc796',
  'Revisá un archivo que no conocías',
  'Elegí un archivo de código de esta Academy que no hayas leído en detalle y explicá, línea por línea, qué hace.',
  'long_answer', 1
),
(
  '1f7c3f44-052b-4656-a378-469e128280d4',
  'cbbf205d-123e-4497-be2f-37680565503b',
  'Aplicá la checklist de 5 puntos',
  'Elegí un componente de esta Academy y evaluá cada uno de los 5 puntos de la checklist de revisión.',
  'long_answer', 1
),
(
  '1babd845-4fce-428f-a7c8-671e9ea65c70',
  'cba7a253-8c73-4a9c-895d-53f72a566e22',
  'Aplicá el método de diagnóstico',
  'La próxima vez que veas un error real en cualquier proyecto, aplicá los 4 pasos del método y documentá el resultado.',
  'long_answer', 1
),
(
  'c8be4a07-2637-4638-b53a-4d3acfe22bff',
  '37020856-7ef3-4246-8d30-b05e16460e1d',
  'Confirmá la precisión del README',
  'Leé la sección "Estado actual" del README de esta Academy y confirmá si describe con precisión lo que existe hoy.',
  'checklist', 1
),
(
  'c8503bbf-4891-4bcc-b239-b4e20b4c8162',
  '2d0a98b7-0aab-4bef-b7f3-b23bf8b43ed4',
  'Ejecutá 3 ítems de TESTING.md',
  'Elegí 3 ítems de docs/TESTING.md y ejecutalos manualmente contra tu Academy real, confirmando si pasan.',
  'checklist', 1
),
(
  '4442edce-116a-4577-8bc1-55543e309bfc',
  '4368533b-a348-4606-b9a0-dfe2f0cb83f8',
  'Reflexión final de la etapa',
  'Escribí tu reflexión sobre qué tan tuyo fue el criterio en este proyecto, y si esa proporción cambió con el tiempo.',
  'long_answer', 1
);
