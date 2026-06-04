> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 11. New Routing

This section tracks the routing restructure initiative to reorganize pages and consolidate layouts.

### Layout Naming for Parallel Development
**Date:** 2026-02-01 (Session 150)

Renamed layouts to enable parallel development of new routing structure while keeping existing pages functional:

| Old Name | New Name | Routes |
|----------|----------|--------|
| `AppLayout.astro` | `LegacyAppLayout.astro` | 30 routes (old dashboard, settings, etc.) |
| `DashLayout.astro` | `AppLayout.astro` | 7 routes (`/`, `/dash/*`) |

**Current layout inventory:**
- `AppLayout.astro` - New dashboard layout (formerly DashLayout)
- `LegacyAppLayout.astro` - Old authenticated layout (to be phased out)
- `AdminLayout.astro` - Admin panel (unchanged)
- `LandingLayout.astro` - Public pages (unchanged)

**Rationale:** `Legacy` prefix clearly signals intent to phase out. Frees up "clean" names (`AppLayout`) for new implementation. Underscore prefix (`_AppLayout`) was rejected due to ESLint parsing issues with Astro.

**See:** `src/layouts/`, Session 150 Decisions

### Archive Pages to _src/pages/ for Routing Reset
**Date:** 2026-02-01 (Session 154)

Moved all pages except `index.astro` to `_src/pages/` using `git mv` to start fresh with routing while preserving existing code for reference.

| Location | Contents | Purpose |
|----------|----------|---------|
| `src/pages/` | Only `index.astro` | Active route: `/` only |
| `_src/pages/` | 36 files + 15 dirs | Archived for cherry-picking |

**Cherry-picking workflow:**
1. Identify page to restore
2. Move from `_src/pages/` back to `src/pages/`
3. Restore any required API routes from `_src/pages/api/`
4. Update test imports if needed

**Rationale:** Clean slate approach for routing restructure. Preserves file history via `git mv`. Underscore prefix convention signals "archived, not active" and Astro ignores it entirely.

**See:** `_src/pages/`, Session 154 Decisions

### URL Routing Architecture - "Bare = My" Convention
**Date:** 2026-02-03 (Session 169)

Adopted a routing convention where bare routes represent user's personal content, and `/discover/` prefix indicates site-wide browsing:

| Pattern | Meaning | Example |
|---------|---------|---------|
| `/thing` | My personal content | `/courses` = my enrolled courses |
| `/discover/thing` | Site-wide browse | `/discover/courses` = course catalog |
| `/@handle` | Universal user profile | `/@jane` = Jane's profile |
| `/settings/*` | Account configuration | Already implies "my" |

**Role-specific dashboards:**
- `/learning` - Student dashboard
- `/teaching` - Teacher dashboard
- `/creating` - Creator dashboard

**Profile URL resolution:**
- `/@handle` - Any user's public profile
- `/@me` - Redirects to current user's profile
- `/profile` - Redirects to `/@me`
- `/settings/profile` - Edit profile form

**Rationale:** Users spend most time with their own content. The default context should be personal; discovery is an explicit action. This is more intuitive than `/my/courses` vs `/courses`.

**See:** `docs/as-designed/url-routing.md`

### Content Hierarchy - Communities → Progressions → Courses
**Date:** 2026-02-03 (Session 169)

Established a three-level content hierarchy:

```
Creator
  └── Community (topic-focused, e.g., "n8n Automation")
        └── Progression (learning journey or standalone)
              └── Course (1-10 BBB sessions)
```

**Key rules:**
- Every course belongs to exactly ONE progression
- Every progression belongs to exactly ONE community
- Progressions are the primary discovery unit (not individual courses)
- Users purchase individual courses, but browse progressions

**Display badges:**
- 1 course in progression = "Stand-alone" badge
- 2+ courses in progression = "Learning Path" badge

**Progression order is advisory, not enforced:**
- Users can start at any course in the progression
- Experienced users may skip introductory courses
- UI shows "Recommended: Complete X first" but doesn't block

**Course copying for reuse:**
- Course can only be in ONE progression
- To reuse content in another progression, copy the course (new ID, shared resources)
- `source_course_id` tracks lineage for resource sharing

**See:** `docs/requirements/rfc/CD-036/CD-036.md`

### Feed Scoping - Four Feed Types
**Date:** 2026-02-03 (Session 169)

Feeds are scoped to one of four contexts with distinct posting permissions:

| Feed | Scope | Who Can Post | Who Can View |
|------|-------|--------------|--------------|
| **The Commons** | Platform-wide | Anyone | Everyone (including visitors) |
| **Community** | Per community | Members only | TBD (design for flexibility) |
| **Course** | Per course | Enrolled + Creator/Teacher | Enrolled students |
| **Personal** | Per user | That user | TBD (followers?) |

**Community membership is derived from enrollments:**
- No separate membership table needed
- User is member if they have enrollment in ANY course of that community

**Stream.io feed patterns:**
- Personal: `user:{user_id}`
- Community: `community:{community_id}`
- Course: `course:{course_id}`
- Commons: `commons:global`

**See:** `docs/requirements/rfc/CD-036/CD-036.md`

### Feeds as Primary Learning Surface — Phased Delivery Strategy
**Date:** 2026-03-19 (Conv 014)

Client directive: feeds provide ~50% of platform learning. Students take courses for focused learning but ask questions and get answers in feeds. This elevates feeds from navigation utility to primary learning destination.

**Strategy (2 phases):**
1. **Phase 5 (CURRENTUSER-OPTIMIZE):** MyFeeds dashboard card + refactor FeedSlidePanel to use `CurrentUser.getFeeds()` — ✅ Done Conv 015
2. **FEEDS-HUB block:** Composite `/feeds` page as full-page hub with activity indicators — ✅ Done Conv 015. Navbar "My Feeds" changed from slideout panel to `/feeds` page link. FeedSlidePanel removed from navbar (orphaned). Badge counts via FEED-INTEL D1 index.

**Rationale:** A primary learning surface needs a full page, not a 320px slideout. Phase 5 didn't create navigation ambiguity; the composite page improved the experience for the "feeds = 50% of learning" vision.

> **Insight:** The aggregated `/feed` (Stream.io timeline) and the `/feeds` hub serve different purposes: the timeline is a *social* feed (chronological posts mixed together), the hub is a *navigation* surface ("here are your feeds, pick one"). Both are needed — the hub helps students choose WHERE to post, the timeline shows WHAT's happening.

---

### FEED-INTEL: D1 Activity Index Alongside Stream.io (CQRS Hybrid)
**Date:** 2026-03-19 (Conv 015)

Stream.io flat feeds have no unread/unseen tracking, no "count since timestamp" queries, and no cross-feed aggregation. This blocks badge counts and smart surfacing. Solution: CQRS pattern — Stream remains durable content store (posts, reactions, comments, threading), D1 gets a thin metadata index (`feed_visits` + `feed_activities`) for navigation queries.

**Implementation:** Write-time indexing — INSERT into `feed_activities` alongside `stream.addActivity()`. Visit recording — upsert `feed_visits` on feed page load (offset=0 only). Badge counts — single D1 query via LEFT JOIN, zero Stream API calls. Clearing — visiting a feed updates `last_visited_at`, all prior posts become "seen."

**Update (Conv 016):** Comment endpoints DO have slug context (URL params). Dual-write added to all 5 post/comment endpoints (3 post + 2 comment). Course comments/reactions endpoints created. `enrollments.user_id` → `student_id` bug fixed in badge query.

**Rationale:** Each system does what it's good at. Stream handles fan-out, reactions, threading. D1 handles cross-feed queries and unread counts. The D1 index is rebuildable from Stream — not a new source of truth.

> **Insight:** This is textbook CQRS — the write model (Stream) optimizes for durability and fan-out, the read model (D1) optimizes for the specific queries the UI needs. The D1 index is *expendable*: a failed INSERT means a badge count is off by one, not data loss. This asymmetry makes the dual-write safe without distributed transactions.

---

### Auto-Routing FeedActivityCard via Activity Metadata
**Date:** 2026-03-19 (Conv 016)

`FeedActivityCard` derives the correct feed API base path from activity metadata (`communitySlug`, `courseSlug`) instead of requiring parent components to pass it. This ensures comments, reactions, and replies route to the correct feed-specific endpoint from any surface — dedicated feed pages, home timeline, and future surfaces like the smart feed.

**Rationale:** Stream activities carry their source context from creation time. Self-routing from data is more resilient than parent configuration — every new display surface gets correct routing automatically without knowing the routing rules.

---

### SMART-FEED: Hybrid Query Strategy (D1 + App-Side Scoring + Stream Enrichment)
**Date:** 2026-03-19 (Conv 017)

SMART-FEED uses a three-phase hybrid architecture instead of complex SQL scoring: (1) D1 selects raw candidates via the proven tuple-matching pattern from `getFeedBadgeCounts()`, (2) app code loads relationship metadata via parallel D1 queries and scores candidates in TypeScript, (3) Stream batch-fetches full activity objects and adds engagement data. Each phase is independently testable.

**Rationale:** Plan Mode verification found the original 7-JOIN CTE design fragile. The hybrid approach matches the existing architecture where `feed-badges.ts` pre-computes feed lists in app code. Scoring in TypeScript allows the algorithm to be swapped without changing the selection or enrichment layers.

> **Insight:** The `scoring.ts` module has a stable interface (`scoreCandidates(candidates, context, params)`) with swappable internals. This means the algorithm can evolve from weighted signals to ML-based ranking without any changes to candidates.ts, enrichment.ts, or the API endpoint.

---

### SMART-FEED: Discovery Cards as Flywheel Driver
**Date:** 2026-03-19 (Conv 017)

Discovery cards are included from day one — not deferred. Public community and course feeds matching user interests are surfaced to non-members with preview text, engagement social proof, and a CTA to join/enroll. Access rules: public communities only (`is_public = 1`), public course feeds only (`feed_public = 1`), no private content. Server-side dismiss tracking via `smart_feed_dismissals` table.

**Rationale:** The Genesis group (60-80 students) is the proving ground for the learn-teach-earn flywheel. Discovery drives visibility → engagement → enrollment → teaching. Waiting for a later phase would miss the testing window.

---

### SMART-FEED: Isolated Scoring Algorithm with Tunable Params
**Date:** 2026-03-19 (Conv 017)

Scoring weights and parameters stored in `platform_stats` (~12 keys with `smart_feed_*` prefix). Algorithm isolated in `src/lib/smart-feed/scoring.ts`. Discovery posts use engagement-heavy weights; member posts use tunable weights. Topic matching uses three signals: static interests (`user_topic_interests`), feed affinity (posting frequency), and category affinity — all SQL-based with no NLP or external APIs.

**Rationale:** Under 15 params fits key-value `platform_stats` rows. Algorithm isolation allows swapping the scoring function without touching candidates, enrichment, or the API layer. Topic signals are all derived from existing indexed tables.

---

### SMART-FEED: Discovery Cards Capped at 1 Per Feed
**Date:** 2026-03-30 (Conv 059)

Discovery cards are capped at 1 per feed in `applyDiversityCap()`. Discovery cards represent "this feed is active, check it out" — a feed-level suggestion, not post-level content. Multiple cards from the same discovered feed are redundant.

**Rationale:** Without the cap, users saw 3 identical cards from the same feed (e.g., "Intro to n8n") which wasted feed real estate and looked like a bug.

---

### SMART-FEED: Completed Enrollments Included in Teacher/Creator Scoring
**Date:** 2026-03-30 (Conv 059)

Teacher/creator relationship persists after course completion for Smart Feed scoring and filtering. `loadScoringContext()` queries include `'completed'` enrollment status alongside `'enrolled'` and `'in_progress'`.

**Rationale:** Students maintain meaningful relationships with their teachers after finishing a course. Excluding completed enrollments caused the "From Teachers" filter to show nothing for students who had finished their courses — poor UX that contradicts the learn-teach-earn flywheel.

> **Insight:** Role-based filters (e.g., "From Teachers") should use boolean flags computed during scoring (`isTeacherPost`, `isCreatorPost`) rather than the `surfaceReason` field, which reflects the dominant algorithm signal (recency, relationship, engagement) — not the actor's role. When recency weight (0.30) exceeds relationship weight (0.25), teacher posts surface as `'recent'` and the role filter misses them entirely.

---

### Dynamic Catch-All for Role-Aware Tab URLs: `[tab].astro` with Whitelist + Access Gate
**Date:** 2026-05-20 (Conv 166)

Role-specific tab URLs under `/course/<slug>/` (`teaching-sessions`, `creator-sessions`, `admin-sessions`, `moderator-sessions`) are served by **one** dynamic catch-all page, `src/pages/course/[slug]/[tab].astro`, not by cloning `sessions.astro` per tab. The catch-all maintains a whitelist (`roleTabMap`) of `tabId → required role flag` and gates access: unknown tab → redirect to `/404`; caller lacks the role → redirect to `/course/<slug>` preserving query params via `Astro.url.search`. Existing static routes (`sessions.astro`, `feed.astro`, `learn.astro`, `resources.astro`, `teachers.astro`, `book.astro`, `index.astro`) take precedence per Astro's static-over-dynamic routing rule and are unaffected.

**Rationale:** Per CLAUDE.md §Solution Quality default-durable rule, the catch-all is the durable option — adding a future role tab is a one-line `roleTabMap` + `tabLabels` entry, not a new ~170-line `.astro` file. The alternative (clone `sessions.astro` 4×) was rejected at ~680 LOC of duplication that would diverge over time. Astro's static-route precedence is the empirical enabler: browser-verified that `/course/intro-to-n8n/book` still hits `book.astro` with `[tab].astro` present.

**Consequences:** All 4 role-tab URLs load correctly on manual refresh / shared bookmark / direct nav. The pattern (whitelist + access gate + static-precedence) is the canonical shape for any future dynamic-segment route under a `[slug]` parent. Inline `Astro.url.search` in the redirect (don't extract to `const search = ...`) — Astro's TS analyzer occasionally fires ts 6133 on intermediate variables consumed inside template literals.

**See:** `src/pages/course/[slug]/[tab].astro`

---

### Clock Abstraction for Time-Sensitive Endpoints
**Date:** 2026-03-17

`src/lib/clock.ts` exports `getNow()` — use it instead of `new Date()` in any code that makes time-sensitive decisions (join windows, late-cancel checks, availability slot generation). Tests mock it to freeze time. Session cancel, session join, and availability endpoints updated.

**Rationale:** `new Date()` in handlers is untestable. A simple wrapper gives tests a clean mock point with zero runtime cost.

> **Insight:** The combination of clock injection + UTC test helpers + CI lint eliminated an entire class of "passes locally, fails on CI" bugs. The three tools work together: clock injection makes handler logic testable, UTC helpers make test data safe, and the lint catches regressions before they reach CI.

**getNow() sweep (Conv 089):** Audit found only 4 of 22+ eligible files actually imported `getNow()` despite the abstraction existing since Conv 003. Migrated 22 source files across 3 tiers: high-priority session/invite guards (10 files), business logic (4 files), analytics endpoints (8 files). Extended `lint-timezone.sh` with a source-file scan that flags bare `new Date()` and `Date.now()` in `src/pages/api/` and `src/lib/` — use `// getNow-exempt` inline comment for legitimate uses (DB stamping, ID generation, clock.ts itself).

### UTC Test Date Helpers
**Date:** 2026-03-17

`tests/helpers/dates.ts` provides `utcDate()`, `futureUTC()`, `pastUTC()`, `nextDayOfWeekUTC()`, `toDateStringUTC()`. All test date construction should use these instead of `setHours()` or multi-arg `new Date()`. CI lint script `npm run lint:tz` flags violations.

**Rationale:** Timezone-unsafe date patterns caused 5 test failures on CI that passed locally. See BEST-PRACTICES.md §8 "Timezone Safety in Tests" for full guidelines.

---

### Enrollment Guards — Block vs Warn Strategy
**Date:** 2026-03-18

Creator self-enrollment, active teacher self-enrollment, duplicate active enrollment, and zero teachers are hard blocks (400). No availability in the configurable window is warn-only — students can still enroll because teachers may update schedules. Zero teachers triggers notification to creator + all admins.

**Rationale:** Hard blocks prevent broken business logic (creator paying themselves). Soft warn for "no availability" because availability is dynamic.

### Re-Enrollment as New Row with Partial Unique Index
**Date:** 2026-03-18

Multiple enrollment rows allowed per student+course. Completed/cancelled rows retained as history. Partial unique index `WHERE status IN ('enrolled', 'in_progress')` enforces at most one active enrollment at the DB level.

**Rationale:** Preserves completion history. Partial unique index is more reliable than app-level checks — survives race conditions and direct DB access.

> **Insight:** SQLite partial indexes (`CREATE UNIQUE INDEX ... WHERE condition`) are underused but ideal for "at most one active" patterns.

### Inactive Teacher Treated as Student for Enrollment
**Date:** 2026-03-18

Only teachers with `is_active=1` AND `teaching_active=1` are blocked from self-enrolling. Deactivated or paused teachers can enroll as regular students.

**Rationale:** Per client: "An inactive teacher is the same as a student from the POV of the course."

### Availability Summary — Public Endpoint with Optional Auth
**Date:** 2026-03-18

`GET /api/courses/:id/availability-summary` is public. Shows slot counts and next-available dates (not exact times). Optional auth to exclude self from teacher list.

**Rationale:** Teacher names/ratings already public. Slot counts add minimal privacy risk. Exact booking times remain behind authenticated booking flow.

### Matt Course SubNav Routing Mirrors `/discover/course` Rest-Spread Pattern
**Date:** 2026-05-24 (Conv 186)

`/matt/course/[slug]/[...tab].astro` mirrors `/discover/course/[slug]/[...tab].astro` exactly, with `VALID_TABS = ['about','modules','reviews','resources','teachers','creator']` and React-island in-app navigation via History API. Path-based (not query-string); SSR-friendly default tab via session; redirect-on-invalid.

**Rationale:** Consistency with established Peerloop convention; cleaner URLs for sharing; team has already validated this pattern at `/discover/course`. Per CLAUDE.md §Solution Quality default-durable rule, mirroring the existing rest-spread pattern is the durable option vs. query-string or client-state-only alternatives.

**Consequences:** Resolves one of `[MATT-EXEC-FLAGS]`'s 7 sub-assumptions. Creator becomes one of 6 tabs in `VALID_TABS`, not a separate route. Tracked in `[MATT-SUBNAV-ROUTING]`.

**See:** `src/pages/discover/course/[slug]/[...tab].astro` (canonical pattern)

---

### Matt Course Page: Single Catch-All Route (About as Empty Segment)
**Date:** 2026-05-25 (Conv 190)

The `/matt/course/[slug]` family is owned by one `[...tab].astro` catch-all. The empty segment renders the About view (body, not a redirect); `index.astro` is deleted. SubNav config lives in a single `_course-tabs.ts` (`buildCourseTabs(slug)`, `_`-prefix excludes from routing) imported by the route.

**Rationale:** Two route files (`index.astro` + `[...tab].astro`) each carried a duplicate `courseTabs` array, which caused SubNav-icon drift (one route updated, the other not) and a redirect-loop lock-in. A single catch-all removes the whole "edited one route, forgot the other" failure class.

**Consequences:** `index.astro` deleted; `route-map.generated.ts` regenerated; conditional title/breadcrumb added. **Reverses** the Conv 188 [MATT-EXEC-PG2] "Option A — shell duplicated, index.astro untouched" structure decision.

---

### Matt Shell: Grey Page + Floating White Content Card
**Date:** 2026-05-25 (Conv 190)

`AppLayout` for `/matt/*` uses a `#f8fafc` page background with the content rendered as a white rounded-20 card + shadow; the sidebar is transparent. Adopted as the full shell (scope B) rather than restyling the sidebar internals alone.

**Rationale:** Matt's active-item blue/white pill only reads as designed against a grey page; a sidebar-only change would leave the active pill white-on-white. The shell and sidebar are one visual system in Matt's Layout Desktop (`81:1483`).

**Consequences:** Body bg + content-card treatment changed for every `/matt/*` page. Logo dropped Medium→Small; MainNav gap 16→24; collapse `«` double-chevron harvested as `chevrons-left.svg` (43rd Matt icon).

---

### Role-Display Label: `roles.ts` Multi-Role Helper + Hierarchy
**Date:** 2026-05-25 (Conv 190)

`src/lib/roles.ts` exposes `userRoles()` + `describeRoles()` over the hierarchy Admin > Creator > Teacher > Moderator > Student (Student is base-only). Label rules: 1 role → role name; 2 → "A, B" (higher first); 3+ → "A + N more"; not logged in → "Visitor". Hierarchy sourced from `UserProfileHeader.tsx`.

**Rationale:** Users hold multiple roles; a single derived role (is_admin?Admin:…) loses that. A reusable helper matches the established badge convention and handles multi-role users uniformly.

**Consequences:** `AppLayout` selects all 5 capability flags and builds the label. Sidebar Profile row shows avatar+name+role when logged in, or filled-circle `user-icon` + "Visitor" (links `/login`) otherwise. Logged-in render not yet visually verified (only Visitor confirmed).

---

### MATT-CUTOVER: Routing Flip (`/matt`→`/`, legacy→`/old`) + Full Namespace Dissolve
**Date:** 2026-05-26 (Conv 195)

After the demo, flip `/matt/*`→`/` and legacy routes→`/old/*`, and dissolve `src/components/matt/*`→`src/components/*` (physical file moves, Astro file-based routing). No fallback redirects — this is not a production app, so unbuilt root routes simply 404. `/old` is the legacy prefix (supersedes the `/fraser` name floated in Conv 193). NAV-RETROFIT stays active until the flip ships, then is superseded.

**Rationale:** Once the namespace dissolves, the folder can no longer carry provenance — an explicit `@matt-source` marker becomes the only coherent authorship signal (reinforces the provenance decision below). Not-production status means the simplest flip works (file-move + link-rewrite, no middleware/redirect layer).

**Consequences:** New MATT-CUTOVER PLAN block (tasks [PROV]/[ROUTE-FLIP]/[PROV-SWEEP]). `/fraser`→`/old` reconciled across `url-routing.md` §8 + `matt-pre-plan.md`. §8 ROUTE-FLIP checklist in `matt-provenance.md` covers API-route exclusion, layout-name collision, ~225 hardcoded `/matt` URLs, demo bridges, ~13 Matt routes vs ~85 legacy. [ICN-NS] overlaps the icon-namespace dissolve — fold/clarify at flip time.

**See:** `docs/as-designed/matt-provenance.md`, `docs/as-designed/url-routing.md` §8

---

### MATT-CUTOVER: `@matt-source` Provenance Marker — Mark Only Matt's
**Date:** 2026-05-26 (Conv 195)

To resolve collisions when Matt redraws something already built, mark only Matt-authoritative artifacts with an inline `@matt-source <figma-node>` marker; everything unmarked (within the design-system layer) is ours. The marker carries the Figma node ref (verifiable, sweep anchor). Adding the marker when Matt redraws is the reconciliation event; `git diff` is the audit trail.

**Rationale:** Domain (design-system vs legacy) and authorship (Matt vs Claude) are orthogonal axes — a folder/route prefix encodes domain cheaply but cannot encode authorship, since authorship is mixed *within* the design-system folder (Matt won't draw everything). "Ours" is the large permanent majority, so marking the minority makes the marker meaningful. Considered: 3-state tag on everything / central manifest / naming-namespace marker — all rejected for the positive-marker-on-Matt's-only scheme. Reinforced by the namespace dissolve (no folder to lean on). Sequencing: mark BEFORE the flip — the `matt/` folder is a free audit aid (everything under it is in-domain) that the flip destroys.

**Consequences:** New `docs/as-designed/matt-provenance.md` (two-axis model, marker spec, reconciliation-via-git, detection sweep). Open: exact marker syntax per artifact type (settle at [PROV] start); whether colocated ours-items get explicit `@matt-source none` (leaning no).

**See:** `docs/as-designed/matt-provenance.md`

---

### ROUTE-MIGRATION: Forward-Migrate Off `/old`, Don't Repoint Tests/Redirects To It
**Date:** 2026-05-26 (Conv 201)

After ROUTE-FLIP (Conv 197) left the working flows under `/old/*` and Matt stubs at root with no redirect layer, treat `/old` as a **conversion source**, not a maintained target. Build the new root app incrementally: (1) wire the minimum to make the app usable (login/logout/home), (2) stub all main-nav items, (3) verify the minimal app, (4) convert `/old` pages → new root routes one at a time. Do NOT fix middleware/hrefs to point at `/old` or repoint the ~30 e2e specs to `/old`.

**Rationale:** `/old` is being dismantled, so stabilizing it (or its tests) is throwaway work. The e2e suite follows the new routes as they land. Rejected alternative: repoint redirects + 30 specs to `/old` (sunk cost in a layer slated for deletion).

**Consequences:** New ROUTE-MIGRATION PLAN block. [E2E-OLD] re-scoped to [E2E-MIG] (re-point e2e incrementally). Phase 1–3 + signup landed this conv (login/signup/onboarding/earnings/profile promoted to root; `AuthModalRenderer` mounted globally in `AppLayout`; logout button on `/profile`; post-login default `/dashboard`→`/`). [RTMIG-4] (convert `/old/*` one at a time) is the large ongoing phase. [E2E-GATE] tracks a structural-change tier + goto-target route resolver (prototype at `.scratch/e2e-route-map.mjs`).

---

### DISC-DROP: Catalog Card Composed from Matt Primitives (No Matt Browse-Card Source)
**Date:** 2026-05-27 (Conv 205)

Matt's design system has no catalog/browse card — every Matt course card (CourseEmbedCard, CourseAnchor, CourseInFeed) is a horizontal feed-embed ROW, and `matt-design-system.md` defines no courses-index layout. The `/courses` catalog grid therefore uses a new `CourseCatalogCard.tsx` composed from existing Matt primitives (MattIcon + IconLabelChip + tokens), with two layout variants: `stacked` (16:9 thumbnail on top, full detail below — used in the grid) and `overlay` (image backdrop + dark scrim, white trimmed text — used in the Popular Courses band). The card image source is `course.thumbnail_url`, reusing Matt's `CourseHeader` background-image + dark-gradient-scrim pattern (fallback `#1f2937`).

**Rationale:** No Figma source exists to match, and a feed-row card does not tile into a browse grid. Composing from primitives stays design-system-consistent without inventing a new tokenized surface (user chose option B: "Matt has no card grid yet").

**Consequences:** New UNMARKED (ours) component, not a Matt-provenance file. The leading course icon was dropped from the card — redundant in an all-courses context where the thumbnail is the identifier.

---

### DISC-DROP: Catalog Card is a Whole-Card Stretched-Link (No Per-Card CTA)
**Date:** 2026-05-27 (Conv 205)

`CourseCatalogCard` has no "View Course" button. The whole card is clickable via a single stretched-link: one real `<a>` on the title with `after:absolute after:inset-0`, plus hover/focus affordance (lift-shadow on stacked, white ring on overlay). This keeps exactly one anchor per card (accessible name = the title) and a large hit target.

**Rationale:** In a catalog the card *is* the navigation unit (unlike feed-embedded anchors, which carry their own CTA because the card hosts other content). An explicit per-card CTA repeated across a full grid is redundant.

**Consequences:** Single anchor per card, verified via `elementFromPoint` at card center. **Caveat:** the stretched-link pattern only stays a11y-clean while a card has ONE action — a future per-card secondary action (e.g. enrolled "Continue") cannot nest under the stretch and would force explicit buttons back for that variant.

---

### PRIM-STAMP: `data-prov` Runtime Stamp on Every Vetted Primitive; `data-matt` Retired Entirely
**Date:** 2026-05-29 (Conv 217)

Every vetted primitive's outermost rendered element now carries a `data-prov` runtime stamp (`matt-sourced` | `matt-inspired` | `legacy`), plus `data-prov-name` and (for matt-sourced) `data-prov-node`. All 59 vetted primitives (35 matt-sourced + 24 matt-inspired) stamped in W3. The unreferenced `data-matt` precursor attribute is fully retired from `src/` (root + child + AppLayout `brand-mark`), keeping only the distinct `data-matt-preview` in the dev showcase. Edge cases resolved to §12b "outermost rendered element": conditional-render branches stamp each branch root; composing wrappers (`PasswordInput`/`SearchInput`) forward an optional `data-prov` override that `Input` spreads onto its root div after its literal default; `UserIcon` roleDot wrapper `<span>` is stamped; `_SocialPostDemo` is wrapped in a stamped `<div>`.

**Rationale:** Page-level provenance markers (§11) say nothing about embedded-component vetted-ness; a DOM stamp makes `[data-prov="legacy"]` a one-line query for unvetted UI. Leaving any `data-matt` would create intra-file convention mixing — the exact unsynced-encoding problem §12 exists to kill. A composing primitive can't passively inherit root identity via `{...rest}` (Input spreads rest onto its inner `<input>`, not its root), so the override must be forwarded explicitly.

**Consequences:** Single clean provenance convention across `src/`. Enforced by a three-layer net: §12c conformity gate in `prov:sweep` (static, hard, asserts registry⟺marker⟺stamp, exits non-zero), tsc/astro-check/build (JSX correctness), and new `prov:page-report` DOM tool (jsdom; PROV_BASE/PROV_COOKIE; informational, always exits 0; generates a re-skin worklist). Documented in `matt-provenance.md §12b/§12c/§12d`.

---

### Tier-1/Tier-2 Page-Conversion Strategy (Compose-Obvious-Now / Extract-Later)
**Date:** 2026-05-30 (Conv 219)

Page conversion off `/old/*` splits into two tiers. **Tier-1 (do now):** Matt shell + SubNavbar + tokens + swaps to obvious *existing* vetted primitives + 404-honest routing. **Tier-2 (defer):** extract new primitives / extend existing ones, deferred to a Rule-of-Three consolidation pass driven by evidence. The `prim-treewalk` sensor + `.scratch` candidate reports are the deferral's memory. Related: a "pre-primitive" (composes vetted primitives but isn't itself registered, e.g. `ErrorRetryCard`) carries no `data-prov` stamp — its vetted children self-stamp; §12's enum has no slot for it and `legacy` would be a semantic lie. Astro `.astro` primitives (e.g. `Card`) cannot be composed by React pre-primitives, which must inline the Matt-tokenized chrome instead.

**Rationale:** Making every page conversion *also* a primitive-design exercise (guessing reuse from n=1) caused the conversion crawl. Tier-1/Tier-2 respects the Rule of Three, serves the converted-pages yardstick, and minimizes churn while keeping a safety net for deferred work.

**Consequences:** Pauses PROFILE-PRIM-SWEEP (reframed as Tier-2); `[RTMIG-TIER]` + `[PROFILE-TIER1]` tasks filed; PROFILE-TIER1 starts next conv. Folds a §12 pre-primitive note into `[PRIM-DOC]`. See Conv 219 Decisions.md §5–6, Learnings.md §2–3, §5.

---

### Leaderboard Discover-Destination Dropped (Not Ported to Root)
**Date:** 2026-06-01 (Conv 229)

The `/old/discover/leaderboard` destination will **not** be ported to a root Matt route. It was the lone remaining item under the DISC-DROP discover-destination migration umbrella (the other four — courses, communities, members, feeds — were ported Convs 204–228); with leaderboard dropped, the umbrella is **complete**. Leaderboard was already excluded from the Matt sidebar in Conv 221 (`[SBAR-DISC]`), so no root `/leaderboard` link exists — nothing dangles, no 404-honesty action needed.

**Rationale:** Product decision — the leaderboard surface is not part of the root experience (gamification was only ever "partially covered" in scope).

**Consequences:** The legacy `src/pages/old/discover/leaderboard.astro` page, `src/pages/api/leaderboard.ts` endpoint, and `src/components/leaderboard/Leaderboard.tsx` component **stay in place** under the durable /old-retention rule (no `/old` deletion until all-converted + client-vetted). DISC-DROP umbrella closed; `[RTMIG-4]` already excludes discover destinations, so no double-counting. See Conv 229.

---

### Precheckout Is an Addressable Route (`/course/[slug]/precheckout`) — Reverses Conv 187
**Date:** 2026-06-01 (Conv 232)

Matt's "enroll/purchase" frame (`558:15067`) is served as a real addressable route at `/course/[slug]/precheckout` — **reversing** the Conv 187 [MATT-EXEC-FLAGS] non-addressable classification. The standalone `precheckout.astro` route file sits beside the `[...tab].astro` catch-all; the shared body (`PrecheckoutContent.astro`, `@matt-source 558:15067`) is also hosted in-shell as a `/benefits` SubNav tab. Rejected: "Buy" SubNav-tab-only (Matt's frame is annotated "NOT a SubNav tab") and the Conv-187 overlay/state form.

**Rationale:** The Conv-232 deep-link audit found all three deep-link candidates still "No" (Stripe `cancel_url`→`/course/[slug]`, no enrollment-resume notification, abandoned-cart via `pl_pending_sessions` localStorage + success SSR self-heal). The classification flipped anyway because the *already-implemented* `CourseHeader` CTA was coded as an `<a href=".../checkout">` (a real link, then a 404-ing route), the frame is a full standalone view, and its Enroll-funnel siblings are addressable. The strict addressability test was a Conv-187 tiebreaker for a page *presumed transient*; once the page was built as a real destination with a real inbound link, that tiebreaker no longer governed.

**Consequences:** `CourseHeader` CTA repointed `/checkout`→`/precheckout`; MFRD addressability table row 9 reversed to addressable; `route-map.generated.ts` regenerated (both repos). The `/benefits` tab is a Peerloop addition diverging from Matt's "not a SubNav tab" note — to be run past Matt ([PRECHECKOUT-MATT-CONFIRM] #35). See Conv 232.

---

### Success Page Ported to Matt-Source, Phased; Downstream Links 404-Honest
**Date:** 2026-06-01 (Conv 233)

The post-checkout success page is ported to a new Matt-source route `src/pages/course/[slug]/success.astro` (`@matt-source 579:16885`), **replacing** the missing root route that — after route-flip — only existed under `/old/...` and was 302-bounced by `[...tab].astro` (`success` ∉ `VALID_TABS`), so buyers never saw confirmation and the SSR self-heal never ran. Ported **phased (option B)**: Phase 1 ships the congrats card, the "Schedule your first session" card (bound to real `course_curriculum` first-module data), the `CourseHeader` Enrolled hero, and preserves legacy self-heal + ExpectationsForm behavior; the community-milestone composer is deferred to Phase 2 ([SUCCESS-COMMUNITY] #38). Downstream link "Schedule Session 1" points at the real root `/course/[slug]/book` and 404s honestly until that page is ported — no `/old` fallback, no resolving stub.

**Rationale:** Legacy is not more suitable than Matt's redesign here, so port-then-Matt-source rather than rehost. Phasing closes the payment-flow break fast while keeping the heaviest reuse piece (the composer) on its own. The 404-honest downstream link follows the established one-page-at-a-time migration principle (no redirect layer, no placeholder stubs).

**Consequences:** New `success.astro`; `CourseHeader` gains `variant="enrolled"` + `headerHref`; 2 new MattIcons (`verified`, `av-timer`; registry 54→56); `route-map.generated.ts` regenerated (both repos); MFRD row 10 (Enroll Success) marked IMPLEMENTED Phase 1; #38 spawned for Phase 2. See Conv 233.

---


### Booking Route — Tactical `@stand-in` Rehost Now, Matt Retrofit Parked
**Date:** 2026-06-01 (Conv 234)

The root booking route `src/pages/course/[slug]/book.astro` is built as an `@stand-in` rehost — legacy server logic (auth/enrollment guards, teacher+eligibility queries) verbatim onto the Matt `AppLayout` shell, rendering the **untouched** legacy `SessionBooking.tsx` wizard. The full Matt restyle is parked under [ENROLL-NAV]. Rejected: a wrapper + Matt teacher-select restyle, and a full Matt wizard port (multi-conv).

**Rationale:** Matt has no course-hosted booking design (his date-picker `622:15671` is the creator-side "Work with [teacher]" profile tab, not Ready-for-Dev); a full restyle overlaps the PENDING CALENDAR block and is multi-conv. The rehost makes the enroll→success→book funnel walk end-to-end this conv — closing the Conv-233 404 — without throwing away work CALENDAR/ENROLL-NAV will redo. Per §Solution-Quality multi-conv carve-out.

**Consequences:** New `@stand-in` page (reintroduces 1 after STANDIN-MATT hit 0); booking wizard stays legacy-styled until ENROLL-NAV. The page also gets the course SubNav rail (see next entry). See Conv 234.

---

### ENROLL-NAV — Dual-Zone Course SubNav (BUILT) + "My Sessions" Explore Tab + Rail Persistence
**Date:** 2026-06-01 (Conv 235)

The dual-zone course SubNav spec'd in Conv 234 is now **BUILT** (`SubNav.astro` backward-compatible dual-zone with `zone`/`done`/`disabled` optional item fields; `loaders/courses.ts` `computeCourseJourney()` state machine from `getBookingEligibility`, enrolled-only; `_course-tabs.ts` zoned state-aware `buildCourseTabs(slug, journey)`). Refinements made during the build:

- **"My Sessions" Explore tab (new), outside the state machine.** Matt's "1:1 Sessions" label = the curriculum frame = the *existing* Modules tab. The genuinely-dropped surface is the student's personal meeting *schedule* (legacy Sessions tab) — built as a new `@matt-inspired` `MySessionsTab.astro` (SSR port of legacy `SessionsTabContent`: progress + book CTA + 5 status buckets + recordings) in the **Explore** zone, OUTSIDE the gated Journey. Rationale: Modules answers "what does the course teach", My Sessions answers "what meetings do I have / when". Resolves the spec's §Naming watch-item.
- **Rail persists across the whole funnel.** `/success` (all viewers) and `/session/[id]` (student viewer only) now carry the course rail, diverging from Matt's rail-less `579:16885` success frame — a Journey that drops its own nav mid-funnel is jarring. Session rail is student-only because the Journey is the student's funnel.

**Rationale:** The Matt rewrite silently dropped the legacy enrolled-operational tabs; ENROLL-NAV re-homes them. Dual-zone matches the user's browse-vs-directed framing, grounded in the legacy `CourseTabs` inventory. Built whole in one conv so one conversation informs the entire state machine + rail.

**Consequences:** 6 files (SubNav, courses loader, `[...tab]`, `_course-tabs`, book, success) + new `MySessionsTab.astro`; 5 gates green (6460 tests) + browser-verified as David. New Matt divergences (dual-zone IA, rail on success/session) folded into [ENROLL-NAV-MATT-CONFIRM] #38. Open: mobile (<1024px) zone-divider rendering in the horizontal-scroll strip. See Conv 235.

---

### Root `/session/[id]` — `@stand-in` Rehost (closes Prepare/Join 404)
**Date:** 2026-06-01 (Conv 235)

Created `src/pages/session/[id].astro` as a `@stand-in` — legacy `/old/session/[id]` server logic verbatim onto the Matt shell, `SessionRoom` island untouched. Rejected: pointing session links at `/old/session/[id]` (mixes /old into Matt pages), and disabling Prepare/Join. Follows the Conv-234 `/book` `@stand-in` precedent.

**Rationale:** Default-durable; the root session route did not exist post route-flip, so Prepare/Join 404'd. The rehost also fixes the SAME latent 404 in already-shipped Matt components (MyStudents, SessionHistory, StudentDashboard). Full Matt retrofit deferred to the Session family [MATT-EXEC-PG2] #9.

**See:** `docs/decisions/11-new-routing.md`; Conv 235.

---

### COMM-DETAIL — `/community/[slug]` Detail Family (Triad Decompose, About Default, Commons Pinned)
**Date:** 2026-06-03 (Conv 237)

Ported `/old/community/[slug]/*` to a root `/community/[slug]` detail family, mirroring `/course/[slug]`. Three locked decisions:

- **Approach C — full decompose** of the legacy 628-line `CommunityTabs` island into per-URL server/island tabs (rejected A: SubNav rail + reuse island whole; B: shell-wrap keeping the island's own tab bar). Standardizes the `[...tab].astro` + `_*-tabs.ts` + `SubNav` triad across a **3rd** page family (course / profile / community). `/profile` (`@matt-inspired`, no Figma source) de-risks the decompose.
- **Empty segment = NEW About/Overview default** (rejected: bare URL = Feed, faithful to legacy). `/community/[slug]` = About overview (description, stats, host, learning-paths from schema); Feed moves to `/community/[slug]/feed`. Canonical feed URL changes.
- **The Commons pinned on /communities** as a distinct card (cover image + link) above the joinable grid, not mixed into it (rejected: drop the filter / leave as-is). Everyone is auto-joined so it isn't a "join" candidate but IS a real destination; mirrors how `FeedsHubPanel` already treats it. Fulfills previously-404 home/feed links.

**Rationale:** User wanted the SubNav-triad standardization payoff; an About overview is valuable and schema-backed; The Commons needs a reachable destination. SubNav holds **destinations only** — Manage/Leave actions → header, `?tag=` filters → tab body, back-nav → breadcrumb.

**Consequences:** New `community/[slug]/[...tab].astro` + `_community-tabs.ts` (flat single-zone, `isSystem` drops Courses); 2 new client islands (`CommunityMembersTab`, `CommunityResourcesTab`) extracted from `CommunityTabs`; `bio` (`u.bio_short`) threaded through `fetchCommunityDetailData` (no schema change); `communities.astro` extracts `theCommons`. Decorative `?tag=` chips + dead Leave button dropped → [COMM-TAG-FILTER]. `/feed/[slug]` will be the 4th triad family. 5 gates green (6460/6460), browser-verified. See Conv 237.

**See:** `docs/decisions/11-new-routing.md`; Conv 237.

---

### FEED-DETAIL — Single-Page `/feed` Port (Not a [...tab] Family)
**Date:** 2026-06-03 (Conv 238)

The [FEED-DETAIL] task was written as "port `/old/feed/*` → `/feed/[slug]`, a 4th [...tab] family" — but legacy `/feed` is a single 40-line SmartFeed page (`/old/feed.astro`); no `/feed/[slug]` exists or is linked, while ~7 components link to bare `/feed` (which 404'd). Re-scoped to a **single-page `@matt-inspired` port**: new `src/pages/feed.astro` (AppLayout + SectionTitle + breadcrumb + OnboardingNudgeBanner) mounting the existing prop-less `SmartFeed` island, `max-w-2xl`, `noNav`, getSession redirect atop the existing PROTECTED_EXACT guard. Rejected: a `/feed/[slug]` multi-tab family (the task's literal wording) and a from-scratch new design.

**Rationale:** Matches legacy reality and fixes the ~7 dead `/feed` links. The triad ([...tab].astro + _*-tabs.ts + SubNav) pattern is for multi-tab entity-detail; a personal smart feed is not that. Establishes a new pattern — single-page `@matt-inspired` legacy port (Matt shell + carried-forward island), distinct from the triad.

**Consequences:** New `src/pages/feed.astro`; ~7 links + middleware guard now resolve. Discovery CTAs repointed to root (`discover.ts:222/250`, `enrichment.ts:179/180`: `/discover/{community,course}/` → `/community,/course`); DiscoverSlidePanel Feeds→/feeds, Courses→/courses fixed. 5 gates green (6460/6460), browser + curl verified. See Conv 238.

**See:** `docs/decisions/11-new-routing.md`; Conv 238.
