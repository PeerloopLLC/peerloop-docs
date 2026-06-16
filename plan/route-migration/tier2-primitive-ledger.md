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
| **DismissButton** | small icon × dismiss | `/` · SmartFeed.tsx:469, AnnouncementCard.tsx:31, SuggestionCard.tsx:95 | 3 | 🟢 Extracted (Conv 291) | `ui/DismissButton.tsx`, registered. Formalized the OnboardingNudgeBanner close pattern. Future sightings → just swap to it. |
| **FilterTabs / SegmentedControl** | row of filter/role pills, one active | `/` · SmartFeed.tsx:336 (All/From Teachers/Trending/Unseen) | 1 | 🟡 Watching | Strongly expect 2 more: `CoursesRoleTabs` (RG-COURSES) + community tabs (RG-COMMS). Extract consolidates the active-pill styling (`bg-text-primary text-white` vs ghost). **Impact: med** — touches 3 feed/listing surfaces. |
| **EmptyState** | centered icon + message + optional CTA | `/` · SmartFeed.tsx:354 (empty), :305 (error variant) | 1 | ⚪ Adopt-existing | A Matt **`EmptyState.astro` already exists** — likely ADOPT, not build. Error variant ≈ `ErrorRetryCard` pre-primitive. **Impact: low-med**, mechanical swap. |
| **AnnouncementCard** (vet) | info/callout feed card (left rail) | `/` · feed/AnnouncementCard.tsx | 1 | 🟡 Watching | Now Matt-tokenized (Conv 291) but **UNREGISTERED** (no `data-prov`). Renders on Home; may appear on community feeds. Vet + register when confident it's stable. **Impact: low** (single component, just bookkeeping). |
| **SuggestionCard** (vet) | entity-suggestion feed card | `/` · feed/SuggestionCard.tsx | 1 | 🟡 Watching | Same as above — Matt-tokenized, unregistered. Sibling of `DiscoveryCard` (which IS stamped). **Impact: low.** |
| **ReactionButton / IconButton** | reaction / comment action button | `/` · community/FeedActivityCard.tsx:489, 509 | 1 | 🟡 Watching | `FeedActivityCard` is shared across **every** feed surface (Home, community, course feeds). loop-repeated signal. **Impact: high** if extracted — broad reuse — but needs the design settled. |
| **FormField (Select/Textarea/Input)** | labelled form control | `/` · ui/FormModal.tsx:114/131/144 (conditional — modal only) | 1 | 🟡 Watching | Deeper/conditional (renders only when a modal opens, not first-paint). Forms are everywhere → **high** consolidation potential, but assess under a form-focused route, not a feed one. |

## Per-route log

- **`/` (RG-HOME) — Conv 291.** Swept SmartFeed + AnnouncementCard + SuggestionCard (legacy→Matt token migration); extracted **DismissButton**. Logged candidates: FilterTabs, EmptyState (adopt), AnnouncementCard/SuggestionCard vetting, FeedActivityCard buttons, FormField (conditional). Full sensor output: [`.scratch/prim-candidates-components-feed-SmartFeed.md`](../../.scratch/prim-candidates-components-feed-SmartFeed.md). `FeedActivityCard` itself left as-is (mostly-weak signals — already largely Matt).
