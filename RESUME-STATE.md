# State — Conv 067 (2026-03-31 ~21:08)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 067 performed the first STUMBLE-AUDIT walkthrough of the registration PLATO run (visitor→member). Fixed 7 issues discovered during the walkthrough: dead signup params, wrong visitor redirect, password validation mismatch, and most significantly removed the username field from signup entirely (server now auto-generates handles from name with collision suffix). Added post-signup redirect to /onboarding. Registration run walks clean end-to-end.

## Completed

- [x] CreatorTeacherList test verified passing (already fixed Conv 028)
- [x] Mapped all registration entry points in codebase
- [x] Removed dead `?role=creator` param from marketing links
- [x] Fixed EnrollButton to redirect visitors to `/signup` not `/login`
- [x] Wired email URL param through to SignupForm for ModeratorInvite pre-fill
- [x] Synced client-side password validation with server rules
- [x] Removed username field from signup, added server-side handle auto-generation with collision suffix
- [x] Updated PLATO runs to not send handle in register body
- [x] Rewrote SignupForm + register API tests for new behavior
- [x] Added post-signup redirect to `/onboarding`
- [x] Walked registration flow clean: visitor → Create account → 4 fields → submit → /onboarding
- [x] Verified handle collision: testwalker, testwalker1
- [x] Added ROUTE-AUDIT deferred block (#39) to PLAN.md

## Remaining

### Carried Forward
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities) — now enclosed in /discover routes
- [ ] Monitor maybeUpdateActorSession design flaw (Convs 063-065) — if more collisions occur, fix by scoping auto-detection to source: 'register' actions only

### STUMBLE-AUDIT Findings (not yet fixed)
- [ ] Handle validation mismatch — 3 different validators (SignupForm client, auth/index.ts register, api/me/profile.ts update) need unification
- [ ] Verify username change works in settings/profile UI
- [ ] Email pre-fill not tested in browser — verify ModeratorInvite `/signup?email=...` path
- [ ] Home page: differentiate new member view from established member (needs client input)

### Documentation
- [ ] Clarify migration file naming — distinguish schema vs data files
- [ ] Re-run route-matrix.mjs — EnrollButton redirect and for-creators params changed
- [ ] Pre-existing test count discrepancy: auth-modal.test.ts 28 in TEST-UNIT.md vs 26 in TEST-COVERAGE.md

## TodoWrite Items

- [ ] #1: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #2: Monitor maybeUpdateActorSession design flaw (Convs 063-065)
- [ ] #8: Handle validation mismatch — 3 validators need unification
- [ ] #11: Email pre-fill not tested in walkthrough — verify ModeratorInvite path
- [ ] #12: Verify username change works in settings/profile UI
- [ ] #16: Home page: differentiate new member view from established member (needs client input)
- [ ] #17: Clarify migration file naming — distinguish schema vs data files
- [ ] #18: Re-run route-matrix.mjs — EnrollButton redirect and for-creators params changed
- [ ] #19: Pre-existing test count discrepancy: auth-modal.test.ts 28 vs 26

## Key Context

- STUMBLE-AUDIT workflow: fix-as-you-find, reset DB, restart dev server, walk from top until clean. Registration run is the first to pass.
- Handle auto-generation: server generates from name (lowercase, strip non-alphanumeric, max 20 chars), appends incrementing suffix on collision (`testwalker`, `testwalker1`...). Fallback to `user` if name yields empty string.
- Post-signup redirect: `handleAuthSuccess()` checks `wasSignup` flag. Signup → `/onboarding`. Login → stays on page or `/dashboard` if on auth page. Pending action (returnUrl) takes priority over both.
- CurrentUser for new members has: `onboardingCompletedAt: null`, empty `enrollments`, `teacherCertifications`, `createdCourses` maps. All signals needed for future home page differentiation.
- Full test suite status: 66 tests passing across SignupForm (23), register API (26), EnrollButton (16), auth-modal (26). No regressions.
- Next STUMBLE-AUDIT run: onboarding flow, or admin grants creator role.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
