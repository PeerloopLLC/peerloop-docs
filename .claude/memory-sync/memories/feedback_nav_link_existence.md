---
name: Browser-run nav link existence check
description: PLATO browser-runs must verify nav links exist before clicking — some are conditional (e.g., /onboarding disappears after first tag selection)
type: feedback
---

Nav paths from route-map.generated.ts assume links always exist, but some are conditional:
- AppNavbar "Complete Profile" → `/onboarding` has `hideWhenOnboarded` — disappears after onboarding starts
- Other nav items may be capability-gated (e.g., `/teaching` only for teachers, `/creating` only for creators)

**Why:** User pointed out that browser-runs will error if they try to click a link that's been hidden by state. The route-map is a static snapshot; runtime state determines what's actually visible.

**How to apply:** When writing PLATO browser-run steps that follow a nav path, note that the path may need a fallback (e.g., direct URL entry) if the nav link is state-dependent. Browser-runs should gracefully handle "link not found" rather than hard-failing.
