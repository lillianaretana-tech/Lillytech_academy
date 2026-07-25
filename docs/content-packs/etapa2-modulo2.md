# Etapa 2 — SQL: Módulo 2 "Modificar datos"

---

## LECCIÓN 1: Agregar filas con INSERT

**Título:** Agregar filas con INSERT

**Nivel:** Fundamentos
**Duración estimada (min):** 15
**Prerrequisitos:** Ordenar resultados con ORDER BY

**Resumen:**
La instrucción que crea una fila nueva en una tabla — el otro lado de SELECT: en vez de leer, escribís.

**Objetivos:**
```
- Escribir un INSERT especificando columnas y valores.
- Entender qué pasa con las columnas que no se mencionan en el INSERT.
- Reconocer cuándo INSERT falla por violar una restricción (unique, not null, foreign key).
```

**Explicación:**
```
INSERT agrega una fila nueva a una tabla. La forma básica nombra las columnas y después los valores, en el mismo orden:

INSERT INTO practical_projects (user_id, name, status)
VALUES ('uuid-de-la-usuaria', 'OnboardFlow', 'completed');

Las columnas que no mencionás toman su valor por defecto: si la tabla tiene DEFAULT gen_random_uuid() en id, se genera solo; si una columna tiene DEFAULT now() en created_at, se llena solo; si una columna no tiene default y es NOT NULL (como muchas de las que armamos en las migraciones), el INSERT falla si no la incluís.

Cada vez que tu app llama a supabase.from('practical_projects').insert({...}), eso genera exactamente este tipo de instrucción por debajo — con la diferencia de que RLS revisa, antes de dejarlo pasar, si a esa usuaria se le permite insertar ahí (recordá la política practical_projects: own insert que ya armamos, con with check (auth.uid() = user_id)).
```

**Ejemplo:**
```
Cuando registraste un proyecto práctico desde la página "Proyectos" de esta Academy, tu navegador mandó algo equivalente a: INSERT INTO practical_projects (user_id, name, status, description) VALUES (...). El formulario de React solo junta los datos — quien realmente los guarda es este INSERT, corriendo del lado del servidor de Supabase.
```

**Aplicación práctica:**
```
En el SQL Editor, probá insertar una fila de prueba en una tabla que puedas borrar después sin problema — por ejemplo application_settings: INSERT INTO application_settings (key, value) VALUES ('test_key', 'test_value');. Confirmá con un SELECT que apareció, y después bórrala con DELETE (lo vemos en la próxima lección) o dejala si preferís.
```

**Errores comunes:**
```
- Escribir los valores en un orden distinto al de las columnas listadas — SQL no adivina por posición si vos ya declaraste las columnas explícitamente.
- Olvidar comillas simples en valores de texto: VALUES (uuid, OnboardFlow) falla, VALUES (uuid, 'OnboardFlow') funciona.
- No revisar las restricciones de la tabla antes de insertar — un INSERT que viola una FK (por ejemplo, un lesson_id que no existe) falla con un error de integridad referencial.
```

**Lista de comprobación:**
```
- [ ] Puedo escribir un INSERT completo especificando columnas y valores.
- [ ] Entiendo qué pasa con una columna que tiene DEFAULT y no la incluyo en el INSERT.
- [ ] Puedo explicar qué es una violación de restricción y dar un ejemplo.
```

---

## LECCIÓN 2: Modificar filas con UPDATE

**Título:** Modificar filas con UPDATE

**Nivel:** Fundamentos
**Duración estimada (min):** 15
**Prerrequisitos:** Agregar filas con INSERT

**Resumen:**
La instrucción que cambia valores en filas que ya existen — y la que más cuidado exige de las tres, porque un WHERE mal puesto (o ausente) puede modificar mucho más de lo que querías.

**Objetivos:**
```
- Escribir un UPDATE con SET y WHERE.
- Explicar por qué un UPDATE sin WHERE es una de las operaciones más peligrosas en SQL.
- Reconocer el patrón "SELECT primero, UPDATE después" como hábito de seguridad.
```

**Explicación:**
```
UPDATE cambia el valor de una o más columnas en las filas que cumplen una condición:

UPDATE lesson_progress
SET status = 'completed', completed_at = now()
WHERE user_id = 'uuid-de-la-usuaria' AND lesson_id = 'uuid-de-la-leccion';

SET define qué columnas cambian y a qué valor. WHERE define qué filas se ven afectadas — y acá está el punto más importante de toda esta lección: si te olvidás el WHERE, el UPDATE se aplica a TODAS las filas de la tabla, sin excepción, sin aviso.

Por eso el hábito profesional es: antes de correr un UPDATE, correr el SELECT equivalente con la misma condición WHERE, mirar qué filas aparecen, y solo después convertir ese SELECT en UPDATE. Esto ya lo mencionamos en la lección del SQL Editor — acá es donde más importa aplicarlo.

Cada vez que tu app marca una lección como completada (setLessonStatus en el servicio progress.service.ts de esta Academy), por debajo corre un UPDATE como el de arriba — filtrado siempre por user_id y lesson_id específicos, nunca "todas las filas".
```

**Ejemplo:**
```
Cuando marcaste como completada la lección "Qué es SELECT y para qué sirve" en esta misma Academy, el código ejecutó un UPDATE sobre lesson_progress filtrado por tu user_id y el id de esa lección exacta — no tocó el progreso de ninguna otra lección ni de ninguna otra persona.
```

**Aplicación práctica:**
```
En el SQL Editor: primero corré SELECT * FROM application_settings WHERE key = 'test_key'; (o la fila que hayas creado en la lección anterior). Confirmá que aparece la fila correcta, y recién ahí corré UPDATE application_settings SET value = 'valor_actualizado' WHERE key = 'test_key';. Verificá el cambio con otro SELECT.
```

**Errores comunes:**
```
- Correr UPDATE tabla SET columna = valor; sin WHERE — actualiza absolutamente todas las filas.
- Escribir una condición WHERE que coincide con más filas de las que pensabas (por ejemplo, WHERE status = 'pending' cuando había más de una fila en ese estado y solo querías cambiar una).
- No verificar el resultado después — Postgres te dice cuántas filas fueron afectadas ("UPDATE 3"), y si ese número no es el esperado, es una señal de alerta inmediata.
```

**Lista de comprobación:**
```
- [ ] Puedo escribir un UPDATE con SET y WHERE correctamente.
- [ ] Puedo explicar por qué UPDATE sin WHERE es peligroso, con mis propias palabras.
- [ ] Adopté el hábito de correr el SELECT equivalente antes de un UPDATE real.
```

---

## LECCIÓN 3: Eliminar filas con DELETE

**Título:** Eliminar filas con DELETE

**Nivel:** Fundamentos
**Duración estimada (min):** 15
**Prerrequisitos:** Modificar filas con UPDATE

**Resumen:**
La instrucción que borra filas — irreversible salvo que tengas backups, y con el mismo riesgo que UPDATE si se te olvida el WHERE.

**Objetivos:**
```
- Escribir un DELETE con WHERE.
- Entender qué es ON DELETE CASCADE y por qué borrar una fila puede borrar otras en cascada.
- Explicar la diferencia entre borrar datos y "desactivarlos" (soft delete).
```

**Explicación:**
```
DELETE elimina filas completas de una tabla:

DELETE FROM personal_notes WHERE id = 'uuid-de-la-nota';

Igual que con UPDATE, el WHERE es lo que evita el desastre: DELETE FROM personal_notes; sin condición borra todas las notas de todas las usuarias.

Hay algo más para entender acá, que ya usamos en las migraciones de esta Academy: ON DELETE CASCADE. Cuando definimos una clave foránea con esa opción (por ejemplo, lesson_id uuid references lessons(id) on delete cascade en personal_notes), le estamos diciendo a Postgres: "si se borra la lección, borrá también automáticamente todas las notas que apuntan a ella". Es lo que evita que queden notas "huérfanas" apuntando a una lección que ya no existe.

Por eso cuando en el panel admin borrás una lección, en el fondo eso dispara (vía CASCADE) el borrado de sus ejercicios, sus recursos, y el progreso de todas las estudiantes sobre esa lección — no es magia, es una consecuencia directa de cómo se diseñaron las foreign keys.

Una alternativa a borrar de verdad es el "soft delete": en vez de DELETE, hacés UPDATE tabla SET is_active = false — la fila sigue existiendo pero se trata como si no estuviera. Esta Academy usa ese patrón con is_published en el contenido académico: despublicar no es lo mismo que eliminar.
```

**Ejemplo:**
```
Cuando eliminás una etapa desde el panel de Administración de esta Academy, el botón "Eliminar" ejecuta un DELETE FROM stages WHERE id = ... — y por las foreign keys con ON DELETE CASCADE que armamos en la migración 0003, eso arrastra automáticamente el borrado de todos los cursos, módulos y lecciones que colgaban de esa etapa. Por eso el confirm() de JavaScript antes de borrar no es un capricho — es la única protección real contra un borrado en cascada accidental.
```

**Aplicación práctica:**
```
En el SQL Editor: DELETE FROM application_settings WHERE key = 'test_key';, para limpiar la fila de prueba que creaste en la Lección 1. Confirmá con un SELECT que ya no aparece.
```

**Errores comunes:**
```
- Correr DELETE FROM tabla; sin WHERE — borra la tabla entera.
- No pensar en las consecuencias de ON DELETE CASCADE antes de borrar una fila "padre" — un solo DELETE puede arrastrar cientos de filas relacionadas sin que lo veas venir.
- Usar DELETE cuando en realidad hacía falta un soft delete (UPDATE ... SET is_active = false), perdiendo información que podría haber sido útil conservar.
```

**Lista de comprobación:**
```
- [ ] Puedo escribir un DELETE con WHERE correctamente.
- [ ] Puedo explicar qué es ON DELETE CASCADE con un ejemplo de esta Academy.
- [ ] Puedo explicar cuándo conviene un soft delete en vez de un DELETE real.
```
