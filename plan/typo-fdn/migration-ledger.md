# Style-Guide Conformance Ledger — per-component (the RTMIG-4 sweep's conformance checklist)

> **Formerly the "TYPO-FDN migration ledger."** As of **Conv 299** this is the canonical
> **per-route conformance checklist** that the route sweep's **4th "Swept" gate** references
> (Type / Spacing / Colour). TYPO-FDN built the type/spacing foundation + this ledger;
> PALETTE-FDN built the colour foundation; the **per-route application rides the
> [RTMIG-4 sweep](../route-migration/README.md#style-guide-conformance--the-4th-swept-gate-decided-conv-299)** —
> and that section owns the **in/out scope** (RG-ADMIN, RG-PUBLIC, `/old/*` are OUT). The rows
> below cover the two already-Swept routes (`/`, `/courses`, started Conv 298); **in-scope
> routes add their component rows as they are swept.**

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
| **Spacing** | Margin/padding/gap use **scale classes only** (`p-16`, `gap-12`, `mt-4` = Matt px scale via the bridge). **No arbitrary `[Npx]`** for margin/padding/gap. (Widths/heights/radii may stay arbitrary where no scale token exists.) Off-scale values **snap to the nearest scale step** (policy RESOLVED Conv 299, decision 2 below: `6→8`, `10→12`); sub-4px optical nudges + positioning offsets matched to a real element (e.g. `bottom-[76px]`) are sanctioned keeps. |
| **Colour** | Text/bg/border use role tokens (`neutral-*`, `brand-*`, …); **no** raw `text-slate-*`/`text-gray-*`/hex. (Cross-references PALETTE-FDN; this ledger tracks its component tail at component granularity.) |
| **Card** | If the component is a **Home feed card**, it conforms to the Unified Feed-Card Spec below — not just "uses some token", but the *same* token per slot as its siblings. |

## Unified Feed-Card Spec — ✅ LOCKED Conv 298 (the canonical card contract)

The Home feed renders ~7 card components of different origins; they must present
**identically** per slot. Derived from `AnnouncementCard` (the token-clean reference).
**✅ Confirmed Conv 298 → locked into style-guide §9.4a** (`docs/as-designed/matt-design-system/09-typography.md`).

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
| `FeedActivityCard` | /communities, /community/[slug], course-feed *(SHARED)* | ☑ | ☑ | ☑ | ✅ **Conv 299 migrate + Conv 300 HOME-VERIFY (DOM-truth).** `p-16`, `w-[80px]` strip-bleed (`-my-16 -mr-16 ml-16`), 3 source tints (course=`info`, community=`neutral` DOM-confirmed; system=`brand` src `:218`), `text-body-small-medium`, no raw type/colour. Re-verify on its other 3 routes when swept. |
| `FeedPost` | — *(wraps SocialPost)* | ☑ | ☑ | ☑ | ✅ **Conv 300.** Wrapper composing `SocialPost`; `gap-12 p-16 rounded-12`. Visible type is `SocialPost`'s — now genuinely tokenized (see that row). Prior "Type ☑" was hollow. |
| `SuggestionCard` | — | ☑ | ☑ | ☑ | ✅ **Done** (Conv 298). badge `font-medium`→`text-body-small-medium`; desc→`text-body-default-prose`, `mt-[2px]`→`mt-4`. |
| `DiscoveryCard` | /discover *(SHARED)* | ☑ | ☑ | ☑ | ✅ **Done** (Conv 298). 🔴 fixed latent bug: `p-4`(4px)→`p-16`, `h-4 w-4`(4px) icons→`size-16`; scale-class spacing; `secondary-100`→`neutral-100`. |
| `CourseAnchor` | many entity surfaces *(SHARED)* | ☑ | ☑ | ☑ | ✅ **Conv 299/300.** `px-20 py-12 rounded-12`; eyebrow/meta tokenized via `EntityPill`/`IconLabelChip` (own rows). Colour role-tokens (`text-entity-primary`, `text-text-tertiary`, `text-primary-default`=americana-blue token ✅). Analytic-count `font-semibold` now tokenized (`text-body-*-bold`, [TYPO-CTA-TOKEN] ✅). |
| `CommunityAnchor` | many *(SHARED)* | ☑ | ☑ | ☑ | ✅ **Conv 299/300.** `px-20 py-12 rounded-12`; eyebrow/meta tokenized via `EntityPill`/`IconLabelChip`. Analytic-count `font-semibold` now tokenized ([TYPO-CTA-TOKEN] ✅). **Exception (C-keep):** 🧠 emoji `text-[20px]` (icon glyph, no token). |

### Shared sub-primitives (render *inside* the cards/anchors above) — added Conv 300

These `@matt-source`/`@matt-inspired` primitives carry the visible type for the feed; tracked here per the **Conv-300 @matt-source policy** (below). Migrating them pre-conforms every consuming surface (verify per-route on each sweep).

| Component | Prov | Type | Spacing | Colour | Notes |
|---|---|:--:|:--:|:--:|---|
| `SocialPost` | `@matt-source` | ☑ | ☑ | ☐ | ✅ **Conv 300** type: author→`text-body-medium-bold` (token encodes the `-0.352px` tracking), timestamp/"in"→`text-body-small`, body→`text-body-default-prose` (lh 22.75→21px, §9.4a). **Colour ☐:** author `text-black` (#000) has no role token — held as a recorded exception (mapping→`text-text-default` would lighten #000→#414141 app-wide). → [TYPO-CTA-TOKEN] sibling decision. |
| `EntityPill` | `@matt-source` | ☑ | ☑ | ☑ | ✅ **Conv 300.** eyebrow → `text-body-small-medium` (exact 12/500/lh-12px, zero-change). |
| `IconLabelChip` | `@matt-inspired` | ☑ | ☑ | ☑ | ✅ **Conv 300.** meta chip → `text-body-small` (12/400/lh-12px). |

### Home (`/`) — non-card

| Component | Also on | Type | Spacing | Colour | Notes |
|---|---|:--:|:--:|:--:|---|
| `index.astro` (layout) | — | ☑ | ☑ | ☑ | Arb-px present are widths/radius (`max-w-[640px]`, `rounded-[16px]`) — allowed, not spacing. |
| `SmartFeed` | — | ☑ | ☑ | ☑ | ✅ **Conv 299/300.** `space-y-16` → 16px rendered gaps (DOM); no raw type/colour. |
| `OnboardingNudgeBanner` | /courses *(SHARED)* | ☑ | ☑ | ☑ | ✅ **Conv 299/300.** Source-clean (verified via source — doesn't render for onboarded users; re-confirm in-browser on a new-user feed when convenient). |
| `ProgressionNudge` | — | ☑ | ☑ | ☑ | ✅ **Conv 299/300.** DOM-verified (Amanda, S→T): `gap-16 px-20 py-16 rounded-12`, no raw type/colour. |
| `StickySignupBar` | — (visitor) | ☑ | ☑ | ☑ | ✅ **Conv 300 — fully conformant, no edits needed.** `src/components/marketing/StickySignupBar.astro` (`@matt-inspired`): `gap-12 rounded-12 px-16 py-12 mt-8` + sanctioned `bottom-[76px]` offset; type `text-body-default`/`text-body-medium-bold`; colour `text-text-default`/`border-border-default`. CTA = shared `<Button>` primitive (own scope). |

### `/courses`

| Component | Also on | Type | Spacing | Colour | Notes |
|---|---|:--:|:--:|:--:|---|
| `courses.astro` | — | ☑ | ☑ | ☑ | Clean. |
| `CoursesRoleTabs` | — | ☑ | ☑ | ☑ | ✅ **Conv 301.** Owns **zero** presentation — delegates entirely to the shared `RoleTabBar` primitive (markup + Matt-§5 role palette live there). Prior Spacing/Colour ☐ was stale. `RoleTabBar` itself is a separate shared row (verify on its own sweep). |
| `CoursesCatalog` | — | ☑ | ☑ | ☑ | ✅ **Conv 301.** Dispatcher — all spacing is scale-class (`gap-16`, `mb-16`, `p-24`), all colour role-tokens; `rounded-[12px]` = radius (allowed). Prior Spacing/Colour ☐ was stale. |
| `CoursesFilters` | — | ☑ | ☑ | ☑ | ✅ **Conv 301.** "Clear filters" `font-medium`→`text-body-small-medium`; FilterChip hover `bg-[var(--gray-100)]`→`bg-neutral-100` (exact #F1F1F1). |
| `SectionTitle` | many *(SHARED)* | ☑ | ☑ | ☑ | ✅ **Conv 301.** Dropped **redundant** `font-medium` — `text-hN` already applies Matt's Medium (weight 500), so zero visual change app-wide. `text-text-default` already a role token; no spacing of its own. |
| `RecommendedCourses` | — | ☑ | ☑ | ☑ | ✅ **Conv 301 — no edits (already conformant).** Ledger "1 raw font-*" was **stale** (the DISC-DROP restyle fixed it): uses `text-body-medium-bold`/`text-body-small`, `bg-neutral-100`, scale-class spacing. (Conv-292 ephemeral-dismiss → `[STALE-TESTS]`.) |
| `CourseCatalogCard` | RecommendedCourses, /discover, course-detail hero *(SHARED)* | ☑ | ☑ | ☑ | ✅ **Conv 301 (DOM-verified).** badge `text-[12px] font-medium`→`text-body-small-medium` (12/500), CTA `font-medium`→`text-body-small-medium`, `px-[8px]`→`px-8`, dropped redundant `tracking-[-0.352px]` on both titles (token `text-body-medium-bold` provides -0.352px — DOM-confirmed). **Exceptions (C-keep):** `#1f2937` no-thumbnail fallback (= Matt CourseHeader hero; no role token), overlay `rgba(0,0,0,…)` image scrim, hover `shadow-[…rgba…]` (no shadow token; box-shadow ∉ text/bg/border). |
| `CourseProgressCard` | — | ☑ | ☑ | ☑ | ✅ **Conv 301 (DOM-verified, student tab).** badge→`text-body-small-medium`+`px-8`, inline `font-medium`×2 (teacher name, "Share your experience")→`text-body-small-medium`, dropped title tracking. Shadow = C-keep. |
| `CourseTeachingCard` | — | ☑ | ☑ | ☑ | ✅ **Conv 301.** badge→`text-body-small-medium`+`px-8`, paused/revoked pill `bg-[var(--gray-100)]`→`bg-neutral-100`, dropped title tracking. Shadow = C-keep. |
| `CourseCreatedCard` | — | ☑ | ☑ | ☑ | ✅ **Conv 301.** badge→`text-body-small-medium`+`px-8`, draft/retired pill `bg-[var(--gray-100)]`→`bg-neutral-100`, dropped title tracking. Shadow = C-keep. |
| `CourseModerationCard` | — | ☑ | ☑ | ☑ | ✅ **Conv 301 (DOM-verified, moderating tab).** badge→`text-body-small-medium`, `gap-[4px]`→`gap-4`, `px-[8px]`→`px-8`, "Moderating" pill `bg-[var(--gray-100)]`→`bg-neutral-100` (DOM: rgb(241,241,241)=#F1F1F1, identical), dropped title tracking. Shadow = C-keep. |

### `/profile` (RG-PROFILE) — added Conv 301 (tab-by-tab sweep, IN PROGRESS)

Multi-tab route (`profile/[...tab].astro`): Account / Edit Profile / Interests / Payments / Notifications / Security. **⚠️ Scope correction (Conv 301):** the initial per-axis grep only matched arbitrary `[Npx]` and **undercounted spacing** — the 4 settings islands are **full legacy-Tailwind components** (`text-secondary-*`/`bg-secondary-*` slate ramps, `bg-primary-*`, `text-sm`, `font-medium`/`-semibold`, `space-y-6`, `px-6 py-4`, `mt-0.5`) whose legacy **numeric scale classes are off-Matt-scale and collapse-prone** (DOM-confirmed Conv 301: `NotificationSettings` Section header `py-4` renders **4px** not 16px — the NAV-RETROFIT bridge bug; `px-6` → 24px). So each settings tab is a **full 3-axis legacy→Matt restyle** (spacing-collapse fixes + slate→`neutral`/`primary`→`brand` colour map + type tokens), not the light type+colour touch-up first implied. Swept tab-by-tab, cheap-first. **Type also has a gap:** 16px-medium labels (`font-medium`, no size) have no exact §09 token (body-medium=16/400, body-medium-bold=16/600; no 16/500) — needs a per-case call.

| Component (tab) | Type | Spacing | Colour | Notes |
|---|:--:|:--:|:--:|---|
| `[...tab].astro` chrome (Account) | ☑ | ☑ | ☑ | ✅ **Conv 301.** Account-tab chrome (identity/prefs/session Cards). 3 raw-colour spots mapped: avatar circle `bg-[#eef2ff]`→`bg-brand-100`, Help hover `bg-[#f8fafc]`→`bg-neutral-50` (both ~zero change), Sign-out button `border-[#fca5a5]`/`text-[#dc2626]`/`hover:bg-[#fef2f2]`→`border-error-300`/`text-error-300`/`hover:bg-error-100` (intended alignment to the harmonized error palette — border soft-red→crimson). Type/spacing already token-clean. |
| `InterestsSettings` (Interests) | ☑ | ☑ | ☑ | ✅ **Conv 301 — no edits (already conformant):** role tokens throughout, 0 violations. 🟠 Missing `data-prov` stamp → [PROV-STAMP-GAPS] #25 (provenance axis, not conformance). |
| `ProfileSettings` (Edit Profile) | ☐ | ☐ | ☐ | Pending — full legacy restyle. 740 lines; heaviest in the group. |
| `StripeConnectSettings` (Payments) | ☐ | ☐ | ☐ | Pending — full legacy restyle. |
| `NotificationSettings` (Notifications) | ☐ | ☐ | ☐ | Pending — full legacy restyle (DOM-assessed Conv 301): **Spacing** `py-4`→4px collapse / `px-6`→24px / `space-y-6` / `mt-0.5` (needs Matt-scale by intended px); **Colour** slate `secondary-{50/100/200/300/600/900}`→`neutral-*`, `bg-primary-600`/`ring-primary-500`→`brand-*`; **Type** `font-semibold`(16/600 title)→`text-body-medium-bold`, `text-sm`(desc)→`text-body-default`, `font-medium`(16/500 label) → no exact token (per-case call). |
| `SecuritySettings` (Security) | ☐ | ☐ | ☐ | Pending — full legacy restyle. |

### Route completion (derived)

| Route | Presentation-swept? | Blocking components |
|---|:--:|---|
| `/` | ☑ | **CONFORMANCE COMPLETE — Conv 300 [HOME-VERIFY] (DOM-truth, member + visitor).** All 8 component groups ☑ (modulo recorded @matt-source exceptions). |
| `/courses` | ☑ | **CONFORMANCE COMPLETE — Conv 301 [TYPO-FDN] (DOM-verified, member Amanda Lee across catalog/student/moderating + token probes).** All 11 component rows ☑ (modulo recorded exceptions). Full logged-out-visitor visual pass folds into the eventual whole-route re-verify; the catalog card is the same verified component for visitors (only the CTA label differs). |
| `/profile` | ☐ | **IN PROGRESS — Conv 301 (RG-PROFILE tab-by-tab).** Account chrome + Interests tab ☑ (2/6). Blocking: `ProfileSettings` (Edit), `StripeConnectSettings` (Payments), `NotificationSettings`, `SecuritySettings` — Type + Colour pending (spacing already clean). |

## Open decisions (need your call before migrating)

1. ~~**Unified Feed-Card Spec** (above) — confirm the per-slot tokens, then it locks into §9.4.~~ **✅ RESOLVED Conv 298 — confirmed + locked into style-guide §9.4a.**
2. ~~**Off-scale px snap-or-flag**~~ **✅ RESOLVED Conv 299 — SNAP.** Snap off-scale gaps to the
   nearest scale step, preserving the small/large hierarchy: **`gap-[6px]`→`gap-8`**,
   **`gap-[10px]`→`gap-12`** (the latter aligns the main anchor gap with the §9.4a card gap).
   On-scale values written in arbitrary form (`px-[20px]`, `py-[12px]`, `gap-[8px]`, `gap-[16px]`)
   convert to their **equal** scale classes (`px-20`/`py-12`/`gap-8`/`gap-16` — zero visual
   change). **Sanctioned keeps (NOT violations):** sub-4px optical nudges (`py-[2px]`/`mt-[2px]`,
   per the AnnouncementCard precedent) and **positioning offsets matched to a real element** —
   the ledger's "`m-[76px]`" is actually `bottom-[76px]` in StickySignupBar = the mobile
   ControlBar's height, a justified position offset (positioning, not spacing-scale).
3. ~~**CourseAnchor/CommunityAnchor** shared-scope~~ **✅ RESOLVED Conv 299 — MIGRATE BOTH NOW.**
   Shared ⇒ **one ledger row each, migrated once.** Blast radius: CourseAnchor ~8 prod surfaces
   (ReviewsTab, CourseCatalogCard, CourseEmbedCard, EntityLink, EntityPill, FeedPost, SmartFeed,
   SocialPost); CommunityAnchor 2 (DiscoveryCard, SmartFeed). Migrating during the `/`+`/courses`
   backfill pre-conforms the other surfaces in one pass; changes are token-only (px→equal scale
   class, font→token, colour→role), so the 8-surface reach is low-risk. Verify in Home/courses
   context now; other routes re-verify on their own sweep (derived completion).

## @matt-source conformance policy — DECIDED Conv 300

**The Type/Spacing/Colour gate reaches into `@matt-source` primitives, hybrid-style:** tokenize where a role token is **exactly equivalent** (zero visual change — e.g. `text-[16px] font-semibold tracking-[-0.352px]` → `text-body-medium-bold`, whose `-0.022em` letter-spacing = `-0.352px` at 16px); **keep token-less** the values with no exact token, recorded as sanctioned exceptions (below). Small line-height *corrections* toward the §09 spec (e.g. SocialPost body `leading-relaxed` 22.75→21px) count as conformance, not regressions. This supersedes the earlier open question of whether `@matt-source` was in scope; shared primitives now get ledger rows and migrate once (verify per-route on each sweep).

**Recorded exceptions (sanctioned keeps — do NOT flag as violations):**
- `SocialPost` author `text-black` (#000) — no pure-black role token; **not** silently mapped (→`text-text-default` would lighten author names app-wide #000→#414141). Revisit if a near-black token is added.
- `CommunityAnchor` 🧠 emoji `text-[20px]` — icon glyph, no type token.
- **`/courses` card shadows** — every course card's `hover:shadow-[0_4px_12px_rgba(0,0,0,0.10)]` (Conv 301): no shadow token exists in the bridge, and a box-shadow colour is not a text/bg/border fill, so it's outside the Colour rule. Consistent Matt card-shadow across all cards.
- **`CourseCatalogCard` image-area colours** (Conv 301): `#1f2937` no-thumbnail fallback (= Matt's CourseHeader hero colour; no role token) and the overlay variant's `rgba(0,0,0,…)` scrim gradient over the thumbnail. Both are image-backdrop values, no role-token equivalent.
- **`EnrollButton` (NOT a /courses row)** — its legacy render path (`font-semibold`/`text-sm`/`secondary-*`/`primary-600`/`text-amber-800`, arbitrary spacing) is explicitly untouched-for-legacy-call-sites and its Matt-variant `gap-[8px]`/`p-[16px]`/`border-[#eaeff5]` are unswept; not on `/courses`. Conv 301 folded in only the `bg-[var(--gray-100)]`→`bg-neutral-100` token swap. Full conformance rides the course-detail route sweep.
- ~~Entity CTA labels `font-semibold` at 12/14px — no 600-weight token~~ **✅ RESOLVED Conv 300 [TYPO-CTA-TOKEN].** These were `AnalyticCount` (count pills) + ReviewsTab, *not* CTAs (the `<Button>` primitive was already tokenized). Minted `text-body-small-bold` / `text-body-default-bold` (12/14px @ 600, lh 1.0 — §9.2a) + migrated; zero visual change (DOM-verified). Also realizes the formerly-phantom `text-body-default-bold` (closes part of [TYPO-PHANTOM] #34).

## Status

- Created Conv 298 [TYPO-FDN] Phase 2. Audit of `/` + `/courses` complete (this ledger).
- **Migration started Conv 298 — 3/23 rows ☑** (AnnouncementCard, SuggestionCard, DiscoveryCard);
  Unified Card Spec confirmed + locked (Open decision 1 resolved). Code `3d3b0dae` / docs `8578d03`.
- **Open decisions 2 + 3 RESOLVED Conv 299** (snap `6→8` / `10→12`, keep sub-4px nudges +
  `bottom-[76px]`; migrate both anchors now). **All open decisions now closed** — no blockers
  remain. Next: migrate per the rows, ☑ as each axis lands, commit per group. Resume from this ledger.
- **Conv 299 — Home (`/`) backfill CODE-COMPLETE, browser-verify PENDING (rows stay ☐).** All
  **8 Home components** are now code-migrated to conformance: StickySignupBar + FeedPost verified
  **already conformant** (0 edits); CourseAnchor, CommunityAnchor, OnboardingNudgeBanner,
  ProgressionNudge, SmartFeed migrated (group 1, code `24cf8646`); FeedActivityCard migrated
  (group 2, code `02ba8664` — full colour map, 3-way source tint course→info, type tokens, `p-4`→`p-16`
  + coupled strip-bleed + `w-20`→`w-[80px]` collapse fix; reaction-pill geometry preserved pending
  the ReactionButton primitive). tsc + lint green throughout. **Rows below remain ☐ until the whole-route
  browser-verify** (member + visitor, DOM-truth — the [HOME-VERIFY] gate) confirms the spacing-collapse
  fixes, source tints, and colour fidelity; flip the RG-HOME rows ☑ only then. Also fixed a latent
  broken token `text-body-default-bold`→`-medium` (ProgressionNudge) → [TYPO-PHANTOM] grep sweep queued.
- **Conv 300 — [HOME-VERIFY] ran (DOM-truth, member Sarah/Amanda + visitor).** Flipped 7/8 Home component groups ☑ (FeedActivityCard, SmartFeed, ProgressionNudge, OnboardingNudgeBanner, FeedPost, CourseAnchor, CommunityAnchor) + added 3 shared sub-primitive rows (SocialPost/EntityPill/IconLabelChip, migrated this conv). Decided the **@matt-source policy** (above) + 3 recorded exceptions. Code: `SocialPost.tsx`, `EntityPill.tsx`, `IconLabelChip.tsx` (tsc+lint clean). **StickySignupBar then verified conformant (no edits) → RG-HOME conformance COMPLETE, 8/8.** Remaining follow-ups: foundation [TYPO-CTA-TOKEN]; verify `AppNavbar` legacy classes don't leak onto `/` [NAVBAR-LEAK].
- **Conv 300 — [TYPO-CTA-TOKEN] done.** Minted `text-body-small-bold` + `text-body-default-bold` (12/14px @ 600, lh 1.0 — §9.2a) — fills the dense-regime bold gap + realizes the phantom `text-body-default-bold` (closes part of [TYPO-PHANTOM] #34). Migrated `AnalyticCount` + `ReviewsTab` (zero visual change, DOM-verified; `font-semibold` residual now empty on Home). Code: `tokens-typography.css`, `tokens-tailwind-bridge.css`, `AnalyticCount.tsx`, `ReviewsTab.astro`; doc §9.2a. **Note:** ReviewsTab still carries raw hex colours (`#584df4`/`#f6f6f6`/rgba) → /courses Colour backfill ([COURSES-FIXES] #27).
- **Conv 301 — [TYPO-FDN] `/courses` backfill COMPLETE → route conformance-swept.** All 11 `/courses`
  rows flipped ☑ via ~21 token-only edits across 7 components (`SectionTitle`, `CoursesFilters`,
  `CourseCatalogCard`, `CourseProgressCard`, `CourseTeachingCard`, `CourseCreatedCard`,
  `CourseModerationCard`) + the folded-in `EnrollButton` bg swap — all zero-visual-change /
  exact-equivalent: `text-[12px] font-medium`→`text-body-small-medium` (12/500), `font-medium`
  dropped from `text-hN` (already 500), redundant `tracking-[-0.352px]` dropped (token provides it),
  `px-[8px]`→`px-8` / `gap-[4px]`→`gap-4`, `bg-[var(--gray-100)]`→`bg-neutral-100` (#F1F1F1 exact).
  3 stale ledger rows corrected (`RecommendedCourses` already conformant; `CoursesCatalog`/`CoursesRoleTabs`
  own no/­delegated presentation). 5 gates green (tsc / astro-check 0/0/0 across 1434 files / lint / tailwind-v4).
  DOM-verified (member Amanda Lee: catalog + student + moderating tabs; `bg-neutral-100`=rgb(241,241,241),
  title tracking preserved -0.352px after class removal, `text-body-small-medium`=12/500). @matt-source
  policy unchanged; added the /courses shadow + image-area + EnrollButton-legacy recorded exceptions.
- SoT pair: this ledger (component conformance) + `PLAN.md` ACTIVE § TYPO-FDN (phases) +
  `docs/as-designed/matt-design-system/09-typography.md` (the discipline).
