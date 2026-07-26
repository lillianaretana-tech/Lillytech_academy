-- 0016_seed_git_modulo1.sql
-- Módulo 1 de la Etapa 6 (Git y GitHub): "Lo básico, ya vivido en este proyecto".

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '85325857-1afc-4fcf-8f92-ba5bf70cd961', id, 'Lo básico, ya vivido en este proyecto', 'Repositorios, commits e historial — conceptos que ya usaste subiendo esta misma Academy a GitHub.', 1, true
from public.courses where title = 'Git y GitHub sin miedo';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'b63eee57-eef5-4eda-848a-754d138fab70',
  '85325857-1afc-4fcf-8f92-ba5bf70cd961',
  'Repositorios: la carpeta que recuerda todo',
  'Qué es exactamente un repositorio de Git, y por qué el que ya creaste (lillytech_academy) es mucho más que "una carpeta con código".',
  E'- Explicar qué es un repositorio de Git.\n- Distinguir el repositorio local (en tu Codespace) del remoto (en GitHub).\n- Reconocer la carpeta oculta .git que hace posible todo esto.',
  E'Un repositorio de Git es una carpeta cuyo contenido está siendo rastreado por Git — no solo el estado actual de los archivos, sino cada versión anterior de cada archivo, con quién cambió qué y cuándo.\n\nEn este proyecto real, existen dos repositorios relacionados pero distintos:\n\n- El repositorio local: la copia dentro de tu Codespace, en /workspaces/lillytech_academy. Ahí es donde escribís código y hacés commits.\n- El repositorio remoto: la copia en github.com/lillianaretana-tech/lillytech_academy. Es una copia completa del historial, alojada en los servidores de GitHub, que sirve como respaldo y como forma de compartir el proyecto.\n\ngit push es lo que sincroniza cambios del local hacia el remoto — cada vez que lo corriste, le mandaste a GitHub los commits nuevos que todavía no tenía.\n\nToda la "memoria" de un repositorio vive en una carpeta oculta llamada .git, dentro de la carpeta del proyecto. Esa carpeta contiene el historial completo — si la borraras, perderías todo el rastro de Git (aunque los archivos actuales seguirían ahí), y la carpeta dejaría de ser un repositorio.',
  E'Cuando corriste git remote add origin https://github.com/lillianaretana-tech/lillytech_academy.git al principio de este proyecto, le estabas diciendo a tu repositorio local: "tu copia remota vive en esta dirección" — sin ese paso, git push no sabría hacia dónde mandar los cambios.',
  E'En tu Codespace, corré ls -la en la raíz del proyecto y confirmá que existe una carpeta .git (las carpetas que empiezan con punto no se muestran con ls solo, hace falta el -a).',
  E'- Confundir el repositorio local con el remoto — son dos copias distintas que se sincronizan, no la misma cosa.\n- Borrar accidentalmente la carpeta .git pensando que es "basura" — eso destruye todo el historial de versiones, aunque los archivos actuales sobrevivan.\n- Pensar que un repositorio es "solo los archivos" sin entender que también incluye todo su historial de cambios.',
  E'- [ ] Puedo explicar qué es un repositorio de Git.\n- [ ] Puedo explicar la diferencia entre repositorio local y remoto.\n- [ ] Confirmé la existencia de la carpeta .git en mi propio proyecto.',
  10, 'Fundamentos', 'Accesibilidad básica: que cualquiera pueda usarla', 1, true
),
(
  '1c27cdf6-2b47-4967-af63-3d3468ee77c6',
  '85325857-1afc-4fcf-8f92-ba5bf70cd961',
  'Commits: fotos con fecha y mensaje',
  'Cada vez que corriste git commit en este proyecto, quedó guardada una "foto" completa de cómo estaba el código en ese momento exacto — para siempre.',
  E'- Explicar qué es un commit y qué información guarda.\n- Escribir un mensaje de commit claro, siguiendo la convención ya usada en esta Academy.\n- Entender qué es el hash de un commit y para qué sirve.',
  E'Un commit es una "foto" (snapshot) del estado completo del proyecto en un momento específico, junto con un mensaje que explica qué cambió y por qué. Cada commit tiene un identificador único (el hash, algo como e6efa3b) que lo distingue de cualquier otro commit, en cualquier repositorio del mundo.\n\nEn este proyecto ya escribiste varios commits reales:\n\ngit commit -m "scaffold inicial + base de datos (Fases 1-3)"\ngit commit -m "feat: experiencia de estudiante conectada a Supabase (Fase 4)"\ngit commit -m "feat: panel de administracion con CRUD completo (Fase 5)"\n\nNotá la convención que usamos: un prefijo (feat:, fix:, docs:, chore:) seguido de una descripción breve de QUÉ cambió, en presente. Esto no es una regla de Git en sí — es una convención que adoptamos para que el historial se lea con sentido, no como una lista de "cambios" genéricos y sin contexto.\n\nUn commit no es lo mismo que "guardar el archivo" (Ctrl+S) — podés guardar un archivo cien veces sin hacer ningún commit. Un commit es una decisión explícita de decir "este conjunto de cambios, juntos, forman una unidad completa que quiero registrar en el historial".',
  E'El commit "chore: elimina zip que quedo commiteado por error" que hicimos juntas es un buen ejemplo de mensaje de commit: cuenta exactamente qué se hizo (eliminar un archivo) y por qué (había quedado ahí por error) — alguien que lea el historial dentro de un año entiende el motivo sin tener que preguntarte.',
  E'En tu Codespace, corré git log --oneline y contá cuántos commits reales ya tiene este proyecto. Elegí uno y explicá, sin mirar el código, solo por el mensaje, qué cambió en ese momento.',
  E'- Escribir mensajes de commit genéricos como "cambios" o "arreglos" — no aportan nada útil a quien lea el historial después (incluida tu propia yo del futuro).\n- Hacer un solo commit gigante con demasiados cambios sin relación entre sí, en vez de commits más chicos y enfocados en una sola cosa.\n- Confundir "guardar el archivo" con "hacer un commit" — son acciones completamente distintas en momentos distintos del flujo.',
  E'- [ ] Puedo explicar qué es un commit y qué información guarda.\n- [ ] Puedo escribir un mensaje de commit siguiendo la convención de esta Academy.\n- [ ] Corrí git log --oneline y revisé el historial real de este proyecto.',
  15, 'Fundamentos', 'Repositorios: la carpeta que recuerda todo', 2, true
),
(
  '3eb8ec1e-2cca-4f17-a754-c4cc9e17b0fa',
  '85325857-1afc-4fcf-8f92-ba5bf70cd961',
  'Historial: leer el pasado completo de un proyecto',
  'Cómo consultar, ordenar y entender la secuencia completa de commits de este proyecto — la misma información que ya viste pasar por la terminal cada vez que hiciste push.',
  E'- Usar git log para revisar el historial de commits.\n- Leer la salida de un git push y entender qué información muestra.\n- Explicar por qué el historial de Git es más confiable que "acordarse" de qué cambió.',
  E'El historial de un repositorio es la secuencia completa y ordenada de todos sus commits, desde el primero hasta el más reciente. git log --oneline te muestra una versión resumida (un hash corto y el mensaje de cada commit); git log sin flags muestra el detalle completo (autor, fecha, mensaje completo).\n\nCada vez que hiciste git push en este proyecto, la terminal te mostró información real del historial sincronizándose: "Enumerating objects", "Counting objects", y al final una línea como e6efa3b..3a90d28 main -> main — eso significa "el historial remoto avanzó desde el commit e6efa3b hasta el 3a90d28", literalmente mostrándote el tramo de historial que se acaba de sincronizar.\n\n¿Por qué importa tener este historial en vez de simplemente confiar en la memoria? Porque un proyecto que va a acompañarte "durante los próximos años" (como pediste para esta Academy) va a acumular cientos de cambios — ningún ser humano recuerda con precisión qué cambió hace ocho meses y por qué. El historial de Git es la fuente de verdad objetiva, siempre disponible, que no depende de la memoria de nadie.',
  E'Si dentro de un año te preguntás "¿cuándo agregamos la Biblioteca de Conceptos?", no hace falta que lo recuerdes — git log te muestra el commit exacto ("feat: v1.2 - Biblioteca de Conceptos completa"), con fecha, y podés ver exactamente qué archivos cambiaron ese día.',
  E'Corré git log --oneline en tu proyecto y contá cuántos commits llevás hasta ahora. Elegí el más antiguo y el más reciente, y describí en una frase la diferencia entre el estado del proyecto en esos dos momentos.',
  E'- Depender de la memoria ("creo que fue hace un par de semanas") en vez de consultar el historial real con git log.\n- No leer la salida de git push, perdiéndose información útil sobre qué se sincronizó exactamente.\n- Pensar que el historial de Git es "solo para casos de emergencia" — es una herramienta de consulta cotidiana, no solo de rescate.',
  E'- [ ] Puedo usar git log --oneline para ver el historial resumido.\n- [ ] Puedo leer la salida de un git push y explicar qué significa cada línea.\n- [ ] Puedo explicar por qué el historial de Git es más confiable que la memoria humana para un proyecto de años.',
  10, 'Fundamentos', 'Commits: fotos con fecha y mensaje', 3, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  '9d365401-ed0b-4cf2-bccc-ae59db4a7a4a',
  'b63eee57-eef5-4eda-848a-754d138fab70',
  'Confirmá la carpeta .git',
  'Corré ls -la en la raíz de tu proyecto y confirmá que existe la carpeta .git. Anotá qué otras carpetas ocultas ves.',
  'checklist', 1
),
(
  '10827483-88f6-418f-9ef4-6703b82e6a53',
  '1c27cdf6-2b47-4967-af63-3d3468ee77c6',
  'Escribí un mensaje de commit para un cambio hipotético',
  'Imaginá que acabás de agregar una nueva lección de contenido. Escribí el mensaje de commit que usarías, siguiendo la convención de esta Academy.',
  'short_answer', 1
),
(
  '0de0cb08-48eb-489e-aa92-9fb33c2eefe2',
  '3eb8ec1e-2cca-4f17-a754-c4cc9e17b0fa',
  'Explorá tu propio historial',
  'Corré git log --oneline en tu proyecto real. Contá los commits y describí, en una frase, qué cambió entre el primero y el más reciente.',
  'evidence_link', 1
);
