-- 0013_seed_frontend_modulo1.sql
-- Módulo 1 de la Etapa 5 (Desarrollo frontend): "Fundamentos web".

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '34944dee-fbf3-4d06-a0f7-75596f519dd9', id, 'Fundamentos web', 'HTML, CSS, JavaScript y TypeScript — las cuatro capas que, juntas, arman cualquier interfaz web, incluida esta misma Academy.', 1, true
from public.courses where title = 'React aplicado a proyectos LillyTech';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'b6838cd3-4362-4ad1-b43e-bfdf86763e30',
  '34944dee-fbf3-4d06-a0f7-75596f519dd9',
  'HTML: la estructura de una página',
  'El esqueleto de cualquier página web — qué es un título, qué es un párrafo, qué es un botón, antes de que nada tenga estilo ni comportamiento.',
  E'- Explicar qué es HTML y qué responsabilidad tiene (y cuál no).\n- Leer una estructura HTML simple e identificar sus elementos.\n- Reconocer HTML "escondido" dentro del JSX de esta Academy.',
  E'HTML (HyperText Markup Language) describe la ESTRUCTURA y el SIGNIFICADO de una página — qué es un título, qué es un párrafo, qué es un botón, qué es un campo de formulario. No define colores ni tamaños (eso es CSS) ni comportamiento (eso es JavaScript) — solo qué es cada cosa.\n\n<h1>LillyTech Learning Academy</h1>\n<p>Academia personal de aprendizaje.</p>\n<button>Ingresar</button>\n\nEsta Academy no tiene archivos .html propios más allá de index.html (el punto de entrada de Vite) — pero eso no significa que no use HTML. React genera HTML real por debajo: cada vez que escribís JSX como <button className="btn-primary">Guardar</button> en un componente .tsx, React lo convierte en un elemento <button> real dentro del HTML que finalmente ve el navegador.\n\nEntender HTML importa incluso trabajando con React, porque las etiquetas correctas (button para acciones, a para navegación, label conectado a un input) son la base de la accesibilidad — un tema que se retoma más adelante en esta misma etapa.',
  E'Si abrís las herramientas de desarrollador del navegador (F12) en cualquier pantalla de esta Academy y mirás la pestaña Elements, vas a ver HTML real y completo — <div>, <button>, <input> — generado a partir de todo el JSX que escribimos en los componentes React.',
  E'Abrí esta Academy en el navegador, F12 → Elements, y buscá el botón "Iniciar sesión" en el HTML resultante. Confirmá que es una etiqueta <button> real, no un <div> disfrazado con estilos de botón.',
  E'- Usar <div onClick={...}> en vez de <button onClick={...}> para algo que es una acción — funciona visualmente, pero pierde el comportamiento y la accesibilidad que un botón real trae gratis (foco con teclado, lectores de pantalla).\n- Pensar que "no escribo HTML" porque trabajás en React — JSX se convierte en HTML real, solo con una sintaxis distinta.\n- No usar la etiqueta semánticamente correcta (usar <p> para un título, o viceversa) — afecta accesibilidad y SEO, aunque visualmente "se vea igual".',
  E'- [ ] Puedo explicar qué es HTML y qué NO define (estilo, comportamiento).\n- [ ] Puedo encontrar el HTML real generado por un componente React en las herramientas de desarrollador.\n- [ ] Puedo explicar por qué usar <button> en vez de <div> para una acción clickeable importa.',
  10, 'Fundamentos', 'Separación de ambientes', 1, true
),
(
  '53561060-3113-4654-b517-6aa05c107b0b',
  '34944dee-fbf3-4d06-a0f7-75596f519dd9',
  'CSS: cómo se ve todo',
  'El lenguaje que define colores, espaciados y tipografía — y por qué esta Academy casi no escribe CSS "a mano", sino a través de Tailwind.',
  E'- Explicar qué es CSS y su relación con HTML.\n- Entender qué es una utility class y cómo Tailwind cambia la forma de escribir estilos.\n- Leer los tokens de marca (colores, fuentes) definidos para esta Academy.',
  E'CSS (Cascading Style Sheets) define CÓMO se ve el HTML: colores, tamaños, espaciados, tipografía, disposición en pantalla. Tradicionalmente se escribe en archivos .css separados, con selectores que apuntan a elementos HTML.\n\nEsta Academy usa Tailwind CSS, un enfoque distinto: en vez de escribir CSS en archivos separados, se aplican clases de utilidad directo en el HTML/JSX, cada una con un efecto chico y específico:\n\n<button className="rounded-md bg-brass px-4 py-2 text-paper">Guardar</button>\n\nrounded-md, bg-brass, px-4, py-2, text-paper son clases que Tailwind ya trae predefinidas (o que definimos nosotras en tailwind.config.js, como brass y paper, los colores de marca de LillyTech). Cada clase hace una sola cosa chica, y se combinan para lograr el estilo completo — en vez de escribir .mi-boton { background: #B08D57; padding: 8px 16px; } en un archivo CSS separado.\n\nEsta Academy define sus propios tokens de color (brass, ink, paper, sage, rust) en tailwind.config.js, así toda la app usa la misma paleta consistente sin repetir códigos de color hexadecimales por todos lados.',
  E'El archivo tailwind.config.js de esta Academy define brass: { DEFAULT: ''#B08D57'', light: ''#D8C39C'', dark: ''#8A6D3F'' } — desde ahí, cualquier componente puede usar bg-brass o text-brass-dark sin que nadie tenga que recordar el código hexadecimal exacto cada vez.',
  E'Abrí src/pages/DashboardPage.tsx y contá cuántas className aparecen. Elegí una y probá identificar qué hace cada clase individual dentro de ese string (por ejemplo, mb-6 text-sm text-ink-soft).',
  E'- Pensar que Tailwind "no es CSS de verdad" — sí lo es, solo que aplicado como combinación de clases en vez de reglas en un archivo separado.\n- Usar colores hexadecimales sueltos (bg-[#B08D57]) en vez de los tokens de marca ya definidos (bg-brass) — rompe la consistencia visual del proyecto.\n- No aprovechar que Tailwind ya trae responsive y estados (hover, focus) como parte de las mismas clases, reinventando eso con CSS custom innecesario.',
  E'- [ ] Puedo explicar qué es CSS y qué responsabilidad tiene.\n- [ ] Puedo leer una clase de Tailwind y explicar qué hace.\n- [ ] Puedo encontrar los tokens de color de marca definidos en tailwind.config.js.',
  15, 'Fundamentos', 'HTML: la estructura de una página', 2, true
),
(
  '20f87546-4645-497b-b109-0f464cdc24d0',
  '34944dee-fbf3-4d06-a0f7-75596f519dd9',
  'JavaScript: cómo se comporta todo',
  'El lenguaje que hace que las cosas reaccionen — un clic, una respuesta que llega, un dato que cambia. Sin JavaScript, HTML y CSS solo describen una foto fija.',
  E'- Explicar qué responsabilidad tiene JavaScript frente a HTML y CSS.\n- Leer una función simple de JavaScript y explicar qué hace.\n- Identificar JavaScript "puro" dentro de un componente React de esta Academy.',
  E'Si HTML es la estructura y CSS es la apariencia, JavaScript es el COMPORTAMIENTO: qué pasa cuando hacés clic, cómo reacciona la página a datos que cambian, qué validaciones se corren antes de enviar un formulario.\n\nfunction formatStudiedTime(minutes) {\n  if (minutes < 60) return minutes + " min";\n  const hours = Math.floor(minutes / 60);\n  return hours + " h";\n}\n\nEsta es, literalmente, una función real de esta Academy (en DashboardPage.tsx, aunque con tipos de TypeScript agregados — la próxima lección). Toma un número de minutos y devuelve un texto formateado — es JavaScript puro, sin nada de React todavía: no hay JSX, no hay componentes, es solo lógica.\n\nReact usa JavaScript para todo lo que no es puramente visual: los handlers de eventos (onClick={handleSubmit}), la lógica de qué mostrar según el estado (if (loading) return <p>Cargando...</p>), las llamadas a servicios (await getLesson(lessonId)). Todo eso es JavaScript (o TypeScript, que es JavaScript con tipos), corriendo dentro de componentes React.',
  E'La función setLessonStatus() del servicio progress.service.ts de esta Academy es JavaScript/TypeScript puro — no tiene nada de React ni de JSX, solo lógica: decide si hace un INSERT o un UPDATE según si ya existía progreso previo, y llama a Supabase.',
  E'Buscá la función formatStudiedTime en src/pages/DashboardPage.tsx y explicá, línea por línea, qué hace cada parte (el if, el Math.floor, el operador ternario si lo hay).',
  E'- Pensar que "todo lo que no es HTML/CSS" en un componente React es "React" — mucho de eso es JavaScript puro, React solo orquesta cuándo se ejecuta.\n- No distinguir entre lógica que pertenece a un componente visual y lógica que debería vivir en un servicio separado (esta Academy ya separa esto: componentes en pages/, lógica de datos en services/).\n- Escribir funciones muy largas que mezclan demasiadas responsabilidades, en vez de dividirlas en piezas más chicas y con un solo propósito cada una.',
  E'- [ ] Puedo explicar qué responsabilidad tiene JavaScript frente a HTML y CSS.\n- [ ] Puedo leer una función simple y explicar qué hace, paso a paso.\n- [ ] Puedo distinguir JavaScript puro de JSX dentro de un componente React.',
  15, 'Fundamentos', 'CSS: cómo se ve todo', 3, true
),
(
  'b33507d5-7e3e-45a7-8f23-e9a27e723072',
  '34944dee-fbf3-4d06-a0f7-75596f519dd9',
  'TypeScript: JavaScript con reglas explícitas',
  'La capa que le agrega tipos a JavaScript — y por qué esta Academy la eligió desde el día uno, en vez de JavaScript simple.',
  E'- Explicar qué le agrega TypeScript a JavaScript.\n- Leer una interface o type de esta Academy y explicar qué describe.\n- Reconocer un error que TypeScript detecta antes de que el código llegue a correr.',
  E'TypeScript es JavaScript con un sistema de tipos agregado: le decís explícitamente qué forma tiene cada dato (¿es texto? ¿un número? ¿un objeto con ciertas propiedades específicas?), y el compilador de TypeScript revisa, antes de que el código corra, si estás usando esos datos de forma consistente con lo que declaraste.\n\nexport interface Lesson {\n  id: string\n  title: string\n  is_published: boolean\n  estimated_minutes: number | null\n}\n\nEsta interface (de src/types/database.types.ts en esta Academy) describe exactamente qué forma tiene una lección. Si en algún componente escribís lesson.titel (con error de tipeo), TypeScript lo marca como error ANTES de que ejecutes nada — en JavaScript simple, ese error recién aparecería en producción, cuando alguien viera undefined en pantalla sin entender por qué.\n\nEsta Academy usa TypeScript en todo el frontend (todos los archivos son .ts o .tsx, no .js/.jsx) precisamente por esto: con un modelo de datos de 18+ tablas, la posibilidad de escribir mal el nombre de un campo o pasar un tipo incorrecto es alta — TypeScript atrapa esos errores mientras escribís código, no cuando ya está corriendo para una usuaria real.',
  E'Cuando armamos el tipo Lesson con estimated_minutes: number | null, eso obliga a que cualquier componente que use ese campo maneje explícitamente el caso en que sea null (por ejemplo, con estimated_minutes ?? 0) — TypeScript no te deja "olvidarte" de ese caso, a diferencia de JavaScript puro.',
  E'Abrí src/types/database.types.ts y elegí una interface (por ejemplo PracticalProject). Contá cuántos campos son obligatorios (sin | null) versus opcionales, y pensá por qué cada uno tiene esa forma.',
  E'- Usar any en TypeScript "para que compile más rápido" — eso desactiva justamente la protección que TypeScript ofrece, dejando ese dato sin ningún chequeo.\n- Pensar que TypeScript "es un lenguaje distinto" en vez de JavaScript con una capa extra — todo el JavaScript válido también es válido dentro de un archivo TypeScript.\n- No actualizar los tipos cuando cambia el modelo de datos real (por ejemplo, agregar una columna en una migración sin reflejarla en database.types.ts) — genera una desincronización silenciosa entre lo que la base de datos realmente tiene y lo que el código "cree" que tiene.',
  E'- [ ] Puedo explicar qué le agrega TypeScript a JavaScript.\n- [ ] Puedo leer una interface de esta Academy y explicar qué describe.\n- [ ] Puedo dar un ejemplo de un error que TypeScript atraparía antes de ejecutar el código.',
  15, 'Fundamentos', 'JavaScript: cómo se comporta todo', 4, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  '43d678e5-9d28-40ee-a0c2-4091b07f1bea',
  'b6838cd3-4362-4ad1-b43e-bfdf86763e30',
  'Encontrá el HTML real de un botón',
  'Con F12 abierto, inspeccioná el botón "Iniciar sesión" de esta Academy y confirmá qué etiqueta HTML es realmente.',
  'evidence_link', 1
),
(
  '0a2d2e4e-a35b-49bf-9824-2be546e3d501',
  '53561060-3113-4654-b517-6aa05c107b0b',
  'Desglosá una clase de Tailwind',
  'Elegí un className de varias palabras de cualquier componente de esta Academy y explicá qué hace cada clase individual dentro de ese string.',
  'short_answer', 1
),
(
  '854d982a-77c2-40ce-b1ff-3f84748a0bc9',
  '20f87546-4645-497b-b109-0f464cdc24d0',
  'Explicá una función real línea por línea',
  'Tomá formatStudiedTime de DashboardPage.tsx y explicá, en tus palabras, qué hace cada línea.',
  'short_answer', 1
),
(
  '64c75c94-d7dd-4f39-954b-1d98a17506a5',
  'b33507d5-7e3e-45a7-8f23-e9a27e723072',
  'Contá campos obligatorios vs opcionales',
  'Elegí una interface de database.types.ts y contá cuántos campos son obligatorios versus opcionales (con | null). Explicá por qué cada uno tiene esa forma.',
  'short_answer', 1
);
