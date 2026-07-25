# LillyTech Academy — Plan Evolutivo (v1.1 en adelante)

**Estado:** Propuesta para revisión — ningún cambio fue ejecutado todavía.
**Base:** Arquitectura actual (Fases 1-5 completas: scaffold, base de datos con 18 tablas + RLS, experiencia de estudiante, panel admin).

---

## Principio de reutilización del conocimiento

> Ningún conocimiento debería existir en dos lugares distintos.

Si un concepto ya fue explicado una vez (en la Biblioteca de Conceptos), las lecciones, proyectos y notas futuras deben **enlazar** ese concepto en lugar de volver a explicarlo. LillyTech Academy debe comportarse como una red de conocimiento interconectada, no como una colección de documentos independientes.

Este principio no es solo filosófico — tiene una consecuencia técnica directa en cómo se diseña v1.1/v1.2: las tablas `concept_lessons`, `concept_projects` y `concept_resources` (relaciones N:N) no son un capricho de modelado, son la implementación concreta de este principio. Cuando una lección necesita explicar "qué es RLS", en vez de repetir la explicación completa, se enlaza al concepto "RLS" ya documentado una sola vez en la Biblioteca. La lección aporta el contexto curricular (por qué esto importa *en este punto de la ruta*); el concepto aporta la explicación canónica (que no se repite en ningún otro lado).

Esto también redefine ligeramente el campo "Explicación" de una lección: a partir de que exista la Biblioteca de Conceptos, la explicación de una lección debería tender a ser breve y remitir al concepto correspondiente, en vez de duplicar contenido extenso que ya vive en la ficha del concepto. Las 6 lecciones ya cargadas (Etapas 1 y 2) seguirán funcionando tal cual están — este principio aplica hacia adelante, no exige reescribir lo existente.

---

## Principio de secuenciación

Tus 5 prioridades no son independientes entre sí — hay dependencias reales de datos. Este plan las respeta en el orden que pediste, pero divide la Prioridad 1 (Biblioteca de Conceptos) en dos versiones porque es la pieza más grande y todo lo demás depende de ella:

```
P1 Biblioteca de Conceptos ──┬──► P5 Nivel de dominio (vive DENTRO de cada concepto)
                              └──► P3 Buscador global (necesita algo que buscar)
P2 Bitácora completa ────────────► independiente, se puede hacer en paralelo
P4 Indicadores de aprendizaje ───► necesita P1 y P2 para métricas completas
```

Por eso el orden de versiones no es 1-2-3-4-5 literal, sino el que minimiza trabajo repetido.

---

## v1.1 — Ajustes de base + fundamento de Conceptos ✅ COMPLETADA

**Complejidad:** M (mediana)
**Depende de:** nada — se monta sobre lo ya construido.

Dos cosas en esta versión, agrupadas porque ambas son "terminar lo que ya empezamos" antes de construir lo nuevo:

**a) Cerrar gaps ya detectados en la auditoría** (bajo costo, alto valor inmediato):
- Mostrar `lesson_resources` en la vista de lección del estudiante (la tabla ya existe, solo falta la UI — y agregar el campo al editor admin, que hoy tampoco lo expone).
- Buscador simple dentro de Biblioteca (ya existe la misma lógica en Notas, se reutiliza).
- Horas estudiadas en el Dashboard, sumando `estimated_minutes` de lecciones completadas — cero cambios de esquema.

**b) Fundamento de datos para la Biblioteca de Conceptos:**
- Tabla nueva `concepts`: nombre, qué_es, por_qué_existe, qué_problema_resuelve, cuándo_utilizarlo, errores_comunes, nivel_dominio, created_by, is_published.
- Tabla `concept_relations` (N:N entre conceptos, para "relaciones con otros conceptos").
- Tabla `concept_lessons` y `concept_projects` (N:N, igual patrón que `project_lessons` que ya existe).
- Tabla `concept_resources` (mismo patrón que `lesson_resources`).
- RLS: mismo criterio que el resto — publicado visible para autenticados, escritura solo admin.
- CRUD en el panel admin (mismo patrón ya construido para rutas/etapas/lecciones — se reutiliza el componente de administración de contenido).

**Justificación:** sin este fundamento, ni el buscador global (P3) ni el nivel de dominio (P5) tienen dónde vivir. Es la inversión que evita reconstruir en versiones posteriores.

---

## v1.2 — Biblioteca de Conceptos, vista completa (Prioridad 1 terminada) ✅ COMPLETADA

**Complejidad:** M
**Depende de:** v1.1 (esquema ya creado)

- Vista de estudiante: navegación de conceptos (no por orden curricular como la Biblioteca actual, sino alfabética/por categoría — es deliberadamente distinta a la Biblioteca de rutas).
- Ficha de concepto completa con los 12 campos que pediste: qué es, por qué existe, qué problema resuelve, cuándo utilizarlo, ejemplos reales, errores comunes, relaciones con otros conceptos, notas personales, nivel de dominio, proyectos relacionados, lecciones relacionadas, recursos relacionados.
- Navegación cruzada: desde una lección se puede saltar a los conceptos relacionados, y viceversa.
- Notas personales por concepto: se reutiliza `personal_notes`, agregando `concept_id` opcional (hoy solo admite `lesson_id`) — cambio aditivo, no rompe lo existente.

**Justificación:** esta es la pieza que te transforma la app de "academia con lecciones" a "segunda memoria" — es la más alineada con tu filosofía de "Wikipedia personal", y la que más valor tiene a largo plazo (2 años acumulando conceptos vale mucho más que 2 años acumulando lecciones completadas). Es también donde se materializa el **Principio de reutilización del conocimiento**: a partir de esta versión, el flujo de trabajo correcto para redactar contenido nuevo es "¿este concepto ya existe? → enlazalo. ¿no existe? → creá el concepto una vez, después enlazalo desde donde haga falta."

---

## v1.3 — Nivel de dominio (Prioridad 5)

**Complejidad:** S (chica)
**Depende de:** v1.1/v1.2 (el campo `nivel_dominio` ya existe en el esquema, esta versión es la UI + lógica)

- Selector de nivel en la ficha de cada concepto: *No lo conozco / Lo entiendo / Lo puedo explicar / Lo puedo aplicar / Lo podría enseñar*.
- Este nivel es tuyo, personal — no es un campo del concepto en sí (que es contenido compartido/publicado por admin), sino un registro por usuario y concepto (tabla `concept_mastery`: user_id, concept_id, level, updated_at). Aclaro esto porque si el nivel viviera directo en `concepts`, sería el mismo para todo el mundo — y vos querés que sea tu propio progreso personal, no una propiedad del contenido.
- Se muestra como indicador visual (no barra de progreso genérica, sino los 5 niveles como estados, más parecido a un semáforo de comprensión que a un % de avance).
- Reemplaza (o convive con) el estado binario "completada/no completada" de las lecciones como la métrica que más importa a nivel de concepto — la lección marca que la *viste*, el nivel de dominio marca que la *entendiste*.

**Justificación:** es la prioridad que mejor refleja tu objetivo real ("comprender profundamente", no "memorizar") — completar una lección es un evento, el nivel de dominio es un estado que evoluciona.

---

## v1.4 — Bitácora completa (Prioridad 2)

**Complejidad:** S
**Depende de:** nada nuevo — la tabla `learning_activity` ya existe y ya registra eventos.

- Página dedicada `/bitacora` (hoy solo hay un resumen de 5 eventos en el Dashboard).
- Vista cronológica completa, filtrable por tipo de evento y por rango de fechas.
- Se amplían los tipos de evento registrados: hoy solo se loguean inicio/fin de lección — hay que agregar logging de creación de notas, dudas, actualización de proyectos, y (cuando exista v1.2) creación/edición de conceptos y cambios de nivel de dominio.
- Redacción de cada entrada en tono de "diario" en vez de "log técnico" (ej. "Completaste 'Claves primarias' — llevás 3 lecciones esta semana" en vez de solo "lesson_completed").

**Justificación:** de las 5 prioridades, es la de menor complejidad técnica (la tabla ya existe) y la que te da el "diario de aprendizaje" que pediste explícitamente — buena relación esfuerzo/valor, por eso la adelanto en la secuencia aunque la marcaste P2.

---

## v1.5 — Buscador global (Prioridad 3)

**Complejidad:** M
**Depende de:** v1.1-v1.4 (necesita que exista contenido en todas las fuentes para tener sentido: conceptos, lecciones, notas, dudas, proyectos, recursos, bitácora)

- Un solo campo de búsqueda (probablemente en el header del `AppLayout`, visible desde cualquier pantalla).
- Resultados agrupados por tipo de contenido (Conceptos / Lecciones / Notas / Dudas / Proyectos / Bitácora), no una lista mezclada.
- Búsqueda de texto simple al principio (`ILIKE` en Postgres) — suficiente para el volumen de datos que vas a tener en los próximos 1-2 años; full-text search de Postgres (`tsvector`) queda como mejora futura si el volumen crece mucho.

**Justificación:** es la prioridad con más dependencias — construirla antes que las demás significaría un buscador que solo encuentra lecciones, cuando la idea completa es que encuentre *todo tu conocimiento acumulado*. Por eso va después, no por menor importancia sino por orden técnico correcto.

---

## v1.6 — Indicadores de aprendizaje (Prioridad 4)

**Complejidad:** S/M
**Depende de:** todas las anteriores (son las que generan los datos a medir)

- Ampliar el Dashboard con: horas estudiadas totales (ya en v1.1), conceptos aprendidos (contando niveles "lo puedo aplicar" o superior), dudas resueltas, notas creadas, proyectos relacionados, progreso por etapa (no solo global).
- Posiblemente un gráfico simple de progreso en el tiempo (usando la Bitácora de v1.4 como fuente).

**Justificación:** son métricas derivadas — no tiene sentido construirlas antes que las fuentes de datos que resumen. Por eso quedan al final, aunque las marcaste P4 y no P6 — el orden técnico correcto las empuja al cierre del ciclo.

---

## Resumen de secuencia y complejidad

| Versión | Contenido | Complejidad | Prioridad original |
|---|---|---|---|
| v1.1 | Gaps existentes + esquema de Conceptos | M | (fundamento de P1) |
| v1.2 | Biblioteca de Conceptos completa | M | P1 |
| v1.3 | Nivel de dominio | S | P5 |
| v1.4 | Bitácora completa | S | P2 |
| v1.5 | Buscador global | M | P3 |
| v1.6 | Indicadores de aprendizaje | S/M | P4 |

## Lo que NO estoy proponiendo agregar (y por qué)

Aplicando tu propia restricción — "¿ayuda a comprender mejor la tecnología y conservar el conocimiento durante años?" — dejé afuera de este plan cosas que podrían parecer atractivas pero no pasan el filtro:

- **Exportación de notas a PDF** — es útil pero no ayuda a *comprender*, es una comodidad de respaldo. Puede vivir como v1.7 o más adelante, sin urgencia.
- **Copias de seguridad manuales desde la app** — Supabase ya respalda la base de datos a nivel de infraestructura; una función de export dentro de la app sería redundante salvo que quieras un backup *portable* fuera de Supabase, que es una decisión de negocio distinta a "aprender mejor".
- **Gamificación (streaks, puntos, insignias)** — explícitamente fuera de tu filosofía ("no es un LMS"), no lo incluyo en ninguna versión salvo que lo pidas.

---

## Visión futura (v2 / v3, no implementar todavía) — Asistente de Aprendizaje IA

Documentado para dejar registro de la dirección de largo plazo, sin construir nada de esto hasta que v1.1-v1.6 estén sólidas.

No sería un chatbot genérico conectado a un modelo con conocimiento general — sería un asistente que responde **exclusivamente** con tu propio conocimiento acumulado en LillyTech Academy: conceptos, lecciones, notas, bitácora, proyectos y sus relaciones. Ejemplos del tipo de pregunta que debería poder responder:

- "¿Dónde aprendí sobre RLS?"
- "Mostrame todos los errores que cometimos en la Migración 24."
- "¿Qué decisiones tomamos cuando unimos Safety Academy y OnboardFlow?"
- "¿Qué conceptos necesito entender antes de aprender Edge Functions?"
- "Explicame JWT usando únicamente ejemplos de mis proyectos."

**Por qué esto no es parte de v1.x:** técnicamente depende de que exista un cuerpo de conocimiento estructurado y conectado (Biblioteca de Conceptos + Bitácora + relaciones) — construirlo antes sería un asistente que "alucina" sobre una base de datos casi vacía. Es la razón de más peso para respetar el orden de v1.1 a v1.6 sin saltarse pasos: cada versión anterior es, literalmente, el material de entrenamiento/contexto que va a necesitar este asistente el día que se construya.

**Cuándo tendría sentido evaluarlo en serio:** cuando la Biblioteca de Conceptos tenga un volumen real de contenido (no solo Etapas 1-2), y la Bitácora lleve varios meses de registros reales — ahí el asistente empieza a tener algo genuino sobre lo cual responder, en vez de repetir lo poco que hay.

Cuando llegue ese momento, técnicamente encaja con lo que ya existe en este entorno: es exactamente el tipo de tarea para la que están pensadas las llamadas a la API de Anthropic con búsqueda sobre tus propios datos (RAG sobre Supabase) — no requeriría rehacer nada de la arquitectura actual, solo una capa nueva por encima.

---

## Próximo paso

Esto es una propuesta — no ejecuté ningún cambio de código ni de base de datos. Cuando la revises, decime si el orden te hace sentido o si preferís reordenar alguna prioridad, y arrancamos por la versión que definamos (probablemente v1.1, por ser la base de todo lo demás).
