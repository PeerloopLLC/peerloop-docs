# State — Conv 331 (2026-06-24 ~13:36)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Pre-staging verification + deploy, then two route-group closures and a major policy-setting discussion. Ran all 5 baseline gates (full Vitest 6741/6741) + deployed to staging (Version `4e345ca3`, client testing). Closed **[RG-SESSION] #27** (triage: `/session/[id]` = SessionRoom only → RG-SESSIONS stands; deleted dead AvailabilityEditor; kept SessionHistory → new [SESSHIST] #28). Closed **[RG-DISCOVER] #2** by **retiring `/feed` + `/feeds`** under the new **[OLD-RETIRE-DEFAULT]** policy (4 src + 2 e2e deletions, 5 edits, middleware + test cleanup; full suite 6737/6737; committed code `d47c8612` / docs `3724497`). Established two standing policies in memory: **[OLD-RETIRE-DEFAULT]** (`/old/*` + AppNavbar retire-by-default) and **[ADMIN-CONF-POLICY]** (the RG-ADMIN restyle spec — decided this conv, editing deferred). Net: the canonical route sweep is **~complete except RG-ADMIN**.

## Completed

- [x] [SWEEP-FULLSUITE] #12 — full Vitest 6741/6741 + all 5 gates green; staging deployed (Version 4e345ca3, app-only)
- [x] [RG-SESSION] #27 — triage closed (RG-SESSIONS sweep stands; AvailabilityEditor deleted; SessionHistory → [SESSHIST])
- [x] [RG-DISCOVER] #2 — CLOSED: /members swept (Conv 315) + /feed,/feeds RETIRED; full suite 6737/6737

## Remaining

**Route sweep umbrella + the one remaining canonical group:** [RTMIG-4] #1 (in_progress — canonical sweep ~complete EXCEPT RG-ADMIN) · **[RG-ADMIN] #3 (in_progress — restyle policy [ADMIN-CONF-POLICY] DECIDED, editing pending: start shell (AdminLayout+AdminNavbar dark identity) + AdminDashboard, then route-by-route; ~1470 legacy hits / 16 routes / 33 comps; build on RG-MOD)** · [RG-PUBLIC] #4 (DEFERRED — 13/15 marketing pages still /old; retire-decision under [OLD-RETIRE-DEFAULT], not a sweep)

**Cross-cutting / foundations:** [XCUT-BACKREF] #5 · [TA-SKEL] #6 (skeleton `w-80`/`w-96`→`[80px]`/`[96px]`) · [PALETTE-FDN] #7 · [SPACING-4PX-SWEEP] #8 · [SWEEP-SPACING-GREP] #9 · [LAYOUT-SG] #10

**Memory system:** [MEM-CAP-ARCH] #11 [Opus] — MEMORY.md at 81% bytes (added 2 pointers this conv); architectural fix, do NOT re-prune.

**Process / debt:** [VITE-DEDUP] #13 · [PROV-STAMP-GAPS] #14 · [HOME-FIXES] #15 · [COURSES-FIXES] #16 · [E2E-MIG] #17 (NOW also: retarget 3 feed-route specs — home-feed/feed-badges/my-feeds-card — at Home/dashboards) · [E2E-GATE] #18 · [ICN-NS] #19 · [TZ-AUDIT] #20 [Opus] · [DOCGEN-SPEC] #21 · [V217-WATCH] #22 · [M4-ZGUARD] #23 · [OLD-PORTED-CLEANUP] #24 · [PREFLIP-WT] #25 · [REVIEW-COUNT-SRC] #26 · **[SESSHIST] #28** (verify SessionHistory.tsx intent — re-wire into /teaching vs delete + its test + barrel line)

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #3 [RG-ADMIN] (in_progress) · #4 [RG-PUBLIC] · #5 [XCUT-BACKREF] · #6 [TA-SKEL] · #7 [PALETTE-FDN] · #8 [SPACING-4PX-SWEEP] · #9 [SWEEP-SPACING-GREP] · #10 [LAYOUT-SG] · #11 [MEM-CAP-ARCH] [Opus] · #13 [VITE-DEDUP] · #14 [PROV-STAMP-GAPS] · #15 [HOME-FIXES] · #16 [COURSES-FIXES] · #17 [E2E-MIG] · #18 [E2E-GATE] · #19 [ICN-NS] · #20 [TZ-AUDIT] [Opus] · #21 [DOCGEN-SPEC] · #22 [V217-WATCH] · #23 [M4-ZGUARD] · #24 [OLD-PORTED-CLEANUP] · #25 [PREFLIP-WT] · #26 [REVIEW-COUNT-SRC] · #28 [SESSHIST]

(#2 [RG-DISCOVER], #12 [SWEEP-FULLSUITE], #27 [RG-SESSION] COMPLETED this conv.)

## Key Context

- **Next sweep = RG-ADMIN, policy is locked.** Start shell-first: `AdminLayout` + `AdminNavbar` → the dark `neutral-900` "Admin" identity (light-on-dark nav, "Admin" wordmark + glyph, `info`-blue accent for primary actions (NOT brand-purple), role chip by avatar, shared page-header), then `AdminDashboard`, then route-by-route (top offenders Payouts/PromotionSettings/Announcements/Topics). Full spec in `memory/project_admin_conformance_policy.md`. Relaxations A–D + type 12px-base/10px-meta + STRICT drop-all-`dark:` (122 of them). Write the detailed per-component ledger section into `plan/typo-fdn/migration-ledger.md` when the sweep starts. Build on RG-MOD (Conv 313).
- **[OLD-RETIRE-DEFAULT]** (memory): `/old/*` + AppNavbar retire-by-default; links from AppNavbar/DiscoverSlidePanel/`/old` DON'T count as canonical value. Implies a future AppNavbar-retirement track.
- **/feed + /feeds are GONE** — SmartFeed stays on Home (`/`) + `/api/feeds/smart`; the orphaned islands FeedsDiscoveryGrid/FeedsDirectory deleted; FeedAllTab/FeedRoleTab kept (still used by `/old` ExploreFeeds → die with [OLD-PORTED-CLEANUP]). Docs agent de-stale'd url-routing.md/feeds.md/route-stories.md/TEST-COVERAGE/CLI-TESTING/API-COMMUNITY.
- **MEMORY.md at 81% bytes** — #11 [MEM-CAP-ARCH] [Opus] is the architectural fix; do NOT re-prune.
- **Commits this conv (pre-r-end):** code `d47c8612` + docs `3724497` (the RG-DISCOVER retire). This end-of-conv bookkeeping commit (Step 6) adds the Extract/Learnings/Decisions + agent doc updates + memory + RESUME-STATE. Code gated tsc/lint/astro(1432)/build + full Vitest 6737/6737.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
