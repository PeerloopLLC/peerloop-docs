---
name: project_old_appnavbar_retire_by_default
description: "Conv 331 policy — /old/* + AppNavbar are retire-by-default; must prove CANONICAL value (links from legacy surfaces don't count)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 26134cab-6ac3-4dba-8aa5-43b6a6e22531
---

**[OLD-RETIRE-DEFAULT] (Conv 331):** Standing policy — from here on `/old/*` pages must **seriously prove their value** to stay hosted in the app. Default disposition is **retire**, not keep.

**`AppNavbar.tsx` is grouped WITH `/old/*`** as provisional infrastructure — it's the legacy navbar (`src/layouts/old/AppLayout.astro` / LegacyAppLayout) that serves `/old/*`. The canonical Matt shell is `src/layouts/AppLayout.astro` + `src/components/Sidebar.tsx`. The AppNavbar-hosted **`DiscoverSlidePanel`** is likewise legacy (NOT rendered by the canonical Sidebar — verified Conv 331; Sidebar only *references* it in a comment).

**Consequence for route-value judgments:** a link *from* AppNavbar / DiscoverSlidePanel / any `/old` surface does **NOT** count as evidence a route earns its place. Only links from **canonical** surfaces count — Matt `Sidebar`, Home `/`, role workspaces (`/learning`·`/teaching`·`/creating` and the MyFeeds panel on them), etc. Anything reachable *only* via AppNavbar inherits AppNavbar's provisional status.

Sharpens [[project_old_pages_no_delete_until_vetted]] (Conv 250 covered the MOVE *mechanic* + deletability; this sets the *default disposition* and folds AppNavbar in). Feeds [[project_route_404_honesty_standin]]. Implies a future **AppNavbar-retirement track** + sharpens [OLD-PORTED-CLEANUP] #24. First applied to the RG-DISCOVER `/feed`+`/feeds` call (Conv 331).
