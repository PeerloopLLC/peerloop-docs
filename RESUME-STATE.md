# State — Conv 270 (2026-06-11 ~22:07)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Closed **`[HOME-FEED-MERGE]` #28** — built the `[VISITOR-GATING]` "Join to participate" CTA (form A, on `FeedActivityCard` only) + the three deferred cosmetic-polish remnants (scope A): `DiscoveryCard` Matt-token restyle, visitor-aware `SmartFeed` (new server `viewerAuthenticated` flag hides member-only tabs), `StickySignupBar` mobile stack. Browser-verified both auth states (Phase-6 intent-preserving `ctaUrl` confirmed preserved). The heavier `FeedPost`+entity-anchor sample-post migration was scoped OUT and handed off to #3/#31. Then planned **tomorrow's path through the whole Feed/Promotion/Discovery group** — see Key Context.

## Completed

- [x] [VISITOR-GATING] "Join to participate" CTA (form A) on `FeedActivityCard` — `canParticipate` prop (default true) + `deriveJoinUrl`; +4 tests
- [x] [HOME-FEED-MERGE] #28 cosmetic remnants (scope A): DiscoveryCard Matt restyle (ghost outlined CTA, ctaUrl preserved) · visitor-aware SmartFeed (`viewerAuthenticated` flag) · StickySignupBar mobile stack; +4 tests
- [x] #28 CLOSED; browser-verified both auth states; committed (code `1ea1a2b8`, docs `af5bd2d`) + this /r-end commit
- [x] Slack handoff: #3/#31 descriptions carry `⤵ INHERITED FROM #28` + ctaUrl-preservation warning; recorded in plan README
- [x] Tomorrow's Feed/Promotion/Discovery sequence written to `plan/home-feed-merge/README.md` § Remaining-work sequence; created #39/#40 with `#40 blocks #29/#31`

## Remaining

**▶ TOMORROW'S FOCUS — Feed/Promotion/Discovery group (full path in `plan/home-feed-merge/README.md` § Remaining-work sequence):**
- [ ] Enablers first: [SEED-STREAM-FIDELITY] #39 → [COMMUNITY-ANCHOR] #40 (#40 blocks #29 Step 4 + #31)
- [ ] PROMOTE spine: [PROMOTE-PIPELINE] #29 [Opus] Step 4 → [PROMO-LIFECYCLE] #35 [Opus] → [ADMIN-FEED-UI] #30 [Opus] → [RECO-UNIFY] #31 [Opus] (spillover candidate) → #29 Step 7 PromoteNudge (LAST)
- [ ] Small cleanups (palate-cleansers, no deps): [API-DISC-DOC] #33 · [SYS-NAMING] #32 · [SYS-GET-GATE] #36 · [FEEDSHUB-ORPHAN] #37
- [ ] [DISC-SEED] #34 — broader discovery seed (parent of #39)
- [ ] Must-finish spine = #39→#40→#29→#35→#30→#29-Step7; drop #31 first if short on time

**Other backlog (unchanged):**
- [ ] [ROLE-STUDIOS] #1 [Opus] — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison sign-off)
- [ ] [RTMIG-4] #2 [Opus] · [SSR-LOADER-DEAD] #4 · [COMM-TAG-FILTER] #5 · [CT-RESTYLE] #6 · [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 (watch) · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13 · [PREFLIP-WT] #14 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #15 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #16 · [MEM-CAP] #17 (MEMORY.md ~87% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #24 · [COURSEDETAIL-DEAD] #25 · [NUDGE-CACHE-FLASH] #26 · [NUDGE-TC-V2] #27 · [TW-V4] #38
- [ ] [TEST-FILE-COUNT] #41 (stale TEST-COMPONENTS.md total) · [PLAN-RENUM] #42 (stale #3x plan numbers)

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] [Opus] (BLOCKED) · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] [Opus] (owns CommunityAnchor+meta for FeedPost migration) · #4 [SSR-LOADER-DEAD]
- [ ] #5 [COMM-TAG-FILTER] · #6 [CT-RESTYLE] · #7 [PRIM-MATCH-INDEX] · #8 [TXTBTN] · #9 [PROFILE-PRIM-SWEEP]
- [ ] #10 [ICN-NS] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [SHOWMORE] · #14 [PREFLIP-WT]
- [ ] #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY] · #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP]
- [ ] #20 [LEARN-ISLAND-RESTYLE] · #21 [CREATE-ISLAND-RESTYLE] · #22 [TEACH-ISLAND-RESTYLE] · #23 [TRIAGE-RESTYLE]
- [ ] #24 [V217-WATCH] · #25 [COURSEDETAIL-DEAD] · #26 [NUDGE-CACHE-FLASH] · #27 [NUDGE-TC-V2]
- [ ] #29 [PROMOTE-PIPELINE] [Opus] (blocked by #40) · #30 [ADMIN-FEED-UI] [Opus] · #31 [RECO-UNIFY] [Opus] (blocked by #40; owns FeedPost render swap)
- [ ] #32 [SYS-NAMING] · #33 [API-DISC-DOC] · #34 [DISC-SEED] · #35 [PROMO-LIFECYCLE] [Opus] · #36 [SYS-GET-GATE] · #37 [FEEDSHUB-ORPHAN] · #38 [TW-V4]
- [ ] #39 [SEED-STREAM-FIDELITY] (enabler) · #40 [COMMUNITY-ANCHOR] (blocks #29/#31) · #41 [TEST-FILE-COUNT] · #42 [PLAN-RENUM]

## Key Context

- **#28 is CLOSED.** New server pattern: `GET /api/feeds/smart` returns `viewerAuthenticated` (server-baked auth flag) so the prop-less `SmartFeed` island adapts visitor chrome with no localStorage guess — the project's standing defense against `[NUDGE-CACHE-FLASH]`. `FeedActivityCard.canParticipate` (default true) drives the "Join to participate" CTA via `deriveJoinUrl`.
- **Linchpin for tomorrow:** `[COMMUNITY-ANCHOR]` #40 (no CommunityAnchor exists; only CourseAnchor) unblocks BOTH PROMOTE Step 4 templates AND the deferred FeedPost sample-post migration (#31). `[SEED-STREAM-FIDELITY]` #39 is the verify-enabler — seed `stream_activity_id` are invalid placeholders (`stream-fa-NNN`) → Promote 404s on seed posts + sample-post previews render empty.
- **⚠️ When #31 does the FeedPost render swap, preserve the Phase-6 intent-preserving `ctaUrl`** (visitor → `/signup?redirect=…`); `FeedPost.feedLink` points at the feed page, not the signup redirect.
- **Baseline verified THIS conv:** tsc 0 · astro 0/0/0 · lint clean · suite **6634/6634** · build ✓. (Code committed `1ea1a2b8`; docs this /r-end.)
- Dev server may still be running on :4321 (started for verification) — `pkill -f "astro dev"` if stale.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
