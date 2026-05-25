# State — Conv 191 (2026-05-25 ~12:40)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Demo-prep conv. Fixed broken machine detection, cleared the small Conv-190 carry-forwards, then pivoted to a team demo tomorrow: discovered the legacy app's spacing was silently broken app-wide since Conv 174 (Tailwind-bridge `--spacing-*` override hijacking the numeric scale ~4×). Per user decision, did NOT revert (would break `/matt`) — instead began migrating the legacy shell ONTO Matt's design (NAV-RETROFIT, approach B), retrofitting the AppNavbar and adding a bidirectional New Design ↔ Classic App demo bridge. Then fixed 3 Astro View-Transition regressions surfaced by the round-trip (all DOM-verified after the user flagged that screenshots were misleading). 4 commits (2 code, 2 docs) + 1 global; **all unpushed**. NAV-RETROFIT is the live block.

## Completed

- [x] [MDET] Machine detection fixed → canonical `MacMiniM4Pro` (global commit `98cc4c4`, pushed)
- [x] [MEM-ICON-COUNT] MEMORY.md icon registry → 43 SVGs / MattIcon.tsx
- [x] [MDS-SHELL] matt-design-system.md synced to Conv-190 shell + 3 letter-spacing corrections
- [x] [VIDEO-COMMENT-ICN] VideoClipAnchor chat→video-comment (registry swap, not a harvest)
- [x] [MATT-PROFILE-VERIFY] logged-in Profile row verified by user
- [x] [DEMO-HOME] legacy home-page impact assessed → spacing-collision root cause found
- [x] NAV-RETROFIT step 1 — AppNavbar restyled to Matt (220px, typography, brand-blue active, chevrons, slideout offsets)
- [x] Bidirectional demo bridge — New Design→/matt/, Classic App→/ (TEMP)
- [x] 3 View-Transition regressions fixed (navbar bunching / Messages card / slideouts) — DOM-verified

## Remaining

**NAV-RETROFIT continuation (live block):**
- [ ] [NAV-ICON-SWAP] legacy nav icons → MattIcon glyphs
- [ ] [NAV-SIBLINGS] same width-coupling in `AdminNavbar.tsx` (`w-64`), `AppHeader.tsx` (`w-64`), `MoreSlidePanel.tsx` (`left-64`) — admin/legacy-header, off demo path
- [ ] [LEGACY-SPACING-AUDIT] broader sweep of legacy pages for the hijacked-step set {4,8,12,16,20,24,32,40,48,64}
- [ ] approach-A (swap legacy nav to Matt components + extend NavItem with button/badge/auth) — optional, "if B goes well"
- [ ] [VTPRD] verify the VT CSS-drop bug is dev-only (prod = single global stylesheet); confirms hardening was belt-and-suspenders

**Course-tab polish (held):**
- [ ] [CRS-MOBILE] / [SHOWMORE] / [ENTITY-VIS-AUDIT] / [CH-VARIANTS] / [MATT-ICON-SWAP]

**Bigger Matt blocks:**
- [ ] [MATT-EXEC-PG2] Enroll / Choose Teacher / Session families
- [ ] [MMP-PH5] Phase 5 graduation — **BLOCKED on MacMiniM4** (machine-local `.scratch/` source files)
- [ ] [MATT-EXEC-EXT] [Opus] / [MATT-EXEC-GRD] / [MMP-PH3] / [RTB] [Opus]

**Asset harvests / tooling / watches:**
- [ ] [HOWTOREG-ICN] / [PLAY-CIRCLE-ICN]
- [ ] [ASSET-SWEEP-GATE] / [FIGMA-MCP-DOC-HARVEST] / [MFRD-GRADUATE] / [ESOT-STRUCTURE] / [BROWSER-FALLBACK]
- [ ] [MFRD-LOOKUP] / [TXTBTN] / [LH-VERIFY] / [MEM-CAP-WATCH]

## TodoWrite Items

- [ ] #5 [CRS-MOBILE] / #6 [SHOWMORE] / #7 [ENTITY-VIS-AUDIT] / #8 [CH-VARIANTS] / #9 [MATT-ICON-SWAP]
- [ ] #10 [MATT-EXEC-PG2] / #11 [MMP-PH5] (blocked MacMiniM4) / #12 [MATT-EXEC-EXT] [Opus] / #13 [MATT-EXEC-GRD] / #14 [MMP-PH3] / #15 [RTB] [Opus]
- [ ] #16 [HOWTOREG-ICN] / #18 [PLAY-CIRCLE-ICN]
- [ ] #19 [ASSET-SWEEP-GATE] / #20 [FIGMA-MCP-DOC-HARVEST] / #21 [MFRD-GRADUATE] / #22 [ESOT-STRUCTURE] / #23 [BROWSER-FALLBACK]
- [ ] #24 [MFRD-LOOKUP] / #25 [TXTBTN] / #26 [LH-VERIFY] / #27 [MEM-CAP-WATCH]
- [ ] #29 [NAV-RETROFIT] (in progress) / #30 [VTPRD]

## Key Context

- **Commits this conv are UNPUSHED** (push before the demo if it runs from a fresh pull): code `c5ad1b6` + `be462d5`, docs `377ac5c` + `ac3e2cb` (global `98cc4c4` already pushed). `/r-end` Step 7 will push them — if push succeeded this state is moot; if it failed, push manually.
- **Spacing-collision root cause:** `global.css` imports `tokens-tailwind-bridge.css` whose `@theme` `--spacing-4..64: var(--space-N)` aliases Tailwind's numeric scale to Matt literal-px → legacy utilities using {4,8,12,16,20,24,32,40,48,64} are ~4× too small app-wide. Do NOT revert (breaks /matt). Migrate legacy onto Matt; use standard non-hijacked steps (2/2.5/3/6/…) or inline `style`.
- **View-Transition gotchas (Astro + transition:persist islands):** (1) island-unique arbitrary utilities drop when sibling-route CSS swaps in → use standard classes / inline style; (2) inline `<script>` doesn't re-run on VT → bind to `astro:page-load`; (3) duplicate `style` attr in JSX is silently dropped (build WARN only) — always merge. See DEVELOPMENT-GUIDE.md (new sections) + `feedback_dom_truth_over_screenshots.md`.
- **Verification method:** for precise layout/position/visibility, trust DOM (`getComputedStyle`/`getBoundingClientRect`/`elementFromPoint`) + dev-server log, NOT screenshots (they misled me twice this conv).
- **TEMP demo bridge:** AppNavbar "New Design"→/matt/ (SparklesIcon, top item) + Matt Sidebar "Classic App"→/ (arrow-left, in NAV + COLLAPSED_NAV) — both marked TEMP for easy removal once redesign is default.
- **Open question:** is the demo on dev or staging? Prod build = single global CSS → VT-drop bug wouldn't occur ([VTPRD]).
- Dev server was stopped at conv end (no longer running on :4321).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
