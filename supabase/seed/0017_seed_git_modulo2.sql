-- 0017_seed_git_modulo2.sql
-- Módulo 2 de la Etapa 6 (Git y GitHub): "Trabajar con cambios".

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '59d9d7ce-c5b5-4f99-9d9a-fcbda117c975', id, 'Trabajar con cambios', 'Branches, pull requests, revert y conflictos — herramientas que esta Academy todavía no usó (porque trabajás sola), pero que te van a hacer falta apenas cambien las condiciones.', 2, true
from public.courses where title = 'Git y GitHub sin miedo';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '6ad07867-8df1-4579-b181-fe96b2b96bc9',
  '59d9d7ce-c5b5-4f99-9d9a-fcbda117c975',
  'Branches: trabajar en paralelo sin pisar lo que ya funciona',
  'Una línea de trabajo separada de main, donde podés probar cosas sin arriesgar el código que ya sabés que anda bien.',
  E'- Explicar qué es un branch y qué problema resuelve.\n- Crear un branch nuevo y volver a main.\n- Reconocer por qué esta Academy no usó branches todavía, y cuándo empezaría a necesitarlos.',
  E'Un branch (rama) es una línea de desarrollo separada dentro del mismo repositorio — podés hacer commits en un branch sin que esos cambios afecten main (la rama principal) hasta que decidas juntarlos (merge).\n\ngit branch fase-6-certificados    -- crea el branch\ngit checkout fase-6-certificados  -- te "parás" en ese branch\n-- (o junto en un solo paso: git checkout -b fase-6-certificados)\n\nEsta Academy, hasta ahora, hizo todos sus commits directo en main — una decisión razonable porque sos la única desarrolladora: no hay riesgo de pisar el trabajo de otra persona, y cada fase se completó y probó antes de seguir con la siguiente.\n\n¿Cuándo empezarías a necesitar branches de verdad? En cuanto quisieras probar algo arriesgado sin comprometer el main que ya funciona — por ejemplo, si quisieras experimentar con una reorganización grande del modelo de datos de certificados, y no estuvieras segura de que va a salir bien en el primer intento. Trabajar en un branch te permite volver a main sin ningún rastro del experimento fallido, simplemente no haciendo merge.\n\nEl documento GITHUB_SETUP.md que ya tenés en este proyecto sugiere justamente esto: una rama por fase (fase-4-estudiante, fase-5-admin, etc.) — una convención que todavía no adoptamos en la práctica, pero que quedó documentada para cuando el proyecto lo pida.',
  E'Si mañana quisieras probar una versión experimental del Asistente de Aprendizaje IA (mencionado como visión futura v2/v3 en el Plan Evolutivo) sin arriesgar que un error rompa la app real que ya usás a diario, la forma correcta sería crear un branch asistente-ia-experimental, trabajar ahí, y solo hacer merge a main cuando estés segura de que funciona.',
  E'En tu Codespace, corré git branch para ver en qué branch estás actualmente (debería decir solo * main). Después probá git checkout -b prueba-branch, hacé un cambio chico de prueba en cualquier archivo, y volvé a main con git checkout main sin hacer commit — confirmá que el cambio de prueba desapareció de main.',
  E'- Trabajar en main directamente para cambios grandes y riesgosos, sin la posibilidad de "abandonar" el experimento limpiamente si sale mal.\n- Crear branches con nombres poco descriptivos (branch1, prueba) que no dicen nada sobre su propósito unas semanas después.\n- Olvidarse en qué branch se está parada, y hacer commits importantes accidentalmente en un branch de prueba.',
  E'- [ ] Puedo explicar qué es un branch y qué problema resuelve.\n- [ ] Puedo crear un branch nuevo y volver a main.\n- [ ] Puedo identificar cuándo esta Academy empezaría a necesitar branches de verdad.',
  15, 'Intermedio', 'Historial: leer el pasado completo de un proyecto', 1, true
),
(
  '077ccdfe-6483-4503-ad6d-3156efefeffb',
  '59d9d7ce-c5b5-4f99-9d9a-fcbda117c975',
  'Pull requests: proponer un cambio antes de aplicarlo',
  'Cómo GitHub deja ver, comparar y aprobar un cambio antes de que se una a main — útil incluso trabajando sola, como forma de revisión propia.',
  E'- Explicar qué es un pull request y qué información muestra.\n- Entender por qué un PR es útil incluso para una sola desarrolladora.\n- Reconocer la diferencia entre "hacer merge directo" y "abrir un PR primero".',
  E'Un pull request (PR) es una propuesta formal de unir los cambios de un branch a otro (típicamente, de un branch de trabajo hacia main). GitHub te muestra, en una sola pantalla, exactamente qué archivos cambiaron, línea por línea, antes de confirmar la unión.\n\nEsta Academy nunca abrió un PR — cada git push a main aplicó los cambios directamente, sin ese paso intermedio de revisión. Es razonable para una sola desarrolladora avanzando rápido, pero tiene un costo: perdés la oportunidad de revisar el diff completo de una fase antes de que quede aplicada, y no queda un registro separado (documentado en el propio historial de GitHub) de "esto es lo que se propuso, esto es lo que se aprobó".\n\nEl documento GITHUB_SETUP.md de este proyecto ya lo menciona: "no hace falta pull requests formales si sos la única que edita — pero si querés dejar registro de qué cambió en cada fase, un PR (aunque te lo apruebes vos misma) te da el historial ordenado y el diff completo de cada fase". Es una herramienta de disciplina personal, no solo de colaboración con otras personas.',
  E'Si hubieras abierto un pull request para cada una de las versiones v1.1 a v1.6 de esta Academy, hoy podrías repasar en GitHub, en una sola pantalla por versión, exactamente qué archivos cambiaron en cada una — hoy esa información existe, pero mezclada dentro del historial general de commits de main.',
  E'Entrá a tu repo en GitHub y mirá la pestaña "Pull requests" — va a estar vacía, porque nunca abriste ninguno. Leé la documentación de GitHub sobre cómo se crea un PR desde un branch (no hace falta crear uno real todavía, solo entender el flujo).',
  E'- Pensar que los pull requests "son solo para equipos" — también sirven como herramienta de revisión personal y de documentación de fases.\n- Hacer merge directo de cambios grandes sin ningún paso de revisión, perdiendo la oportunidad de revisar el diff completo antes de aplicarlo.\n- Confundir un PR con un branch — el branch es donde vive el cambio, el PR es la propuesta formal de unirlo a otro branch.',
  E'- [ ] Puedo explicar qué es un pull request.\n- [ ] Puedo explicar por qué un PR es útil incluso trabajando sola.\n- [ ] Repasé la pestaña Pull requests de mi propio repo en GitHub.',
  10, 'Intermedio', 'Branches: trabajar en paralelo sin pisar lo que ya funciona', 2, true
),
(
  '8d444073-e116-4175-b889-ed1f6dbb16b7',
  '59d9d7ce-c5b5-4f99-9d9a-fcbda117c975',
  'Revert: deshacer un commit sin borrar el historial',
  'Cómo deshacer un cambio que ya se aplicó a main, sin fingir que nunca pasó — la diferencia entre corregir el futuro y reescribir el pasado.',
  E'- Explicar qué hace git revert y en qué se diferencia de simplemente borrar código.\n- Entender por qué revert crea un commit nuevo en vez de eliminar el commit problemático.\n- Reconocer un caso real donde hubiera sido apropiado usar revert en este proyecto.',
  E'git revert deshace los cambios de un commit específico, pero de una forma particular: en vez de borrar ese commit del historial (como si nunca hubiera existido), crea un COMMIT NUEVO que aplica el cambio contrario. El commit original sigue estando ahí, visible en el historial — solo que ahora hay otro commit después que lo cancela.\n\ngit revert a1b2c3d\n\nEsto es coherente con algo que ya viste en la lección de migraciones de la Etapa 3: no se reescribe el pasado, se corrige hacia adelante. Si el commit del zip que quedó pegado por error en el repo hubiera sido más grave (en vez de solo borrar el archivo con un commit nuevo, como hicimos), revert habría sido la herramienta correcta: en vez de intentar "hacer como si ese commit no hubiera pasado", se documenta explícitamente que se decidió deshacerlo, y por qué.\n\nEsto es distinto de simplemente editar el código para sacar lo que sobraba (que es, de hecho, lo que hicimos con el zip) — para cambios chicos y obvios, un commit normal de corrección alcanza; revert tiene más sentido cuando el commit completo (no solo un archivo suelto) resultó ser un error y hay que deshacerlo entero, de forma rastreable.',
  E'El commit "chore: elimina zip que quedo commiteado por error" de este proyecto fue, en la práctica, una corrección manual (borrar el archivo y commitear de nuevo) en vez de un revert formal — funcionó igual de bien para ese caso puntual, porque el problema era un solo archivo suelto, no un conjunto de cambios que hubiera que deshacer como unidad completa.',
  E'Sin ejecutar nada real, escribí cómo se vería el comando exacto para revertir el commit más reciente de tu historial (podés usar git log --oneline para ver su hash).',
  E'- Intentar "deshacer" un commit ya subido a GitHub borrándolo del historial (con comandos que reescriben el pasado, como rebase agresivo) en vez de revertirlo hacia adelante — peligroso si otras personas (o vos misma en otra copia) ya tienen ese historial.\n- Confundir revert con simplemente editar el código de vuelta al estado anterior sin ningún commit que lo documente — se pierde el rastro de que hubo un error y se corrigió.\n- Usar revert para cambios chicos donde un commit de corrección normal ya alcanza, agregando complejidad innecesaria al historial.',
  E'- [ ] Puedo explicar qué hace git revert y por qué crea un commit nuevo en vez de borrar el original.\n- [ ] Puedo explicar la diferencia entre revert y reescribir el historial.\n- [ ] Identifiqué, en el historial de este proyecto, un caso donde revert habría sido la herramienta apropiada.',
  15, 'Intermedio', 'Pull requests: proponer un cambio antes de aplicarlo', 3, true
),
(
  'd57547ff-cf21-486b-a17a-9059cc3e0112',
  '59d9d7ce-c5b5-4f99-9d9a-fcbda117c975',
  'Resolución de conflictos: cuando dos cambios chocan',
  'Qué pasa cuando dos versiones del mismo archivo no pueden combinarse solas — y por qué esta Academy, trabajando en un solo branch, nunca lo vivió todavía.',
  E'- Explicar qué es un conflicto de merge y cuándo ocurre.\n- Leer los marcadores de conflicto que Git agrega a un archivo.\n- Reconocer que un conflicto no es un error del sistema, sino Git pidiendo ayuda humana.',
  E'Un conflicto de merge ocurre cuando Git intenta combinar dos versiones distintas del mismo archivo (por ejemplo, al hacer merge de un branch a otro) y encuentra cambios que se superponen en las mismas líneas, sin poder decidir automáticamente cuál "gana". En ese caso, Git no adivina — se detiene y te pide que decidas vos.\n\nCuando esto pasa, Git marca el archivo con algo así:\n\n<<<<<<< HEAD\ntexto de la versión actual (main)\n=======\ntexto de la otra versión (el branch que estás integrando)\n>>>>>>> nombre-del-branch\n\nTu trabajo es editar el archivo a mano, decidiendo qué texto final querés (puede ser uno de los dos, una combinación, o algo completamente distinto), borrar los marcadores (<<<<<<<, =======, >>>>>>>), y hacer un commit normal confirmando la resolución.\n\nEsta Academy nunca vivió un conflicto real porque todo el trabajo pasó directo por main, sin branches paralelos tocando los mismos archivos al mismo tiempo. En cuanto empieces a usar branches (Lección 1 de este módulo) para trabajar en paralelo, la posibilidad de un conflicto aparece — no es un síntoma de que algo esté mal, es simplemente lo que pasa cuando dos líneas de trabajo tocan la misma parte de un archivo.',
  E'Si tuvieras un branch fase-6-certificados y otro fase-7-glosario, y ambos modificaran la misma sección de AppLayout.tsx (por ejemplo, agregando cada uno un link nuevo al sidebar), al intentar unir ambos branches a main, Git no podría decidir solo en qué orden deberían quedar los dos links nuevos — eso sería un conflicto real, esperando tu decisión.',
  E'Sin necesidad de generar un conflicto real, escribí cómo resolverías el ejemplo de arriba: dos links nuevos agregados al mismo lugar del sidebar por branches distintos. ¿Cuál pondrías primero?',
  E'- Entrar en pánico ante un conflicto, pensando que algo se rompió — es un evento normal y esperado del trabajo con branches, no un error.\n- Resolver un conflicto sin entender realmente qué cambio representa cada lado (HEAD vs. el otro branch), eligiendo al azar.\n- Olvidarse de borrar los marcadores de conflicto (<<<<<<<, =======, >>>>>>>) al resolver, dejando texto roto en el archivo.',
  E'- [ ] Puedo explicar qué es un conflicto de merge y cuándo ocurre.\n- [ ] Puedo leer los marcadores de conflicto y explicar qué representa cada sección.\n- [ ] Puedo describir cómo resolvería un conflicto hipotético simple.',
  15, 'Intermedio', 'Revert: deshacer un commit sin borrar el historial', 4, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  '28e6475d-fbec-4187-b02b-ac5762fcae6f',
  '6ad07867-8df1-4579-b181-fe96b2b96bc9',
  'Creá y abandoná un branch de prueba',
  'Creá un branch nuevo, hacé un cambio chico sin commitear a main, y volvé a main confirmando que el cambio no quedó ahí.',
  'checklist', 1
),
(
  '037af590-052b-4fd1-b083-3482ba472f4f',
  '077ccdfe-6483-4503-ad6d-3156efefeffb',
  'Repasá la pestaña Pull requests',
  'Entrá a tu repo en GitHub, pestaña Pull requests, y confirmá que está vacía. Leé en la documentación de GitHub cómo se abriría uno.',
  'checklist', 1
),
(
  '4b6ec3c2-a326-4500-be88-636c40237eb5',
  '8d444073-e116-4175-b889-ed1f6dbb16b7',
  'Escribí el comando de revert',
  'Usando git log --oneline, elegí un commit real de tu historial y escribí el comando exacto que usarías para revertirlo (sin ejecutarlo).',
  'short_answer', 1
),
(
  '7b257806-ae65-4589-bf3f-1ddd18eacc7c',
  'd57547ff-cf21-486b-a17a-9059cc3e0112',
  'Resolvé un conflicto hipotético',
  'Para el ejemplo de dos links nuevos agregados al mismo lugar del sidebar por branches distintos, escribí cómo quedaría el archivo final después de tu resolución.',
  'short_answer', 1
);
