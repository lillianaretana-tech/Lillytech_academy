import { Outlet } from 'react-router-dom'

export function AuthLayout() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-paper px-4">
      <div className="w-full max-w-sm">
        <div className="mb-8 text-center">
          <p className="font-display text-2xl font-semibold text-ink">LillyTech</p>
          <p className="text-xs uppercase tracking-wide text-brass">Learning Academy</p>
        </div>
        <div className="card">
          <Outlet />
        </div>
      </div>
    </div>
  )
}
