import { Navigate, Route, Routes } from 'react-router-dom'
import { AuthLayout } from '@/layouts/AuthLayout'
import { AppLayout } from '@/layouts/AppLayout'
import { ProtectedRoute } from './ProtectedRoute'
import { AdminRoute } from './AdminRoute'
import { LoginPage } from '@/pages/LoginPage'
import { SignupPage } from '@/pages/SignupPage'
import { ForgotPasswordPage } from '@/pages/ForgotPasswordPage'
import { DashboardPage } from '@/pages/DashboardPage'
import { LibraryPage } from '@/pages/LibraryPage'
import { LessonPage } from '@/pages/LessonPage'
import { ConceptsLibraryPage } from '@/pages/ConceptsLibraryPage'
import { ConceptDetailPage } from '@/pages/ConceptDetailPage'
import { BitacoraPage } from '@/pages/BitacoraPage'
import { SearchPage } from '@/pages/SearchPage'
import { ProjectsPage } from '@/pages/ProjectsPage'
import { NotesPage } from '@/pages/NotesPage'
import { AdminContentPage } from '@/pages/admin/AdminContentPage'
import { AdminLessonEditPage } from '@/pages/admin/AdminLessonEditPage'
import { AdminProgressPage } from '@/pages/admin/AdminProgressPage'
import { AdminConceptsPage } from '@/pages/admin/AdminConceptsPage'
import { AdminConceptEditPage } from '@/pages/admin/AdminConceptEditPage'
import { NotFoundPage } from '@/pages/NotFoundPage'

export function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<Navigate to="/dashboard" replace />} />

      <Route element={<AuthLayout />}>
        <Route path="/login" element={<LoginPage />} />
        <Route path="/signup" element={<SignupPage />} />
        <Route path="/forgot-password" element={<ForgotPasswordPage />} />
      </Route>

      <Route element={<ProtectedRoute />}>
        <Route element={<AppLayout />}>
          <Route path="/dashboard" element={<DashboardPage />} />
          <Route path="/library" element={<LibraryPage />} />
          <Route path="/lesson/:lessonId" element={<LessonPage />} />
          <Route path="/concepts" element={<ConceptsLibraryPage />} />
          <Route path="/concepts/:conceptId" element={<ConceptDetailPage />} />
          <Route path="/bitacora" element={<BitacoraPage />} />
          <Route path="/search" element={<SearchPage />} />
          <Route path="/projects" element={<ProjectsPage />} />
          <Route path="/notes" element={<NotesPage />} />

          <Route element={<AdminRoute />}>
            <Route path="/admin" element={<AdminContentPage />} />
            <Route path="/admin/lessons/:lessonId" element={<AdminLessonEditPage />} />
            <Route path="/admin/progress" element={<AdminProgressPage />} />
            <Route path="/admin/concepts" element={<AdminConceptsPage />} />
            <Route path="/admin/concepts/:conceptId" element={<AdminConceptEditPage />} />
          </Route>
        </Route>
      </Route>

      <Route path="*" element={<NotFoundPage />} />
    </Routes>
  )
}
