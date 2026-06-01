> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 7. Development Workflow & Documentation

### Additive DB Setup Script Naming
**Date:** 2026-03-18 (Conv 006)

DB setup combo scripts follow the pattern `db:setup:{target}:{level}` where each level chains through the previous:
- `db:setup:local` — reset + migrate (production-like base)
- `db:setup:local:dev` — + dev seed
- `db:setup:local:stripe` — + Stripe sandbox accounts
- `db:setup:local:booking` — + booking test scenario
- `db:setup:local:feeds` — + Stream.io activities + D1 feed_activities (Conv 018)
- Same chain for `:staging` variants

**Rationale:** Previous names were ambiguous (`fullsetup` wasn't full, `setup:clean` was unclear, `db:setup:booking` broke the suffix pattern). The base should be minimal — suffixes add layers, not subtract. The chain mirrors data dependency order (booking needs Stripe, Stripe needs dev users).

> **Insight:** This is a general principle for layered tooling — defaults should be the safest/simplest option, with explicit opt-in for each layer of complexity. It prevents accidents (running full dev seed when you wanted production-like) and makes the dependency order self-documenting.

### cert_id vs teacher_id for SQL Alias Renames
**Date:** 2026-03-16 (Session 391)

When renaming `st_id` SQL aliases during TERMINOLOGY-CLEANUP, use `cert_id` for teacher certification record PKs (in SSR loaders) and `teacher_id` for teacher user IDs (in enrollment/earnings APIs). The names should reflect what the value actually represents, not just strip the "st" prefix.

**Rationale:** `st_id` appeared in two distinct contexts with different semantics. In SSR loaders, it's `teacher_certifications.id` (a certification record PK). In enrollment APIs, it's `users.id` (the teacher's user ID). Using `teacher_id` for both would be ambiguous.

**See:** `src/lib/ssr/loaders/teachers.ts` (cert_id). The `teacher_id` alias precedent originally lived in `src/pages/api/me/enrollments.ts` — that endpoint was deleted in Conv 124 when MyCourses migrated to `useCurrentUser()`; the same naming rule still applies to any enrollment/earnings SQL that surfaces a teacher user ID.

### Three-Layout System
**Date:** 2025-12-28

| Layout | Purpose | Header | Footer |
|--------|---------|--------|--------|
| LandingLayout | Public pages | PublicHeader | PublicFooter |
| AppLayout | Authenticated | GatedHeader | GatedFooter |
| AdminLayout | Admin area | AdminSidebar | - |

### Machine Name Standardization
**Date:** 2025-12-28
**Updated:** 2026-02-19 — Renamed `MacMini` → `MacMiniM4-Pro`, added `MacMiniM4`. Retired `MBA-2017`.
**Updated:** 2026-05-21 (Conv 168 [MND]) — Canonical M4Pro form changed `MacMiniM4-Pro` → `MacMiniM4Pro` (no hyphen). Code, hooks, and 8 docs migrated; `dev-env-scan.sh` accepts all three forms for historical-session compat.

Use `MacMiniM4Pro` and `MacMiniM4` as standard machine names in documentation.

**Rationale:** Short, unique enough for grep scanning; enables automated detection. No-hyphen form aligns with PLAN.md and avoids `M4-Pro` parse ambiguity (M4-Pro chip vs Mac-mini-M4 Pro chip).

### Template-Based Project Initialization
**Date:** 2025-12-28

`/q-init` copies from `.claude/templates/` rather than creating from scratch.

**Rationale:** Templates maintained independently; ensures consistency; easy updates.

### Portable vs Project-Specific Docs
**Date:** 2025-12-28

- `/q-docs` - Standard docs, portable across projects
- `/q-local-docs` - Project-specific docs, customized per project

### Startup Checks via CLAUDE.md
**Date:** 2025-12-28

Add "Session Startup Check" section to CLAUDE.md for automatic checks (like RESUME-STATE.md detection).

**Rationale:** Single point of truth; no maintenance burden on individual skills.

### Always Stage All Changes in /q-commit
**Date:** 2026-01-19

Always stage all changes with `git add .` during commits. No selective staging based on perceived task relevance.

**Rationale:** Selective staging leads to orphaned changes that may be forgotten. At session end, all changes in the working directory should be committed together. If changes truly shouldn't be committed, they should be in `.gitignore` or explicitly stashed.

### Capture Planned Work Before Session End
**Date:** 2026-01-20

Use `/q-end-with-plan <description>` or `/q-end-with-plan --recent` when ending a session with planned but unstarted work.

**Rationale:** `/q-end-session` detects pending work via TodoWrite, not conversation context. If planned work isn't in TodoWrite, save state won't be triggered. This skill bridges the gap by generating todos from a description (or from recent discussion via `--recent`) before running the end-session workflow.

**See:** `~/.claude/commands/q-end-with-plan.md`

### Page JSON as Single-Lookup Source of Truth
**Date:** 2026-01-27
**Status:** DEPRECATED — JSON page specs, markdown page specs, PageSpec Astro stubs, and all related scripts/components were deleted in Sessions 307+311. See git history. Route information is in `docs/as-designed/url-routing.md` and `docs/as-designed/route-stories.md`.

Each page's JSON file (`src/data/pages/**/*.json`) served as the single place to find all related file paths.

**Rationale:** Files for one page were scattered across 6+ directory trees. Opening the JSON gave you every path without searching.

### Drop block and status From Page Metadata
**Date:** 2026-01-27

Removed `block` (build sequence number) and `status` (implementation state enum) from `PageMetadataSchema`. Deleted `PageStatusSchema` entirely.

**Rationale:** Block numbers are historical build order, no longer relevant. Status was inconsistently classified between PAGES-MAP.md and JSON. Neither provides ongoing value. PAGES-MAP.md is being repurposed as a lightweight index.

---

