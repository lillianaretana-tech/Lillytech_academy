export function NotesPage() {
  return (
    <div>
      <h1 className="mb-1 font-display text-2xl font-semibold text-ink">Notas</h1>
      <p className="mb-6 text-sm text-ink-soft">Todas tus notas personales, por lección.</p>

      <div className="card">
        <p className="text-sm text-ink-soft">
          Se conecta a <code className="rounded bg-paper-muted px-1 py-0.5">personal_notes</code>{' '}
          en la Fase 4.
        </p>
      </div>
    </div>
  )
}
