-- 0014_seed_frontend_modulo2.sql
-- Módulo 2 de la Etapa 5 (Desarrollo frontend): "React en la práctica".

insert into public.modules (id, course_id, title, description, order_index, is_published)
select '649672a7-a233-418f-bcac-b84d5b613638', id, 'React en la práctica', 'React, componentes y formularios — cómo se organiza realmente el código de esta Academy.', 2, true
from public.courses where title = 'React aplicado a proyectos LillyTech';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '5c400301-7102-4898-926d-71c77241a8f8',
  '649672a7-a233-418f-bcac-b84d5b613638',
  'React: interfaces que reaccionan a los datos',
  'La idea central de React — describir cómo se ve la interfaz SEGÚN los datos actuales, en vez de ir modificando la pantalla paso a paso a mano.',
  E'- Explicar la idea central de React: describir la interfaz en función del estado.\n- Entender qué significa que un componente "se vuelve a renderizar".\n- Leer un componente simple de esta Academy e identificar qué datos determinan lo que muestra.',
  E'Antes de librerías como React, actualizar una interfaz cuando cambiaban los datos significaba escribir código que buscaba manualmente el elemento en la página y lo modificaba paso a paso ("agregá esta fila a la tabla", "cambiá el texto de este botón"). React propone otra idea: vos describís CÓMO SE VE la interfaz en función de los datos actuales, y React se encarga de descubrir qué cambió en la pantalla real y actualizar solo eso.\n\nfunction StatusBadge({ status }) {\n  if (status === ''completed'') return <span className="text-sage">Completada</span>\n  return <span className="text-ink-soft">Sin empezar</span>\n}\n\nEste componente (simplificado, de esta Academy) no "cambia" nada manualmente — simplemente describe qué mostrar según el valor de status. Si status cambia, React vuelve a ejecutar esta función y actualiza la pantalla para que coincida con el nuevo resultado — a esto se le llama "re-renderizar".\n\nEsta idea (interfaz como función de los datos) es la que hace que trabajar con datos que cambian todo el tiempo, como el progreso de estudio en esta Academy, sea manejable: nunca escribís código para "actualizar el número de lecciones completadas en pantalla" — simplemente actualizás el dato real, y la interfaz se re-renderiza sola reflejando el nuevo valor.',
  E'Cuando marcás una lección como completada en esta Academy, el componente LessonPage no tiene ningún código que diga "cambiá el texto del badge a Completada" — solo actualiza el estado local (setStatus(''completed'')), y React re-renderiza el componente StatusPill con el nuevo valor, mostrando automáticamente el texto y color correctos.',
  E'Abrí src/pages/LessonPage.tsx y encontrá la función StatusPill al final del archivo — leé el mapeo de estados a etiquetas y confirmá que no hay ningún código que "busque y cambie" elementos de la pantalla, solo una función que describe qué mostrar según el status recibido.',
  E'- Intentar modificar el HTML directamente con JavaScript "a la vieja usanza" (document.getElementById) dentro de un componente React, en vez de dejar que el estado y el re-render se encarguen.\n- No entender por qué un componente "se actualiza solo" cuando cambia su estado — parece magia si no se conoce la idea central de React.\n- Pensar que cada cambio de estado recarga la página entera — React solo actualiza las partes que realmente cambiaron, no la página completa.',
  E'- [ ] Puedo explicar la idea central de React con mis propias palabras.\n- [ ] Puedo explicar qué significa "re-renderizar" un componente.\n- [ ] Puedo leer StatusPill en LessonPage.tsx y explicar qué determina lo que muestra.',
  15, 'Intermedio', 'TypeScript: JavaScript con reglas explícitas', 1, true
),
(
  'd0e91aa7-243b-4d1b-913a-1ced451ba0f8',
  '649672a7-a233-418f-bcac-b84d5b613638',
  'Componentes: piezas reutilizables de interfaz',
  'Cómo React organiza la interfaz en piezas chicas y con nombre — y por qué esta Academy separa páginas, layouts y (todavía poco) componentes reutilizables.',
  E'- Explicar qué es un componente de React.\n- Distinguir páginas, layouts y componentes reutilizables en la estructura de esta Academy.\n- Identificar props (las "entradas" de un componente) en un ejemplo real.',
  E'Un componente de React es una función que devuelve JSX — una pieza de interfaz con nombre propio, que podés reutilizar en distintos lugares pasándole datos distintos cada vez (llamados "props").\n\nEsta Academy organiza sus componentes en tres carpetas con propósitos distintos:\n\n- src/pages/: una página completa por pantalla (DashboardPage, LibraryPage, LessonPage) — cada una es un componente, pero pensado para usarse una sola vez, en una ruta específica.\n- src/layouts/: estructura que envuelve a varias páginas (AppLayout con el sidebar, AuthLayout para login/registro) — se reutiliza, pero para "enmarcar" contenido, no como pieza chica.\n- src/components/: hoy casi vacía en esta Academy — sería el lugar para piezas realmente reutilizables entre páginas distintas, como un componente de badge de estado que hoy vive duplicado dentro de LibraryPage.tsx y LessonPage.tsx (StatusBadge y StatusPill, con lógica parecida pero no compartida).\n\nUn componente recibe props (propiedades) como parámetros: function StatusPill({ status }) recibe status como prop, y decide qué mostrar según ese valor — la misma función podría usarse para cualquier lección, con cualquier estado, sin duplicar código.',
  E'Si extrajéramos StatusBadge y StatusPill de esta Academy a un solo componente reutilizable en src/components/, ambas páginas (Biblioteca y Lección) podrían importarlo y usarlo con la misma prop status, en vez de mantener dos versiones parecidas pero separadas del mismo concepto visual — una mejora pendiente real de este proyecto.',
  E'Compará StatusBadge (en LibraryPage.tsx) con StatusPill (en LessonPage.tsx) — son casi lo mismo, con nombres y estilos ligeramente distintos. Escribí cómo se vería un único componente combinado que sirviera para ambos casos.',
  E'- Duplicar la misma lógica visual en varios componentes en vez de extraerla a uno reutilizable (justo lo que le pasa a esta Academy con los badges de estado).\n- Confundir "página" con "componente" — toda página ES un componente, pero no todo componente es una página completa.\n- No pasar la información necesaria como props, y en cambio hacer que un componente "adivine" datos que debería recibir explícitamente de quien lo usa.',
  E'- [ ] Puedo explicar qué es un componente de React.\n- [ ] Puedo explicar la diferencia entre pages/, layouts/ y components/ en esta Academy.\n- [ ] Identifiqué un caso real de duplicación que podría resolverse con un componente compartido.',
  15, 'Intermedio', 'React: interfaces que reaccionan a los datos', 2, true
),
(
  'f14016ee-7d45-4e65-936e-903f3e39cfa5',
  '649672a7-a233-418f-bcac-b84d5b613638',
  'Formularios: capturar lo que la usuaria escribe',
  'Cómo React conecta un campo de texto en pantalla con una variable de estado — y por qué cada input de esta Academy "sabe" su propio valor en todo momento.',
  E'- Explicar el patrón de "input controlado" en React.\n- Leer un formulario simple de esta Academy y trazar cómo el valor escrito llega al estado.\n- Reconocer qué pasa al enviar un formulario (submit) y cómo se evita el comportamiento por defecto del navegador.',
  E'En React, el patrón estándar para formularios es el "input controlado": el valor de cada campo vive en el estado del componente (useState), y el campo se actualiza SOLO cuando ese estado cambia — nunca al revés.\n\nconst [email, setEmail] = useState('''')\n\n<input\n  value={email}\n  onChange={(e) => setEmail(e.target.value)}\n/>\n\nEsto significa que el campo de email en LoginPage.tsx de esta Academy no "tiene su propio valor" de forma independiente — su valor ES el estado email, y cada tecla que escribís dispara onChange, que actualiza ese estado, que a su vez hace que React vuelva a renderizar el input con el nuevo valor. Parece un camino largo para algo simple, pero da control total: podés validar, transformar, o bloquear lo que se escribe, todo en un solo lugar (el handler onChange).\n\nAl enviar el formulario, el evento onSubmit recibe un objeto evento cuyo comportamiento por defecto (recargar la página completa, como hacían los formularios HTML tradicionales) hay que prevenir explícitamente con e.preventDefault() — si no, React perdería el control y el navegador recargaría todo, perdiendo el estado de la aplicación.',
  E'En src/pages/LoginPage.tsx, la función handleSubmit empieza con e.preventDefault() antes de hacer cualquier otra cosa — sin esa línea, cada intento de login recargaría la página entera, perdiendo cualquier estado de React que hubiera antes de ese momento.',
  E'Abrí LoginPage.tsx y trazá el camino completo: desde que escribís una letra en el campo de email, pasando por onChange, hasta que ese valor llega a la llamada signIn(email, password).',
  E'- Olvidar e.preventDefault() en el handler de submit, causando un recargado completo de la página en cada envío del formulario.\n- Usar un input "no controlado" (sin value y onChange conectados al estado) cuando después se necesita leer o validar ese valor desde código — genera inconsistencias difíciles de depurar.\n- No limpiar el estado del formulario después de un envío exitoso, dejando datos viejos visibles la próxima vez que se abre.',
  E'- [ ] Puedo explicar qué es un input controlado en React.\n- [ ] Puedo trazar el camino completo de un campo de LoginPage.tsx, de la tecla al estado.\n- [ ] Puedo explicar por qué hace falta e.preventDefault() en el submit.',
  15, 'Intermedio', 'Componentes: piezas reutilizables de interfaz', 3, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'a3c0f069-0698-4463-9301-e6e9a09caa14',
  '5c400301-7102-4898-926d-71c77241a8f8',
  'Leé StatusPill y explicá su lógica',
  'Encontrá la función StatusPill en LessonPage.tsx y explicá, para cada valor posible de status, qué se muestra.',
  'short_answer', 1
),
(
  '4b281a29-4b7f-4ab7-bf3b-2a62365df5cc',
  'd0e91aa7-243b-4d1b-913a-1ced451ba0f8',
  'Diseñá un componente compartido',
  'Compará StatusBadge y StatusPill, y escribí cómo se vería un componente único que sirva para ambos casos, qué props recibiría.',
  'short_answer', 1
),
(
  '365b3ea4-6e10-4627-8780-8030ff2aa1aa',
  'f14016ee-7d45-4e65-936e-903f3e39cfa5',
  'Trazá un input controlado',
  'En LoginPage.tsx, trazá el camino completo del campo de contraseña: desde que escribís una tecla hasta que el valor llega a la función signIn.',
  'short_answer', 1
);
