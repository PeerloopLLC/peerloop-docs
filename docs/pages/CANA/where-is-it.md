# CANA (Creator Analytics) — File & Folder Inventory

> **Purpose:** Complete inventory of every file where CANA page details can be found, for consolidation planning.
>
> **Generated:** 2026-01-27 | **Total files:** ~47

---

## 1. Page Specifications (2 files)

| File | What It Contains |
|------|-----------------|
| `src/data/pages/dashboard/creator/analytics.json` | Runtime JSON spec — metadata, connections, data requirements, sections, user stories, test coverage |
| `docs/pagespecs/dashboard/creator/CANA.md` | Markdown spec — mirrors JSON in human-readable form with API examples |

## 2. Page Documentation & Audit (2 files)

| File | What It Contains |
|------|-----------------|
| `docs/pages/CANA/CANA.md` | Page summary — features, sections, API endpoints, status |
| `docs/pages/CANA/AUDIT-CANA.md` | Test audit report (2026-01-27) — ✅ Safe to modify, 181 tests, blind spots |

## 3. Astro Route (1 file)

| File | What It Contains |
|------|-----------------|
| `src/pages/dashboard/creator/analytics.astro` | Frontend route — loads `CreatorAnalytics` React component with breadcrumbs/layout |

## 4. React Components (8 files)

| File | Role |
|------|------|
| `src/components/analytics/CreatorAnalytics.tsx` | **Orchestrator** — fetches data, manages period/course filtering, renders 7 children |
| `src/components/analytics/MetricsRow.tsx` | 5 metric cards with change indicators |
| `src/components/analytics/EnrollmentTrendsChart.tsx` | Area chart with revenue overlay |
| `src/components/analytics/CoursePerformanceTable.tsx` | Table with 6 columns |
| `src/components/analytics/FunnelAnalysis.tsx` | Funnel visualization with conversion rates |
| `src/components/analytics/ProgressDistribution.tsx` | Pie chart of student progress |
| `src/components/analytics/SessionAnalytics.tsx` | 4 metrics + bar chart |
| `src/components/analytics/STPerformanceTable.tsx` | S-T leaderboard with 7 columns |

## 5. API Endpoints (7 files)

| File | Endpoint |
|------|----------|
| `src/pages/api/me/creator-analytics.ts` | `GET /api/me/creator-analytics` (summary) |
| `src/pages/api/me/creator-analytics/courses.ts` | `.../courses` |
| `src/pages/api/me/creator-analytics/enrollments.ts` | `.../enrollments` |
| `src/pages/api/me/creator-analytics/funnel.ts` | `.../funnel` |
| `src/pages/api/me/creator-analytics/progress.ts` | `.../progress` |
| `src/pages/api/me/creator-analytics/sessions.ts` | `.../sessions` |
| `src/pages/api/me/creator-analytics/st-performance.ts` | `.../st-performance` |

## 6. Component Tests (8 files, 127 tests)

| File | Tests |
|------|-------|
| `tests/components/analytics/CreatorAnalytics.test.tsx` | 32 (orchestrator) |
| `tests/components/analytics/CoursePerformanceTable.test.tsx` | 19 |
| `tests/components/analytics/STPerformanceTable.test.tsx` | 18 |
| `tests/components/analytics/SessionAnalytics.test.tsx` | 14 |
| `tests/components/analytics/EnrollmentTrendsChart.test.tsx` | 13 |
| `tests/components/analytics/FunnelAnalysis.test.tsx` | 11 |
| `tests/components/analytics/MetricsRow.test.tsx` | 11 |
| `tests/components/analytics/ProgressDistribution.test.tsx` | 9 |

## 7. API Tests (7–8 files, 54 tests)

| File | Tests |
|------|-------|
| `tests/api/me/creator-analytics/index.test.ts` | 9 |
| `tests/api/me/creator-analytics/courses.test.ts` | 10 |
| `tests/api/me/creator-analytics/enrollments.test.ts` | 7 |
| `tests/api/me/creator-analytics/funnel.test.ts` | 7 |
| `tests/api/me/creator-analytics/progress.test.ts` | 7 |
| `tests/api/me/creator-analytics/sessions.test.ts` | 7 |
| `tests/api/me/creator-analytics/st-performance.test.ts` | 7 |
| `tests/api/me/creator-analytics.test.ts` | (legacy/root level) |

## 8. Test Script (1 file)

| File | What It Contains |
|------|-----------------|
| `scripts/page-tests/test-CANA.sh` | Bash runner — runs all 181 tests, supports `--quick` mode |

## 9. Planning & Cross-Reference Files (mentions CANA)

| File | What's Referenced |
|------|-------------------|
| `PAGES-MAP.md` | Route, status ✅, block 8, JSON/spec paths |
| `PLAN.md` | Session 83, 116, 129 entries; test coverage JSON |
| `COMPLETED_PLAN.md` | Notes STAnalytics reuses CANA chart components |
| `research/run-001/SCOPE.md` | CANA section heading |
| `research/run-001/PAGES-INDEX.md` | CANA entry with doc links |
| `research/run-001/ACCESS-MATRIX.md` | CANA — Creator only |
| `research/run-001/FEATURE-FLAGS.md` | Listed under Pages |
| `research/run-001/features/features-block-9.md` | F-CANA-001 through F-CANA-006 |
| `research/run-001/STORY-DEPENDENCIES.md` | CANA enabled by NOTF, SETT, PROF |

## 10. Session Log

| File | What It Contains |
|------|-----------------|
| `docs/sessions/2026-01/2026-01-27_13-56-37_Dev.md` | Session 129 — strengthened CANA tests from 69→181 |

---

## Summary

| Category | Files | Notes |
|----------|------:|-------|
| Specifications | 2 | JSON + Markdown (overlapping content) |
| Documentation | 2 | Page doc + audit report |
| Astro page | 1 | Route entry point |
| React components | 8 | 1 orchestrator + 7 children |
| API endpoints | 7 | All under `/api/me/creator-analytics/` |
| Component tests | 8 | 127 tests |
| API tests | 7–8 | 54 tests |
| Test script | 1 | Shell runner |
| Cross-references | 9+ | PLAN, PAGES-MAP, research docs |
| Session logs | 1 | Session 129 |
| **Total** | **~47** | |

## Consolidation Notes

Documentation is spread across **6 distinct locations**:
1. `src/data/pages/` — JSON spec (runtime)
2. `docs/pagespecs/` — Markdown spec (design)
3. `docs/pages/CANA/` — Page doc + audit
4. `research/run-001/` — Scope, features, access matrix
5. `PAGES-MAP.md` — Route/status lookup
6. `PLAN.md` — Session history references

The source code and tests are already well-organized under `analytics/` folders. The main consolidation opportunity is in the documentation layer.
