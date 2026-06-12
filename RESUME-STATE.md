# State — Conv 272 (2026-06-12 ~10:03)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built **[QLINT]** (#1) — a deterministic **Stop-hook** linter (`.claude/hooks/qlint-question-format.sh`, registered under `hooks.Stop`) enforcing the CLAUDE.md §User-Facing-Questions A)/B)-labels rule; reframed (with the user) from a syntactic "or" check to a **typeability** check, calibrated 19/19, committed docs `67f2143`. Closed **[FEED-U1]** (#2) — added a **PART C: DISCOVERY RAILS FRESHNESS** to `migrations-dev/0001_seed_dev.sql` (extending the existing TIMESTAMP FRESHNESS mechanism the user pointed to) so all **6 discovery rails populate** (was 2/6); home marketing feed verified full in-browser; full 5-gate green; committed code `87dfe2b3`. Both repos already committed during the conv; this /r-end commits only conv-end bookkeeping.

## Completed

- [x] [QLINT] Stop-hook question-format linter — built, typeability-model (only A)/B) labels exempt; `(yes/no)` + "yes or no" blessed; parenthetical-slash-list + or-anywhere detection; code+quote stripped; `stop_hook_active` guard; fails open. Calibrated 19/19 (`.scratch/qlint-calibration.sh`), registered, committed (docs 67f2143). Memory updated (`feedback_option_phrasing.md` + MEMORY.md index).
- [x] [FEED-U1] Discovery-rails freshening (PART C, inversion-safe) — all 6 rails populate; home feed full; 5-gate green (tsc/astro 0-0-0/lint/test 6634/build); committed (code 87dfe2b3). docs/as-designed/migrations.md updated (Part C) by r-end docs agent.

## Remaining

**Feed group (canonical plan: `plan/home-feed-merge/REASSEMBLY-CONV271.md`; build order U2 → U3):**
- [ ] [FEED-U2] #3 [Opus] — discovery-rendering unit: pipeline metadata + CommunityAnchor + FeedPost render swap + remove getDiscoveryCandidates + delete FeedsHubPanel. **Now unblocked (U1 closed).** NEXT.
- [ ] [FEED-U3] #4 [Opus] (blocked by #3) — promotion system: U3a substrate (schema+cron+dials+announcement) · U3b entity-promo · U3c admin · U3d PromoteNudge (LAST).
- [ ] [SYS-NAMING] #5 [Opus] — owner-based feed naming; DECIDE rollout scope first.
- [ ] [PROMOTE-IDEMP] #6 · [API-DISC-DOC] #7 (also covers the pre-existing `/api/discovery/rails` doc gap) · [SYS-GET-GATE] #8 — independent cleanups.
- [ ] [COMM-TAG-FILTER] #9 · [SUCCESS-COMMUNITY-VERIFY] #10 — PARKED needs-spec.

**Other backlog (unchanged):**
- [ ] [ROLE-STUDIOS] #11 [Opus] (⛔ BLOCKED BY CLIENT) · [RTMIG-4] #12 [Opus] · [SSR-LOADER-DEAD] #13 · [CT-RESTYLE] #14 · [PRIM-MATCH-INDEX] #15 · [TXTBTN] #16 · [PROFILE-PRIM-SWEEP] #17 (PAUSED)
- [ ] [ICN-NS] #18 · [E2E-MIG] #19 · [E2E-GATE] #20 · [SHOWMORE] #21 · [PREFLIP-WT] #22 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #23 [Opus] · [MEM-CAP] #24 (MEMORY.md ~89% → /r-prune-memory) · [DOCGEN-SPEC] #25 · [OLD-PORTED-CLEANUP] #26
- [ ] [LEARN-ISLAND-RESTYLE] #27 · [CREATE-ISLAND-RESTYLE] #28 · [TEACH-ISLAND-RESTYLE] #29 · [TRIAGE-RESTYLE] #30
- [ ] [V217-WATCH] #31 · [COURSEDETAIL-DEAD] #32 · [NUDGE-CACHE-FLASH] #33 · [NUDGE-TC-V2] #34 · [TW-V4] #35 (incl. 2 concrete deprecations: StickySignupBar.astro `backdrop-blur-sm`, SuggestionCard.tsx `flex-shrink-0`) · [TEST-FILE-COUNT] #36 · [PLAN-RENUM] #37
- [ ] [COMMONS-DATE] #38 — give `comm-the-commons` a fixed early founding date in the dev seed (pre-existing join-before-founding inversion; harmless to rails, wrong on member lists).

## TodoWrite Items

- [ ] #3 [FEED-U2] [Opus] (next) · #4 [FEED-U3] [Opus] (blocked by #3) · #5 [SYS-NAMING] [Opus] · #6 #7 #8 cleanups · #9 #10 PARKED
- [ ] #11 [ROLE-STUDIOS] [Opus] (BLOCKED) · #12 [RTMIG-4] [Opus] · #13–#22 · #23 [TZ-AUDIT] [Opus] · #24–#37 · #38 [COMMONS-DATE]

## Key Context

- **QLINT is live** — it runs on every turn-end. If a turn-end ever gets unexpectedly blocked, the reason text names the rule; the fix is to add A)/B) labels (or rephrase the choice). To extend: edit `.claude/hooks/qlint-question-format.sh` + add a fixture to `.scratch/qlint-calibration.sh` and keep it green. Full archaeology in `memory/feedback_option_phrasing.md`.
- **FEED-U1 closed** — the relative-date freshness mechanism lives in `migrations-dev/0001_seed_dev.sql` § "TIMESTAMP FRESHNESS" (now 3 parts; PART C = rail-source tables). `db:setup:local:dev` re-applies it; rails recompute on-demand in dev (no KV).
- **Baseline verified THIS conv** = full 5-gate green (tsc / astro check 0-0-0 / lint / test 388 files 6634 tests / build) after the seed change.
- **MEMORY.md at ~89%** of the SessionStart byte cap → [MEM-CAP] #24 (`/r-prune-memory`).
- **Local env note:** two dev servers were left running (:4321 pre-existing from another session, :4322 from this conv — share a pid so the kill was skipped); browser tab 545380885 open. Harmless; kill :4322 if you want a single server.
- Code/docs already committed (code 87dfe2b3, docs 67f2143); this /r-end adds the conv-end bookkeeping commit.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Then start `[FEED-U2]` #3 (next unit; U1 closed, U2 unblocked).**
