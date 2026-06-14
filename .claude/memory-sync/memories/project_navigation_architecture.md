---
name: project_navigation_architecture
description: "AppLayout (Matt shell) is the canonical layout since ROUTE-FLIP (Conv 197); LegacyAppLayout/AppHeader/AppNavbar still wrap /old/*. When adding routes, mind which shell + startsWith active-matching for sub-routes."
metadata: 
  node_type: memory
  type: project
  originSessionId: 1931ac08-1cf4-4eaa-bfbd-67fd4a7dc272
---

**AppLayout (Matt shell)** is the canonical layout since ROUTE-FLIP (Conv 197). **LegacyAppLayout / AppHeader / AppNavbar** still wrap `/old/*` pages.

**How to apply:** When adding routes, mind **which shell** the route lives under (Matt `AppLayout` for root routes, legacy shell for `/old/*`), and check `startsWith` active-matching when a nav item must stay highlighted across sub-routes.

Related: [[project_old_pages_no_delete_until_vetted]], [[project_preflip_worktree_reference]].
