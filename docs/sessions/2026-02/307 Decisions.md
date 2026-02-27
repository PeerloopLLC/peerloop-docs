# Session Decisions - 2026-02-27

## 1. Single Comprehensive Deletion Manifest
**Type:** Strategic
**Topics:** docs-infra, workflow

**Trigger:** Phase 4 of STORY-REMAP required creating MARKED-FOR-DELETION manifests for multiple categories of dead files.

**Options Considered:**
1. Separate manifest per category (4a, 4b, 4c, 4d) — one file per section
2. Single comprehensive manifest with sections ← Chosen
3. Inline deletion lists in CURRENT-BLOCK-PLAN.md

**Decision:** Created a single `docs/reference/MARKED-FOR-DELETION.md` with 5 sections (A-E) covering all 249 files, plus a summary table and execution order.

**Rationale:** A single document is easier to review as a whole, shows the total scope (249 files), and provides a clear execution order. The user needs to see the complete picture before approving any deletion.

**Consequences:** One file to review, one approval needed. Execution order is documented within the manifest itself.

---

## 2. Archive vs Delete Strategy
**Type:** Strategic
**Topics:** docs-infra

**Trigger:** JSON page specs and page metadata have historical value (screenshots, design decisions embedded in JSON) but are no longer used by the application.

**Options Considered:**
1. Delete everything outright
2. Archive data files, delete code files ← Chosen
3. Keep everything but add deprecation headers

**Decision:** JSON page specs and page metadata (Sections A and D) will be archived to `docs/archive/`. Code components and scripts (Sections B and C) will be deleted.

**Rationale:** JSON specs contain embedded design decisions and the page metadata includes screenshots — these have historical/reference value. Code files (components, scripts) have no value once the system they serve is removed.

**Consequences:** Need to create `docs/archive/json-page-specs/` and `docs/archive/pages/` directories during execution.

---

## 3. Session Logs Are Historical Records
**Type:** Strategic
**Topics:** docs-infra

**Trigger:** Stale reference grep found ~200 mentions of `src/data/pages/` in session logs under `docs/sessions/`.

**Options Considered:**
1. Update session logs to remove stale references
2. Leave session logs untouched — they're historical ← Chosen
3. Add deprecation notes to affected session logs

**Decision:** Session logs are never modified after creation. They document what happened at that point in time.

**Rationale:** Session logs are immutable historical records. Editing them to remove stale references would rewrite history and undermine their value as an audit trail. The references were accurate when the session occurred.

**Consequences:** `src/data/pages/` will appear in old session logs indefinitely. This is expected and correct.
