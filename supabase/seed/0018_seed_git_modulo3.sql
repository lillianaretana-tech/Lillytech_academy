-- 0018_seed_git_modulo3.sql
-- Módulo 3 de la Etapa 6 (Git y GitHub): "Publicar y versionar" — cierra la Etapa 6 completa.

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '7ba150cf-35c6-4c34-ac52-8573126a050d', id, 'Publicar y versionar', 'Versiones, releases, GitHub Pages y el flujo de trabajo seguro que ya venís siguiendo sin nombrarlo así.', 3, true
from public.courses where title = 'Git y GitHub sin miedo';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'e806eda5-c839-454d-bc68-6b5d2807a3ce',
  '7ba150cf-35c6-4c34-ac52-8573126a050d',
  'Versiones: ponerle nombre a un momento del proyecto',
  'La diferencia entre "el historial de commits" y "una versión con nombre" — y por qué esta Academy ya tiene, sin llamarlas así, versiones bien definidas (v1.1 a v1.6).',
  E'- Distinguir un commit cualquiera de una versión con nombre.\n- Explicar la convención de versionado semántico (semver) básica.\n- Relacionar el Plan Evolutivo de esta Academy con la idea de versiones.',
  E'Cada commit es un punto en el historial, pero no todos los commits representan un momento "completo y estable" del proyecto que valga la pena nombrar. Una versión es justamente eso: un punto específico del historial al que le ponés un nombre porque representa un estado coherente y utilizable — "esto es lo que el proyecto podía hacer en este momento".\n\nUna convención común para nombrar versiones es el versionado semántico (semver): v1.2.0, con tres números — mayor.menor.parche. Un cambio de "menor" (v1.1 → v1.2) agrega funcionalidad nueva sin romper lo anterior; un cambio "mayor" (v1.x → v2.0) puede incluir cambios que rompen compatibilidad con la versión anterior; un "parche" (v1.2.0 → v1.2.1) es una corrección chica.\n\nEsta Academy ya tiene, documentado en docs/PLAN_EVOLUTIVO.md, exactamente esta idea aplicada: v1.1 (gaps + fundamento de Conceptos), v1.2 (Biblioteca de Conceptos completa), v1.3 (nivel de dominio), y así hasta v1.6. Cada una representa un momento estable y coherente del proyecto — aunque, a diferencia de un versionado semver formal con tags de Git, estas versiones viven como secciones documentadas en un archivo, no como tags reales en el repositorio todavía.',
  E'Si quisieras formalizar las versiones ya documentadas en PLAN_EVOLUTIVO.md como versiones reales de Git, podrías usar git tag v1.6 sobre el commit exacto donde terminó esa versión — dejando un marcador permanente y navegable, en vez de solo un párrafo en un documento.',
  E'Abrí docs/PLAN_EVOLUTIVO.md y contá cuántas versiones ya completaste (marcadas COMPLETADA). Elegí una y pensá qué número de semver le pondrías si tuvieras que decidir hoy.',
  E'- Pensar que "versión" es lo mismo que "commit" — todo commit es parte del historial, pero no todo commit merece ser nombrado como una versión.\n- No documentar en ningún lado qué cambió entre una versión y la siguiente, perdiendo la razón de tenerlas nombradas.\n- Usar semver sin entender qué significa cada número, incrementando el número equivocado para el tipo de cambio real.',
  E'- [ ] Puedo explicar la diferencia entre un commit y una versión nombrada.\n- [ ] Puedo explicar los tres números del versionado semántico.\n- [ ] Puedo relacionar las versiones de PLAN_EVOLUTIVO.md con esta idea.',
  15, 'Intermedio', 'Resolución de conflictos: cuando dos cambios chocan', 1, true
),
(
  '3813ecde-51c8-4698-ba59-168c936142e2',
  '7ba150cf-35c6-4c34-ac52-8573126a050d',
  'Releases: una versión, empaquetada y publicada',
  'Cómo GitHub deja marcar formalmente un punto del historial como "versión publicada", con notas de qué trae — el siguiente paso natural después de nombrar versiones.',
  E'- Explicar qué es un release de GitHub y en qué se diferencia de un tag simple.\n- Entender qué información suele incluir un release (notas de la versión).\n- Reconocer cuándo esta Academy podría beneficiarse de crear releases reales.',
  E'Un release en GitHub es un tag de Git (un nombre fijo sobre un commit específico) combinado con una página de notas: qué cambió, qué se agregó, qué se corrigió — visible en la pestaña "Releases" del repositorio, y opcionalmente con archivos adjuntos (como un .zip del código en ese momento exacto).\n\nEsta Academy nunca creó un release — cada versión (v1.1 a v1.6) quedó documentada solo en docs/PLAN_EVOLUTIVO.md y docs/ROADMAP.md, dentro del propio código, en vez de como una entrada visible en GitHub. Funciona igual de bien para uso personal, pero un release formal tendría una ventaja: cualquiera que entre al repo (incluida tu propia yo del futuro) vería de un vistazo, en la pestaña Releases, la línea de tiempo completa de versiones publicadas, sin tener que abrir y leer un archivo markdown completo.\n\nSi en algún momento quisieras formalizar esto, el proceso sería: git tag -a v1.6 -m "Buscador global + indicadores de aprendizaje" seguido de git push origin v1.6, y después crear el release desde la interfaz de GitHub, usando ese tag como base y copiando las notas relevantes de PLAN_EVOLUTIVO.md.',
  E'Un release v1.2 de esta Academy podría tener como notas exactamente el resumen de esa sección en PLAN_EVOLUTIVO.md: "Biblioteca de Conceptos completa: ficha por concepto, relaciones, lecciones/proyectos relacionados, notas personales, gestión desde /admin" — reutilizando contenido que ya escribiste, no inventando algo nuevo.',
  E'Entrá a la pestaña "Releases" de tu repo en GitHub (vas a verla vacía, como con Pull Requests) y leé la documentación de GitHub sobre cómo crear uno. No hace falta crear un release real todavía — el objetivo es reconocer dónde viviría esta información si decidieras formalizarla.',
  E'- Confundir un release con un simple commit — un release es una marca deliberada y visible, no cualquier punto del historial.\n- No incluir notas útiles en un release, dejando solo el número de versión sin contexto de qué cambió.\n- Crear releases para cada commit chico, perdiendo el sentido de que un release representa un momento significativo, no cualquier cambio.',
  E'- [ ] Puedo explicar qué es un release y en qué se diferencia de un tag simple.\n- [ ] Puedo describir qué notas incluiría un release de una de las versiones ya completadas de esta Academy.\n- [ ] Repasé la pestaña Releases de mi propio repo en GitHub.',
  10, 'Intermedio', 'Versiones: ponerle nombre a un momento del proyecto', 2, true
),
(
  '7bb9ab47-3c8d-4728-860a-05310a6b7c7e',
  '7ba150cf-35c6-4c34-ac52-8573126a050d',
  'GitHub Pages: publicar una web directo desde el repo',
  'Un servicio gratuito de GitHub para publicar sitios estáticos — útil para cierto tipo de proyectos, pero no el camino elegido para esta Academy.',
  E'- Explicar qué es GitHub Pages y qué tipo de sitios puede alojar.\n- Entender por qué esta Academy no usa GitHub Pages, sino Vercel (planeado, sin implementar aún).\n- Reconocer la diferencia entre un sitio estático y una app con backend real.',
  E'GitHub Pages es un servicio gratuito que convierte el contenido de un repositorio (o de una carpeta específica dentro de él) en un sitio web público, con su propia URL. Es ideal para sitios estáticos: HTML/CSS/JS que no necesitan ningún servidor corriendo lógica de backend — páginas de documentación, portfolios, blogs generados estáticamente.\n\nEsta Academy NO es un buen candidato para GitHub Pages, y vale la pena entender por qué: aunque el frontend (React compilado) sí podría alojarse como archivos estáticos, la app entera depende de Supabase corriendo del lado de "backend" (Auth, RLS, la base de datos) — eso no es algo que GitHub Pages resuelva ni necesite resolver, porque Supabase es un servicio externo separado al que el frontend estático simplemente se conecta.\n\nEl plan de esta Academy, documentado en GITHUB_SETUP.md, es usar Vercel en cambio — un servicio pensado específicamente para aplicaciones como esta: sirve el frontend compilado, permite configurar variables de entorno (tus claves de Supabase) de forma segura, y genera automáticamente un deploy de vista previa por cada rama o PR. GitHub Pages no ofrece esa gestión de variables de entorno de la misma forma, entre otras diferencias.',
  E'Si esta Academy fuera solo un sitio de documentación pública sobre tu proceso de aprendizaje (sin login, sin base de datos, solo texto y ejemplos estáticos), GitHub Pages sería perfecto. Pero como necesita login real, progreso guardado, y conexión a Supabase, el camino correcto es Vercel — la elección ya está documentada en este mismo proyecto, aunque el deploy real todavía no se hizo.',
  E'Entrá a Settings → Pages en tu repo de GitHub y mirá qué opciones aparecen (aunque no vayas a activarlo). Compará mentalmente con lo que ya sabés de Vercel por el documento GITHUB_SETUP.md de este proyecto.',
  E'- Intentar alojar una aplicación con backend real (como esta Academy) en GitHub Pages, sin poder resolver dónde vive la configuración de Supabase de forma segura.\n- Pensar que GitHub Pages y Vercel son intercambiables — sirven propósitos distintos, aunque ambos "publiquen sitios en internet".\n- No investigar las opciones de deploy antes de necesitarlas, dejando la decisión para un momento de apuro.',
  E'- [ ] Puedo explicar qué es GitHub Pages y qué tipo de sitios aloja bien.\n- [ ] Puedo explicar por qué esta Academy no usaría GitHub Pages.\n- [ ] Repasé la sección de Vercel en GITHUB_SETUP.md de este proyecto.',
  10, 'Intermedio', 'Releases: una versión, empaquetada y publicada', 3, true
),
(
  'c1c39c2a-3519-4328-a1a4-7f4c494ae7fa',
  '7ba150cf-35c6-4c34-ac52-8573126a050d',
  'Flujo seguro de cambios: todo lo de este módulo, en la práctica diaria',
  'Cómo se ve, junto, un flujo de trabajo prudente con Git — repasando todo lo aprendido en esta etapa como un solo hábito coherente.',
  E'- Integrar branches, commits, pull requests y versiones en un flujo de trabajo coherente.\n- Comparar el flujo real usado en esta Academy con un flujo "ideal" más formal.\n- Identificar en qué momento valdría la pena adoptar cada práctica adicional.',
  E'Esta lección cierra la Etapa 6 uniendo todo lo visto en un solo flujo de trabajo. El que ya usaste en esta Academy fue:\n\n1. Escribir código directo en main.\n2. git add -A para preparar todos los cambios.\n3. git commit -m "..." con un mensaje descriptivo.\n4. git push para sincronizar con GitHub.\n\nEste flujo es razonable y prudente para el contexto actual (una desarrolladora, avanzando en fases claramente delimitadas, cada una probada antes de seguir). Un flujo más formal, que empezarías a necesitar con más gente trabajando o con usuarias reales dependiendo de la app en producción, se vería más así:\n\n1. Crear un branch para el cambio (git checkout -b nombre-del-cambio).\n2. Hacer commits ahí, no en main.\n3. Push del branch (no de main).\n4. Abrir un pull request, revisando el diff completo.\n5. Solo después de revisar (y, en equipo, de que alguien más apruebe), hacer merge a main.\n6. Opcionalmente, marcar con un tag/release si ese merge representa una versión significativa.\n\nLa diferencia entre ambos flujos no es que uno sea "correcto" y el otro "incorrecto" — es que cada uno es apropiado para un contexto de riesgo distinto, el mismo principio de "proporcional al riesgo" que ya viste en seguridad y en arquitectura. Trabajar directo en main tiene sentido hoy; adoptar branches y PRs tendría sentido en cuanto el proyecto sume más gente, más usuarias reales, o cambios más arriesgados.',
  E'Si mañana alguien más empezara a colaborar en el código de esta Academy, el primer cambio de flujo necesario no sería aprender Git de cero — sería simplemente empezar a usar branches y pull requests para cada cambio, en vez de que las dos personas empujen commits directo a main y arriesguen pisarse el trabajo mutuamente.',
  E'Escribí, en tus propias palabras, en qué momento futuro de LillyTech (más gente, más usuarias, qué señal específica) adoptarías cada práctica que quedó pendiente en este módulo: branches, pull requests, releases formales.',
  E'- Adoptar todo el flujo formal desde el día uno para un proyecto que todavía no lo necesita, agregando fricción sin beneficio real.\n- No tener ningún plan de cuándo migrar a un flujo más seguro, quedándose en el flujo simple aunque el contexto de riesgo ya haya cambiado.\n- Pensar que "flujo seguro" significa "el más complicado posible" — significa el apropiado al riesgo real, ni más ni menos.',
  E'- [ ] Puedo describir el flujo de trabajo que ya usa esta Academy.\n- [ ] Puedo describir un flujo más formal con branches y PRs.\n- [ ] Puedo identificar la señal concreta que me haría cambiar de un flujo al otro.',
  15, 'Intermedio', 'GitHub Pages: publicar una web directo desde el repo', 4, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'a01b01ef-e6c1-4817-b51d-2f93e39124a5',
  'e806eda5-c839-454d-bc68-6b5d2807a3ce',
  'Asigná números de semver a tus versiones',
  'Repasá docs/PLAN_EVOLUTIVO.md y asigná un número semver (mayor.menor.parche) a cada versión completada hasta ahora.',
  'short_answer', 1
),
(
  '907a4971-4d2e-433f-90c3-eb842013ba8c',
  '3813ecde-51c8-4698-ba59-168c936142e2',
  'Redactá notas de un release',
  'Elegí una versión ya completada (por ejemplo v1.2) y escribí cómo se verían sus notas de release, basándote en PLAN_EVOLUTIVO.md.',
  'short_answer', 1
),
(
  '83b33e22-05f1-4bb2-b468-8a6b741d4492',
  '7bb9ab47-3c8d-4728-860a-05310a6b7c7e',
  'Compará GitHub Pages con Vercel',
  'Repasá la sección de Vercel en docs/GITHUB_SETUP.md y escribí, en tus palabras, por qué GitHub Pages no serviría para esta Academy.',
  'short_answer', 1
),
(
  'bb2bf2d1-9594-4df0-b296-820ccf4f2c06',
  'c1c39c2a-3519-4328-a1a4-7f4c494ae7fa',
  'Identificá tu señal de cambio de flujo',
  'Escribí qué señal concreta (más gente, más usuarias, qué tipo de cambio) te haría pasar del flujo actual a uno con branches y pull requests.',
  'long_answer', 1
);
