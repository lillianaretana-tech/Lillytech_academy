# Setup de GitHub — lillytech_academy

## 1. Crear el repositorio

En GitHub, dentro de tu org `lillianaretana-tech` (o tu cuenta personal, como prefieras):

- Nombre: **`lillytech_academy`**
- Visibilidad: **privado** (tiene tu URL y estructura interna — no hay motivo para hacerlo público en esta etapa)
- No marques "Add a README" ni "Add .gitignore" al crearlo — ya vienen en el zip, para evitar conflictos al hacer el primer push.

## 2. Estructura del repo (ya armada en el zip)

```
lillytech_academy/
├── .env.example          # plantilla de variables — SÍ se sube
├── .gitignore             # excluye .env, node_modules, dist
├── IMPLEMENTATION_PLAN.md
├── README.md
├── package.json
├── vite.config.ts
├── tailwind.config.js
├── postcss.config.js
├── tsconfig*.json
├── eslint.config.js
├── index.html
├── src/
│   ├── components/  pages/  layouts/  features/
│   ├── hooks/  services/  lib/  types/  utils/  routes/  styles/
├── supabase/
│   ├── migrations/   # 0001 a 0011
│   └── seed/          # 0001 a 0003
└── docs/
    ├── ARCHITECTURE.md
    ├── DATABASE.md
    ├── SECURITY.md
    ├── ROADMAP.md
    └── TESTING.md
```

**Lo único que NO se sube nunca:** tu `.env` real con las credenciales de Supabase. Ya está en `.gitignore`. Si en algún momento lo ves listado en `git status`, pará antes de hacer commit.

## 3. Primer push (desde tu computadora, con el zip ya descomprimido)

```bash
cd lillytech_academy
git init
git add .
git status              # confirmá que NO aparece .env en la lista
git commit -m "chore: scaffold inicial + base de datos (Fases 1-3)"
git branch -M main
git remote add origin https://github.com/lillianaretana-tech/lillytech_academy.git
git push -u origin main
```

## 4. Flujo de branches sugerido para lo que sigue

Dado que las fases quedan claras (4: estudiante, 5: admin, 6: certificados, 7: pruebas), lo más simple para vos sola trabajando es:

- `main` — siempre desplegable, cada fase se mergea acá cuando queda probada.
- Una rama por fase: `fase-4-estudiante`, `fase-5-admin`, etc. Se abre, se trabaja, se prueba localmente, se mergea a `main`.

No hace falta pull requests formales si sos la única que edita — pero si querés dejar registro de qué cambió en cada fase, un PR (aunque te lo apruebes vos misma) te da el historial ordenado y el diff completo de cada fase, cosa que te puede servir después para tu documentación de LillyTech.

## 5. Conectar con Vercel

Una vez el repo esté en GitHub:

1. En Vercel → "Add New Project" → importás `lillianaretana-tech/lillytech_academy`.
2. Framework preset: **Vite**.
3. Variables de entorno (Settings → Environment Variables), mismas que tu `.env` local:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
4. Deploy. Cada push a `main` genera un deploy de producción; cada rama/PR genera un preview aparte — útil para revisar una fase antes de mergearla.

## 6. Commits pequeños y descriptivos (regla del proyecto)

Convención sugerida, simple:

```
feat: dashboard con progreso real
fix: RLS de lesson_progress no dejaba insertar
docs: actualiza README con pasos de Vercel
chore: reorganiza carpeta features/lessons
```

No hace falta nada más elaborado que esto para un proyecto de una sola desarrolladora.
