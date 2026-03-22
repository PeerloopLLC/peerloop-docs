# Session Decisions - 2026-02-17

## 1. Breadcrumb Placement: Above Page Title, Inside MainPanel
**Type:** Implementation
**Topics:** astro, ui-architecture

**Trigger:** Designing the breadcrumb system — should breadcrumbs be part of the layout (above the main panel) or rendered by each page?

**Options Considered:**
1. In the layout, above the main content panel (like LegacyAppLayout's border-b bar)
2. Inside the page content, above the `<h1>` title ← Chosen
3. Inside the page content, below the `<h1>` title (existing hand-coded pattern)

**Decision:** Breadcrumbs are rendered by each page inside the main content area, positioned above the page heading.

**Rationale:** Top-level pages don't need breadcrumbs, so putting them in the layout would require conditional rendering or awkward empty space. The sidebar already provides global navigation context. Each page knows its own position in the hierarchy and can decide whether to include breadcrumbs. The existing hand-coded breadcrumbs were below the heading but conventional placement (GitHub, AWS, Shopify) puts them above.

**Consequences:** Created `Breadcrumbs.astro` component. Each page imports and renders it with its own `items` array. Top-level pages (`/learning`, `/courses`, `/messages`) have no breadcrumbs.

---

## 2. Navigation Context: Hybrid Route-Based + `?via=` Query Param
**Type:** Strategic
**Topics:** astro, ui-architecture

**Trigger:** How should breadcrumbs reflect the user's navigation path? A user arriving at `/community/ai-tools` from Discover vs from My Communities should see different trails.

**Options Considered:**
1. Route-based only (static hierarchy, same trail regardless of how user arrived)
2. History-based (track actual click path in sessionStorage)
3. Hybrid: route-based defaults + `?via=` query param for context ← Chosen

**Decision:** Use route-based breadcrumbs as defaults, with optional `?via=` query parameters to provide navigation-context-aware trails.

**Rationale:** Route-based is simple and works for most cases. `?via=` adds context-awareness without hidden state — it survives refresh, works with bookmarks/shared URLs, requires no client-side JS, and is debuggable. sessionStorage would break across tabs and create invisible state. The `?via=` approach is consistent with existing patterns (`?redirect=`, `?returnUrl=`).

**Consequences:** Linking pages add `?via=` to outbound hrefs (e.g., discover/communities adds `?via=discover-communities` to community card links). Receiving pages read the param and build conditional breadcrumb items. Direct URL access gets the default route-based trail.

---

## 3. Via Display: Clean Trail Replacement (Approach A) Over Annotation
**Type:** Implementation
**Topics:** ui-architecture

**Trigger:** When `?via=` is present, should we show the via-based trail only, or show both the default trail AND a "via" annotation?

**Options Considered:**
1. Clean replacement — `?via=` changes the entire trail ← Chosen
2. Annotation — show default trail plus small "via Discover" note alongside

**Decision:** The `?via=` parameter replaces the breadcrumb trail entirely. No dual display.

**Rationale:** Breadcrumbs answer "where am I?" — one clear trail is better than two competing ones. The annotation approach would add visual noise for marginal benefit. The user agreed that showing the full URL segment chain wasn't worth the clutter.

**Consequences:** Simple `if/else` logic in pages. Each `via` value maps to a complete breadcrumb trail. Easy to extend with new via values later.

---

## 4. Community Context in Course Links: Query Params Over DB Lookup
**Type:** Implementation
**Topics:** astro, d1

**Trigger:** When navigating from `/community/ai-tools/courses` to a course, the breadcrumb needs the community name and slug. How to pass this data?

**Options Considered:**
1. Pass community slug only, look up name via DB query on course page
2. Pass both slug and name as query params (`?cs=ai-tools&cn=AI+Tools+%26+Strategy`) ← Chosen

**Decision:** Encode both community slug (`cs`) and community name (`cn`) in the URL query parameters.

**Rationale:** The linking component (`CommunityTabs`) already has both values as props. Passing them avoids an extra DB round-trip on the receiving page. URL encoding handles special characters. The slug serves as fallback if the name param is ever missing.

**Consequences:** Course page URLs from community context are longer but fully self-contained. No additional database queries needed. `CommunityTabs.tsx` builds the URL with `encodeURIComponent(communityName)`.
