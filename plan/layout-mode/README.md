# [LAYOUT-MODE] — Per-user layout reserve (top vs responsive rail)

**Status:** 🔨 IN PROGRESS — design approved Conv 355; **Phases A + B COMPLETE Conv 356** (A: per-user `nav_layout` schema + SSR sourcing + `/profile` toggle; B: SubNav orientation wired + [SNAV-CLEAN] dead-code deletion — both verified end-to-end); **Phase C COMPLETE Conv 357** (journey vertical/rail mode via `CourseRail` wrapper — DOM-verified both modes, 5 gates green); **Phase D pending** (listing-page filters — the heaviest, the client's outstanding request).
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

### Phase A — Setting infrastructure (backbone) ✅ COMPLETE (Conv 356)
**Backbone (Conv 355):** per-request `navLayout` threaded via `Astro.locals` — added `App.Locals.navLayout` (`env.d.ts`); `AppLayout` resolves + publishes `navLayout` on `Astro.locals` + drives `subNavOnLeft`; `SubNav` reads `Astro.locals.navLayout ?? SUBNAV_LAYOUT`. Commits `4f0486ac` (code) + `38a4c47` (docs).

**Per-user sourcing + toggle (Conv 356):**
- **Schema:** `nav_layout TEXT NOT NULL DEFAULT 'top' CHECK (nav_layout IN ('top','rail'))` on `users` (`migrations/0001_schema.sql`, per Schema Discrepancy Discipline) + `User` type (`db/types.ts`). Local D1 reseeded. **Vocabulary:** DB/API store the user-facing `'top' | 'rail'`; `AppLayout` maps `'rail' → 'left'` (the internal `SubNavLayout` placement) in one place — downstream (`Astro.locals.navLayout`, `SubNav`) stays `'top' | 'left'`, untouched from Conv 355.
- **SSR sourcing:** `AppLayout` folds `nav_layout` into its existing logged-in-user query (no extra round-trip) and resolves `navLayout` from it; the `SUBNAV_LAYOUT` constant is now only the logged-out / no-DB fallback.
- **Persist API:** `nav_layout` added to `PATCH/GET /api/me/profile` (whitelist + `'top'|'rail'` validation + `bumpUserDataVersion`) — same path as the email/marketing prefs.
- **Toggle UI:** `LayoutToggle.tsx` island (segmented Top bar / Side rail) on the `/profile` Account "Preferences" card beside `ThemeToggle`; PATCHes then hard-reloads (placement is SSR-computed, so a client flip can't apply it).
- **Verified (Conv 356):** browser DOM-truth end-to-end — toggle → PATCH → reload → whole shell re-orients (rail 196px + wrapper `lg:flex-row` on `'rail'`; top-strip on `'top'`), both directions, DB persists each way. 5 gates green (tests 6732).

> Note: journey + listing components (`CourseJourneyStepper`, `ListingShell`, filter islands) still read/behave per their own logic; wiring them to `navLayout` is Phases C/D. Phase B wires `SubNav` orientation fully + folds in [SNAV-CLEAN].

### Phase B — SubNav orientation + fold in [SNAV-CLEAN] ✅ COMPLETE (Conv 356)
- `SubNav` orientation reads the per-user value via `Astro.locals.navLayout ?? SUBNAV_LAYOUT` (from the Phase-A backbone); no further wiring needed — the top + rail branches already switch on it.
- **[SNAV-CLEAN] done:** deleted the inert dual-zone/two-tier cluster machinery from `SubNav.astro` — the `kind:'cluster'` branch + `SubNavClusterItem`/`SubNavClusterChild`/`SubNavRootItem` types, zone dividers/headers + the `zoneLabels` prop, the done-✓ overlay, the disabled-gate render, the `zoned` guard, and the now-unused `ProgressBar`/`MattIcon` imports. Verified no caller feeds zoned/cluster/done/disabled items (audit) — `buildCourseExploreTabs` is flat; the journey's `done`/`disabled` live on `CourseJourney`/`CourseSessionAction` feeding the stepper, not SubNav. SubNav is now a flat tab strip/rail only.
- **Verified (Conv 356):** browser DOM-truth — course page (richest SubNav, 7 Explore tabs) renders correctly in both modes (top strip; rail 196px beside content, wrapper `lg:flex-row`), "About" exact-match still selected. 5 gates green (tests 6732).

### Phase C — Journey vertical / indented mode ✅ COMPLETE (Conv 357)
**Architecture fork resolved → `CourseRail` wrapper** (user pick, Conv 357). The rail-column assembly is authored once, not inline ×4.

- **`CourseRail.astro` (NEW)** owns the course pages' `sub-nav` slot. Reads `Astro.locals.navLayout`:
  - `top` → renders `<SubNav>` exactly as before (client default **byte-identical** — no regression).
  - `left` (desktop ≥lg) → a `lg:w-[196px]` flex-column (divider/sticky owned by the wrapper; SubNav's own rail chrome overridden off) stacking **SubNav (rail) → vertical `CourseJourneyStepper` → nested `CourseSessionsActions`**. Below lg the wrapper is `display:contents`, so SubNav falls back to its mobile strip.
- **`CourseJourneyStepper` + `CourseSessionsActions`** gained `orientation: 'top' | 'rail'`. Rail = vertical steps + **indented Sessions cluster** nested under the Sessions step via a `sessions-cluster` slot (restores The Journey's hierarchy). Following SubNav's own responsive split, the `top` instances stay as the **mobile** journey (`lg:hidden` in rail mode); the `rail` instances are `hidden lg:flex` — exactly one shows per breakpoint, so **no page reads `navLayout`**.
- **4 pages wired** (`[...tab]`/`book`/`success`/`session/[id]`): each swaps `SubNav → CourseRail` passing `exploreTabs`/`journey`/`sessionActions`; the existing entity-header stepper + content pills self-suppress on desktop in rail mode.
- **Verified (Conv 357)** — DOM-truth on `:4321` (jennifer.kim, enrolled+completed): rail mode = 196px column, SubNav tabs + vertical stepper (Enroll✓/Payment✓/Sessions 2-of-2/Certificate·locked) + indented My Sessions/Book/Join under Sessions; horizontal band + top pills `display:none` at desktop. Top mode = single horizontal band + full-width SubNav strip + pill row, no rail column (unchanged). 5 gates green (tests 6732).

### Phase D — Listing pages (the special UI — heaviest)
- `ListingShell` gains a mode: `'top'` = filters as a **horizontal bar above the listing** (NET-NEW UI); `'rail'` = the current 320px left aside.
- The filter islands (`CoursesFilters` / `MembersFilters` / `CommunitiesFilters`) need a horizontal presentation for top mode — filters reorient far less trivially than tabs (this is the "special UI").
- One filter model, two presentations. **This phase finally delivers the client's still-outstanding listing-page request** — those filters are currently *always* left.

---

## Notes / risks
- **Default `'top'` respects the client regardless of phase order** — safe to ship phases independently.
- **Phase D is the real design work**; A–C are largely reorientation of existing pieces.
- Phase order dependency: A first (backbone); B trivial after A; C medium; D heaviest & most independent (it's also the one the client is actually waiting on).
