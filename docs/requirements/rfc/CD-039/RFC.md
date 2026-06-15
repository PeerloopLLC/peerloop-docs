# RFC: CD-039 - Single-Column "Twitter-style" Listings

**Source:** [CD-039.md](./CD-039.md)
**Date:** 2026-06-14
**Status:** Open (all 6 open questions resolved with client 2026-06-14 — see table below)
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
- [ ] `/communities` — `CommunitiesCatalog.tsx` (`grid-cols-1 sm:grid-cols-2 xl:grid-cols-3`)
- [ ] `/courses` — `CoursesCatalog` (`grid sm:grid-cols-2 xl:grid-cols-3`)
- [ ] `/members` — `MemberDirectory.tsx` (`grid-cols-1 md:grid-cols-2 lg:grid-cols-3`)
- [ ] `/feeds` — `FeedsDiscoveryGrid.tsx` (`grid sm:grid-cols-2`)
- [ ] `/feeds` — `FeedAllTab.tsx` + `FeedRoleTab.tsx` (`grid sm:grid-cols-2`)
- [ ] Discover course tabs — `ExploreAllTab`, `ExploreTeachingTab`, `ExploreStudentTab`, `ExploreCreatedTab`, `ExploreModerationTab` (`grid sm:grid-cols-2 xl:grid-cols-3`)
- [ ] Discover community tabs — `CommunityAllTab`, `CommunityCreatedTab`, `CommunityMemberTab`, `CommunityTeachingTab`, `CommunityModerationTab` (`grid sm:grid-cols-2`)

#### Shared layout primitive
- [ ] Create a shared centered-column + right-rail layout shell (`@matt-inspired`) reused across the surfaces above (instead of ad-hoc edits to ~15 components)
- [ ] Cap centered card column at **max-width ~640px** (Q3 resolved)
- [ ] Use vertical spacing pattern consistent with `HomeFeed` (`space-y-*`)

### 2. Right Panel (New Feature)

**Core Change:** Add a persistent, sticky right panel beside the centered column. It **hosts the
page's filters when present**, and falls back to a light-blue placeholder elsewhere (Q2 + Q5 resolved).

- [ ] New right-panel component — no persistent right rail exists today (only left sidebars + `AdminDetailPanel` slide-in)
- [ ] Sticky-on-scroll; one consistent shell, content varies per page
- [ ] **Relocate existing filters into the right panel** — `CoursesFilters` (left `w-64` rail on `/courses`) + the Explore-tab filter sidebars move here (Q5 resolved: filters → right panel)
- [ ] Light-blue background placeholder on pages **without** filters (future content TBD)
- [ ] Hide below `lg` so mobile is a pure single column (Q6 resolved)

### 3. Image Standardized Frame (behavior)

**Core Change:** Standardize card images into one **responsive 16:9 frame** — height scales with
screen size but all cards share the same proportion (Q4 + Q4b resolved). Images vary in source
height, so a fixed frame is needed rather than intrinsic/variable heights.

- [ ] Standardize card cover images to a **16:9** frame (matches existing app-wide `aspect-video`)
- [ ] Frame scales responsively with the column width (height tracks screen size)
- [ ] Use `object-cover` within the frame (scales proportionally, no distortion; absorbs minor off-ratio)
- [ ] Add upload guidance / "certain size image" expectation so creators target 16:9 (avoids visible cropping)

### 4. Docs to Update (on implementation)
- [ ] `docs/as-designed/url-routing.md` — note single-column listing convention if it affects routing/shell
- [ ] `docs/reference/_COMPONENTS.md` — grid components + new layout shell / right panel

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
- **Completed:** 0
- **Remaining:** 21
- **Last Updated:** 2026-06-14
