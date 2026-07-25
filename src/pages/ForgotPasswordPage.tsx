import { useState, type FormEvent } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '@/features/auth/hooks/useAuth'

export function ForgotPasswordPage() {
  const { requestPasswordReset } = useAuth()
  const [email, setEmail] = useState('')
  const [status, setStatus] = useState<'idle' | 'sent' | 'error'>('idle')
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  async function handleSubmit(e: FormEvent) {
    e.preventDefault()
    setSubmitting(true)
    const { error } = await requestPasswordReset(email)
    setSubmitting(false)
    if (error) {
      setError(error)
      setStatus('error')
      return
    }
    setStatus('sent')
  }

  if (status === 'sent') {
    return (
      <div className="text-center">
        <p className="text-sm text-ink">
          Si el correo existe, te enviamos un enlace para restablecer tu contraseña.
        </p>
        <Link to="/login" className="mt-4 inline-block text-xs text-brass hover:underline">
          Volver a iniciar sesión
        </Link>
      </div>
    )
  }

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-4">
      <h1 className="text-center text-lg font-semibold text-ink">Recuperar contraseña</h1>
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
        />
      </div>
      {error && <p className="text-sm text-rust">{error}</p>}
      <button type="submit" disabled={submitting} className="btn-primary">
        {submitting ? 'Enviando…' : 'Enviar enlace'}
      </button>
      <Link to="/login" className="text-center text-xs text-ink-soft hover:text-brass">
        Volver a iniciar sesión
      </Link>
    </form>
  )
}
