# Session Learnings - 2026-02-04

## 1. Tech Docs Can Drift from Actual Decisions
**Topics:** workflow, documentation

**Context:** Compared tech-021-url-routing.md (Session 169) with the actual codebase and found discrepancies. Initially thought the code was wrong.

**Learning:** Later decisions in DECISIONS.md (Sessions 175, 177) had superseded the original tech doc. The codebase was actually CORRECT per the authoritative decisions. Tech docs can become stale — DECISIONS.md is the source of truth.

**Pattern:** When finding discrepancies between tech docs and code:
1. Check DECISIONS.md for later decisions on the same topic
2. Check the decision dates — newer wins
3. Update the tech doc to reflect current decisions, not vice versa

---

## 2. Astro File Structure: Flat vs Folder Pattern
**Topics:** astro, routing

**Context:** Found inconsistent patterns in `src/pages/` — some routes used `route/index.astro` (folder) while others used `route.astro` (flat).

**Learning:** Both patterns produce identical routes in Astro. The choice is organizational:

| Pattern | Use When |
|---------|----------|
| `route.astro` (flat) | Leaf routes with no sub-routes |
| `route/index.astro` (folder) | Routes that have/will have sibling files or sub-routes |

**Pattern:** For `/discover/courses`:
- Flat: `discover/courses.astro` ✓ (no sub-routes needed)
- Folder: `discover/courses/index.astro` ✗ (unnecessary nesting)

Exception: Dynamic params like `[slug]` still need folders if they have sub-routes (`course/[slug]/learn.astro`).

---

## 3. Stream.io v2 Cannot Filter by Custom Fields Server-Side
**Topics:** stream

**Context:** Investigating how to implement "show only posts about Topic X" in the TownHall feed.

**Learning:** Stream.io Activity Feeds v2 does not support filtering activities by custom fields (like `courseId` or `topic`) on the server. You can only:
- Get all activities from a feed (with pagination)
- Filter client-side (doesn't scale for mobile)
- Use separate feeds per filterable category

**Pattern:** For filterable content, create dedicated feeds:
```
townhall:main       → All posts
course:python-101   → Python 101 posts only
announcements:main  → Official announcements only
```

---

## 4. Stream Ranked Feeds Cannot Combine with Date Filtering
**Topics:** stream

**Context:** Investigating how to implement "top posts since yesterday" (ranked + time filtered).

**Learning:** Critical limitation — when using ranked feeds (custom scoring), you can only use `limit` and `offset` for pagination. The `id_lt` and `id_gt` parameters (for date filtering) are not supported with ranked feeds.

| Feed Type | `limit`/`offset` | `id_lt`/`id_gt` |
|-----------|------------------|-----------------|
| Chronological | ✅ | ✅ |
| Ranked | ✅ | ❌ |

**Workarounds:**
1. Aggressive time decay in ranking formula (soft filter)
2. Two-phase query: chronological with `id_gt`, then sort client-side
3. D1 hybrid: SQL for date filtering, Stream for content

---

## 5. Stream Pricing: No Per-Feed Cost
**Topics:** stream

**Context:** Concerned that creating separate feeds for each course/topic would be expensive.

**Learning:** Stream charges based on:
- API calls (read/write operations)
- Activities (total stored)

There is NO per-feed or per-feed-group charge. Having 100 separate `course:{id}` feeds costs the same as 1 feed, assuming the same total activity volume.

---

## 6. Slide-Out Panels Preserve URL State (Peek Before Commit)
**Topics:** astro, ui-ux

**Context:** Discussing whether `/discover` page is needed when DiscoverSlidePanel exists.

**Learning:** The DiscoverSlidePanel opens without changing the URL. This is a "peek before commit" UX pattern — users can browse options without losing their current page context. If they close the panel, they're right back where they started.

**Implication:** The slide panel is a navigation overlay, not a destination. A `/discover` page serves different purposes (SEO, direct URL access).

---

## 7. SEO Implications of Missing Parent Routes
**Topics:** astro, seo

**Context:** Discussing whether `/discover` route is needed when `/discover/*` sub-routes exist.

**Learning:** Missing parent routes cause SEO and UX issues:

| Issue | Impact |
|-------|--------|
| Crawlers see broken hierarchy | `/discover/courses` exists but `/discover` is 404 |
| URL truncation fails | Users edit URL to parent, get error |
| Breadcrumb dead links | "Home > Discover > Courses" with dead "Discover" link |
| No link equity aggregation | Can't pass authority to children |

**Solution:** Even if a page's navigation is primarily via slide panel, create a minimal hub page for SEO and direct URL access.

---

## 8. Stream External Parameters for Personalized Feeds
**Topics:** stream

**Context:** Investigating how to implement per-user feed personalization.

**Learning:** Stream supports `external` parameters in ranking formulas that can be passed at query time:

```typescript
// Ranking formula uses external.w_* weights
// "score": "decay_linear(time) * (external.w_announcements * is_announcement + ...)"

// Query with user preferences
const response = await feed.get({
  limit: 25,
  ranking_vars: {
    w_announcements: 10,  // This user wants announcements
    w_courses: 5,
  }
});
```

Same feed, different ordering per user — without creating user-specific feeds.
