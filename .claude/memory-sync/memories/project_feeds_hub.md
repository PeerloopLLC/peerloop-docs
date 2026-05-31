---
name: feeds-hub-block-rationale
description: "FeedsHub composite is destined for the \"/\" landing page (Matt), NOT /feeds; /feeds is the Discover-destination role-tab directory"
metadata: 
  node_type: memory
  type: project
  originSessionId: e154550c-5f54-406f-b4e4-eca419aa474f
---

Client directive (Conv 014): Feeds provide ~50% of learning on the platform. Students take courses for focused learning but ask questions in feeds — feeds are where they get answers.

**RESOLVED — Conv 224 (DRV-C, /feeds identity question).** Two distinct feed surfaces exist; do NOT conflate them:

1. **`/feeds` = the Discover destination** (DISC-ROLE-VIEWS Phase C port, Option A). Ports `old/discover/feeds.astro` → Matt root `/feeds`: a `DiscoverFeedsGrid` (public feeds to join, CTAs) + the role-aware "Your Feeds" directory (`ExploreFeeds`, which is already an All/Student/Teaching/Created/Moderating role-tab dispatcher). Mirrors the just-shipped `/communities` (Conv 222) + `/members` (Conv 223) siblings. The Discover slide-panel "Feeds" link (`/discover/feeds`) repoints here.

2. **`FeedsHub` composite → the `/` landing page** (Matt's directive, future block — NOT /feeds). FeedsHub (the composite: The Commons pinned + Home-Feed link + Community/Course type-sections + badges + search, in `src/components/feed/FeedsHub.tsx`) is intended to be the `/` landing page — first thing a visitor sees, personalized when logged in. `/` will accrete more client-added content alongside it, so the composite needs a growable container, not the `/feeds` directory box.

**Why the composite is OUT of /feeds:** different job (landing vs Discover directory), Matt wants it on `/`, `/` will grow, and keeping `/feeds` composite-free makes it a clean sibling of `/communities` + `/members`. See [[feedback_port_functionality_and_styling]] — Option-A port must still transfer ALL of old/discover/feeds.astro's behavior (discovery grid + role tabs + visitor/auth states) field-by-field.

**Out of scope for /feeds:** `/feed` (SmartFeed aggregated timeline — separate content surface) and `/course/[slug]/feed` (per-course feed). The FeedsHub→`/` work is tracked as a separate task.

**How to apply:** When building the `/` landing block later, mount FeedsHub on `/` with visitor (public) vs logged-in (personalized) variants; do NOT put the composite on /feeds.
