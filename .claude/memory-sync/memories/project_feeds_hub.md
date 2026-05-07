---
name: FEEDS-HUB block rationale
description: Client expects feeds = 50% of learning; composite /feeds page needed as primary destination, not just slideout nav
type: project
---

Client directive (Conv 014): Feeds provide ~50% of learning on the platform. Students take courses for focused learning but ask questions in feeds — feeds are where they get answers.

**Why:** This reframes feeds from a navigation utility to a primary learning surface. The current FeedSlidePanel (320px slideout) can't carry this weight. A full-page hub is needed.

**Current feed surfaces (pre-FEEDS-HUB):**
- `FeedSlidePanel` — slideout from navbar, lists townhall + communities + course feeds (own API calls)
- `/feed` — aggregated home timeline (Stream.io)
- `/community` — My Communities hub (communities only, no course feeds)
- `/community/[slug]` — individual community feed
- `/course/[slug]/feed` — course discussion feed

**Gap:** No full-page view that shows ALL feeds (communities + courses) together with activity indicators. Students need to know which feed to post their question in.

**Decision (Conv 014):** Option 1 — build Phase 5 as-scoped (MyFeeds card + FeedSlidePanel refactor), then create FEEDS-HUB block for the composite `/feeds` page. Phase 5 doesn't create ambiguity because FeedSlidePanel + dashboard card + `/feed` aggregated timeline cover the navigation adequately for Genesis cohort.

**How to apply:** When building FEEDS-HUB, the composite `/feeds` page should include: The Commons pinned top, course feeds grouped by enrollment status (active first), community feeds, activity indicators (recent post count, unread status), search. The MyFeeds dashboard card (Phase 5) becomes a driver to this page.
