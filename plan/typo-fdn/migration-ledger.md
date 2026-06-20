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
| `EntityPill` | `@matt-source` | ☑ | ☑ | ☑ | ✅ **Conv 300.** eyebrow → `text-body-small-medium` (exact 12/500/lh-12px, zero-change). **Conv 305:** added `muted` variant (`bg-neutral-50` + `text-text-tertiary`) for static/placeholder pills with no entity-cascade backing — adopted by CreatorTab's static "Expertise" tags (CC static-content grey, not a Matt signature). |
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

Multi-tab route (`profile/[...tab].astro`): Account / Edit Profile / Interests / Payments / Notifications / Security. **⚠️ Scope correction (Conv 301):** the initial per-axis grep only matched arbitrary `[Npx]` and **undercounted spacing** — the 4 settings islands are **full legacy-Tailwind components** (`text-secondary-*`/`bg-secondary-*` slate ramps, `bg-primary-*`, `text-sm`, `font-medium`/`-semibold`, `space-y-6`, `px-6 py-4`, `mt-0.5`) whose legacy **numeric scale classes are off-Matt-scale and collapse-prone** (DOM-confirmed Conv 301: `NotificationSettings` Section header `py-4` renders **4px** not 16px — the NAV-RETROFIT bridge bug; `px-6` → 24px). So each settings tab is a **full 3-axis legacy→Matt restyle** (spacing-collapse fixes + slate→`neutral`/`primary`→`brand` colour map + type tokens), not the light type+colour touch-up first implied. Swept tab-by-tab, cheap-first. **Type gap RESOLVED (Conv 302):** 16px-medium labels (`font-medium`, no size) had no exact §09 token (body-medium=16/400, body-medium-bold=16/600; no 16/500) → **CC-minted `--body-medium-medium` (16/500, body regime)** in tokens-typography.css + bridge (`text-body-medium-medium`); applies to all remaining settings-island labels.

| Component (tab) | Type | Spacing | Colour | Notes |
|---|:--:|:--:|:--:|---|
| `[...tab].astro` chrome (Account) | ☑ | ☑ | ☑ | ✅ **Conv 301.** Account-tab chrome (identity/prefs/session Cards). 3 raw-colour spots mapped: avatar circle `bg-[#eef2ff]`→`bg-brand-100`, Help hover `bg-[#f8fafc]`→`bg-neutral-50` (both ~zero change), Sign-out button `border-[#fca5a5]`/`text-[#dc2626]`/`hover:bg-[#fef2f2]`→`border-error-300`/`text-error-300`/`hover:bg-error-100` (intended alignment to the harmonized error palette — border soft-red→crimson). Type/spacing already token-clean. |
| `InterestsSettings` (Interests) | ☑ | ☑ | ☑ | ✅ **Conv 301 — no edits (already conformant):** role tokens throughout, 0 violations. 🟠 Missing `data-prov` stamp → [PROV-STAMP-GAPS] #25 (provenance axis, not conformance). |
| `ProfileSettings` (Edit Profile) | ☑ | ☑ | ☑ | ✅ **Conv 303 (DOM-verified, member Amanda Lee + visitor `/login` redirect).** Full 3-axis restyle — 740 ln, heaviest in the group (sub-components PublicBadge/Input/TextArea/Toggle/Section + 8 form sections). **Colour:** slate `secondary-{200/300/400/500/600/700/900}`→`neutral-*`; **sky `primary-*`→`brand-*` (first tab with sky)** — PublicBadge `text-primary-600 bg-primary-50`→`brand-300/brand-100`, Toggle on-track `bg-primary-600`→`bg-brand-300`, focus rings `primary-500`→`brand-300` (TextArea + Toggle); **red→`error-*`** (Conv-301 precedent: TextArea error border/ring, form-error banner). **Amber/green status banners LEFT** (fieldErrors warning, saveSuccess — no Matt warning/success tokens → PALETTE-FDN #29). **Type:** Section h3→`text-body-medium-bold`, Toggle label→**`text-body-medium-medium` (16/500, matching NotificationSettings per user choice)** + desc→`text-body-default` (14), banners/legend→`text-body-default`, captions→`text-body-small`, PublicBadge `text-xxs`→`text-body-small-medium` (10→12 closest Matt). **Spacing:** bare Matt numerics + off-set normalized; Toggle knob `h-4 w-4`→`h-16 w-16` (collapse-fix), track `h-6 w-11` + translate kept (Switch geometry); badge `px-1.5 py-0.5` sub-scale kept. DOM-truth: badge #584DF4/#ECEBFE/12px, Section border #DADADA, header py16/px24/#F8F8F8, h3 16/600/#1F1F1F, toggle label 16/500/#1F1F1F, desc 14/400/#767676, on-track #584DF4, off-track #DADADA, knob 15.99px. **Tier-2 (2 ripe extractions APPLIED):** loading→`<SkeletonCard rows={2} />`×3, error→`<ErrorRetryCard>`. Deferred → [PROFILE-PRIM-SWEEP]: Toggle→Switch (2nd consumer), TextArea→FormField+textarea primitive. Gates: tsc 0, lint clean, tailwind ✓, build 0, 33/33 ProfileSettings.test, grep-clean. Code `c9d61e6c`. |
| `StripeConnectSettings` (Payments) | ☑ | ☑ | ☑ | ✅ **Conv 303 (DOM-verified, member Amanda Lee, creator-gated payments tab).** Full 3-axis restyle. **Spacing → bare Matt numerics + off-set normalized** (retro-fixed Conv 303 to match the NotificationSettings convention, after an initial `[Npx]`/collapse-only pass): collapse-set bugs `gap-4`→`gap-16`, badge `w-12 h-12`→`w-48 h-48`, `mb-4`→`mb-16`, icons `h-4 w-4`→`size-16`, button `px-4`→`px-16`; **off-set also normalized** `p-6`→`p-24`, `w-6 h-6`→`w-24 h-24`, `gap-2`→`gap-8`, `gap-1`→`gap-4`, `mb-1`→`mb-4`, `px-2`→`px-8`, `py-2`→`py-8`, `p-3`→`p-12`, `mt-2`→`mt-8` (sub-scale `py-0.5`=2px kept). All ∈ Matt scale {4,8,12,16,24,48}. **Colour:** slate `secondary-{200 border / 400 inactive-icon / 600 text / 900 title}`→`neutral-{300/300/500/900}` (border-200→neutral-300, off-state hollow-○ 400→neutral-300, muted-text-600→neutral-500, title-900→neutral-900). No sky/`primary-*` present. **LEFT (out-of-scope):** status triad yellow/green/red badges + green-✓ checks + `text-red-600` error + purple Stripe brand — no Matt success/warning tokens (converting only red breaks the triad), and purple is the Conv-219 3B honest-orphan. **Type:** `font-semibold`(h3)→`text-body-medium-bold`, `text-sm`(multi-line desc)→`text-body-default-prose`, `text-sm`(label/error)→`text-body-default`, `text-xs font-medium`(status pill)→`text-body-small-medium`, `text-sm font-medium`(warning title)→`text-body-default-medium`, `text-xs`(warning sub)→`text-body-small`; `text-xl` glyph-sizing left. DOM-truth: border #DADADA, row-gap 16px, badge 47.997px, h3 16/600/lh24/−0.352px/#1F1F1F, desc 14/400/lh21/#767676, button px16/fw500, icon 15.99px. Gates: tsc 0, lint clean, tailwind ✓, build 0, 36/36 StripeConnectSettings.test, grep-clean. 🟠 Tier-2: purple button → Matt `<Button>` brand-variant (the connected-state CTA already uses `<Button>`) → [PROFILE-PRIM-SWEEP] (honest-orphan, not ripe solo). |
| `NotificationSettings` (Notifications) | ☑ | ☑ | ☑ | ✅ **Conv 302 (DOM-verified, member Amanda Lee).** Full 3-axis restyle. **Spacing:** `py-4`/`pr-4`(rows) + knob `h-4 w-4` were **collapsing to 4px** (NAV-RETROFIT bridge) → `py-16`/`pr-16`/`h-16 w-16`; card-level `px-6`→`px-24`, `space-y-6`→`space-y-24` (zero-change Matt-scale). **Colour:** slate `secondary-{50/100/200/300/600/900}`→`neutral-{50/100/300/300/500/900}` (text-900→neutral-900, desc-600→neutral-500 muted-text, borders-200→neutral-300, off-track-300→neutral-300, header-bg-50→neutral-50, dividers-100→neutral-100); sky `bg-primary-600`/`ring-primary-500`→`bg-brand-300`/`ring-brand-300`. **Type:** `font-semibold`(h3)→`text-body-medium-bold`, `text-sm`(desc)→`text-body-default`, `font-medium`(16/500 label)→**`text-body-medium-medium`** (CC-minted this conv to fill the 16/500 §09 gap; user-chosen over bump-to-600 / drop-to-14). DOM-truth: label 16px/500/lh24/−0.352px/#1F1F1F, desc 14px/400/#767676, knob 15.99px, ON-track #584DF4, OFF-track #DADADA, header py16/px24/bg#F8F8F8/border#DADADA. Gates: tsc 0, lint clean, build 0, grep-clean. 🟠 Tier-2: Toggle→`Switch` (none in registry) + Section→Card(.astro mismatch) logged → [PROFILE-PRIM-SWEEP] (deferred, not ripe solo). |
| `SecuritySettings` (Security) | ☑ | ☑ | ☑ | ✅ **Conv 303 (DOM-verified, member Amanda Lee + visitor `/login` redirect).** Full 3-axis restyle of the Security island (Section + DeleteAccountModal subcomponents). **Spacing → bare Matt numerics + off-set normalized** (Section `px-6 py-4`→`px-24 py-16`, `space-y-6`→`space-y-24`, modal `p-4/p-6`→`p-16/p-24`, `gap-3`→`gap-12`, icon `w-5 h-5`→`w-20 h-20`, buttons `px-4 py-2`→`px-16 py-8`; collapse-set bugs + off-set both). **Colour:** slate `secondary-{200/300/500/600/700/900}`→`neutral-{300/300/500/500/700/900}` (titles-900→900, strong-labels-700→700, desc/muted-600/500→500, borders→300, header-bg-50→50, code-bg-100→100); **red danger → `error-*`** following the Conv-301 account-chrome precedent: `text-red-600`→`error-300`, `red-700/800/900`→`error-500`, `bg-red-600`+`hover:bg-red-700`→`bg-error-300`+`hover:bg-error-500`, `bg-red-50`→`bg-error-100`, `border-red-200`→`border-error-300`. **Type:** `font-semibold`(Section h3)→`text-body-medium-bold`, `font-medium` 16px labels→**`text-body-medium-medium`**, `text-sm`→`text-body-default`/`-default-medium`, modal `text-xl font-bold`→`text-h3-bold` (20/600). DOM-truth: non-danger border #DADADA, header py16/px24/bg#F8F8F8, h3 16/600/#1F1F1F, label 16/500/#1F1F1F, desc 14/400/#767676, danger border #E11D3F (error-300), danger h3/label #B0102F (error-500), Delete btn bg#E11D3F/px16/py8/fw500. **Tier-2 (2 ripe extractions APPLIED):** loading→`<SkeletonCard rows={1} />`×4, error→`<ErrorRetryCard>` (both already used by sibling StripeConnect). Deferred → [PROFILE-PRIM-SWEEP]: red `<Button>` danger variant, modal Cancel→`outlined`, `DeleteAccountModal`→Modal primitive. Test updated (`border-red-200`→`border-error-300`). Gates: tsc 0, lint clean, tailwind ✓, build 0, 29/29 SecuritySettings.test, grep-clean. |

### `/course/[slug]/[...tab]` (RG-COURSES backfill — IN PROGRESS, Conv 304 → [CDETAIL-CONF])

Course-detail hub swept Conv 295 under the **pre-gate** legacy-port standard; this is the conformance 4-gate backfill (Type/Spacing/Colour). Hub-first, then `/book` + `/success`. **15 components assessed; colour axis nearly clean** (no slate/gray/legacy; residue is `@matt-source` arbitrary type + a few hexes). Full per-component remaining list + decided conventions live in **[CDETAIL-CONF]** (task) / RESUME-STATE.

| Component | Type | Spacing | Colour | Notes |
|---|:--:|:--:|:--:|---|
| `[...tab].astro` shell · `Card` · `SectionTitle` · `ProgressionNudge` · `CheckoutCancelToast` | ☑ | ☑ | ☑ | **Clean** (5 components, no work). |
| `SubNav` · `SubNavItem` *(SHARED nav)* · `ResourcesTab` | ☑ | ☑ | ☑ | ✅ **Conv 306 — prior "clean" ☑ was STALE** (predated the snap policy; SubNav last touched Conv 244). Browser-verify (enrolled member) caught off-scale `gap-[10px]`/`p-[10px]`/`gap-[6px]`/`px-[10px]`/`pr-[10px]`/`py-[6px]` in SubNav tab links + progress block, and `gap-[15px]` in ResourcesTab; snapped to scale (`gap-12`/`p-12`/`gap-8`/`py-8`/`gap-16`). SubNav SHARED with `/profile` + every tabbed route — snapped once, propagates (DOM-verified `/profile` no-regression). |
| `TeachersTab` | ☑ | ☑ | ☑(exc) | ✅ **Conv 305** — spacing→scale (snapped `gap-[15px]`→`gap-16`, `gap-[6px]`→`gap-8`; `gap-[20px]`→`gap-20`, `p-[20px]`→`p-20`, `gap-[8px]`→`gap-8`); dropped redundant person-name `tracking-[-0.352px]`. **(Prior Spacing ☑ was stale — predated the §170 snap carve-out; surfaced + fixed Conv 305.)** **Colour exc:** person-name `text-black` (#000, SocialPost precedent). |
| `CourseHeader` *(SHARED hero)* | ☑ | ☑ | ☑(exc) | ✅ **Conv 304** type: hero `font-bold` 700→`text-h1-bold` (600), `text-h3-bold`, `text-body-medium-medium`. ✅ **Conv 305 Spacing — off-scale SNAPPED to scale** (user chose snap-over-matt-exception even though Figma `517:8935` verified `px-[60px]`/`gap-[10px]`/`gap-[19px]` were Matt's *exact* values — overrides §170 "keep as exception" for the spacing axis): `px-[60px]`→`px-64`, `gap-[10px]`→`gap-12` (tie 8↔12 → round-half-up), `gap-[19px]`→`gap-20`; on-scale arbitraries→scale classes (`py-40`/`gap-32`/`gap-16`/`gap-8`×2/`gap-4`). Colour exc: rgba scrim + `#1f2937` fallback + `text-white` (no token). |
| `AnalyticCount` *(SHARED primitive)* | ☑ | ☑ | ☑(exc) | ✅ **Conv 304** — EXTENDED with `trigger` variant (backward-compat). `#f6f6f6`+`rgba(88,77,244,.14)` = documented Matt signature (recorded exception at primitive). **Back-pointer: swept consumers = `/` (SocialPost), `/course/[slug]` (ReviewsTab).** |
| `ReviewsTab` | ☑ | ☑ | ☑ | ✅ **Conv 304** — 3 pills → `<AnalyticCount>` (raw `#584df4`/`#f6f6f6` now owned by primitive); prose-token; name-tracking dropped. `text-black` name = kept (SocialPost #000 precedent); 👍💕💬 emoji = kept. |
| `CreatorTab` | ☑ | ☑ | ☑(exc) | ✅ **Conv 305 — 3 axes (browser-verified Conv 306).** Type: TagPill `text-[12px] font-medium`→`text-body-small-medium` (via muted EntityPill), dropped redundant `tracking-[-0.352px]` on person-name (token encodes it). Spacing: all → scale classes; off-scale snapped `gap-[6px]`→`gap-8`, `gap-[10px]`→`gap-12`, `gap-x-[30px]`→`gap-x-32` (ties round up, §170 carve-out). Colour: TagPill→`<EntityPill muted>` (`bg-neutral-50`+`text-text-tertiary`), section headings `text-black`→`text-text-default` (About + `headingC`); `bg-primary-light`/`border-primary-default`/`text-course-primary` = valid role tokens. **Colour exc:** person-name `text-black` (#000) KEPT (SocialPost precedent); `#E0E8FF`/`#584DF4` are in the doc-comment only. |
| `ModulesTab` | ☑ | ☑ | ☑ | ✅ **Conv 305 — 3 axes (browser-verified Conv 306).** Spacing → scale classes; off-scale snapped `gap-[30px]`→`gap-32`, `px-[14px]`→`px-16` (tie↑), `p-[10px]`→`p-12` (tie↑). Type: `text-body-default leading-normal`→`text-body-default-prose` (×2, empty-state + description). Colour clean (role tokens: `text-text-default`/`-tertiary`, `border-border-default`, `bg-student-background`). Kept: `rounded-[12px]`/`rounded-[60px]` (radii), `min-w-[19px]` (width). |
| `MattCourseFeed` | ☑ | ☑ | ☑(exc) | ✅ **Conv 305 (browser-verified Conv 306).** Spacing→scale (snapped `gap-[30px]`→`gap-32`, `gap-[6px]`→`gap-8`; `gap-1`→`gap-4`). Type: `leading-normal`→`text-body-default-prose` ×5, `text-[12px]`→`text-body-small`, dropped person-name `tracking-[-0.352px]`. **Colour exc:** person-name `text-black` (#000, SocialPost precedent). |
| `PrecheckoutContent` | ☑ | ☑ | ☑(exc) | ✅ **Conv 305 (browser-verified Conv 306).** Spacing→scale (snapped `gap-[41px]`→`gap-40`, `px-[60px]`→`px-64`, `gap-[10px]`→`gap-12`, `gap-[19px]`→`gap-20`). Type: hero `text-[32px] font-bold`→`text-h1-bold` (700→600), `font-semibold`→`-bold` tokens (`text-body-small-bold`/`text-h3-bold`/`text-body-default-bold`). Colour: `bg-[#414141]`→`bg-neutral-700` (exact tokenize; differs from CourseHeader's tokenless `#1f2937`). **Colour exc:** hero `text-white` ×3 + scrim (on-dark). |
| `MySessionsTab` | ☑ | ☑ | ☑(exc) | ✅ **Conv 305 (@matt-inspired) — browser-verified Conv 306.** Spacing→scale across all session-card rows (snapped `gap-[10px]`→`gap-12`, `px-[14px]`→`px-16`, `gap-[6px]`→`gap-8`). Type: `font-medium`→`-medium` tokens (default/small per size), `font-normal`→drop, empty-state CTA `font-semibold`→`text-body-default-bold`. **Colour exc:** `text-[7px] font-bold` avatar initials ×3 (known keep), `text-white` on coloured buttons/avatars, `bg-ashy-blue` track (#EAEFF5 primitive, = Border-Default, SubNav precedent — no exact bg role token), `tracking-wide` uppercase eyebrows. |

**Decided conventions (Conv 304):** `text-body-default leading-normal`→`text-body-default-prose` (NOT a leading-drop); hero `font-bold` 700→`text-h1-bold` 600; About-style headings `text-black`→`text-text-default` but **person-name `text-black` kept** (#000 precedent); emoji/scrim/fallback/white/glyph-size = recorded exceptions. Full exception inventory in [CDETAIL-CONF].

### `/course/[slug]/book` + `/course/[slug]/success` (CDETAIL-CONF siblings — Conv 305)

| Component | Type | Spacing | Colour | Notes |
|---|:--:|:--:|:--:|---|
| `book.astro` (page chrome) | ☑ | ☑ | ☑ | ✅ **Conv 305.** `gap-[24px]`→`gap-24`, `gap-[6px]`→`gap-8`; inline `font-medium`→`text-body-default-medium`. Breadcrumb/header already token-clean. |
| `SessionBooking` *(booking wizard, @matt-inspired)* | ☑ | ☑ | ☑(exc) | ✅ **Conv 305 — mostly conformant already from the Conv-242 re-skin.** Spacing already scale-class (only `px-[2px]` sub-scale kept). Type: bare `font-medium`→`text-body-default-medium` (14px `<dl>` rows), `font-normal`→drop, eyebrow `font-medium`→`text-body-small-medium`. **Colour exc:** `bg-white` cards + `text-white` on coloured buttons (no white role token); role tokens (`text-primary`/`neutral-100`/`warning-*`) throughout. |
| `success.astro` (page chrome) | ☑ | ☑ | ☑ | ✅ **Conv 305.** Spacing snaps (`gap-[37px]`→`gap-40`, `gap-[11px]`→`gap-12`, `gap-[19px]`→`gap-20`, `gap-[6px]`→`gap-8`, `p-[10px]`→`p-12`, `px-[14px]`→`px-16`). Type: `text-[24px] font-semibold leading-none`→`text-h2-bold` (24/600 exact), `text-[16px] font-medium`→`text-body-medium-medium` ×3. Colour: Emerson-quote `text-black`→`text-text-default` ×2 (not a person-name). |
| `MilestoneComposer` *(@matt-source 729:15940)* | ☑ | ☑ | ☑(exc) | ✅ **Conv 305.** Spacing→scale (`gap-[11px]`→`gap-12`, `p-[20px]`→`p-20`, `gap-[6px]`→`gap-8`); `leading-normal`→prose; dropped person-name `tracking-`. **Colour exc:** person-name `text-black` (#000, SocialPost precedent). |
| `ExpectationsForm` *(modal)* | ☑ | ☑ | ☑(exc) | ✅ **Conv 305.** `font-semibold` inline→`text-body-default-bold`. **Colour exc:** `bg-black/50` scrim, `bg-white` panel, icon `text-white` (modal chrome, no tokens). |

**CDETAIL-CONF — ✅ COMPLETE Conv 306 (browser-verified, route Swept).** Conv 305 conformed the top-level component *files*; the Conv-306 browser-verify (enrolled member `sarah.miller`/`intro-to-n8n` across about/creator/modules/feed/book/success + visitor on bare-hub/benefits + `/profile` regression, DOM-truth) caught that the snap had **not reached the SHARED sub-components/primitives** the conformed files compose. Snapped those to scale (16 files, deterministic px→nearest 4px step, ties up, ≤2px shifts): `SubNav`/`SubNavItem`, `Button`, `IconLabelChip`, `SocialPost`, `FormField`, `CourseEmbedCard`, `CourseInFeed`, `ReviewsTab`, and the 7 entity anchors (`Course`/`Creator`/`StudentTeacher`/`Module`/`Review`/`Resource`/`Milestone`Anchor). All hub surfaces now render Matt-scale (CourseHeader `px-64`/`gap-12`/`gap-20`, stats `gap-8`, SubNav tabs `12px`). Gates green (tsc/check/lint/build + Button/EnrollButton 22/22). **Back-pointer:** these primitives are shared app-wide — the snap propagates to `/`, `/courses`, `/profile`, feeds (conformance-additive; re-confirm on their sweeps). **Sole residual = logged deferral:** `AnalyticCount`/`Module` reaction-pill geometry `px-[9px]`/`py-[5px]` (the "👍0" pills) kept pending the ReactionButton extraction (ledger Home row); sanctioned `py-[2px]` nudges + `>64px` sticky-header offsets also kept.

### `/messages` (RG-MESSAGES) — Conv 307

| Component | Type | Spacing | Colour | Notes |
|---|:--:|:--:|:--:|---|
| `MessagesCenter` *(island root, @matt-inspired)* | ☑ | ☑ | ☑ | ✅ **Conv 307.** Type: error h2 `text-body-large font-semibold`→`text-h3-bold` (20/600), "Select a conversation" `font-medium`→`text-body-default-medium`. Colour clean (spinner `border-primary-default` = valid americana-blue). Spacing on-scale. Tier-2: "Try Again" → `<Button variant="primary" property1="Small">`. |
| `ConversationList` | ☑ | ☑ | ☑ | ✅ **Conv 307.** Type: h1 →`text-h3-bold`; "Mark all read" + `PILL_BASE` `font-medium`→`text-body-small-medium`; empty-state h3s→`text-body-default-medium`; conv-name conditional `font-semibold/medium`→`text-body-default-{bold,medium}`. Colour: row-hover `bg-[var(--gray-100)]`→`bg-neutral-100`. **Exc (C-keep):** unread count badge `text-[10px] font-medium` (sub-12 glyph, MySessionsTab precedent). Tier-2: empty-state "New Message"→`<Button>`; All/Unread pills→SegmentedPills (un-ripe). |
| `MessageThread` | ☑ | ☑ | ☑ | ✅ **Conv 307.** Type: participant name `font-semibold`→`text-body-default-bold`, empty-state name→`text-body-default-medium`, date-pill `font-medium`→`text-body-small-medium`. Colour: back-hover + date-pill + other-bubble `bg-[var(--gray-100)]`→`bg-neutral-100`. **Exc (C-keep):** own-bubble `bg-primary-default text-white` (valid americana-blue + on-coloured white). Tier-2: send-icon button→IconButton (un-ripe). |
| `NewConversationModal` | ☑ | ☑ | ☑ | ✅ **Conv 307.** Reuses `Modal` + `SearchInput`. Type: user-name rows `font-medium`→`text-body-default-medium`. Colour: search-result hover + selected-user `bg-[var(--gray-100)]`→`bg-neutral-100`. Tier-2: "Start Conversation"→full-width `<Button>`. |
| `Avatar` → `UserIcon` *(@matt-source 1:35)* | ☑ | ☑ | ☑ | ✅ **Conv 307.** Null-state placeholder `bg-[var(--gray-100)]`→`bg-neutral-100`; otherwise delegates to `UserIcon`. |

**RG-MESSAGES — ✅ COMPLETE Conv 307 (browser-verified, route Swept).** Light sweep — Tier-1 already clean (Matt `AppLayout` shell, reuses Modal/SearchInput/UserIcon/MattIcon, all `data-prov` stamped). **Verify-before-counting catch:** `primary-default`/`primary-light` are valid **americana-blue** role tokens (`--Primary-Default`), NOT legacy `primary-*` survivors — ~12 phantom findings avoided. Real work: `--gray-100`→`neutral-100` ×7 (DOM #F1F1F1 exact, zero-change), font-weight→token bundling ×~12, `<Button>` adoption ×3 (colour-neutral — Button `primary` variant resolves to americana-blue, DOM-confirmed r39px / bg #0777B6). DOM-verified member sarah.miller (h1 20/600, conv-name 14/500, thread name 14/600, date-pill rgb(241,241,241), Start-Conversation Button pill full-width) + visitor → `/login?redirect=/messages`; no console errors. Tier-2 deferrals (IconButton, SegmentedPills, CountBadge) logged in the [Tier-2 ledger](../route-migration/tier2-primitive-ledger.md).

### `/notifications` (RG-NOTIFS) — Conv 307

| Component | Type | Spacing | Colour | Notes |
|---|:--:|:--:|:--:|---|
| `NotificationCenter` *(single island, @matt-inspired)* | ☑ | ☑ | ☑(exc) | ✅ **Conv 307.** Self-contained (only MattIcon). Type: `PILL_BASE`/Mark-all/Clear-read/action-link/Load-more `font-medium`→`text-body-small-medium`; empty-state h3 `text-body-large font-medium`→`text-body-large-medium` (20/500 zero-change); notif-title conditional `font-medium/semibold`→`text-body-default-{medium,bold}`. Colour: `bg-[var(--gray-100)]`→`bg-neutral-100` ×7 (system chip + 3 skeletons + PILL_OFF/row/load-more hovers). Spacing already scale-clean (arbitraries = w/h/radii). Tier-2: "Try again"→`<Button variant="primary" property1="Small">`. **Colour exc (C-keep):** per-type icon tints (`text-blue-500 bg-blue-50` … ×18 types) = documented honest-orphan (Matt has no notification-type colour scale); `text-white` on PILL_ON. |

**RG-NOTIFS — ✅ COMPLETE Conv 307 (browser-verified, route Swept).** Twin of RG-MESSAGES — same verify-before-counting catch (`primary-*` = valid americana-blue role tokens) + same light conformance set. DOM-verified member sarah.miller (pills 12/500 active #0777B6, title 14/500 read, type-chip emerald tint preserved, neutral-100 rgb(241,241,241), no console errors) + visitor → `/login?redirect=/notifications`. Tier-2 deferrals (SegmentedPills 3rd inline site, IconButton delete-icon, neutral Load-more) logged in the [Tier-2 ledger](../route-migration/tier2-primitive-ledger.md).

### `/session/[id]` (RG-SESSIONS) — Conv 308

| Component | Type | Spacing | Colour | Notes |
|---|:--:|:--:|:--:|---|
| `SessionRoom` *(island root, @matt-inspired)* | ☑ | ☑ | ☑ | ✅ **Conv 308.** Role tokens throughout (`text-text-*`, `bg-primary-light`, `course-primary/background` all valid — verify-before-counting). Colour: error + cancelled-icon `bg-gray-100`→`bg-neutral-100` ×2. Type clean. Spacing scale-clean (arbitraries = w/h/radii). Tier-2: stuck-message `<textarea>`→`form/Textarea`. |
| `SessionPrepare` | ☑ | ☑ | ☑ | ✅ **Conv 308.** Static prepare surface (Note/ToDoItem/ChatBubble primitives). Colour: composer `bg-gray-100`→`bg-neutral-100`. **Spacing fix:** StaticComposer `gap-10`/`pl-10` (rendered **40px** off-scale via Tailwind base×10) → `gap-12`/`pl-12` (Conv-305 snap, 10→12). **Exc (C-keep):** `bg-white` send-circle (no white token). Composer DOM-verified Conv 308 (temp future-dated session): `gap-12`/`pl-12` = 12px, `bg-neutral-100` rgb(241,241,241); seed restored. |
| `SessionParticipantCard` | ☑ | ☑ | ☑ | ✅ **Conv 308 — clean, no edits.** Role tokens + scale spacing + UserIcon/MattIcon primitives. (Message-icon button logged → IconButton, un-ripe.) |
| `SessionCompletedView` | ☑ | ☑ | ☑ | ✅ **Conv 308.** Colour: `bg-gray-100`→`bg-neutral-100` ×4; **star gold `text-[#f5b800]`→`text-star`** (stale "no token exists" comment retired — `--star` existed since Conv 297, SessionBooking already used it). Type clean (★ glyph sizing now primitive-owned). Tier-2: 5-star widgets (main+sub)→new **`StarRating`**; comment+goals `<textarea>`→`form/Textarea`. |
| `StarRating` *(NEW @matt-inspired primitive)* | ☑ | ☑ | ☑ | ✅ **Conv 308 — extracted.** `ui/StarRating.tsx`, registered. Interactive (integer + hover-preview + `onHoverChange`) + `readOnly` fractional-fill + `showValue`; on=`text-star`, off=`text-border-default`. ★ glyph px (sm14/md20/lg30) = icon-exempt sizing. DOM+screenshot verified (4-gold+1-grey interactive rgb 245,166,35; 4.5 half-star readonly). |
| `SessionBooking` *(/book — backward-pointer)* | ☑ | ☑ | ☑ | ✅ **Conv 308 re-glance.** ★N.N avg badge (×2) → `<StarRating readOnly showValue size="sm">`. Already swept Conv 297; otherwise unchanged. |

**RG-SESSIONS — ✅ COMPLETE Conv 308 (route Swept).** Tier-1 already clean Matt. Headline = **Tier-2 `StarRating` extraction** (unified 3 divergent star colourings — `#f5b800`/`amber-400`/`text-star` — onto `--star`; see [Tier-2 ledger](../route-migration/tier2-primitive-ledger.md)). Conformance: `bg-gray-100`→`neutral-100` ×7 + star gold→`text-star` + composer spacing snap + `Textarea` adopt ×3. Gate tsc 0 / lint 0 / 105 booking tests / prov-clean-for-StarRating. DOM+screenshot verified (completed/rating view, member jennifer.kim; readonly fractional via injected markup under real CSS). **Composer spacing VERIFIED (Conv 308):** seeded a temp future-dated session → early/prepare composer DOM-truth confirms `gap-12`/`pl-12` = 12px (was 40px), `bg-neutral-100` rgb(241,241,241); seed restored. CourseReviewModal (learning, unswept) also adopted StarRating surgically — its other legacy styling deferred to its own route sweep.

### Route completion (derived)

| Route | Presentation-swept? | Blocking components |
|---|:--:|---|
| `/` | ☑ | **CONFORMANCE COMPLETE — Conv 300 [HOME-VERIFY] (DOM-truth, member + visitor).** All 8 component groups ☑ (modulo recorded @matt-source exceptions). |
| `/courses` | ☑ | **CONFORMANCE COMPLETE — Conv 301 [TYPO-FDN] (DOM-verified, member Amanda Lee across catalog/student/moderating + token probes).** All 11 component rows ☑ (modulo recorded exceptions). Full logged-out-visitor visual pass folds into the eventual whole-route re-verify; the catalog card is the same verified component for visitors (only the CTA label differs). |
| `/course/[slug]/[...tab]` + `/book` + `/success` | ☑ | **CONFORMANCE COMPLETE — Conv 306 [CDETAIL-CONF] (DOM-verified, enrolled member + visitor + `/profile` regression).** All hub/sibling components ☑ all 3 axes; Conv-306 browser-verify snapped the shared sub-components/primitives the Conv-305 file-conformance missed (see § course-detail note above). Residual = logged ReactionButton-geometry deferral only. |
| `/profile` | ☑ | **CONFORMANCE COMPLETE — Conv 301–303 (RG-PROFILE tab-by-tab, 6/6).** All 6 islands ☑ DOM-verified (member Amanda Lee + visitor `/login` redirect): Account chrome, Interests, NotificationSettings, StripeConnectSettings (Payments), SecuritySettings (Security), ProfileSettings (Edit). 16/500-label gap resolved (minted `text-body-medium-medium`); status-colour gap (amber/green/Stripe-status) → PALETTE-FDN #29. **Spacing convention standardized: bare Matt numerics + off-set normalized.** Tier-2 deferrals (Switch ×2, Card/Section, Button danger/brand variants, Modal, Textarea) → [PROFILE-PRIM-SWEEP] (full consumer set now known). |
| `/messages` | ☑ | **CONFORMANCE COMPLETE — Conv 307 (RG-MESSAGES, DOM-verified member sarah.miller + visitor `/login` redirect).** All 5 island components ☑ all 3 axes. Light sweep (gray-100→neutral-100 ×7, font-weight→tokens ×~12, `<Button>` ×3 colour-neutral). Tier-2 deferrals → [Tier-2 ledger](../route-migration/tier2-primitive-ledger.md) (IconButton/SegmentedPills/CountBadge). |
| `/notifications` | ☑ | **CONFORMANCE COMPLETE — Conv 307 (RG-NOTIFS, DOM-verified member sarah.miller + visitor `/login` redirect).** Single `NotificationCenter` island ☑ all 3 axes (per-type icon tints = documented honest-orphan C-keep). Light sweep (gray-100→neutral-100 ×7, font-weight→tokens ×7, `<Button>` "Try again"). Tier-2 deferrals → Tier-2 ledger (SegmentedPills 3rd site / IconButton / neutral Load-more). |
| `/session/[id]` | ☑ | **CONFORMANCE COMPLETE — Conv 308 (RG-SESSIONS, DOM+screenshot verified, member jennifer.kim completed-view + david.r).** All island components ☑ all 3 axes. Headline: extracted **`StarRating`** primitive (interactive + readonly fractional-fill). Conformance: gray-100→neutral-100 ×7, star gold→`text-star`, composer spacing snap, Textarea adopt ×3. Early/prepare composer DOM-verified Conv 308 (temp future session, gap/pl = 12px). Tier-2 deferral (IconButton +1 site) → Tier-2 ledger. |

### Conv 306 — finish-sweep pass (the 4 priority routes: `/`, `/courses`, `/profile`, `/course/[slug]`)

Driven to fully Swept across Tier-1 + Typography + Colour + Spacing + ripe Tier-2:

- **Spacing — CLOSED + browser-verified.** The CDETAIL-CONF verify exposed that file-level conformance hadn't reached shared sub-components/primitives; snapped them app-wide (deterministic px→nearest 4px, ties up, sub-4px nudges + `>64` offsets kept): SubNav/SubNavItem, ResourcesTab, Button, IconLabelChip, SocialPost, FormField, CourseEmbedCard, CourseInFeed, 10 entity anchors, **app-shell nav** (Sidebar/MainNav/NavItem/AppNavbar), AnalyticCount reaction pill (`px-[9px]`/`py-[5px]`→`px-8`/`py-4` — Matt-exact Figma value snapped per the §170 carve-out), Module. Home DOM-verified clean (content + chrome, member); `/profile`/`/courses` spot-verified, no regression.
- **Tier-2 ripe extractions DONE:** `Switch` primitive extracted (`ui/Switch.tsx`, 2 consumers — NotificationSettings + ProfileSettings Toggle rows; 61/61 tests, browser-verified toggles). Reaction-pill geometry closed (AnalyticCount is the shared primitive — no inline dup). FeedActivityCard recolor confirmed already done (Conv 299).
- **Tier-2 — PROFILE-PRIM-SWEEP #32 now FULLY EXTRACTED (Conv 306, "no stragglers"):** `Switch` (ui/Switch.tsx, 2 consumers), `Textarea` (adopt form/Textarea.tsx — bio field), **`SettingsSection`** (new React primitive — the `.astro` Card can't run in islands — with `padded`/`spaced`/`divided` body presets + `danger`; replaces 3 local `Section` fns), `Modal` (conformed: dropped `dark:`/`secondary-*`/`text-lg`/`p-4`-collapse → neutral+tokens+scale, AND fixed a latent backdrop-click bug; adopted for `DeleteAccountModal`), and a CC-owned **Button `danger`** variant (error ramp, beyond Matt's Color-collection) swapping the destructive buttons. Gates green; DOM-verified /profile/security.
- **Colour — status tokens EXIST (correction).** Earlier notes claiming "no Matt success/warning ramp" were wrong: `--success-100/300/500` (Matt greens), `--error-100/300/500` (Matt tint + tuned), and `--warning-100/300/500` (#FEF3E2/#F59E0B/#B45309 — minted amber, parallel to the others) are all defined in `tokens-semantic.css` + exposed as `bg-/text-/border-{success,warning,error}-*`. So status colour is a **mechanical swap**, not a foundation decision. Conv 306 tokenized the profile status banners (ProfileSettings save-warning + success; StripeConnect account-status triad/checkmarks/errors). App-wide there are ~1565 raw `text-/bg-{green,red,amber,yellow}-*` utilities, but **most are legitimate role-tints** (member directory, role badges, discover cards) — only genuine *status* banners swap, per-route as routes are swept. The former Stripe-purple orphan is now **tokenized** (Conv 306): minted `--stripe-100/300/500` (deliberately keeping Stripe's brand-purple cue, just no longer raw `purple-600`). No status/colour stragglers remain on the 4 routes.

**Verdict:** all 4 routes are Swept (Tier-1 + 3 conformance axes + ripe Tier-2). Residual = the PALETTE status-token foundation decision + logged Tier-2 dedup candidates.

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

**⚠️ SPACING-axis carve-out — DECIDED Conv 305 (overrides "keep as exception" for spacing only):** off-scale `@matt-source` spacing **snaps to the nearest 4px scale step** (round-half-up on ties) rather than being kept as a sanctioned exception — **even when Figma confirms the off-scale value is Matt's exact value** (the [CDETAIL-CONF] CourseHeader case: Figma `517:8935` verified `px-[60px]`/`gap-[10px]`/`gap-[19px]` were Matt's literal values, and the user *still* chose snap). Rationale: the [SPACING-4PX-SWEEP] goal is a strict scale, and the bridge only defines the named set `{4,8,12,16,20,24,32,40,48,64}`px — an off-scale arbitrary carries no token and would otherwise leak forever. Snap map: nearest step; **ties round up** (`gap-[10px]`→`gap-12`, `gap-[6px]`→`gap-8`); `px-[60px]`→`px-64`, `gap-[19px]`→`gap-20`, `gap-x-[30px]`→`gap-x-32`. On-scale arbitraries (`gap-[16px]`→`gap-16`) are the zero-change tokenization the main rule already covers. **This carve-out is SPACING-ONLY** — Colour keeps its exception model (the recorded keeps below stand: image-backdrop hexes, scrims, `#000` author names, shadows). First applied: CourseHeader (Conv 305). Governs all remaining [SPACING-4PX-SWEEP] / route-sweep spacing work.

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
