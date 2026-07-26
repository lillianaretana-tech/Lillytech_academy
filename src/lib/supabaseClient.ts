import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL as string
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY as string

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error(
    'Faltan VITE_SUPABASE_URL o VITE_SUPABASE_ANON_KEY. Revisa tu archivo .env (mira .env.example).',
  )
}

// Nota: el cliente NO se tipa con un genérico Database. Ese tipo era un
// placeholder incompleto (ver database.types.ts) — tiparlo con algo
// incompleto es peor que no tiparlo, porque bloquea el build de
// producción con errores estrictos de TypeScript. Todos los servicios de
// esta Academy ya castean manualmente los resultados con `as Tipo`, así
// que la seguridad de tipos real sigue estando, solo que aplicada
// después de la respuesta en vez de en la firma del cliente.
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
  },
})
