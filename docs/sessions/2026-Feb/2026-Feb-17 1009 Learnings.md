# Session Learnings - 2026-02-17

## 1. API Count vs Display Count Mismatch from Multi-Layer Filtering
**Topics:** astro, d1

**Context:** The `/discover/communities` page showed "4 available to join" but only rendered 3 community cards.

**Learning:** When filtering happens at multiple layers (SQL query returns count, then page filters items client-side), the count and displayed items can diverge. The API counted all public communities including system ones (`is_system=1`), but the page filtered them out of the rendered list while using the raw API total for the label.

**Pattern:** Fix at both layers for defense in depth: add `AND c.is_system = 0` to the SQL WHERE clause (correct the source), and derive the label count from `communities.length` instead of `data.total` (safety net at display layer).

---

## 2. Breadcrumbs Belong Inside Page Content, Not in Layout
**Topics:** astro, ui-architecture

**Context:** Designing where to place breadcrumbs in the AppLayout — above the main panel (in the layout) vs inside it (per-page).

**Learning:** Breadcrumbs are page-specific context, not global chrome. Placing them inside the page content (above the `<h1>`) keeps them optional — top-level pages like `/learning` or `/courses` don't need them and avoid awkward empty space. The sidebar already provides global navigation context via active-item highlighting. The LegacyAppLayout had breadcrumbs in the layout via a prop, but the new approach of each page rendering its own `<Breadcrumbs>` component gives more control.

---

## 3. Query Params Beat sessionStorage for Navigation Context
**Topics:** astro, ui-architecture

**Context:** Deciding how to track where a user came from when they navigate to a detail page (e.g., arriving at `/community/ai-tools` from Discover vs from My Communities).

**Learning:** URL query params (`?via=discover-communities`) are superior to sessionStorage for breadcrumb context because they: survive page refresh, work when sharing/bookmarking URLs, require zero client-side JavaScript, are visible and debuggable, and align with the web's stateless URL model. sessionStorage creates invisible state that breaks across tabs and can't be shared. This matches the codebase's existing patterns (`?redirect=`, `?returnUrl=`).

---

## 4. Passing Display Data Through Query Params vs DB Lookups
**Topics:** astro, d1

**Context:** When navigating from a community's courses tab to a course detail page, the breadcrumb needs the community name. Two options: pass it as a query param or look it up from DB on the receiving page.

**Learning:** When the linking page already has the display data (e.g., `communityName`), encoding it in the URL (`?cn=AI+Tools+%26+Strategy`) avoids an extra database round-trip on the receiving page. URL encoding handles special characters. Use the slug as a fallback (`communityName || communitySlug`) in case the name param is missing. Short params (`cs`, `cn`) keep URLs manageable.

---

## 5. Making Shared Components Context-Aware with Optional Props
**Topics:** astro, ui-architecture

**Context:** `CourseCard.tsx` is used from multiple contexts (Discover, Community courses tab, Homepage). Course links needed `?via=` params that differ by context.

**Learning:** Adding an optional `via` prop to shared components keeps them backward-compatible while enabling context-awareness. Callers that care about navigation context pass `via="discover-courses"`, others don't pass it and get clean URLs. The component builds the URL conditionally: `` `/course/${slug}${via ? `?via=${via}` : ''}` ``. This avoids forking the component or adding context-detection logic inside it.
