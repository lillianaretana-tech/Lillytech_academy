-- 0002_seed_modules_and_lessons.sql
-- Módulos del curso de la Etapa 1 y las 3 lecciones completas pedidas:
-- 1. Qué es una base de datos
-- 2. Tablas, filas y columnas
-- 3. Claves primarias

insert into public.modules (id, course_id, title, description, order_index, is_published) values
  ('561333a5-828b-4720-9b08-a3485852b7f2', 'f2deb3e7-5355-4e2d-bfcd-a63eee7cc382', 'Tablas y registros', 'La unidad básica de una base de datos relacional.', 1, true),
  ('8c01555e-480d-4953-b0af-3b06ad2fba87', 'f2deb3e7-5355-4e2d-bfcd-a63eee7cc382', 'Claves y relaciones', 'Cómo se conectan las tablas entre sí.', 2, false),
  ('64a8023c-c690-4ea8-9684-fdcc9c07160c', 'f2deb3e7-5355-4e2d-bfcd-a63eee7cc382', 'Diseño y normalización', 'Cómo diseñar una base de datos que no se vuelva un caos.', 3, false);

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  'e80d1fc0-2da1-4d99-9f76-132de0f075e3',
  '561333a5-828b-4720-9b08-a3485852b7f2',
  'Qué es una base de datos',
  'Entender qué problema resuelve una base de datos y por qué casi todas tus herramientas LillyTech dependen de una.',
  E'- Explicar con tus propias palabras qué es una base de datos.\n- Distinguir una base de datos de un archivo Excel o un Google Sheet.\n- Reconocer en qué parte de tus propios proyectos hay una base de datos trabajando.',
  E'Una base de datos es un sistema organizado para guardar información de forma que se pueda consultar, actualizar y relacionar de manera confiable, incluso cuando muchas personas o procesos la usan al mismo tiempo.\n\nLa diferencia con un archivo suelto (un Excel, un CSV, un Google Sheet) no es solo de tamaño. Es de garantías: una base de datos como PostgreSQL (la que usa Supabase) se asegura de que dos procesos no se pisen escribiendo al mismo tiempo, de que los datos respeten reglas (por ejemplo, que un empleado no pueda existir sin un nombre), y de que si algo falla a la mitad de una operación, no quede la información a medias.\n\nEn términos simples: un Excel es una hoja donde vos controlás manualmente el orden y la consistencia. Una base de datos es un sistema que controla eso por vos, con reglas explícitas.',
  E'Pensá en tu sistema de Control de vacaciones. Cada persona tiene sus días, sus fechas tomadas, su tope legal. Si eso viviera en un Excel compartido, dos personas editando a la vez podrían pisar los cambios una de la otra, o alguien podría borrar sin querer una fórmula. En Supabase (Postgres), cada cambio pasa por reglas: quién puede escribir qué, y qué datos son válidos.',
  E'En Wordyssey, cada mundo, cada progreso de Bruno, cada logro desbloqueado vive en tablas de Supabase. Cuando alguien abre la app en el teléfono y en la computadora, ve lo mismo, porque no hay "dos copias" del archivo — hay una sola fuente de verdad: la base de datos.',
  E'- Pensar que una base de datos es "solo una tabla más grande". La diferencia real está en las garantías (concurrencia, reglas, integridad), no en el tamaño.\n- Confundir la base de datos con la interfaz que la muestra. React o HTML son la ventana; la base de datos es donde vive la información real.\n- Creer que hay que saber SQL avanzado para empezar a entender el concepto. Se puede entender el "para qué" antes del "cómo".',
  E'- [ ] Puedo explicar en una frase qué es una base de datos, sin usar la palabra "base de datos" en la explicación.\n- [ ] Puedo nombrar dos diferencias concretas entre un Excel compartido y una base de datos real.\n- [ ] Puedo señalar al menos un proyecto propio (Vacaciones, Wordyssey, Inventario, etc.) y decir qué información vive en su base de datos.',
  15,
  'Fundamentos',
  null,
  1,
  true
),
(
  '7a516b13-4df4-4f05-846e-e32ab9decf0a',
  '561333a5-828b-4720-9b08-a3485852b7f2',
  'Tablas, filas y columnas',
  'La forma en que una base de datos relacional organiza la información: tablas, con filas (registros) y columnas (campos).',
  E'- Identificar tablas, filas y columnas en un caso real.\n- Entender qué es un "registro" y por qué cada fila representa una cosa concreta.\n- Reconocer tipos de datos básicos y por qué importan.',
  E'Una tabla es una lista de cosas del mismo tipo: empleados, tareas, lecciones, sitios. Cada fila (también llamada "registro") es una de esas cosas en particular — un empleado específico, una tarea específica. Cada columna es una característica que todas las filas comparten — nombre, fecha de ingreso, sitio asignado.\n\nEsto se parece mucho a una hoja de Excel: filas y columnas. La diferencia es que en una base de datos, cada columna tiene un tipo de dato definido de antemano (texto, número, fecha, verdadero/falso, etc.), y la base de datos rechaza lo que no cumple ese tipo. Si una columna es "fecha de ingreso" y alguien intenta guardar la palabra "mañana" en vez de una fecha real, la base de datos lo rechaza — no lo permite "por las dudas" como haría un Excel.\n\nEsto es lo que hace que los datos sean confiables: no dependés de que la persona que los cargó lo haya hecho bien a mano. El sistema mismo pone límites.',
  E'Pensá en la tabla `sites` (sitios) de tu sistema de Inventario multi-sitio (JLL LSEG, McKinsey, ADVANT, Bayer, CBRE, WP). Cada fila es un sitio real. Las columnas podrían ser: nombre del sitio, dirección, cliente asociado, activo/inactivo. Cada sitio nuevo que agregás es una fila nueva — no una tabla nueva.',
  E'En tu Control diario de Facilities, la tabla de tareas tiene una fila por cada tarea/compromiso registrado, y columnas como título, responsable, fecha límite, estado. Cuando marcás una tarea como completada, no estás creando nada nuevo — estás actualizando el valor de la columna "estado" en esa fila específica.',
  E'- Pensar que agregar un dato nuevo del mismo tipo requiere una tabla nueva (no — es una fila nueva en la tabla existente).\n- Mezclar información de cosas distintas en la misma tabla "para no crear otra" (por ejemplo, mezclar empleados y sitios en una sola tabla) — esto se llama falta de normalización y se ve en el Módulo 3.\n- No pensarle bien el tipo de dato a una columna desde el inicio (por ejemplo, guardar fechas como texto libre), lo cual genera errores difíciles de detectar después.',
  E'- [ ] Puedo distinguir, dado un ejemplo real, cuál es la tabla, cuál es una fila y cuál es una columna.\n- [ ] Puedo explicar por qué el tipo de dato de una columna importa, con un ejemplo de lo que pasa si no se respeta.\n- [ ] Puedo identificar en uno de mis propios sistemas (Inventario, Vacaciones, Facilities) al menos una tabla y describir sus columnas principales.',
  15,
  'Fundamentos',
  'Qué es una base de datos',
  2,
  true
),
(
  '43df9ad0-ccf7-4283-b609-d5f84753784e',
  '561333a5-828b-4720-9b08-a3485852b7f2',
  'Claves primarias',
  'Cómo identifica una base de datos, sin ambigüedad, a cada registro individual — y por qué eso es la base de todo lo demás (relaciones, actualizaciones, integridad).',
  E'- Explicar qué es una clave primaria y qué problema resuelve.\n- Entender por qué un UUID es una buena elección de clave primaria en Supabase.\n- Reconocer por qué nunca conviene usar un campo "humano" (como el nombre) como clave primaria.',
  E'Una clave primaria es la columna (o combinación de columnas) que identifica, sin ninguna ambigüedad, a una fila específica dentro de una tabla. Ninguna otra fila puede tener el mismo valor de clave primaria.\n\n¿Por qué hace falta esto? Porque los nombres se repiten, los datos cambian, y una base de datos necesita una forma 100% confiable de decir "esta fila, y no otra". Si usaras el nombre de un empleado como identificador, el día que contrates a dos personas que se llamen igual, el sistema no podría distinguirlas.\n\nEn Supabase (y en la mayoría de tus proyectos LillyTech) la convención es usar un UUID (un identificador único generado automáticamente, algo como `e80d1fc0-2da1-4d99-9f76-132de0f075e3`) como clave primaria (`id`). Tiene ventajas frente a un número que aumenta de 1 en 1: se puede generar sin depender de un servidor central, no revela cuántos registros existen, y funciona igual de bien si después conectás varios sistemas entre sí.\n\nLa clave primaria es también lo que hace posibles las relaciones entre tablas — el tema del próximo módulo: una tabla puede "apuntar" a otra guardando su clave primaria como referencia (eso se llama clave foránea).',
  E'En tu sistema de Recruitment/CV screening, cada candidato tiene un `id` (UUID) como clave primaria. Aunque dos candidatos se llamen "María Fernández", cada fila tiene un `id` distinto — el sistema nunca los confunde, sin importar cuántos "María Fernández" postulen.',
  E'En AuditPro, cada hallazgo de auditoría tiene su propio `id`. Cuando el sistema dispara una alerta por correo (vía Make) para un hallazgo urgente, usa ese `id` para señalar exactamente cuál — no el texto del hallazgo, que podría repetirse o cambiar.',
  E'- Usar como clave primaria un dato que puede cambiar (como el correo electrónico o el nombre) — si ese dato cambia, se rompen todas las relaciones que dependían de él.\n- Confundir clave primaria con "el primer campo que se me ocurre" — la clave primaria se elige por su capacidad de ser única y estable, no por conveniencia visual.\n- Pensar que un UUID "se ve feo" es un buen motivo para no usarlo — la legibilidad para humanos y la función de identificar de forma única son necesidades distintas.',
  E'- [ ] Puedo explicar con un ejemplo propio por qué el nombre de una persona no sirve como clave primaria.\n- [ ] Puedo explicar la diferencia entre un UUID y un número autoincremental como clave primaria, y cuándo preferir cada uno.\n- [ ] Puedo identificar la clave primaria en al menos una tabla de un sistema que ya construiste.',
  20,
  'Fundamentos',
  'Tablas, filas y columnas',
  3,
  true
);
