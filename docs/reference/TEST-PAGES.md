# Page Tests

Page-level integration tests using Vitest and React Testing Library.

**Last Updated:** 2026-03-16 (Session 390 — reconciled counts)

---

## Coverage Summary

| Metric | Count |
|--------|------:|
| Astro Pages | 68 |
| Test Files | 14 |
| **Coverage** | **19%** |

*See [TEST-COVERAGE.md](TEST-COVERAGE.md) for detailed coverage gaps by page group.*

---

## Overview

Page tests validate complete page flows including:
- Page rendering with all sections
- User journeys (multi-step interactions)
- Form validation and submission
- Navigation and redirects
- Error handling and empty states

---

## Test Categories

Each page test follows 6 standard categories (documented in `tests/README.md`):

1. **Rendering** - Elements appear correctly
2. **Interaction/Search** - User can interact with controls
3. **Validation/Filtering** - Form/input validation works
4. **Submission/Sorting** - API calls or sort behavior
5. **Navigation/Pagination** - Redirects or page nav
6. **Error Handling/Empty State** - Error display

---

## Auth Pages

| Page | Test File | Tests |
|------|-----------|------:|
| Login | `tests/pages/auth/LoginForm.test.tsx` | 20 |
| Signup | `tests/pages/auth/SignupForm.test.tsx` | 25 |
| Password Reset | `tests/pages/auth/PasswordResetForm.test.tsx` | 27 |

**Subtotal:** 3 files, 72 tests

**Note:** LoginForm and SignupForm are modal-only (no page-mode redirect tests). Auth modal state machine tested separately in `tests/lib/auth-modal.test.ts` (28 tests).

---

## Course Pages

| Page | Test File | Tests |
|------|-----------|------:|
| Course Browse | `tests/pages/courses/CourseBrowse.test.tsx` | 30 |
| Course Detail | `tests/pages/courses/CourseDetail.test.tsx` | 56 |

**Subtotal:** 2 files

---

## Creator Pages

| Page | Test File | Tests |
|------|-----------|------:|
| Creator Browse | `tests/pages/creators/CreatorBrowse.test.tsx` | 33 |
| Creator Profile | `tests/pages/creators/CreatorProfile.test.tsx` | 40 |

**Subtotal:** 2 files

---

## Dashboard Pages

| Page | Test File | Tests |
|------|-----------|------:|
| Creator Dashboard | `tests/pages/dashboard/CreatorDashboard.test.tsx` | 45 |
| Student Dashboard | `tests/pages/dashboard/StudentDashboard.test.tsx` | 29 |
| Teacher Dashboard | `tests/pages/dashboard/TeacherDashboard.test.tsx` | 46 |

**Subtotal:** 3 files

---

## Profile Pages

| Page | Test File | Tests |
|------|-----------|------:|
| User Profile | `tests/pages/profile/UserProfile.test.tsx` | 36 |

**Subtotal:** 1 file

---

## Onboarding Pages

| Page | Test File | Tests |
|------|-----------|------:|
| Onboarding | `tests/pages/onboarding/onboarding.test.ts` | 7 |

**Subtotal:** 1 file

---

## Teacher Pages

| Page | Test File | Tests |
|------|-----------|------:|
| Teacher Directory | `tests/pages/teachers/TeacherDirectory.test.tsx` | 35 |
| Teacher Profile | `tests/pages/teachers/TeacherProfile.test.tsx` | 40 |

**Subtotal:** 2 files

---

## Summary

| Area | Files |
|------|------:|
| Auth | 3 |
| Courses | 2 |
| Creators | 2 |
| Dashboard | 3 |
| Onboarding | 1 |
| Profile | 1 |
| Teachers | 2 |
| **Total** | **14** |

---

## Related Documentation

- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test coverage index
- [TEST-COMPONENTS.md](TEST-COMPONENTS.md) - Component tests
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands
