# State — Conv 259 (2026-06-10 ~12:29)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Continued the **feeds redesign** ([HOME-FEED-MERGE]). Client signed off on both adoption gates → updated the SoT docs to ✅ ADOPTED, recorded the **promotion password-gate** mechanism (free + shared password, admin-set via `/admin/*`, payment deferred), and promoted the 5 reserved build codes to TodoWrite (#31-35) + added [SYS-RENAME] #30 + [SYS-NAMING] #36. Then built **[SYS-RENAME] boundary C + A** to completion: C = mechanical `feed_type 'townhall'→'system'` enum rename; A = System community/feed admin-only lockdown (member feed + badges exclude System, /community/the-commons 404s non-admins, GET/POST /api/feeds/townhall require admin, autoJoinTheCommons retired). All 5 baseline gates green incl. full suite 6481/6481. **Next conv = boundary B = [POST-MATT] #35.**

## Completed

- [x] [SYS-RENAME] #30 — boundary C (enum rename: schema CHECKs + ~21 files + dev seed + tests; getTownhall→getSystemFeed) + boundary A (admin-only lockdown: getFeeds isAdmin-gated, candidates/feed-badges exclude is_system, community detail 404, townhall GET/POST require admin +403 test, autoJoinTheCommons retired + onboarding.ts deleted, /communities pin removed). tsc/astro/lint/build/6481-tests all green.
- [x] Feeds redesign ADOPTED — both client gates cleared; `plan/home-feed-merge/` README + client-meeting updated; 5 reserved codes promoted (#31-35); announcement-fan-out deferral recorded on [ADMIN-FEED-UI] #33.

## Remaining

- [ ] [POST-MATT] #35 [Opus-no] — **NEXT CONV (boundary B).** Post/feed-item → Matt design (ungated; posts exist today). Spec in `plan/home-feed-merge/post-format-matt.md` (simple 477:8285 + complex 477:8203). Post shell = container for 3 feed-item variants + promote templates; reuse Avatar/Button/CourseCatalogCard; new ReactionPill + comment-pill + shell. Folds in [SHOWMORE] #13.
- [ ] [HOME-FEED-MERGE] #28 [Opus] — feeds-redesign anchor / 7-phase consumption side (getMarketingCandidates → cursor → un-gate API → SmartFeed render variants → Home recomposition → signup-intent → verify). SoT `plan/home-feed-merge/`.
- [ ] [DISCOVERY-RAILS] #31 [Opus] · [PROMOTE-PIPELINE] #32 [Opus] (⚠️ resolve 4 password clarifications first) · [ADMIN-FEED-UI] #33 [Opus] (holds the deferred Announcement data model + fan-out) · [RECO-UNIFY] #34 [Opus]
- [ ] [SYS-NAMING] #36 — cosmetic townhall→system rename (routes /api/feeds/townhall→/system + callers, Stream group ×3 sites, TownHallFeed component, "Platform Community"/"The Commons" labels) + run `npm run db:setup:local:dev` to re-seed local D1.
- [ ] [VISITOR-GATING] #29 [Opus] — site-wide browse-vs-act gating audit; builds intent-preserving signup the HOME-FEED-MERGE CTAs depend on. Investigative → surface first.
- [ ] [ROLE-STUDIOS] #1 — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison sign-off).
- [ ] [RTMIG-4] #2 [Opus] · [ENTITY-ANCHOR] #3 · [SSR-LOADER-DEAD] #4
- [ ] [COMM-TAG-FILTER] #5 · [CT-RESTYLE] #6 (Tier-2 community)
- [ ] [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 (watch) · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13 (ties to [POST-MATT])
- [ ] [PREFLIP-WT] #14 (KEEP until client-vet) · [TZ-AUDIT] #15 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #16
- [ ] [MEM-CAP] #17 (MEMORY.md ~85% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #24 · [COURSEDETAIL-DEAD] #25 · [NUDGE-CACHE-FLASH] #26 · [NUDGE-TC-V2] #27 [Opus]

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] (BLOCKED) · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] · #4 [SSR-LOADER-DEAD]
- [ ] #5 [COMM-TAG-FILTER] · #6 [CT-RESTYLE] · #7 [PRIM-MATCH-INDEX] · #8 [TXTBTN] · #9 [PROFILE-PRIM-SWEEP]
- [ ] #10 [ICN-NS] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [SHOWMORE] · #14 [PREFLIP-WT]
- [ ] #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY] · #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP]
- [ ] #20 [LEARN-ISLAND-RESTYLE] · #21 [CREATE-ISLAND-RESTYLE] · #22 [TEACH-ISLAND-RESTYLE] · #23 [TRIAGE-RESTYLE]
- [ ] #24 [V217-WATCH] · #25 [COURSEDETAIL-DEAD] · #26 [NUDGE-CACHE-FLASH] · #27 [NUDGE-TC-V2] [Opus]
- [ ] #28 [HOME-FEED-MERGE] [Opus] · #29 [VISITOR-GATING] [Opus] · #31 [DISCOVERY-RAILS] [Opus] · #32 [PROMOTE-PIPELINE] [Opus]
- [ ] #33 [ADMIN-FEED-UI] [Opus] · #34 [RECO-UNIFY] [Opus] · #35 [POST-MATT] · #36 [SYS-NAMING]
- (#30 [SYS-RENAME] completed this conv)

## Key Context

- **Feeds redesign is ADOPTED + in build.** SoT `plan/home-feed-merge/` (README = baseline + adoption status; client-meeting-2026-06-10-feeds.md = the model + reconciliation; post-format-matt.md = post shell spec). Build is multi-conv: 6 build tasks (#31-36) + 7-phase HOME-FEED-MERGE #28 consumption.
- **Dependency order:** SYS-RENAME ✅ → POST-MATT (#35, next) / DISCOVERY-RAILS (#31) → PROMOTE-PIPELINE (#32) → RECO-UNIFY (#34) → ADMIN-FEED-UI (#33) → HOME-FEED-MERGE #28 phases.
- **SYS-RENAME state:** D1 `feed_type` enum is `'system'` everywhere; Stream feed group `('townhall','main')`, the `/api/feeds/townhall*` routes, `TownHallFeed.tsx`, and "Platform Community"/"The Commons" labels are still `townhall` — DELIBERATELY deferred to [SYS-NAMING] #36 (D1 enum and Stream group are decoupled identifiers). System community is admin-only: gated at getFeeds (isAdmin), candidates (is_system=0), feed-badges (is_system=0), community detail page (404), and townhall GET/POST endpoints (isUserAdmin/403).
- **Announcement model does NOT exist yet** — deferred to [ADMIN-FEED-UI] #33 (is_announcement flag + admin mark + global fan-out to member/visitor feeds). Until it ships, members get NO System broadcast (intended interim).
- **Promotion password gate** ([PROMOTE-PIPELINE] #32): free + shared password, admin-set via /admin/*, payment deferred. 4 OPEN clarifications to resolve before building: global-vs-per-level, per-promotion-vs-session, storage + hashing mechanism, which escalation levels gated.
- 🟠 **Local D1 stale:** still has old `feed_type='townhall'` rows + pre-rename CHECK — run `npm run db:setup:local:dev` before next dev-server use (test DB re-inits automatically; folded into #36).
- **Baseline verified THIS conv:** tsc 0 · astro check 0/0/0 · lint clean · build ✓ · full suite 6481/6481.
- Code committed in Step 6 (pre-commit HEAD on `jfg-dev-13-matt`; 36 files incl. onboarding.ts deletion).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
