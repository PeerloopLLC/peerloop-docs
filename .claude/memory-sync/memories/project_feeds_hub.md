---
name: feeds-hub-block-rationale
description: "/feeds = Discover-destination role-tab directory. FeedsHub composite was once destined for \"/\" (Conv 224) but Conv 267 (HOME-FEED-MERGE ph5) made / the merged SmartFeed surface and UNMOUNTED FeedsHub — do NOT re-add it to Home"
metadata: 
  node_type: memory
  type: project
  originSessionId: e154550c-5f54-406f-b4e4-eca419aa474f
---

Client directive (Conv 014): Feeds provide ~50% of learning on the platform. Students take courses for focused learning but ask questions in feeds — feeds are where they get answers.

**RESOLVED — Conv 224 (DRV-C, /feeds identity question).** Two distinct feed surfaces exist; do NOT conflate them:

1. **`/feeds` = the Discover destination** (DISC-ROLE-VIEWS Phase C port, Option A). Ports `old/discover/feeds.astro` → Matt root `/feeds`: a `DiscoverFeedsGrid` (public feeds to join, CTAs) + the role-aware "Your Feeds" directory (`ExploreFeeds`, which is already an All/Student/Teaching/Created/Moderating role-tab dispatcher). Mirrors the just-shipped `/communities` (Conv 222) + `/members` (Conv 223) siblings. The Discover slide-panel "Feeds" link (`/discover/feeds`) repoints here.

2. **`FeedsHub` composite → was destined for the `/` landing page (Conv 224) — ⚠️ SUPERSEDED Conv 267.** Original plan: FeedsHub (the composite: The Commons pinned + Home-Feed link + Community/Course type-sections + badges + search, in `src/components/feed/FeedsHub.tsx`) would be the `/` landing page, personalized when logged in. **That never happened.** Per the client directive (Conv 258), **HOME-FEED-MERGE phase 5 (Conv 267)** made `/` the *merged SmartFeed surface* + sole public marketing page; of the prior dashboard content **only the nudges remain**. The "Your Feeds" FeedsHub panel, quick-start ActionCards, Recent-Activity empty state, and the Conv-256 cross-role TriageStrip were all **REMOVED from Home**. The `FeedsHub.tsx` component still exists in the codebase but is **unmounted** — do NOT re-add it to Home.

**Why the composite is OUT of /feeds (still true):** different job (landing vs Discover directory), keeping `/feeds` composite-free makes it a clean sibling of `/communities` + `/members`. See [[feedback_port_functionality_and_styling]].

**Out of scope for /feeds:** `/feed` (SmartFeed aggregated timeline — separate content surface) and `/course/[slug]/feed` (per-course feed).

**Home layout note (Conv 298, [[?]] [HOME-RPANEL]):** Home (`src/pages/index.astro`, @matt-inspired) is now: breadcrumb + OnboardingNudgeBanner + ProgressionNudge + SmartFeed (member); visitor swaps nudges for an orienting line + StickySignupBar. Conv 298 added a bespoke right-side light-blue "coming soon" panel (feed fixed-640 anchored left, panel flex-grows right, hidden `<lg`) — Home-only divergence from the CD-039 Q2 left-panel decision.

**How to apply:** `/` is the merged SmartFeed surface — do NOT mount FeedsHub (or ActionCards / TriageStrip) on Home. `/feeds` stays the Discover-destination role-tab directory (FeedsHub composite belongs on neither today).
