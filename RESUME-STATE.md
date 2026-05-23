# State — Conv 178 (2026-05-23 ~11:14)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 178 conceived, scoped, and approved Phase 4.5 `[MATT-EXEC-CMP]` (Component import from Matt's Figma Components page) between Phase 4 (PRM-2 complete Conv 176) and Phase 5 (PG2 pending) with 8 dependency-ordered subtasks. Harvested all 39 icons from Matt's Figma catalogue including Vector/User-Icon resolution, with authoritative renames via Matt's catalogue labels (catching `newspaper→feed`, `mail→message`, `calendar_month→calendar` semantic corrections vs Figma's auto-export names). Wrote `.scratch/matt-main/components/icons/_INDEX.md` capturing Primary/Secondary section structure + Arrow/Level/Bookmark Component-variant groupings. Buttons reconnaissance revealed 3-orthogonal-dimension architecture (Color via Variable Mode × State via Property 1 × Size via 5 frame cells) + Matt's CSS uses `var(--Background)` validating [CASCADE-BROKEN] as implementation issue. Mid-conv pivot: project moved to client's Pro Figma account — ending conv to set up Figma MCP server between convs, then `/r-start` fresh with MCP active for remaining 7 CMP subtasks.

## Completed

- [x] Conv 178 start (/r-start) — counter 177→178, 31 tasks transferred from RESUME-STATE
- [x] `npm install` — no actual drift (lockfile already reflected Conv 177 upgrades)
- [x] Phase 4.5 `[MATT-EXEC-CMP]` block conceived, scoped, and approved
- [x] PLAN.md updated — Phase 4.5 block + 8 subtasks inserted; PG2 description updated; MATT-DESIGN-PUSH status line updated
- [x] `matt-pre-plan.md` §9 — Phase 4.5 row added; total estimate 8–11 → 10–15 convs
- [x] TodoWrite — 9 new CMP tasks created (#32 parent + #33-#40 subtasks); dependencies wired
- [x] `.scratch/matt-figma-extraction-today.md` checklist drafted (~250 lines) — though now stale post-Pro-account pivot
- [x] 9 subfolders pre-created under `.scratch/matt-main/components/`
- [x] Figma export settings advised — `Include bounding box ✅`, `sRGB` explicit
- [x] 39 icons extracted from Figma — all `viewBox="0 0 24 24"` confirmed
- [x] Catalogue screenshot consulted — authoritative Matt naming (Primary 8 / Secondary 31)
- [x] 19 icon renames executed (newspaper→feed, mail→message, calendar_month→calendar, Property variants → arrow/level/bookmark, Vector→user-icon)
- [x] `_INDEX.md` written with sections + variant groupings + naming convention rules
- [x] Buttons reconnaissance — 3-orthogonal-dimension architecture documented
- [x] [CASCADE-BROKEN] validated as implementation issue (Matt's CSS uses var() refs)
- [x] Pro account pivot identified; MCP setup chain (#48-#52) created

## Remaining

🔝 **LEAD next-conv task** (per user's /r-end argument):

- [ ] **[MCP-SETUP-WALK]** Walk user + client through Figma MCP setup on client's Pro account step-by-step. Sub-tasks: [MCP-INSTALL], [MCP-TOKEN], [MCP-CONFIG], [MCP-VERIFY]

**MCP setup chain (today's blocker → next-conv lead):**

- [ ] **[MCP-SETUP-WALK]** Lead task — walkthrough [Opus]
- [ ] **[MCP-INSTALL]** Install Figma MCP server (Figma official vs community decision) [Opus]
- [ ] **[MCP-TOKEN]** Generate Figma personal access token from Pro account
- [ ] **[MCP-CONFIG]** Add mcpServers block to settings.json (user vs project level)
- [ ] **[MCP-VERIFY]** Verify tools appear via ToolSearch after /r-start

**After MCP confirmed — resume CMP harvest:**

- [ ] **[MATT-EXEC-CMP-ICN]** Icons — harvest complete; pending **registry-integration phase** ([CMP-ICN-REGISTRY] decision + implementation) [Opus]
- [ ] **[CMP-ICN-REGISTRY]** Decide registry strategy: extend existing icon-paths.ts vs matt-namespace vs section-grouped [Opus]
- [ ] **[CMP-VAR-PROMOTE-DECISION]** Decide Arrow/Level/Bookmark — flat icons or React primitives [Opus]
- [ ] **[MATT-EXEC-CMP-BTN]** Buttons audit vs Matt's 3-orthogonal-dimension architecture [Opus] [blocked by #33]
- [ ] **[MATT-EXEC-CMP-MNV]** Main Nav primitive [Opus] [blocked by #33]
- [ ] **[MATT-EXEC-CMP-SNV]** Sub Nav upgrade + mobile drawer [Opus] [blocked by #33]
- [ ] **[MATT-EXEC-CMP-ENT]** Entities multi-primitive + entity headers [Opus]
- [ ] **[MATT-EXEC-CMP-CHT]** Chat primitive [Opus] [blocked by #33]
- [ ] **[MATT-EXEC-CMP-PNC]** Post Anchors primitive [Opus] [blocked by #33]
- [ ] **[MATT-EXEC-CMP-BRN]** Brand verify/build

**Doc updates triggered by Conv 178 findings:**

- [ ] **[MDS-BTN-3D]** Update matt-design-system.md §6 Buttons → 3-orthogonal-dimension architecture
- [ ] **[MDS-CASCADE-VALIDATED]** Add Conv 178 cascade-validation note to matt-design-system.md
- [ ] **[MFE-STALE]** Supersede `.scratch/matt-figma-extraction-today.md` when MCP online
- [ ] **[MRR]** Re-scope task #9 [MATT-MCP-RETRY] description (Pro account exists, MCP install pending)

**Memory captures from Conv 178 methodology learnings:**

- [ ] **[MFM]** Save memory — Matt-design extraction methodology (consult catalogue for naming, not visual inference)
- [ ] **[STOR]** Save memory — ask user for source-of-truth before visual ID drilling
- [ ] **[DTU]** Save memory — defer to user-supplied source material (may consolidate with [STOR])

**Carrying forward from Conv 177:**

- [ ] **[MATT-EXEC-FLAGS]** Verify 4 route-shape assumptions before Phase 5 starts
- [ ] **[MATT-EXEC-PG2] [Opus]** Phase 5: 12 /matt/* routes [blocked by #32 CMP parent]
- [ ] **[MATT-EXEC-EXT] [Opus]** Phase 6: extrapolation primitives
- [ ] **[MATT-EXEC-GRD]** Phase 7: doc graduation
- [ ] **[MATT-COURSE-POLISH]** Body section visual polish on /matt/course/[slug]
- [ ] **[MATT-CREATOR-TAB]** /matt/course/[slug]/creator route (Phase 5 sub-task)
- [ ] **[MATT-ICON-SWAP]** Hero overlay inline-SVG icons → icon-system in Phase 6
- [ ] **[MATT-INVENTORY-CLEANUP]** Triage `.scratch/matt-figma/` (actual is matt-main)
- [ ] **[MATT-MCP-RETRY]** SUPERSEDED by MCP-SETUP-WALK chain — close once MCP live
- [ ] **[MATT-RT-DOC]** Triage /matt/* route documentation in url-routing.md
- [ ] **[RTB]** Design Role Tab Bar — finalize design-spec doc
- [ ] **[TSV]** Token Scaffolding Verification
- [ ] **[NOTE-YELLOW]** Add `--note-yellow` token
- [ ] **[CASCADE-BROKEN] [Opus]** validated Conv 178 as impl issue; needs Tailwind 4 bridge fix
- [ ] **[AAP]** UPSTREAM-BLOCKED — Astro 6.3.7 still has the leak
- [ ] **[TWLG-MIN-H]** Tailwind 4 `min-h-[480px]` arbitrary-value silent fail
- [ ] **[ASF]** Astro.slots.has + && short-circuit investigation
- [ ] **[MPV]** Add Figma SVG + qlmanage step to pre-plan scaffolding
- [ ] **[MND2]** detect-machine.sh still returns "Unknown" on M4Pro
- [ ] **[TDS-DRIFT]** tech-doc-sweep returned no recent changes despite matt/* additions
- [ ] **[INV-PATH-FIX]** Sweep `.scratch/matt-figma/` references → `matt-main`
- [ ] **[VITE-DEPS-WATCH]** Watch for Vite missing-chunk warnings
- [ ] **[MEM-CAP]** Schedule `/r-prune-claude` pass
- [ ] **[MEM-IDX-SLOT]** Add MEMORY.md entry for `reference_astro_slot_forwarding.md`

**BBB / Production (parked):**

- [ ] **[BR-ZERO-REPRO]** Reproduce 0-min empty recording state
- [ ] **[BR-STATUS] [Opus]** Add sessions.recording_status enum column
- [ ] **[DB-SYNC-04] [Opus]** Apply 0004_feed_activity_index.sql to prod D1
- [ ] **[DB-SYNC-03] [Opus]** Insert tracker row for 0003_fix_session_times.sql
- [ ] **[DB-SYNC-02-RENAME] [Opus]** Rename stale 0002_seed.sql in prod d1_migrations
- [ ] **[PROD-PW-APPLY] [Opus]** Execute deferred Peerloop2 rotation
- [ ] **[DB-SYNC-VERIFY]** Final prod D1 convergence check

## TodoWrite Items

(54 tasks total at conv close — all marked completed via TaskUpdate to clear board, since the persistent state lives here)

## Key Context

- **Branch `jfg-dev-13-matt`** holds all Matt design work + Conv 177's [NPM-UP]/[DSSR-SCOPE] fixes + Conv 178's PLAN/matt-pre-plan edits (commit will be created in /r-end Step 6). No code changes this conv.

- **39 icons live at `.scratch/matt-main/components/icons/`** — all kebab-case, all `viewBox="0 0 24 24"`, all named per Matt's authoritative catalogue labels. `_INDEX.md` documents Primary (8) / Secondary (31) sections + Arrow / Level / Bookmark Component-variant groupings + naming convention rules.

- **Naming convention authority rule (Conv 178 established):** Matt's catalogue label is the source of truth for icon naming, NOT Figma's auto-export filename (which uses source Material-Icon names like `newspaper`, `mail`, `calendar_month`). 6 specific corrections documented in `_INDEX.md`: newspaper→feed, mail→message, calendar_month→calendar, chat_bubble→chat, present_to_all→present, Vector→user-icon. Plus Property 1=X variants flattened to `arrow-*`, `level-*`, `bookmark`/`bookmark-filled`.

- **Phase 4.5 [MATT-EXEC-CMP] inserted** between Phase 4 (PRM-2) and Phase 5 (PG2). 8 dependency-ordered subtasks (CMP-ICN foundational, blocks BTN/MNV/SNV/CHT/PNC). Total estimate bumped 8–11 → 10–15 convs.

- **Buttons architecture is 3-orthogonal-dimension** (NOT 6×3 flat matrix as `matt-design-system.md §6` documented): Color via Variable Mode (6 modes: Primary/Outlined/Course/Student/Creator/Default) × State via Property 1 (Default/Hover + possibly Active/Disabled) × Size via 5 frame cells (likely xs/sm/md/lg/xl). Surgical capture for buttons = 6 + 4 + 5 ≈ 15 captures, NOT 6×4×5 = 120.

- **[CASCADE-BROKEN] validated as implementation issue, not design choice.** Matt's button CSS in Dev Mode shows `background: var(--Background, #...)` and `border: 1px solid var(--Border, #...)` — design IS authored against cascade. Our codebase's Tailwind 4 bridge fails to propagate `.entity-*` classes through to `bg-entity-background`. Fix is on us.

- **Client Pro Figma account is the new path forward** (URL: https://www.figma.com/design/UpDNMiIEO8y3J7ZHkm356b/PeerLoop). User added as user. MCP server itself still needs install + token + settings.json config — see [MCP-SETUP-WALK] chain.

- **`.scratch/matt-figma-extraction-today.md` checklist is stale** post-Pro-account pivot. The 3-tier deadline-driven structure was Dev Mode trial-bound. Kept for reference but don't operate from it; supersede with MCP-based plan next conv.

- **Diagnostic patterns for next conv MCP work:**
  - After `/r-start`, immediately run `ToolSearch query: figma` to verify MCP tools appear
  - If MCP works: use it to re-extract Button architecture (capture all dimensions structurally vs the manual screenshot capture we'd planned) → update matt-design-system.md §6 with the corrected 3-dimension architecture
  - If MCP doesn't work: debug the settings.json config first; do NOT fall back to manual screenshot capture (low value vs MCP path)

- **Per /r-end user argument:** "BUt our first task when the new conv starts is to walk me through what I and the client need to do step by step to get the MCP server working on his pro account" — this is the LEAD task pinning #1 in next conv.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
