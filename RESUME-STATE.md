# State — Conv 263 (2026-06-11 ~10:17)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Design-only conv: **locked the full PROMOTE-PIPELINE delivery-system design** (no code written). Worked through the mechanics of how promotion interacts with Stream and settled on **Model ① "reference + teaser lane"** — promoted posts live in **D1 only**, never written to Stream; higher-feed appearances are assembled at read time (lane query → enrich-by-id → display-only teaser). Decided inbound-visitor **posture A** (read-only source feeds → handed to a prioritized `[VISITOR-GATING]` #29), **auto-live + post-hoc takedown** moderation, a **14d active / 60d D1-retention** lifecycle (new `[PROMO-LIFECYCLE]` #36), a **"Visit Feed"** feed-level CTA, **author-direct-at-target** entity-promo **templates**, and a **PromoteNudge** family (both per-post + workspace). All persisted to `plan/home-feed-merge/README.md` (four new sections + a 7-step build sequence). Also fixed a recurring process miss: **option labels must be typeable Latin, never symbols** (α/β, ①②③) — extended `feedback_option_phrasing.md` + CLAUDE.md ×2 + MEMORY.md.

## Completed

- [x] [PROMOTE-PIPELINE] #30 — full delivery-system DESIGN locked (Model ① reference-lane · posture A · auto-live+takedown · 14d/60d lifecycle · Visit-Feed CTA · author-direct templates · PromoteNudge · 7-step build sequence). Build pending; design in plan SoT.
- [x] [VISITOR-GATING] #29 — posture-A contract recorded + PRIORITIZED (runs first; closes the 🔴 auth-only react/comment gap)
- [x] Option-labeling rule (typeable Latin, never symbols) → CLAUDE.md §Recurring-Failures + §User-Facing-Questions + `feedback_option_phrasing.md` + MEMORY.md

## Remaining

- [ ] [VISITOR-GATING] #29 [Opus] **[PRIORITY — runs first]** — posture A: read-only source feeds; close react/comment auth-only gap across 6 endpoints via one `canParticipate` predicate + "Join to participate" CTA + 403 tests
- [ ] [PROMOTE-PIPELINE] #30 [Opus] — BUILD the locked design (7-step sequence): (1) promote.ts copy→reference + drop target_activity_id + lane joins source_activity_id; (2) lane injection (Home/community page/admin System view) + feed-GET canPromote flag; (3) Promote button [needs #28]; (4) templates + CommunityAnchor + composer [needs #28]; (5) PROMO-LIFECYCLE; (6) ADMIN-FEED-UI; (7) PromoteNudge LAST. SoT plan/home-feed-merge/README.md.
- [ ] [PROMO-LIFECYCLE] #36 [Opus] — active 14d + D1 retention 60d, cron purge (`workers/cron/`) + platform_stats dials + admin UI (folds into #31)
- [ ] [HOME-FEED-MERGE] #28 [Opus] — phase-4 live-wiring (gates PROMOTE-PIPELINE Promote button + composer)
- [ ] [ADMIN-FEED-UI] #31 [Opus] — Announcement model + fan-out + promotion-password admin UI + duration dials + System-promotion takedown view
- [ ] [RECO-UNIFY] #32 [Opus] — unify reco bands onto Discovery Rails + Promoted lane
- [ ] [ROLE-STUDIOS] #1 — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison sign-off)
- [ ] [RTMIG-4] #2 [Opus] · [ENTITY-ANCHOR] #3 [Opus] (now home for per-post permalink + notifications action_url) · [SSR-LOADER-DEAD] #4
- [ ] [COMM-TAG-FILTER] #5 · [CT-RESTYLE] #6 · [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 (watch) · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13 · [PREFLIP-WT] #14 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #15 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #16 · [MEM-CAP] #17 (MEMORY.md ~86% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #24 · [COURSEDETAIL-DEAD] #25 · [NUDGE-CACHE-FLASH] #26 · [NUDGE-TC-V2] #27
- [ ] [VISITOR-GATING] #29 (see top) · [SYS-NAMING] #33 · [API-DISC-DOC] #34 · [DISC-SEED] #35

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] (BLOCKED) · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] [Opus] · #4 [SSR-LOADER-DEAD]
- [ ] #5 [COMM-TAG-FILTER] · #6 [CT-RESTYLE] · #7 [PRIM-MATCH-INDEX] · #8 [TXTBTN] · #9 [PROFILE-PRIM-SWEEP]
- [ ] #10 [ICN-NS] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [SHOWMORE] · #14 [PREFLIP-WT]
- [ ] #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY] · #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP]
- [ ] #20 [LEARN-ISLAND-RESTYLE] · #21 [CREATE-ISLAND-RESTYLE] · #22 [TEACH-ISLAND-RESTYLE] · #23 [TRIAGE-RESTYLE]
- [ ] #24 [V217-WATCH] · #25 [COURSEDETAIL-DEAD] · #26 [NUDGE-CACHE-FLASH] · #27 [NUDGE-TC-V2]
- [ ] #28 [HOME-FEED-MERGE] [Opus] · #29 [VISITOR-GATING] [Opus] [PRIORITY] · #30 [PROMOTE-PIPELINE] [Opus] (design done; build pending)
- [ ] #31 [ADMIN-FEED-UI] [Opus] · #32 [RECO-UNIFY] [Opus] · #33 [SYS-NAMING] · #34 [API-DISC-DOC] · #35 [DISC-SEED] · #36 [PROMO-LIFECYCLE] [Opus]

## Key Context

- **PROMOTE-PIPELINE design is COMPLETE and persisted** — `plan/home-feed-merge/README.md` §§ Delivery model + lifecycle / Templates / Promote-nudges / Build sequence. Build is the next phase; nothing built this conv.
- **Model ① = D1-only promotions.** No Stream write at any level. `promote.ts` must be rewritten copy→reference; drop `post_promotions.target_activity_id`; `lane.ts` joins `source_activity_id`. The shipped Conv-262 copy-based promote.ts is a rewrite-to-simpler.
- **Push vs pull:** native feeds + timeline use Stream push (in-boundary); promotion uses pull (D1 query + enrich-by-id, cross-boundary). ② TO-target was rejected because System is admin-only + `autoJoinTheCommons` was retired (no fanout reaches students).
- **🔴 Pre-existing gap (for #29):** `POST /api/feeds/{course|community}/[slug]/{reactions,comments}` gate on auth ONLY — no membership/enrollment check. Posture A closes it.
- **Build dependencies:** Promote button + template composer need [HOME-FEED-MERGE] #28 phase-4. [VISITOR-GATING] #29 is independent → runs first.
- **New primitive needed:** `CommunityAnchor` (parallel to `CourseAnchor`; 9 entity anchors exist, none for community).
- **MEMORY.md ~86% byte cap** ([MEM-CAP] #17) — this conv added to the option-phrasing line; prune soon.
- **No baseline run this conv** (design-only, zero code changes — code repo clean). Last verified baseline: Conv 262 (6547/6547), not re-verified this conv.
- Docs commit (CLAUDE.md + plan README + memory mirror + session files) lands at this /r-end. Code repo unchanged.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
