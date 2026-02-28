# Session Decisions - 2026-02-28

## 1. Delete PageSpec Archive Rather Than Maintain It
**Type:** Strategic
**Topics:** docs-infra

**Trigger:** After archiving 312 files (17MB) across Sessions 307-311, questioned whether `docs/archive/` served any purpose.

**Options Considered:**
1. Keep archive for easy browsing without git commands
2. Delete archive, rely on git history ← Chosen

**Decision:** Deleted the entire `docs/archive/` directory. Git history is the archive.

**Rationale:** The archive contained only superseded PageSpec artifacts (JSON specs, markdown specs, Astro stubs, page metadata). Nothing references it, nothing depends on it. Pages are now implemented as real Astro components. Git preserves the full history with commit context.

**Consequences:** 312 files / 17MB removed from repo. All `docs/archive/` references in CLAUDE.md, PLAYBOOK.md, BEST-PRACTICES.md, DECISIONS.md, SCRIPTS.md, and PAGES-INDEX.md updated to point to git history.

---

## 2. Delete Four PageSpec-Dependent Skills
**Type:** Implementation
**Topics:** cc-workflow, docs-infra

**Trigger:** User identified that `/L-convert-page`, `/L-verify-page`, `/L-page-links`, and `/L-consolidate-page` depended on the old page-code system that no longer exists.

**Options Considered:**
1. Update skills to work with current Astro pages
2. Delete skills entirely ← Chosen

**Decision:** Deleted all four skills. They were tightly coupled to the old PageSpec system (page codes, JSON specs, `docs/pages/` metadata) with no path to adaptation.

**Rationale:** The skills assumed a page-code-driven workflow (ABOU, SGUP, etc.) that no longer exists. Pages are now real Astro components. Building new equivalents would be a separate effort with different requirements.

**Consequences:** Removed from `.claude/commands/`. References cleaned from DECISIONS.md.

---

## 3. Delete Three Dead Audit Scripts
**Type:** Implementation
**Topics:** docs-infra

**Trigger:** Session 307's manifest flagged `audit-api-coverage.mjs`, `audit-test-sufficiency.mjs`, and `reconcile-planned-apis.mjs` as "may need updating." Reading the code revealed they were 100% dependent on deleted inputs.

**Options Considered:**
1. Rewrite scripts to use current data sources
2. Delete scripts ← Chosen

**Decision:** Deleted all three scripts. Their entire input pipeline (`src/data/pages/`, `scripts/page-tests/`) was deleted in Session 307.

**Rationale:** The scripts had zero useful code paths remaining — every function read from deleted directories. "Updating" would mean rewriting from scratch with different data sources, which is a new feature, not maintenance.

**Consequences:** Removed from `Peerloop/scripts/`. Entries removed from `docs/reference/SCRIPTS.md`.
