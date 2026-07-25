# Etapa 3 — Supabase: Módulo 1 "Primeros pasos con tu proyecto"

---

## LECCIÓN 1: Qué es un proyecto de Supabase y cómo se organiza

**Título:** Qué es un proyecto de Supabase y cómo se organiza

**Nivel:** Fundamentos
**Duración estimada (min):** 15
**Prerrequisitos:** Qué es una base de datos

**Resumen:**
Un proyecto de Supabase es Postgres más un conjunto de servicios (Auth, Storage, Realtime, Edge Functions) que corren alrededor de esa base de datos — todo lo que ya usaste para armar LillyTech Academy.

**Objetivos:**
```
- Identificar las piezas principales de un proyecto Supabase: base de datos, Auth, Storage, API.
- Distinguir entre el panel visual (dashboard de supabase.com) y la base de datos real que hay detrás.
- Reconocer los datos de conexión de un proyecto (URL y claves) y para qué sirve cada uno.
```

**Explicación:**
```
Cuando creaste el proyecto de LillyTech Academy en supabase.com, en el fondo se creó una base de datos Postgres completa, dedicada solo a vos, corriendo en un servidor de Supabase. Todo lo que ves en el dashboard (Table Editor, SQL Editor, Authentication, Storage) son formas distintas de mirar y controlar esa misma base de datos — no son sistemas separados.

Encima de esa base de datos, Supabase agrega capas de servicio:

- Auth: gestiona usuarios, sesiones y contraseñas (la tabla auth.users que ya usamos en las migraciones).
- API automática: cada tabla que creás queda expuesta automáticamente como endpoint REST, sin que tengas que escribir un backend — por eso tu app React puede hacer supabase.from('lessons').select() sin un servidor intermedio.
- Storage: para archivos (imágenes, PDFs) — todavía no lo usamos en la Academy.
- Realtime: para recibir cambios en vivo — tampoco lo usamos todavía.

Cada proyecto tiene una URL única (algo como https://rpvhdfvxroxdlagixupv.supabase.co) y un par de claves: la anon key (pública, la que ya tenés en tu .env) y la service role key (privada, nunca se usa en el frontend — la vemos en la lección de claves anon y service role).
```

**Ejemplo:**
```
Tu archivo src/lib/supabaseClient.ts de esta misma Academy es el ejemplo más directo: ahí es donde tu app React se conecta al proyecto Supabase usando la URL y la anon key. Todo lo que la app hace después (login, leer lecciones, guardar notas) pasa por esa única conexión.
```

**Aplicación práctica:**
```
Entrá al dashboard de tu proyecto Supabase y recorré el menú de la izquierda: Table Editor, SQL Editor, Authentication, Storage, Database. No hace falta tocar nada — el objetivo es que reconozcas dónde vive cada cosa que ya usamos (por ejemplo, las tablas que creamos con las migraciones deberían verse en Table Editor).
```

**Errores comunes:**
```
- Pensar que el Table Editor y el SQL Editor son "bases de datos distintas" — son dos formas de ver y editar la misma base de datos.
- Confundir el dashboard de supabase.com (la interfaz web) con la base de datos en sí — el dashboard puede estar caído y tu base de datos seguir funcionando para tu app.
- No saber dónde encontrar la URL y las claves del proyecto cuando hacen falta (están en Project Settings → API).
```

**Lista de comprobación:**
```
- [ ] Puedo nombrar al menos 3 servicios que vienen incluidos en un proyecto Supabase además de la base de datos.
- [ ] Sé dónde encontrar la URL y la anon key de mi proyecto.
- [ ] Puedo explicar la diferencia entre el dashboard visual y la base de datos real.
```

---

## LECCIÓN 2: El SQL Editor

**Título:** El SQL Editor

**Nivel:** Fundamentos
**Duración estimada (min):** 10
**Prerrequisitos:** Qué es un proyecto de Supabase y cómo se organiza

**Resumen:**
La herramienta donde escribís y ejecutás SQL directo contra tu base de datos — la misma que ya usaste para correr todas las migraciones de esta Academy.

**Objetivos:**
```
- Ubicar y usar el SQL Editor dentro del dashboard de Supabase.
- Entender qué pasa cuando corrés una consulta ahí (a diferencia de correrla desde el código de la app).
- Reconocer buenas prácticas básicas antes de ejecutar SQL en el editor.
```

**Explicación:**
```
El SQL Editor es una ventana de texto donde escribís SQL puro y lo ejecutás directo contra tu base de datos, sin pasar por tu aplicación. Es la herramienta que ya usaste para correr las 13 migraciones y los 4 seeds de esta Academy.

Es poderosa y hay que tratarla con respeto: acá no hay confirmaciones extra ni "deshacer" — si corrés un DELETE FROM lessons; sin WHERE, se borran todas las lecciones, sin aviso. Por eso el hábito correcto es: antes de correr algo destructivo (UPDATE, DELETE), primero correr un SELECT con la misma condición para ver exactamente qué filas vas a afectar.

El SQL Editor guarda un historial de las consultas que corriste, y te deja guardar consultas favoritas ("snippets") si las repetís seguido — por ejemplo, un SELECT que uses para revisar el progreso de estudiantes.
```

**Ejemplo:**
```
Cuando corriste 0012_concepts.sql en el SQL Editor, eso creó 7 tablas nuevas de una sola vez. El editor no te preguntó "¿estás segura?" antes de crearlas — confía en que quien lo corre sabe lo que está haciendo. Por eso las reglas de trabajo del proyecto dicen "no ejecutar migraciones destructivas sin autorización": es una regla humana, no una protección técnica del editor.
```

**Aplicación práctica:**
```
En el SQL Editor de tu proyecto, corré: SELECT title, is_published FROM concepts; — deberías ver el concepto de Row Level Security que ya cargamos. Practicá el hábito: antes de un UPDATE o DELETE reales, corré primero el SELECT equivalente.
```

**Errores comunes:**
```
- Correr un UPDATE o DELETE sin cláusula WHERE, afectando toda la tabla por accidente.
- No revisar en qué proyecto estás parada antes de correr algo — si tenés varios proyectos Supabase abiertos en pestañas distintas, es fácil confundirse.
- Pegar SQL de un tutorial sin leerlo, sin entender qué tablas toca.
```

**Lista de comprobación:**
```
- [ ] Puedo abrir el SQL Editor y correr una consulta SELECT simple.
- [ ] Entiendo por qué un DELETE sin WHERE es peligroso en este editor específicamente.
- [ ] Adopté el hábito de revisar con SELECT antes de modificar o borrar datos.
```

---

## LECCIÓN 3: Authentication y la tabla auth.users

**Título:** Authentication y la tabla auth.users

**Nivel:** Fundamentos
**Duración estimada (min):** 15
**Prerrequisitos:** El SQL Editor

**Resumen:**
Cómo Supabase gestiona quién sos vos cuando iniciás sesión — la pieza que hace posible que RLS sepa distinguir tus datos de los de cualquier otra persona.

**Objetivos:**
```
- Explicar qué es auth.users y por qué está separada de tus tablas propias (como profiles).
- Entender qué es un JWT y qué información transporta.
- Reconocer por qué nunca se debería duplicar la contraseña de alguien en una tabla propia.
```

**Explicación:**
```
Supabase Auth mantiene una tabla especial, auth.users, separada del resto de tu base de datos (vive en un esquema llamado auth, no en public donde están tus tablas). Ahí se guarda el email, la contraseña (encriptada, nunca en texto plano) y metadata de cada persona registrada.

Vos no tocás auth.users directamente casi nunca — en cambio, tu propia tabla profiles (que ya existe en esta Academy) tiene una fila por usuaria, conectada por id a auth.users, para guardar datos que sí te interesan a vos como app (nombre completo, avatar) sin mezclarlos con la lógica interna de autenticación de Supabase.

Cuando alguien inicia sesión, Supabase le entrega un JWT (JSON Web Token) — un token firmado que probablemente contenga, entre otras cosas, el id de esa usuaria. Ese token viaja en cada pedido que tu app hace a la base de datos, y es lo que la función auth.uid() lee cuando una política RLS evalúa "¿este dato es tuyo?".
```

**Ejemplo:**
```
El trigger handle_new_user() que ya armamos en esta Academy (migración 0002) se dispara automáticamente cada vez que aparece una fila nueva en auth.users — es decir, cada vez que alguien se registra — y desde ahí crea la fila correspondiente en profiles y le asigna el rol student. Nunca tocás auth.users directo: reaccionás a sus cambios con un trigger.
```

**Aplicación práctica:**
```
En el SQL Editor, corré: SELECT id, email, created_at FROM auth.users; y confirmá que tu propio usuario aparece ahí. Después corré SELECT * FROM public.profiles; y notá que tu profile tiene el mismo id — esa es la conexión entre ambas tablas.
```

**Errores comunes:**
```
- Intentar guardar la contraseña de alguien en una tabla propia "por las dudas" — Supabase Auth ya la maneja de forma segura, duplicarla es un riesgo de seguridad sin ningún beneficio.
- Confundir profiles con auth.users — profiles es tuya, la controlás vos; auth.users la controla el sistema de Auth.
- Pensar que borrar una fila de profiles borra también la cuenta de la persona — son cosas separadas (aunque en esta Academy configuramos on delete cascade desde auth.users hacia profiles, no al revés).
```

**Lista de comprobación:**
```
- [ ] Puedo explicar la diferencia entre auth.users y profiles.
- [ ] Puedo explicar qué es un JWT en una frase simple.
- [ ] Entiendo por qué auth.uid() puede usarse dentro de una política RLS.
```
