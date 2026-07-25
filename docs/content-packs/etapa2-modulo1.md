# Etapa 2 — SQL: Módulo 1 "Consultar datos con SELECT"

Contenido para pegar en el editor de lecciones (`/admin/lessons/:id`), lección por lección.

---

## LECCIÓN 1: Qué es SELECT y para qué sirve

**Título:** Qué es SELECT y para qué sirve

**Nivel:** Fundamentos
**Duración estimada (min):** 15
**Prerrequisitos:** Claves primarias

**Resumen:**
La instrucción que le pedís a la base de datos que te devuelva información — la puerta de entrada a todo lo demás en SQL.

**Objetivos:**
```
- Escribir una consulta SELECT básica sin ayuda.
- Entender la diferencia entre pedir todas las columnas y pedir columnas específicas.
- Reconocer en qué parte de tus propios proyectos se ejecutan SELECTs todo el tiempo, aunque no los veas.
```

**Explicación:**
```
SELECT es la instrucción que usás para pedirle datos a una base de datos. No cambia nada, no borra nada — solo pregunta y te devuelve una respuesta en forma de tabla.

La forma más simple es pedir todo:

SELECT * FROM empleados;

El asterisco (*) significa "todas las columnas". Esto funciona, pero en la práctica casi nunca es lo mejor: si la tabla tiene 20 columnas y solo necesitás el nombre y la fecha de ingreso, pedir todo es más lento y más difícil de leer. Por eso lo normal es nombrar las columnas que realmente necesitás:

SELECT nombre, fecha_ingreso FROM empleados;

Cada vez que tu app React llama a supabase.from('tabla').select('columna1, columna2'), por debajo se está generando una consulta SELECT como esta. No es magia — es SQL con una capa de JavaScript encima.
```

**Ejemplo:**
```
En tu Control de Asistencia, cuando la app muestra la lista de empleados de un sitio, en el fondo corre algo parecido a:

SELECT nombre, puesto, sitio_id FROM empleados WHERE sitio_id = 'valor-del-sitio';

(el WHERE lo vemos en la próxima lección — por ahora fijate que SELECT es la parte que dice "qué columnas quiero ver").
```

**Aplicación práctica:**
```
Abrí el SQL Editor de cualquiera de tus proyectos Supabase y probá correr un SELECT simple sobre una tabla que ya conozcas, como sites o empleados. No hace falta que sea perfecto — el objetivo es ver la respuesta real de la base de datos en pantalla.
```

**Errores comunes:**
```
- Usar SELECT * por costumbre incluso cuando solo hace falta una columna — funciona, pero es una mala práctica que se nota cuando la tabla crece.
- Olvidar el punto y coma al final (en el SQL Editor de Supabase no siempre es obligatorio, pero es buena costumbre).
- Confundir SELECT (leer datos) con SET (que se usa en UPDATE) — son cosas distintas aunque suenen parecido.
```

**Lista de comprobación:**
```
- [ ] Puedo escribir un SELECT * FROM tabla; sin mirar un ejemplo.
- [ ] Puedo escribir un SELECT con columnas específicas.
- [ ] Puedo explicar por qué nombrar columnas específicas es mejor que usar *.
```

---

## LECCIÓN 2: Filtrar resultados con WHERE

**Título:** Filtrar resultados con WHERE

**Nivel:** Fundamentos
**Duración estimada (min):** 15
**Prerrequisitos:** Qué es SELECT y para qué sirve

**Resumen:**
Cómo pedirle a la base de datos que te devuelva solo las filas que cumplen una condición, en vez de todas.

**Objetivos:**
```
- Escribir un SELECT con una condición WHERE.
- Combinar más de una condición con AND y OR.
- Reconocer WHERE en las consultas que ya usan tus propios sistemas.
```

**Explicación:**
```
WHERE es la parte de una consulta que filtra: le dice a la base de datos "de todas las filas de esta tabla, dame solo las que cumplen esto".

SELECT nombre, estado FROM tareas WHERE estado = 'pendiente';

Esto devuelve únicamente las tareas cuyo estado sea exactamente "pendiente" — el resto ni siquiera viaja de vuelta al cliente. Eso es importante: filtrar en la base de datos (con WHERE) es mucho más eficiente que traer todo y filtrar después en el código.

Se pueden combinar condiciones:

SELECT * FROM tareas WHERE estado = 'pendiente' AND responsable = 'Juan';
SELECT * FROM tareas WHERE estado = 'pendiente' OR estado = 'en_progreso';

AND exige que se cumplan todas las condiciones. OR exige que se cumpla al menos una.
```

**Ejemplo:**
```
En tu Control diario de Facilities, cuando filtrás las tareas por "solo las mías y pendientes", eso es un WHERE con AND: WHERE responsable_id = auth.uid() AND estado = 'pendiente'. De hecho, así es literalmente como funcionan las políticas RLS que ya armamos en las migraciones — son WHERE escondidos que corre la base de datos automáticamente.
```

**Aplicación práctica:**
```
En el SQL Editor, probá un SELECT sobre una tabla con datos (por ejemplo lesson_progress de esta misma Academy) y agregale un WHERE que filtre por status = 'completed'. Compará el resultado con el SELECT sin WHERE.
```

**Errores comunes:**
```
- Usar = para comparar con NULL (no funciona — hace falta IS NULL, algo que se ve más adelante en la ruta).
- Olvidar las comillas simples alrededor de texto: WHERE estado = pendiente falla, WHERE estado = 'pendiente' funciona.
- Pensar que WHERE filtra columnas — en realidad filtra filas. Las columnas se eligen en el SELECT.
```

**Lista de comprobación:**
```
- [ ] Puedo escribir un WHERE con una sola condición.
- [ ] Puedo combinar dos condiciones con AND.
- [ ] Puedo explicar la diferencia entre AND y OR con un ejemplo propio.
```

---

## LECCIÓN 3: Ordenar resultados con ORDER BY

**Título:** Ordenar resultados con ORDER BY

**Nivel:** Fundamentos
**Duración estimada (min):** 10
**Prerrequisitos:** Filtrar resultados con WHERE

**Resumen:**
Cómo pedirle a la base de datos que te devuelva los resultados en un orden específico, en vez del orden en que estén guardados.

**Objetivos:**
```
- Ordenar resultados de forma ascendente y descendente.
- Ordenar por más de una columna.
- Reconocer por qué el orden de una tabla nunca debería darse por sentado sin ORDER BY.
```

**Explicación:**
```
Una base de datos no garantiza ningún orden particular en los resultados a menos que se lo pidas explícitamente con ORDER BY. Es un error común asumir que las filas "siempre vienen en el orden en que se crearon" — a veces es así, pero no está garantizado, y puede cambiar con el tiempo.

SELECT * FROM lecciones ORDER BY order_index ASC;

ASC (ascendente) es el valor por defecto — de menor a mayor. Para el orden inverso:

SELECT * FROM lecciones ORDER BY order_index DESC;

También se puede ordenar por más de un criterio:

SELECT * FROM certificados ORDER BY issued_at DESC, completion_percentage DESC;

Esto ordena primero por fecha (más reciente primero) y, entre certificados de la misma fecha, por porcentaje de finalización.
```

**Ejemplo:**
```
El servicio learningStructure.service.ts de esta misma Academy usa exactamente esto — cada consulta a etapas, cursos, módulos y lecciones termina con .order('order_index', { ascending: true }), que es la versión en JavaScript/Supabase de un ORDER BY order_index ASC.
```

**Aplicación práctica:**
```
En el SQL Editor, tomá cualquier tabla con una columna de fecha (como created_at) y probá ordenarla primero ascendente y después descendente. Notá cómo cambia el orden de las filas en el resultado.
```

**Errores comunes:**
```
- Asumir que los datos "siempre vienen ordenados" sin poner ORDER BY explícito — es una fuente clásica de bugs difíciles de reproducir.
- Ordenar por una columna que no se seleccionó en el SELECT — en Postgres esto sí funciona (a diferencia de otros motores), pero conviene tenerlo claro.
- Confundir ASC/DESC con el orden alfabético — con texto también aplica (A antes que Z en ASC), no es solo para números.
```

**Lista de comprobación:**
```
- [ ] Puedo ordenar resultados de forma ascendente y descendente.
- [ ] Puedo ordenar por dos columnas a la vez.
- [ ] Puedo explicar por qué no conviene asumir un orden sin ORDER BY explícito.
```
