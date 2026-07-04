# State — Conv 362 (2026-07-04 ~12:25)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Mobile-navigation + course-journey UI polish, four threads all committed to `jfg-dev-14` and deployed to staging (final version `1bd65720`): **[MOBNAV]** (bottom ControlBar → 5 icons, added Members; header-right kept notifications), **[MOBUP]** (new `MobileUpNav.astro` compact `‹ parent` up-chevron for mobile deep flows — the deterministic "up" the desktop breadcrumb provides but which is hidden < lg), and **[SHERO]** + **[BHERO]** (course-journey hero conformity — moved the `/success` hero to the top and gave `/book` a hero, so all four journey destinations render the hero in the `entity-header` slot). All verified on the user's real phone on staging.

## Key Context

- **New pattern — mobile up-nav:** `MobileUpNav.astro` is a `lg:hidden` chevron linking to the breadcrumb's **immediate parent** (deterministic "up", component-tested to never use `history.back()` — which is fragile on deep-link/notification entry). Rendered via a new guarded `mobile-upnav` slot in `AppLayout.astro` above `entity-header`. Wired on 7 deep-flow pages; top-level pages skip it (up = Home, already a ControlBar shortcut).
- **New pattern — journey hero placement:** the course hero belongs in `AppLayout`'s `entity-header` slot (top) on ALL journey destinations, fed by `fetchCourseTabData`. `/success` uses `isEnrolled={true}` (its own `data.isEnrolled` can be stale in the just-self-healed case); `/book` keeps its thin `course` query for enrollment/teacher logic and adds `fetchCourseTabData` just for the hero (guarded, loader is nullable).
- **Verification gotcha (learning):** the MCP browser tab is background-hidden, and **Chrome freezes CSS-transition timelines in hidden tabs** — a "stuck/frozen" transition there is an artifact, not a bug; verify the transition's END state. Also: the machine's OS window clamp (~472px) blocks literal phone-width renders but NOT sub-`lg` (≤520px) verification.
- **5 gates green** all conv (final 6751 tests). `jfg-dev-14` carries this conv's commits — **not yet pushed to origin at the time of writing** (pushed in the r-end Step 7).
- **Backlog:** see `CURRENT-TASKS.md` — no Ordered sequence; LAYOUT-SG stays "FOUNDATION LOCKED, residuals deal-with-as-they-come". A quiet sibling gap (`/book` had no hero) was closed this conv by BHERO.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
