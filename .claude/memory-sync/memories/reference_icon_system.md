---
name: reference_icon_system
description: "Peerloop's two icon systems — the Astro path registry (icon-paths.ts) + React icons.tsx/brand-icons.tsx, and the Matt MattIcon SVG registry — with their usage patterns, the currentColor/fill='none' gotcha, and the auto-register-by-drop convention"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 7de96234-317d-4057-9a70-b56f9468dd50
---

Peerloop has **two** icon systems on different axes; know which one a surface uses before adding an icon.

**Astro path registry** (`src/lib/icon-paths.ts`): 39 entries (5 dir + 4 nav + 4 people + 4 content + 16 obj + 3 community + 3 brand). React side: `icons.tsx` (~96 exports); brand: `brand-icons.tsx` (Google/GitHub/Stripe/Twitter/LinkedIn/YouTube/Instagram). Usage:
- Astro pattern: `<Icon name="profile" class="w-6 h-6 text-purple-600" />`
- React pattern: `({ className = 'h-5 w-5' }: IconProps)`

**Matt registry** (`src/components/icons/MattIcon.tsx` + `./svg/*.svg`, imported as `@components/icons/MattIcon`): **54 SVGs** loaded via Vite `import.meta.glob('./svg/*.svg')`, fills normalized to `currentColor`.
- The MattIcon wrapper is `fill="none"`, so harvested SVG paths **MUST** carry an explicit `fill="currentColor"` or they render invisible.
- **Auto-register convention:** drop a new `.svg` into `svg/` and it registers automatically — there is no manifest to update.
- Unknown name → renders a dashed-border placeholder (a visible "missing icon" signal).
- Conv 193 [NAV-ICON-SWAP] harvested 10 Material-outlined icons for the legacy-nav retrofit (menu, search, admin-panel-settings, chevron-right, group, label, assignment, videocam, warning, person-add).
- Conv 212 added `lock` (Material-outlined) for the /profile Security tab.
