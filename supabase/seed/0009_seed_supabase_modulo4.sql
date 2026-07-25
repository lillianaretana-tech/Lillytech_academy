-- 0009_seed_supabase_modulo4.sql
-- Módulo 4 de la Etapa 3 (Supabase): "Operación del proyecto" — cierra la Etapa 3 completa.

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '1736a605-a7e1-49e8-bf81-d63576c128ea', id, 'Operación del proyecto', 'Migraciones, backups, logs, entornos y variables — cómo se mantiene un proyecto Supabase en el tiempo, no solo cómo se crea.', 4, true
from public.courses where title = 'Supabase en profundidad';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'ad433a85-da71-43ab-8ad0-88910db0e88f',
  '1736a605-a7e1-49e8-bf81-d63576c128ea',
  'Migraciones: cambios de esquema con historial',
  'Por qué cada cambio a la estructura de la base de datos de esta Academy vive en un archivo numerado, en vez de aplicarse directo y sin dejar rastro.',
  E'- Explicar qué es una migración y qué problema resuelve frente a modificar la base "a mano".\n- Reconocer la convención de numeración usada en esta Academy.\n- Entender por qué las migraciones nunca se editan después de aplicadas, solo se agregan nuevas.',
  E'Una migración es un archivo SQL que describe UN cambio a la estructura de la base de datos (crear una tabla, agregar una columna, crear una política), guardado con un número de orden. Esta Academy tiene 13 migraciones en supabase/migrations/, numeradas 0001 a 0013, cada una haciendo un cambio específico y acumulativo.\n\n¿Por qué no simplemente entrar al Table Editor y crear las tablas a mano, clickeando? Porque eso no deja ningún registro reproducible. Si mañana necesitaras recrear esta misma base de datos en otro proyecto Supabase (por ejemplo, un entorno de pruebas separado), con las migraciones alcanza con correr los 13 archivos en orden. Sin ellas, tendrías que recordar y repetir cada click manual — imposible de mantener con precisión después de la migración número 20 o 30.\n\nLa regla de oro de las migraciones: una vez aplicada (corrida contra una base de datos real), nunca se edita el archivo — si algo estaba mal o necesita cambiar, se crea una migración NUEVA que corrige lo anterior (por ejemplo, un ALTER TABLE que agrega la columna que faltaba). Esto preserva el historial real de cómo evolucionó la base, en vez de reescribir la historia.',
  E'Cuando encontramos el problema del course_id desactualizado en el seed del Módulo 3 de SQL, la solución no fue "editar las migraciones viejas" — fue ajustar el seed para buscar por título en vez de id fijo. Ese es el mismo espíritu: no reescribir el pasado, adaptar hacia adelante.',
  E'En tu Codespace, abrí supabase/migrations/ y ordená los archivos por nombre — confirmá que ves la secuencia completa del 0001 al 0013, cada uno con un nombre que describe qué hace.',
  E'- Editar una migración ya aplicada en vez de crear una nueva — si alguien más (o vos misma en otro entorno) ya la corrió, editarla después genera inconsistencias.\n- No numerar las migraciones en el orden correcto de dependencia (por ejemplo, una migración que crea una política sobre una tabla que todavía no existe).\n- Aplicar cambios de estructura directo en producción sin que quede un archivo de migración documentando qué se hizo y por qué.',
  E'- [ ] Puedo explicar qué es una migración y qué problema resuelve.\n- [ ] Puedo listar las migraciones de esta Academy en orden.\n- [ ] Puedo explicar por qué no se edita una migración ya aplicada.',
  15, 'Intermedio', 'Realtime: recibir cambios sin recargar la página', 1, true
),
(
  '8e25ca5f-7435-4227-a75e-ca12b27cb52a',
  '1736a605-a7e1-49e8-bf81-d63576c128ea',
  'Backups: qué pasa si algo sale mal',
  'Las copias de seguridad automáticas de Supabase, y la diferencia entre confiar en ellas y tener tu propia red de seguridad.',
  E'- Explicar qué tipo de backups ofrece Supabase según el plan del proyecto.\n- Reconocer la diferencia entre un backup automático y uno manual.\n- Identificar qué backup "extra" ya tiene esta Academy sin llamarlo así.',
  E'Supabase hace backups automáticos de tu base de datos con cierta frecuencia (la frecuencia exacta y cuánto tiempo se conservan depende del plan del proyecto — en el plan gratuito son más limitados que en planes pagos). Esto te protege de fallas de infraestructura del lado de Supabase, pero no de errores humanos que ya se aplicaron y confirmaron (como un DELETE sin WHERE que corriste vos misma y ya hiciste commit).\n\nAdemás del backup que ofrece Supabase, esta Academy ya tiene, sin llamarlo así, una segunda red de seguridad: las migraciones y seeds que viven en tu repo de GitHub. Si alguna vez perdieras el proyecto Supabase entero, con esos archivos podrías reconstruir toda la estructura y el contenido desde cero en un proyecto nuevo — no es un backup en el sentido estricto (no incluye el progreso de estudiantes, por ejemplo), pero sí te devuelve toda la estructura y el contenido educativo.\n\nUn backup manual bajo demanda (antes de un cambio grande y riesgoso) suele ser posible desde el dashboard, en Database → Backups — vale la pena revisarlo antes de una migración especialmente destructiva.',
  E'El hecho de que puedas reconstruir la ruta completa de esta Academy, sus 11 etapas y todo el contenido, simplemente corriendo los archivos de supabase/migrations/ y supabase/seed/ en un proyecto Supabase nuevo, es en sí una forma de respaldo — distinta a un backup de infraestructura, pero igual de valiosa para vos.',
  E'Entrá a Database → Backups en tu dashboard de Supabase y mirá qué opciones aparecen para tu plan actual. No hace falta restaurar nada — solo familiarizarte con dónde está.',
  E'- Confiar ciegamente en el backup automático de Supabase como única red de seguridad, sin versionar tus migraciones en Git.\n- No hacer un backup manual antes de una migración grande y potencialmente destructiva.\n- Pensar que un backup de base de datos también respalda tu código — son cosas separadas (por eso Git y Supabase Backups cumplen roles distintos, complementarios).',
  E'- [ ] Sé qué tipo de backup automático tiene mi proyecto según su plan.\n- [ ] Entiendo que mis migraciones en GitHub son, en la práctica, una segunda red de seguridad.\n- [ ] Sé dónde encontrar la opción de backup manual en el dashboard.',
  10, 'Intermedio', 'Migraciones: cambios de esquema con historial', 2, true
),
(
  'f5bfba7c-dfcd-4034-9cae-b830b2df35e6',
  '1736a605-a7e1-49e8-bf81-d63576c128ea',
  'Logs: qué pasó realmente',
  'Dónde mirar cuando algo falla y no sabés por qué — los registros que Supabase guarda de cada consulta, error y evento de autenticación.',
  E'- Ubicar la sección de Logs en el dashboard de Supabase.\n- Distinguir entre logs de base de datos, de API y de autenticación.\n- Adoptar el hábito de revisar logs como primer paso ante un error inesperado.',
  E'Supabase guarda logs (registros) de varias capas distintas de tu proyecto, todos accesibles desde el dashboard en la sección Logs:\n\n- Logs de base de datos (Postgres): errores de SQL, consultas lentas.\n- Logs de API (PostgREST): cada request que llega a través de supabase.from(...), con su código de respuesta.\n- Logs de Auth: intentos de login, registros, errores de autenticación.\n\nCuando algo falla en tu app y el mensaje de error en el navegador no es suficientemente claro (por ejemplo, un genérico "Failed to fetch" o un error de RLS poco descriptivo), los logs del dashboard suelen tener el detalle real: qué política bloqueó la consulta, qué columna causó el error, o si el problema fue de red y no de tu código.\n\nEl hábito profesional ante un error inesperado es: primero mirar el error en la consola del navegador, después (si no alcanza) revisar los logs correspondientes en el dashboard de Supabase, y recién después sospechar que el código de la app está mal — muchas veces el problema real es una política RLS, una migración que no corrió, o datos que no son los esperados.',
  E'El error transitorio "No se pudo cargar la lección" que viste hace poco en esta Academy, justo después de correr una migración nueva, es exactamente el tipo de situación donde revisar los Logs de API te mostraría el código de error exacto de PostgREST — útil si alguna vez ese tipo de error persistiera en vez de resolverse solo con un refresh.',
  E'Entrá a la sección Logs de tu dashboard y explorá las distintas pestañas (Postgres, API, Auth). No hace falta que haya errores para mirarlos — familiarizate con el formato antes de necesitarlo en una emergencia real.',
  E'- Asumir que el código de React está roto antes de revisar qué dicen los logs del lado de Supabase.\n- No saber que existen logs separados por capa (base de datos, API, Auth) y buscar en el lugar equivocado.\n- Ignorar logs de consultas lentas que podrían indicar la necesidad de un índice (conectado con la lección de índices de la Etapa 2).',
  E'- [ ] Sé dónde está la sección Logs en el dashboard.\n- [ ] Puedo distinguir logs de base de datos, de API y de autenticación.\n- [ ] Adopté el hábito de revisar logs antes de asumir que el problema es del código.',
  10, 'Intermedio', 'Backups: qué pasa si algo sale mal', 3, true
),
(
  'c58cde58-586e-4488-95be-e4ce7e9a019c',
  '1736a605-a7e1-49e8-bf81-d63576c128ea',
  'Stage y producción: por qué no se prueba donde vive lo real',
  'La idea de tener un entorno separado para probar cambios antes de que toquen los datos reales — algo que esta Academy todavía no tiene, y por qué eso es una decisión consciente, no un descuido.',
  E'- Explicar la diferencia entre un entorno de stage/desarrollo y uno de producción.\n- Reconocer los riesgos de trabajar con un solo proyecto Supabase para todo.\n- Identificar cuándo tendría sentido, para esta Academy, separar entornos.',
  E'Muchos proyectos serios mantienen al menos dos proyectos Supabase separados: uno de "stage" o desarrollo (donde se prueban migraciones y cambios nuevos, con datos de prueba) y otro de "producción" (donde viven los datos reales, de usuarias reales). El flujo típico: probás una migración riesgosa en stage primero, confirmás que anda bien, y recién después la aplicás en producción.\n\nEsta Academy, hasta ahora, usa un solo proyecto Supabase para todo — que también es tu entorno de producción real (tus propios datos de estudio). Esto es una decisión razonable para el tamaño y el riesgo actual del proyecto: sos la única usuaria, y el costo de mantener un segundo proyecto Supabase completo (con su propia base de datos, sus propias claves, su propio .env) sería mayor que el beneficio, al menos por ahora.\n\nEsto se conecta directo con la lección de "seguridad proporcional al riesgo" que ya viste: separar entornos tiene sentido cuando el riesgo de romper producción es alto (muchas usuarias reales, datos críticos) — para un proyecto personal en etapa de aprendizaje activo, sería sobreingeniería innecesaria, al menos en este momento.',
  E'Cuando corriste la migración con el error de course_id, el hecho de que fallara "de forma segura" (todo el archivo se revirtió automáticamente, sin dejar datos a medias) es justamente lo que te permitió trabajar con un solo entorno sin tanto riesgo — Postgres protegiéndote de un error que en un sistema sin transacciones podría haber sido más grave.',
  E'No hay ejercicio práctico de "crear" un segundo entorno ahora — el objetivo de esta lección es la reflexión: si LillyTech Academy creciera a tener más estudiantes reales dependiendo de ella, ¿en qué momento pensás que valdría la pena separar stage de producción?',
  E'- Copiar la práctica de "siempre hay que tener stage y producción separados" sin evaluar si el proyecto realmente lo necesita todavía.\n- Probar cambios riesgosos directo en el único entorno que existe, sin las protecciones que sí tenés (transacciones, backups, revisión antes de correr).\n- No tener un plan de cuándo sí valdría la pena separar entornos, si el proyecto creciera.',
  E'- [ ] Puedo explicar la diferencia entre stage y producción.\n- [ ] Puedo explicar por qué esta Academy no separa entornos todavía, y que es una decisión razonada, no un descuido.\n- [ ] Puedo identificar una señal futura que indicaría que ya es momento de separar entornos.',
  10, 'Intermedio', 'Logs: qué pasó realmente', 4, true
),
(
  'ad781b31-8dd5-45be-a9d9-998e7b6f6657',
  '1736a605-a7e1-49e8-bf81-d63576c128ea',
  'Variables de entorno: configuración que no vive en el código',
  'Por qué la URL y la clave de Supabase de esta Academy no están escritas directo en los archivos .tsx, sino en un archivo aparte que ni siquiera se sube a Git.',
  E'- Explicar qué es una variable de entorno y qué problema resuelve.\n- Leer el archivo .env de esta Academy y explicar cada línea.\n- Reconocer por qué .env está en .gitignore y qué pasaría si no lo estuviera.',
  E'Una variable de entorno es un valor de configuración que vive fuera del código fuente, disponible para la aplicación en tiempo de ejecución pero no "hardcodeado" (escrito fijo) en ningún archivo .tsx o .ts.\n\nEsta Academy usa dos, definidas en tu archivo .env:\n\nVITE_SUPABASE_URL=https://tu-proyecto.supabase.co\nVITE_SUPABASE_ANON_KEY=tu-clave\n\nY leídas en el código así (src/lib/supabaseClient.ts):\n\nconst supabaseUrl = import.meta.env.VITE_SUPABASE_URL\n\n¿Por qué no escribir esos valores directo en supabaseClient.ts? Porque eso acoplaría el código a un proyecto Supabase específico — si alguna vez quisieras un entorno de stage separado (lección anterior), o si otra persona clonara este repo para su propia Academia, cada quien necesita sus propios valores sin tener que editar el código fuente compartido.\n\nPor eso .env está en .gitignore: nunca se sube a GitHub, cada quien lo crea localmente con sus propios valores (a partir de .env.example, que sí se sube, como plantilla vacía). Si .env se subiera a un repo público, cualquiera podría ver tu URL y tu clave — para la anon key no sería grave (es pública por diseño), pero es una práctica que hay que mantener consistente para el día que exista una clave que sí importe proteger.',
  E'El prefijo VITE_ en ambas variables no es arbitrario — Vite (el bundler de esta Academy) solo expone al código del navegador las variables de entorno que empiezan con ese prefijo específico, como medida de seguridad para evitar que variables sensibles del servidor terminen filtrándose sin querer al código que corre en el navegador de cualquiera.',
  E'Abrí tu archivo .env.example (el que sí está en el repo) y compará su estructura con tu .env real (que no está en el repo). Confirmá que ambos tienen las mismas dos claves, con valores distintos (placeholder vs. reales).',
  E'- Subir accidentalmente un archivo .env real a Git, exponiendo valores que deberían quedar locales.\n- Escribir valores de configuración directo en el código en vez de en variables de entorno, acoplando el código a un entorno específico.\n- Olvidar el prefijo VITE_ (o el que corresponda según el bundler) y preguntarse por qué la variable "no aparece" en el código del frontend.',
  E'- [ ] Puedo explicar qué es una variable de entorno con mis propias palabras.\n- [ ] Puedo leer mi propio .env y explicar cada línea.\n- [ ] Puedo explicar por qué .env está en .gitignore y qué pasaría si no lo estuviera.',
  10, 'Intermedio', 'Stage y producción: por qué no se prueba donde vive lo real', 5, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  '36e8241c-a40a-4bdf-bdf1-1f121b6757d0',
  'ad433a85-da71-43ab-8ad0-88910db0e88f',
  'Ordená y contá tus migraciones',
  'Abrí supabase/migrations/ en tu Codespace y confirmá que hay 13 archivos, numerados en orden, cada uno con un nombre descriptivo.',
  'checklist', 1
),
(
  '3933fe6a-0fb0-4243-b632-7c949c27e8d0',
  '8e25ca5f-7435-4227-a75e-ca12b27cb52a',
  'Revisá las opciones de backup de tu plan',
  'Entrá a Database → Backups en tu dashboard y anotá qué opciones de backup automático y manual tenés disponibles según tu plan actual.',
  'short_answer', 1
),
(
  'b43b0889-aba9-4633-94ef-9621f3432536',
  'f5bfba7c-dfcd-4034-9cae-b830b2df35e6',
  'Explorá los Logs',
  'Entrá a la sección Logs y mirá al menos una entrada real de cada pestaña (Postgres, API, Auth si tenés actividad reciente).',
  'checklist', 1
),
(
  '1348f53c-dd00-4450-b458-ab80ba15e978',
  'c58cde58-586e-4488-95be-e4ce7e9a019c',
  'Reflexioná sobre cuándo separar entornos',
  'Escribí, en tus palabras, qué señal concreta te indicaría que ya es momento de crear un proyecto Supabase de stage separado del de producción para esta Academy.',
  'short_answer', 1
),
(
  '0b360c1f-1d45-48c7-9252-8390e007df61',
  'ad781b31-8dd5-45be-a9d9-998e7b6f6657',
  'Compará tu .env con .env.example',
  'Confirmá que ambos archivos tienen exactamente las mismas claves (VITE_SUPABASE_URL, VITE_SUPABASE_ANON_KEY), y que solo .env.example está subido a GitHub.',
  'checklist', 1
);
