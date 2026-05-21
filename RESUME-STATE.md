# State — Conv 167 (2026-05-20 ~21:35)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Worked the 4-item A→B→C user pick from RESUME-STATE Conv 166: [CAP-DEFEND] defensive null-guard widening, [RM-PARAM-BUG] targeted regex exclusions in route-matrix scanner, [SEED-PW] dev seed password rotation Password1 → Peerloop2 (narrowed to dev-only; surfaced [PROD-PW] for prod side), [WRANGLER-CMT] staging-comment rewrite. Then full 5-gate baseline run (all green: 6453/6453 tests, 0 errors anywhere) which surfaced 2 small follow-ups [CCK-LINT] + [TW-OUTLINE] (both closed same turn) and [CCK-DA] (deleted_at script heuristic emits 90+ false positives — needs structural fix, deferred). Net: 6 tasks completed, 3 new pending surfaced.

## Completed

- [x] [CAP-DEFEND] Widened early-return guard in `CourseAvailabilityPreview.tsx:76`
- [x] [RM-PARAM-BUG] Added query-string-appender exclusions in `route-matrix.mjs:normalizeDynamic`; broken targets 1→0
- [x] [SEED-PW] Rotated dev seed password Password1 → Peerloop2 across 13 files
- [x] [WRANGLER-CMT] Rewrote `wrangler.toml:107-113` staging block comment
- [x] [CCK-LINT] Fixed eslint.config.js ignore `.astro/**` → `**/.astro/**`
- [x] [TW-OUTLINE] Renamed `outline-none` → `outline-hidden` × 2 in MemberDirectory.tsx
- [x] Full 5-gate baseline green (tsc / astro / lint / 6453 tests / build all clean)

## Remaining

- [ ] **[BR-ZERO-REPRO]** Reproduce 0-min empty-but-published recording state in next BBB test — needed for [BR-STATUS] enum design
- [ ] **[BR-STATUS]** Add sessions.recording_status column with enum `none | requested | capturing | processing | published | failed | empty` [Opus] — awaits [BR-ZERO-REPRO] data + Blindside follow-up
- [ ] **[XMV]** Front-load cross-machine verification (`HOME=/Users/livingroom` simulation) before locking sweep rules into CLAUDE.md or memory
- [ ] **[MND]** Fix `detect-machine.sh` hostname match for M4Pro — `~/.claude/.machine-name` contains literal `"Unknown (M4Pro.local)"` instead of canonical `"MacMiniM4Pro"`; hardcoded workaround still in use Conv 167
- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in `ClientRouter` — WAITING on upstream Astro fix post-6.3.6
- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings (astro/audit/xray/toolbar) — self-resolved Conv 165, investigate only if it recurs
- [ ] **[RAM-NO-NAV]** `route-api-map.mjs` warns `/course/[slug]/[tab]` has no discovered nav path — verify benign vs add nav surface; decide whether to silence or wire
- [ ] **[PROD-PW]** Rotate prod admin seed password (admin@peerloop.com) [Opus] — `migrations/0002_seed_core.sql` still seeds usr-admin with old Password1 hash; decisions needed on (a) prod password choice (Peerloop2 too well-known after dev rotation), (b) whether to also UPDATE existing prod admin via wrangler d1 execute. Surfaced Conv 167 [SEED-PW]
- [ ] **[CCK-DA]** Fix /w-codecheck Check 8 deleted_at false-positive heuristic — emits 90+ bogus findings; current heuristic matches table-name-in-same-block instead of qualified `<table>.deleted_at`. Per memory/feedback_heuristic_calibration.md, re-validate against Conv 117 motivating case before commit

## TodoWrite Items

- [ ] #3: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state
- [ ] #4: [BR-STATUS] Add sessions.recording_status column with enum [Opus]
- [ ] #5: [XMV] Front-load cross-machine verification
- [ ] #6: [MND] Fix detect-machine.sh hostname match for M4Pro
- [ ] #7: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] #8: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings
- [ ] #11: [RAM-NO-NAV] route-api-map warns /course/[slug]/[tab] has no nav path
- [ ] #12: [PROD-PW] Rotate prod admin seed password (admin@peerloop.com) [Opus]
- [ ] #13: [CCK-DA] Fix w-codecheck Check 8 deleted_at false-positive heuristic

## Key Context

**Pre-commit state:** Code repo will be committed in Step 6 with 16 modified files (no new files). Docs repo committed with PLAN.md updates (CAP-DEFEND checked off + [PROD-PW] / [CCK-DA] added), 4 regenerated route doc files (page-connections.md + 3 TSVs), 5 doc files updated by docs agent for password rotation reflection (CLI-TESTING.md, BEST-PRACTICES.md, TEST-E2E.md, CLI-REFERENCE.md, SCRIPTS.md), 3 new session files (Extract/Learnings/Decisions), RESUME-STATE.md (this file) + memory mirror sync.

**Baseline state (verified THIS conv):** All 5 gates green — tsc clean / `npm run check` 0/0/0 across 1215 files / lint 0 errors 0 warnings / 6453/6453 tests / build ~7s.

**[CCK-DA] context:** /w-codecheck Check 8 spot-check confirmed false positives via `grep -rn '<flagged_table>.deleted_at' src/` returning zero hits across all 18 flagged tables (teacher_certifications, tags, course_tags, user_tags, transactions, user_stats, sessions, payouts, topics, moderator_invites, content_flags, payment_splits, feed_activities, communities, community_members, community_moderators, course_curriculum, member_profiles). Every flagged SQL block correctly applies `deleted_at IS NULL` to courses/enrollments/users; script flags unrelated tables in same block as bogus violations.

**[PROD-PW] context:** The bcrypt hash for "Password1" lives at `migrations/0002_seed_core.sql:172` for `usr-admin` / admin@peerloop.com. Re-running seed against prod hits PK collision (existing row not updated), so seed rotation alone won't fix existing prod admin — needs separate `wrangler d1 execute` UPDATE statement against `peerloop-db` prod D1. Conv 167 declined Peerloop2 for prod admin since it's now broadly known across dev README/scripts.

**API contract `/api/courses/[id]/sessions`** (locked Conv 165, unchanged Conv 167):
- Default scope = highest-privilege precedence
- Explicit `scope=student|teacher|all` with role-appropriate gates

**Route-matrix scanner rule (Conv 167):** Template-literal expressions like `${Astro.url.search}` and `${...searchParams...}` are NOT route params — they're query-string appenders. The scanner now drops them before applying generic `[param]` normalization.

**File path references:**
- Dev seed bcrypt hash (Peerloop2): `$2b$10$tQMUTTuSbJiuqpITHrCN7.PMrqqkJTZROlbhZkPfvLKYEtcAsflXi` (cost 10, bcryptjs)
- Dev plaintext password constant: `src/lib/mock-data.ts:1485` (DEV_PASSWORD = 'Peerloop2')
- Prod admin seed (still old hash): `migrations/0002_seed_core.sql:172`
- Route-matrix scanner: `scripts/route-matrix.mjs:202-211` (normalizeDynamic)
- /w-codecheck Check 8 (needs fixing): `.claude/skills/w-codecheck/SKILL.md` schema-aware deleted_at section

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Quick wins available:** [MND] (hostname fix, trivial), [RAM-NO-NAV] (decide silence vs wire). **Higher-value:** [CCK-DA] (script heuristic redesign with fixture-driven validation per memory/feedback_heuristic_calibration.md). **External-blocked / waiting:** [BR-ZERO-REPRO], [BR-STATUS], [AAP], [VITE-DEPS-WATCH], [XMV].
