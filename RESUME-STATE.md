# State — Conv 170 (2026-05-21 ~16:15)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Short conv. Curated `.scratch/matt-figma/` (229 files, 137 MB) → `.scratch/matt-main/` (83 files, 85 MB) — the focused build set MacMiniM4 needs to start happy-path implementation tonight. Set includes tokens (color + typography), layout primitives, base components, the 31 canonical Content/Happy/ screens, the 10 Purpose milestone frames, and the page-overview PNGs. Excluded categories documented in `.scratch/matt-main/_README.md` with reason per row (Prototype copies, Section Title-N variants, Why-we-need-it justification notes, Frame N unnamed, etc.). User transferring matt-main to MacMiniM4 via Dropbox.

## Completed

- [x] [MATT-ISOLATE] Curate matt-figma → matt-main with happy-path build set (83 files / 85 MB; `_README.md` with inclusion structure + 16-row exclusion table; `typograhy-overview.png` typo + misplaced location fixed at copy step)
- [x] /r-start task transfer (12 tasks from Conv 169 RESUME-STATE → TodoWrite with mnemonic codes preserved)

## Remaining

### BBB-RECORDING (carry-forward, external-blocked)

- [ ] **[BR-ZERO-REPRO]** Reproduce 0-min empty-but-published recording state — needs fresh BBB test session
- [ ] **[BR-STATUS]** [Opus] Add `sessions.recording_status` column with enum `none | requested | capturing | processing | published | failed | empty` — awaits [BR-ZERO-REPRO] + Blindside follow-up

### DEPLOYMENT.DB-SYNC (carry-forward; apply when DEPLOYMENT block is actively worked)

- [ ] **[DB-SYNC-04]** [Opus] Apply `migrations/0004_feed_activity_index.sql` to prod via `wrangler d1 execute peerloop-db --remote --file migrations/0004_feed_activity_index.sql`. Creates `feed_visits` + `feed_activities` tables + 2 indexes. Then insert tracker row.
- [ ] **[DB-SYNC-03]** Insert tracker row for `0003_fix_session_times.sql` without running the SQL (data already converged on prod — `sessions_missing_z = 0`)
- [ ] **[DB-SYNC-02-RENAME]** Rename stale `0002_seed.sql` → `0002_seed_core.sql` in prod `d1_migrations` table (cosmetic — silences `wrangler d1 migrations list` false-positive)
- [ ] **[PROD-PW-APPLY]** [Opus] Execute the deferred Peerloop2 rotation against prod admin — 3 steps bundled with DB-SYNC: (1) edit `migrations/0002_seed_core.sql:172` with Peerloop2 hash `$2b$10$tQMUTTuSbJiuqpITHrCN7.PMrqqkJTZROlbhZkPfvLKYEtcAsflXi`; (2) `wrangler d1 execute peerloop-db --remote --command="UPDATE users SET password_hash = '<hash>' WHERE id = 'usr-admin'"`; (3) verify login as `admin@peerloop.com / Peerloop2`
- [ ] **[DB-SYNC-VERIFY]** Final convergence check: `wrangler d1 migrations list peerloop-db --remote` reports "No migrations to apply"; `feed_visits` + `feed_activities` exist; `usr-admin` hash prefix = `$2b$10$tQMU...`

### Matt design push (planning + execution in next 1-2 convs)

- [ ] **[MATT-MCP-RETRY]** Re-attempt Figma MCP setup at conv-start of next conv after Brian's paid Figma account is provisioned and a Dev seat is assigned. Hypothesis: viewer's own seat needs Dev Mode capability, not just file-level Dev Mode access. If MCP works: `claude mcp add` config + restart. If still missing: fall back to SVG extraction from `.scratch/matt-main/` (the curated set authored this conv; or `.scratch/matt-figma/` for anything excluded).
- [ ] **[MATT-INVENTORY-CLEANUP]** Triage remaining `.scratch/matt-figma/` items next conv: (1) `tokens/color-guide/typograhy-overview.png` rename + relocation **already done as part of Conv 170 [MATT-ISOLATE]** in the matt-main copy — apply to matt-figma source if matt-figma is also wanted to be tidy; (2) identify which top-level `happy path/Frame N.svg` items are real screens vs supporting design assets; (3) confirm `Content/Happy/` 31 SVGs are the canonical screen library (confirmed informally during Conv 170 curation — all 31 are in matt-main/happy-path/screens/).
- [ ] **[MATT-PRE-PLAN]** [Opus] Next conv main work: read `.scratch/matt-main/_README.md` (covers the curated subset and what was excluded) + `.scratch/matt-figma/_INVENTORY.md` (for full-source context if needed), retry MCP, then plan: (a) `/matt/*` route map mapped to current Peerloop routes + net-new pages, (b) token extraction strategy (CSS custom properties + Tailwind theme extension; consume from `matt-main/tokens/color-guide/Generated with plugin_ Color Variable Style-Guide Generator.svg` + `matt-main/tokens/typography/{Body,Headers}.svg`), (c) responsive breakpoint encoding from `matt-main/layout/Mobile page structure _= 640px.svg` + `matt-main/layout/Tablet*.svg` + `matt-main/layout/Desktop + Tablet Landscape.svg`, (d) component library mapping (Matt's `matt-main/components/*.svg` → `src/components/matt/*`), (e) `MattLayout.astro` design.

### Other carry-forwards (external-blocked / watch-only)

- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in ClientRouter — WAITING on upstream Astro fix post-6.3.6. Verification probe after each Astro upgrade: `curl http://localhost:4321/ | grep -oE 'src="[^"]*ClientRouter[^"]*"'` (non-absolute = fixed)
- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings — self-resolved Conv 165, investigate only if recurs

## TodoWrite Items

- [ ] #1: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state
- [ ] #2: [BR-STATUS] Add sessions.recording_status enum column [Opus]
- [ ] #3: [DB-SYNC-04] Apply 0004_feed_activity_index.sql to prod D1 [Opus]
- [ ] #4: [DB-SYNC-03] Insert tracker row for 0003_fix_session_times.sql without running SQL
- [ ] #5: [DB-SYNC-02-RENAME] Rename stale 0002_seed.sql → 0002_seed_core.sql in prod d1_migrations
- [ ] #6: [PROD-PW-APPLY] Execute deferred Peerloop2 rotation against prod admin [Opus]
- [ ] #7: [DB-SYNC-VERIFY] Final prod D1 convergence check
- [ ] #8: [MATT-MCP-RETRY] Re-attempt Figma MCP setup at conv-start
- [ ] #9: [MATT-INVENTORY-CLEANUP] Triage .scratch/matt-figma/ folder
- [ ] #10: [MATT-PRE-PLAN] Plan /matt/* route map + tokens + components + MattLayout [Opus]
- [ ] #11: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] #12: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings

## Key Context

**Pre-commit state (will be committed in Step 6):**
- **Docs repo:** `.scratch/matt-main/` (new, gitignored — 83 files / 85 MB / `_README.md` + tokens/ + layout/ + components/ + happy-path/); `RESUME-STATE.md` (re-created this step); session files (Extract pruned to ~80 lines after manifest-based prune; Learnings.md; Decisions.md; PLAN.md updated by update-plan agent).
- **Code repo:** No changes.

**Baseline state (NOT re-verified this conv):** Conv 169 had `tsc --noEmit` + `npm run check` clean after [RAM-NONAV-SWEEP]. Full 5-gate baseline (lint, test, build) last verified Conv 168 (6453/6453 tests + 5-gate green). No `src/` runtime code touched this conv, so carry-forward is safe.

**[MATT-ISOLATE] curated set is at `.scratch/matt-main/`:**
- `_README.md` — full structure + exclusion-table
- `tokens/color-guide/` (5 SVGs) + `tokens/typography/` (2 SVGs + overview PNG)
- `layout/` (14 SVGs + overview PNG): Mobile/Tablet/Desktop page-structure SVGs, page-template, page-padding, nav-width, sidebar-width, header-bar, control-bar, 16px/20px spacing, course-header, course-in-feed
- `components/` (13 SVGs + components-layers.png): Brand, Button Primary, Main Nav, Sub Nav, Module, Chat, Entities, Icons, Note, Section Title, Social Post, To Do Item, Post Anchors
- `happy-path/α1 Happy Path.svg` + `happy-path/purpose-milestones/` (10 SVGs) + `happy-path/screens/` (31 canonical Content/Happy SVGs)

**Transfer plan:** User moves matt-main → MacMiniM4 via Dropbox. `.scratch/` is gitignored; not in Obsidian vault — Dropbox is the chosen transport.

**Cross-machine memory sync status:** Conv 170 /r-start showed 0-diff between mirror and live (M4Pro state matches M4 state). MEMORY.md cap healthy 58%/56%. No drift to remediate.

**File path references:**
- Curated set: `~/projects/peerloop-docs/.scratch/matt-main/`
- Full source: `~/projects/peerloop-docs/.scratch/matt-figma/`
- Inventory (source): `~/projects/peerloop-docs/.scratch/matt-figma/_INVENTORY.md`
- README (curated): `~/projects/peerloop-docs/.scratch/matt-main/_README.md`
- DB-SYNC PLAN block: `~/projects/peerloop-docs/PLAN.md` § `Active: DEPLOYMENT` → `### DEPLOYMENT.DB-SYNC`
- PROD-PW seed location: `~/projects/Peerloop/migrations/0002_seed_core.sql:172`
- PROD-PW hash source: `~/projects/Peerloop/src/lib/mock-data.ts:1485` (DEV_PASSWORD = 'Peerloop2'); migrations-dev/0001_seed_dev.sql:43-49 for the hash itself
- DECISIONS.md PROD-PW rationale: `~/projects/peerloop-docs/docs/DECISIONS.md` §4

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Next conv main thrust:** Matt design push planning — read `.scratch/matt-main/_README.md`, retry MCP, then [MATT-PRE-PLAN] (route map + tokens + components + MattLayout). **Coordination-needed:** DB-SYNC bundle ([Opus] on #3 + #6) — touches live prod D1 + admin auth; pair before running. **External-blocked / waiting:** [BR-ZERO-REPRO], [BR-STATUS] [Opus], [AAP], [VITE-DEPS-WATCH].
