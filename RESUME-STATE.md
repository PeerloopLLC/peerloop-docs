# State — Conv 297 (2026-06-17 ~21:30)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Completed the **RG-COURSES route sweep (4/4)** — the first fully-finished RG-* group. Built **[RSTART-DIFFGATE]** (a /r-start code-branch match gate) after a cross-machine stale-branch incident, swept `/book` (colour map onto PALETTE-FDN + `text-star` catch), **removed `/precheckout`** (subnavbar remnant → `/benefits`), and swept `/success` — which surfaced and drove a full **ExpectationsForm retrofit** (new `form/Textarea` primitive) plus an app-wide **[ALERT-TUNE]** (`--Alert-Default` neon → tuned `error-300`). Full codecheck green for all Conv-297 work; 5 pre-existing test failures tracked as [STALE-TESTS]. Committed pre-close: code `1b24ff94`, docs `4dd5ae0` (the r-end close commit follows).

## Completed

- [x] [RSTART-DIFFGATE] /r-start Step 5.6 code-branch match gate (conv-branch-check.sh + 8-case calibration)
- [x] [RG-COURSES] route sweep COMPLETE 4/4 (/book, /success, [...tab], /courses; /precheckout REMOVED; group 5→4)
- [x] New `form/Textarea` @matt-inspired primitive + matt-inspired-registry registration
- [x] [ALERT-TUNE] `--Alert-Default` → `var(--error-300)` (#FF0038→#E11D3F), 23 utils / 14 files unified
- [x] Memory index gap fixed (project_jfg_dev_branches_are_snapshots pointer line)
- [x] Full codecheck — all gates PASS for Conv-297 work; build clean

## Remaining

**Route sweep (RTMIG-4 umbrella — 13 RG groups remain after RG-COURSES):**
- [ ] [RTMIG-4] umbrella · [RG-ADMIN] (cleanest unblocked start) · [RG-AUTH] · [RG-PROFILE] · [RG-COMMS] · [RG-DISCOVER]
- [ ] [RG-PUBPROF] [Opus] (blocked by [ROLE-SEMANTICS]) · [ROLE-SEMANTICS] [Opus] · [RG-WORKSPACES] [Opus] ⛔client
- [ ] [RG-MESSAGES] · [RG-NOTIFS] · [RG-SESSIONS] · [RG-MOD] · [RG-PUBLIC] (deferred group)

**Follow-ups / debt:**
- [ ] [STALE-TESTS] 5 pre-existing test failures (4 = Conv-292 ephemeral-dismiss stale tests: RecommendedCourses/Communities + OnboardingNudgeBanner; 1 = ListingShell mobile-contract) — update tests to match intended behavior
- [ ] [COURSES-FIXES] (open: [FILTERS-RESPONSIVE], [TYPO-REVIEW]) · [HOME-FIXES] · [PROV-STAMP-GAPS] (5 untracked: CommunityAnchor, DiscoveryCard, _FeedPostDemo, StickySignupBar, MembersFilters)
- [ ] [PALETTE-FDN] migration tail (FeedActivityCard recolor at ReactionButton/IconButton extraction; per-route colour migration; retire legacy `--color-secondary-*`/`--color-primary-*` ramp)
- [ ] [OLD-PORTED-CLEANUP] · [PREFLIP-WT] · [E2E-MIG] · [E2E-GATE] (blocked by E2E-MIG) · [ICN-NS] · [TZ-AUDIT] [Opus] · [DOCGEN-SPEC] · [V217-WATCH] · [MEM-PRUNE] · [LAYOUT-SG] · [M4-ZGUARD]

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] ⛔client · #9 [RG-PROFILE] · #11 [RG-COMMS] · #12 [RG-DISCOVER] · #13 [E2E-MIG] · #14 [E2E-GATE] · #15 [ICN-NS] · #16 [TZ-AUDIT] [Opus] · #17 [DOCGEN-SPEC] · #18 [V217-WATCH] · #19 [MEM-PRUNE] · #20 [LAYOUT-SG] · #21 [RG-MESSAGES] · #22 [RG-NOTIFS] · #23 [RG-SESSIONS] · #24 [RG-MOD] · #25 [RG-PUBLIC] · #26 [PROV-STAMP-GAPS] · #27 [HOME-FIXES] · #28 [COURSES-FIXES] · #29 [M4-ZGUARD] · #31 [PALETTE-FDN] · #32 [STALE-TESTS]

## Key Context

- **RG-COURSES is the first complete RG-* group.** Route-sweep SoT: `plan/route-migration/README.md` + `tier2-primitive-ledger.md`. Next unblocked: [RG-ADMIN] (island/body-only, shell already Matt).
- **[RSTART-DIFFGATE] is LIVE** — next /r-start will run `conv-branch-check.sh` and offer a safe checkout if the code branch ≠ RESUME-STATE's recorded branch. Verdicts/calibration in the script header.
- **New `form/Textarea` primitive** — multi-line sibling of Input (`@matt-inspired`); the `form/` family now = Input + Select + Textarea + FormField.
- **[ALERT-TUNE] done:** form-error red (`--Alert-Default`, used by FormField required `*` + Input/Select/Textarea invalid) is now `var(--error-300)` `#E11D3F`. `--carmine-red` (#FF0038) retained but unused.
- **`/precheckout` removed:** content lives at the `/benefits` SubNav "Enroll" tab; the route 302→`/course/[slug]` via the catch-all unknown-tab handler (kept, not 404). Route maps regen at this r-end Step 5c.
- **[STALE-TESTS] are NOT Conv-297 regressions** — proven via import-graph. The 4 dismiss tests need updating to the Conv-292 ephemeral-dismiss design (dev/staging reappear-on-reload is intentional).
- **MEMORY.md ~84%** of SessionStart cap → [MEM-PRUNE] #19 still live.
- Code repo on `jfg-dev-14`; commits this conv: code `1b24ff94`, docs `4dd5ae0` (+ the r-end close commit).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
