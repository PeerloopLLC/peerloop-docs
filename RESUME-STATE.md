# State — Conv 292 (2026-06-16 ~13:51)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Recovered the code repo onto `jfg-dev-14` (ff'd to Conv 291's `2a216a4f`; RESUME-STATE's "jfg-dev-14 never existed" was wrong). Then swept **RG-COURSES route 1 (`/courses`)** end-to-end via the 8-step process: route-own surface was clean Matt; applied cross-cutting fixes (`#f1f5f9`→`bg-secondary-100` token across 12 sites, DismissButton adopt), Step-7 local fixes (card image `aspect-[8/3]`, Level/Length→Select dropdowns), a Select `clearable` mode (dropdowns can return to "All"), and a dev/staging always-show behavior for dismissible nudges/recs. Marked `/courses` ☑ Swept. 4 RG-COURSES detail routes remain.

## Completed

- [x] Code-branch recovery → `jfg-dev-14` (ff to `2a216a4f`), pushed
- [x] RG-COURSES route 1 (`/courses`) **Swept** (full 8-step process)
- [x] Cross-cutting: `#f1f5f9`→`bg-secondary-100` (12 sites, Rule-of-Three) + DismissButton adopt in OnboardingNudgeBanner
- [x] Step-7 local fixes: card image `aspect-[8/3]`, Level/Length pills→Select dropdowns
- [x] Select `clearable` mode (placeholder re-selectable) — fixes dropdowns can't-return-to-All
- [x] Dev/staging always-show dismissibles (`src/lib/ephemeral-dismiss.ts` + 3 components)
- [x] Cross-cutting Tier-1 Rule-of-Three register + README Step-1/5 pointers; 2 memories saved

## Remaining

**RG-COURSES continues (routes 2–5):**
- [ ] [RG-COURSES] (#10) Sweep `/course/[slug]/{[...tab],book,precheckout,success}` (4 routes remain; route 1 `/courses` swept)

**[COURSES-FIXES] #28 open items (2 cross-cutting, to graduate to own tasks when worked):**
- [ ] [FILTERS-RESPONSIVE] responsive/compact filters (search + "…more"); ListingShell reflow + shared collapsible-filter primitive — affects all filtered listings
- [ ] [TYPO-REVIEW] app-wide typography conformance; coordinate with [LAYOUT-SG]

**Other route groups + cross-cutting (carried):**
- [ ] [RTMIG-4] umbrella (blocked) · [RG-ADMIN] · [RG-PUBPROF] [Opus] (blocked by ROLE-SEMANTICS) · [RG-AUTH] · [ROLE-SEMANTICS] [Opus] · [RG-PROFILE] · [RG-COMMS] · [RG-DISCOVER] · [RG-WORKSPACES] [Opus] ⛔client · [RG-MESSAGES]/[RG-NOTIFS]/[RG-SESSIONS]/[RG-MOD]/[RG-PUBLIC] (deferred)
- [ ] [OLD-PORTED-CLEANUP] · [PREFLIP-WT] · [E2E-MIG] · [E2E-GATE] (blocked by E2E-MIG) · [ICN-NS] · [TZ-AUDIT] [Opus] · [DOCGEN-SPEC] · [V217-WATCH] · [MEM-PRUNE] · [LAYOUT-SG] · [PROV-STAMP-GAPS] · [HOME-FIXES] · [COURSES-FIXES]

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] · #9 [RG-PROFILE] · #10 [RG-COURSES] (in_progress) · #11 [RG-COMMS] · #12 [RG-DISCOVER] · #13 [E2E-MIG] · #14 [E2E-GATE] · #15 [ICN-NS] · #16 [TZ-AUDIT] [Opus] · #17 [DOCGEN-SPEC] · #18 [V217-WATCH] · #19 [MEM-PRUNE] · #20 [LAYOUT-SG] · #21 [RG-MESSAGES] · #22 [RG-NOTIFS] · #23 [RG-SESSIONS] · #24 [RG-MOD] · #25 [RG-PUBLIC] · #26 [PROV-STAMP-GAPS] · #27 [HOME-FIXES] · #28 [COURSES-FIXES]
- (#29 [DEV13-RM] was created then DELETED — jfg-dev-NN branches are intentional snapshots, do NOT clean up; see memory `project_jfg_dev_branches_are_snapshots`)

## Key Context

- **Branch:** code on `jfg-dev-14` (canonical/active). `jfg-dev-13-matt` and other `jfg-dev-NN` are **intentional point-in-time snapshots — do NOT propose deleting them** (memory `project_jfg_dev_branches_are_snapshots`).
- **Route sweep SoT:** `plan/route-migration/README.md` (8-step process + 14-group checklist; `/courses` row ☑) + `tier2-primitive-ledger.md` (Tier-2 candidates + the new **cross-cutting Tier-1 Rule-of-Three register**: ≥3 sites→fix, <3→watch, log either way).
- **Dev/staging behavior:** dismissible nudges/recs reappear on every reload in dev/staging by design (`ephemeral-dismiss.ts` `readDismissed()`); "dismiss doesn't stick on staging" is EXPECTED — do NOT re-persist (memory `project_ephemeral_dismiss_dev_staging`). Staging detected by hostname containing `staging`; upgrade path = `PUBLIC_` env var if it ever moves.
- **New reusable primitive behavior:** `Select` has a `clearable` prop; filter-selects should use it.
- **Token gotcha (unchanged):** `bg-primary` is transparent; Matt brand-blue = `bg-text-primary`. `rounded-8/12` are token-backed (`--radius-*`) — NOT legacy. Gates miss CSS → browser/DOM-verify visual work.
- **MEMORY.md ~84%** of the SessionStart cap (2 memories added this conv) → **[MEM-PRUNE] (#19) is live** — run `/r-prune-memory`.
- **Dev server** left running on `:4321` (pid 50607) — ephemeral local state.
- **Commits this conv (pre-r-end):** code `34febbcf`,`ef8d4151`,`1dadeca1`,`ef0f2f54`; docs `a3cc71b`,`cf281ee`,`16800ac`. /r-end adds the session-docs/plan/decisions commit.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
