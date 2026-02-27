# Session Learnings - 2026-02-27

## 1. PageSpec System Dependency Chain
**Topics:** docs-infra, astro

**Context:** Phase 4 of STORY-REMAP required identifying all dead files from the old PageSpec system to create a deletion manifest.

**Learning:** The PageSpec system forms a clear dependency chain: `SpecPanelToggle.tsx` (imported in layouts) → toggles `PageSpecView.astro` → imports `page-spec-validator.ts` → imports `page-spec.ts` (Zod schema) → exports types via `types/page-spec.ts`. No Astro pages import PageSpecView directly — the layouts (`LandingLayout`, `LegacyAppLayout`) import SpecPanelToggle, which is guarded by a `pageCode` prop check. This means the entire chain is safe to remove as long as the layout imports are cleaned up first.

**Pattern:** When auditing dead code for deletion, trace the full import chain from entry points (layouts/pages) rather than just grepping for individual file names. The dependency direction reveals safe deletion order.

---

## 2. Scripts with Mixed Concerns Need Separate Treatment
**Topics:** docs-infra, workflow

**Context:** Several scripts in `Peerloop/scripts/` reference `src/data/pages/` or PageSpec patterns but serve broader purposes.

**Learning:** Three scripts (`audit-api-coverage.mjs`, `audit-test-sufficiency.mjs`, `reconcile-planned-apis.mjs`) reference page specs internally but aren't dead — they perform broader auditing functions. They were correctly excluded from the deletion manifest but flagged as needing updates post-deletion. Distinguishing "uses the data" from "only exists to serve the data" is the key test for marking something dead vs needs-updating.

---

## 3. Stale Reference Categorization Strategy
**Topics:** docs-infra, dual-repo

**Context:** Grep found ~300 lines referencing `src/data/pages/` across the docs repo. Deciding what to do with each was the challenge.

**Learning:** Stale references fall into three clean categories: (1) **Session logs** — historical, never modify; (2) **Files already in the deletion manifest** — will be archived/deleted, references die with them; (3) **Live docs** — need cleanup after deletion, not before. Trying to clean up references before the deletion creates churn (files you're about to archive get edited first). The right sequence is: delete first, clean references second.

---

## 4. Route Verification Yields Useful Drift Detection
**Topics:** docs-infra, workflow

**Context:** Phase 6 required verifying that ROUTE-STORIES.md covers all routes from tech-021-url-routing.md.

**Learning:** The comparison revealed that tech-021 is missing 3 routes added after its last update (`/teaching/availability`, `/creating/earnings`, `/invite/mod/[token]`). This is useful drift detection — the route authority doc (tech-021) needs periodic reconciliation with what actually exists in the codebase. ROUTE-STORIES.md, being newer, caught routes that tech-021 hadn't documented yet.
