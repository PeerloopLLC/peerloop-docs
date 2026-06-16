---
name: project_ephemeral_dismiss_dev_staging
description: "Dismissible nudges/recs reappear on every reload in dev+staging by design (ephemeral-dismiss helper) — NOT a bug; don't re-persist"
metadata: 
  node_type: memory
  type: project
  originSessionId: 7a4d174a-0668-449c-bcd6-ab03ed4c0dcb
---

**Soft-dismissible UI (onboarding nudge, recommendation bands) intentionally reappears on every page load in dev + staging** (Conv 292). They can still be dismissed within a session (the × hides them until refresh), but the persisted localStorage flag is **ignored on mount** in dev/staging so their UI is always visible while building/QAing pages and during client staging tests. Production keeps persistent dismissal.

Mechanism: `src/components/.../` dismissibles read mount-time state via `readDismissed(key)` from **`src/lib/ephemeral-dismiss.ts`**. `dismissalPersists()` returns `false` (→ ephemeral/always-show) when `import.meta.env.DEV` (local `astro dev`), `localhost`/`127.0.0.1`, or `location.hostname.includes('staging')` (staging = `peerloop-staging.…workers.dev`); `true` only on the production domain.

Components using it: `OnboardingNudgeBanner`, `RecommendedCourses`, `RecommendedCommunities` (keys `peerloop:nudge:onboarding:<context>`, `peerloop:recs:courses:dismissed`, `peerloop:recs:communities:dismissed`).

**Why:** otherwise a dismissed nudge/band is invisible during page work, so its UI is unaccounted for ([RG-COURSES] sweep need). **How to apply:** if a client/QA reports "dismiss doesn't stick on staging," that is EXPECTED — do not re-persist. Staging detection is hostname-substring `staging`; if staging moves to a domain without that substring, update `ephemeral-dismiss.ts` (or switch to a build-time `PUBLIC_` env var). New dismissibles should call `readDismissed()` instead of reading localStorage directly. Relates to [[project_staging_integration_plan]], [[reference_staging_url]].
