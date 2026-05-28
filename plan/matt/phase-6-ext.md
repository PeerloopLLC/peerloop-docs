# Phase 6 — Extrapolation primitives [MATT-EXEC-EXT]

**Status:** → ongoing (build lazily per page that first requires the primitive)
**Family:** matt
**Spec:** `docs/as-designed/matt-pre-plan.md` §7 + §9 Phase 6

---

## Summary

Phase 6 builds the primitives Matt didn't draw (form-input variants text/email/password/textarea/select, skeleton loader, modal frame, empty-state slot, status pill/toast for Alert/Success/Warning/Info states — Success/Warning/Info scaffolded — flag for Matt v2). Establishes coverage for the ~70 pages Matt didn't draw.

**Build-only-what-each-page-needs:** broader Phase-6 primitives are built lazily by the page that first requires them, not up-front.

## Home-slice DONE (Conv 203)

The RTMIG-4 Home port surfaced 4 gaps:

- `EmptyState.astro` (Recent-Activity empty state; also retrofitted `/dev/saved`)
- `ActionCard.astro` (the 2 dashboard action cards)
- Harvested Material `clock.svg` (icon-provenance entry, source=ours)
- Restyled `OnboardingNudgeBanner` to Matt (MattIcon + tokens + `Button`)

EmptyState + ActionCard registered in `prov-candidates.ts` `PHASE6_EXTRAPOLATION_CANDIDATES` (unmarked = ours; no third marker per `matt-provenance.md §6a`).

## STANDIN-MATT slice (Conv 207)

11 new form/UI primitives landed during the `[STANDIN-MATT]` retrofit pass:

- `Input.tsx` (base text input with leading icon + trailing slot)
- `FormField.tsx` (label + input + error/description, auto id wiring)
- `PasswordInput.tsx` (Show/Hide toggle via text button)
- `Select.tsx` (native select wrapped in Input chrome)
- `SelectableCard.tsx` (large card-as-checkbox/radio)
- `FormBanner.tsx` (tone-coloured error/success/warning/info)
- `FormSection.tsx` (titled section card with header bar)
- `SkeletonCard.tsx` (loading placeholder)
- `ErrorState.tsx` (symmetric with EmptyState)
- `SearchInput.tsx` (Input specialization with leading search icon + clearable)
- `SegmentedPills.tsx` (generic single-select pills, per-option icon)

Detail in [standin-matt.md](standin-matt.md).

## Remaining Phase-6 primitives (deferred to first-needing page)

- Form inputs beyond what's already built (textarea, etc.)
- Skeleton loader (beyond `SkeletonCard.tsx`)
- Modal frame
- Status pill/toast (Alert/Success/Warning/Info — Success/Warning/Info scaffolded as `FormBanner.tsx` tones, flag for Matt v2)

## Folded-in tasks

- **+ live-hero→MattIcon migration** (folded in from `[MATT-ICON-SWAP]` Conv 194): the live `CourseHero.tsx` still uses legacy `@components/ui/icons` React primitives, not MattIcon — migrate when the legacy course page graduates to Matt components.
- **+ deeper mobile breakpoint work** for the `/matt/` course per-tab bodies (folded in from `[CRS-MOBILE]` Conv 194 — literal SubNav scope verified fine, but Matt's frames have a fuller mobile breakpoint not yet built).

## Open icon harvests

- [ ] **[VIDEO-COMMENT-ICN]** Harvest `video_comment` Material icon — VideoClipAnchor currently uses `chat` icon as substitute pending the real icon.
- [ ] **[PLAY-CIRCLE-ICN]** Harvest `play_circle` Material icon — VideoClipAnchor currently uses inline-SVG placeholder.
- [ ] **[HOWTOREG-ICN]** (TodoWrite #20) — Harvest `how_to_reg` Material icon (identified during Happy Path probing).

## Open

- [ ] **[MATT-EXEC-EXT]** (TodoWrite #11, [Opus]) — the umbrella.
- [ ] **[DARK-HERO-VARS]** ✅ COMPLETE Conv 187 — Added `tone="default"|"on-dark"` prop to `IconLabelChip.tsx`. Button dark variant confirmed unneeded.
