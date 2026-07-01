# State — Conv 355 (2026-07-01 ~15:29)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Shipped **[SNAV-TOP] Phase 2a** — the course enrollment journey redesigned as a horizontal stepper ("Direction C") across all 4 course pages — plus a SubNav `md:flex-wrap` responsiveness fix, **completing the SNAV-TOP block** (archived to `plan/COMPLETED.md`). A long design discussion (client wants left panels gone site-wide; user wants the desktop rail as a reserve) then produced **[LAYOUT-MODE]**: a per-user layout reserve whose **Phase A threading backbone** (per-request `navLayout` via `Astro.locals`) landed and was verified. Conv ends paused before the Phase A schema/toggle work.

## Key Context

- **Commits (jfg-dev-14, not pushed to any PR):** `e55e49d0` Phase 2a stepper · `74e90342` flex-wrap fix · `4f0486ac` Phase A backbone. Docs on `main`.
- **[LAYOUT-MODE] design is the source of truth:** `plan/layout-mode/README.md` — ONE model + orientation-aware presentation + ONE per-user `nav_layout` setting (default `'top'` = client; `'rail'` = Matt's responsive desktop rail). Middle ground avoids maintaining two content copies; **[SNAV-CLEAN] still proceeds** (fold into Phase B — do NOT revive the old zoned code). Phases: A setting infra / B SubNav orientation + SNAV-CLEAN / C journey vertical-indented mode / D listing filters top-vs-rail (heaviest; delivers the client's still-outstanding listing-page request).
- **Phase A remaining (resume here):** add `nav_layout TEXT NOT NULL DEFAULT 'top'` to `users` in `migrations/0001_schema.sql` → **local D1 reseed (resets the :4321 session)**; source `navLayout` from AppLayout's existing logged-in-user query (replace the `SUBNAV_LAYOUT` constant fallback); build the `/profile` toggle UI + persist API.
- **Threading is done + verified:** `AppLayout` sets `Astro.locals.navLayout`; `SubNav` reads it (`?? SUBNAV_LAYOUT`). Flipping the value flips the whole page between top strip and desktop rail. The journey stepper stays horizontal until Phase C adds its vertical mode.
- **Gotcha:** this machine's Chrome bridge doesn't apply window resizes to `innerWidth` — DOM-measure (`scrollWidth`/`clientWidth`) instead of trusting a resized viewport.
- For the task backlog, see `CURRENT-TASKS.md` — [LAYOUT-MODE] is Ordered #1.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
