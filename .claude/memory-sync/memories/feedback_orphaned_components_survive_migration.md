---
name: feedback_orphaned_components_survive_migration
description: Route migrations orphan page-level components while tsc/lint/tests stay green; verify route-reachability before trusting/editing a page component (esp. in grep sweeps).
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 96602cd2-d0ba-4944-80b4-5fa46ed65385
---

**Before trusting or editing a page-level component — especially in a grep-driven copy/rename sweep — verify it is actually reachable from a route.** A component mounted by no `src/pages/**` route is invisible dead code that every automated check still passes.

**Why:** Conv 339 retired `/old` routing by deleting ~60 **page** files but leaving the **components** those pages rendered. The whole course-detail family — `ExploreCourseTabs`/`ExploreCourseHero`/`CourseHero`/`CourseDetail`/`CourseTabs`/`LearnTab` + `discover/detail-tabs/*` + `courses/course-tabs/*` — was orphaned (superseded by the Matt `/course/[slug]/[...tab].astro` page, which renders its own content; there is no `/discover` route and no `/courses/[slug]` detail page). Nothing flagged it:
- `tsc`, `lint`, `astro check`, `build` all stay green — Vite just tree-shakes an unmounted component out of the bundle.
- Several orphans still had **passing unit tests** (`LearnTab` ×2, `CourseDetail` ×5-incl-type, `role-utils` ×4) — tests import components directly, bypassing routing, so green tests give a false "alive" signal.

**How it bit us:** Conv 391's `[DIPLOMA-UI-GAPS]` was a grep-driven "Certificate→Diploma" copy sweep. It edited real strings inside 4 of these orphaned components in good faith — so 4 of the 9 "user-visible" changes rendered **nowhere**. Conv 392 caught it only by walking the live app + tracing mount points by hand.

**How to apply:**
- When a task says "user sees X on component C", confirm C is transitively imported from a `src/pages/**` route before treating the edit as user-facing. Trace `<C` / `C client:` mounts, not just that C compiles.
- A grep/rename sweep across `src/components/**` should assume some matches are dead code; spot-check reachability.
- Migrations that delete routes must also delete (or explicitly re-home) the components those routes solely rendered.
- The durable fix is a reachability detector (walk `src/pages/**` → reachable set → flag page-level components reached by nothing) wired into `/w-codecheck` — tracked as `[ORPHAN-DETECT]`. Related credential/diploma context in [[project_diploma_vs_certificate]].
