# State — Conv 262 (2026-06-10 ~21:20)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Caught and reverted a **premature production deploy** (the `peerloop-cron` worker had been deployed to prod from a dev branch when DISCOVERY-RAILS #30's "prod deploy" was taken literally) — re-scoped #30 to staging-complete, folded the prod deploy into the gated MVP-GOLIVE block, and recorded the rule "staging is the only deploy target; prod is gated behind launch." Then resolved the 4 **promotion password-gate** clarifications and **built the [PROMOTE-PIPELINE] backend foundation + Promoted-lane read-side** (schema, lib, 3 endpoints, 24 tests), all 5 gates green, full suite **6547/6547**. Committed twice (foundation `581be011`/`aa37ea3`; the lane increment commits at this /r-end).

## Completed

- [x] [DISCOVERY-RAILS] #30 — re-scoped to staging-complete; prod deploy folded into MVP-GOLIVE (premature prod cron reverted); rule recorded as `feedback_staging_is_deploy_target_prod_gated`
- [x] [PROMOTE-PIPELINE] #31 password-gate policy RESOLVED (one global · per-promotion · bcrypt in platform_stats · every step gated) + **backend foundation BUILT** (post_promotions table + feed_activities lineage column; src/lib/promotion/ target/permissions/gate/promote/lane; POST /api/feeds/promote, GET|POST /api/admin/promotion-password, GET /api/feeds/promoted; 24 tests)

## Remaining

- [ ] [PROMOTE-PIPELINE] #31 [Opus] — **epic continues:** Promote button in FeedPost + per-promotion password prompt (**WAIT for [HOME-FEED-MERGE] #28 phase-4 live-wiring** to avoid rework); promote-a-course/community templates (give the Promoted lane its *entity* rail entries); promote-nudges; `/admin` password UI (folds into [ADMIN-FEED-UI] #33). SoT `plan/home-feed-merge/README.md` § PROMOTE-PIPELINE.
- [ ] [ROLE-STUDIOS] #1 — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison sign-off)
- [ ] [RTMIG-4] #2 [Opus] · [ENTITY-ANCHOR] #3 · [SSR-LOADER-DEAD] #4
- [ ] [COMM-TAG-FILTER] #5 · [CT-RESTYLE] #6 · [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 (watch) · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13 (ties POST-MATT) · [PREFLIP-WT] #14 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #15 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #16 · [MEM-CAP] #17 (MEMORY.md ~85% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19 (44 ported /old copies)
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #24 · [COURSEDETAIL-DEAD] #25 · [NUDGE-CACHE-FLASH] #26 · [NUDGE-TC-V2] #27 [Opus]
- [ ] [HOME-FEED-MERGE] #28 [Opus] (phase 4 live-wires POST-MATT FeedPost + consumes discovery client + promote button) · [VISITOR-GATING] #29 [Opus]
- [ ] [ADMIN-FEED-UI] #32 [Opus] (Announcement model + fan-out; also promotion-password admin UI) · [RECO-UNIFY] #33 [Opus] (Promoted lane is one rail source — uses getPromotedActivities) · [SYS-NAMING] #34
- [ ] [API-DISC-DOC] #35 — document GET /api/discovery/rails (driftCheck gap; needs route-mapping.txt `discovery|` line + an API-*.md home; placement API-DISCOVERY.md vs fold into API-RECOMMENDATIONS.md) · [DISC-SEED] #36 (richer staging seed)

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] (BLOCKED) · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] · #4 [SSR-LOADER-DEAD]
- [ ] #5 [COMM-TAG-FILTER] · #6 [CT-RESTYLE] · #7 [PRIM-MATCH-INDEX] · #8 [TXTBTN] · #9 [PROFILE-PRIM-SWEEP]
- [ ] #10 [ICN-NS] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [SHOWMORE] · #14 [PREFLIP-WT]
- [ ] #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY] · #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP]
- [ ] #20 [LEARN-ISLAND-RESTYLE] · #21 [CREATE-ISLAND-RESTYLE] · #22 [TEACH-ISLAND-RESTYLE] · #23 [TRIAGE-RESTYLE]
- [ ] #24 [V217-WATCH] · #25 [COURSEDETAIL-DEAD] · #26 [NUDGE-CACHE-FLASH] · #27 [NUDGE-TC-V2] [Opus]
- [ ] #28 [HOME-FEED-MERGE] [Opus] · #29 [VISITOR-GATING] [Opus] · #31 [PROMOTE-PIPELINE] [Opus] (foundation+lane done; epic continues)
- [ ] #32 [ADMIN-FEED-UI] [Opus] · #33 [RECO-UNIFY] [Opus] · #34 [SYS-NAMING] · #35 [API-DISC-DOC] · #36 [DISC-SEED]

## Key Context

- **PROMOTE-PIPELINE backend is built + tested; only UI/content layers remain.** The promote flow (Course→Community→System) escalation, the bcrypt password gate (platform_stats key `promotion_gate_password_hash`, fail-closed), and the Promoted-lane read-side (`getPromotedActivities`) all exist. SoT: `plan/home-feed-merge/README.md` § PROMOTE-PIPELINE.
- **`canPromote` is a capability separate from `canPost`** — admin / course-creator / certified-teacher (Course→Community) and admin / community-creator / certified-teacher-in-community (Community→System). It deliberately bypasses the admin-only System-feed posting rule; the password gate makes that safe.
- **Next epic piece without a #28 dependency** = promote-a-course/community templates (the Promoted *rail*'s entity entries). The Promote *button* must wait for #28 phase-4.
- **Promotion endpoints are documented** (API-COMMUNITY.md § Promotion, API-ADMIN.md § Promotion Password, feeds.md, TEST-COVERAGE.md) — the "document 3 endpoints" follow-up is DONE.
- **DISCOVERY-RAILS prod deploy is NOT a feature task** — it's gated in MVP-GOLIVE.CRON-CLEANUP (the cron worker runs both BBB cleanup + discovery refresh). Prod is undeployed; never run `deploy:prod`/`deploy:cron:prod` for features (memory `feedback_staging_is_deploy_target_prod_gated`).
- **Schema edits land in `migrations/0001_schema.sql`** directly (prod pre-launch) — the new tables are there.
- **MEMORY.md ~85% byte cap** ([MEM-CAP] #17) — run /r-prune-memory soon.
- **Baseline verified THIS conv:** tsc 0 · astro 0/0/0 · lint clean · tailwind clean · full suite **6547/6547** (379 files) · build ✓.
- Code: foundation committed `581be011`; lane increment + docs commit land at this /r-end.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
