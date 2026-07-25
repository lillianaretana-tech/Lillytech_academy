import { Link } from 'react-router-dom'

export function NotFoundPage() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-3 bg-paper text-center">
      <p className="font-display text-3xl font-semibold text-ink">404</p>
      <p className="text-sm text-ink-soft">Esta página no existe.</p>
      <Link to="/dashboard" className="btn-primary mt-2">
        Volver al dashboard
      </Link>
    </div>
  )
}
