---
name: project_navigation_architecture
description: "AppLayout (Matt shell) is the canonical layout since ROUTE-FLIP (Conv 197). /old/* pages are wrapped by layouts/old/AppLayout.astro → AppNavbar (NOT LegacyAppLayout/AppHeader — those were orphaned + deleted Conv 339). When adding routes, mind which shell + startsWith active-matching."
metadata: 
  node_type: memory
  type: project
  originSessionId: 1931ac08-1cf4-4eaa-bfbd-67fd4a7dc272
---

**AppLayout (Matt shell)** is the canonical layout since ROUTE-FLIP (Conv 197), used by all root routes.

**The `/old/*` legacy shell** is `src/layouts/old/AppLayout.astro`, which renders **AppNavbar**. That is the *only* live legacy shell. (Corrected Conv 339: `src/layouts/LegacyAppLayout.astro` + `src/components/layout/AppHeader.tsx` were found **orphaned** — zero importers, not even from `/old` pages — and **deleted**. The earlier claim that "LegacyAppLayout/AppHeader/AppNavbar wrap /old/*" was stale; only **AppNavbar** wraps `/old`.)

**How to apply:** When adding routes, mind **which shell** the route lives under (Matt `AppLayout` for root routes, `layouts/old/AppLayout.astro` for `/old/*`), and check `startsWith` active-matching when a nav item must stay highlighted across sub-routes.

Related: [[project_old_pages_no_delete_until_vetted]], [[project_old_appnavbar_retire_by_default]], [[project_preflip_worktree_reference]].
