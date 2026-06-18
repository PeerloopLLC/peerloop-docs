# TYPO-FDN Migration Ledger — per-component presentation conformance

> **The completion mechanism.** A standing, committed checklist of every component
> that must be brought true to the style guide (type + spacing + colour). A component
> is **not done until every axis box is ☑**; a route is **not "presentation-swept"
> until every component it renders is ☑**. Lives in git, shows in `git grep`, and
> keeps the TYPO-FDN PLAN block honestly incomplete until the last box flips.
>
> **Why this exists (the motivating shortfall).** PALETTE-FDN deferred
> `FeedActivityCard`'s 9 raw `text-slate-*` colours with only a *route-level* note
> ("tail rides the RG-* sweeps") — no component checkbox, so it could rot
> indefinitely. This ledger gives that work a row (`FeedActivityCard · Colour ☐`)
> that stays red until done. A component-level checkbox would have caught it; a
> route-level one can't.

## Granularity model — component SoT, route completion derived

- **Rows are components, not routes.** A shared component (`FeedActivityCard`,
  `OnboardingNudgeBanner`, `CourseAnchor`) gets **one** row, tracked once.
- Each row lists the **routes** it renders on (blast-radius — migrating it improves
  all of them; verify it in each).
- **Route completion is derived:** a route is presentation-swept ⟺ every component in
  its tree is ☑. This is the mechanism that survives deferring a shared component —
  the shared row stays ☐ and *no* consuming route can claim done.

## Conformance rules — what each ☑ means

| Axis | ☑ requires |
|---|---|
| **Type** | All text uses §09 tokens by role (size/weight/line-height): paragraphs → `text-body-default-prose`/`-medium`; captions/labels → `text-body-default`/`-small`(+`-medium`); headings → `text-hN`. **No** `text-[Npx]`, no Tailwind `text-xs/sm/base/lg`, no ad-hoc `leading-*`, no raw `font-*` weight (use the token's `-medium`/`-bold` variant). |
| **Spacing** | Margin/padding/gap use **scale classes only** (`p-16`, `gap-12`, `mt-4` = Matt px scale via the bridge). **No arbitrary `[Npx]`** for margin/padding/gap. (Widths/heights/radii may stay arbitrary where no scale token exists.) Off-scale values must snap to scale or be flagged (see Open Decisions). |
| **Colour** | Text/bg/border use role tokens (`neutral-*`, `brand-*`, …); **no** raw `text-slate-*`/`text-gray-*`/hex. (Cross-references PALETTE-FDN; this ledger tracks its component tail at component granularity.) |
| **Card** | If the component is a **Home feed card**, it conforms to the Unified Feed-Card Spec below — not just "uses some token", but the *same* token per slot as its siblings. |

## Unified Feed-Card Spec — PROPOSED (the canonical card contract)

The Home feed renders ~7 card components of different origins; they must present
**identically** per slot. Derived from `AnnouncementCard` (the token-clean reference).
**⬜ PENDING your confirmation — once locked, copied into style-guide §9.4.**

| Slot | Token / class |
|---|---|
| Container padding | `p-16` |
| Container radius | `rounded-12` |
| Eyebrow / label | `text-body-small-medium` (12/1.0/500), uppercase as needed |
| Title | `text-body-medium-bold` (16/1.5/600) |
| Body / paragraph | `text-body-default-prose` (14/1.5) |
| Meta / timestamp | `text-body-small` (12/1.0) |
| CTA link | `text-body-small-medium` |
| Inter-element rhythm | `mt-4` (label→title→body), `mt-8` (body→CTA); internal `gap-12` |

## Ledger — components on `/` and `/courses`

Legend: ☑ conformant · ☐ needs work · — n/a · *(SHARED)* used beyond these two routes.

### Home (`/`) — feed cards (must hit Unified Card Spec)

| Component | Also on | Type | Spacing | Colour | Notes |
|---|---|:--:|:--:|:--:|---|
| `AnnouncementCard` | — | ☑ | ☑ | ☑ | ✅ **Done** (Conv 298). `mt-[2px]` = sanctioned icon-baseline optical exception (flagged, kept). |
| `FeedActivityCard` | /communities, /community/[slug], course-feed *(SHARED)* | ☐ | ☐ | ☐ | **Heaviest:** 15 raw `text-*` + 10 raw `font-*` + 9 raw `slate` + `rounded-lg`(→12). = PALETTE-FDN `[FAC-RECOLOR]`. Verify all 4 route contexts. |
| `FeedPost` | — | ☑ | ☐ | ☐ | Type clean; spacing/colour unverified. |
| `SuggestionCard` | — | ☑ | ☑ | ☑ | ✅ **Done** (Conv 298). badge `font-medium`→`text-body-small-medium`; desc→`text-body-default-prose`, `mt-[2px]`→`mt-4`. |
| `DiscoveryCard` | /discover *(SHARED)* | ☑ | ☑ | ☑ | ✅ **Done** (Conv 298). 🔴 fixed latent bug: `p-4`(4px)→`p-16`, `h-4 w-4`(4px) icons→`size-16`; scale-class spacing; `secondary-100`→`neutral-100`. |
| `CourseAnchor` | many entity surfaces *(SHARED)* | ☑ | ☐ | ☐ | Heavy arb-px: `gap-[10/6/8/16]`, `px-[20/8]`, `py-[12]` — off-scale 10/6. |
| `CommunityAnchor` | many *(SHARED)* | ☐ | ☐ | ☐ | `text-[12px]`/`text-[20px]`/`leading-none`; same heavy arb-px as CourseAnchor. |

### Home (`/`) — non-card

| Component | Also on | Type | Spacing | Colour | Notes |
|---|---|:--:|:--:|:--:|---|
| `index.astro` (layout) | — | ☑ | ☑ | ☑ | Arb-px present are widths/radius (`max-w-[640px]`, `rounded-[16px]`) — allowed, not spacing. |
| `SmartFeed` | — | ☐ | ☐ | ☐ | 3 raw `text-*` + 5 raw `font-*`. |
| `OnboardingNudgeBanner` | /courses *(SHARED)* | ☐ | ☐ | ☐ | 1 raw `font-*`; `mt-[2px]`. |
| `ProgressionNudge` | — | ☑ | ☐ | ☐ | Type clean; spacing/colour unverified. |
| `StickySignupBar` | — (visitor) | ☑ | ☐ | ☐ | `m-[76px]` way off-scale → review. |

### `/courses`

| Component | Also on | Type | Spacing | Colour | Notes |
|---|---|:--:|:--:|:--:|---|
| `courses.astro` | — | ☑ | ☑ | ☑ | Clean. |
| `CoursesRoleTabs` | — | ☑ | ☐ | ☐ | Type clean. |
| `CoursesCatalog` | — | ☑ | ☐ | ☐ | Dispatcher; type clean. |
| `CoursesFilters` | — | ☐ | ☐ | ☐ | 1 raw `font-*`. |
| `SectionTitle` | many *(SHARED)* | ☐ | ☐ | ☐ | 1 raw `font-*`. |
| `RecommendedCourses` | — | ☐ | ☐ | ☐ | 1 raw `font-*`. (Conv-292 ephemeral-dismiss → `[STALE-TESTS]`.) |
| `CourseCatalogCard` | — | ☐ | ☐ | ☐ | `text-[12px]` + `font-medium`; `px-[8px] py-[2px]`. |
| `CourseProgressCard` | — | ☐ | ☐ | ☐ | 3 raw `font-*` + arb-px; `px-[8px] py-[2px]`. |
| `CourseTeachingCard` | — | ☐ | ☐ | ☐ | 1 raw `font-*` + arb-px. |
| `CourseCreatedCard` | — | ☐ | ☐ | ☐ | 1 raw `font-*` + arb-px. |
| `CourseModerationCard` | — | ☐ | ☐ | ☐ | 1 raw `font-*` + arb-px. |

### Route completion (derived)

| Route | Presentation-swept? | Blocking components |
|---|:--:|---|
| `/` | ☐ | all rows above except index.astro / FeedPost(partial) |
| `/courses` | ☐ | all rows except courses.astro / CoursesRoleTabs / CoursesCatalog |

## Open decisions (need your call before migrating)

1. **Unified Feed-Card Spec** (above) — confirm the per-slot tokens, then it locks into §9.4.
2. **Off-scale px snap-or-flag** — these have no scale token: `gap-[10px]`, `gap-[6px]`,
   `mt-[2px]` (cards + anchors), `m-[76px]` (StickySignupBar). Options: **snap** to nearest
   scale (10→8/12, 6→8, 2→4, 76→drop/restructure — small visual change), or **flag** as
   sanctioned exceptions. Per "drop all px", default is snap; I'll list each before changing.
3. **CourseAnchor/CommunityAnchor** are heavily arbitrary-px and *(SHARED)* far beyond
   these two routes — confirm we migrate them now (improves many routes) vs. scope to their
   own unit.

## Status

- Created Conv 298 [TYPO-FDN] Phase 2. Audit of `/` + `/courses` complete (this ledger).
- Next: confirm Open Decisions → migrate per the rows, ☑ as each axis lands, commit per group.
- SoT pair: this ledger (component conformance) + `PLAN.md` ACTIVE § TYPO-FDN (phases) +
  `docs/as-designed/matt-design-system/09-typography.md` (the discipline).
