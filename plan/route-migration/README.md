# ROUTE SWEEP — visual-presentation sweep of every route

**The living source of truth for [RTMIG-4].** This is a **full visual-presentation
sweep** of the entire app surface, organized by **route group**. The unit of work is a
**route's `.astro` page**, but its scope is the **whole rendered page** — every component
the route mounts, all the way down. The route is the *entry point* for assessing the
page's visual presentation; we then do whatever Tier-1 / Tier-2 work that assessment turns up.

> **This supersedes the Conv-290 "porting backlog" framing.** Porting is no longer the
> organizing idea — it's just one kind of work a route might need. **Every route is in the
> sweep, including the ones that already look done.** "Ported" vs "unported" is an
> informational column, not a filter. The done-state is **Swept** (assessed + any visual
> work applied + confirmed), not "ported".

## ⛔ Working protocol — the per-route sweep process (canonical; do NOT skip or hurry)

This is the authoritative, multi-conv-resumable process. **Exhaustive assessment is valued
very highly — we are NOT hurrying.** Every route gets a *complete* Tier-1 AND Tier-2
assessment. A new conversation resumes by reading this section + the route checklist below +
the [Tier-2 ledger](tier2-primitive-ledger.md) + any `.scratch/prim-candidates-*.md` reports.

For **each** route, in order:

1. **Assess Tier-1 (visual / token consistency) — exhaustive.** Open the route's `.astro`
   and **walk its entire component tree** (every island + primitive it mounts, all the way
   down — subcomponents are part of the route). Judge: Matt shell/layout conformance
   (e.g. ListingShell for listings), Matt tokens (flag every legacy `primary-*`/`secondary-*`/
   `rounded-lg`/`text-sm`/`dark:` survivor), SubNav correctness, 404-honesty, and whether it
   reuses existing vetted primitives.
   **Cross-cutting Tier-1 concerns** (shared-infra token nits / hard-coded values repeated
   across components — a placeholder hex, a primitive's hard-coded color, a bare-scale utility)
   are logged in the **[cross-cutting Tier-1 token register](tier2-primitive-ledger.md#cross-cutting-tier-1-token-register-rule-of-three-sop)**
   with a **Rule-of-Three** verdict: **≥3 distinct sites ⇒ Fix** (consolidate now, at whatever
   route it ripened on); **<3 ⇒ Watch**. **Logged either way** — that's the SOP. (Same
   Rule-of-Three discipline the Tier-2 ledger applies to primitives, here applied to
   token/styling concerns. First verify the concern is real before counting — e.g. a
   token-backed utility that only *looks* legacy is not a violation.)
2. **Assess Tier-2 (primitive extraction) — complete, via the ledger.** Run
   `/w-prim-candidates` on the route's key components (the sensor walks the import graph).
   **Log EVERY STRONG candidate in the [Tier-2 ledger](tier2-primitive-ledger.md)** — route ·
   site · instance count · status · impact — *including one-offs* (we record the need + assess
   impact even when Rule-of-Three isn't met). This is the complete Tier-2 pass; nothing is
   skipped, only deferred-with-a-record.
3. **Surface** — present the full Tier-1 + Tier-2 assessment: what the route has, the Tier-1
   work it needs, and every Tier-2 candidate with its impact + a recommended extract-now /
   watch disposition.
4. **Pause for refinements** — **STOP and wait.** The user may add, remove, or reframe scope.
   **Do not edit code before this checkpoint clears.**
5. **Do the work** — apply agreed Tier-1 fixes + the *ripe* Tier-2 extractions (register new
   primitives in `matt-inspired-registry.ts` + `data-prov` stamp; update the ledger row to
   🟢 Extracted). Un-ripe candidates stay logged. Likewise apply any **Rule-of-Three-triggered
   cross-cutting Tier-1 fixes** from the [register](tier2-primitive-ledger.md#cross-cutting-tier-1-token-register-rule-of-three-sop)
   (≥3 sites — consolidate every known site, not just this route's); <3-site concerns stay
   logged as Watch.
6. **Browser-verify** — run the gate (`tsc` / `astro check` / `lint` / `prov:sweep`), then
   **view the route in-browser** across relevant states (member + visitor + any conditional
   cards/empty/error). DOM-verify (`getComputedStyle`/`getBoundingClientRect`) where precision
   matters — gates don't catch CSS (see the `bg-primary`→`bg-text-primary` Conv-291 lesson).
7. **User out-of-scope review (final step — user-driven).** The user inspects the rendered
   page and decides whether anything they saw should be fixed but falls **outside Tier-1/Tier-2
   scope**. If so, **create a dedicated per-route task** (`[<ROUTE>-FIXES]`) and record the
   user's list there. **CAPTURE, do NOT solution or fix** — these are noted for *eventually*,
   when that route's task is worked; do not discuss them to resolution or act on them now.
   **Store CC's research/analysis inline with each item** (the user welcomes comments — e.g.
   root-cause, affected components, design options). The task is a **living per-route list**:
   it grows over time and is **consulted as the sweep proceeds** (a fix noted on one route may
   inform another). If nothing out-of-scope, skip.
8. **Mark Swept** — tick the route row ☑ in the checklist below + note what landed. **Swept =
   Tier-1 done + Tier-2 fully assessed (ripe extracted, rest logged in the ledger) +
   browser-verified + the user's out-of-scope review done** — plus, **for in-scope routes**,
   **style-guide conformance**: every component the route renders is ☑ on Type / Spacing /
   Colour in the [conformance ledger](../typo-fdn/migration-ledger.md) (see § Style-guide
   conformance below for the in/out scope). Un-ripe ledger candidates do NOT block Swept;
   **out-of-scope routes skip the conformance gate** (structural Tier-1/Tier-2 only).

A group task closes when **every** route row under it is ticked Swept.

## Tier-1 / Tier-2 — kinds of work, assessed per route (per `docs/decisions/11-new-routing.md:442`)

Tier is **not** a grouping axis and **not** a per-page phase decided up front — it's a
classification applied **at assessment time** for whatever a given route needs:

- **Tier-1 (do now):** Matt shell + SubNavbar + tokens + swap to *existing* vetted
  primitives + 404-honest routing.
- **Tier-2 (extract):** extract *new* primitives / extend existing ones — evidence-driven,
  Rule-of-Three. Done in-line for the route when the assessment calls for it (no longer a
  single deferred cross-cutting pass; that Conv-219 framing is relaxed for the sweep).

**Cross-route candidates accumulate in the [Tier-2 Primitive Candidate Ledger](tier2-primitive-ledger.md).**
Each route's `/w-prim-candidates` run logs its STRONG candidates there with their site +
instance count, so a cross-cutting primitive (FilterTabs, shared cards, …) gets extracted at
whatever route completes its Rule-of-Three — and one-offs stay visible for impact assessment
even when we're not yet acting. A route can be marked **Swept** with un-ripe Tier-2 candidates
still logged (Swept = Tier-1 done + assessed + *ripe* primitives extracted), not exhausted.

## Style-guide conformance — the 4th "Swept" gate (DECIDED Conv 299)

Beyond Tier-1 (shell/tokens/primitives) and Tier-2 (primitive extraction), an in-scope
route's components must **conform to the style guide on three axes** before the route is Swept.
The route sweep *applies* this layer — the foundations (tokens + discipline) are already built
by **PALETTE-FDN** (colour) and **TYPO-FDN** (type/spacing); the **per-route application rides
this sweep**, exactly as PALETTE-FDN's per-route colour migration already does.

| Axis | Conform to | Foundation |
|------|-----------|-----------|
| **Type** (incl. line-height) | §09 `text-body-*` / `text-hN` role tokens — no `text-[Npx]`, no Tailwind `text-xs/sm/…`, no ad-hoc `leading-*` / raw `font-*` | TYPO-FDN · `docs/as-designed/matt-design-system/09-typography.md` |
| **Spacing** | Matt px scale classes (`p-16`, `gap-12`, `mt-4`) — no arbitrary `[Npx]` for margin/padding/gap; off-scale snaps or is flagged | TYPO-FDN · `[SPACING-4PX-SWEEP]` |
| **Colour** | role tokens (`neutral-*`, `brand-*`, status hues) — map-or-flag; no raw `text-slate-*`/hex | PALETTE-FDN · `docs/as-designed/matt-design-system/05-color-and-tokens.md` |

(Home feed cards additionally conform to the **Unified Feed-Card Spec**, style-guide §9.4a.)
Line-height is **not** a separate axis — the `text-body-*` tokens bundle size+weight+line-height,
so the Type gate covers it.

**The checklist is the [conformance ledger](../typo-fdn/migration-ledger.md)** (component-SoT,
per-axis ☐/☑, route-completion derived): a route is conformance-complete ⟺ every component it
renders is ☑ on all three axes. **Built-in from the start** on routes swept from here on;
**backfilled** on the two already-Swept routes (`/`, `/courses` — started Conv 298, 3/23).

### Conformance scope — which groups get the gate (DECIDED Conv 299)

The gate is **not** app-wide — only user-facing surfaces that matter now. Out-of-scope routes
still get the **structural** Tier-1/Tier-2 sweep; they skip the type/spacing/colour pass.

| | Groups |
|---|---|
| **IN — conformance rides the sweep** | RG-HOME, RG-COURSES *(both backfill)*, RG-COMMS, RG-DISCOVER, RG-MESSAGES, RG-NOTIFS, RG-PROFILE, RG-SESSIONS, RG-PUBPROF, **RG-MOD** (hangs off `Sidebar.tsx`), **RG-WORKSPACES** (IN despite the ⛔ client block), **RG-AUTH** |
| **OUT now — structural sweep only** | `/old/*` (deletion-bound, not a group), **RG-ADMIN** (`/admin/*`, internal), **RG-PUBLIC** (15 marketing pages — redesign-likely) |

Excludes ~31 routes (admin 16 + public 15) + all `/old/*`. **Revisit** RG-PUBLIC if the
marketing redesign lands; **revisit** RG-ADMIN if the admin surface gets a design pass.

## Cross-cutting / shared-surface handling — the backward-pointer (DECIDED Conv 304)

**The "done" definition this enforces.** A route is **Swept = done = client-showable**: every
surface it renders (route-local *and* shared, as they appear on this route) either conforms or
carries a **consciously-approved exception** — full stop, no "almost done, will look right once
the whole sweep finishes." A shared component is brought to conformance the **first** time any
route sweeps it, and **conformant-is-conformant** — it is not re-touched on later routes that
merely consume it. The residual unknown therefore lands **only on unswept routes** (unknown by
definition), never on a done one. This is deliberately better for the client demo: every swept
page can be shown as finished.

**The one seam, and its catch.** The model holds *as long as* a conformed shared surface never
has to change again. Two cases break that — and only these:

1. **Context-dependent shared components** — a comp conformant on route A may need a genuine
   change when route C's sweep hits it in a different context (narrower column, new variant).
   That change propagates **backward** to A. *(Live example: `FeedActivityCard` renders 3
   source-tints across surfaces — ledger-flagged "re-verify on its other routes when swept".)*
2. **Unlocked foundations** — a PALETTE-FDN / spacing / type **token** tweak found during a
   later sweep retro-applies to every already-swept route.

**Backward-pointer rule.** For any shared surface with **≥2 swept consumers**, its ledger row
records **which swept routes consume it** (in the existing [Tier-2](tier2-primitive-ledger.md) /
[conformance](../typo-fdn/migration-ledger.md) ledgers — no new artifact). When a later sweep
**changes** that surface, use the back-pointer to **re-glance those swept routes** (usually a
30-second DOM check, often zero change). Surfaces that first-conform and never change never need
a pointer — zero overhead. This is the guarantee that a late change to a shared surface can't
silently regress an already-done route.

**Forward discovery is unchanged** — step 6 still browser-verifies every shared comp *as it
appears on the route being swept*. The back-pointer adds only the **backward** check that
forward verification can't give. Seeding back-pointers for surfaces already shared across the
3 swept groups (RG-HOME/COURSES/PROFILE) before this policy existed → **[XCUT-BACKREF]**.

**`@matt-source` primitives ARE in conformance scope (DECIDED Conv 300, hybrid):** tokenize where
a role token is exactly equivalent; keep token-less specs as recorded exceptions. Shared primitives
(`SocialPost`, `EntityPill`, …) get ledger rows + migrate once. Full policy + exceptions: see the
[conformance ledger § @matt-source policy](../typo-fdn/migration-ledger.md#matt-source-conformance-policy--decided-conv-300).

## Migration policy (Conv 250) — MOVE, don't copy (applies to still-unported rows)

Porting a route **MOVES** the legacy file `/old/X` → `/X`, marks it `@stand-in`, commits
that move as the page's legacy baseline. The `/old` copy is **NOT** retained live.
Reference / rollback = the **preflip worktree** (`peerloop-ref` → `~/projects/Peerloop-preflip`
:4331) + **git history**. `[PREFLIP-WT]` stays alive until **client-vetting complete**.
**Two-step:** (1) **rehost** = `git mv` + `@stand-in` + commit; (2) **Matt port** =
`@stand-in → @matt-inspired` in place, diffing field-by-field against the move-commit
baseline (faithful function+content AND full Matt styling).

## Status legend

| Token | Meaning |
|-------|---------|
| ☐ | Not yet swept |
| ☑ | Swept — assessed, visual work applied, confirmed |
| ⬜ | (port state) legacy-only, needs a root port before/with its sweep |
| 🟦 | (port state) at root as `@stand-in`, awaiting Matt port |
| ✅ | (port state) root `@matt` page live — still gets swept |

## Group summary (14 groups · ~50 routes · full surface)

| Group (TodoWrite) | Routes | Port state | Sweep notes |
|-------------------|--------|-----------|-------------|
| **[RG-HOME]** | `/` (1) | ✅ | feed-led home (SmartFeed **permanent** here); Tier-1 = ListingShell alignment fix. **Conformance COMPLETE 8/8 ☑ — Conv 300 [HOME-VERIFY] (DOM-truth, member+visitor)** (modulo recorded @matt-source exceptions). |
| **[RG-COURSES]** ✅ | courses + course/[slug]/{[...tab],book,success} (4; `/precheckout` REMOVED Conv 297) | ✅ | **COMPLETE Conv 297 — 4/4 swept.** `/book` colour-mapped onto PALETTE-FDN; `/success` clean + ExpectationsForm retrofit ([EXPECTATIONS-MATT]) + app-wide ([ALERT-TUNE]); `/precheckout` removed (subnavbar remnant → `/benefits` tab). folds COURSEDETAIL-DEAD. |
| **[RG-COMMS]** | communities, community/[slug]/[...tab] (2) | ✅ | ☑ **SWEPT (Conv 311)** — Conv-310 slice (5 islands) + Conv-311 [RGCOMMS-VERIFY] ✅ + [RGCOMMS-FEEDS] ✅ (CommunityFeed/SystemFeed/CommentSection feed bodies, full primitive adoption). Gates green; DOM-truth zero forbidden tokens (member+admin). Residual `Card.astro` `rounded-12` no-op **✅ now FIXED Conv 311** (systemic @theme radius registration, [SWEEP-SPACING-GREP] — /community `<Card>`s verified 12px). folds COMMUNITY-FIX bugs |
| **[RG-DISCOVER]** | feed, feeds, members (3) | ✅ | **`/members` ☑ SWEPT Conv 315** (1/3); `/feed`+`/feeds` **likely retire** (SmartFeed now permanent on Home, Conv 291) — group closes on the retire decision; folds FEEDS-FIX bugs |
| **[RG-MESSAGES]** ✅ | messages (1) | ✅ | **SWEPT Conv 307 — 1/1.** Light sweep: gray-100→neutral-100 (×7), font-weight→tokens (×~12), `<Button>` adoption (colour-neutral americana-blue). |
| **[RG-NOTIFS]** ✅ | notifications (1) | ✅ | **SWEPT Conv 307 — 1/1.** Light sweep: gray-100→neutral-100 (×7), font-weight→tokens (×7), `<Button>` "Try again"; per-type tints = honest-orphan C-keep. |
| **[RG-PROFILE]** ✅ | profile/[...tab] (1, multi-tab) | ✅ | **CONFORMANCE COMPLETE — 6/6 tabs (Conv 301–303), route ☑ Swept.** folds CT-RESTYLE / PRIM-MATCH-INDEX / TXTBTN / PROFILE-PRIM-SWEEP |
| **[RG-SESSIONS]** ✅ | session/[id] (1) | ✅ | **SWEPT Conv 308 — 1/1.** Extracted **`StarRating`** primitive (interactive + readonly fractional); `bg-gray-100`→`neutral-100` ×7; star gold `#f5b800`→`text-star`; Textarea adopt ×3; composer `gap-10`/`pl-10`→`gap-12`/`pl-12`. |
| **[RG-MOD]** ✅ | mod (1) | ✅ | **SWEPT Conv 313 — Tranche A (Conv 312) + B + browser-verify.** A = 4 mod-only `Admin*` primitives conformed (3 axes) + double-header fix; B = `ModeratorQueue` chrome (action buttons adopt `Button` w/ new CC-owned `warning`/`suspend` variants; category badges hybrid — priority→status, reason/content-type orphans kept; stat cards + detail body + skeleton). Browser-verified DOM-truth (admin `brian` on bridge :4324). 5 gates green, `ModeratorQueue.test` 58/58 + `Button.test` 5/5. |
| **[RG-WORKSPACES]** | learning, teaching (+courses/[id]), creating (+apply, communities/[slug]) (6) | ✅ shells | ROLE-STUDIOS, ⛔ client-blocked; folds the island restyles |
| **[RG-ADMIN]** | /admin/* (16; 14 `@stand-in` + 2 `@matt-inspired`) | 🟦 | island/body-only port + sweep. **Conformance OUT (Conv 299)** — structural Tier-1/Tier-2 only, no type/spacing/colour pass. |
| **[RG-AUTH]** ✅ | login, signup, onboarding, visitor, 404, reset-password, verify/[id] (7) | ✅ | **SWEPT Conv 314 — 7/7, browser-verified.** Shared auth-modal tree conformed (submit `<button>`s + OAuth → `<Button>`); 2 unported routes ported (reset-password + verify/[id], MOVE old→root). folds RTMIG-MISC |
| **[RG-PUBPROF]** ✅ | @[handle], teacher/[handle], creator/[handle] (3) | ✅ 3/3 | **SWEPT 3/3 — `/@[handle]` + `/teacher/[handle]` Conv 316, `/creator/[handle]` Conv 317.** Creator flattened to hub look (gradient hero→white card), `fetchCreatorProfileData` adopted, `<Button>`+`UserAvatar`+`getRatingDisplay`, Creator-purple badge. **[CCARD-CONF] done** (shared CourseCard 3-axis conformed — only renders live on /creator; FeaturedCourses/CourseBrowse/CourseDetail found dead → logged [OLD-PORTED-CLEANUP]). All 3 DOM-verified coherent (visitor/own/not-found, 0 forbidden tokens, console clean). ROLE-SEMANTICS ✅ Conv 315. |
| **[RG-PUBLIC]** | become-a-teacher + 14 marketing (15) | ⬜ deferred | low-data, redesign-likely; swept last. **Conformance OUT (Conv 299)** — structural only; revisit if the marketing redesign lands. |

**Cross-cutting tasks (NOT route groups):** [RTMIG-4] (umbrella), [ROLE-SEMANTICS]
(✅ resolved Conv 315 — was the RG-PUBPROF gate), [OLD-PORTED-CLEANUP], [PREFLIP-WT],
[E2E-MIG], [E2E-GATE], [ICN-NS], [TZ-AUDIT], [DOCGEN-SPEC], [V217-WATCH], [MEM-PRUNE],
[LAYOUT-SG], [XCUT-BACKREF] (seed shared-surface back-pointers), [CCARD-CONF]
(✅ DONE Conv 317 — shared `CourseCard` 3-axis conformed; footprint corrected to
**5 consumers / renders live ONLY on /creator** — /courses uses `CourseCatalogCard`,
/course/[slug] related-section empty — so no backward-glance needed; `FeaturedCourses`/
`CourseBrowse`/`CourseDetail` import it but are dead → [OLD-PORTED-CLEANUP]),
[PALETTE-FDN] (foundation DONE Conv 296 —
colour role scales + status hues + map-or-flag sweep policy; per-route colour migration of
legacy/`@stand-in` surfaces rides this sweep, mechanical now).

---

## RG-HOME — `/` — **[RG-HOME]**

| Swept | Route | File | Notes (assessment + Tier work — filled at work-time) |
|-------|-------|------|------|
| ☑ | `/` | `index.astro` | **SWEPT Conv 291.** Tier-1: adopted `ListingShell` (centered ~640 feed, `hideRightPanel`), fixing the prior left-aligned `max-w-2xl` feed; token-migrated AnnouncementCard + SuggestionCard (legacy→Matt). Tier-2: extracted **DismissButton** primitive (3 sites); remaining candidates in the [ledger](tier2-primitive-ledger.md). Browser-verified (member+visitor). Out-of-scope fixes deferred → **[HOME-FIXES] #34** (card fonts / type-badge / image-width, filters→panel, panel shown+hideable). SmartFeed PERMANENT here (`/feed`/`/feeds` likely retire); FeedActivityCard NOT yet token-migrated. TRIAGE-RESTYLE deleted. **Conv 296 re-align:** SmartFeed legacy block migrated onto the new PALETTE-FDN tokens (`dark:` removed, error red toned); **FeedActivityCard (57 utils, shared across Home/community/course feeds) recolor DEFERRED** to the ReactionButton/IconButton extraction — deterministic mapping logged in the [ledger](tier2-primitive-ledger.md). **Conv 298 [HOME-RPANEL] (closes part of [HOME-FIXES] #34 = panel shown+hideable):** client wanted Home's dead left gutter killed via a right-side light-blue "Coming Soon" panel that pushes the feed left and grows on wide screens → replaced `ListingShell` with a **bespoke two-column layout in `index.astro`** (feed `lg:w-[640px] lg:shrink-0` anchored left + `<aside class="hidden lg:block lg:flex-1">` light-blue `#eff6ff` growing panel, hides `<lg`). ListingShell's flex model (fixed-panel + growing-list) is the inverse of a decorative absorber, so bespoke beat reuse; Home-only RIGHT (the 4 filter pages keep CD-039 LEFT). DOM-verified 1680/900/2560/1440px; growth bounded by AppLayout's 1248px content-card cap (accepted). Committed `86325970`. **Conv 298 [TYPO-FDN] migration:** AnnouncementCard / SuggestionCard / DiscoveryCard brought to the Unified Feed-Card Spec (3/23 ledger rows ☑); FeedActivityCard type/spacing/colour still tracked in [plan/typo-fdn/migration-ledger.md](../typo-fdn/migration-ledger.md). **Conv 299 conformance backfill — Home CODE-COMPLETE, browser-verify PENDING:** all 8 Home components now code-migrated to the 4th-gate (Type/Spacing/Colour) — StickySignupBar + FeedPost already conformant (0 edits); CourseAnchor/CommunityAnchor/OnboardingNudgeBanner/ProgressionNudge/SmartFeed (code `24cf8646`) + FeedActivityCard (code `02ba8664`, incl. its deferred colour swap + 3-way source tint course→info + the `p-4`/strip/`w-20`→`w-[80px]` bridge-collapse fixes; reaction-pill geometry kept pending ReactionButton). tsc/lint green. **Conv 300 [HOME-VERIFY] — conformance gate now SATISFIED (8/8 ☑, DOM-truth member Sarah/Amanda + visitor).** Browser-verify found the feed's visible type lived in untouched `@matt-source` sub-primitives → decided the **@matt-source hybrid policy** (tokenize-where-equivalent) + migrated `SocialPost`/`EntityPill`/`IconLabelChip` (code `e8a1167b`, 3 new ledger rows); StickySignupBar verified already-conformant (no edits); `[NAVBAR-LEAK]` confirmed AppNavbar legacy classes don't render on `/`; `[TYPO-CTA-TOKEN]` minted `text-body-{small,default}-bold` (12/14px @600) + migrated AnalyticCount/ReviewsTab (code `ea9cce83`); `[TYPO-PHANTOM]` grep clean (zero phantoms). RG-HOME conformance COMPLETE — modulo 3 recorded @matt-source exceptions ([conformance ledger](../typo-fdn/migration-ledger.md#matt-source-conformance-policy--decided-conv-300)). |

## RG-COURSES — `/courses` + course detail — **[RG-COURSES]**

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☑ | `/courses` | `courses.astro` | **SWEPT Conv 292.** Catalog grid (`CourseCatalogCard`, DISC-DROP stretched-link). Tier-1/2: route-own surface clean; cross-cutting fixes — `#f1f5f9`→`bg-secondary-100` token (12 sites, RoT), DismissButton adopt in OnboardingNudgeBanner. Step-7 local fixes done: card image `aspect-video`→`aspect-[8/3]` (2/3 height), Level+Length pills→Select dropdowns (CoursesFilters). Browser-verified (member; dropdowns + shorter cards; no console errors). Deferred → **[COURSES-FIXES] #28**: ⟂ responsive/compact filters ([FILTERS-RESPONSIVE]) + ⟂ app-wide typography ([TYPO-REVIEW]). **Conv 296 re-align:** migrated onto the new PALETTE-FDN tokens — `bg-secondary-100`→`bg-neutral-100` ×8 across Course{Progress,Teaching,Created,Moderation}Card + RecommendedCourses skeleton. |
| ☑ | `/course/[slug]/[...tab]` | `course/[slug]/[...tab].astro` | **SWEPT Conv 295.** `@matt-source` hub (8 tabs). Page shell clean Matt; assessed page + all 14 subcomponents. **No per-route fixes** — 4 hard-hex swaps applied then **reverted** after classifying them as Matt primitive-signature / convention values (not strays): `#f6f6f6`+`rgba(88,77,244,.14)` = `AnalyticCount` Default signature; `#1f2937` = shared no-thumbnail fallback. **Precedent set:** classify hard-hex before swapping (primitive→adopt; convention/recurring→tokenize app-wide; only strays→per-route swap). Candidates logged in [ledger](tier2-primitive-ledger.md): AnalyticCount adopt/extend, TagPill, `#f6f6f6` tokenize-at-primitive, no-image-color (`#1f2937` vs `#414141`) reconcile. EnrollButton dropped (already Matt via `PrecheckoutContent variant="matt"`; legacy path is `/old`-only → dead-code after [OLD-PORTED-CLEANUP] #6). Tier-2 sensor: all loop-repeated substrate. Gate green; browser DOM-verified. Step-7 review: nothing out-of-scope. Hero inset-vs-full-bleed still tracked under [LAYOUT-SG]. **Conv 304 — conformance 4-gate BACKFILL STARTED ([CDETAIL-CONF], multi-conv):** the Conv-295 sweep predates the Conv-299 conformance gate (it was done to the legacy-port standard), so the hub family carries unpaid Type/Spacing/Colour debt. 3 of ~15 components green this conv — `CourseHeader` (hero `font-bold` 700→`text-h1-bold` 600 + 2 type tokens), `AnalyticCount` (EXTENDED with a `trigger` variant), `ReviewsTab` (3 pills adopt `AnalyticCount` + prose tokens). Per-component remaining list + decided conventions live in the [conformance ledger § course-detail](../typo-fdn/migration-ledger.md) + [CDETAIL-CONF]. **Conv 305 — [CDETAIL-CONF] conformance backfill CODE-COMPLETE end-to-end (browser-verify is the only remaining step before this row's conformance can be declared):** resolved the 2 carried-over open questions (TagPill→EntityPill `muted` variant; CourseHeader off-scale spacing) then conformed the whole family — all hub components (CourseHeader, EntityPill `muted`, CreatorTab, ModulesTab, MattCourseFeed, PrecheckoutContent, MySessionsTab, TeachersTab) + sibling routes `/book` + `/success` + their islands (SessionBooking, MilestoneComposer, ExpectationsForm), all 3 axes. 4 code + 4 docs commits, 5 gates green. **Spacing-snap policy GENERALIZED** (§170 carve-out: off-scale `@matt-source` spacing snaps to nearest 4px step, ties up — even Figma-verified Matt literals; Colour keeps its exception model). 🟠 Found + fixed **TeachersTab's stale Spacing ☑** (predated the snap policy) — pre-Conv-305 Spacing ☑ rows across other RG groups may similarly carry off-scale spacing (`[SWEEP-SPACING-GREP]` catches this). **Conv 306 — ✅ CONFORMANCE BACKFILL COMPLETE (browser-verified, DOM-truth: enrolled member `sarah.miller`/`intro-to-n8n` across about/creator/modules/feed/book/success + visitor on bare-hub/benefits + `/profile` regression).** The verify caught that the Conv-305 file-conformance hadn't reached the SHARED sub-components/primitives the conformed files compose — snapped 16 to scale (SubNav/SubNavItem, Button, IconLabelChip, SocialPost, FormField, CourseEmbedCard, CourseInFeed, ReviewsTab, + 7 entity anchors; deterministic px→nearest 4px step, ties up, ≤2px). All hub/sibling surfaces now Matt-scale; gates green (tsc/check/lint/build + Button/EnrollButton 22/22). **Stale "clean" ☑ on SubNav corrected** (last touched Conv 244, pre-snap-policy). Residual = logged ReactionButton-geometry deferral (`AnalyticCount`/`Module` reaction pills `px-[9px]`/`py-[5px]`) only. Shared-primitive snap propagates app-wide (`/`, `/courses`, `/profile`, feeds — conformance-additive). Detail: [conformance ledger § course-detail](../typo-fdn/migration-ledger.md). |
| ☑ | `/course/[slug]/book` | `course/[slug]/book.astro` | `@matt-inspired` (graduated Conv 242). **SWEPT Conv 297.** Tier-1: 30 Tailwind-default colour utils → PALETTE-FDN role tokens (13× `bg-gray-100`→`neutral-100`; red→`error-100/500`; green→`success-100/300`; amber warning family→`warning-100/300/500`; **2× `text-amber-500 ★`→`text-star`** — the map-or-flag catch); 2 stale "honest-orphan" comments retired. No per-route fixes. Tier-2 (🟡 Watch, none ripe): Stepper (:381), teacher SelectableCard (:436), month-nav **IconButton** (:556/570 — app-wide extraction, ledger L42), Calendar/DatePicker (:553–615), time-slot Chip (:648). Verified: tsc/lint clean, zero strays; member DOM-truth (schedule step `bg-neutral-100`→rgb(241,241,241), `text-star`→rgb(245,166,35), all 8 role vars resolve exact); visitor→`/login`. Sensor report: `.scratch/prim-candidates-components-booking-SessionBooking.md`. |
| ➖ | ~~`/course/[slug]/precheckout`~~ | **REMOVED Conv 297** | Subnavbar-experiment remnant (Matt `558:15067`). The content's canonical home is the **`/benefits` SubNav "Enroll" tab** (`[...tab].astro` renders the shared `PrecheckoutContent`); the standalone route was only an alternate host. Deleted `precheckout.astro`; repointed CourseHeader non-enrolled CTA `/precheckout`→`/benefits`. `/precheckout` now **302→`/course/[slug]`** via the catch-all unknown-tab handler (graceful existing behavior, not 404). User decision Conv 297. |
| ☑ | `/course/[slug]/success` | `course/[slug]/success.astro` | **SWEPT Conv 297.** `@matt-source 579:16885`. Page shell + MilestoneComposer already clean Matt. Sweep finding: subcomponent **ExpectationsForm** (one-time post-enroll modal) was unmigrated legacy → **retrofitted** ([EXPECTATIONS-MATT]): adopted FormField + Select + new **Textarea** primitive + Button, mapped red/legacy-ramp → alert/brand role tokens, `@matt-inspired`, behavior preserved (6 fields, ≥20-char validation, POST, skip, char counter). Surfaced + **fixed app-wide** ([ALERT-TUNE]): `--Alert-Default` neon `#FF0038` → `var(--error-300)` `#E11D3F` (23 alert utils / 14 files unified with the Conv-296 error tune). Verified: tsc/lint clean, zero strays; DOM-truth on the live modal (6 FormFields / 4 Selects / 2 Textareas, brand gradient, Save disabled-until-valid, required `*`→#E11D3F). |

## RG-COMMS — Communities — **[RG-COMMS]**

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☑ | `/communities` | `communities.astro` | `@matt-inspired`. **Conv 310 (Option-B slice):** shell clean Matt. Islands swept: RecommendedCommunities (`rounded-8` no-op→`rounded-[8px]`, skeleton `secondary-100`/`#e2e8f0`→neutral), CommunityRoleFallbackCard (`bg-secondary-100`→`bg-neutral-100`); CommunitiesCatalog confirmed already-clean; CommunitiesRoleTabs/Filters clean. CommunityCatalogCard already Matt (shared). **✅ Conv 311 verified:** CommunitiesCatalog DOM-truth zero offenders (no bare `rounded-8`); RecommendedCommunities + CommunityRoleFallbackCard source-clean (`rounded-[8px]` fix @ line 86 + `rounded-[12px]` resolve). |
| ☑ | `/community/[slug]/[...tab]` | `community/[slug]/[...tab].astro` | `@matt-inspired`. Shell + SubNav clean Matt. **Conv 310 (Option-B slice):** full 3-axis restyle of **CommunityMembersTab** (Creator badge purple→brand, Mod badge amber→warning, rows/empty/search neutral, 4px-collapse spacing fixed), **CommunityResourcesTab** (+`<Button>` adopt), **AddCommunityResourceModal** (body restyle + `<Button>` adopt; Modal primitive already in use). **✅ Conv 311 [RGCOMMS-FEEDS] DONE:** CommunityFeed (344) + SystemFeed (430) feed bodies + CommentSection (shared) fully restyled — `secondary`/`slate`→`neutral`, `primary`/`indigo`→`brand`, `red`→`error`, `amber`→`warning`, all `dark:` dropped, 4px-collapse spacing translated to Matt px-scale — plus **full primitive adoption** (`<Textarea>`/`<Input>`/`<Button>`; `<Select>` kept; inline text-actions Reply/View/Delete/Cancel/Clear stay tokenized — no primitive fits). Gates green (tsc/lint/tailwind/astro 0/0/0/0 via /w-codecheck). DOM-truth verified **zero forbidden tokens** live: CommunityFeed + CommentSection (member guy-rymberg, /ai-for-you/feed) + SystemFeed (admin, /system/feed — system feed is admin-only). **Cross-cutting note → [XCUT-BACKREF] #28:** these 3 are shared across ExploreFeeds/MyFeeds/FeedsHub/FeedsDirectory/FeedAllTab/CommunityTabs — swept here, benefits all. Folded bugs: [COMM-TAG-FILTER] (DEFERRED post-prod), [COMMONS-DATE]. **✅ Conv 311 DOM-truth verified** (guy-rymberg, creator of `ai-for-you`): Members Creator badge `bg-brand-100/text-brand-500` (computed rgb 236,235,254 / 58,48,201), Mod badge `bg-warning-100/text-warning-500` (rgb 254,243,226 / 180,83,9) — no purple/amber; Resources + AddCommunityResourceModal **zero offenders**, `<Button>` primitive confirmed. **Cross-cutting finding (NOT a slice defect):** the detail-shell `<Card>` renders bare `rounded-12` → 0px no-op (`ui/Card.astro:40`, app-wide) → routed to [SWEEP-SPACING-GREP], **✅ FIXED Conv 311** (systemic @theme radius fix; /community `<Card>`s DOM-verified 12px). |

> **RG-COMMS status:** ☑ **SWEPT (Conv 311)** — slice (Conv 310 Option B) + both deferrals complete. All islands + the CommunityFeed/SystemFeed/CommentSection feed bodies Matt-conformed (full primitive adoption); gates green; DOM-truth verified zero forbidden tokens live (member + admin). **[RGCOMMS-VERIFY] ✅** — 6 slice islands DOM-truth/source-confirmed (Members brand/warning badges via computed styles, Resources + AddResourceModal zero-offender + `<Button>`, Catalog clean, Recommended/RoleFallback source-clean), verified in the reserved Chrome bridge (transport restored via extension re-login). **Both deferred items DONE (Conv 311):** [RGCOMMS-VERIFY] ✅ + [RGCOMMS-FEEDS] ✅ (feed bodies + CommentSection restyled, full primitive adoption, gates green, DOM-truth zero forbidden tokens member+admin). **The cross-cutting `ui/Card.astro:40` `rounded-12` no-op (app-wide square `<Card>`s, surfaced here but NOT RG-COMMS-specific) is ✅ FIXED Conv 311** — systemic `@theme` radius registration (moved the numeric `--radius-*` scale into the `@theme` block in `tokens-tailwind-bridge.css`; bare `rounded-N` now resolve app-wide, /community + / `<Card>`s DOM-verified 12px); the rounded-N portion of **[SWEEP-SPACING-GREP] #27** is closed (its spacing margin/padding/gap-grep portion remains).

## RG-DISCOVER — Feed / Feeds / Members — **[RG-DISCOVER]**

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☐ | `/feed` | `feed.astro` | SmartFeed. **Likely RETIRE (Conv 291)** — SmartFeed is now a permanent part of Home (RG-HOME); kept for now (deep-links/returnUrl), de-linked from sidebar Conv 258. Don't invest in sweeping until retire decision lands. |
| ☐ | `/feeds` | `feeds.astro` | Discover destination (DiscoverFeedsGrid + "Your Feeds"). **Likely RETIRE (Conv 291)** alongside `/feed`. |
| ☑ | `/members` | `members.astro` | **SWEPT Conv 315.** Shell clean (AppLayout+ListingShell+SectionTitle). 3 islands conformed: Colour `gray-100`→`neutral-100` ×9, Type tokens, Spacing `px-8/py-4` snaps, dropped redundant title `tracking-[-0.352px]`; Tier-2 `<Button>` adopt ×2 (Retry/Clear), Load-More + multi-select filter pills kept hand-rolled (`SegmentedPills` is single-select — logged Tier-2). 4 gates green; user step-7 visual-confirmed clean. Detail-view `/@handle` 404 → RG-PUBPROF (ROLE-SEMANTICS). Folded bugs: [DISCCARD-DEL], [FEED-LANE-RENDER], [STREAM-PURGE], [SHOWMORE] (held client-vet). |

## RG-MESSAGES — `/messages` — **[RG-MESSAGES]**

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☑ | `/messages` | `messages.astro` | **SWEPT Conv 307.** `@matt-inspired` (MSG-PORT Conv 245); island tree = MessagesCenter → ConversationList / MessageThread / NewConversationModal / Avatar→UserIcon. Tier-1 already clean (AppLayout shell, role-token breadcrumb, reuses Modal/SearchInput/UserIcon/MattIcon, all `data-prov` stamped). **Verify-before-counting catch:** `primary-default`/`primary-light` = valid **americana-blue** role tokens (`--Text-Primary`→`--Primary-Default`), NOT legacy `primary-*` survivors — a ~12-finding false alarm avoided. **Conformance (3 axes):** _Colour_ — `bg-[var(--gray-100)]`→`bg-neutral-100` ×7 (DOM #F1F1F1 exact, zero-change); `text-white`/`text-white/70` on coloured surfaces = C-keep (no white token). _Type_ — font-weight bundling ×~12: `text-body-large font-semibold`(20/600)→`text-h3-bold`, `…font-medium`→`text-body-{small,default}-medium`, conv-name conditional `font-semibold/medium`→`text-body-default-{bold,medium}`, date-pill→`text-body-small-medium`; `text-[10px]` unread badge = **C-keep** (sub-12 glyph, MySessionsTab `text-[7px]` precedent). _Spacing_ — already clean (all p/gap/m on scale; arbitraries are w/h/radii). **Tier-2:** adopted `<Button>` (primary variant = americana-blue ⇒ colour-neutral) for the 3 hand-rolled text buttons (Try Again / New Message / Start Conversation); send-icon button + All/Unread filter pills + unread count-badge logged un-ripe in the [Tier-2 ledger](tier2-primitive-ledger.md) (IconButton / SegmentedPills / CountBadge). **Browser-verified (DOM-truth, member sarah.miller + visitor):** h1 20/600, conv-name 14/500, thread name 14/600, date-pill rgb(241,241,241), Start-Conversation `<Button>` pill r39px bg #0777B6 full-width 416px, no console errors; visitor → `/login?redirect=/messages`. Gates: tsc 0, lint 0 (prov:sweep red = pre-existing non-messages debt). |

## RG-NOTIFS — `/notifications` — **[RG-NOTIFS]**

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☑ | `/notifications` | `notifications.astro` | **SWEPT Conv 307.** `@matt-inspired` (NOTIF-PORT Conv 245); surface = single self-contained `NotificationCenter` island (legacy `NotificationsList` serves `/old`, `NotificationSettings` swept under RG-PROFILE). Tier-1 clean (AppLayout shell, role-token breadcrumb, shared `SectionTitle`, MattIcon, data-prov stamped). **Verify-before-counting:** `primary-default`/`primary-light`/`alert-*`/`border-border-default` all valid role tokens; the per-type icon tints (`text-blue-500 bg-blue-50` …) are a **documented honest-orphan** (Matt has no notification-type colour scale — file comment) → **C-keep, untouched**. **Conformance:** _Colour_ — `bg-[var(--gray-100)]`→`bg-neutral-100` ×7 (system chip + PILL_OFF hover + 3 skeletons + row-hover + load-more hover; #F1F1F1 exact). _Type_ — font-weight bundling ×7: `PILL_BASE`/Mark-all/Clear-read/action-link/Load-more `font-medium`→`text-body-small-medium`, empty-state h3 `text-body-large font-medium`→`text-body-large-medium` (20/500 zero-change), notif-title conditional→`text-body-default-{medium,bold}`. _Spacing_ — already clean (scale classes; arbitraries are w/h/radii). **Tier-2:** adopted `<Button variant="primary" property1="Small">` for "Try again"; filter pills→SegmentedPills (3rd inline site), delete-icon→IconButton, neutral Load-more→no Button variant — all logged un-ripe in [Tier-2 ledger](tier2-primitive-ledger.md). **Browser-verified (DOM-truth, member sarah.miller + visitor):** pills 12/500 (active americana #0777B6), title 14/500 (read), type-chip emerald tint preserved, Clear-read 500, neutral-100 rgb(241,241,241), no console errors; visitor → `/login?redirect=/notifications`. Gates: tsc 0, lint 0. |

## RG-PROFILE — `/profile` (own) — **[RG-PROFILE]**

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☑ | `/profile/[...tab]` | `profile/[...tab].astro` | **✅ CONFORMANCE COMPLETE — 6/6 tabs (Conv 301–303).** `@matt-inspired` (folds old/profile + old/settings/*). Tier-2 primitive cluster folds here: [CT-RESTYLE], [PRIM-MATCH-INDEX], [TXTBTN], [PROFILE-PRIM-SWEEP]. **Swept tab-by-tab, all 3 axes, commit per tab.** **Done (6/6):** (1) **Interests** ☑ grep-clean (🟠 missing `data-prov` → folded [PROV-STAMP-GAPS] #25); (2) **Account-page chrome** ☑ — 3 colour spots → role tokens (avatar `bg-[#eef2ff]`→`bg-brand-100`, Help hover `bg-[#f8fafc]`→`bg-neutral-50` both ~zero-change; Sign-out `border-[#fca5a5]`/`text-[#dc2626]`/`hover:bg-[#fef2f2]`→`error-300`/`error-300`/`error-100`). Code `67310d7d`, RG-PROFILE 2/6; (3) **NotificationSettings (Notifications)** ☑ **Conv 302** — full 3-axis restyle, DOM-verified member Amanda Lee: spacing-collapse fixes (`py-4`/`pr-4`/knob `h-4 w-4` → 16px Matt-scale) + slate→`neutral`/sky→`brand` colour map + type tokens; the **16/500-label gap RESOLVED** by minting **`text-body-medium-medium`** (16/500 body regime, tokens-typography.css + bridge, §09 §9.2b). Gates green (tsc/lint/check/build + 28/28 NotificationSettings.test). Tier-2: Toggle→`Switch` (none in registry) + Section→Card(.astro mismatch) → [PROFILE-PRIM-SWEEP]; (4) **StripeConnectSettings (Payments)** ☑ **Conv 303** — full 3-axis restyle, DOM-verified member Amanda Lee (creator-gated tab) + visitor (middleware `/login` redirect): collapse-set spacing fixes (`gap-4`/badge `w-12 h-12`/`mb-4`/icons `h-4 w-4`/button `px-4` → 16px/48px Matt-scale) + slate `secondary-{200/400/600/900}`→`neutral-{300/300/500/900}` + type tokens (`text-body-medium-bold`/`-default-prose`/`-default`/`-small-medium`/`-default-medium`/`-small`; minted 16/500 token N/A here — no 16/500 labels). **Left out-of-scope:** status triad yellow/green/red + `text-red-600` error + purple Stripe brand (no Matt success/warning tokens; purple = Conv-219 3B honest-orphan). Gates green (tsc/lint/tailwind/build + 36/36 StripeConnectSettings.test). Tier-2: purple button → `<Button>` brand-variant → [PROFILE-PRIM-SWEEP]; (5) **SecuritySettings (Security)** ☑ **Conv 303** — full 3-axis restyle (Section + DeleteAccountModal subcomponents), DOM-verified member Amanda Lee + visitor (`/login` redirect): slate→`neutral` + **red danger→`error-*`** (Conv-301 account-chrome precedent: red-600→error-300, red-700/900→error-500, red-50→error-100, red-200→error-300) + type tokens + bare-Matt-numeric spacing. **Tier-2: 2 ripe extractions APPLIED** — loading→`<SkeletonCard>`×4, error→`<ErrorRetryCard>` (both already consumed by sibling StripeConnect); deferred → [PROFILE-PRIM-SWEEP]: red `<Button>` danger variant, modal Cancel→`outlined`, `DeleteAccountModal`→Modal primitive. Test updated (border-red-200→error-300). Gates green (tsc/lint/tailwind/build + 29/29 SecuritySettings.test). **Spacing convention standardized this conv:** bare Matt numerics + off-set normalized (`py-16`/`px-24`, not `[16px]`); StripeConnect (4) retro-fixed to match; (6) **ProfileSettings (Edit)** ☑ **Conv 303** — full 3-axis restyle of the heaviest tab (740 ln, sub-components PublicBadge/Input/TextArea/Toggle/Section), DOM-verified member Amanda Lee + visitor (`/login` redirect): slate→`neutral` + **sky `primary-*`→`brand-*`** (first sky tab: PublicBadge brand-300/100, toggle on-track brand-300, focus rings brand-300) + red→`error-*` + type tokens (Toggle label→16/500 `text-body-medium-medium` per user choice, matching NotificationSettings) + bare-Matt spacing (knob `h-4 w-4`→`h-16 w-16`); amber/green status banners left → PALETTE-FDN #29. Tier-2: loading→`<SkeletonCard>`×3 + error→`<ErrorRetryCard>` APPLIED; Toggle→Switch + TextArea→primitive → [PROFILE-PRIM-SWEEP]. Gates green (tsc/lint/tailwind/build + 33/33 ProfileSettings.test). Code `c9d61e6c`. **RG-PROFILE COMPLETE (6/6)** — `/profile/[...tab]` route fully swept. |

## RG-SESSIONS — `/session/[id]` — **[RG-SESSIONS]**

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☑ | `/session/[id]` | `session/[id].astro` | **SWEPT Conv 308.** Page shell + island tree (SessionRoom → SessionPrepare / SessionParticipantCard / SessionCompletedView, + sibling SessionBooking on `/book`) clean Matt. **Tier-2 EXTRACTED: `StarRating`** (`ui/StarRating.tsx`, interactive + readonly fractional-fill) — unified 3 divergent star colourings (`#f5b800` / `amber-400` / `text-star`) onto `--star`; adopted in SessionCompletedView (main+sub), CourseReviewModal (local StarRow), SessionBooking `/book` readonly avg badge (backward-pointer re-glanced). **Conformance:** Colour `bg-gray-100`→`neutral-100` ×7 + star gold→`text-star` (stale "no token exists" comment retired — token existed since Conv 297); Type clean (★ glyph px = icon-exempt, primitive-owned); Spacing `gap-10`/`pl-10` (rendered 40px off-scale)→`gap-12`/`pl-12` (Conv-305 snap). **Tier-2 applied:** `Textarea` adopt ×3 (stuck-msg + comment + goals). C-keep: `bg-white` send-circle (no white token). Gate: tsc 0 / lint 0 / 105 booking tests; DOM+screenshot verified (interactive 4-gold+1-grey rgb 245,166,35; readonly half-star at 4.5; Textarea white-fill r12px placeholder preserved); prov:sweep clean for StarRating. Early/prepare composer DOM-verified Conv 308 (temp future-dated session): `gap-12`/`pl-12` = 12px, `bg-neutral-100` rgb(241,241,241); seed restored. |

## RG-MOD — `/mod` — **[RG-MOD]**

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☑ | `/mod` | `mod.astro` | **SWEPT Conv 313.** Moderation console (non-admin moderators). **Conv 312 assessment + Tranche A (Option-B slice).** Page shell clean Matt (`AppLayout` + `SectionTitle`, role tokens, on-scale spacing). Substance = `ModeratorQueue` (836 ln) composing 4 `Admin*` primitives. **Tranche A DONE:** the 4 mod-only `Admin*` primitives (`AdminFilterBar`/`AdminPagination`/`AdminDataTable`/`AdminDetailPanel` + `StatusBadge`/`RoleBadge`) — misnamed (live in `components/admin/` but consumed ONLY by `ModeratorQueue` → **zero RG-ADMIN blast radius**) — conformed all 3 axes + **double-header fix** (removed the island's internal `<h1>Moderation Queue</h1>`; the page `SectionTitle` owns the title; `ModeratorQueue.test` 58/58). Headline: bridge-shrunk spacing (`p-4`/`h-4`/`h-12`/`h-16` rendering 4/4/12/16px) restored to literal-px; `indigo`→`brand`, `gray`→`neutral`/text tokens; type+radius tokens. 5 gates green. **Tranche B DONE (Conv 313):** `ModeratorQueue`'s own chrome conformed — (Decision 1) the 5 inline action buttons (Dismiss/Remove/Warn/Suspend + Retry) adopt the `Button` primitive, minting CC-owned `warning` (amber ramp) + `suspend` (honest-orphan orange) variants beside the Conv-306 `danger`; (Decision 2, hybrid) `getPriorityBadgeClass`→status tokens, `getReason`/`getContentTypeBadgeClass` map clean hues + **keep orphan hues** (orange/purple/indigo/cyan/pink); stat cards (`text-2xl font-bold`→`text-h2-bold`, `p-4`→`p-16`), detail-panel body + skeleton (`h-4`→`h-16`) conformed; avatar-initial `bg-orange-100`/`text-orange-600` kept honest-orphan. 5 gates green, `ModeratorQueue.test` 58/58 + `Button.test` 5/5 (full-suite 8 failures all proven **pre-existing** → [STALE-TESTS]). Detail → [conformance ledger § /mod](../typo-fdn/migration-ledger.md). **Browser-verified DONE (Conv 313, DOM-truth, admin `brian@peerloop.com` on Chrome bridge :4324)** — stat cards, table badges, action-button variants + new `warning`/`suspend` utilities, detail-panel body all confirmed. **RG-MOD ☑ Swept.** Residual: Warn/Suspend buttons not seen in-situ (seed pending-flag lacks `target_user`; probe-verified + test-asserted). |

## RG-WORKSPACES — Role workspaces — **[RG-WORKSPACES]** · 🟦 UNBLOCKED Conv 317 (ROLE-STUDIOS)

Shells built `@matt-inspired`. **✅ Client comparison RESOLVED (Conv 317):** client approved the
individual role dashboards (`/learning` `/teaching` `/creating`); the composite `/dashboard`
(UnifiedDashboard) will **not** be ported, kept in `/old/*` as deprecated reference. The
old-vs-new freeze is **lifted** → the shared dashboard comps (`EnrollmentCard`,
`CertificatesSection`, `MyFeeds`) are free to conform; doing so incidentally restyles the
deprecated `/old/dashboard` (acceptable — forking to pixel-freeze it was rejected). `/old/dashboard`
is still **kept** (not retired). Island restyles fold in as rows. `creating/apply` +
[NUDGE-CACHE-FLASH] owned here. SoT: `PLAN.md § ROLE-STUDIOS` (6-phase) + `[[project_role_studios_deconstruct_nudges]]`.

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☐ | `/learning/[...tab]` | `learning/[...tab].astro` | Conv-255 pilot. [LEARN-ISLAND-RESTYLE] folds here. **ASSESSED + PLANNED Conv 317 (conformance not started — paused).** 5 components, all now free to conform (⛔ lifted): StudentDashboard own-markup (30) + StudentSessionsList (54, only /learning + /old/learning/sessions) are non-shared; **EnrollmentCard (34), CertificatesSection (15), MyFeeds (25) are shared with the deprecated /old/dashboard** (UnifiedDashboard via Merged*) — conforming them incidentally restyles it (OK per Conv-317 client decision). Plan: slate `secondary-*`→`neutral-*`, sky `primary-*`→`brand-*` (note brand-300-vs-500 context nuance — DOM-verify vs precedent), `rounded-xl/lg`→`12/8`, type→Matt tokens, **honest-orphan keeps** = status pills (green/blue/amber/red), cert-type tints (blue/purple/green, /teacher precedent), feed-type tints; star→`text-star`; main CTAs→`<Button>`. |
| ☐ | `/teaching/[...tab]` | `teaching/[...tab].astro` | [TEACH-ISLAND-RESTYLE] folds here. |
| ☐ | `/teaching/courses/[courseId]` | `teaching/courses/[courseId].astro` | Teacher course-manage view. |
| ☐ | `/creating/[...tab]` | `creating/[...tab].astro` | Creator Studio. [CREATE-ISLAND-RESTYLE] folds here. |
| ☐ | `/creating/apply` | `creating/apply.astro` | Become-a-creator pre-flow + nudge destination. |
| ☐ | `/creating/communities/[slug]` | `creating/communities/[slug].astro` | Creator community manage. |

## RG-ADMIN — `/admin/*` — **[RG-ADMIN]** · 🟦 rehosted, island/body-only

**Shell already Matt** (`AdminLayout` + `AdminNavbar`, Conv 193) — pages are thin `.astro`
wrappers mounting an island, so port/sweep is **island/body-only**, shell untouched.
`/api/admin/*` unaffected. 14 are `@stand-in`; `announcements` + `promotion-settings` are
already `@matt-inspired` (still swept).

| Swept | Route | File | Port |
|-------|-------|------|------|
| ☐ | `/admin` | `admin/index.astro` | 🟦 |
| ☐ | `/admin/analytics` | `admin/analytics.astro` | 🟦 |
| ☐ | `/admin/announcements` | `admin/announcements.astro` | ✅ `@matt-inspired` |
| ☐ | `/admin/certificates` | `admin/certificates.astro` | 🟦 |
| ☐ | `/admin/courses` | `admin/courses.astro` | 🟦 |
| ☐ | `/admin/creator-applications` | `admin/creator-applications.astro` | 🟦 |
| ☐ | `/admin/enrollments` | `admin/enrollments.astro` | 🟦 |
| ☐ | `/admin/moderation` | `admin/moderation.astro` | 🟦 |
| ☐ | `/admin/moderators` | `admin/moderators.astro` | 🟦 |
| ☐ | `/admin/payouts` | `admin/payouts.astro` | 🟦 |
| ☐ | `/admin/promotion-settings` | `admin/promotion-settings.astro` | ✅ `@matt-inspired` |
| ☐ | `/admin/recordings` | `admin/recordings.astro` | 🟦 |
| ☐ | `/admin/sessions` | `admin/sessions.astro` | 🟦 |
| ☐ | `/admin/teachers` | `admin/teachers.astro` | 🟦 |
| ☐ | `/admin/topics` | `admin/topics.astro` | 🟦 |
| ☐ | `/admin/users` | `admin/users.astro` | 🟦 |

## RG-AUTH — Auth / entry / error — **[RG-AUTH]** (folds RTMIG-MISC)

**☑ SWEPT (Conv 314) — 7/7, browser-verified DOM-truth (member + logged-out + public cert).** The
shared **auth-modal tree** (LoginModal/SignupModal → LoginForm/SignupForm + OAuthButtons; mounted
app-wide via `AuthModalRenderer` in AppLayout) conformed here — recurring Tier-2 = the hand-rolled
submit `<button>`s adopt the `<Button>` primitive (4 sites) + OAuthButtons adopt `<Button variant="outlined">`
(blue Matt pill, user-chosen). The **2 unported routes ported** (MOVE old→root, two-step rehost+Matt).
Shared `Input` primitive computed `border-radius:0px` observed (pre-existing, consumed by already-swept
`/login`/`/signup`/`/profile` — out of RG-AUTH new-work scope; logged in conformance ledger).

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☑ | `/login` | `login.astro` | **Conv 314.** Wrapper (`AutoOpenAuthModal`+`AppLayout`); substance = LoginModal→LoginForm+OAuthButtons. Chrome tokens (`p-6`→`p-24`, `text-sm`/`secondary-600`/`primary-600`→role); error-box `rounded-[12px]`→`rounded-12`; forgot-pw font-weight bundle; submit + OAuth → `<Button>`. DOM-verified: OAuth blue pills r39 `rgb(7,119,182)`, Sign-in pill full-width, links 12/500. |
| ☑ | `/signup` | `signup.astro` | **Conv 314.** Mirror of login (SignupModal/SignupForm). Submit→`<Button>` (Create account r39 full-width), Terms/Privacy + sign-in links 12/500 blue. |
| ☑ | `/onboarding` | `onboarding.astro` | **Conv 314.** Shell clean; `OnboardingProfile` submit → `<Button>` (r39, americana-blue, disabled-state DOM-verified). FormSection tree intact. |
| ☑ | `/visitor` | `visitor.astro` | **Conv 314.** Already Matt; one fix — `ThemeToggle` off-track `bg-[#cbd5e1]`→`bg-neutral-300` (DOM-verified `rgb(218,218,218)`). **Shared w/ `/profile`** → back-pointer re-glanced, no regression. login/signup Buttons r39 (primary + outlined). |
| ☑ | `/404` | `404.astro` | **Conv 314.** `LandingLayout`. Bridge-shrunk margins restored (`mt-4`→`mt-16`, `mt-2`→`mt-8`, `mt-8`→`mt-24`, `gap-4`→`gap-12`; DOM-verified 16/8/24/12px). Buttons already `<Button>`. `text-6xl` numeral kept = documented display-exception (no Matt token). |
| ☑ | `/reset-password` | `reset-password.astro` | **Conv 314 — PORTED** (git mv `old/`→root). Legacy `@layouts/old/AppLayout`→Matt `AppLayout`; `PasswordResetForm` retrofit onto FormField/Input + `<Button>` + error/`success-*` tokens, bridge-shrunk icon circle restored (`size-[64px]`/`size-[32px]`); `@matt-inspired`. DOM-verified: h1 24/600, submit pill full-width, AppLayout shell. |
| ☑ | `/verify/[id]` | `verify/[id].astro` | **Conv 314 — PORTED** (git mv `old/`→root). Kept `LandingLayout` + SSR. Full body conform: red→`error-*`, green→`success-*`, secondary→`neutral`/text, **all `dark:` dropped**, bridge-shrunk spacing/sizing restored, raw `<svg>` check → `<MattIcon name="verified">`. cert-type+course-title `text-lg font-semibold`→`text-h3-bold` (user-chosen). DOM-verified verified-state: card success-100/300, radius 12, p-32, MattIcon renders (no placeholder), all 20/600. `@matt-inspired`. |

## RG-PUBPROF — Public profiles — **[RG-PUBPROF]** · ✅ **SWEPT 3/3 (hub+teacher Conv 316, creator Conv 317)**

> **ROLE-SEMANTICS resolution (Conv 315):** the predicate was decided Conv 252 + already implemented (data-layer call-sites + SSR loaders all use canonical `isCreatorSubquery`/`isTeacherSubquery`). Two residual items applied this conv: (1) `fetchCreatorProfileData` now selects + maps `courses.primary_topic_id` (was hardcoded `null`; column exists, schema L347 — RG-PUBPROF-preparatory, browser-verify when the loader is adopted); (2) `UserProfileHeader` role badges now delegate to canonical `userRoles()` instead of re-implementing inline (behavior-preserving). tsc/lint clean. [ENTITY-ANCHOR] plural-slug fix + [SSR-LOADER-DEAD] remain RG-PUBPROF's own scope (not ROLE-SEMANTICS).

**Hub-and-spoke.** `/@[handle]` is the universal hub; `PublicProfile` carries
`is_creator`/`is_teacher` (per [ROLE-SEMANTICS]) and renders role teasers linking OUT to the
deep views. All 3 still legacy-only.

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☑ | `/@[handle]` | `@[handle].astro` ✅ | **SWEPT Conv 316.** Ported root (`git mv old→root`, `@matt-inspired`). 5-comp conformance (PublicProfile/UserCard/UserAvatar/CreatorTeaser/TeacherTeaser — [conformance ledger §/@[handle]](../typo-fdn/migration-ledger.md)). Tier-2 `<Button>`×4 (Try-Again/Edit/Message/Website). DOM-verified member (guy-rymberg, creator+teacher — both teasers) + visitor + error: 0 forbidden tokens, 0 console errors; user step-7 CLEAN. **[ENTITY-ANCHOR] (hub):** teaser links already singular (`/teacher/${handle}`, `/creator/${handle}`) — DOM-verified correct. Honest-orphans: Creator-purple/Teacher-blue role hues. Dead `UserProfileHeader`/`UserProfileQuickLinks` (0 importers) → [OLD-PORTED-CLEANUP]. Un-ripe Tier-2 logged (StatCard→AnalyticCount, EntityPill/Badge, card-container, social IconButton). |
| ☑ | `/teacher/[handle]` | `teacher/[handle]/index.astro` ✅ | **SWEPT Conv 316.** Ported root (`git mv old→root`, `@matt-inspired`); `.astro` adopted `fetchTeacherProfileData` (canonical predicate — **[SSR-LOADER-DEAD] teacher-half resolved**, inline SQL gone). **FLATTENED to hub look** (Conv-316 user decision): gradient hero → white UserCard-style header; all body sections → white Matt cards. Conformed TeacherProfile + TeacherProfileHeader + TeacherAvailabilityCard + shared ReviewList/ReviewCard (route-local). Tier-2: `<Button>`×6, ReviewCard stars→`StarRating`, review avatar→`UserAvatar`. 🔴 Fixed a hydration-mismatch date bug (`new Date().toLocaleDateString` no-TZ → `timeZone:'UTC'`, [TZ-AUDIT]-class). DOM-verified member+own-profile+not-found (0 console errors, 0 forbidden tokens); user step-7 CLEAN. Honest-orphans: cert-type tints + Teacher/Available badges. `TeacherCard.tsx` (directory card) NOT on this route — excluded. |
| ☑ | `/creator/[handle]` | `creator/[handle]/index.astro` ✅ | **SWEPT Conv 317.** Ported root (`git mv old→root`, `@matt-inspired`); `.astro` adopted `fetchCreatorProfileData` (**[SSR-LOADER-DEAD] creator-half resolved**, inline SQL gone). **FLATTENED to hub look** (mirrors /teacher): gradient hero → white UserCard-style header; all body sections → white Matt cards. Conformed CreatorProfile + CreatorProfileHeader. Tier-2: `<Button>` adoption, `UserAvatar`, **`getRatingDisplay` upgrade** (header was raw `.toFixed`). **Creator-purple badge** (honest-orphan, matches hub UserCard). **[CCARD-CONF] done** — shared `CourseCard` 3-axis conformed (props frozen; `featured`→brand/`new`→success; popular/bestseller honest-orphans). 🟠 CourseCard live footprint correction: renders live ONLY on /creator (/courses uses `CourseCatalogCard`); `FeaturedCourses`/`CourseBrowse`/`CourseDetail` import it but are **dead** → logged [OLD-PORTED-CLEANUP]. DOM-verified visitor+own-profile+not-found (0 forbidden tokens, console clean); all 3 RG-PUBPROF pages cross-verified coherent. `primary_topic_id` plumbed but unused by CourseCard. `CreatorCard.tsx` (directory card) excluded. |

## RG-PUBLIC — Public / marketing — **[RG-PUBLIC]** · ⬜ deferred (swept last)

Low-data, redesign-likely. Tracked also under `PLAN.md § Deferred: PUBLIC-PAGES`.
`become-a-teacher` already rehosted `@stand-in`; the other 14 remain `/old/*`.

| Swept | Route | File | Notes |
|-------|-------|------|------|
| ☐ | `/become-a-teacher` | `become-a-teacher.astro` | 🟦 rehosted `@stand-in`. |
| ☐ | `/about` | `old/about.astro` ⬜ | marketing |
| ☐ | `/blog` | `old/blog.astro` ⬜ | marketing |
| ☐ | `/careers` | `old/careers.astro` ⬜ | marketing |
| ☐ | `/contact` | `old/contact.astro` ⬜ | marketing |
| ☐ | `/cookies` | `old/cookies.astro` ⬜ | legal |
| ☐ | `/faq` | `old/faq.astro` ⬜ | marketing |
| ☐ | `/for-creators` | `old/for-creators.astro` ⬜ | marketing |
| ☐ | `/help` | `old/help.astro` ⬜ | marketing |
| ☐ | `/how-it-works` | `old/how-it-works.astro` ⬜ | marketing |
| ☐ | `/pricing` | `old/pricing.astro` ⬜ | marketing |
| ☐ | `/privacy` | `old/privacy.astro` ⬜ | legal |
| ☐ | `/stories` | `old/stories.astro` ⬜ | marketing |
| ☐ | `/terms` | `old/terms.astro` ⬜ | legal |
| ☐ | `/testimonials` | `old/testimonials.astro` ⬜ | marketing |

---

## Reference: resolved / not actionable

**Retired (not ported):** `/dashboard` (`UnifiedDashboard`) → deconstructed by ROLE-STUDIOS;
`AppNavbar.tsx:97` `/dashboard` link fixed in ROLE-STUDIOS Phase 3.

**Deleted (Conv 251):** `/teachers`, `/creators` (empty "Coming soon" stubs; referrers →
`/members?roles=…`).

**Dropped (Conv 229):** `/old/discover/leaderboard` — product decision not to port.

**Stale `/old` copies → [OLD-PORTED-CLEANUP]:** ~43 already-ported routes still carry a
`/old` copy under the pre-Conv-250 copy policy — deletable per-route as follow-up cleanup.
