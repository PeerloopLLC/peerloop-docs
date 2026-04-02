# State — Conv 075 (2026-04-02 ~11:18)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 075 backfilled BrowserIntent walkthroughs for ecosystem (22 intents) and activities (14 intents) PLATO instances, fixed 3 pre-existing test failures, and secured the BBB webhook endpoint with URL-embedded HMAC token authentication. Memory files corrected for PLATO browser-mode terminology.

## Completed

- [x] Backfill BrowserIntent walkthroughs for `ecosystem` and `activities` scenarios
- [x] Fix 3 pre-existing test failures (handle format, ForCreators CTA, onboarding title)
- [x] Security: BBB webhook endpoint HMAC signature validation
- [x] Memory corrections: PLATO browser-mode terminology (browser-runs via /chrome MCP, not Playwright)

## Remaining

### Carried Forward
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)

### Docs Drift
- [ ] TEST-COVERAGE.md: E2E section header says "25 files" but actual count is 30 (pre-existing)

## TodoWrite Items

- [ ] #2: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #3: Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)
- [ ] #6: TEST-COVERAGE.md: E2E section header says "25 files" but actual count is 30 (pre-existing drift)

## Key Context

- **BBB webhook auth**: `src/lib/webhook-auth.ts` provides `generateWebhookToken()` / `verifyWebhookToken()`. Token is HMAC-SHA256(sessionId, BBB_SECRET). Generated in `join.ts`, verified in `bbb.ts`. PLATO api-runner auto-injects tokens for BBB step actions.
- **BrowserIntent instances**: `ecosystem.instance.ts` (22 intents, multi-course/multi-student) and `activities.instance.ts` (14 intents, sessions/homework/social). Both registered in `instances/index.ts`.
- **PLATO browser-runs**: Execute through /chrome MCP bridge, not Playwright. NavClick = deterministic, pageAction = prose/instructional. See memory files `feedback_plato_browser_mode.md` and `feedback_plato_stumble_terminology.md`.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
