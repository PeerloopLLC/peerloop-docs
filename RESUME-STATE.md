# State — Conv 315 (2026-06-21 ~14:05)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Continued the route sweep (RTMIG-4) on a user-defined batch (`/members` + detail view + `/learning`/`/teaching`/`/creating`). **Swept `/members`** (RG-DISCOVER, 1/3) and **resolved ROLE-SEMANTICS** (#4) — which **unblocks RG-PUBPROF**. Then, at the user's request before /r-end, inventoried all 77 `/old/*` routes (reshape-aware) into a keep/deletable classification for next conv's RG-PUBPROF + OLD-PORTED-CLEANUP. All gates green (tsc/lint/astro-check 0/0/0/prov); nothing deleted.

## Completed

- [x] `/members` ☑ **Swept** (RG-DISCOVER, 1/3) — 3 islands conformed (Colour `gray-100`→`neutral-100` ×9, Type tokens, Spacing `px-8/py-4` snaps, dropped redundant title tracking); Tier-2 `<Button>` adopt ×2 (Retry/Clear); Load-More + multi-select filter pills kept hand-rolled (`SegmentedPills` is single-select — logged). User step-7 visual-confirmed clean. SoT: `plan/typo-fdn/migration-ledger.md` (§ /members + route row ☑) + `plan/route-migration/README.md` (RG-DISCOVER /members ☑).
- [x] [ROLE-SEMANTICS] ✅ **resolved** (#4) — predicate was already canonical (decided Conv 252); applied the 2 residual fixes: `creators.ts` `primary_topic_id` restored (SELECT+map; column exists schema L347 — RG-PUBPROF-preparatory, loader currently unused) + `UserProfileHeader` role badges → canonical `userRoles()` (behavior-preserving). tsc+lint clean. **Unblocks #3 RG-PUBPROF.**
- [x] `/old/*` route inventory classified — 77 routes → **33 keep / 44 candidate-deletable** (40 stale ported-copies of swept routes + 4 dead/dropped). Artifact: `.scratch/old-routes-disposition-conv315.md`.

## Remaining

**Route sweep (RTMIG-4 umbrella — RG groups):**
- [ ] [RTMIG-4] #1 (umbrella, in_progress) · [RG-PUBPROF] #3 [Opus] — **NOW UNBLOCKED** (ROLE-SEMANTICS done); port + sweep 3 routes (`@[handle]` hub + `teacher/[handle]` + `creator/[handle]`); sources at `old/@[handle].astro`, `old/teacher/[handle]/index.astro`, `old/creator/[handle]/index.astro`
- [ ] [RG-WORKSPACES] #7 [Opus] ⛔client — `/learning`, `/teaching`, `/creating` (6 routes); ⛔ = keep `/old/dashboard` live (vet), sweep is fine
- [ ] [RG-DISCOVER] #8 — `/feed`+`/feeds` remain (likely-retire); `/members` done this conv
- [ ] [RG-ADMIN] #2 (conf OUT) · [RG-PUBLIC] #16 (conf OUT)

**OLD cleanup (informed by this conv's inventory):**
- [ ] [OLD-PORTED-CLEANUP] #5 — 44 candidate-deletable `/old` routes; per-route inbound-ref check FIRST; full list in `.scratch/old-routes-disposition-conv315.md`. Do NOT touch the 33 KEEP (RG-PUBPROF 3 + RG-PUBLIC 14 + RG-WORKSPACES 15 + dashboard-vet 1).
- [ ] [PREFLIP-WT] #6 — teardown preflip worktree

**Conformance foundations:**
- [ ] [PALETTE-FDN] #21 · [SPACING-4PX-SWEEP] #22 · [SWEEP-SPACING-GREP] #23 · [LAYOUT-SG] #15

**Tier-2 cross-cutting:**
- [ ] [XCUT-BACKREF] #24 — re-glance swept routes after cross-cutting extractions. **New un-ripe candidate this conv:** `SegmentedPills` multi-select extension (for MembersFilters) — logged in Tier-2 ledger.

**Memory system:**
- [ ] [MEM-CAP-ARCH] #25 [Opus] — MEMORY.md auto-load cap architecture (fired again at 80% bytes 20481/25600 at this conv's r-start; both prune levers exhausted — do NOT just re-prune).

**Process / follow-ups / debt:**
- [ ] [SWEEP-FULLSUITE] #26 · [PROV-STAMP-GAPS] #17 · [HOME-FIXES] #18 · [COURSES-FIXES] #19 · [E2E-MIG] #9 · [E2E-GATE] #10 · [ICN-NS] #11 · [TZ-AUDIT] #12 [Opus] · [DOCGEN-SPEC] #13 · [V217-WATCH] #14 · [M4-ZGUARD] #20

## TodoWrite Items

- [ ] #1 [RTMIG-4] (in_progress) · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] (UNBLOCKED) · #5 [OLD-PORTED-CLEANUP] · #6 [PREFLIP-WT] · #7 [RG-WORKSPACES] [Opus] ⛔client · #8 [RG-DISCOVER] · #9 [E2E-MIG] · #10 [E2E-GATE] · #11 [ICN-NS] · #12 [TZ-AUDIT] [Opus] · #13 [DOCGEN-SPEC] · #14 [V217-WATCH] · #15 [LAYOUT-SG] · #16 [RG-PUBLIC] · #17 [PROV-STAMP-GAPS] · #18 [HOME-FIXES] · #19 [COURSES-FIXES] · #20 [M4-ZGUARD] · #21 [PALETTE-FDN] · #22 [SPACING-4PX-SWEEP] · #23 [SWEEP-SPACING-GREP] · #24 [XCUT-BACKREF] · #25 [MEM-CAP-ARCH] [Opus] · #26 [SWEEP-FULLSUITE]
- (#4 [ROLE-SEMANTICS] completed this conv)

## Key Context

- **RG-PUBPROF (#3) is the next batch item + now UNBLOCKED.** Exactly 3 routes: `/@[handle]` (hub, `PublicProfile` + role teasers) · `/teacher/[handle]` (deep, `fetchTeacherProfileData`) · `/creator/[handle]` (deep, `fetchCreatorProfileData`). Hub-and-spoke. Two-step port (rehost `git mv old→root` `@stand-in`, then `@matt-inspired` sweep). `[ENTITY-ANCHOR]` plural-slug fix + `[SSR-LOADER-DEAD]` are RG-PUBPROF's own scope (NOT ROLE-SEMANTICS). Conformance IN.
- **RG-PUBPROF ≠ /profile.** Own-user `/profile/[...tab]` (RG-PROFILE) is already swept; RG-PUBPROF is OTHER users' public profiles. Don't conflate.
- **`fetchCreatorProfileData` is currently UNUSED** (only barrel-exported; live `/old/creator/[handle]` uses inline SQL). The `primary_topic_id` fix is preparatory — browser-verify it when RG-PUBPROF adopts the loader.
- **`.scratch/old-routes-disposition-conv315.md`** = verified 77-route classification (gitignored). Use for RG-PUBPROF scoping + OLD-PORTED-CLEANUP. 44 deletable need per-route inbound-ref check first; 33 KEEP must not be touched.
- **MEMORY.md cap at 80% bytes** — #25 [MEM-CAP-ARCH] [Opus] is the architectural fix (do NOT re-prune).
- **Dev server was up** (4321/4322/4323) this conv; `/members` was user-visually confirmed.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
