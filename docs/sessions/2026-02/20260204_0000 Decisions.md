# Session Decisions - 2026-02-04

## 1. Update tech-021-url-routing.md to Align with DECISIONS.md
**Type:** Implementation
**Topics:** documentation, routing

**Trigger:** Found discrepancies between tech-021-url-routing.md and actual codebase. Investigation revealed later decisions in DECISIONS.md (Sessions 175, 177) that superseded the original tech doc.

**Options Considered:**
1. Update code to match tech doc
2. Update tech doc to match code and DECISIONS.md ← Chosen
3. Leave both as-is

**Decision:** Update tech-021-url-routing.md to reflect the later decisions from Sessions 173, 175, 177. Add "Last Updated" date and references to all relevant sessions.

**Rationale:** DECISIONS.md is the source of truth. The codebase correctly implements the later decisions (singular resources, activity vs resource namespaces). The tech doc was simply out of date.

**Consequences:** tech-021-url-routing.md now documents singular resource convention, activity vs resource namespaces, and actual file structure.

---

## 2. Use Flat File Pattern for Astro Pages Unless Sub-Routes Needed
**Type:** Implementation
**Topics:** astro, routing, conventions

**Trigger:** Inconsistent file patterns found — some routes used `route/index.astro`, others used `route.astro`.

**Options Considered:**
1. Always use folder pattern (`route/index.astro`) for consistency
2. Always use flat pattern (`route.astro`) unless sub-routes needed ← Chosen
3. Mixed approach based on preference

**Decision:** Use flat files (`route.astro`) by default. Only use folders (`route/index.astro`) when:
- Route has dynamic params with sub-routes (e.g., `course/[slug]/learn.astro`)
- Route is a hub with sibling files (e.g., `settings/index.astro` with `settings/profile.astro`)

**Rationale:** Flat files are easier to scan in file explorer, reduce nesting, and make the file tree mirror the URL tree more directly.

**Consequences:** Flattened 8 routes:
- `course/[slug]/learn/index.astro` → `learn.astro`
- `discover/*/index.astro` → `discover/*.astro` (5 files)
- `learning/index.astro` → `learning.astro`
- `creating/studio/index.astro` → `studio.astro`

---

## 3. Create /discover Hub Page for SEO and Direct Navigation
**Type:** Implementation
**Topics:** astro, seo, routing

**Trigger:** `/discover/*` routes exist but `/discover` returns 404. Question raised about whether hub page is needed given DiscoverSlidePanel.

**Options Considered:**
1. No `/discover` page — panel is the hub ← Rejected (SEO issues)
2. `/discover` redirects to `/discover/courses`
3. Minimal hub page with section links ← Chosen
4. Search-first page with unique content

**Decision:** Create `/discover/index.astro` as a minimal hub page with:
- Unique SEO-friendly heading and descriptions
- Search input (UI only, functionality later)
- Section cards linking to sub-routes
- "Coming soon" teaser for `/discover/community`

**Rationale:** The page serves different purposes than the panel:
- SEO: Indexable hub with descriptive content
- Direct navigation: Users typing `/discover` get a useful page
- Breadcrumbs: "Discover" link works

**Consequences:** Created `src/pages/discover/index.astro` with 5 section cards and search UI.

---

## 4. Stream Architecture: Separate Feeds for Filterable Categories
**Type:** Strategic
**Topics:** stream, architecture

**Trigger:** Investigating how to implement "show only posts about Topic X" for mobile users.

**Options Considered:**
1. Single townhall + client-side filtering ← Rejected (doesn't scale)
2. Separate feeds per filterable category ← Chosen
3. D1 hybrid (SQL filter + Stream content)
4. Wait for Stream v3 with server-side filtering

**Decision:** Use separate Stream feeds for each filterable category rather than client-side filtering. For example:
- `townhall:main` for all community posts
- `course:{id}` for course-specific posts
- `announcements:main` for official announcements

**Rationale:**
- Client-side filtering requires downloading all posts to filter locally — unacceptable on mobile
- Stream pricing is per-API-call, not per-feed — no cost increase
- Separate feeds enable proper pagination (page 2 of "course X" works correctly)

**Consequences:** Added FEEDS block to PLAN.md to explore architecture options with client.

---

## 5. Add FEEDS Block to PLAN.md for Architecture Exploration
**Type:** Strategic
**Topics:** stream, planning

**Trigger:** Multiple architectural decisions needed for Stream feed implementation — requires client input.

**Options Considered:**
1. Make architecture decisions now
2. Add planning block for exploration with client ← Chosen
3. Defer feeds entirely

**Decision:** Add FEEDS block to PLAN.md (priority 3) with sections for:
- `FEEDS.ARCHITECTURE` — Options A-E for feed structure
- `FEEDS.RANKING` — Algorithmic feed configuration
- `FEEDS.LIMITATIONS` — Stream v2 constraints and workarounds
- `FEEDS.IMPLEMENTATION` — Tasks after decisions made
- `FEEDS.OPEN_QUESTIONS` — Items needing client input

**Rationale:** The feed architecture has multiple valid options with different trade-offs. Client input needed on:
- Whether to use paid tier for ranked feeds
- Whether per-course filtering is required
- Whether user personalization is wanted

**Consequences:** PLAN.md updated with new block. Tech doc updated with ranked feeds section.
