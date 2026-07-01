# State — Conv 356 (2026-07-01 ~17:25)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Shipped **[LAYOUT-MODE] Phases A + B**. Phase A landed the per-user `nav_layout` setting (`'top'|'rail'`, default `'top'`) — schema column, SSR sourcing in `AppLayout` (mapping `'rail'→'left'`), the `PATCH/GET /api/me/profile` persist, and a `LayoutToggle` island on `/profile`. Phase B (**[SNAV-CLEAN]**) deleted the now-dead zoned/cluster machinery from `SubNav.astro`, leaving a flat tab strip/rail. Both verified end-to-end in the browser + 5 gates green (tests 6732). Phase C was scoped and **deliberately deferred** to next conv.

## Key Context

- **Commits this conv (code `jfg-dev-14`):** `f8fb810a` (Phase A) + `521320d5` (Phase B / [SNAV-CLEAN]). Docs `main`: `4112924` (Phase A) + `b3755c1` (Phase B) + this /r-end bookkeeping commit. All pushed by this /r-end.
- **Vocabulary decision (durable):** DB/API store the user-facing `'top'|'rail'`; `AppLayout` maps `'rail'→'left'` in **one** place; internal `SubNavLayout` / `Astro.locals.navLayout` stay `'top'|'left'` (untouched from Conv 355). Toggle labels: "Top bar" / "Side rail".
- **SSR-preference pattern:** `LayoutToggle` PATCHes then **hard-reloads** — the placement is SSR-computed, so a client-only state flip can't apply it. Contrast `ThemeToggle` (localStorage, client-only).
- **Phase C (resume here) — OPEN architecture fork:** rail mode relocates the journey from the `entity-header` slot into the left rail (below the tabs) as a vertical stepper + indented Sessions cluster. Needs an `orientation:'top'|'rail'` prop on `CourseJourneyStepper` + `CourseSessionsActions`, **plus** per-page conditional slotting across the **4 course pages** (`course/[slug]/[...tab]`, `book`, `success`, `session/[id]`). Decide first: **`CourseRail` wrapper component vs inline per-page**. Design in `plan/layout-mode/README.md § Phase C`.
- **Gotcha (this machine):** the Chrome bridge doesn't apply window resizes to `innerWidth` — DOM-measure (`getBoundingClientRect`/`scrollWidth`/`clientWidth`) instead of trusting a resized viewport. The rail is a `lg:` (≥1024px) treatment; verify at desktop width.
- **Dev DB note:** the Phase-A reseed reset the local :4321 session; re-login via `POST /api/auth/dev-login {email:'brian@peerloop.com'}`.
- For the task backlog, see `CURRENT-TASKS.md` — **[LAYOUT-MODE] Phase C is Ordered #1**.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
