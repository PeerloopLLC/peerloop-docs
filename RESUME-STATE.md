# State — Conv 265 (2026-06-11 ~12:23)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built **PROMOTE-PIPELINE Steps 1–2** (the runs-first piece of the Feeds-redesign arc). **Step 1 — foundation correction (copy → reference, Model ①):** `promote.ts` endpoint rewritten to record ONE D1 `post_promotions` row referencing the canonical source activity (no Stream write / no duplicate); dropped `post_promotions.target_activity_id` (+ index); `lane.ts` JOIN re-pointed to `source_activity_id` (`PromotedEntry.sourceActivityId`). **Step 2 — `canPromote` flag:** community + course feed GETs now return a correct `canPromote` (role-allowed ∧ target-exists ∧ not top-of-chain System); +11 endpoint tests. **Also dropped the orphaned `feed_activities.promoted_from_activity_id`** (col + index + `indexFeedActivity` param) — Model ① has no writer for it (user-approved). Lane **rendering** folded into #28 (Home/community teasers) + #30 (admin System view) — read-side already exists. Baseline **6581/6581** green (all 5 gates). PROMOTE-PIPELINE Steps 3–7 remain; 3–4 gated on #28 phase-4.

## Completed

- [x] [PROMOTE-PIPELINE] Step 1 — foundation correction (copy→reference Model ①): schema, `recordPromotion`, `lane.ts`, `promote.ts` endpoint, 2 tests rewritten.
- [x] [PROMOTE-PIPELINE] Step 2 — `canPromote` flag on community + course feed GETs (+11 tests).
- [x] Dropped orphaned `feed_activities.promoted_from_activity_id` (col + index + param).
- [x] Baseline verified this conv — 6581/6581, tsc + astro + lint + build green.
- [x] Docs: `API-COMMUNITY.md` + `feeds.md` updated to Model ① + `canPromote`; decision routed to `docs/decisions/02-database.md`.

## Remaining

- [ ] [HOME-FEED-MERGE] #28 [Opus] **[NEXT]** — phase-4 live-wiring of merged home feed; absorbs the "Join to participate" CTA. **Gates PROMOTE-PIPELINE Steps 3–4.** Recommended entry **A (backend-first: build phases 1–3 = `getMarketingCandidates` builder + cursor rework + un-gate `/api/feeds/smart`)** over B (render-first phase 4). Prereqs exist (FeedPost adapter Conv 260, discovery-rails layer Conv 262). SoT `plan/home-feed-merge/README.md` § Build phases.
- [ ] [PROMOTE-PIPELINE] #29 [Opus] — Steps 1–2 DONE; **Steps 3–7 remain:** 3 Promote button (needs #28) · 4 templates+CommunityAnchor+composer (needs #28) · 5 PROMO-LIFECYCLE (#35) · 6 ADMIN-FEED-UI (#30) · 7 PromoteNudge (LAST). SoT `plan/home-feed-merge/README.md` § Build sequence.
- [ ] [ADMIN-FEED-UI] #30 [Opus] · [RECO-UNIFY] #31 [Opus] · [PROMO-LIFECYCLE] #35 [Opus] — downstream PROMOTE-PIPELINE chain. #30 also gets the admin System-view lane (moderation) + password UI + duration dials.
- [ ] [SYS-GET-GATE] #36 — townhall *comments GET* still auth-only though System feed is admin-only to view; gate to admin OR confirm unreachable. Low risk.
- [ ] [SYS-NAMING] #32 · [API-DISC-DOC] #33 (covers the open `/api/discovery/rails` doc gap — re-flagged by docs agent Conv 265) · [DISC-SEED] #34
- [ ] [ROLE-STUDIOS] #1 — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison sign-off)
- [ ] [RTMIG-4] #2 [Opus] · [ENTITY-ANCHOR] #3 [Opus] · [SSR-LOADER-DEAD] #4
- [ ] [COMM-TAG-FILTER] #5 · [CT-RESTYLE] #6 · [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 (watch) · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13 · [PREFLIP-WT] #14 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #15 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #16 · [MEM-CAP] #17 (MEMORY.md ~87% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #24 · [COURSEDETAIL-DEAD] #25 · [NUDGE-CACHE-FLASH] #26 · [NUDGE-TC-V2] #27

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] (BLOCKED) · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] [Opus] · #4 [SSR-LOADER-DEAD]
- [ ] #5 [COMM-TAG-FILTER] · #6 [CT-RESTYLE] · #7 [PRIM-MATCH-INDEX] · #8 [TXTBTN] · #9 [PROFILE-PRIM-SWEEP]
- [ ] #10 [ICN-NS] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [SHOWMORE] · #14 [PREFLIP-WT]
- [ ] #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY] · #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP]
- [ ] #20 [LEARN-ISLAND-RESTYLE] · #21 [CREATE-ISLAND-RESTYLE] · #22 [TEACH-ISLAND-RESTYLE] · #23 [TRIAGE-RESTYLE]
- [ ] #24 [V217-WATCH] · #25 [COURSEDETAIL-DEAD] · #26 [NUDGE-CACHE-FLASH] · #27 [NUDGE-TC-V2]
- [ ] #28 [HOME-FEED-MERGE] [Opus] [NEXT] · #29 [PROMOTE-PIPELINE] [Opus] (Steps 3–7)
- [ ] #30 [ADMIN-FEED-UI] [Opus] · #31 [RECO-UNIFY] [Opus] · #32 [SYS-NAMING] · #33 [API-DISC-DOC] · #34 [DISC-SEED] · #35 [PROMO-LIFECYCLE] [Opus] · #36 [SYS-GET-GATE]

## Key Context

- **PROMOTE-PIPELINE delivery = Model ① reference-lane.** A promotion writes ONE `post_promotions` row (canonical `source_activity_id` + target feed via `to_feed_type`/`to_feed_id`). NO Stream write, NO duplicate activity, NO target `feed_activities` row. Every higher-feed appearance is assembled at read time: `getPromotedActivities` (D1) → source `stream_activity_id` → `getActivitiesByIds` enrich → display-only teaser. Engagement stays on the original post.
- **Dropped columns (this conv):** `post_promotions.target_activity_id` (+ idx) and `feed_activities.promoted_from_activity_id` (+ idx + `indexFeedActivity` param). Both orphaned by Model ①.
- **`canPromote` flag (Step 2):** community + course feed GET responses now carry `canPromote`. Computed = session ∧ role-allowed (`canPromote` lib) ∧ a resolvable target (`resolvePromotionTarget !== null`) ∧ not the top-of-chain System feed. Course needs the target probe (no-progression course → false); community is role-only (always resolves to System). This is the gate signal the future per-post `PromoteNudge` consumes (avoids 403-after-click).
- **Lane injection folded out (Q1=A):** the lane read-side already exists (`getPromotedActivities` + `GET /api/feeds/promoted`, Conv 262). Teaser **rendering** belongs to #28 (Home + community-page FeedPost) and #30 (admin System moderation view). No durable server-only injection that isn't redundant or in #28's `getSmartFeed` rewrite path.
- **Next conv = #28 HOME-FEED-MERGE.** Recommended entry **A (backend-first, phases 1–3)** — pure server/data, fully testable, sets up the client phases. It's the critical-path bottleneck for the whole feeds/promotion arc.
- **Baseline:** verified THIS conv — 6581/6581 tests, tsc + astro check + lint + build all green.
- Code + docs commits land at this /r-end.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
