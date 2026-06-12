# State — Conv 276 (2026-06-12 ~17:35)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Recovered from a Conv-275 crash (restored the staged-deleted RESUME-STATE.md, 37 tasks intact) then advanced **FEED-U3c** — the promotion-system admin surface. Shipped three of U3c's four sub-verticals this conv, all browser-verified and 5-gate green: ① + ② the **Promotion Settings page** (`/admin/promotion-settings` — password set/rotate + lifecycle-dial editing + new `/api/admin/promotion-config` write endpoint), and ③ the **System-promotion moderation view** (a "System Promotions" tab on `/admin/moderation` with list + take-down). Will be committed in Step 6 (not yet pushed at write time). Remaining in U3c: ④ announcement model + fan-out (carries a novel architecture decision); then U3d.

## Completed

- [x] /r-start crash recovery (Conv 275 → 276), 37 tasks restored from HEAD's RESUME-STATE.md
- [x] FEED-U3c ① password set/rotate UI (drives existing `/api/admin/promotion-password`)
- [x] FEED-U3c ② lifecycle-dial UI + new `/api/admin/promotion-config` write endpoint
- [x] FEED-U3c ③ System-promotion moderation view (lib + 2 endpoints + tab shell)
- [x] Both slices browser-verified end-to-end (Chrome bridge, admin=brian)
- [x] 5 gates green (tsc / astro 0-0-0 / lint / test **6671** / build)

## Remaining

**Feed group (canonical plan: `plan/home-feed-merge/REASSEMBLY-CONV271.md`; U3c ①②③ done → ④ next):**
- [ ] [FEED-U3] #1 [Opus] — **U3c ④ next:** announcement data model + author + fan-out. **Decide fan-out architecture FIRST** (new `announcements` table query-on-read vs per-user notification rows vs a smart-feed Announcements lane — none exists today; CLAUDE.md §Critical Rule). Then **U3d:** PromoteNudge self-gating island (`/creating`+`/teaching`) + mount the already-built `EntityPromoComposer.tsx`. Possible follow-up: audit log for System-promotion removals (`moderation_actions.flag_id` is NOT NULL→content_flags, so it needs its own mechanism).
- [ ] [SYS-NAMING] #2 · [PROMOTE-IDEMP] #3 · [API-DISC-DOC] #4 · [SYS-GET-GATE] #5 — independent feed-group cleanups
- [ ] [COMM-TAG-FILTER] #6 · [SUCCESS-COMMUNITY-VERIFY] #7 — PARKED (needs-spec)
- [ ] [DISC-RAILS-DOC] #37 — document `GET /api/discovery/rails` in API-COMMUNITY.md (driftCheck; pre-existing Conv 261 gap, re-surfaced by the docs agent this conv)

**Other backlog:**
- [ ] [ROLE-STUDIOS] #8 [Opus] (⛔ BLOCKED BY CLIENT) · [RTMIG-4] #9 [Opus] · [SSR-LOADER-DEAD] #10 · [CT-RESTYLE] #11 · [PRIM-MATCH-INDEX] #12 · [TXTBTN] #13 · [PROFILE-PRIM-SWEEP] #14 (PAUSED)
- [ ] [ICN-NS] #15 · [E2E-MIG] #16 · [E2E-GATE] #17 · [SHOWMORE] #18 · [PREFLIP-WT] #19 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #20 [Opus] · [MEM-CAP] #21 (MEMORY.md 89% → /r-prune-memory) · [DOCGEN-SPEC] #22 · [OLD-PORTED-CLEANUP] #23
- [ ] [LEARN-ISLAND-RESTYLE] #24 · [CREATE-ISLAND-RESTYLE] #25 · [TEACH-ISLAND-RESTYLE] #26 · [TRIAGE-RESTYLE] #27
- [ ] [V217-WATCH] #28 · [COURSEDETAIL-DEAD] #29 · [NUDGE-CACHE-FLASH] #30 · [NUDGE-TC-V2] #31 · [TW-V4] #32 (incl. StickySignupBar.astro `backdrop-blur-sm`, SuggestionCard.tsx `flex-shrink-0`) · [TEST-FILE-COUNT] #33 · [PLAN-RENUM] #34
- [ ] [COMMONS-DATE] #35 · [DISCCARD-DEL] #36

## TodoWrite Items

- [ ] #1 [FEED-U3] [Opus] (U3c④ next) · #2 [SYS-NAMING] · #3 #4 #5 cleanups · #6 #7 PARKED · #37 [DISC-RAILS-DOC]
- [ ] #8 [ROLE-STUDIOS] [Opus] (BLOCKED) · #9 [RTMIG-4] [Opus] · #10–#19 · #20 [TZ-AUDIT] [Opus] · #21–#36

## Key Context

- **FEED-U3c status:** ① + ② + ③ done this conv (browser-verified). ④ + U3d remain. SoT = `plan/home-feed-merge/REASSEMBLY-CONV271.md` (updated this conv with the ①②③ done markers + verification notes).
- **New code (will be committed Step 6):** `src/lib/promotion/{config.ts savePromotionConfig, moderation.ts listSystemPromotions/removeSystemPromotion}`; endpoints `/api/admin/promotion-config` (GET/POST) + `/api/admin/moderation/promotions/{index, [id]/remove}`; components `PromotionSettingsAdmin.tsx`, `SystemPromotionsModeration.tsx`, `ModerationPage.tsx` (tab shell); page `/admin/promotion-settings.astro` (`@matt-inspired`); `moderation.astro` rewired to ModerationPage; AdminNavbar "Settings" section. Tests: `promotion-config.test.ts` (+4), `promotion-moderation.test.ts` (+7).
- **U3c ③ semantics:** system-only scope (`to_feed_type='system'`), admin-gated (`requireRole(['admin'])`), removal = scope-guarded delete of the `post_promotions` row only (model ① — source post untouched, verified in D1). No `moderation_actions` audit (its `flag_id` is NOT NULL→content_flags).
- **3 decisions routed** to `docs/decisions/` (04-auth: moderation scope/gating; 05-ui-ux-components: `@matt-inspired` for net-new admin pages) + decision-log + INDEX; 1 TIMELINE entry.
- **Local D1 (dev :4321):** promotion gate left CONFIGURED (set to `PromoGate2026!` during ① verify); dials reset to 14/60; the ③ verify seed (`pp-verify-001`) was removed by the test. A `db:setup:local:dev` re-seed clears the gate password.
- **Baseline verified THIS conv** = full 5-gate green (tsc / astro 0-0-0 / lint / test **6671** / build) at the ③ build.
- **MEMORY.md ~89%** of the SessionStart byte cap → [MEM-CAP] #21 (`/r-prune-memory`).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Then for [FEED-U3] #1 → U3c ④**, first decide the announcement fan-out architecture (open question), then build.
