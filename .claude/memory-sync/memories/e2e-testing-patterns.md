---
name: E2E testing patterns for Peerloop
description: After page.goto() add waitForLoadState('networkidle') for Astro client:load islands (parallel-worker hydration race); E2E suite needs npm run db:setup:local seed-data headroom (cross-test write contamination)
type: feedback
originSessionId: b7ca0efc-0993-40d0-90b1-6a94909c0b7f
---
## React Hydration Under Parallel Load

Astro `client:load` islands SSR-render HTML before React hydrates JS handlers.
Under parallel worker load, buttons are **visible but not interactive**.

**Fix:** Add `waitForLoadState('networkidle')` after `page.goto()`:
```ts
await page.goto('/some-page');
await page.waitForLoadState('networkidle');
```

Discovered: Session 335 — booking wizard button click failed in parallel but passed with `--workers=1`.

## Cross-Test DB Contamination

Tests that write data (POST /api/sessions) leave state affecting other tests.

**Fix:** Add headroom in seed data. Always `npm run db:setup:local` before full E2E suite.
