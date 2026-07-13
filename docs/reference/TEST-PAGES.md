# Page Tests

Page-level integration tests using Vitest and React Testing Library.

**Last Updated:** 2026-07-12 (Conv 392 — [ORPHAN-PURGE] deleted `courses/CourseDetail.test.tsx` (56) with the retired dead-legacy `CourseDetail` component family (unreachable from any route); Pages 10→9, Courses 1→0 (category removed), coverage 15%→13%.)
**Prev:** 2026-07-09 (Conv 378 — [TEST-PAGE-COUNTS] reconciled per-file *case* counts to on-disk `tests/pages/` truth (vitest JSON reporter, 355 cases / 10 files): Login 20→21, Signup 23→24, CreatorDashboard 45→46, StudentDashboard 29→28, TeacherDashboard 46→48; Auth subtotal 70→72. File-count roll-ups unchanged.)
**Prev:** 2026-06-26 (Conv 339 — [OLD-PORTED-CLEANUP] deleted `courses/CourseBrowse.test.tsx` (30) with the retired `/old` CourseBrowse page; Pages 11→10, Courses 2→1, coverage 16%→15%)

---

## Coverage Summary

| Metric | Count |
|--------|------:|
| Astro Pages | 68 |
| Test Files | 9 |
| **Coverage** | **13%** |

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
| Login | `tests/pages/auth/LoginForm.test.tsx` | 21 |
| Signup | `tests/pages/auth/SignupForm.test.tsx` | 24 |
| Password Reset | `tests/pages/auth/PasswordResetForm.test.tsx` | 27 |

**Subtotal:** 3 files, 72 tests

**Note:** LoginForm and SignupForm are modal-only (no page-mode redirect tests). SignupForm no longer tests handle field (removed in Conv 067; handle is auto-generated server-side). Auth modal state machine tested separately in `tests/lib/auth-modal.test.ts` (26 tests).

---

## Creator Pages

| Page | Test File | Tests |
|------|-----------|------:|
| Creator Profile | `tests/pages/creators/CreatorProfile.test.tsx` | 40 |

**Subtotal:** 1 file

*Note: CreatorBrowse test deleted in Conv 111 — `/discover/creators` now 301-redirects to `/discover/members?roles=creator`.*

---

## Dashboard Pages

| Page | Test File | Tests |
|------|-----------|------:|
| Creator Dashboard | `tests/pages/dashboard/CreatorDashboard.test.tsx` | 46 |
| Student Dashboard | `tests/pages/dashboard/StudentDashboard.test.tsx` | 28 |
| Teacher Dashboard | `tests/pages/dashboard/TeacherDashboard.test.tsx` | 48 |

**Subtotal:** 3 files

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
| Teacher Profile | `tests/pages/teachers/TeacherProfile.test.tsx` | 58 |

**Subtotal:** 1 file

*Note: TeacherDirectory test deleted in Conv 111 — `/discover/teachers` now 301-redirects to `/discover/members?roles=teacher`.*

---

## Summary

| Area | Files |
|------|------:|
| Auth | 3 |
| Creators | 1 |
| Dashboard | 3 |
| Onboarding | 1 |
| Teachers | 1 |
| **Total** | **9** |

---

## Related Documentation

- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test coverage index
- [TEST-COMPONENTS.md](TEST-COMPONENTS.md) - Component tests
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands
