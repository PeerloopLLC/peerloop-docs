---
name: feeds-hub-block-rationale
description: "[FEEDS] / is the merged SmartFeed surface — do NOT re-add panel surfaces to its FEED COLUMN. Conv 427 correction: /feeds and FeedsHub NO LONGER EXIST (route retired Conv 331), and the bar never covered the right rail, which now carries DiscoveryRails"
metadata: 
  node_type: memory
  type: project
  originSessionId: e154550c-5f54-406f-b4e4-eca419aa474f
  modified: 2026-07-28T15:10:35.014Z
---

Client directive (Conv 014): Feeds provide ~50% of learning on the platform. Students take courses for focused learning but ask questions in feeds — feeds are where they get answers.

**⚠️ Conv 427 correction — two things this memory used to assert are GONE. Verified, not inferred:**

- **`/feeds` does not exist.** It was built Conv 224 (`39d48647`, the DRV-C Discover-destination port) and **retired Conv 331** (`d47c8612`, "Retire /feed + /feeds routes; close RG-DISCOVER"). There is no `src/pages/feeds.astro` and zero `href="/feeds"` in `src/`. Do not plan work "onto `/feeds`" — that means building a new route.
- **`FeedsHub.tsx` does not exist either.** It was unmounted from Home by Conv 267 and has since been deleted, so "do NOT re-add FeedsHub to Home" is now a rule about a component that is not there.
- **A new `/discover` hub is also barred** — `docs/decisions/01-architecture.md` **DISC-DROP** (Conv 204) dropped `/discover` entirely and folded it into `/courses`.

**What is still true and still load-bearing.** Per the client directive (Conv 258), **HOME-FEED-MERGE phase 5 (Conv 267)** made `/` the *merged SmartFeed surface* + sole public marketing page; of the prior dashboard content **only the nudges remain**. The "Your Feeds" panel, quick-start ActionCards, Recent-Activity empty state, and the Conv-256 cross-role TriageStrip were all **REMOVED from Home**. Home is: breadcrumb + OnboardingNudgeBanner + ProgressionNudge + SmartFeed (member); a visitor swaps nudges for an orienting line.

**Scope of the bar (clarified Conv 427).** It governs Home's **feed column** — the feed leads, and nothing may be stacked above it competing for that attention. It never governed the **right rail**, which was an explicitly empty `hidden lg:block` "More coming soon" placeholder from Conv 298 ([HOME-RPANEL]) until `[REC-REHOME]` filled it. Reading the bar as "no panel may exist anywhere on `/`" is what stalled `[REC-REHOME]` for two convs.

**Home also already does entity discovery in-stream:** `SmartFeed` renders rails-backed `suggestion-card`s (`SuggestionCard.tsx` — reason badge new/trending/topic_match/popular, CTA, and a dismiss that POSTs to `/api/feeds/smart/dismiss` and *trains* future feeds). Before proposing any new "recommend courses/communities" surface, check whether this already covers it.

**Right rail today (Conv 427, `[REC-REHOME]`):** `/`, `/courses` and `/communities` all mount `DiscoveryRails` in that rail — For You / Trending / New / Popular lanes off the ONE global Discovery Rails blob. The blue placeholder survives as the island's empty-state fallback. The old per-page carousels and both `/api/recommendations/*` endpoints are deleted. See [[project_role_studios_deconstruct_nudges]].

**Out of scope:** `/course/[slug]/feed` (per-course feed) is a separate content surface and still exists.

**How to apply:** `/` is the merged SmartFeed surface — do NOT stack panel surfaces above/into its feed column. The right rail is fair game and is already occupied by `DiscoveryRails`. Do not route new work to `/feeds` or `/discover`; neither exists.
