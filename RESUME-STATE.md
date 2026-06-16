# State — Conv 291 (2026-06-16 ~10:11)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Reframed RTMIG-4 from a porting backlog into a **full visual-presentation route sweep** — 14 `RG-*` route-group tasks, every route a sweep unit (page + all subcomponents), even already-ported ones. Documented a canonical, multi-conv-resumable **8-step per-route process** (assess Tier-1 + Tier-2 → surface → PAUSE → work → browser-verify → user out-of-scope review → Swept) and created a route-scoped **Tier-2 primitive-candidate ledger**. Then **swept the first route, `/` (RG-HOME)**: adopted ListingShell (centered feed), token-migrated the feed surface to Matt, extracted the DismissButton primitive, browser-verified. Committed both repos (code `2a216a4f`, docs `c380998`) via `/r-commit`; this `/r-end` adds session docs + RESUME-STATE.

## Completed

- [x] Restructured RTMIG-4 → 14 RG-* route-group tasks (route sweep); rewrote `plan/route-migration/README.md` as the full-sweep checklist + 8-step process
- [x] Created `plan/route-migration/tier2-primitive-ledger.md` (route-scoped candidate accumulation + impact)
- [x] Swept `/` (RG-HOME): ListingShell + hideRightPanel, feed token migration (SmartFeed/AnnouncementCard/SuggestionCard), DismissButton primitive extracted + registered, browser-verified
- [x] Documented the per-route sweep process to memory (`feedback_route_sweep_pause_protocol.md`)

## Remaining

**Route sweep — next groups (cleanest unblocked: RG-ADMIN or RG-COURSES):**
- [ ] [RTMIG-4] Route-sweep umbrella (14 RG-* groups); blocked by #2/#3/#4
- [ ] [RG-ADMIN] Sweep /admin/* (16 routes) — island/body-only, no deps
- [ ] [RG-PUBPROF] [Opus] Sweep public profiles (3, port+sweep); blocked by [ROLE-SEMANTICS]
- [ ] [RG-AUTH] Sweep auth/entry/error (7)
- [ ] [RG-PROFILE] Sweep /profile (multi-tab)
- [ ] [RG-COURSES] Sweep courses + course detail (5)
- [ ] [RG-COMMS] Sweep communities (2)
- [ ] [RG-DISCOVER] Sweep feed/feeds/members (3) — /feed,/feeds likely retire
- [ ] [RG-MESSAGES] · [RG-NOTIFS] · [RG-SESSIONS] · [RG-MOD] · [RG-PUBLIC] (deferred)
- [ ] [RG-WORKSPACES] [Opus] Sweep role workspaces (6) ⛔ client-blocked
- [ ] [ROLE-SEMANTICS] [Opus] Canonical creator/teacher predicate; blocks RG-PUBPROF

**Per-route follow-ups:**
- [ ] [HOME-FIXES] Out-of-scope / fixes (LIVING list: card fonts, type-badge, image width, filters→panel, panel shown+hideable)
- [ ] [PROV-STAMP-GAPS] 5 components stamp data-prov with no registry entry (pre-existing)
- [ ] [OLD-PORTED-CLEANUP] Delete ~43 stale /old copies · [PREFLIP-WT] Teardown pre-flip worktree

**Cross-cutting / infra:**
- [ ] [E2E-MIG] ~45 UI-structure-drift failures · [E2E-GATE] (blocked by E2E-MIG)
- [ ] [ICN-NS] (held client-vet) · [TZ-AUDIT] [Opus] · [DOCGEN-SPEC] · [V217-WATCH] · [MEM-PRUNE] · [LAYOUT-SG]

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] · #16 [RG-PROFILE] · #17 [RG-COURSES] · #18 [RG-COMMS] · #19 [RG-DISCOVER] · #20 [E2E-MIG] · #21 [E2E-GATE] · #22 [ICN-NS] · #23 [TZ-AUDIT] [Opus] · #24 [DOCGEN-SPEC] · #25 [V217-WATCH] · #26 [MEM-PRUNE] · #27 [LAYOUT-SG] · #28 [RG-MESSAGES] · #29 [RG-NOTIFS] · #30 [RG-SESSIONS] · #31 [RG-MOD] · #32 [RG-PUBLIC] · #33 [PROV-STAMP-GAPS] · #34 [HOME-FIXES]

## Key Context

- **Route sweep is the active work.** SoT = `plan/route-migration/README.md` (8-step per-route process + 14-group route checklist with ☐/☑ Swept) + `tier2-primitive-ledger.md` (cross-route primitive candidates). Process also in memory `feedback_route_sweep_pause_protocol.md`. **Exhaustive, not hurried; PAUSE at every route before touching code.**
- **Swept = Tier-1 done + Tier-2 fully assessed (ripe extracted, rest logged in ledger) + browser-verified + user out-of-scope review done.** Un-ripe ledger candidates do NOT block Swept.
- **Step 7 = capture, don't solution.** User out-of-scope items → `[<ROUTE>-FIXES]` task with CC research as notes; do NOT try to fix/discuss them.
- **`/` (RG-HOME) is Swept.** SmartFeed is PERMANENT on Home; `/feed`+`/feeds` (RG-DISCOVER) likely retire. FeedActivityCard NOT yet token-migrated (in [HOME-FIXES]).
- **Token gotcha:** `bg-primary` is transparent (undefined utility); Matt brand-blue bg = `bg-text-primary` (`#0777b6`). Gates miss CSS — browser/DOM verify visual work.
- **Branch:** code on `jfg-dev-13-matt` (the real continuous branch; Conv-290's `jfg-dev-14` never existed). Commits this conv: code `2a216a4f`, docs `c380998` (pre-r-end; r-end adds more).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
