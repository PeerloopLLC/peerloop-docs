# State — Conv 169 (2026-05-21 ~15:46)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Two-track conv: (1) closed cross-block follow-ups — [RAM-NONAV-SWEEP] (19 .astro `noNav` annotations, scanner zero-warning, tsc+astro check green); [PROD-PW-APPLY] audit revealed prod D1 drift (missing 0003 + 0004, stale 0002 tracker name) so redirected the rotation into a new `DEPLOYMENT.DB-SYNC` sub-block bundling all 4 prod-D1 mutations + the password rotation as one atomic step. (2) Pre-plan intake for the Matt design push — situation captured, branch plan locked (`jfg-dev-13-matt` from `jfg-dev-12`), `/matt/` route base agreed, tokens-as-future-global-default decision made. Figma MCP setup blocked tonight by viewer-seat limitation (not Brian's paid setup yet); user worked around via 229-file SVG/PNG batch export to `.scratch/matt-figma/`. `_INVENTORY.md` and `overview/pages-panel.md` persisted for next-conv orientation.

## Completed

- [x] [RAM-NONAV-SWEEP] — 19 .astro files annotated with `export const noNav = true;` + reason comment; scanner reports `ℹ️ no-nav by design` for all 20 routes (incl. Conv 168's tab.astro); zero `⚠️` warnings; tsc + astro check green
- [x] [PROD-PW-APPLY] — Redirected into new DEPLOYMENT.DB-SYNC sub-block (PLAN.md); seed file edit reverted; no in-flight disagreement between seed and prod
- [x] Matt design intake — captured situation, four directives, branch plan, route plan, style scope. Pre-export gathered (229 SVG/PNG files, 137 MB). Inventory + page-panel notes persisted to `.scratch/matt-figma/`

## Remaining

### BBB-RECORDING (carry-forward, external-blocked)

- [ ] **[BR-ZERO-REPRO]** Reproduce 0-min empty-but-published recording state — needs fresh BBB test session
- [ ] **[BR-STATUS]** [Opus] Add `sessions.recording_status` column with enum `none | requested | capturing | processing | published | failed | empty` — awaits [BR-ZERO-REPRO] + Blindside follow-up

### DEPLOYMENT.DB-SYNC (new — added Conv 169; apply when DEPLOYMENT block is actively worked)

- [ ] **[DB-SYNC-04]** Apply `migrations/0004_feed_activity_index.sql` to prod via `wrangler d1 execute peerloop-db --remote --file migrations/0004_feed_activity_index.sql`. Creates `feed_visits` + `feed_activities` tables + 2 indexes. Then insert tracker row.
- [ ] **[DB-SYNC-03]** Insert tracker row for `0003_fix_session_times.sql` without running the SQL (data already converged on prod — `sessions_missing_z = 0`)
- [ ] **[DB-SYNC-02-RENAME]** Rename stale `0002_seed.sql` → `0002_seed_core.sql` in prod `d1_migrations` table (cosmetic — silences `wrangler d1 migrations list` false-positive)
- [ ] **[PROD-PW-APPLY]** Execute the deferred Peerloop2 rotation against prod admin — 3 steps bundled with DB-SYNC: (1) edit `migrations/0002_seed_core.sql:172` with Peerloop2 hash `$2b$10$tQMUTTuSbJiuqpITHrCN7.PMrqqkJTZROlbhZkPfvLKYEtcAsflXi`; (2) `wrangler d1 execute peerloop-db --remote --command="UPDATE users SET password_hash = '<hash>' WHERE id = 'usr-admin'"`; (3) verify login as `admin@peerloop.com / Peerloop2`
- [ ] **[DB-SYNC-VERIFY]** Final convergence check: `wrangler d1 migrations list peerloop-db --remote` reports "No migrations to apply"; `feed_visits` + `feed_activities` exist; `usr-admin` hash prefix = `$2b$10$tQMU...`

### Matt design push (new — pre-plan complete; planning + execution in next 2 convs)

- [ ] **[MATT-MCP-RETRY]** Re-attempt Figma MCP setup at conv-start of next conv after Brian's paid Figma account is provisioned and a Dev seat is assigned. Hypothesis: viewer's own seat needs Dev Mode capability, not just file-level Dev Mode access. If MCP works: `claude mcp add` config + restart. If still missing: fall back to SVG extraction from `.scratch/matt-figma/`.
- [ ] **[MATT-INVENTORY-CLEANUP]** Triage `.scratch/matt-figma/` next conv. Specific items: (1) move `tokens/color-guide/typograhy-overview.png` → `tokens/typography/typography-overview.png` (fix typo + location); (2) identify which top-level `happy path/Frame N.svg` items are real screens vs supporting design assets; (3) confirm `Content/Happy/` 31 SVGs are the canonical screen library.
- [ ] **[MATT-PRE-PLAN]** Next conv main work: read `.scratch/matt-figma/_INVENTORY.md`, retry MCP, then plan: (a) `/matt/*` route map mapped to current Peerloop routes + net-new pages, (b) token extraction strategy (CSS custom properties + Tailwind theme extension; consume from `tokens/color-guide/Generated with plugin_ Color Variable Style-Guide Generator.svg` + `tokens/typography/{Body,Headers}.svg`), (c) responsive breakpoint encoding from `layout/Mobile page structure _= 640px.svg` + `layout/Desktop/Tablet page structure _ 1025.svg`, (d) component library mapping (Matt's `components/*.svg` → `src/components/matt/*`), (e) `MattLayout.astro` design.

### Other carry-forwards (external-blocked / watch-only)

- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in ClientRouter — WAITING on upstream Astro fix post-6.3.6. Verification probe after each Astro upgrade: `curl http://localhost:4321/ | grep -oE 'src="[^"]*ClientRouter[^"]*"'` (non-absolute = fixed)
- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings — self-resolved Conv 165, investigate only if recurs

## TodoWrite Items

- [ ] #1: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state
- [ ] #2: [BR-STATUS] Add sessions.recording_status enum column [Opus]
- [ ] #3: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] #4: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings

## Key Context

**Pre-commit state (will be committed in Step 6):**
- **Docs repo:** PLAN.md (DEPLOYMENT.DB-SYNC sub-block added, [RAM-NONAV-SWEEP] checked off, [PROD-PW-APPLY] redirected, Last Updated rewritten); RESUME-STATE.md deleted by /r-start (this file will be re-created post-commit); docs/as-designed/route-api-map.md (regenerated by scanner — 20 routes flipped to `ℹ️ no-nav by design`); docs/DECISIONS.md (noNav entry updated to Conv 169 completion state); session files (Extract pruned to 210 lines, Learnings.md, Decisions.md, TIMELINE.md entries).
- **Code repo:** 19 .astro files with `noNav` annotation; package-lock.json (npm install at /r-start).

**Baseline state (NOT re-verified post-edit):** tsc --noEmit + npm run check were run after [RAM-NONAV-SWEEP] edits — both clean. Full 5-gate baseline (lint, test, build) not re-verified this conv. Conv 168's 6453/6453 tests + 5-gate baseline green was carried forward; none of Conv 169's edits touched src/ runtime code in ways that would break tests.

**[RAM-NONAV-SWEEP] context:** Pattern is `// <one-line reason>` + `export const noNav = true;` in .astro frontmatter, read by `parseNoNav()` at `scripts/route-api-map.mjs:90-105`. Categories: footer/marketing 14, error 1, admin 1, 301-redirects 3.

**[PROD-PW-APPLY] context:** Prod D1 drift discovered Conv 169 — the seed split rename (`0002_seed.sql` → `0002_seed_core.sql`) left prod's d1_migrations tracker with the old name. Both 0003 and 0004 are NOT in prod's tracker; 0004's tables (`feed_visits`, `feed_activities`) are physically absent. Procedure to apply DB-SYNC bundled in PLAN.md (`## Active: DEPLOYMENT` → `### DEPLOYMENT.DB-SYNC`).

**Matt design push context:**
- Branch plan: `jfg-dev-13-matt` forked from `jfg-dev-12` at next conv start
- Route plan: temporary `/matt/` top-level coexisting with current pages; eventual flip `/matt/` → `/`, current `/` → `/fraser`
- Style scope: tokens designed as future-global default (CSS custom properties + Tailwind theme extension); only `/matt/*` routes consume them via a new `MattLayout.astro`; existing layouts untouched
- Figma access: Dev Mode confirmed on Matt's file via 3-day shared window, but MCP toggle missing from user's Figma desktop Preferences (v126.3.12) — hypothesis: viewer's own seat needs Dev Mode capability, not just file-level access. Brian's paid Figma account setup tonight is the unblocker.
- 229 SVG/PNG files batch-exported from Figma to `.scratch/matt-figma/` (137 MB). Folder structure: `tokens/`, `layout/`, `components/`, `happy path/` (with nested `Content/Happy/` containing the 31 canonical screen SVGs).
- See `~/projects/peerloop-docs/.scratch/matt-figma/_INVENTORY.md` for full folder map, key takeaways, anomalies (incl. `typograhy-overview.png` misplacement), and MCP retry plan.
- See `~/projects/peerloop-docs/.scratch/matt-figma/overview/pages-panel.md` for the categorized Pages-panel inventory typed from the first screenshot.

**File path references:**
- noNav pattern reference: `~/projects/Peerloop/src/pages/course/[slug]/[tab].astro:20-22`
- noNav scanner helper: `~/projects/Peerloop/scripts/route-api-map.mjs:90-105` (`parseNoNav`)
- PROD-PW seed location: `~/projects/Peerloop/migrations/0002_seed_core.sql:172`
- PROD-PW hash source: `~/projects/Peerloop/src/lib/mock-data.ts:1485` (`DEV_PASSWORD = 'Peerloop2'`); used hash at `migrations-dev/0001_seed_dev.sql:43-49`
- DB-SYNC PLAN block: `~/projects/peerloop-docs/PLAN.md` § `Active: DEPLOYMENT` → `### DEPLOYMENT.DB-SYNC`
- DECISIONS.md PROD-PW rationale: `~/projects/peerloop-docs/docs/DECISIONS.md` §4

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Next conv main thrust:** Matt design push planning (read `.scratch/matt-figma/_INVENTORY.md`, retry MCP, then plan route map + tokens + components). **Coordination-needed:** DB-SYNC bundle (touches live prod D1 — pair before running). **External-blocked / waiting:** [BR-ZERO-REPRO], [BR-STATUS] [Opus], [AAP], [VITE-DEPS-WATCH].
