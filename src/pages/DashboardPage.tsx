export function DashboardPage() {
  return (
    <div>
      <h1 className="mb-1 font-display text-2xl font-semibold text-ink">Dashboard</h1>
      <p className="mb-6 text-sm text-ink-soft">
        Tu avance general, la ruta activa y la próxima lección recomendada aparecerán aquí.
      </p>

      <div className="card">
        <p className="text-sm text-ink-soft">
          Todavía no hay datos de progreso — esta vista se conecta a{' '}
          <code className="rounded bg-paper-muted px-1 py-0.5">learning_paths</code>,{' '}
          <code className="rounded bg-paper-muted px-1 py-0.5">enrollments</code> y{' '}
          <code className="rounded bg-paper-muted px-1 py-0.5">lesson_progress</code> en la Fase 4,
          una vez existan las tablas (Fase 3).
        </p>
      </div>
    </div>
  )
}
