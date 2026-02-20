# Session Decisions - 2026-02-05

## 1. CommunityFeed as Separate Component (Not Parameterized TownHallFeed)
**Type:** Implementation
**Topics:** stream, astro

**Trigger:** Needed to implement per-community feeds. TownHallFeed uses `townhall:main` but communities need `community:{communityId}`.

**Options Considered:**
1. Create new `CommunityFeed` component + dedicated API endpoints ← Chosen
2. Refactor `TownHallFeed` to accept feed configuration as props

**Decision:** Created separate `CommunityFeed.tsx` component with its own API endpoints at `/api/feeds/community/[slug]/*`.

**Rationale:**
- TownHallFeed has course tagging/filtering that communities don't need
- Clearer separation of concerns
- Easier to maintain/debug
- Follows CourseFeed pattern (also a separate component)

**Consequences:**
- 4 new files: component + 3 API endpoints
- Slightly more code than parameterizing TownHallFeed
- More consistent with existing codebase patterns

---

## 2. Parameterize FeedActivityCard/CommentSection Instead of Creating Variants
**Type:** Implementation
**Topics:** stream, astro

**Trigger:** FeedActivityCard and CommentSection hardcoded `/api/feeds/townhall/*` URLs. Needed them to work with community feeds.

**Options Considered:**
1. Add `feedApiBasePath` prop to existing components ← Chosen
2. Create CommunityActivityCard, CommunityCommentSection variants
3. Use React Context to provide feed configuration

**Decision:** Added optional `feedApiBasePath` prop with default value to existing components.

**Rationale:**
- Backward compatible (existing usage unchanged)
- Single source of truth for component logic
- Explicit prop drilling easier to trace than Context
- Less code than creating variants

**Consequences:**
- Modified 2 shared components
- CommentSection required prop propagation to nested CommentItem
- All three feed types (townhall, course, community) can share components

---

## 3. AppNavbar "My Communities" Link Fixed to /community
**Type:** Implementation
**Topics:** astro

**Trigger:** Found AppNavbar linked to `/communities` (plural) but page exists at `/community` (singular).

**Options Considered:**
1. Fix AppNavbar to use `/community` ← Chosen
2. Create redirect from `/communities` to `/community`
3. Rename page to `/communities` to match nav

**Decision:** Fixed the AppNavbar link from `/communities` to `/community`.

**Rationale:**
- `/community` is the established route (follows hierarchy pattern)
- One-line fix vs creating redirect infrastructure
- Consistent with tech-021-url-routing.md documentation

**Consequences:**
- Navigation now works correctly
- No 404 when clicking "My Communities"
