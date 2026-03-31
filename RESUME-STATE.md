# State — Conv 065 (2026-03-31 ~15:56)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 065 completed PLATO-SCENARIOS.SEED-TOPUP Phase 4 SqlTopUp enrichment: 36 SqlTopUp steps adding reviews, ratings, transactions, certificates, expertise, moderation, notifications, testimonials, and more. Fixed a pre-existing flattenCourseData bug that caused multi-creator scenarios to flatten the wrong creator's course data. Discovered CTE enrollment lookup limitation in D1 INSERT context; workaround uses explicit JOINs.

## Completed

- [x] 36 SqlTopUp enrichment steps in seed-dev-topup.ts (reviews, ratings, transactions, payment splits, moderation, notifications, expertise/qualifications, testimonials, certificates, community resources, intro sessions, contact submissions, session invites, moderator invites, platform stats)
- [x] Bug fix: flattenCourseData iteration order in api-runner.ts (prefer 'creator' actor slot)
- [x] Bug fix: courseTitle propagation to prefer bound creator
- [x] Bug fix: admin email mismatch (admin@peerloop.com vs brian@peerloop.com in CTE)
- [x] 10 new verify assertions for enrichment data
- [x] Full test suite: 365 files, 6361 tests, all passing

## Remaining

### PLATO Scenarios Phase 4 SqlTopUp (remaining)
- [ ] Register Fraser as member-only user (SqlTopUp)
- [ ] Timestamp backdating for historical appearance
- [ ] David's additional sessions (2 scheduled, beyond 1 completed + 1 cancelled)
- [ ] Marcus's 2nd enrollment (n8n course) + teacher certification
- [ ] Validate PLATO-seeded DB matches SQL-seeded DB (count comparison)

### PLATO Scenarios Phase 5
- [ ] Update docs/as-designed/plato.md with scenario layer
- [ ] Update docs/reference/PLATO-GUIDE.md

### Cleanup / Consistency
- [ ] Fix seed-full persona admin email: brian@peerloop.com -> admin@peerloop.com
- [ ] Document CTE limitation: enrollment CTEs fail in D1 INSERT context
- [ ] Handle format divergence: SQL seed uses hyphens (guy-rymberg), API rejects them

### Client Decisions
- [ ] Confirm with client: remove /courses, /feeds, /communities (MyXXX pages) — now enclosed in /discover routes

### Monitor
- [ ] Monitor maybeUpdateActorSession design flaw (Convs 063-065) — if more collisions occur, fix by scoping auto-detection to source: 'register' actions only

## TodoWrite Items

- [ ] #2: Register Fraser as member-only user (SqlTopUp)
- [ ] #3: Timestamp backdating for historical appearance
- [ ] #4: David's additional sessions (2 scheduled)
- [ ] #5: Marcus's 2nd enrollment (n8n course) + teacher certification
- [ ] #6: Validate PLATO-seeded DB matches SQL-seeded DB
- [ ] #7: Update docs (plato.md, PLATO-GUIDE.md) — Phase 5
- [ ] #8: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #9: Monitor maybeUpdateActorSession design flaw (Convs 063-065)
- [ ] #10: Handle format divergence: SQL seed hyphens vs API rejects them
- [ ] #11: Document CTE limitation: enrollment CTEs fail in D1 INSERT context
- [ ] #12: Fix seed-full persona admin email: brian@peerloop.com -> admin@peerloop.com

## Key Context

- PLATO now has 19 runs, 4 scenarios (flywheel, ecosystem, activities, seed-dev), 3 persona sets (genesis, ecosystem, seed-full).
- Seed-dev scenario: 53 API chain steps + 38 SqlTopUp steps + 26 verify assertions.
- SqlTopUp enrollment lookups MUST use explicit JOINs (`FROM enrollments e JOIN users u ... JOIN courses c ...`), not CTE references. CTE `_e` returns NULL in INSERT context.
- SqlTopUp steps use `topup-` ID prefix for traceability.
- flattenCourseData now prefers 'creator' actor slot — fixes multi-creator scenarios.
- Core seed admin: admin@peerloop.com (NOT brian@peerloop.com).
- Full test suite: 365 files, 6361 tests, all passing.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
