-- 0020_seed_seguridad_modulo2.sql
-- Módulo 2 de la Etapa 7 (Seguridad práctica): "Seguridad por capas".

insert into public.modules (id, course_id, title, description, order_index, is_published)
select 'b5c37a3c-8cc7-4060-b8a1-c7d9878af09b', id, 'Seguridad por capas', 'Qué le corresponde proteger al frontend y qué le corresponde al backend — un repaso enfocado en la responsabilidad de cada capa.', 2, true
from public.courses where title = 'Seguridad proporcional al riesgo';

insert into public.lessons (
  id, module_id, title, summary, objectives, content, example,
  practical_application, common_mistakes, checklist, estimated_minutes,
  level, prerequisites, order_index, is_published
) values
(
  '7bdc650b-fe25-47aa-ab37-e59c9c586ce0',
  'b5c37a3c-8cc7-4060-b8a1-c7d9878af09b',
  'Seguridad del frontend: lo que sí le corresponde',
  'El frontend no puede proteger datos de verdad — pero sí tiene responsabilidades de seguridad reales, distintas de la autorización.',
  E'- Identificar qué responsabilidades de seguridad SÍ le corresponden al frontend.\n- Explicar por qué esas responsabilidades son de experiencia y prevención, no de garantía.\n- Reconocer un ejemplo de cada una en esta Academy.',
  E'Ya quedó claro en la Etapa 4 que el frontend nunca es la garantía real de autorización — eso lo da RLS. Pero eso no significa que el frontend no tenga NINGUNA responsabilidad de seguridad. Le corresponden estas, con un rol distinto al de "garantizar":\n\n- Validación de formato antes de enviar (evita pedidos inútiles a la API, mejora la experiencia, no es la protección real).\n- No filtrar información sensible en el código o en mensajes de error mostrados a la usuaria (por ejemplo, nunca mostrar el mensaje crudo de un error de base de datos que podría revelar detalles internos de la estructura).\n- Sanitizar contenido que se muestra en pantalla si viene de una fuente no confiable, para evitar inyección de HTML/JavaScript malicioso (menos relevante en esta Academy porque React ya escapa el contenido por defecto al renderizar texto, a menos que se use dangerouslySetInnerHTML, que esta Academy no usa en ningún lado).\n- Manejar bien la sesión: cerrar sesión correctamente, no dejar tokens expuestos innecesariamente en el código.\n\nLa idea central: el frontend protege la EXPERIENCIA y ayuda a PREVENIR errores comunes, pero nunca es la última línea de defensa contra alguien decidido a saltárselo.',
  E'React ya te protege de forma automática de un tipo de ataque común (inyección de HTML) simplemente por cómo renderiza texto: si guardaras <script>alert(1)</script> como el contenido de una nota en esta Academy, React lo mostraría literalmente como texto, no lo ejecutaría como código — a menos que alguien usara explícitamente dangerouslySetInnerHTML, que esta Academy no usa en ningún componente.',
  E'Buscá en todo el código de esta Academy si existe algún uso de dangerouslySetInnerHTML (podés usar el buscador de archivos del Codespace). Confirmá que no aparece en ningún lado.',
  E'- Confiar en que "el frontend valida, así que ya está protegido" — la validación de frontend es conveniencia, no protección real (tema ya visto en la lección de Validación).\n- Mostrar mensajes de error técnicos completos a la usuaria, revelando detalles internos que podrían ayudar a alguien con intenciones maliciosas.\n- Usar dangerouslySetInnerHTML sin pensar en las consecuencias, abriendo la puerta a inyección de código si el contenido viene de una fuente no completamente confiable.',
  E'- [ ] Puedo nombrar 2 responsabilidades de seguridad reales del frontend.\n- [ ] Puedo explicar por qué React protege contra inyección de HTML por defecto.\n- [ ] Confirmé que esta Academy no usa dangerouslySetInnerHTML en ningún componente.',
  15, 'Intermedio', 'Manejo de secretos', 1, true
),
(
  '52b7e618-0b88-4980-88fa-267ae1d118dc',
  'b5c37a3c-8cc7-4060-b8a1-c7d9878af09b',
  'Seguridad del backend: donde vive la garantía real',
  'Repaso enfocado de por qué, en esta Academy, "backend" significa Postgres + RLS + funciones — y qué responsabilidades de seguridad recaen ahí, sin excepción.',
  E'- Repasar por qué la seguridad real de esta Academy vive en el backend (Supabase), no en el frontend.\n- Enumerar las piezas de seguridad de backend que ya existen en este proyecto.\n- Explicar qué pasaría si cada una de esas piezas faltara.',
  E'Ya viste en la Etapa 4 que esta Academy no tiene un servidor propio — Supabase cumple el rol de backend. Esta lección repasa, con foco específico en seguridad, todas las piezas de esa capa que ya existen:\n\n- RLS activado en TODAS las tablas — sin excepciones, garantizado desde la primera migración.\n- Políticas escritas con condiciones reales, nunca using (true) sin justificar.\n- La función is_admin() como punto único de verdad sobre quién es administradora — si esa función tuviera un bug, afectaría a todas las políticas que dependen de ella, por eso se prueba con cuidado.\n- El trigger handle_new_user() asignando siempre el rol mínimo (student) por defecto.\n- La service role key nunca expuesta en ningún lugar del frontend.\n\nSi cualquiera de estas piezas faltara o estuviera mal configurada, el problema NO se notaría necesariamente en la interfaz — la app podría verse y funcionar perfecto para vos, mientras alguien más, saltándose el frontend y hablando directo con la API, accediera a datos que no debería. Esta es la razón por la que la seguridad de backend importa incluso cuando "todo funciona bien" desde la interfaz: un frontend que funciona no es evidencia de que el backend esté seguro.',
  E'Si alguna política RLS de esta Academy tuviera un error sutil (por ejemplo, using (true) en vez de using (auth.uid() = user_id) por un error de tipeo), la app seguiría funcionando exactamente igual para vos en el navegador — el problema solo se notaría si alguien inspeccionara los pedidos directos a la API, algo que la interfaz normal nunca revela.',
  E'Corré SELECT tablename, policyname, qual FROM pg_policies WHERE qual = ''true'';. Si devuelve alguna fila, esa política merece revisión inmediata — un using (true) sin condición real es una bandera roja.',
  E'- Asumir que "la app funciona bien" es evidencia de que el backend está seguro — son cosas independientes.\n- No auditar periódicamente las políticas existentes buscando condiciones demasiado permisivas.\n- Depender de una sola función (como is_admin()) sin haberla probado con cuidado, dado que un error ahí se propaga a todas las políticas que la usan.',
  E'- [ ] Puedo enumerar 3 piezas de seguridad de backend de esta Academy.\n- [ ] Puedo explicar por qué "la app funciona bien" no garantiza que el backend esté seguro.\n- [ ] Corrí la consulta de auditoría sugerida y confirmé que ninguna política usa using (true) sin justificar.',
  15, 'Intermedio', 'Seguridad del frontend: lo que sí le corresponde', 2, true
);

insert into public.exercises (id, lesson_id, title, instructions, type, order_index) values
(
  'a7192bbf-f5bc-4328-ab4f-080ffdfa4d13',
  '7bdc650b-fe25-47aa-ab37-e59c9c586ce0',
  'Buscá dangerouslySetInnerHTML',
  'Usando el buscador de archivos de tu Codespace, confirmá que dangerouslySetInnerHTML no aparece en ningún componente de esta Academy.',
  'evidence_link', 1
),
(
  '750bff5f-aca6-4597-97eb-65423bff64ed',
  '52b7e618-0b88-4980-88fa-267ae1d118dc',
  'Auditá políticas con using (true)',
  'Corré la consulta sugerida en la lección y confirmá que ninguna política real de esta Academy usa using (true) sin justificación.',
  'evidence_link', 1
);
