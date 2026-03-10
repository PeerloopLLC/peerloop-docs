# STORY-GAP-ANALYSIS.md

**Purpose:** Categorize user stories not served by current routes
**Created:** Session 306 (2026-02-27)
**Companion to:** [ROUTE-STORIES.md](../architecture/route-stories.md) (canonical mapping)

---

## Summary

| Category | Stories | Priority Breakdown |
|----------|---------|-------------------|
| On-hold: Goodwill Points | 23 | P2: 23 |
| On-hold: Course Chat | 2 | P2: 2 |
| On-hold: Sub-Community | 2 | P3: 2 |
| On-hold: Feed Promotion | 2 | P3: 2 |
| On-hold: Creator Newsletters | 1 | P3: 1 |
| New route needed | 1 | P2: 1 |
| Employer role (no route, no gap) | 0 | — |
| **Total unserved** | **31** | P2: 26, P3: 5 |

**Key finding:** No P0 or P1 stories are unserved. All 31 unserved stories are P2 (deferred) or P3 (future). The current route architecture covers 100% of MVP-critical functionality.

---

## 1. On-Hold: Goodwill Points System (23 stories, all P2)

**Status:** Deferred to Block 2+
**Dependency:** Requires gamification tables, point tracking infrastructure, "Summon Help" UX
**On-hold pages:** HELP (Summon Help), LEAD (Leaderboard — route exists but stories are goodwill-dependent)

The goodwill system is the largest single cluster of unserved stories. It spans 3 roles (Student, Teacher, Platform) and would affect approximately 8 routes if implemented.

### Student Goodwill Stories

| Story | Description | Priority |
|-------|-------------|----------|
| US-S030 | Earn goodwill points through participation | P2 |
| US-S031 | See power user level/tier | P2 |
| US-S062 | Summon help from certified peers when stuck | P2 |
| US-S063 | See how many helpers are available on course page | P2 |
| US-S064 | Award goodwill points (10-25 slider) to helpers | P2 |
| US-S066 | Award "This Helped" points (5) to chat answers | P2 |
| US-S067 | See goodwill balance and history (private view) | P2 |
| US-S068 | See total earned goodwill on public profile | P2 |

### Teacher Goodwill Stories

| Story | Description | Priority |
|-------|-------------|----------|
| US-T015 | Earn points for teaching activity | P2 |
| US-T024 | Toggle "Available to Help" status | P2 |
| US-T025 | Receive notifications for summon requests | P2 |
| US-T026 | Respond to summon requests, join chat/video | P2 |
| US-T027 | Earn goodwill points (10-25) for Summon help | P2 |
| US-T028 | Earn goodwill points (5) for chat answers | P2 |
| US-T029 | Earn availability bonus points (5/day) | P2 |

### Platform Goodwill Infrastructure

| Story | Description | Priority |
|-------|-------------|----------|
| US-P051 | Track goodwill points for user actions | P2 |
| US-P052 | Calculate power user tiers based on points | P2 |
| US-P058 | Track Teacher points for activity | P2 |
| US-P077 | Track goodwill point transactions | P2 |
| US-P078 | Enforce anti-gaming rules (daily caps, cooldowns) | P2 |
| US-P079 | Auto-award points for certain actions | P2 |
| US-P080 | Display available helpers count per course | P2 |
| US-P081 | Track summon help requests | P2 |

### Implementation Notes

When goodwill is implemented, these stories would need:
- New DB tables: `goodwill_points`, `goodwill_transactions`, `summon_requests`
- New routes: possibly `/help` (summon help), or integrated into existing routes
- Updates to: `/@[handle]` (display points), `/course/[slug]` (helper count), `/teaching` (availability toggle)
- `/discover/leaderboard` stories (US-P053, US-P082) become active

---

## 2. On-Hold: Course Chat (2 stories, all P2)

**Status:** Deferred. Real-time chat superseded by community feeds (Stream.io).
**On-hold page:** CHAT (`/courses/:slug/chat`)
**Alternative:** Course discussions now served by `/course/[slug]/feed`

| Story | Description | Priority |
|-------|-------------|----------|
| US-S065 | Mark messages as questions in course chat | P2 |
| US-M004 | Add users to closed/private chats (Moderator) | P2 |

### Implementation Notes

If real-time course chat is added later, it would likely use Cloudflare Durable Objects (per tech decisions). The community feed covers async discussion; chat would serve real-time collaboration during sessions.

---

## 3. On-Hold: Sub-Community (2 stories, all P3)

**Status:** Future feature. User-created sub-communities with invite functionality.
**On-hold page:** SUBCOM (`/groups/[id]`)

| Story | Description | Priority |
|-------|-------------|----------|
| US-S081 | Create sub-community and invite specific users | P3 |
| US-P097 | Support user-created sub-communities with invite | P3 |

### Implementation Notes

Sub-communities are study groups or interest clusters created by users (not creators). This differs from creator-managed communities (`/creating/communities`) which already exist. Would need a new route (e.g., `/groups/[id]` or `/community/[slug]` with a `type: user-created` flag).

---

## 4. On-Hold: Feed Promotion (2 stories, all P3)

**Status:** Deferred. Depends on goodwill points system.

| Story | Description | Priority |
|-------|-------------|----------|
| US-S071 | Spend goodwill points to promote post to main feed | P3 |
| US-P085 | Process feed promotion requests (backend) | P3 |

### Implementation Notes

This is a goodwill-dependent feature. Would integrate into existing feed routes (`/community/[slug]`, `/feed`) rather than requiring new routes.

---

## 5. On-Hold: Creator Newsletters (1 story, P3)

**Status:** Future feature.
**On-hold page:** CNEW (`/dashboard/creator/newsletters`)

| Story | Description | Priority |
|-------|-------------|----------|
| US-C026 | Publish newsletters (potentially with subscription payments) | P3 |

### Implementation Notes

Would need new route under `/creating/newsletters` or similar. Low priority — creators currently use community feeds for announcements.

---

## 6. New Route Needed (1 story, P2)

| Story | Description | Priority | Suggested Route |
|-------|-------------|----------|-----------------|
| US-P099 | Changelog page for feature announcements | P2 | `/changelog` |

### Implementation Notes

Simple static/dynamic page. Could be implemented as a marketing page or an admin-managed content page.

---

## 7. Employer Role — No Route Gap

The Employer/Funder role (US-E001 through US-E006) has 6 stories, all served by existing routes:

| Story | Served By | Priority |
|-------|-----------|----------|
| US-E001 | `/course/[slug]` (employer checkout) | P1 |
| US-E002 | Cross-cutting notifications | P1 |
| US-E003 | Cross-cutting notifications | P1 |
| US-E004 | `/settings/profile` | P1 |
| US-E005 | `/messages` | P1 |
| US-E006 | `/messages` | P2 |

No dedicated employer dashboard is needed for MVP. If employer usage grows, a `/sponsoring` or `/funding` activity namespace could be added.

---

## Route Coverage Matrix

### Routes with Many Stories (>10)

| Route | Stories | Notes |
|-------|---------|-------|
| `/course/[slug]` | 15 | Highest story density — course detail is the key conversion page |
| `/community/[slug]` | 17 | Includes feed interactions shared across feed contexts |
| `/creating` | 13 | Creator dashboard with approval workflows |
| `/creating/studio` | 17 | Course builder is a complex tool |
| `/session/[id]` | 15 | Video session room with many capabilities |
| `/learning` | 15 | Student dashboard hub |
| `/messages` | 13 | Multi-role messaging |
| `/admin/analytics` | 10 | Platform metrics |
| `/course/[slug]/learn` | 11 | Course content viewer with homework |
| `/course/[slug]/book` | 10 | Session booking |

### Routes with Zero Stories

| Route | Status | Notes |
|-------|--------|-------|
| `/about` | OK | Marketing page, no dedicated story |
| `/how-it-works` | OK | Marketing page, implied by US-G002 |
| `/faq` | OK | Marketing page |
| `/for-creators` | OK | Marketing landing page |
| `/become-a-teacher` | OK | Marketing landing page |
| `/contact` | OK | Marketing page |
| `/privacy` | OK | Legal page |
| `/terms` | OK | Legal page |
| `/testimonials` | OK | Marketing page, shared with /stories |
| `/welcome` | OK | Post-signup page, not yet implemented |
| `/creating/apply` | OK | New route, no old page code |
| `/discover/students` | OK | New route |
| `/discover/communities` | OK | New route, implied by architecture |
| `/courses` | OK | List view; stories on /learning |
| `/profile` | OK | Redirect to /@[handle] |
| `/settings` | OK | Hub page, no functionality |
| `/settings/security` | OK | Implied by auth infrastructure |
| `/admin/teachers` | OK | Covered by other admin routes |
| `/admin/moderation` | OK | Shared with /mod |
| `/course/[slug]/success` | OK | Confirmation page |
| `/verify/[id]` | OK | Implied by certification system |
| `/teaching/analytics` | OK | Implied by dashboard metrics |

All zero-story routes are either marketing/legal pages, hub/redirect pages, or new routes whose functionality is implied by broader stories. **No route is genuinely unserved.**

---

## Conclusions

1. **No MVP gaps.** All 184 P0 stories and all 125 P1 stories are mapped to current routes or cross-cutting infrastructure.
2. **Goodwill is the biggest deferred cluster** — 23 stories waiting for a single feature system.
3. **Only 1 genuinely new route needed** — `/changelog` (P2).
4. **The Twitter-like UI pivot increased route count** but successfully absorbed all stories from the old page system.
5. **Employer role works without dedicated routes** — 6 stories all served by existing pages.

---

## References

- [ROUTE-STORIES.md](../architecture/route-stories.md) — Canonical route→story mapping
- [USER-STORIES-MAP.md](../../research/user-stories-map.md) — All 402 stories
- [url-routing.md](../architecture/url-routing.md) — Route architecture
- [docs/reference/OLD-CODE-TO-NEW-ROUTE.md](OLD-CODE-TO-NEW-ROUTE.md) — Translation table
