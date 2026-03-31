# State — Conv 063 (2026-03-31 ~12:11)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 063 designed and implemented the PLATO Scenario layer (Phases 0-2). Added PlatoScenario type system, executeScenario() in the runner, findBy discovery pattern, actor bindings, course flattening, ecosystem persona set, and ecosystem scenario (2 courses, 3 students, 7 DB verifications). Phases 3-4 (new atomic runs + seed scenario replacing SQL) are next.

## Completed

- [x] Phase 0: PlatoScenario, RunRef, SqlTopUpRef, ChainStep, ScenarioResult types
- [x] Phase 0: Scenario reporting, scenarios/ directory with registry/loader
- [x] Phase 1: executeScenario() in PlatoRunner, flywheel.scenario.ts
- [x] Phase 1: plato-scenarios.api.test.ts replacing old chain test
- [x] Phase 2: findBy() in extractPath with parseDotPath()
- [x] Phase 2: Actor bindings, course flattening, cookie store rekeying
- [x] Phase 2: Ecosystem persona + scenario (18 steps, all passing)
- [x] Phase 2: add-teacher-cert.run.ts

## Remaining

### PLATO Scenarios Phase 3-5
- [ ] Phase 3: Build new atomic runs (book-complete-session, cancel-session, send-message, follow-user, submit-homework, set-availability)
- [ ] Phase 4: Build seed-full.ts persona set (Guy 4 courses, Gabriel 2 courses, 8 students)
- [ ] Phase 4: Build seed-dev.scenario.ts (~40-50 chain steps)
- [ ] Phase 4: Add SqlTopUp for feed activities, availability overrides, timestamp backdating
- [ ] Phase 4: Create plato-seed.api.test.ts + npm run db:seed:plato
- [ ] Phase 4: Validate PLATO-seeded DB matches SQL-seeded DB
- [ ] Phase 5: Update docs (plato.md, PLATO-GUIDE.md)

### Client Decisions
- [ ] Confirm with client: remove /courses, /feeds, /communities (MyXXX pages) — now enclosed in /discover routes. If agreed, middleware cleanup needed.

### Monitor: maybeUpdateActorSession Design Flaw
- [ ] Monitor over Convs 063-065: `maybeUpdateActorSession` auto-detects user creation by matching `provides` key names (userId, studentId, creatorId, teacherId). Can corrupt actor sessions when discovery actions provide another actor's ID under those names. Workaround: use non-matching key names. If more collisions occur by Conv 065, scope auto-detection to `source: 'register'` actions only.

## TodoWrite Items

- [ ] #1: Confirm with client: remove MyXXX pages — /courses, /feeds, /communities now enclosed in /discover. If agreed, middleware cleanup needed.
- [ ] #2: Monitor maybeUpdateActorSession flaw (Convs 063-065) — if more collisions occur, fix by scoping auto-detection to source: 'register' actions only.

## Key Context

- PLATO Scenario infrastructure is complete (Phases 0-2). Two scenarios passing: flywheel (11 runs, genesis) and ecosystem (18 steps, multi-course/multi-student).
- Plan file at `.claude/plans/vast-enchanting-wigderson.md` has the full 5-phase implementation plan.
- Key patterns: findBy in extractPath, actorBindings on RunRef, flattenCourseData, parseDotPath for paren-aware dot splitting.
- New run: add-teacher-cert.run.ts — teacher certification without Stripe Connect (for 2nd+ courses in multi-course scenarios).
- Full test suite: 365 files, 6359 tests, all passing.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
