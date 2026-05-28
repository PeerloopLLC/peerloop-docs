# Phase 2 — Layout shell [MATT-EXEC-SHL]

**Status:** ✅ COMPLETE (Conv 174 base, Conv 175 refinements + viz; Conv 190 rewritten to Matt's Layout Desktop in `[SBAR-REWRITE]`)
**Family:** matt
**Spec:** `docs/as-designed/matt-pre-plan.md` §9 Phase 2

---

## Summary

Phase 2 layout shell landed. 5 components authored under `src/{layouts,components}/matt/` (now in repo root post-Conv 197 [ROUTE-FLIP], see [cutover.md](cutover.md)):

- `HeaderBar.astro` (slot-based per Decision 7=C — `header-left`/`center`/`right` slots; fixed-top at `<lg`; mobile = brand+icons row, tablet portrait = centered brand)
- `SubNav.astro` (items-prop based; vertical-left strip at `lg:` 196px wide; horizontal-scroll fallback at `<lg` as Phase 4 drawer stub)
- `Sidebar.tsx` (React island, `useState` toggle expanded/collapsed 220/70px, 5-item primary nav + earnings/notifications/profile chip + brand)
- `ControlBar.tsx` (React island, bottom-fixed pill, 6 nav icons with `tabletOnly` flag — 4 icons at `<sm` + 6 icons at `sm:`; z-30)
- `AppLayout.astro` (composes all 4; Sidebar `hidden lg:flex`, HeaderBar/ControlBar `lg:hidden`; named slots `header-bar`/`entity-header`/`role-tab-bar`/`sub-nav` + default; entity prop applies `.entity-{creator|student|course}` class)

Gates green: tsc 0 / astro 1220/0/0/0 / build 6.13s. Built CSS verified: bridge color/typography utilities (`--color-text-default`, `--color-entity-background`, `--text-body-default`, etc.) emit because components consumed them — confirms Tailwind 4's on-demand `@theme` emission behavior (see Phase 1 Learning #1). 3 positioning refinements deferred → `[MSH-REFINE]`.

## Conv 175 — [MSH-REFINE] + [MSH-VIZ]

**[MSH-REFINE]** — Phase 2 MattLayout shell refinements completed:

- (a) Tailwind `lg:` breakpoint shifted 1024→1025px via `--breakpoint-lg: 1025px` global override in `tokens-tailwind-bridge.css @theme` (single source of truth, propagates to all `lg:*` callsites in both matt/* and legacy fraser/*)
- (b) tablet HeaderBar `top:48px` applied
- (c) tablet main content `pt-[88px]` clearance applied

Also cleaned HeaderBar.astro: removed dead `<slot>{fallback}</slot>` content from 3 slot wrappers (defaults moved to AppLayout per slot-forwarding fix — see Decision below); docstring updated to point to AppLayout for defaults and cross-reference `memory/reference_astro_slot_forwarding.md`. `npm run check` clean (0 errors, 0 warnings, 1 pre-existing hint).

**[MSH-VIZ]** — Phase 2 shell preview validated in browser. Created `/matt/index.astro` stub (5750 B, gated `noNav`) exercising every AppLayout slot for breakpoint regression checks. Confirmed shell renders at desktop (1300×713) + tablet (800×900) + mobile.

**Diagnosed and fixed Astro slot-forwarding suppression bug:** `<Fragment slot="x"><slot name="y" /></Fragment>` in AppLayout marked HeaderBar's slot as "filled (with empty content)" even when the page didn't fill the inner slot, suppressing HeaderBar's `<slot name="x">FALLBACK</slot>` fallback. `Astro.slots.has + &&` short-circuit fix DID NOT work (root cause unconfirmed). Durable fix landed: moved defaults from HeaderBar to AppLayout via ternary inside *unconditional* Fragments (`{Astro.slots.has('x') ? <slot name="x" /> : <span>default</span>}`). Saved `memory/reference_astro_slot_forwarding.md` documenting the bug + repro pattern + failed-fix attempt + durable fix.

**Strategic decisions captured:**

- **Slot-forwarding fix lives in AppLayout via unconditional Fragment + ternary** — single source of truth for defaults at the layout consumer; HeaderBar becomes a pure shell primitive with no slot fallbacks. Trade-off: pages using HeaderBar directly (without AppLayout) lose the defaults — acceptable per HeaderBar's docstring noting direct use is rare.
- **Tailwind `lg:` breakpoint shifted 1024→1025px globally** via `--breakpoint-lg: 1025px` in `tokens-tailwind-bridge.css @theme`. Single source of truth, propagates to every `lg:*` callsite in both matt/* and legacy fraser/* pages. Matches Matt's spec exactly. Visual impact only at the 1024px edge case. Same low-blast-radius reasoning as Conv 174 global spacing override.

**Patterns established:**

- **AppLayout slot-default pattern** — defaults live in AppLayout via ternary inside *unconditional* Fragments using `Astro.slots.has()` to decide between page override and default. Primitives (HeaderBar) carry no slot fallbacks.

## Conv 190 — [SBAR-REWRITE] full sidebar + shell rewrite

Sidebar + shell rewritten to match Matt's Layout Desktop `81:1483` (Decision 2 — scope B: sidebar AND shell, so the active pill pops against a grey page).

**Shell** (`AppLayout.astro`): page bg `#f8fafc`, content = white rounded-20 card + shadow, sidebar transparent, body `lg:p-16 lg:gap-16`, now fetches the logged-in user.

**Sidebar** (`Sidebar.tsx`): collapse `«` double-chevron top-right (harvested `keyboard_double_arrow_left` → `chevrons-left.svg`, **43rd icon**), active item = white pill always, bottom cluster with descriptions (Earnings+"Learn More", Notifications, Profile).

**Supporting:** `MainNav.tsx` active → 'Main' pill regardless of children + gap `16 → 24`; `UserIcon.tsx` gained `size` prop (24/40); Logo sized `Medium → Small` per user.

**Profile role logic** — new `src/lib/roles.ts` (`userRoles()` + `describeRoles()`) on hierarchy Admin > Creator > Teacher > Moderator > Student (sourced from `UserProfileHeader.tsx`; Student base-only): 1 role → role, 2 → "A, B" higher-first, 3+ → "A + N more"; Visitor when not logged in (filled `user-icon` circle + "Visitor", links `/login`). `AppLayout` selects all 5 capability flags and builds the label via `describeRoles` (Decision 3).

Verified `/matt/` Home-pill, collapsed mode, course page, and the Visitor state live.

**[SBAR-STICKY]** — Sidebar aux cluster (Earnings/Notifications/Profile) sat at page-bottom not viewport-bottom (the `<aside>` stretched to full body height; `flex-1` nav pushed aux down). Added `lg:sticky lg:top-0 lg:h-screen lg:overflow-y-auto`. Verified pinned while scrolling. (Same flex-child stretch root cause later seen on SubNav — fixed via `self-start` in [MATT-COURSE-POLISH], see phase-5.)

## Open

- [ ] **[PROF-ROW-VERIFY]** Conv 190 — Visually verify the logged-in Sidebar Profile row (avatar + name + e.g. "Admin + N more"). Only the Visitor fallback was confirmed in-browser this conv (dev session isn't authenticated; user logs in as Brian off-chat via real password entry). The `describeRoles` logic is type-checked and traced correct but the avatar+name+role rendering hasn't been eyeballed.
