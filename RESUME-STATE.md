# State — Conv 357 (2026-07-01 ~21:03)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Shipped **[LAYOUT-MODE] Phases C + D**, closing the whole block (A+B+C+D). Phase C = the course enrollment journey now renders as an indented vertical left-rail stepper (rail layout) via a new `CourseRail.astro` wrapper. Phase D = listing-page filters (`/courses`, `/members`, `/communities`) gain a minimal top bar (search + Sort + a "Filters" collapse) in the default top layout, keeping the 320px left aside for the rail opt-in. Mid-Phase-D a rail double-render bug forced a durable mechanism fix: **`navLayout` resolution moved to middleware**. Committed both phases (4 commits) + this /r-end bookkeeping; all pushed by /r-end.

## Key Context

- **LAYOUT-MODE is DONE** — archived as `plan/COMPLETED.md` #76; detail in `plan/layout-mode/README.md`. One per-user `nav_layout` setting (`/profile` `LayoutToggle`) drives all three surfaces (content-page subnavs, course journey, listing filters) via `Astro.locals.navLayout`; no page hard-pins `subNavLayout`, so all obey it.
- **Durable mechanism change (this conv):** `src/middleware.ts` now has `resolveNavLayout` — it resolves the per-user layout onto `locals` **before page frontmatter runs**. This was needed because **Astro evaluates a page's slot-content expressions eagerly, before a wrapping layout's frontmatter**, so a page-template `Astro.locals.navLayout` read was unreliable (it split from what AppLayout/ListingShell saw → rail double-rendered). `AppLayout` now prefers the middleware value (keeps its own resolution as a fallback). This also strengthens Phases A–C reads. See `docs/decisions/05-ui-ux-components.md` + this conv's Decisions.md.
- **Diagnostic gotcha (for future bridge testing):** a mixed-DOM state that **survives a hard reload** is a real SSR bug, not a ClientRouter view-transition artifact.
- **Verification:** DOM-truth on the user's `:4321` server (test user `jennifer.kim@example.com`, enrolled+completed in `intro-to-claude-code`). Toggled her `nav_layout` in local D1 to check both modes; **restored to `top`** at the end. 5 gates green (tests 6732) after both phases.
- **Two follow-ups landed in the backlog** (see `CURRENT-TASKS.md`): `[LAYOUT-DOC]` (fix `08-layout-and-margins.md` ListingShell two-mode + a pre-existing left/right inconsistency) and `[LAYOUT-TOGGLE-AFF]` (the /profile control is a segmented toggle, not a checkbox — confirm affordance). Both low priority.
- **Next Ordered #1:** `[MEM-CAP-ARCH]` Phase 2 — automate the HOT/COLD `MEMORY.md` index enforcement in `/r-prune-memory`.
- For the task backlog, see `CURRENT-TASKS.md`.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
