# State — Conv 264 (2026-06-11 ~11:18)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built **[VISITOR-GATING] #29 server-side** (the PRIORITIZED, runs-first piece of the Feeds-redesign arc): closed the 🔴 pre-existing gap where the 6 feed reaction/comment endpoints gated on auth only. New `src/lib/feed-participation.ts` (`canParticipate` predicate + `checkCourseParticipation`/`checkCommunityParticipation`) is now the single source of truth; all 6 mutating endpoints ({community,course,townhall}×{reactions,comments}) gate POST/DELETE on participation (community→member · course→creator/admin/teacher/enrolled · system→admin-only); GET stays open per posture A. Refactored `course/[slug].ts` + `community/[slug].ts` onto the shared helper (deleted their inline copies). +23 tests (2 new course test files); **baseline 6570/6570 green** (tsc/lint/astro/build all pass). The "Join to participate" client CTA was **folded into [HOME-FEED-MERGE] #28** (user choice). New follow-up **[SYS-GET-GATE] #37**. **PROMOTE-PIPELINE #30 build deferred to next conv** by the user.

## Completed

- [x] [VISITOR-GATING] #29 — server-side posture-A participation gating across 6 endpoints; shared `feed-participation.ts`; 2 source handlers refactored onto it; +23 tests; baseline 6570/6570 green.

## Remaining

- [ ] [PROMOTE-PIPELINE] #30 [Opus] **[NEXT]** — BUILD the locked design, Steps 1–2 first (both unblocked, no #28 dep): (1) foundation correction — rewrite `promote.ts` copy→reference (0 Stream writes), drop `post_promotions.target_activity_id`, `lane.ts` joins `source_activity_id`; (2) lane injection (Home/community page/admin System view) + feed-GET `canPromote` flag. Then Steps 3–4 (Promote button + template composer) need #28. SoT `plan/home-feed-merge/README.md` § Build sequence.
- [ ] [HOME-FEED-MERGE] #28 [Opus] — phase-4 live-wiring; **now also absorbs the [VISITOR-GATING] "Join to participate" client CTA** (surfaces the 403s in FeedPost; shares intent-preserving-signup machinery). Gates PROMOTE-PIPELINE Steps 3–4.
- [ ] [ADMIN-FEED-UI] #31 [Opus] · [RECO-UNIFY] #32 [Opus] · [PROMO-LIFECYCLE] #36 [Opus] — downstream PROMOTE-PIPELINE chain.
- [ ] [SYS-GET-GATE] #37 — townhall *comments GET* still auth-only though System feed is admin-only to view; gate to admin OR confirm unreachable. Low risk.
- [ ] [SYS-NAMING] #33 · [API-DISC-DOC] #34 (covers the open `/api/discovery/rails` doc gap) · [DISC-SEED] #35
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
- [ ] #28 [HOME-FEED-MERGE] [Opus] (absorbs "Join to participate" CTA) · #30 [PROMOTE-PIPELINE] [Opus] [NEXT]
- [ ] #31 [ADMIN-FEED-UI] [Opus] · #32 [RECO-UNIFY] [Opus] · #33 [SYS-NAMING] · #34 [API-DISC-DOC] · #35 [DISC-SEED] · #36 [PROMO-LIFECYCLE] [Opus] · #37 [SYS-GET-GATE]

## Key Context

- **VISITOR-GATING server-side is DONE.** `src/lib/feed-participation.ts` is the single source of truth — `canParticipate(db, userId, ref)` where ref = `{type:'community',slug}` | `{type:'course',slug}` | `{type:'system'}`. Returns `{allowed, role, status, error, message}`; endpoints map `!allowed` → `Response.json({error,message},{status})` (403 deny / 404 missing entity).
- **Gate placement:** after input validation, before Stream calls. Comment endpoints use a block-scoped `{ let gateDb; ... }` to avoid colliding with the handler's existing `db`/`user` locals.
- **Townhall (System) = admin-only** for react/comment (matches the source feed's SYS-RENAME lockdown). Community = member; course = creator/admin/teacher/enrolled.
- **GET (read) intentionally NOT gated** — posture A keeps viewing open. EXCEPTION flagged: townhall comments GET is auth-only though the System feed is admin-only to view → [SYS-GET-GATE] #37.
- **Next conv: PROMOTE-PIPELINE #30 Steps 1–2** (foundation correction + lane injection) — both independent of #28. Model ① = D1-only promotions (no Stream write).
- **Baseline:** verified THIS conv — 6570/6570 tests, tsc + astro check + lint + build all green.
- Docs: `plan/home-feed-merge/README.md` Status + build-sequence updated; `docs/reference/API-COMMUNITY.md` got 3 participation-gate callouts; a decision routed to `docs/decisions/04-auth.md`.
- Code + docs commits land at this /r-end.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
