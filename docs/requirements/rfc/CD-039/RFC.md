# RFC: CD-039 - Single-Column "Twitter-style" Listings

**Source:** [CD-039.md](./CD-039.md)
**Date:** 2026-06-14
**Status:** ✅ Closed — implemented Conv 285 (all 21 items; Phases 5–6 subsumed by the root-migration catalogs). All 6 open questions resolved with client 2026-06-14 (see table below).
**Client:** Brian
**Tracked in PLAN.md:** `LIST-1COL` (8-phase plan)

---

## Summary

Convert discovery/catalog **grid** listings to a single, centered, max-width column (one card
per row at all breakpoints, à la Twitter/X). Add a **right panel** (light-blue placeholder) to
absorb the whitespace from capped card width. Ensure card **images retain aspect ratio at any
size**. The personal feed surfaces (`/feed`, `/`) already use the target single-column pattern
and serve as the reference implementation.

---

## Change Requests

### 1. Single Centered Column for Listings (UI/Layout)

**Core Change:** Replace multi-column card grids with a single centered max-width column.

#### Convert grid → single column
- [x] `/communities` — `CommunitiesCatalog.tsx` (`grid-cols-1 sm:grid-cols-2 xl:grid-cols-3`) — Phase 1 (Conv 284)
- [x] `/courses` — `CoursesCatalog` (`grid sm:grid-cols-2 xl:grid-cols-3`) — Phase 2 (Conv 284)
- [x] `/members` — `MemberDirectory.tsx` (`grid-cols-1 md:grid-cols-2 lg:grid-cols-3`) — Phase 3 (Conv 284)
- [x] `/feeds` — `FeedsDiscoveryGrid.tsx` (`grid sm:grid-cols-2`) — Phase 4 (Conv 285)
- [x] `/feeds` — ~~`FeedAllTab.tsx` + `FeedRoleTab.tsx`~~ **(those are legacy `/old/discover/feeds` only)** → live equivalent `FeedsDirectory.tsx` (loading + `FeedSection` + `RoleTabContent` grids) — Phase 4 (Conv 285)
- [x] Discover course tabs — ~~`Explore*Tab` ×5~~ **SUBSUMED (Conv 285):** legacy-only (`/old/discover/courses`); live equivalent `CoursesCatalog` converted in Phase 2. Legacy excluded by route-honesty.
- [x] Discover community tabs — ~~`Community*Tab` ×5~~ **SUBSUMED (Conv 285):** legacy-only (`/old/discover/communities`); live equivalent `CommunitiesCatalog` converted in Phase 1. Legacy excluded by route-honesty.

#### Shared layout primitive
- [x] Create a shared centered-column + right-rail layout shell (`@matt-inspired`) reused across the surfaces above (instead of ad-hoc edits to ~15 components) — `ListingShell.astro`. Phase 1 (Conv 284)
- [x] Cap centered card column at **max-width ~640px** (Q3 resolved) — `columnMaxWidth` default 640. Phase 1 (Conv 284)
- [x] Use vertical spacing pattern consistent with `HomeFeed` (`space-y-*`) — column uses `flex flex-col gap-16`. Phase 1 (Conv 284)

### 2. Right Panel (New Feature)

**Core Change:** Add a persistent, sticky right panel beside the centered column. It **hosts the
page's filters when present**, and falls back to a light-blue placeholder elsewhere (Q2 + Q5 resolved).

- [x] New right-panel component — no persistent right rail exists today (only left sidebars + `AdminDetailPanel` slide-in) — `ListingShell` right panel. Phase 1 (Conv 284)
- [x] Sticky-on-scroll; one consistent shell, content varies per page — `lg:sticky lg:top-24`. Phase 1 (Conv 284)
- [x] **Relocate existing filters into the right panel** — `CoursesFilters` (`/courses`) Phase 2; `CommunitiesFilters` (`/communities`) Phase 1; `MembersFilters` (`/members`) Phase 3. (`/feeds` has no standalone filter rail → placeholder; Explore-tab "sidebars" are legacy `/old`, excluded — see Phases 5–6 subsumed.)
- [x] Light-blue background placeholder on pages **without** filters (future content TBD) — `bg-[#eff6ff]`, used on `/feeds`. Phase 4 (Conv 285)
- [x] Hide below `lg` so mobile is a pure single column (Q6 resolved) — filled panels reflow to top, placeholder is `hidden lg:block`. Phase 1 (Conv 284)

### 3. Image Standardized Frame (behavior)

**Core Change:** Standardize card images into one **responsive 16:9 frame** — height scales with
screen size but all cards share the same proportion (Q4 + Q4b resolved). Images vary in source
height, so a fixed frame is needed rather than intrinsic/variable heights.

- [x] Standardize card cover images to a **16:9** frame (matches existing app-wide `aspect-video`) — already compliant: `CourseCatalogCard`/`CommunityCatalogCard` `stacked` variant uses `aspect-video`; members=avatars, feeds=icon tiles (N/A). Phase 7 (Conv 285)
- [x] Frame scales responsively with the column width (height tracks screen size) — `aspect-video w-full` does this inherently. Phase 7 (Conv 285)
- [x] Use `object-cover` within the frame (scales proportionally, no distortion; absorbs minor off-ratio) — already in place on both catalog cards. Phase 7 (Conv 285)
- [x] Add upload guidance / "certain size image" expectation so creators target 16:9 (avoids visible cropping) — `CourseEditor` already had it; added to `CommunitySettings` cover field. Phase 7 (Conv 285)

### 4. Docs to Update (on implementation)
- [x] `docs/as-designed/url-routing.md` — note single-column listing convention if it affects routing/shell — added "Single-Column Listing Shell" note under Implementation Notes. Phase 8 (Conv 285)
- [x] `docs/reference/_COMPONENTS.md` — grid components + new layout shell / right panel — added "Layout Components" § with `ListingShell` entry. Phase 8 (Conv 285)

---

## Open Questions for Brian

_All resolved with client 2026-06-14 (Conv 284)._

| # | Question | Status | Answer |
|---|----------|--------|--------|
| 1 | **Scope** — all six surface families, or a subset? | ✅ Resolved | **All six families** (communities, courses, members, feeds discovery, discover course tabs, discover community tabs). |
| 2 | **Right panel** — role, sticky, content? | ✅ Resolved | **Hosts the page's filters when present, else light-blue placeholder.** Sticky-on-scroll; one shell, content varies per page. |
| 3 | **Max card width** | ✅ Resolved | **~640px** (slightly wider than Twitter's ~600px to fit richer Peerloop cards). |
| 4 | **Image handling** — crop vs contain vs intrinsic? | ✅ Resolved | **Standardized responsive frame**, NOT intrinsic/variable heights. Height changes with screen size; all cards share one proportion. |
| 4b | **Standard image ratio** | ✅ Resolved | **16:9** (matches existing `aspect-video`), `object-cover`; uploaders target 16:9 ("certain size image" guidance). |
| 5 | **Left filter rails** — keep, relocate? | ✅ Resolved | **Relocate filters into the right panel.** (Client open to this; merges with Q2.) |
| 6 | **Mobile** — hide side panels? | ✅ Resolved | **Yes** — right panel + left rails collapse below `lg`, leaving the pure single column. |

---

## Implementation Priority

| Priority | Item | Effort |
|----------|------|--------|
| High | Shared centered-column + right-rail layout shell | Medium |
| High | Convert grid surfaces to single column (~15 components) | Medium |
| Medium | Right-panel placeholder (light-blue) | Low |
| Medium | Image aspect-ratio policy (pending Q4) | Low–Medium |

---

## Completion Tracking

- **Total Items:** 21
- **Completed:** 21 (Phases 1–4 + 7 implemented; 5–6 subsumed by Phases 1–2; docs + primitive done Phase 8)
- **Remaining:** 0
- **Last Updated:** 2026-06-14 (Conv 285)
