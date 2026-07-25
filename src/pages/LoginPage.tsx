import { useState, type FormEvent } from 'react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '@/features/auth/hooks/useAuth'

export function LoginPage() {
  const { signIn } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  const from = (location.state as { from?: Location })?.from?.pathname ?? '/dashboard'

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setSubmitting(true)
    const { error } = await signIn(email, password)
    setSubmitting(false)
    if (error) {
      setError(error)
      return
    }
    navigate(from, { replace: true })
  }

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-4">
      <h1 className="text-center text-lg font-semibold text-ink">Iniciar sesión</h1>

      <div>
        <label htmlFor="email" className="mb-1 block text-xs font-medium text-ink-soft">
          Correo
        </label>
        <input
          id="email"
          type="email"
          required
          className="input-field"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          autoComplete="email"
        />
      </div>

      <div>
        <label htmlFor="password" className="mb-1 block text-xs font-medium text-ink-soft">
          Contraseña
        </label>
        <input
          id="password"
          type="password"
          required
          className="input-field"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          autoComplete="current-password"
        />
      </div>

      {error && <p className="text-sm text-rust">{error}</p>}

      <button type="submit" disabled={submitting} className="btn-primary">
        {submitting ? 'Ingresando…' : 'Ingresar'}
      </button>

      <Link to="/forgot-password" className="text-center text-xs text-ink-soft hover:text-brass">
        Olvidé mi contraseña
      </Link>
    </form>
  )
}
