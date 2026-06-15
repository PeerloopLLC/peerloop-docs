# State — Conv 288 (2026-06-15 ~13:52)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Ops + docs conv (no code changes). Reseeded local dev D1, then deployed to **staging** (full DB reseed + app `dde…` version dd8ca1a9 + cron 68e5651b), verified loads (HTTP 200). Then a layout investigation (/courses vs /course/[slug] "margin jar") grew into a new **LAYOUT-SG** block: extracted Matt's newly-added Figma layout frames (page templates + full Tailwind-breakpoint set + 3 populated mobile pages) and **authored the margins/layout style guide** at `docs/as-designed/matt-design-system/08-layout-and-margins.md`. Code (ContentShell build + rollout) deferred to next conv per user.

## Completed

- [x] Reseeded local dev D1 (`db:setup:local:dev`, full + feeds)
- [x] Staging deploy: full DB reseed (`db:setup:staging:feeds`) + app (`deploy:staging` → dd8ca1a9) + cron (`deploy:cron:staging` → 68e5651b); verified HTTP 200 / "Home | Peerloop"
- [x] [LAYOUT-SG] authored margins/layout style guide (08-layout-and-margins.md §8.3.1/§8.3.2/§8.5) from Matt's Figma frames; archived 4 screenshots; INDEX + PLAN + task #29

## Remaining

- [ ] [LAYOUT-SG] #29 [Opus] — **guide authored; build DEFERRED:** build `ContentShell` (white card, breakpoint widths/paddings, full-bleed hero, rhythm tokens) + add grey-bg/1248-cap/shell-wrapper to `AppLayout` → pilot on `/courses` + `/course/[slug]` (kills the jar) → app-wide rollout (~80 pages, overlaps RTMIG-4 + island-restyle); promote `/courses` "Browse Courses" H2→H1. **OPEN: Q2 desktop utility-column SIDE (client decision; mobile leans right via drawer).**
- [ ] [COMM-TAG-FILTER] #1 — DEFERRED post-production
- [ ] [ROLE-STUDIOS] #2 [Opus] — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison sign-off)
- [ ] [RTMIG-4] #3 [Opus] — port ~89 legacy /old/* → root
- [ ] [SSR-LOADER-DEAD] #4 · [CT-RESTYLE] #5 · [PRIM-MATCH-INDEX] #6 · [TXTBTN] #7 · [PROFILE-PRIM-SWEEP] #8 (PAUSED profile cluster)
- [ ] [ICN-NS] #9 · [SHOWMORE] #12 · [PREFLIP-WT] #13 (KEEP until client-vet)
- [ ] [E2E-MIG] #10 — residual ~45 UI-structure-drift failures (Bucket A fixable; Bucket B held on ROLE-STUDIOS; 1 parallel-contamination flake)
- [ ] [E2E-GATE] #11 — ⛔ transitively blocked (needs E2E-MIG + ROLE-STUDIOS)
- [ ] [TZ-AUDIT] #14 [Opus] · [DOCGEN-SPEC] #15 · [OLD-PORTED-CLEANUP] #16
- [ ] [LEARN-ISLAND-RESTYLE] #17 · [CREATE-ISLAND-RESTYLE] #18 · [TEACH-ISLAND-RESTYLE] #19 · [TRIAGE-RESTYLE] #20
- [ ] [V217-WATCH] #21 · [COURSEDETAIL-DEAD] #22 · [NUDGE-CACHE-FLASH] #23
- [ ] [COMMONS-DATE] #24 · [DISCCARD-DEL] #25 · [FEED-LANE-RENDER] #26 · [STREAM-PURGE] #27
- [ ] [MEM-PRUNE] #28 — run /r-prune-memory (MEMORY.md at 80% of cap)

## TodoWrite Items

- [ ] #1 [COMM-TAG-FILTER] · #2 [ROLE-STUDIOS] [Opus] · #3 [RTMIG-4] [Opus] · #4 [SSR-LOADER-DEAD] · #5 [CT-RESTYLE] · #6 [PRIM-MATCH-INDEX] · #7 [TXTBTN] · #8 [PROFILE-PRIM-SWEEP] · #9 [ICN-NS] · #10 [E2E-MIG] · #11 [E2E-GATE] · #12 [SHOWMORE] · #13 [PREFLIP-WT] · #14 [TZ-AUDIT] [Opus] · #15 [DOCGEN-SPEC] · #16 [OLD-PORTED-CLEANUP] · #17 [LEARN-ISLAND-RESTYLE] · #18 [CREATE-ISLAND-RESTYLE] · #19 [TEACH-ISLAND-RESTYLE] · #20 [TRIAGE-RESTYLE] · #21 [V217-WATCH] · #22 [COURSEDETAIL-DEAD] · #23 [NUDGE-CACHE-FLASH] · #24 [COMMONS-DATE] · #25 [DISCCARD-DEL] · #26 [FEED-LANE-RENDER] · #27 [STREAM-PURGE] · #28 [MEM-PRUNE] · #29 [LAYOUT-SG] [Opus]

## Key Context

- **Staging is current** as of this conv: app version dd8ca1a9, cron 68e5651b (`*/15 * * * *`), DB matches local seed. Staging URL `peerloop-staging.brian-1dc.workers.dev` (admin brian@peerloop.com / Peerloop2).
- **LAYOUT-SG spec (authoritative, in 08-layout-and-margins.md):** shell-swap at `lg` (1024); below = single-column + floating nav pills, above = 220 sidebar + white "Page Content" card. Content **fills the card, caps 964px**; whole shell caps **1248px** and centers beyond xl (2xl → 144px margins). Paddings: card `p-24` (lg+) / `32` (md) / `16` (base/sm); outer frame 16; nav gutter 16. **Hero full-bleed**, body padded. Vertical rhythm: blocks 24 / sections 30→snap-32 / list 16. Page bg `#f8fafc`. Matt frame node IDs recorded in §8.3.1/§8.3.2; 4 screenshots in `figma-screenshots/`.
- **Jar fix plan:** build a shared `ContentShell` (sibling of `ListingShell`) = the white card; `ListingShell`'s 640+320≈964 already fits inside it. Non-listing pages currently inherit AppLayout's uncapped `flex-1` (the bug).
- **Chrome-bridge gotcha (this conv):** live Peerloop pages never reach `document_idle` (open feeds connection) → `read_page`/`screenshot` 45s-timeout; use `javascript_tool` (works at `readyState=complete`) + `curl` to verify. Recorded as a Learning.
- **NOT verified this conv:** the 5 baseline gates (no code changed; code repo clean since `45582070`). Baseline carry-forward unchanged from Conv 286 (vitest 6742-ish), not re-verified.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
