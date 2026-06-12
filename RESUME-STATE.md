# State — Conv 274 (2026-06-12 ~14:30)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built **FEED-U3a** (promotion lifecycle substrate) + the **entire FEED-U3b** (entity-promo backbone + the A2 author-direct composer) — three committed, 5-gate-green units (code `792ec587`, `a3488f35`, `2cf95592`). U3a: 2 `platform_stats` dials + `loadPromotionConfig` + `purgeExpiredPromotions` + cron purge + dial-driven lane window; expiry is computed (no `expires_at`). U3b backbone: entity-promo posts render in the home feed via a `promoContext` seam keyed on `promoEntityId`. U3b A2 composer: `createEntityPromo` + `POST /api/feeds/promote-entity` + `GET /api/feeds/promotable-entities` + `EntityPromoComposer.tsx` (Option-A placement — author into the entity's own public feed; mount deferred to U3d). Full suite 6660 passing.

## Completed

- [x] [FEED-U3a] Backend substrate — dials + computed expiry + cron retention purge + lane default window (code `792ec587`)
- [x] [FEED-U3b backbone] entity-promo render path (`promoContext` + SmartFeed branch) + seed posts (code `a3488f35`)
- [x] [FEED-U3b A2 composer] createEntityPromo + promote-entity + promotable-entities endpoints + EntityPromoComposer (code `2cf95592`)

## Remaining

**Feed group (canonical plan: `plan/home-feed-merge/REASSEMBLY-CONV271.md`; U3a+U3b done → U3c next):**
- [ ] [FEED-U3] #1 [Opus] — **U3c next:** admin surface (password set/rotate UI, lifecycle-dial UI, System-promotion moderation view) **+ the announcement data model deferred here from U3a** (table + types + fan-out). Then **U3d:** PromoteNudge (self-gating island, `/creating`+`/teaching`) + mount `EntityPromoComposer` in that workspace prompt.
- [ ] [SYS-NAMING] #2 — owner-based feed naming (display strings only) · [PROMOTE-IDEMP] #3 · [API-DISC-DOC] #4 · [SYS-GET-GATE] #5 — independent cleanups
- [ ] [COMM-TAG-FILTER] #6 · [SUCCESS-COMMUNITY-VERIFY] #7 — PARKED (needs-spec)
- [ ] [DISC-RAILS-DOC] #37 — document `GET /api/discovery/rails` in the API-*.md set (pre-existing Conv 261 gap; needs route-mapping decision)

**Other backlog:**
- [ ] [ROLE-STUDIOS] #8 [Opus] (⛔ BLOCKED BY CLIENT) · [RTMIG-4] #9 [Opus] · [SSR-LOADER-DEAD] #10 · [CT-RESTYLE] #11 · [PRIM-MATCH-INDEX] #12 · [TXTBTN] #13 · [PROFILE-PRIM-SWEEP] #14 (PAUSED)
- [ ] [ICN-NS] #15 · [E2E-MIG] #16 · [E2E-GATE] #17 · [SHOWMORE] #18 · [PREFLIP-WT] #19 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #20 [Opus] · [MEM-CAP] #21 (MEMORY.md ~89% → /r-prune-memory) · [DOCGEN-SPEC] #22 · [OLD-PORTED-CLEANUP] #23
- [ ] [LEARN-ISLAND-RESTYLE] #24 · [CREATE-ISLAND-RESTYLE] #25 · [TEACH-ISLAND-RESTYLE] #26 · [TRIAGE-RESTYLE] #27
- [ ] [V217-WATCH] #28 · [COURSEDETAIL-DEAD] #29 · [NUDGE-CACHE-FLASH] #30 · [NUDGE-TC-V2] #31 · [TW-V4] #32 (incl. StickySignupBar.astro `backdrop-blur-sm`, SuggestionCard.tsx `flex-shrink-0`) · [TEST-FILE-COUNT] #33 · [PLAN-RENUM] #34
- [ ] [COMMONS-DATE] #35 — fixed founding date for comm-the-commons in dev seed
- [ ] [DISCCARD-DEL] #36 — delete orphaned DiscoveryCard.tsx after FEED-U2 client-vet

## TodoWrite Items

- [ ] #1 [FEED-U3] [Opus] (U3c next) · #2 [SYS-NAMING] · #3 #4 #5 cleanups · #6 #7 PARKED · #37 [DISC-RAILS-DOC]
- [ ] #8 [ROLE-STUDIOS] [Opus] (BLOCKED) · #9 [RTMIG-4] [Opus] · #10–#19 · #20 [TZ-AUDIT] [Opus] · #21–#36

## Key Context

- **FEED-U3 status:** U3a ✅ + U3b ✅ (backbone + A2 composer). U3c + U3d remain. SoT = `plan/home-feed-merge/REASSEMBLY-CONV271.md` (updated this conv with all 4 decisions + done markers).
- **4 decisions this conv** (in REASSEMBLY-CONV271.md + `docs/decisions/`): (1) promo expiry **computed from dial**, no `expires_at`; (2) announcement model **deferred from U3a to U3c**; (3) A2 composer **Option-A placement** (author into entity's own public feed → home discovery, NOT the unbuilt lane consumer); (4) composer **mount deferred to U3d**.
- **Entity-promo mechanism:** a Stream post w/ `postKind:'entity_promo'`+`promoEntityType`+`promoEntityId`; `enrichment.ts readPromoFields`→`promoContext` (anchor keyed on the PROMOTED entity); rendered by `SmartFeed.tsx` before the discovery branch; surfaces via the **marketing/discovery** path (the home feed does NOT consume the promoted lane — that UI consumer is unbuilt).
- **`EntityPromoComposer.tsx` is built but UNMOUNTED** — its `/creating`+`/teaching` home lands in U3d.
- **Baseline verified THIS conv** = full 5-gate green (tsc / astro 0-0-0 / lint / test **6660** / build) at the final commit.
- **MEMORY.md ~89%** of the SessionStart byte cap → [MEM-CAP] #21 (`/r-prune-memory`).
- All work committed (code `2cf95592`, docs to be committed by this /r-end); not pushed until /r-end Step 7.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Then start [FEED-U3] #1 → U3c** (admin surface + the deferred announcement data model) — the next feed unit.
