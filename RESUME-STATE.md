# State — Conv 280 (2026-06-14 ~10:41)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Three things shipped: **[SUCCESS-COMMUNITY-VERIFY]** (browser A–E sweep of the success-page milestone composer + a new `MilestoneComposer.test.tsx` regression test, closing a no-test gap), **[COMM-TAG-FILTER]** deferred to post-production (channels were a port-artifact; the member-town-hall premise is gone), and **[SYS-RENAME]** — a full pre-production rename of the system feed: `the-commons`/`The Commons`/`townhall` → `system` across slug, id (`comm-system`), name (`System`), API route (`/api/feeds/system`), and component (`SystemFeed`), behind a new `src/lib/system-feed.ts` constants module. The **Stream feed group stays `townhall`** (declared in the Stream dashboard, not creatable on write — a 500 caught this) behind a documented constant. 5 gates green (test **6713**), browser-verified. Cosmetic residue → [SYS-RENAME-COSMETIC].

## Completed

- [x] /r-start (Conv 279→280); 32 tasks transferred; memory mirror→live 0-diff
- [x] [SUCCESS-COMMUNITY-VERIFY] — A–E browser sweep + new `tests/components/course/MilestoneComposer.test.tsx` (6 cases); REASSEMBLY #16 marked verified
- [x] [COMM-TAG-FILTER] deferred post-production (task #1 + `plan/comm-tag-filter/README.md` + REASSEMBLY #5 corrected to build-ready)
- [x] [SYS-RENAME] — full system-feed value/route/component rename; new `src/lib/system-feed.ts`; route maps regenerated (both repos); local D1 re-seeded; 5 gates green (test 6713); browser-verified (/community/system renders "System", admin POST 200, non-admin 403, old route 404)
- [x] Stream-group decision settled: stays `townhall` behind `SYSTEM_STREAM_GROUP` constant (user-confirmed)

## Remaining

- [ ] [COMM-TAG-FILTER] #1 — DEFERRED post-production (do not build for MVP)
- [ ] [ROLE-STUDIOS] #3 [Opus] (⛔ BLOCKED BY CLIENT — wants old-vs-new dashboard comparison)
- [ ] [RTMIG-4] #4 [Opus] — main unblocked loop: ~89 legacy `/old/*` pages → root
- [ ] [SSR-LOADER-DEAD] #5 · [CT-RESTYLE] #6 · [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13 · [PREFLIP-WT] #14 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #15 [Opus] · [MEM-CAP] #16 (MEMORY.md 89% → /r-prune-memory) · [DOCGEN-SPEC] #17 · [OLD-PORTED-CLEANUP] #18
- [ ] [LEARN-ISLAND-RESTYLE] #19 · [CREATE-ISLAND-RESTYLE] #20 · [TEACH-ISLAND-RESTYLE] #21 · [TRIAGE-RESTYLE] #22
- [ ] [V217-WATCH] #23 · [COURSEDETAIL-DEAD] #24 · [NUDGE-CACHE-FLASH] #25 · [NUDGE-TC-V2] #26 · [TW-V4] #27 · [TEST-FILE-COUNT] #28 · [PLAN-RENUM] #29
- [ ] [COMMONS-DATE] #30 · [DISCCARD-DEL] #31 · [TESTDOC-DRIFT] #32
- [ ] [SYS-RENAME-COSMETIC] #34 — ~26 files cosmetic townhall/commons var-names + comments + "TOWNHALL-SELECT" seed-post body + stale manual-doc mentions (ROLES.md:680, SCRIPTS.md:412, sentry.md:407) + consolidate promotion/types.ts SYSTEM_FEED_ID into system-feed.ts

## TodoWrite Items

- [ ] #1 [COMM-TAG-FILTER] (DEFERRED) · #3 [ROLE-STUDIOS] [Opus] (BLOCKED) · #4 [RTMIG-4] [Opus] · #5–#32 · #34 [SYS-RENAME-COSMETIC]

## Key Context

- **System feed rename (committed Step 6):** live system community is `id: comm-system` / `slug: system` / `name: System`; route `/api/feeds/system` (+ comments/reactions); component `SystemFeed`; D1 `feed_type`/`feed_group` enum = `'system'`. **Stream feed group stays `townhall:main`** behind `SYSTEM_STREAM_GROUP` in `src/lib/system-feed.ts` — Stream groups are dashboard-declared, not write-creatable (renaming 500s). Fully eliminating `townhall` would need a dashboard-created `system` group + constant flip.
- **`src/lib/system-feed.ts`** (NEW) is the canonical constants home: SLUG/COMMUNITY_ID/NAME/STREAM_GROUP/STREAM_ID. `promotion/types.ts` still has a duplicate `SYSTEM_FEED_ID='system'` → consolidate in [SYS-RENAME-COSMETIC].
- **Baseline verified THIS conv** = full 5-gate green (tsc / astro 0-0-1hint / lint / test **6713** / build).
- **Decisions routed** to `docs/decisions/01-architecture.md` + `02-database.md` + decision-log + INDEX + TIMELINE (Stream-group constraint, full rename, COMM-TAG-FILTER deferral).
- **Docs synced** (7 driftCheck docs): API-COMMUNITY/USERS, CLI-QUICKREF, TEST-COVERAGE/COMPONENTS, feeds.md, url-routing.md. TEST-COVERAGE counts were already stale pre-conv → corrected to disk.
- **Leftover local state:** dev server may still be running on :4321; local D1 re-seeded clean. Browser tabs from this + prior convs open.
- **MEMORY.md ~89%** of SessionStart byte cap → [MEM-CAP] #16 (`/r-prune-memory`).

## Resume Command

To continue: run `/r-start`. **Next** = [RTMIG-4] #4 is the main unblocked loop; [SYS-RENAME-COSMETIC] #34 is a quick residual sweep; [MEM-CAP] #16 is quick housekeeping. ROLE-STUDIOS blocked by client.
