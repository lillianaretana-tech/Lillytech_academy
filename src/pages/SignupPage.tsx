import { useState, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '@/features/auth/hooks/useAuth'

export function SignupPage() {
  const { signUp } = useAuth()
  const navigate = useNavigate()
  const [fullName, setFullName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [status, setStatus] = useState<'idle' | 'created'>('idle')
  const [submitting, setSubmitting] = useState(false)

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setError(null)
    setSubmitting(true)
    const { error } = await signUp(email, password, fullName)
    setSubmitting(false)
    if (error) {
      setError(error)
      return
    }
    setStatus('created')
  }

  if (status === 'created') {
    return (
      <div className="text-center">
        <p className="text-sm text-ink">
          Cuenta creada. Si tu proyecto Supabase pide confirmación por correo, revisá tu bandeja
          de entrada antes de iniciar sesión.
        </p>
        <button onClick={() => navigate('/login')} className="btn-primary mt-4">
          Ir a iniciar sesión
        </button>
      </div>
    )
  }

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-4">
      <h1 className="text-center text-lg font-semibold text-ink">Crear cuenta</h1>

      <div>
        <label htmlFor="fullName" className="mb-1 block text-xs font-medium text-ink-soft">
          Nombre completo
        </label>
        <input
          id="fullName"
          type="text"
          required
          className="input-field"
          value={fullName}
          onChange={(e) => setFullName(e.target.value)}
        />
      </div>

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
          minLength={6}
          className="input-field"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          autoComplete="new-password"
        />
      </div>

      {error && <p className="text-sm text-rust">{error}</p>}

      <button type="submit" disabled={submitting} className="btn-primary">
        {submitting ? 'Creando cuenta…' : 'Crear cuenta'}
      </button>

      <Link to="/login" className="text-center text-xs text-ink-soft hover:text-brass">
        Ya tengo cuenta
      </Link>
    </form>
  )
}
