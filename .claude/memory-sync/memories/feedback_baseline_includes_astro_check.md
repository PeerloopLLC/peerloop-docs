---
name: Baselines must include astro check — Conv 104 incident pointer
description: Primary rule lives in CLAUDE.md §Baseline Verification. This file retains the Conv 104 incident detail and the CI workflow change.
type: feedback
originSessionId: 2c360464-0c38-4f6e-ad84-a2f6567211fe
---
**Primary rule is in CLAUDE.md** — see §Baseline Verification (5-gate definition, verify-this-conv discipline).

**Conv 104 incident detail (kept here):**

- `tsc --noEmit` was green; `npm run check` (astro check) reported 10 type errors in `.astro` pages (CourseTag triple-definition + 2 one-offs) plus 27 hints
- Errors had been invisible through Conv 100–103 because `astro check` was never in:
  - The local in-conv baseline habit (tsc/test/build only)
  - `.github/workflows/ci.yml` (ran lint → typecheck → test → build → e2e)
  - Any `/r-end` or `/r-commit` gate
- The 10 .astro errors likely drifted in during the TERMINOLOGY rename block (Sessions 346-356) or the CourseTag type extraction refactor; flagged as `[AC]` for fix before `[P6]` PR merge
- CI was updated Conv 104 to run `npm run check` in the `lint-and-typecheck` job

**User principle:** *"We don't want to bypass issues as we do upgrades, refactors, etc, or really ever."*
