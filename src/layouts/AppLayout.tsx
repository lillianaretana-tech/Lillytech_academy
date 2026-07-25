import { useState } from 'react'
import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '@/features/auth/hooks/useAuth'

const navItems = [
  { to: '/dashboard', label: 'Dashboard' },
  { to: '/library', label: 'Biblioteca' },
  { to: '/concepts', label: 'Conceptos' },
  { to: '/projects', label: 'Proyectos' },
  { to: '/notes', label: 'Notas' },
  { to: '/bitacora', label: 'Bitácora' },
]

const adminNavItems = [{ to: '/admin', label: 'Administración' }]

export function AppLayout() {
  const { isAdmin, signOut, user } = useAuth()
  const navigate = useNavigate()
  const [mobileOpen, setMobileOpen] = useState(false)
  const [globalQuery, setGlobalQuery] = useState('')

  function handleGlobalSearch(e: React.FormEvent) {
    e.preventDefault()
    if (!globalQuery.trim()) return
    navigate(`/search?q=${encodeURIComponent(globalQuery.trim())}`)
    setMobileOpen(false)
  }

  const items = [...navItems, ...(isAdmin ? adminNavItems : [])]

  const linkClasses = ({ isActive }: { isActive: boolean }) =>
    `block rounded-md px-3 py-2 text-sm font-medium transition-colors ${
      isActive ? 'bg-brass/15 text-brass-dark' : 'text-ink-soft hover:bg-paper-muted'
    }`

  return (
    <div className="flex min-h-screen bg-paper">
      {/* Sidebar — escritorio */}
      <aside className="hidden w-64 flex-shrink-0 border-r border-ink/10 bg-white/50 p-5 md:flex md:flex-col">
        <div className="mb-8">
          <p className="font-display text-lg font-semibold text-ink">LillyTech</p>
          <p className="text-xs uppercase tracking-wide text-brass">Learning Academy</p>
        </div>
        <form onSubmit={handleGlobalSearch} className="mb-4">
          <input
            className="input-field text-xs"
            placeholder="Buscar en todo…"
            value={globalQuery}
            onChange={(e) => setGlobalQuery(e.target.value)}
          />
        </form>
        <nav className="flex flex-1 flex-col gap-1">
          {items.map((item) => (
            <NavLink key={item.to} to={item.to} className={linkClasses}>
              {item.label}
            </NavLink>
          ))}
        </nav>
        <div className="border-t border-ink/10 pt-4">
          <p className="mb-2 truncate text-xs text-ink-soft">{user?.email}</p>
          <button onClick={signOut} className="btn-secondary w-full text-xs">
            Cerrar sesión
          </button>
        </div>
      </aside>

      {/* Topbar — móvil */}
      <div className="flex flex-1 flex-col">
        <header className="flex items-center justify-between border-b border-ink/10 bg-white/50 px-4 py-3 md:hidden">
          <div>
            <p className="font-display text-base font-semibold text-ink">LillyTech</p>
            <p className="text-[10px] uppercase tracking-wide text-brass">Learning Academy</p>
          </div>
          <button
            onClick={() => setMobileOpen((v) => !v)}
            className="rounded-md border border-ink/15 px-3 py-1.5 text-sm"
            aria-label="Abrir menú"
          >
            Menú
          </button>
        </header>

        {mobileOpen && (
          <nav className="flex flex-col gap-1 border-b border-ink/10 bg-white/70 p-4 md:hidden">
            <form onSubmit={handleGlobalSearch} className="mb-2">
              <input
                className="input-field text-xs"
                placeholder="Buscar en todo…"
                value={globalQuery}
                onChange={(e) => setGlobalQuery(e.target.value)}
              />
            </form>
            {items.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                className={linkClasses}
                onClick={() => setMobileOpen(false)}
              >
                {item.label}
              </NavLink>
            ))}
            <button onClick={signOut} className="btn-secondary mt-2 text-xs">
              Cerrar sesión
            </button>
          </nav>
        )}

        <main className="flex-1 p-5 md:p-8">
          <Outlet />
        </main>
      </div>
    </div>
  )
}
