# State — Conv 242 (2026-06-04 ~21:45)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Heavy Matt-migration conv. Closed two of a three-feature sequence the user picked (CALENDAR2 → CH-VARIANTS → SUCCESS-COMMUNITY): **[CALENDAR2]** graduated the booking wizard `@stand-in → @matt-inspired` (merge re-skin + Matt date+time-on-one-screen, confirm kept separate), and **[CH-VARIANTS]** built the CourseHeader Scheduled variant (upcoming-session hero, viewer-local client TZ formatting) and fixed the CourseHeader prov NODE-MISMATCH (sweep 6→5). The `@stand-in` census in `src/pages/*.astro` is now ZERO — the Course→Booking→Sessions funnel is fully Matt end-to-end. Surfaced [TZ-AUDIT] (server-UTC vs client-local date-bucketing, a recurring per-port class) and [OUTLINE-V4]. **[SUCCESS-COMMUNITY] is the deferred 3rd feature — pick it up next conv.**

## Completed

- [x] [CALENDAR2] Booking wizard graduated `@stand-in → @matt-inspired 622:15671` — committed `b3854268` (code) / `5ae9f96` (docs). Test rewritten (was silently dead). 5 gates green (suite 6458).
- [x] [CH-VARIANTS] CourseHeader Scheduled variant (`685:13240`) + `CourseJourneyState.nextSession` loader extension + viewer-local `<time>` client enhancement + prov NODE-MISMATCH fix (6→5). Committed this conv (Step 6).
- [x] phase-out memory enriched (happy-path-only / legacy=functional-source-of-truth / latent-bug-per-port).

## Remaining

Carried backlog (mostly unchanged) + 2 new spinoffs this conv ([TZ-AUDIT] #46, [OUTLINE-V4] #45). **Next up: [SUCCESS-COMMUNITY] #10** to finish the funnel-feature sequence.

- [ ] [COMM-TAG-FILTER] Build real Commons tag filtering [Opus] · [CT-RESTYLE] · [COMM-LEAVE] · [MOD-TOGGLE]
- [ ] [MATT-EXEC-PG2] Phase 5 remaining pages (~5 routes: /matt, /login, /teacher/[handle], /teacher/[handle]/schedule, /certification/[id]) · [MATT-EXEC-EXT] · [MMP-PH5] · [MATT-EXEC-GRD]
- [ ] [SUCCESS-COMMUNITY] Success page Phase 2 community composer [Opus] — **next in the sequence** · [CH-VARIANTS done] · [MFRD-LOOKUP] · [PRECHECKOUT-MATT-CONFIRM] · [ENROLL-NAV-MATT-CONFIRM]
- [ ] [RTMIG-TIER] Decide Tier-1/Tier-2 route-migration strategy [Opus] · [RTMIG-4] port ~89 /old/* pages [Opus]
- [ ] [PRIM-MATCH-INDEX] · [PRIM-DOC] · [PRIM-ORPHAN-ACK] · [TXTBTN] · [PROFILE-PRIM-SWEEP] (PAUSED) · [PRIM-COURSES-DISMISS]
- [ ] [ICN-NS] Icon namespace convergence [Opus] · [HOWTOREG-ICN] · [ASSET-SWEEP-GATE]
- [ ] [E2E-MIG] · [E2E-GATE]
- [ ] [SHOWMORE] · [SELECT-AUDIT]
- [ ] [ADMIN-REDIRECT-BLANK] [Opus] · [SETTINGS-WATCHER] · [BAK-ARTIFACT]
- [ ] [PREFLIP-WT] · [REND-DEDUP-GUARD] · [MEM-CAP] (run /r-prune-memory) · [GARBLE-WATCH]
- [ ] [API-USERS-DRIFT] · [DOCS-ROUTES-STALE] · [PREPLAN-CHECKOUT-NOTE]
- [ ] [HOME-FEEDSHUB-VIS] · [DOM-FIRST]
- [ ] [PROV-SWEEP-DEBT] now 5 errors (av-timer/verified icon-provenance + 3 untracked stamps) · [DASH-COURSES-LINK]
- [ ] [OUTLINE-V4] v3 outline-none → outline-hidden in SESS-GRAD files
- [ ] [TZ-AUDIT] Systematic timezone audit + sensor + canonical-policy decision + codecheck gate [Opus] — deferred after the feature sequence
- [ ] [STG-SEED] Optionally reseed staging D1

## TodoWrite Items

- [ ] #1: [COMM-TAG-FILTER] [Opus] · #2: [CT-RESTYLE] · #3: [COMM-LEAVE] · #4: [MOD-TOGGLE]
- [ ] #5: [MATT-EXEC-PG2] · #6: [MATT-EXEC-EXT] · #7: [MMP-PH5] · #8: [MATT-EXEC-GRD]
- [ ] #10: [SUCCESS-COMMUNITY] [Opus] · #11: [MFRD-LOOKUP] · #12: [PRECHECKOUT-MATT-CONFIRM] · #13: [ENROLL-NAV-MATT-CONFIRM]
- [ ] #14: [RTMIG-TIER] [Opus] · #15: [RTMIG-4] [Opus]
- [ ] #16: [PRIM-MATCH-INDEX] · #17: [PRIM-DOC] · #18: [PRIM-ORPHAN-ACK] · #19: [TXTBTN] · #20: [PROFILE-PRIM-SWEEP] · #21: [PRIM-COURSES-DISMISS]
- [ ] #22: [ICN-NS] [Opus] · #23: [HOWTOREG-ICN] · #24: [ASSET-SWEEP-GATE]
- [ ] #25: [E2E-MIG] · #26: [E2E-GATE]
- [ ] #27: [SHOWMORE] · #28: [SELECT-AUDIT]
- [ ] #29: [ADMIN-REDIRECT-BLANK] [Opus] · #30: [SETTINGS-WATCHER] · #31: [BAK-ARTIFACT]
- [ ] #32: [PREFLIP-WT] · #33: [REND-DEDUP-GUARD] · #34: [MEM-CAP] · #35: [GARBLE-WATCH]
- [ ] #36: [API-USERS-DRIFT] · #37: [DOCS-ROUTES-STALE] · #38: [PREPLAN-CHECKOUT-NOTE]
- [ ] #39: [HOME-FEEDSHUB-VIS] · #40: [DOM-FIRST]
- [ ] #41: [PROV-SWEEP-DEBT] (now 5) · #42: [DASH-COURSES-LINK]
- [ ] #44: [STG-SEED] · #45: [OUTLINE-V4] · #46: [TZ-AUDIT] [Opus]

## Key Context

- **Funnel fully Matt:** Course tabs → /precheckout → /success → /book → /session/[id] all `@matt-inspired`. `grep -rE '^\s*\*?\s*@stand-in\s*$' src/pages` = zero. The earlier loose `grep -rl '@stand-in'` false-positives on prose ("[STANDIN-404]", graduation notes) — trust the marker line.
- **Governing principle (user, Conv 242):** Matt is happy-path-only; **legacy = functional source of truth, Matt = the skin.** Every legacy→Matt port surfaces latent bugs (TZ, dead tests, v4 drift) — gates-green ≠ behavior-preserved. See `memory/project_matt_phaseout_inspired_default.md`.
- **[TZ-AUDIT] #46 root cause:** `availability-utils.ts` builds `slot.date` from `getFullYear/getMonth/getDate` = UTC on the Worker, vs browser-local calendar cells → off-by-one for far-TZ users. Durable display pattern established this conv: `<time datetime={iso}>` + `astro:page-load` client upgrade (viewer-local). Canonical-policy decision (teacher vs viewer vs UTC for "the day") is the gating step.
- **prov:sweep now 5** (was 6). NODE_RE only matches literal `data-prov-node="…"` — stamp the component-set node literally, not a dynamic `{ternary}`. Remaining 5: av-timer.svg + verified.svg lack icon-provenance.ts entries; SubNav/MySessionsTab/PrecheckoutContent stamp untracked data-prov-name.
- **Baseline:** 5 gates green at CH-VARIANTS close — tsc/astro/lint 0, suite **6458**, build clean. prov:sweep 5 (debt, [PROV-SWEEP-DEBT] #41).
- **MEMORY.md ~83%** of the 25KB auto-load cap — [MEM-CAP] #34, run /r-prune-memory.
- **Route docs regenerated** this conv (docs agent) — captured a real `/session/[id]` nav-shape change (btn→crumb) from the variant wiring; both repos' route maps updated.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
