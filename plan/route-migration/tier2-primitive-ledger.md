# Tier-2 Primitive Candidate Ledger — route sweep

A running, **route-scoped** ledger of primitive-extraction candidates surfaced during the
RG-* route sweep (see [README.md](README.md)). Companion to the per-component
`/w-prim-candidates` scratch reports — those are point-in-time per component; **this is the
durable cross-route accumulation**.

## Why this exists

- **See the need, not just the trigger.** Rule-of-Three (extract a primitive once the same
  pattern appears 3×) is the *action* threshold — but a candidate seen only once still gets
  logged here, so we can **see it and assess its impact** even when we're not yet acting.
- **Recognize the third instance.** Cross-cutting primitives (FilterTabs, cards, …) reappear
  at multiple routes. Logging each sighting with its site means we *notice* when a pattern
  matures and can extract once, swapping every known call site together — at whatever route
  we're standing on when it ripens.
- **Assess blast radius before acting.** The Impact column records what extraction would
  consolidate (or what breaks if we DON'T), so the extract/defer call is informed.

## How it's used

1. Each route's sweep runs `/w-prim-candidates`; its STRONG candidates get logged here
   (new row, or a new instance-site on an existing row).
2. When a candidate reaches **3 instances** — or its impact justifies acting sooner — extract
   the primitive, swap all listed sites, register it (matt-inspired-registry + `data-prov`),
   and flip it to 🟢 Extracted with the conv.
3. A one-off that we decide is worth extracting anyway (clear win, low risk) can jump
   straight to extraction — the ledger informs that, it doesn't gate it.

**Status:** 🟢 Extracted · 🟡 Watching (instances < 3) · 🔴 Ripe (≥3 — extract next time we touch one) · ⚪ Adopt-existing (a Matt primitive already exists; swap, don't build)

## Candidates

| Candidate | Likely role | Instances (route · site) | Count | Status | Impact / notes |
|---|---|---|---|---|---|
| **DismissButton** | small icon × dismiss | `/` · SmartFeed.tsx:469, AnnouncementCard.tsx:31, SuggestionCard.tsx:95 | 3 | 🟢 Extracted (Conv 291) | `ui/DismissButton.tsx`, registered. Formalized the OnboardingNudgeBanner close pattern. Future sightings → just swap to it. **✅ Reuse gap closed (RG-COURSES, Conv 292):** `OnboardingNudgeBanner.tsx` (the pattern's origin, shared on Home + /courses) now imports + uses DismissButton in both variants (compact + full); the two hand-rolled close buttons removed. Zero visual change (DismissButton owns the same `p-4 rounded-8` close chrome). |
| **FilterTabs / SegmentedControl** | row of filter/role pills, one active | `/` · SmartFeed.tsx:336 (All/From Teachers/Trending/Unseen) · `/courses` · CoursesRoleTabs → **already uses `RoleTabBar`** | 2 | ⚪ Adopt-existing | **Prediction resolved (RG-COURSES, Conv 292):** the consolidation target already exists — `RoleTabBar.tsx` is the vetted role-pill primitive, and CoursesRoleTabs delegates to it (sensor: 0 candidates). The real gap is **SmartFeed's inline filter row (Home) not adopting RoleTabBar/SegmentedPills** — that's a Home/cross-cutting swap, not a /courses build. **Impact: med** (1 inline site to converge). |
| **FilterChip** (removable filter pill) | `<span> ⊃ <button>` active-filter pill with × remove | `/courses` · CoursesFilters.tsx:81 (def) used ~4× inline (:207–217) | 1 | 🟡 Watching | New (RG-COURSES, Conv 292). Sensor `interactive+chrome`. Clean extraction candidate; filter pills very likely recur on **/members** + **/communities** filters → expect Rule-of-Three there. **Impact: med** — consolidates removable-filter-pill chrome across listing routes. |
| **EmptyState** | centered icon + message + optional CTA | `/` · SmartFeed.tsx:354 (empty), :305 (error variant) | 1 | ⚪ Adopt-existing | A Matt **`EmptyState.astro` already exists** — likely ADOPT, not build. Error variant ≈ `ErrorRetryCard` pre-primitive. **Impact: low-med**, mechanical swap. |
| **AnnouncementCard** (vet) | info/callout feed card (left rail) | `/` · feed/AnnouncementCard.tsx | 1 | 🟡 Watching | Now Matt-tokenized (Conv 291) but **UNREGISTERED** (no `data-prov`). Renders on Home; may appear on community feeds. Vet + register when confident it's stable. **Impact: low** (single component, just bookkeeping). |
| **SuggestionCard** (vet) | entity-suggestion feed card | `/` · feed/SuggestionCard.tsx | 1 | 🟡 Watching | Same as above — Matt-tokenized, unregistered. Sibling of `DiscoveryCard` (which IS stamped). **Impact: low.** |
| **ReactionButton / IconButton** | reaction / comment action button | `/` · community/FeedActivityCard.tsx:489, 509 | 1 | 🟡 Watching | `FeedActivityCard` is shared across **every** feed surface (Home, community, course feeds). loop-repeated signal. **Impact: high** if extracted — broad reuse — but needs the design settled. |
| **FormField (Select/Textarea/Input)** | labelled form control | `/` · ui/FormModal.tsx:114/131/144 (conditional — modal only) | 1 | 🟡 Watching | Deeper/conditional (renders only when a modal opens, not first-paint). Forms are everywhere → **high** consolidation potential, but assess under a form-focused route, not a feed one. |

## Cross-cutting Tier-1 token register (Rule-of-Three SOP)

Tier-1 token/styling concerns surfaced during the sweep that are **not** route-specific.
SOP: every concern is logged here with an instance count and a **Rule-of-Three** verdict —
≥3 distinct sites ⇒ **Fix** (consolidate now, at whatever route it ripened on); <3 ⇒ **Watch**.
Logged either way.

| Concern | Instances | RoT | Verdict | Surfaced |
|---|---|---|---|---|
| **`#f1f5f9` neutral placeholder hard-hex** | 13 occ / 9 files (image/skeleton/track bg) | ✅ ≥3 | **✅ FIXED (Conv 292)** — 12 usages → `bg-secondary-100` (className) / `var(--color-secondary-100)` (the conditional CommunityCatalogCard site); 13th occ is the token def itself (kept). Zero visual change (exact-value token). Files: Course{Progress,Teaching,Created,Moderation}Card, CommunityCatalogCard, CommunityRoleFallbackCard, RecommendedCourses (×4), RecommendedCommunities, ProgressBar. **Note:** RecommendedCommunities also has a separate `bg-[#e2e8f0]` skeleton gray (diff value, not in this count) — left for a future pass. | RG-COURSES Conv 292 |
| `rounded-8` / `rounded-12` bare-scale | 25 occ / 16 files | n/a | **Not a violation** — `--radius-8:8px`/`--radius-12:12px` theme tokens; renders identically to `rounded-[Npx]` (bare = token-backed form). Agent's "48px legacy" claim refuted. No action. | RG-COURSES Conv 292 |
| `bg-[#eff6ff]` empty right-panel placeholder | 2 occ / 1 site (ListingShell) | ❌ <3 | **Watch** — single shared-primitive site; not visible on /courses (slot filled by CoursesFilters). Revisit if it spreads or a route shows the empty panel. | RG-COURSES Conv 292 |
| `border-[#066ba4]` Button hover border | 1 occ / 1 primitive | ❌ <3 | **Watch** — documented intentional hardcode (Button.tsx:15). Leave. | RG-COURSES Conv 292 |

## Per-route log

- **`/` (RG-HOME) — Conv 291.** Swept SmartFeed + AnnouncementCard + SuggestionCard (legacy→Matt token migration); extracted **DismissButton**. Logged candidates: FilterTabs, EmptyState (adopt), AnnouncementCard/SuggestionCard vetting, FeedActivityCard buttons, FormField (conditional). Full sensor output: [`.scratch/prim-candidates-components-feed-SmartFeed.md`](../../.scratch/prim-candidates-components-feed-SmartFeed.md). `FeedActivityCard` itself left as-is (mostly-weak signals — already largely Matt).
- **`/courses` (RG-COURSES route 1 of 5) — Conv 292.** Assessed + 2 triggered fixes applied (NOT marked Swept — goal was compliance assessment, not sweep-completion; browser-verify + out-of-scope review still pending). Fixes: `#f1f5f9`→`bg-secondary-100` consolidation (12 usages, RoT-triggered) + DismissButton adopt-swap in OnboardingNudgeBanner. Gate: tsc/lint/astro-check all clean; prov:sweep 7 issues all pre-existing (= [PROV-STAMP-GAPS], none in touched files). Route-own surface (CoursesCatalog, CourseCatalogCard, 4 role cards, CoursesRoleTabs, CoursesFilters) is **clean Matt** — no legacy `primary-*`/`text-sm`/`dark:` survivors. Sensor: CoursesCatalog = 5× `<li>` loop-repeated (substrate around already-extracted cards — dismiss), CoursesFilters = FilterChip (logged 🟡) + a second `<button>` cluster (:218), CoursesRoleTabs = 0 (uses RoleTabBar). Tier-1 flags are all **shared-infra / cross-cutting**, not /courses-specific — see the cross-cutting Tier-1 register below for the Rule-of-Three determinations.
