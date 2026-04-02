# State — Conv 073 (2026-04-02 ~08:30)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 073 standardized PLATO/STUMBLE terminology (API mode/Browser mode), deferred segments to PLATO-ON-STEROIDS block, built snapshot bridge infrastructure (API-run → snapshot → restore → browser-run), created flywheel-to-enrollment scenario+instance, and browser-walked flywheel checkpoints 11-14 (booking wizard, session completion via webhook triggers, certification via API, teacher verification). Found 3 bugs + 1 security gap.

## Completed

- [x] PLATO/STUMBLE terminology standardized (GLOSSARY.md, plato.md, memory)
- [x] Segments deferred to PLATO-ON-STEROIDS block (#41 in PLAN.md)
- [x] PLATO snapshot infrastructure built (types, runner, restore scripts, npm scripts)
- [x] flywheel-to-enrollment scenario + instance created (with snapshot: true)
- [x] PLATO-REGISTRY.md created (manifest of all PLATO assets and lineage)
- [x] plato:restore npm script — combined always-regenerate + restore command
- [x] Browser-walked flywheel checkpoints 11-14 (hybrid: browser for UI, API for webhooks)
- [x] All 8 PLATO tests passing (including new flywheel-to-enrollment)

## Remaining

### Bugs Found During STUMBLE (Conv 073)
- [ ] Dashboard stats show 0 modules/0% after course completion via webhook
- [ ] "Your Courses" section disappears from dashboard after course completion
- [ ] No UI to certify student as teacher (CERT-APPROVAL gap)
- [ ] BBB webhook endpoint has no signature validation (security gap)

### Carried Forward
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)

## TodoWrite Items

- [ ] #1: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #2: Broken route: /course/[slug]/certificate — page doesn't exist
- [ ] #14: Bug: Dashboard stats show 0 modules/0% after course completion via webhook
- [ ] #15: Bug: "Your Courses" section disappears from dashboard after course completion
- [ ] #16: Bug/Gap: No UI to certify student as teacher (CERT-APPROVAL)
- [ ] #17: Security gap: BBB webhook endpoint has no signature validation

## Key Context

- **PLATO terminology finalized:** PLATO = system, API mode / Browser mode, run = execution of an instance, STUMBLE-AUDIT = project block only. See GLOSSARY.md §Testing & Quality.
- **Snapshot bridge works:** `npm run plato:restore -- flywheel-to-enrollment` (~1s) sets up local D1 with post-enrollment state for browser-walking.
- **Flywheel checkpoints 11-14 done:** Booking wizard clean (module auto-advancement, timezone-aware, availability-driven). Session completion via `curl POST /api/webhooks/bbb`. Certification via browser fetch API call. Alex now has teacher status.
- **3 dashboard bugs:** Stats 0% (likely module_progress table not populated by webhook path), course card disappears after completion, no certify button in UI.
- **PLATO-ON-STEROIDS deferred block:** Captures full vision — composable data, segments, DB snapshots, automated agent walkthroughs. Current primitives sufficient for now.
- **Local D1 has flywheel data:** Mara (creator+teacher), Alex (student→teacher), 1 published course, 1 completed enrollment, 3 completed sessions. `/r-start` does NOT reset D1.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
