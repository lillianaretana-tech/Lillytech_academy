-- 0027_seed_devops_etapa11_completa.sql
-- Etapa 11 completa (DevOps básico) — CIERRA TODA LA RUTA "Desarrollo de
-- Aplicaciones LillyTech". 3 módulos, 7 lecciones nuevas (4 subtemas de
-- los 11 originales ya están cubiertos en Etapas 3 y 5, enlazados al final).

-- ============ MÓDULO 1: Preparar el código para producción ============

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '1bd6eb0e-2e4a-4262-a614-36610cc6532f', id, 'Preparar el código para producción', 'Entornos y builds — lo que separa "corre en mi Codespace" de "corre para cualquiera, en cualquier lado".', 1, true
from public.courses where title = 'Desplegar y mantener sin sustos';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'b916b3f2-a610-41aa-b253-35b76ebfdc9a',
  '1bd6eb0e-2e4a-4262-a614-36610cc6532f',
  'Entornos: desarrollo, y lo que vendría después',
  'Repaso del concepto ya visto (stage vs producción, Etapa 3), esta vez con foco en el entorno de DESARROLLO específicamente — el Codespace donde escribís código.',
  E'- Distinguir entorno de desarrollo de entorno de producción.\n- Explicar qué hace que el Codespace de esta Academy sea un entorno de desarrollo.\n- Reconocer qué cambia (y qué no) cuando el código pasa de desarrollo a producción.',
  E'Ya viste en la Etapa 3 la idea de separar stage de producción a nivel de base de datos. Esta lección la aplica al entorno de EJECUCIÓN del código: tu Codespace, corriendo npm run dev, es un entorno de DESARROLLO — pensado para escribir y probar código rápido, con recarga automática en cada cambio, mensajes de error detallados, y sin optimizaciones de rendimiento.\n\nUn entorno de PRODUCCIÓN es distinto: el código compilado, optimizado para velocidad, con mensajes de error más genéricos hacia la usuaria final (por seguridad), y accesible por una URL pública real, no solo por vos en tu Codespace.\n\nEsta Academy hoy solo tiene entorno de desarrollo — todavía no se hizo ningún deploy a producción. Cuando eso pase, vas a notar la diferencia: la misma base de código, corriendo de forma distinta según el entorno.',
  E'Cuando corrés npm run dev en tu Codespace, Vite reconstruye y recarga la página automáticamente cada vez que guardás un cambio — una comodidad de desarrollo que no tendría sentido en producción, donde el código ya está fijo hasta el próximo deploy.',
  E'Repasá qué le pasaría a un mensaje de error real de esta Academy si estuviera en producción — ¿debería mostrar el mismo detalle técnico, o algo más genérico?',
  E'- Confundir "funciona en mi Codespace" con "está listo para producción".\n- Dejar comportamientos de desarrollo expuestos en producción, revelando información sensible.\n- No probar nunca el build de producción antes de desplegarlo.',
  E'- [ ] Puedo explicar la diferencia entre entorno de desarrollo y de producción.\n- [ ] Puedo explicar por qué el Codespace de esta Academy es un entorno de desarrollo.\n- [ ] Identifiqué algo que debería comportarse distinto en producción.',
  10, 'Intermedio', 'Reflexión final de la etapa (Gestión de productos)', 1, true
),
(
  '1a7c5649-d24c-4874-9978-3584f1a92955',
  '1bd6eb0e-2e4a-4262-a614-36610cc6532f',
  'Builds: convertir código fuente en algo que corre rápido',
  'El paso que transforma tus archivos .tsx en algo optimizado que un navegador puede cargar rápido — ya lo usaste sin verlo, cada vez que corriste npm run dev.',
  E'- Explicar qué es un build y qué transformaciones típicas incluye.\n- Distinguir el modo desarrollo del build de producción.\n- Ejecutar el build de producción de esta Academy y revisar su resultado.',
  E'Un build transforma el código fuente en archivos finales optimizados: JavaScript minificado, CSS combinado, TypeScript convertido a JavaScript plano.\n\nCuando corrés npm run dev, Vite NO hace un build completo — usa un modo de desarrollo que sirve archivos casi sin transformar, priorizando velocidad de recarga. El build real de producción se genera con npm run build, que en esta Academy ya está definido en package.json: primero corre tsc -b (verifica tipos, fallando si hay errores) y después vite build (genera los archivos finales en dist/).\n\nEste paso de verificación de tipos ANTES del build evita que algo roto llegue a producción — una protección automática ya configurada en este proyecto, aunque nunca la hayas ejecutado todavía.',
  E'El script "build": "tsc -b && vite build" de esta Academy significa: primero verificar tipos, y solo si eso pasa, generar el build real — si cualquier archivo tuviera un error de tipos, el build entero se detendría ahí.',
  E'En tu Codespace, corré npm run build y observá la salida — debería completar sin errores y crear una carpeta dist/.',
  E'- Pensar que dev y build de producción generan lo mismo.\n- No correr nunca el build antes de un deploy real.\n- Confundir un error de build con un error de runtime.',
  E'- [ ] Puedo explicar qué transformaciones típicas hace un build.\n- [ ] Puedo explicar la diferencia entre el modo dev y el build de producción.\n- [ ] Corrí npm run build y confirmé que termina sin errores.',
  15, 'Intermedio', 'Entornos: desarrollo, y lo que vendría después', 2, true
);

-- ============ MÓDULO 2: Publicar de verdad ============

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '3b8a2abb-f827-4baa-b60c-86d926f584f8', id, 'Publicar de verdad', 'Deploy y Vercel — el paso pendiente de este proyecto: que la app tenga una URL pública, sin depender del Codespace.', 2, true
from public.courses where title = 'Desplegar y mantener sin sustos';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '2578febb-2a05-4f94-9295-e50d05195dc1',
  '3b8a2abb-f827-4baa-b60c-86d926f584f8',
  'Deploy: publicar el build en algún lugar accesible',
  'El acto de tomar los archivos ya construidos y ponerlos en un servidor real, con una URL pública — el paso que esta Academy todavía tiene pendiente.',
  E'- Explicar qué es un deploy y qué necesita para funcionar.\n- Repasar por qué la URL del Codespace no es un deploy real.\n- Identificar qué le falta a esta Academy para tener un deploy real.',
  E'Deploy es tomar el resultado de un build y ponerlo en un servidor accesible públicamente, con una URL fija — a diferencia de correr npm run dev localmente, que solo funciona mientras tu Codespace esté activo.\n\nLa URL tipo solid-acorn-....app.github.dev que usaste durante este proyecto NO es un deploy real: es un túnel temporal hacia tu Codespace, que deja de funcionar apenas se pausa. Un deploy real vive independientemente de que tengas o no el Codespace abierto.\n\nEsta Academy no tiene todavía ningún deploy real. El documento GITHUB_SETUP.md ya identificó el camino (Vercel, próxima lección), pero ese paso sigue pendiente de ejecutarse.',
  E'Si mañana quisieras mostrarle esta Academy a alguien sin abrir tu Codespace, necesitarías un deploy real — una URL fija, siempre disponible, sin depender de una sesión activa tuya.',
  E'Repasá la sección de Vercel en docs/GITHUB_SETUP.md — releé los pasos exactos documentados para el primer deploy real.',
  E'- Confundir la URL temporal del Codespace con un deploy real.\n- Posponer indefinidamente el primer deploy sin razón concreta.\n- No entender qué necesita un deploy antes de intentarlo.',
  E'- [ ] Puedo explicar qué es un deploy y qué lo diferencia de correr localmente.\n- [ ] Puedo explicar por qué la URL del Codespace no es un deploy real.\n- [ ] Releí la sección de Vercel en GITHUB_SETUP.md.',
  15, 'Intermedio', 'Builds: convertir código fuente en algo que corre rápido', 1, true
),
(
  'd1b9042a-c0e6-48bc-b32f-dac675e347bf',
  '3b8a2abb-f827-4baa-b60c-86d926f584f8',
  'Vercel: el camino elegido para esta Academy',
  'Por qué Vercel específicamente, y qué pasaría paso a paso el día que hagas el primer deploy real de este proyecto.',
  E'- Repasar por qué se eligió Vercel para esta Academy.\n- Describir el proceso completo de conectar este repo a Vercel.\n- Identificar qué variables de entorno habría que configurar ahí.',
  E'Ya se mencionó en la Etapa 6 por qué Vercel y no GitHub Pages: esta Academy necesita variables de entorno y un frontend que se conecta a un backend externo.\n\nEl proceso, documentado en GITHUB_SETUP.md: entrar a vercel.com, "Add New Project", importar el repositorio desde GitHub, elegir "Vite" como framework preset, y configurar VITE_SUPABASE_URL y VITE_SUPABASE_ANON_KEY con los mismos valores del .env local — guardadas de forma segura del lado de Vercel, no en un archivo que viaja con el código.\n\nUna vez conectado, cada git push a main dispararía automáticamente un nuevo deploy de producción — la pieza de "integración continua" (próximo módulo) aplicada al deploy.',
  E'Cuando conectes esta Academy a Vercel, vas a pegar exactamente los mismos valores que hoy tenés en tu .env local — pero en el panel de configuración de Vercel, no en un archivo que se sube a ningún lado.',
  E'Sin hacerlo todavía, escribí los pasos exactos, en orden, que seguirías para conectar este repo a Vercel, basándote en GITHUB_SETUP.md.',
  E'- Subir las claves de Supabase al código en vez de configurarlas en Vercel.\n- Elegir un framework preset incorrecto.\n- No verificar que el build funciona localmente antes del primer deploy.',
  E'- [ ] Puedo explicar por qué se eligió Vercel para esta Academy.\n- [ ] Puedo describir el proceso completo de conexión.\n- [ ] Sé qué 2 variables de entorno configurar en Vercel.',
  15, 'Intermedio', 'Deploy: publicar el build en algún lugar accesible', 2, true
);

-- ============ MÓDULO 3: Mantenerlo vivo ============

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '716ee233-90ee-4538-855d-ad16cc57e5e0', id, 'Mantenerlo vivo', 'Monitoreo, rollback e integración continua — cierra la Etapa 11 y toda la ruta completa de esta Academy.', 3, true
from public.courses where title = 'Desplegar y mantener sin sustos';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '4e9d4f10-e839-473f-94a3-c405da18ae7d',
  '716ee233-90ee-4538-855d-ad16cc57e5e0',
  'Monitoreo: saber que algo anda mal antes de que te lo digan',
  'La diferencia entre enterarte de un problema porque lo notás vos misma, y enterarte porque el sistema te avisó — relacionado con Logs, ya visto en la Etapa 3.',
  E'- Explicar qué es monitoreo y en qué se diferencia de revisar logs manualmente.\n- Reconocer qué nivel de monitoreo tiene sentido para esta Academy hoy.\n- Identificar qué señal futura justificaría invertir en monitoreo más activo.',
  E'Ya viste, en la Etapa 3, cómo revisar los Logs de Supabase cuando algo falla — eso es diagnóstico REACTIVO. Monitoreo es más proactivo: sistemas que observan métricas constantemente y te AVISAN cuando algo se sale de lo esperado.\n\nEjemplos: alertas cuando la tasa de errores sube, notificaciones cuando un servicio deja de responder. Vercel, una vez que exista deploy real, ofrece monitoreo básico incluido sin configuración adicional.\n\nPara esta Academy, con una sola usuaria, un monitoreo exhaustivo sería sobreingeniería — mismo criterio de "proporcional al riesgo" ya visto en Seguridad y Arquitectura. La señal que justificaría más monitoreo: más gente dependiendo de la disponibilidad de la app.',
  E'Si Safety Academy tuviera clientes reales dependiendo de capacitaciones obligatorias, un monitoreo activo dejaría de ser opcional — el costo de no enterarte a tiempo sería mucho mayor que en un proyecto personal.',
  E'Pensá qué pasaría hoy si esta Academy dejara de funcionar por un día sin que nadie te avisara — ¿cuánto tardarías en notarlo vos misma?',
  E'- Invertir en monitoreo complejo antes de necesitarlo.\n- No monitorear nada cuando el riesgo real ya lo justificaría.\n- Confundir monitoreo con logs — los logs son historial reactivo; el monitoreo avisa antes.',
  E'- [ ] Puedo explicar la diferencia entre revisar logs y monitoreo activo.\n- [ ] Puedo justificar por qué esta Academy no necesita monitoreo exhaustivo hoy.\n- [ ] Identifiqué la señal futura que justificaría más monitoreo.',
  10, 'Intermedio', 'Vercel: el camino elegido para esta Academy', 1, true
),
(
  '143305c2-d32c-4fbd-9719-eba2f873fefd',
  '716ee233-90ee-4538-855d-ad16cc57e5e0',
  'Rollback: volver a la versión anterior cuando algo se rompe',
  'Qué hacer cuando un deploy nuevo rompe algo que antes funcionaba — relacionado con git revert (Etapa 6), esta vez aplicado al despliegue completo.',
  E'- Explicar qué es un rollback y cuándo se necesita.\n- Relacionar rollback con git revert, ya visto en la Etapa 6.\n- Repasar cómo Vercel facilita el rollback una vez que exista deploy real.',
  E'Rollback es volver a una versión anterior de una aplicación desplegada, típicamente porque el deploy más reciente introdujo un problema. Es la misma idea de git revert — corregir hacia adelante, no reescribir el pasado — aplicada al DEPLOY completo, no solo al código fuente.\n\nUna ventaja de Vercel: cada deploy queda guardado como versión independiente, y volver a una anterior suele ser un clic en el panel — sin revertir commits ni correr un build manual. Esto separa revertir el CÓDIGO (git revert) de revertir el DEPLOY (rollback de la plataforma) — a veces alcanza con lo segundo.\n\nHoy, sin deploy real, esta Academy no tiene rollback en ese sentido. Cuando exista deploy en Vercel, esta capacidad se sumaría automáticamente.',
  E'Si un futuro deploy en Vercel rompiera el login, la reacción correcta sería hacer rollback al deploy anterior desde el panel de Vercel primero, ganando tiempo para corregir con calma, en vez de apurarte bajo presión con la app rota.',
  E'Sin deploy real todavía, describí qué harías si, después de tu primer deploy, notaras que algo se rompió — ¿cuál sería tu primer paso?',
  E'- Intentar corregir un problema de deploy bajo presión en vez de hacer rollback primero.\n- Confundir revertir el código con revertir el deploy.\n- No verificar, tras un rollback, que la causa quedó identificada antes de volver a desplegar.',
  E'- [ ] Puedo explicar qué es un rollback y cuándo se necesita.\n- [ ] Puedo relacionar rollback con git revert.\n- [ ] Describí qué haría ante un problema real tras mi primer deploy.',
  10, 'Intermedio', 'Monitoreo: saber que algo anda mal antes de que te lo digan', 2, true
),
(
  'f3a07ba3-4ef6-4799-afca-0d7d76329743',
  '716ee233-90ee-4538-855d-ad16cc57e5e0',
  'Integración continua: cierre de la Etapa 11 y de toda la ruta',
  'Automatizar la verificación de que el código sigue funcionando en cada cambio — y el cierre de las 11 etapas completas de esta Academy.',
  E'- Explicar qué es integración continua (CI) y qué automatiza.\n- Repasar que Vercel ya ofrece una forma básica de CI en cada push.\n- Cerrar toda la ruta con una reflexión integradora de las 11 etapas.',
  E'Integración continua (CI) automatiza la verificación de que el código sigue funcionando en cada cambio, sin que una persona tenga que acordarse de hacerlo manualmente.\n\nEsta Academy tendría CI básica en cuanto se conecte a Vercel: cada git push dispara un build automático, y si falla, Vercel avisa antes de que ese código llegue a producción — la misma protección de tsc -b && vite build (Módulo 1), ejecutada automáticamente.\n\nUna CI más completa (con pruebas automatizadas reales) tendría sentido si esta Academy sumara la suite de tests que hoy conscientemente no tiene (Etapa 9). Hasta entonces, el build automático de Vercel ya cubre una parte real y valiosa.\n\nEsta lección cierra las 11 etapas completas de la ruta: desde bases de datos (Etapa 1) hasta este momento, cada etapa se apoyó en las anteriores — SQL necesitó bases de datos, Supabase necesitó SQL, Arquitectura conectó todo, Frontend le dio cara, Git lo versionó, Seguridad lo protegió, APIs lo conectó con el mundo, IA aceleró el proceso, Producto le dio dirección, y DevOps lo llevaría a que otra persona pudiera usarlo. El objetivo declarado desde el principio — comprender el porqué, no memorizar — se sostuvo etapa por etapa, con esta misma Academy como ejemplo consistente de principio a fin.',
  E'El primer git push que hagas después de conectar Vercel va a disparar, sin hacer nada más, exactamente el mismo build que corriste manualmente en el Módulo 1 — la diferencia es que a partir de ahí esa verificación pasa a ser automática, para siempre.',
  E'Escribí una reflexión de cierre de toda la ruta: de las 11 etapas completas, ¿cuál sentís que cambió más tu forma de pensar sobre tecnología, y por qué?',
  E'- Pensar que CI reemplaza la revisión humana de código — automatiza chequeos mecánicos, no el criterio visto en la Etapa 9.\n- No aprovechar la CI básica gratis que Vercel ya ofrece.\n- Terminar la ruta sin conectar los aprendizajes entre etapas.',
  E'- [ ] Puedo explicar qué es integración continua y qué automatiza.\n- [ ] Puedo explicar cómo Vercel ya ofrece CI básica sin configuración extra.\n- [ ] Escribí mi reflexión de cierre sobre las 11 etapas completas.',
  20, 'Intermedio', 'Rollback: volver a la versión anterior cuando algo se rompe', 3, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'e7c13f97-7950-4a88-8ba5-3a85664a8531',
  'b916b3f2-a610-41aa-b253-35b76ebfdc9a',
  'Pensá el error en producción',
  'Elegí un mensaje de error real que hayas visto en esta Academy y describí cómo debería verse distinto en producción.',
  'short_answer', 1
),
(
  '03f335dc-cc60-4f02-ba3d-807ee3f7b090',
  '1a7c5649-d24c-4874-9978-3584f1a92955',
  'Corré el build de producción',
  'Corré npm run build en tu Codespace y confirmá que termina sin errores, generando la carpeta dist/.',
  'evidence_link', 1
),
(
  'd4bd45da-7a0d-41d0-8566-2afaf9896f87',
  '2578febb-2a05-4f94-9295-e50d05195dc1',
  'Releé el plan de deploy documentado',
  'Repasá la sección de Vercel en GITHUB_SETUP.md y anotá los pasos exactos para el primer deploy real.',
  'short_answer', 1
),
(
  'cd22e5d7-f120-4304-b8c7-cf58b8d39f07',
  'd1b9042a-c0e6-48bc-b32f-dac675e347bf',
  'Escribí el proceso completo de conexión a Vercel',
  'Describí, paso a paso, cómo conectarías este repositorio a Vercel y qué variables de entorno configurarías.',
  'short_answer', 1
),
(
  'f80b1043-c690-4db5-bdc2-90493e707d7c',
  '4e9d4f10-e839-473f-94a3-c405da18ae7d',
  'Evaluá tu necesidad real de monitoreo',
  'Respondé: si esta Academy dejara de funcionar por un día, ¿cuánto tardarías en notarlo? Usá eso para justificar tu nivel actual de monitoreo.',
  'short_answer', 1
),
(
  '1a323d6a-864f-472a-b1c3-fad94be739ca',
  '143305c2-d32c-4fbd-9719-eba2f873fefd',
  'Planeá tu primera reacción ante un rollback necesario',
  'Describí qué harías, paso a paso, si notaras un problema justo después de tu primer deploy real a Vercel.',
  'short_answer', 1
),
(
  'c28600b9-36b5-4609-9b68-a12220417bd0',
  'f3a07ba3-4ef6-4799-afca-0d7d76329743',
  'Reflexión de cierre de toda la ruta',
  'Escribí tu reflexión final: de las 11 etapas completas de esta Academy, ¿cuál cambió más tu forma de pensar sobre tecnología, y por qué?',
  'long_answer', 1
);
