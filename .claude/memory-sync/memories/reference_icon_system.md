---
name: reference_icon_system
description: "Peerloop's icon systems after [ICN-NS] Phase 1 (Conv 370) — legacy Astro path registry icon-paths.ts RETIRED; three remain (React icons.tsx PascalCaseIcon + brand-icons.tsx + Matt MattIcon SVG registry, which is canonical per Option A); the currentColor/fill='none' gotcha + auto-register-by-drop convention"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 7de96234-317d-4057-9a70-b56f9468dd50
---

**[ICN-NS] Option A ratified — MattIcon is canonical.** After Phase 1 (Conv 370) the legacy **Astro path registry** (`src/lib/icon-paths.ts` + `ui/Icon.astro`) is **RETIRED and deleted** — its 4 real call sites (Breadcrumbs `chevron-right`→MattIcon; Footer's 3 brand logos→`brand-icons.tsx`) migrated away. **Three** systems remain; full audit in `docs/as-designed/icon-system.md`.

- **`MattIcon`** (`src/components/icons/MattIcon.tsx` + `./svg/*.svg`, imported as `@components/icons/MattIcon`) — **the canonical/default** for design glyphs. ~59 SVGs loaded via Vite `import.meta.glob('./svg/*.svg')`. Renders in **both `.astro` (server-side, ~17 files incl. AppLayout) and `.tsx`**. Prop API `{ name, className }` (use `className`, even in `.astro`).
- **React `icons.tsx`** (`@components/ui/icons`) — 108 `PascalCaseIcon` React components, **175 importers**; the React-island workhorse (kept, not canonical). Has **no `.astro` precedent** — only MattIcon is used in `.astro`.
- **React `brand-icons.tsx`** (`@components/ui/brand-icons`) — 7 brand/social logos (Google/GitHub/Stripe/TwitterX/LinkedIn/YouTube/Instagram); the **canonical home for brand logos**. Note `TwitterXLogo` is the **X** mark (not the old bird).

**MattIcon gotchas (unchanged):**
- **Per-icon viewBox preserved** (Conv 187) — the wrapper reads each SVG's own `viewBox` (Material ships 20dp + 24dp grids); don't force 24×24.
- The wrapper is `fill="none"`, so harvested SVG paths **MUST** carry explicit `fill="currentColor"` or they render invisible. Mask `<rect>` fills stay `#D9D9D9` (alpha mask); only the visible path → `currentColor`.
- **Auto-register convention:** drop a new `.svg` into `svg/` and it registers automatically — no manifest to update. Adding one also requires an `icon-provenance.ts` entry or `npm run prov:sweep` fails.
- Unknown name → dashed-border placeholder (visible "missing icon" signal).

**Naming convention (Phase 2, Conv 370):** a shared concept = one base token — `<Concept>Icon` (icons.tsx PascalCase) ↔ `<concept>` (MattIcon kebab); **on a name conflict the MattIcon kebab name is canonical**, icons.tsx renames to match (new icons follow this from the start). Discovery: `icons.tsx` ships **10 literal aliases** (`export const A = B`) — `XIcon=CloseIcon` (§3.4 CONFIRMED same), `SearchIcon=DiscoverIcon`, `RatingIcon=StarFilledIcon`, `PlusIcon=CreatingIcon`, `RevenueIcon=MoneyIcon`, `CreateIcon=EditIcon`, `BrainIcon=LightbulbIcon`, `Privacy/Shield/FocusIcon=ShieldCheckIcon`. Full reconciliation map (aligned 17 / mismatch→rename-target 15 / no-twin) in `docs/as-designed/icon-system.md` §7.

**Phase 3 renames COMPLETE (Conv 370):** consolidated all 10 aliases + **all 15** name-mismatch renames — `icons.tsx` now **98** exports (was 108). Live canonical names: `VideocamIcon`, `MessageIcon`, `InfoIcon`, `CertificationIcon`, `ChatIcon`, `PersonAddIcon`, `AdminPanelSettingsIcon`, `LabelIcon`, `UserIcon`, `QuestionIcon`, `TeachersIcon`, `EarningsIcon`, `WriteIcon`, `GroupIcon` (← `UsersIcon`); aliases gone (`SearchIcon` kept over former base `DiscoverIcon`; `PlusIcon` over `CreatingIcon`). **Rename gotcha:** files using the `import X` + local `const Wrapper = () => <X/>` pattern collided when the import name met the wrapper name — fix = alias the import `as XShared` (hit `BecomeATeacherPage.tsx`, `ForStudentsSection.tsx`); test mocks of `@components/ui/icons` need their keys renamed too (`ContextActionsPanel.test.tsx`).

**Team/Users resolved (Conv 370):** glyph check showed `UsersIcon`=2-person=MattIcon `group` → renamed `UsersIcon`→`GroupIcon`; `TeamIcon`=3-person is a DISTINCT no-twin glyph, **kept** (not merged). `RatingIcon`→`ratings` was **moot** (unused alias already consolidated). **§3.3 DECIDED — accept split (Conv 370); ICN-NS COMPLETE.** The `icons.tsx` (Heroicons, React islands) / `MattIcon` (Material, Matt surfaces) two-system split is an **intentional, documented steady state** — implementation-unification (making shared concepts share one SVG) was **declined**: it would restyle React islands app-wide, and the RTMIG-4 route sweep that could have carried it closed Conv 340 without ever scoping icon-glyph unification, so NO migration will absorb it. Revisitable only if the app commits to an all-Material look. Do NOT rename MattIcon `.svg` files (they carry `icon-provenance.ts` entries) — canonicity flows Matt→React.
