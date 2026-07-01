# [LAYOUT-MODE] — Per-user layout reserve (top vs responsive rail)

**Status:** 📋 PLANNED — design approved Conv 355; execution phased.
**Relationship:** extends **[SNAV-TOP]** (done Conv 354–355); **absorbs [SNAV-CLEAN]** (folds into Phase B).
**Owner decision:** default is the CLIENT's position; the rail is an opt-in per-user reserve.

---

## Problem — two legitimate positions

- **Client:** the left side-panels should disappear **site-wide** — the section-nav rails *and* the listing-page left filter panels on `/members`, `/courses`, `/communities`. Top / minimal, Twitter-style. **This is the default.**
- **Us (reserve):** on **desktop** the top strip (a) wastes the horizontal room a side panel would use, (b) flattens **The Journey's indentation** (the Sessions → My Sessions/Book/Join hierarchy a rail shows and a stepper can't), and (c) **wraps the tab headings to two rows** — clutter, purely to keep the layout uniform across devices.

**Twitter mapping (settles the north-star):** Twitter's **left rail is its MAIN menu** (= Peerloop's `Sidebar` — kept, not in scope); its **sub-menus are top, single-row horizontal-scroll**, and only ever **2–4 items**. Peerloop's section sub-nav is **7 tabs + a 4-step journey with hierarchy** — richer than any Twitter sub-nav. So "be like Twitter" genuinely supports **top for THIN sub-navs** and quietly breaks on our **RICH** ones (course + journey). That is the precise, non-arbitrary justification for the desktop-rail reserve — it earns its keep exactly where the loss is felt.

---

## The middle ground — ONE model, orientation-aware presentation, ONE setting

The concern was "don't maintain two versions of the same content." We don't:

- **Content authored once** — the nav models (`buildCourseExploreTabs` / `buildCourseJourney` / `buildCourseSessionActions`) and the filter islands are the single source.
- **Presentation is orientation-aware** — each component renders that one model as a **top strip** or a **vertical rail** via layout branches. This is exactly the pattern `SubNav.astro` already uses (`navOnTop`): same `items[]`, two orientations.
- **No old-code revival.** The rail form of the journey is a *new* vertical mode of `CourseJourneyStepper`, built on the Phase-2 model — NOT the deleted zoned/cluster `SubNav` code. So **[SNAV-CLEAN] still proceeds.**

"Two orientations" = presentation branches inside one component, not duplicated content. The only standing cost: every future nav/page change should be sanity-checked in both modes.

---

## The setting

- Per-user **`nav_layout: 'top' | 'rail'`** (persisted per user; **default `'top'`** = client). Read at **SSR** in `AppLayout` (fold into the existing logged-in-user query → no first-paint flash, cross-device, account-scoped). **Replaces the `SUBNAV_LAYOUT` build constant.** Toggle lives on **`/profile`**.
- `'top'` → top everywhere (client default).
- `'rail'` → **Matt's original responsive behavior**: vertical rail at ≥1024px, top strip below. (The `'left'` branch already *is* this — it just needs to read the per-user value instead of the constant.)

---

## Phases

### Phase A — Setting infrastructure (backbone)
- Per-user field + migration (`users` column or `user_settings`; schema edit lands in `migrations/0001_schema.sql` pre-launch per Schema Discrepancy Discipline).
- SSR read in `AppLayout`; thread the value to `SubNav` + journey + listing components (retire the `SUBNAV_LAYOUT` constant reads).
- `/profile` toggle UI + persist API. Default `'top'`.

### Phase B — SubNav orientation + fold in [SNAV-CLEAN]
- `SubNav` already has top + rail branches → wire them to the per-user value.
- Delete the dead zoned/cluster code ([SNAV-CLEAN]) — the reserve does NOT need it.

### Phase C — Journey vertical / indented mode
- `CourseJourneyStepper` + `CourseSessionsActions` gain `orientation: 'top' | 'rail'`. Rail mode = vertical steps + **indented Sessions cluster** (restores the hierarchy), from the same model.
- In rail mode, Explore tabs (SubNav rail) + the journey stack in the left-rail region — reproducing the old unified rail, built from the new components.

### Phase D — Listing pages (the special UI — heaviest)
- `ListingShell` gains a mode: `'top'` = filters as a **horizontal bar above the listing** (NET-NEW UI); `'rail'` = the current 320px left aside.
- The filter islands (`CoursesFilters` / `MembersFilters` / `CommunitiesFilters`) need a horizontal presentation for top mode — filters reorient far less trivially than tabs (this is the "special UI").
- One filter model, two presentations. **This phase finally delivers the client's still-outstanding listing-page request** — those filters are currently *always* left.

---

## Notes / risks
- **Default `'top'` respects the client regardless of phase order** — safe to ship phases independently.
- **Phase D is the real design work**; A–C are largely reorientation of existing pieces.
- Phase order dependency: A first (backbone); B trivial after A; C medium; D heaviest & most independent (it's also the one the client is actually waiting on).
