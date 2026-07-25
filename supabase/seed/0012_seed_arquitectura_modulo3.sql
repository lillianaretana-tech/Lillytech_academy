-- 0012_seed_arquitectura_modulo3.sql
-- Módulo 3 de la Etapa 4 (Arquitectura de aplicaciones): "Arquitecturas y entornos" — cierra la Etapa 4 completa.

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '2e3d4268-ec58-4b4e-a377-506165c04119', id, 'Arquitecturas y entornos', 'Multiusuario, multiempresa y separación de ambientes — decisiones de arquitectura que esta Academy ya tomó, algunas todavía sin necesitarlas.', 3, true
from public.courses where title = 'Cómo se arma una aplicación real';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '9468dbe1-8ed0-4c43-8444-b05006387ea5',
  '2e3d4268-ec58-4b4e-a377-506165c04119',
  'Arquitectura multiusuario',
  'Cómo una misma aplicación sirve a muchas personas distintas sin que sus datos se mezclen — algo que esta Academy ya soporta, aunque hoy solo la use una persona.',
  E'- Explicar qué significa que una arquitectura sea "multiusuario".\n- Identificar qué piezas de esta Academy ya la hacen multiusuario, aunque hoy tenga una sola usuaria real.\n- Distinguir multiusuario de multiempresa (próxima lección).',
  E'Una arquitectura multiusuario es aquella donde múltiples personas pueden usar la misma aplicación, cada una viendo y modificando solo lo que le corresponde, sin pisar los datos de las demás. No es necesariamente algo que se "agrega después" — es una decisión de diseño que, si no se toma desde el principio, es mucho más cara de agregar después.\n\nEsta Academy ya es multiusuario en su arquitectura, aunque hoy tenga una sola usuaria real (vos). La evidencia está en cómo está diseñado el modelo de datos desde el principio:\n\n- Cada tabla personal (lesson_progress, personal_notes, practical_projects, concept_mastery) tiene una columna user_id, no asume "una sola persona usa esto".\n- Las políticas RLS ya filtran por auth.uid() = user_id en todos lados — si mañana se registrara una segunda estudiante real, sus datos jamás se mezclarían con los tuyos, sin cambiar una sola línea de código.\n- El rol student vs admin ya está pensado para convivir: varias estudiantes con el mismo rol, cada una con su propio progreso aislado.\n\nEsto es lo opuesto a diseñar "para una sola usuaria" y tener que reestructurar todo después — la arquitectura ya soporta crecer sin refactor mayor.',
  E'Si mañana tu hermana quisiera aprender con LillyTech Academy, simplemente se registraría con su propio email — su progreso, sus notas, sus proyectos, todo quedaría completamente separado del tuyo, gracias a las políticas RLS que ya existen. No haría falta ni una migración nueva.',
  E'Repasá la migración 0004 (exercises_and_progress) y confirmá que lesson_progress tiene user_id como parte de su clave — pensá qué pasaría si esa columna no existiera y todas las estudiantes compartieran una sola fila de progreso por lección.',
  E'- Diseñar el modelo de datos asumiendo "una sola usuaria" y tener que agregar user_id a todas las tablas después, con el costo de migrar datos existentes.\n- Confundir "multiusuario" con "tiene una tabla de usuarios" — lo que importa es que CADA tabla con datos personales aísle correctamente por usuaria, no solo que exista una tabla profiles.\n- Pensar que multiusuario requiere una interfaz distinta — en esta Academy, la misma interfaz sirve para una o mil usuarias, solo cambia cuántas filas hay en cada tabla.',
  E'- [ ] Puedo explicar qué significa arquitectura multiusuario.\n- [ ] Puedo señalar 3 tablas de esta Academy que ya están preparadas para multiusuario.\n- [ ] Puedo explicar por qué agregar esto "después" sería más costoso que diseñarlo desde el principio.',
  15, 'Intermedio', 'Flujo de datos: seguir un dato de punta a punta', 1, true
),
(
  '4875c741-a331-4970-94f7-01a43d80771e',
  '2e3d4268-ec58-4b4e-a377-506165c04119',
  'Arquitectura multiempresa',
  'Un paso más allá de multiusuario: cuando ni siquiera todas las usuarias pertenecen a la misma organización — algo que esta Academy no necesita, pero que sí aplica a otros proyectos LillyTech.',
  E'- Explicar la diferencia entre multiusuario y multiempresa (multi-tenant).\n- Reconocer que esta Academy es multiusuario pero NO multiempresa, y por qué eso es correcto para su propósito.\n- Identificar qué cambiaría si LillyTech Academy se convirtiera en un SaaS que otras organizaciones usaran.',
  E'Multiusuario significa "varias personas, cada una con sus propios datos". Multiempresa (multi-tenant) va un paso más allá: varias ORGANIZACIONES distintas usan la misma aplicación, y ni siquiera las personas de una organización deberían ver datos de otra — es una capa extra de aislamiento, por encima del aislamiento por usuaria individual.\n\nEsta Academy es multiusuario pero NO multiempresa — y esa es la decisión correcta para su propósito actual: es tu academia personal, no un producto que otras empresas van a usar con sus propios equipos. Si algún día LillyTech Academy se convirtiera en un producto SaaS real que otras personas u organizaciones contrataran (mencionado como posible futuro en el plan original, pero explícitamente fuera de alcance del MVP), ahí sí haría falta una capa de "organización" o "tenant": una tabla organizations, una columna organization_id en cada tabla relevante, y políticas RLS que filtren no solo por auth.uid() sino también por pertenencia a la organización correcta.\n\nOtros proyectos LillyTech sí podrían necesitar pensar en esto desde ahora si sirven a múltiples clientes distintos (por ejemplo, un sistema de Inventario que uses para varios sitios de clientes distintos como JLL, McKinsey, ADVANT) — ahí "sitio" o "cliente" cumple un rol parecido al de "empresa" en un sistema multi-tenant.',
  E'En tu sistema de Inventario multi-sitio, la tabla sites probablemente ya cumple un rol parecido a "organización" en un sistema multi-tenant — cada sitio (JLL, McKinsey, etc.) debería ver solo su propio inventario, nunca el de otro cliente, aunque todos usen la misma aplicación.',
  E'Pensá en uno de tus otros proyectos (Inventario, por ejemplo) y identificá si ya tiene, sin llamarlo así, una noción de "organización" o "tenant" que separa los datos de un cliente de los de otro.',
  E'- Confundir multiusuario con multiempresa — no diseñar la capa extra de aislamiento por organización cuando sí hacía falta, permitiendo que datos de un cliente se mezclen con los de otro.\n- Sobre-diseñar multiempresa desde el día uno para un proyecto que nunca lo va a necesitar (como esta Academy) — complejidad innecesaria.\n- No anticipar la necesidad si el producto realmente podría convertirse en SaaS multiempresa más adelante, dificultando el cambio después.',
  E'- [ ] Puedo explicar la diferencia entre multiusuario y multiempresa.\n- [ ] Puedo explicar por qué esta Academy no necesita ser multiempresa.\n- [ ] Puedo identificar si alguno de mis otros proyectos LillyTech ya tiene una noción de "organización" sin llamarla así.',
  15, 'Intermedio', 'Arquitectura multiusuario', 2, true
),
(
  'b054b12b-42fe-46ec-82cd-a9c1c5159ed9',
  '2e3d4268-ec58-4b4e-a377-506165c04119',
  'Separación de ambientes',
  'Repaso final de la Etapa 4: por qué separar desarrollo, pruebas y producción es una práctica estándar — y por qué esta Academy, otra vez, decidió conscientemente no hacerlo todavía.',
  E'- Repasar el concepto de separación de ambientes ya visto en la Etapa 3.\n- Conectarlo con arquitectura multiusuario y multiempresa como parte del mismo tipo de decisión: "proporcional al riesgo real".\n- Cerrar la Etapa 4 con una reflexión integradora sobre las decisiones de arquitectura de esta Academy.',
  E'Ya viste, en la Etapa 3, la idea de separar entornos de stage y producción. Esta lección la retoma desde el ángulo de arquitectura general, para cerrar el módulo: separar ambientes (desarrollo, pruebas/staging, producción) es una práctica estándar en proyectos con múltiples personas trabajando y usuarias reales dependiendo del sistema.\n\nEsta Academy, como ya viste, usa un solo entorno — y es la tercera vez en esta etapa que aparece el mismo patrón de decisión: multiusuario (sí, porque es barato y correcto desde el principio), multiempresa (no, porque no aplica al propósito actual), separación de ambientes (no todavía, porque el riesgo de trabajar en un solo entorno es bajo para un proyecto de una sola desarrolladora).\n\nLa idea que conecta las tres decisiones, y que vale la pena llevarse como cierre de toda la Etapa 4: la arquitectura correcta no es "la más completa posible" ni "la más simple posible" — es la que responde con precisión a los riesgos y necesidades reales del proyecto en el momento en que se construye, dejando la puerta abierta a crecer cuando haga falta, sin pagar el costo de esa complejidad antes de necesitarla.',
  E'Las tres decisiones de este módulo (multiusuario sí, multiempresa no, ambientes separados no todavía) muestran el mismo criterio que ya usaste en la lección de "seguridad proporcional al riesgo" de la Etapa 3 — la arquitectura, igual que la seguridad, se calibra según el riesgo real, no según una regla única aplicada sin pensar.',
  E'Escribí, en tus propias palabras, un resumen de una o dos líneas por cada una de las tres decisiones de este módulo, explicando por qué cada una es correcta para esta Academy en este momento.',
  E'- Aplicar una misma "receta de arquitectura" a todo proyecto sin evaluar su contexto real (ni "siempre separar ambientes" ni "nunca separar ambientes" son reglas universales correctas).\n- No revisar periódicamente si las decisiones de arquitectura siguen siendo las correctas a medida que el proyecto crece (lo que es correcto hoy podría dejar de serlo).\n- Pensar que estas decisiones son "definitivas" en vez de revisables — la arquitectura de un proyecto vivo evoluciona con él.',
  E'- [ ] Puedo resumir las tres decisiones de arquitectura de este módulo y su justificación.\n- [ ] Puedo conectar esta lección con la de "seguridad proporcional al riesgo" de la Etapa 3.\n- [ ] Puedo identificar una señal futura que indicaría que alguna de estas decisiones debería cambiar.',
  15, 'Intermedio', 'Arquitectura multiempresa', 3, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'bcd40975-7c91-46e8-a295-7eaebd334c84',
  '9468dbe1-8ed0-4c43-8444-b05006387ea5',
  'Encontrá el user_id en 3 tablas',
  'Revisá 3 migraciones de esta Academy y confirmá que las tablas de datos personales tienen columna user_id con su foreign key correspondiente.',
  'short_answer', 1
),
(
  'afd08886-87ec-4fb2-ab96-4766e26043e3',
  '4875c741-a331-4970-94f7-01a43d80771e',
  'Analizá uno de tus otros proyectos',
  'Elegí Inventario, Vacaciones o Control de Asistencia y explicá si ya tiene una noción de "organización/sitio/cliente" que cumple un rol multi-tenant, aunque no se llame así.',
  'short_answer', 1
),
(
  '35f0bad0-3465-4839-b73e-955e22c06575',
  'b054b12b-42fe-46ec-82cd-a9c1c5159ed9',
  'Resumí las tres decisiones del módulo',
  'Escribí un resumen de 3-4 líneas explicando por qué esta Academy es multiusuario, no es multiempresa, y no separa ambientes todavía — y qué señal futura cambiaría cada una.',
  'long_answer', 1
);
