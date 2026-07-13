# ROUTE SWEEP — visual-presentation sweep of every route

> ## ✅ [RTMIG-4] CLOSED — Conv 340
> The route-sweep umbrella **closed Conv 340**: **all 13 in-scope route-group sweeps (RG-*) complete**;
> **RG-PUBLIC parked** until the marketing redesign — the only un-swept group, deliberately deferred
> (see § Conformance scope + the RG-PUBLIC disposition note). Conv 340 also finished the residuals of the
> Conv-339 `/old` retirement: doc-reconciliation ([OLD-DOCS-RECON] #18 — `url-routing.md` 9 areas +
> `route-stories.md` `/dashboard` retirement banner; [OLD-DOCS-COMP] #19 — `state-management.md` APP-shell
> rewrite + `_COMPONENTS`/`feeds`/`data-fetching`/`auth-sessions`) and orphan-component deletions
> ([UNIFIED-DASH-RM] #21, [FEEDSHUB-RM] #22 — see the OLD-PORTED-CLEANUP retirement ledger below). 5 gates
> green, full suite 6697/6697. The per-route checklists below remain the SoT for what each group covered;
> residual cross-cutting tasks ([E2E-MIG] **dropped Conv 347** (Playwright frozen; see
> `docs/decisions/06-testing-ci.md`), [SESSHIST] Ph2, [PREFLIP-WT], [OLD-PORTED-CLEANUP] code
> residuals a/b) are tracked in PLAN.md.

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
| **IN — conformance rides the sweep** | RG-HOME, RG-COURSES *(both backfill)*, RG-COMMS, RG-DISCOVER, RG-MESSAGES, RG-NOTIFS, RG-PROFILE, RG-SESSIONS, RG-PUBPROF, **RG-MOD** (hangs off `Sidebar.tsx`), **RG-WORKSPACES** ✅ (was ⛔ client-blocked → unblocked Conv 317, swept 6/6 Conv 324), **RG-AUTH** |
| **OUT now — structural sweep only** | `/old/*` (deletion-bound, not a group), **RG-ADMIN** (`/admin/*`, internal — **restyle policy DECIDED Conv 331**: dense-console relaxations + dark `neutral-900` "Admin" identity, see memory `project_admin_conformance_policy`; multi-conv sweep **✅ COMPLETE Conv 332–336** — shell + AdminDashboard + 16/16 routes done, 3 sub-patterns locked), **RG-PUBLIC** (15 marketing pages — redesign-likely, deferred Conv 331) |

Excludes ~31 routes (admin 16 + public 15) + all `/old/*`. **Revisit** RG-PUBLIC if the
marketing redesign lands; **revisit** RG-ADMIN if the admin surface gets a design pass.

> **RG-PUBLIC disposition DECIDED Conv 336 — keep FULLY DEFERRED until the marketing redesign.** The 14 marketing pages (about, blog, careers, contact, cookies, faq, for-creators, help, how-it-works, pricing, privacy, stories, terms, testimonials) live only in `/old/*`; their root paths 404 by design (route-404-honesty). **Known + ACCEPTED consequence:** the app-wide `Footer.astro` links to those root paths (`/privacy`, `/terms`, `/help`, `/cookies`, …) which therefore **404 sitewide** — this is intentional-pending-redesign, NOT a bug to "fix" by porting pages or repointing to `/old` (the user explicitly chose to leave it). Re-raise only when the marketing redesign is scheduled.

> **Conv 392 cross-ref — marketing COMPONENTS confirmed orphaned + parked.** The systematic orphan detector (`.claude/scripts/codecheck-orphan-components.mjs`) flagged **52 marketing components** (`FeaturedCreators` + its `CreatorCard` dependency, marketing cards, etc.) as unreachable from any live route — classified **Category-B, parked behind RG-PUBLIC** (they die *with* the marketing redesign, NOT deletable independently). Detail + full orphan-cleanup backlog in the § OLD-PORTED-CLEANUP Conv-392 entry below.

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

## OLD-PORTED-CLEANUP — retirement ledger

**Recovery convention (DECIDED Conv 338):** retired `/old` pages + orphaned components are
recovered from **git history**, not an archive folder. The permanent anchor is the pre-flip
snapshot **commit `608346a2`** (also checked out live as the preflip worktree, `:4331`) — it
holds every `/old/*` page + orphaned component intact. Restore any file with
`git checkout 608346a2 -- <path>` (or `git show 608346a2:<path>` to view). The worktree
directory is a convenience over the commit; even after `[PREFLIP-WT]` teardown the commit
anchor persists. No `/_archive` folder — it would duplicate git, fight tsc/lint/build, and rot.

**Conv 338 — audit corrected the carried scope, first deletions landed:**

- 🔴 The carried scope ("44 deletable `/old` copies + 4 dead components:
  UserCardCompact/HomeFeed/FeedAllTab/FeedRoleTab") was **materially inaccurate**. Verified:
  - **74** `/old/*` page files exist (not 44). Only **12** have an exact root-path twin; **62**
    do not — a mix of not-yet-ported, *restructured-path* ports (`/old/dashboard` →
    `/creating`+`/teaching`; `/old/feed`+`/old/feeds` → `/`), deliberate old-vs-new
    comparison-keeps, and **parked RG-PUBLIC marketing pages that are the only copy** (must NOT
    delete). Exact-path matching can't classify these → per-page vetting required (deferred).
  - **`FeedAllTab` + `FeedRoleTab` are LIVE**, not dead — both imported+rendered by
    `ExploreFeeds.tsx`, which is itself consumed only by `/old/discover/feeds.astro`. That
    component chain dies *only* when that `/old` page is retired → **component cleanup is
    coupled to page cleanup**, not independent.
- ✅ **DELETED Conv 338** (genuine 0-importer orphans — repo-wide verified, no test files,
  superseded):
  - `src/components/feed/HomeFeed.tsx` — superseded by `SmartFeed` (HOME-FEED-MERGE).
  - `src/components/users/UserCardCompact.tsx` (+ `UserCardCompactData`) — superseded by
    `UserCard`; removed its 2 `users/index.ts` barrel exports + tidied 5 dangling `@see`
    doc-comments (`UserAvatar.tsx` + 3 API files).
  - All 5 gates green (tsc / check 0-0-0 / lint / test 6737/6737 / build). Restore:
    `git checkout 608346a2 -- src/components/feed/HomeFeed.tsx src/components/users/UserCardCompact.tsx`.
- ✅ **DONE Conv 339 — full retirement executed** (user directive: keep RG-PUBLIC, delete the rest;
  client **discarded** the combined-roles `/old/dashboard`). Per-page vetted all 74 → **deleted 60
  non-marketing `/old` pages** + the coupled orphans: `ExploreFeeds`/`FeedAllTab`/`FeedRoleTab` (the
  `/old/discover/feeds` island chain), the legacy app shell (`layouts/old/AppLayout.astro` +
  `AppNavbar` + `DiscoverSlidePanel` + `UserAccountDropdown`), and the dead
  `FeaturedCourses`/`CourseBrowse`. **KEPT: the 14 RG-PUBLIC marketing pages** (about, blog, careers,
  contact, cookies, faq, for-creators, help, how-it-works, pricing, privacy, stories, terms,
  testimonials) on `LandingLayout` (untouched). **Scope-corrections found during the vet:**
  `CourseDetail` is **LIVE** (real consumer) — NOT deleted; root `/feed`+`/feeds` were already retired
  Conv 331; the legacy shell fully orphaned only because the kept marketing pages use `LandingLayout`.
  One test repointed (`onboarding.test.ts` → root page). 5 gates green (tsc / check 0-0-0 / lint /
  build / full suite 6697/6697). Recovery: `git checkout 608346a2 -- <path>`.
- ⏭️ **Residuals (small):** (a) EnrollButton legacy code-branch (dead now that `/old/course/[slug]` is
  gone) — a code simplification, not a deletion; (b) PLATO nav-model + instances still name the deleted
  `AppNavbar`/`DiscoverSlidePanel` (soft strings/comments, NOT unit-gated) → was folded into `[E2E-MIG]`,
  now **dropped Conv 347** (Playwright frozen; see `docs/decisions/06-testing-ci.md`) — re-home if still needed;
  (c) driftCheck route docs (`url-routing.md` §8, etc.) describe deleted `/old` pages → reconcile under
  a docs follow-up. Generated route maps self-clear at r-end Step 5c.

- ✅ **Conv 340 — residual (c) DONE + the flagged orphaned components DELETED** (closes the doc-recon +
  dead-code byproducts of the Conv-339 retirement; 5 gates green — tsc / check 0-0-0 / lint / build 6.30s /
  full suite **6697/6697**; recovery `git checkout 608346a2 -- <path>`):
  - **[OLD-DOCS-RECON] #18** — `url-routing.md` reconciled across 9 areas (status banner, §8
    intro/consistency-note/island-source rows/summary, Community-Routes `/community`, file-tree compressed to
    the surviving **14** marketing pages, Impl-Status rows, 2 stale AppNavbar pointers, Conv-340 changelog);
    `route-stories.md` `/dashboard` given a **retirement banner** (story table KEPT to preserve the
    298/402 cross-role story-count invariant — the unified-dashboard stories don't cleanly belong to one role
    workspace). **Verb-tense test:** fixed present-tense "stays live" claims, preserved dated `Previously:` history.
  - **[OLD-DOCS-COMP] #19** — 5 component/architecture docs reconciled: `state-management.md` (APP-shell
    rewrite — deleted AppNavbar's CurrentUser-global init extracted into a headless **`CurrentUserInit`**
    island (`AppLayout`, `client:load`, `return null`); visible nav = `Sidebar`; ADMIN shell still uses the
    `AdminNavbar` self-init pattern; window-focus refresh NOT re-wired — 30s version polling covers staleness),
    `_COMPONENTS.md` (feed-cluster tombstone), `feeds.md` (FeedsHub orphaned), `data-fetching.md` (3 dead rows
    + a code example), `auth-sessions.md` (session-expired → **modal-only re-login accepted, no rebuild**;
    email-prefill survives via AuthModal `initialEmail`).
  - **[UNIFIED-DASH-RM] #21** — deleted **9** orphaned `unified/` files
    (`UnifiedDashboard`/`DashboardLinks`/`MergedCertsAvail`/`MergedCourses`/`MergedEarnings`/`MergedPeople`/
    `MergedQuickActions`/`MergedSchedule`/`StatsOverview`); **KEPT 4** shared with live surfaces
    (`PriorityHeader`/`NeedsAttention`/`types` used by live TriageStrip, `CollapsibleSection` by MyFeeds).
    Lesson: "orphaned component ≠ orphaned directory" — a broken `--include=*.tsx` zsh-glob grep had falsely
    reported the whole subtree as orphaned.
  - **[FEEDSHUB-RM] #22** — deleted `feed/FeedsHub.tsx` + `feed/directory/FeedDirectoryCard.tsx`
    (0 importers); `feed/directory/` removed.
  - **[TEST-FILE-COUNT] #20** — `TEST-COMPONENTS.md` grand-total corrected 94→**95** / 2,473→**2,488**
    (component category rows already summed to 95/2,488; only the grand-total row was stale).
  - Still pending: residual **(a)** EnrollButton legacy code-branch (a code simplification) + residual **(b)**
    PLATO nav-model naming → folded into `[E2E-MIG]` (now **dropped Conv 347** — Playwright frozen; see `docs/decisions/06-testing-ci.md`).

- ✅ **Conv 392 — orphan-detector built + Category-A dead-legacy sweep** (systematizes the manual dead-code
  hunts above; 5 gates green — full suite **6643/6643**; recovery `git checkout 608346a2 -- <path>`):
  - **[ORPHAN-DETECT]** — new `.claude/scripts/codecheck-orphan-components.mjs` (reachability BFS from
    `src/pages/**` routes; `KNOWN_ORPHANS` allowlist) — the systematic tool the Conv-340 broken-grep lesson
    called for. Root cause it catches: Conv 339 retired `/old` routing by deleting *pages* but leaving the
    *components*, which still pass tsc/lint/astro/build (and some have green unit tests that import them
    directly, bypassing routing). Surfaced **~118** pre-existing `.tsx`/`.astro` page-component orphans.
  - **[ORPHAN-PURGE]** — deleted the orphaned course-detail family (**20 files**: 16 components + 4 tests)
    after rebuilding its one genuinely-useful surface — the "Course complete! → View Diploma" celebration —
    as a Matt-styled server-rendered banner on the live `/course/[slug]` about tab.
  - **[ORPHAN-BACKLOG] Category-A** — deleted **74** dead-legacy orphan files (64 components + 10 tests,
    −12.5k lines) in 3 family batches (tsc between each; every dangler was a test or dead barrel — zero live
    breakage); detector 118→57. Also retired `dashboard/TriageStrip` + `unified/{NeedsAttention,PriorityHeader}`
    (verified `/old/dashboard` gone since Conv 339, TriageStrip unmounted since Conv 258) + corrected the stale
    `index.astro` comment and `project_role_studios` memory. **Kept `CreatorCard`** (marketing `FeaturedCreators`
    dependency).
  - ⏭️ **Follow-ups:** **Category-B** (52 marketing orphans) — parked behind **RG-PUBLIC** (see the RG-PUBLIC
    disposition cross-ref above; die with the marketing redesign); **Category-C** (4: `error/ErrorPage`,
    leaderboard, `invite/ModeratorInvite`, context-actions) ✅ **DONE Conv 393** (3 deleted + ModeratorInvite
    wired — see the Conv 393 entry below); **wire the detector into `/w-codecheck`** once **B** resolves and the
    53 residuals baseline into `KNOWN_ORPHANS` (it exits 1 until then) — and, alongside that, productionize the
    scoped **`.ts`** detector variant validated Conv 393 (re-derive from the component detector, `src/components/**`
    scope) if a `.ts` gate is wanted; a stray dead **`.ts`**-util sweep
    (the component-only detector misses `.ts`) ✅ **DONE Conv 393** (12 deleted, `src/components/**`-scoped).

- ✅ **Conv 393 — Category-C resolved + stray dead-`.ts` sweep** (closes 2 of the 4 Conv-392 follow-ups; 5 gates
  green — full suite **6534/6534**, build ✓; commits code `1a8a6b6d` / docs `0637915`; recovery
  `git checkout 608346a2 -- <path>`):
  - **[ORPHAN-BACKLOG] Category-C review** — per-item built-vs-dead check of the 4 residual orphans (git history +
    exact-import-path + adjacent-infra tracing). **3 confirmed dead → deleted (11 files):** `error/ErrorPage`
    (+barrel — `404.astro` is live + self-contained, superseded debris, no 404 gap), `leaderboard/Leaderboard`
    (+ `api/leaderboard.ts` + 2 tests — abandoned full-stack feature, both ends orphaned), `context-actions/*`
    (Panel+registry+types+barrel+test — role-aware quick-actions FAB built alongside ModeratorQueue, never mounted).
    tsc stayed clean (closed-orphan property held — zero danglers). **1 was a LIVE bug, not debris → wired:**
    `invite/ModeratorInvite` is the invitee accept/decline landing UI for a *shipped* feature — the admin flow
    (`/admin/moderators` → `POST /api/admin/moderators/invite`) writes a `moderator_invites` row + emails a link to
    `/invite/mod/{token}` (RESEND live on staging), but `src/pages/invite/` never existed so the email link **404'd**.
    Built `src/pages/invite/mod/[token].astro` (`@matt-inspired`, `LandingLayout` per the `verify/[id]` public-token
    precedent, SSR `getSession` → `isAuthenticated`/`userEmail` props). **Verified live** (ephemeral dev server):
    `/invite/mod/<token>` now HTTP 200 + renders the island; control non-matching route still 404s. Detector
    **57→53** (all 4 Category-C cleared).
  - **[ORPHAN-BACKLOG] stray dead-`.ts` sweep** — derived a scoped `.ts` variant of the detector (reachability-from-
    routes is authoritative for `src/components/**` `.ts`, same as `.tsx`; NOT for `src/lib/**`, which has
    worker/middleware/config entry points a pages-rooted sweep can't see → would false-positive). Found 22 dead; an
    all-importers safety classifier separated 🟢 zero-importer-of-any-kind from 🟡-would-dangle-tsc. **Deleted 12:**
    7 utils/types (`discover/{community,feed}-role-utils.ts` +2 tests, `dashboard/unified/types.ts`,
    `courses/course-tabs/types.ts`, `auth/useRequireAuth.ts`) + 5 dead live-dir barrels (admin, community, layout,
    teachers/workspace, ui). **Left 9** parked Category-B / entangled barrels (deleting would dangle still-`tsc`-
    compiled parked orphans — deletion-safety = zero importers of ANY kind, not just route-reachable). **Kept**
    `icons/icon-provenance.ts` (tooling-read by `prov:sweep`, not imported → the `.ts`-detector equivalent of a
    `KNOWN_ORPHANS` allowlist entry). tsc 0 danglers. Also re-verified importers at delete time — Conv 392's
    "keep `courses/course-tabs/types.ts` because live tabs import it" rationale had silently expired (now 0 importers).

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
| **[RG-COMMS]** | communities, community/[slug]/[...tab] (2) | ✅ | ☑ **SWEPT (Conv 311)** — Conv-310 slice (5 islands) + Conv-311 [RGCOMMS-VERIFY] ✅ + [RGCOMMS-FEEDS] ✅ (CommunityFeed/SystemFeed/CommentSection feed bodies, full primitive adoption). Gates green; DOM-truth zero forbidden tokens (member+admin). Residual `Card.astro` `rounded-12` no-op **✅ now FIXED Conv 311** (systemic @theme radius registration, [SWEEP-SPACING-GREP] — /community `<Card>`s verified 12px). folds COMMUNITY-FIX bugs. **✅ Conv-326 deep-verify residuals RESOLVED + ledgered (Conv 327–330, [RTMIG-RECON] Phase 4–5):** community-detail cluster `rounded-lg` + RoleTabBar/CatalogPagination/ListingShell weight/radius (+ honest-orphan `bg-[#eff6ff]`) + CourseFeed inert `neutral-400/600` bug + community-astro `bg-surface-raised` no-op + the 3 tab files' false Conv-310 header claims (corrected in-file Conv 327). Ledger: § RG-COMMS + § Shared primitives. |
| **[RG-DISCOVER]** ✅ | members (1; feed + feeds RETIRED Conv 331) | ✅ | **CLOSED Conv 331.** `/members` ☑ SWEPT Conv 315. `/feed`+`/feeds` **RETIRED** (user decision under [OLD-RETIRE-DEFAULT]): `/feed` = a standalone duplicate of Home's SmartFeed; `/feeds` = a discovery directory reachable only via the My-Feeds dashboard panel. Both pages + orphaned islands (FeedsDiscoveryGrid/FeedsDirectory) deleted; canonical links repointed (SmartFeed "discover more"→/communities, MyFeeds "View Smart Feed"→/); middleware.test.ts updated. folds FEEDS-FIX bugs |
| **[RG-MESSAGES]** ✅ | messages (1) | ✅ | **SWEPT Conv 307 — 1/1.** Light sweep: gray-100→neutral-100 (×7), font-weight→tokens (×~12), `<Button>` adoption (colour-neutral americana-blue). |
| **[RG-NOTIFS]** ✅ | notifications (1) | ✅ | **SWEPT Conv 307 — 1/1.** Light sweep: gray-100→neutral-100 (×7), font-weight→tokens (×7), `<Button>` "Try again"; per-type tints = honest-orphan C-keep. |
| **[RG-PROFILE]** ✅ | profile/[...tab] (1, multi-tab) | ✅ | **CONFORMANCE COMPLETE — 6/6 tabs (Conv 301–303), route ☑ Swept.** folds CT-RESTYLE / PRIM-MATCH-INDEX / TXTBTN / PROFILE-PRIM-SWEEP |
| **[RG-SESSIONS]** ✅ | session/[id] (1) | ✅ | **SWEPT Conv 308 — 1/1.** Extracted **`StarRating`** primitive (interactive + readonly fractional); `bg-gray-100`→`neutral-100` ×7; star gold `#f5b800`→`text-star`; Textarea adopt ×3; composer `gap-10`/`pl-10`→`gap-12`/`pl-12`. |
| **[RG-MOD]** ✅ | mod (1) | ✅ | **SWEPT Conv 313 — Tranche A (Conv 312) + B + browser-verify.** A = 4 mod-only `Admin*` primitives conformed (3 axes) + double-header fix; B = `ModeratorQueue` chrome (action buttons adopt `Button` w/ new CC-owned `warning`/`suspend` variants; category badges hybrid — priority→status, reason/content-type orphans kept; stat cards + detail body + skeleton). Browser-verified DOM-truth (admin `brian` on bridge :4324). 5 gates green, `ModeratorQueue.test` 58/58 + `Button.test` 5/5. |
| **[RG-WORKSPACES]** | learning, teaching (+courses/[id]), creating (+apply, communities/[slug]) (6) | ✅ shells | ROLE-STUDIOS, 🟦 UNBLOCKED Conv 317; **✅ 6/6 routes swept (cluster COMPLETE Conv 324) — `/learning` ☑ Conv 318; `/teaching` (6 tabs) + `/teaching/courses/[courseId]` ☑ Conv 319–321; `/creating/apply` + `/creating/communities/[slug]` ☑ Conv 323** (`/creating` `[...tab]` ☑ Swept Conv 324 — CR-STUDIO all 5 units A–E; **6/6 swept**); `/teaching` tabs DONE (decomposed tab-by-tab into 7 [TCH-*] units; **all 6 /teaching tabs ☑ Swept** — overview/analytics/availability/earnings Conv 319, sessions/students Conv 320; #25 shell+8 sub-comps, #26 TeacherAnalytics+shared DateRangeSelector, #27 AvailabilityCalendar (sky-status kept), #28 EarningsDetail (shared w/ /creating; status palette kept), TCH-SESSIONS + TCH-STUDENTS Conv 320 w/ corrected status-token rule (green→success/blue→info now MAP) + [STATUS-TOKEN-BACKMAP] across 6 swept siblings); **`[TCH-COURSEVIEW]` ☑ Swept Conv 321 (TeacherCourseView, all 6 tabs DOM-verified; CourseFeed carved to `[COURSEFEED-CONF]`)**. **`/creating` DONE — all 5 workspace tabs ☑: `[CR-OVERVIEW]` Conv 321, `[CR-ANALYTICS]` + `[CR-EARN]` Conv 322, `[CR-COMMUNITIES]` Conv 323, `[CR-STUDIO]` ☑ Conv 324 (sub-decomposed into 5 cohesion units A–E: CR-ST-ENTRY/CR-ST-CURRIC/CR-ST-HW/CR-ST-RES/CR-ST-SHELL; full-page unscoped DOM leak = 0; `ConfirmModal` carved to `[CONFIRMMODAL-CONF]`)** (siblings `[CR-APPLY]` + `[CR-COMMUNITY-MGMT]` ☑ Conv 323); folds the island restyles. **Both cross-cut carve-outs `[CONFIRMMODAL-CONF]` + `[COURSEFEED-CONF]` ☑ CONFORMED + DOM-verified Conv 325** (0 leaks; FeedActivityCard scoped OUT to its own future task). **✅ Conv-326 deep-verify residuals RESOLVED + ledgered (Conv 327–330, [RTMIG-RECON] Phase 3–5):** font-weight bulk (58 hits / 7 data-table+studio files), AvailabilityCalendar Family-C micro-mint + red/amber→error/warning ([WS-AVAILCAL] Conv 330), avatar/badge glyphs→display regime ([WS-GLYPHS] Conv 329), EntityPromoComposer error/success, SessionAnalytics + MyFeeds verified-keep, CourseFeed inert `neutral-400/600` + TeacherDashboard `green-500`→`success-500` (Phase 1). Ledger: § RG-WORKSPACES studio + § Shared primitives. |
| **[RG-ADMIN]** | /admin/* (16; all `@matt-inspired`) | ✅ **COMPLETE — 16/16 (Conv 332–336)** | island/body-only port + sweep. **Conformance OUT (Conv 299)** — structural Tier-1/Tier-2 only, no type/spacing/colour pass; runs its own **[ADMIN-CONF-POLICY]** (Conv 331). **Conv 332:** shell restyled (dark `neutral-900` "Admin" identity) + `AdminDashboard` conformed + routes #1–#4 swept (payouts, promotion-settings, announcements, topics) + shared `AdminActionMenu` conformed + **3 locked sub-patterns** (Button / form-primitives / `ui/Modal`). **Conv 333:** routes #5–#7 swept (users, courses, enrollments) + shared `FormModal` conformed + **app-wide `UserAvatar` bridge-fix** (sizeClasses 4× shrunk since Conv 174; re-verify consumers → [XCUT-BACKREF]). **Conv 334:** routes #8 `/admin/recordings` + #9 `/admin/teachers` swept (both zero-backward-pointer — their shared subcomponents/`ConfirmModal` already conformed; teachers fixed 2 red-links + adopted UserAvatar). **Route #10 `/admin/sessions`** swept too (largest route — 4 UserAvatar adopts, 6 stat hues, red-link). **Conv 335:** route #11 `/admin` dashboard *route page* swept — pure marker flip `@stand-in`→`@matt-inspired` (island + shell already conformed Conv 332, re-verified this conv: 0 forbidden tokens, gates green, DOM-truth :4321). **Route #12 `/admin/certificates`** swept too (604+154 ln; zero backward-pointer on shared deps + structural **Revoke modal → `FormModal`**, recipient `UserAvatar` adopted, typeColors blue/purple/green→info/brand/success, 4 stat hues, 2 red-links fixed, tests 58/58, DOM-verified). **Route #13 `/admin/moderators`** swept too (647+121 ln; zero backward-pointer, no custom modal; StatCard tinted→white-card + 4 lifecycle hues, TabButton indigo→info accent, both avatars→UserAvatar, Invite/footer Buttons, DOM-verified). **Route #14 `/admin/moderation`** swept too (BIGGEST — 4 components, 1257 ln: ModerationPage shell + ModerationAdmin + SystemPromotionsModeration + ModerationDetailContent; zero backward-pointer, badge helpers mirror RG-MOD verbatim, avatars→UserAvatar, footer Buttons Dismiss/Remove/Warn/Suspend, both tabs DOM-verified, 9 test assertions updated → 166/166). **Conv 336 closed the group:** route #15 `/admin/creator-applications` (Deny modal → `FormModal`, last hand-rolled admin modal retired) + route #16 `/admin/analytics` (6-section chart dashboard, 7 files, chart-palette = honest-orphan hex, chrome-only) swept; cross-cut **[FOOTER-CONF] #26** (app-wide `Footer.astro`) conformed + `DateRangeSelector` focus-ring→info (analytics 0-leak). **RG-ADMIN ✅ COMPLETE 16/16.** |
| **[RG-AUTH]** ✅ | login, signup, onboarding, ~~visitor~~, 404, reset-password, verify/[id] (7) | ✅ | **SWEPT Conv 314 — 7/7, browser-verified.** Shared auth-modal tree conformed (submit `<button>`s + OAuth → `<Button>`); 2 unported routes ported (reset-password + verify/[id], MOVE old→root). folds RTMIG-MISC **`/visitor` RETIRED Conv 349** — folded into the new auth-aware `/profile` ([PROF-MERGE]); `visitor.astro` deleted, Sidebar chip always → `/profile`. See `url-routing.md`. |
| **[RG-PUBPROF]** ✅ | @[handle], teacher/[handle], creator/[handle] (3) | ✅ 3/3 | **SWEPT 3/3 — `/@[handle]` + `/teacher/[handle]` Conv 316, `/creator/[handle]` Conv 317.** Creator flattened to hub look (gradient hero→white card), `fetchCreatorProfileData` adopted, `<Button>`+`UserAvatar`+`getRatingDisplay`, Creator-purple badge. **[CCARD-CONF] done** (shared CourseCard 3-axis conformed — only renders live on /creator; FeaturedCourses/CourseBrowse/CourseDetail found dead → logged [OLD-PORTED-CLEANUP]). All 3 DOM-verified coherent (visitor/own/not-found, 0 forbidden tokens, console clean). ROLE-SEMANTICS ✅ Conv 315. **✅ Conv-326 deep-verify (`/creator`) residual RESOLVED + ledgered (Conv 327–330, [RTMIG-RECON]):** the sole finding was the shared `UserAvatar` `sizeClasses` (raw `text-xs…3xl`/`font-bold`) — conformed via the Family-A glyph regime Conv 327 (§9.2c); creator-specific comps (CreatorProfile/Header) were already clean. Ledger: § Shared primitives + the `/@[handle]` `UserAvatar` row. **Conv 349 — post-sweep ARCHITECTURE hardening (separate axis; the conformance SWEPT 3/3 claim is unaffected):** public-profile family reframed — `/@[handle]` SSR'd via a new shared `fetchPublicProfileData` loader ([HUB-SSR]) + width/metadata parity (`max-w-4xl`, em-dash spoke titles) ([PROF-PARITY]); `/creator`+`/teacher` reframed as **commercial entry surfaces** (identity-vs-commerce model — `/@handle` = WHO, spokes = WHERE-you-transact; storefront deferred to Phase 2; creator gained a "View Courses" CTA + courses-lead reorder) ([SPOKE-COMMERCE]); `/visitor` merged into auth-aware `/profile` + new app-first `noindex` infra ([PROF-MERGE]). Canonical: `url-routing.md` + `decisions/01-architecture.md` + decision-log. |
| **[RG-PUBLIC]** | become-a-teacher + 14 marketing (15) | ⬜ deferred | low-data, redesign-likely; swept last. **Conformance OUT (Conv 299)** — structural only; revisit if the marketing redesign lands. |

**Cross-cutting tasks (NOT route groups):** [RTMIG-4] (umbrella — **✅ CLOSED Conv 340**; all 13 in-scope groups swept, RG-PUBLIC parked),
**[RTMIG-RECON]** (✅ CLOSED Conv 330 — all 6 phases done; sub-task of the still-active RTMIG-4 umbrella, closure recorded here. Conformance-residual cleanup. A Conv-326 deep-verify of the 3
README-Swept groups absent from the conformance ledger (RG-COMMS, RG-PUBPROF `/creator`,
RG-WORKSPACES `/teaching*`+`/creating*`) found genuine forbidden-token residuals — mostly
**shared-primitive + unrendered-branch**, plus 2 functional token bugs. These groups remain swept
in their **route-owned** code; the residual debt is shared/un-rendered surfaces. **Finding: the
conformance ledger lags the README** for these routes (the ledger stopped being updated ~Conv 317;
README "Swept" rows drifted ahead of "ledger-confirmed conformant"). Ordering = **horizontal**
(shared-primitives-first). **Phase 1 ☑ Conv 326** (2 functional bugs — CourseFeed inert
`neutral-400/600`, `bg-surface-raised` no-op, TeacherDashboard `green-500`→`success-500`; commit
`92481dff`). **Phase 3 ☑ Conv 327** (shared primitives — UserAvatar, PromoteButton, form/Input·Select·Textarea,
ui/Modal, FunnelChart conformed; UserAvatar's glyph sizing resolved by **minting a third
display/glyph type regime** §9.2c with `text-display-avatar-*` tokens — Family A — rather than
preserving an ad-hoc exception (resolves the Conv-316 exception ↔ Conv-326 violation SoT
contradiction); PromoteButton 3-axis conform + 4px bridge-shrink icon fix; commits code
`93e27e34` + docs `e7e11d5`; ledger UserAvatar :255 Type ☑; full suite 6741/6741 + 5 gates green).
**Phase 4 STARTED Conv 327, MOSTLY DONE Conv 328** — route-owned residual cleanup.
*Conv 327:* RG-COMMS community-detail cluster conformed
(CommunityMembersTab/CommunityResourcesTab/AddCommunityResourceModal radii + checkbox `rounded`→`rounded-4`,
community/[slug]/[...tab].astro radii; 3 tab-header integrity items corrected in-file —
"Radius residual fixed Conv 327"; commit code `ac8b6765`).
*Conv 328:* (1) **RG-COMMS route-owned remainder** — RoleTabBar (`font-medium`/`font-semibold`→type-token
weight variants), CatalogPagination (`rounded-[8px]`→`rounded-8`, `font-medium`→`-medium`), ListingShell
+ index.astro (`rounded-[16px]`→`rounded-16` ×3); the CD-039 `bg-[#eff6ff]` light-blue panel **KEPT as a
documented honest-orphan** (no exact Matt token; nearest `info-100` is an info-status tint — wrong
semantics; "Colour keeps exceptions"); commit code `c058d053`. (2) **RG-WORKSPACES font-weight bulk** —
58 raw `font-medium`/`font-bold` hits across 7 data-table files folded to size-correct type-token weight
variants (per-element rendered-size determined first; `font-bold`→`-bold` is the sanctioned 700→600 Matt
normalization); commit `565bc4b7`. (3) **2 clean avatar glyphs** (MaterialsFeedbackView:225 + CourseEditor:1723,
explicit-14px) → `text-display-avatar-sm` (Family A, §9.2c); commit `90e94eb8`. (4) **EntityPromoComposer**
alert/status colours → `text-error-500`/`text-success-500`; **MyFeeds + SessionAnalytics flagged colours
VERIFIED-KEEP** (already in-code documented honest-orphans — category accents / "no Matt notification scale" /
quartet precedent); commit `73c5d337`. **RG-WORKSPACES route-owned font-weight/colour axes now DONE except
two deferred follow-ups:** **[WS-GLYPHS] #28** (5 non-mechanical display-regime hits — three off-scale 40px
avatar fallbacks + count badge + size-less `<h4>`; need DOM-verify or visual-change UserAvatar adoption) and
**[WS-AVAILCAL] #29** (AvailabilityCalendar sparse-ramp red/amber→error/warning map + the novel Family-C
`text-display-micro` mint, 9/10px fork — `sky-*` available-state sanctioned/verify-only).
*Conv 329:* **[WS-GLYPHS] #28 ☑ DONE** — the 5 deferred display-regime hits conformed (user-decided
**inline display-avatar token**, not UserAvatar adoption): three 40px avatar fallbacks (CourseEditor:1637,
TeacherStudentList:183, TeacherUpcomingSessions:106) + the count-badge numeral (TeacherPendingActions:40,
weight 700→600 regime-normalized) → `text-display-avatar-sm` (Family A, §9.2c; `sm` not `md` for consistency
with Conv-328's 32/36px→sm done-glyphs — "ties round up" is **spacing-axis-only**, type doesn't borrow it);
the size-less `<h4>` (MaterialsFeedbackView:211) → `text-body-default-medium`. The 40px circle inherits the
16px body base (no exact display-avatar token; sm=14/md=18 gap) — snapped to the nearest UserAvatar tier
consistency-first. Gates green (tsc/lint/astro 0-0-0(1437)/build 7.28s; full suite deferred to #12,
className-only); commit code `99ef1798` (5 files).
*Conv 330 — RTMIG-RECON CLOSED (Phases 4-remainder + 5 + 6 all done):*
**(A) [WS-AVAILCAL] #28 ☑ DONE** (the last Phase-4 follow-up) — AvailabilityCalendar conformed: **minted display-regime Family C**
(`text-display-micro` 10px/400 + `-medium` 500, lh 1.0) in tokens-typography.css + bridge; 6 micro-type spots →
Family C (user-decided **one token, snap 9→10** — no competing tier so single mint absorbs both; type does NOT
borrow the spacing "ties round up" rule); 8 colour spots red/amber → `error-*`/`warning-*` (user-decided **map**;
`warning-500`==`amber-700` exact, `error-*`=house carmine, "keep only what has no token home" — `sky-*` available
kept, no info-token home); §9.2c Family C promoted pending→minted; commit code `b4b58893`. **All 3 display/glyph
regime families now have minted members in use: A (avatar), C (micro); B (hero numeral) still PENDING.**
**(B) Phase 5 ☑ — ledger backfill + README↔ledger re-sync** (4 tranches): the conformance ledger had NO sections
for the 3 deep-verified groups (added, not appended) — **§ Shared primitives cross-group** (PromoteButton, ui/Modal,
form/Input·Select·Textarea, FunnelChart), **new § RG-COMMS** (8 rows incl. CourseFeed inert-token bug, `bg-[#eff6ff]`
honest-orphan, corrected false Conv-310 header claims), **new § RG-WORKSPACES studio** (8 rows / 14 comps, exact
attributions from commits 565bc4b7/90e94eb8/73c5d337/99ef1798), **§ RG-PUBPROF /creator** + 3 derived "Route
completion" rows; the 3 README group-notes (RG-COMMS/RG-WORKSPACES/RG-PUBPROF deep-verify) flipped 🔴→✅
resolved-and-ledgered; commit docs `791d04b`.
**(C) Phase 6 ☑ — shared-primitive re-check:** re-grepped the 6 cross-cutting primitives → 100% clean (0 forbidden
type/colour/inert-neutral) → the 8 confirmed groups no longer overstated. 🟠 Phase 6 surfaced a NEW "raw-form-of-token"
class (font-weight-on-token ×6 + Module/ToDoItem `text-[Npx]`) → user-decided **ENFORCE** → spawned + completed
**[WEIGHT-NORM] #30** (11 raw-form spots normalized across 8 shared/ui primitives — `font-weight`-on-token → token
weight variant, `text-[Npx]`+`leading-[normal]` → size token; zero visual change, all body tokens lh 1.0) and its
incidental-colour follow-up **[SHARED-COLOUR] #31** (collapsed to ONE live fix: ProgressBar `bg-secondary-100`→
`bg-neutral-100`; rest reclassified dead/legacy: FeedsHub/HomeFeed/UserCardCompact 0-importers → OLD-PORTED-CLEANUP,
FormModal → RG-ADMIN, Breadcrumbs → /old-shell-only); recorded in ledger Open-decision #4; commits code `65791c49` +
docs `67e7b6d`. **Full suite NOT re-run this conv (className/token-only; last green 6741/6741 Conv 327) → #12.**
✅ **[RG-SESSION] RESOLVED Conv 331 — NOT a route surface (the premise was a doc-comment misread).**
`/session/[id]` renders ONLY `<SessionRoom>` (the island tree RG-SESSIONS already swept Conv 308); the
`SessionHistory` mention on line 19 of `[id].astro` is a backref comment (links that *used to* 404 before the
route existed), not a render. Both flagged components are orphaned (not on any live route): `AvailabilityEditor.tsx`
(superseded by AvailabilityCalendar, 0 importers, no test) was **DELETED Conv 331**; `SessionHistory.tsx`
(0 importers, superseded by TeacherSessionsList on `/teaching`, but carries a maintained ~45-case test + richer
features) was **KEPT + flagged [SESSHIST]** (re-wire or delete). RG-SESSIONS SWEPT claim stands.
Full findings: `.scratch/2026-06-23-rtmig4-reconciliation-deepverify.md`),
**[SESSHIST] #28** (Conv 331 flagged `SessionHistory.tsx` — 0-importer orphan superseded by the
live `TeacherSessionsList` but holding richer features + a ~42-case test. **Disposition DECIDED
Conv 338 = harvest then delete, drop sort/pagination.** **Phase 1 ☑ Conv 338** (commit `0661e596`) —
ported the data-model-compatible features into `TeacherSessionsList`: status + date-range filters
(server-side, via `/api/me/teacher-sessions` params — required because the live component fetches
only a recent window) + a per-session expandable detail (info / feedback / attendance, the sole
consumer of `/api/sessions/[id]/attendance`), reusing the conformed `@components/form/Select`.
Sort + pagination intentionally **dropped** (flat-table affordances that fight the grouped
course→student model). **Phase 2 ⏭️ next conv** — adapt SessionHistory's ~42-case test onto
`TeacherSessionsList` (currently 0 tests), browser-verify the `/teaching` sessions tab, then delete
`SessionHistory.tsx` + its test + the barrel line), [ROLE-SEMANTICS]
(✅ resolved Conv 315 — was the RG-PUBPROF gate), [OLD-PORTED-CLEANUP], [PREFLIP-WT],
[E2E-MIG] (✅ **dropped** Conv 347 — Playwright frozen; see `docs/decisions/06-testing-ci.md`),
[E2E-GATE] (✅ done Conv 347 — PLATO instanceFile-gate), [ICN-NS], [TZ-AUDIT], [DOCGEN-SPEC], [V217-WATCH], [MEM-PRUNE],
[LAYOUT-SG], **[BRAND-CASE]** (Conv 349 — app-wide `PeerLoop`→`Peerloop` camelCase cleanup, ~45 hits; TodoWrite #17), **[PROV-STAMP-GAPS]** (✅ DONE Conv 338 — **page-marker axis only**: audited all 46
non-legacy root pages (`src/pages` excl. `old/`/`dev/`/`api/`) → **0 gaps**, every page carries a
real top-of-file 3-marker comment (43 `@matt-inspired`, 2 `@matt-source`, 1 `@stand-in` =
`become-a-teacher.astro`); the route sweep stamped them as it went, no work needed. Detector gotcha
logged → spawned **[PROV-SWEEP-MI]**: marker names recur in graduation-history prose, so use
`grep -oE '@(stand-in|matt-source|matt-inspired)' <file> | head -1` (first token in doc order),
not line-level/substring matching — teach this to `prov-sweep.ts`. **NB scope:** this closed the
*page top-of-file marker* axis; the component-level `data-prov`/registry-stamp items historically
folded here (InterestsSettings missing-stamp [conformance ledger #25]; the `prov:sweep` "pre-existing"
issues in the [Tier-2 ledger](tier2-primitive-ledger.md)) are a *separate provenance axis* and were
NOT in this audit), [XCUT-BACKREF] (✅ DONE Conv 337 — both flagged halves verified
CLEAN, no code change: admin red-links `grep -rnE 'text-red-(500|600|700)' src/components/admin`
= 0 hits (RG-ADMIN already flushed the red-link family); all 32 `UserAvatar` consumers audited for
overflow — every site wraps the avatar in `shrink-0` or pairs it with a `flex-1 min-w-0` sibling, no
overflow risk anywhere; side-finding `UserCardCompact.tsx` confirmed 0 real importers → [OLD-PORTED-CLEANUP]),
[CCARD-CONF]
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
| ☑ | `/course/[slug]/[...tab]` | `course/[slug]/[...tab].astro` | **SWEPT Conv 295.** `@matt-source` hub (8 tabs). Page shell clean Matt; assessed page + all 14 subcomponents. **No per-route fixes** — 4 hard-hex swaps applied then **reverted** after classifying them as Matt primitive-signature / convention values (not strays): `#f6f6f6`+`rgba(88,77,244,.14)` = `AnalyticCount` Default signature; `#1f2937` = shared no-thumbnail fallback. **Precedent set:** classify hard-hex before swapping (primitive→adopt; convention/recurring→tokenize app-wide; only strays→per-route swap). Candidates logged in [ledger](tier2-primitive-ledger.md): AnalyticCount adopt/extend, TagPill, `#f6f6f6` tokenize-at-primitive, no-image-color (`#1f2937` vs `#414141`) reconcile. EnrollButton dropped (already Matt via `PrecheckoutContent variant="matt"`; legacy path is `/old`-only → dead-code after [OLD-PORTED-CLEANUP] #6). Tier-2 sensor: all loop-repeated substrate. Gate green; browser DOM-verified. Step-7 review: nothing out-of-scope. Hero inset-vs-full-bleed → **✅ resolved Conv 364: keep inset** (matches Matt source; see [LAYOUT-SG]). **Conv 304 — conformance 4-gate BACKFILL STARTED ([CDETAIL-CONF], multi-conv):** the Conv-295 sweep predates the Conv-299 conformance gate (it was done to the legacy-port standard), so the hub family carries unpaid Type/Spacing/Colour debt. 3 of ~15 components green this conv — `CourseHeader` (hero `font-bold` 700→`text-h1-bold` 600 + 2 type tokens), `AnalyticCount` (EXTENDED with a `trigger` variant), `ReviewsTab` (3 pills adopt `AnalyticCount` + prose tokens). Per-component remaining list + decided conventions live in the [conformance ledger § course-detail](../typo-fdn/migration-ledger.md) + [CDETAIL-CONF]. **Conv 305 — [CDETAIL-CONF] conformance backfill CODE-COMPLETE end-to-end (browser-verify is the only remaining step before this row's conformance can be declared):** resolved the 2 carried-over open questions (TagPill→EntityPill `muted` variant; CourseHeader off-scale spacing) then conformed the whole family — all hub components (CourseHeader, EntityPill `muted`, CreatorTab, ModulesTab, MattCourseFeed, PrecheckoutContent, MySessionsTab, TeachersTab) + sibling routes `/book` + `/success` + their islands (SessionBooking, MilestoneComposer, ExpectationsForm), all 3 axes. 4 code + 4 docs commits, 5 gates green. **Spacing-snap policy GENERALIZED** (§170 carve-out: off-scale `@matt-source` spacing snaps to nearest 4px step, ties up — even Figma-verified Matt literals; Colour keeps its exception model). 🟠 Found + fixed **TeachersTab's stale Spacing ☑** (predated the snap policy) — pre-Conv-305 Spacing ☑ rows across other RG groups may similarly carry off-scale spacing (`[SWEEP-SPACING-GREP]` catches this). **Conv 306 — ✅ CONFORMANCE BACKFILL COMPLETE (browser-verified, DOM-truth: enrolled member `sarah.miller`/`intro-to-n8n` across about/creator/modules/feed/book/success + visitor on bare-hub/benefits + `/profile` regression).** The verify caught that the Conv-305 file-conformance hadn't reached the SHARED sub-components/primitives the conformed files compose — snapped 16 to scale (SubNav/SubNavItem, Button, IconLabelChip, SocialPost, FormField, CourseEmbedCard, CourseInFeed, ReviewsTab, + 7 entity anchors; deterministic px→nearest 4px step, ties up, ≤2px). All hub/sibling surfaces now Matt-scale; gates green (tsc/check/lint/build + Button/EnrollButton 22/22). **Stale "clean" ☑ on SubNav corrected** (last touched Conv 244, pre-snap-policy). Residual = logged ReactionButton-geometry deferral (`AnalyticCount`/`Module` reaction pills `px-[9px]`/`py-[5px]`) only. Shared-primitive snap propagates app-wide (`/`, `/courses`, `/profile`, feeds — conformance-additive). Detail: [conformance ledger § course-detail](../typo-fdn/migration-ledger.md). |
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
| 🗑️ | ~~`/feed`~~ | ~~`feed.astro`~~ | **RETIRED Conv 331** (user decision, [OLD-RETIRE-DEFAULT]). Was a standalone duplicate of Home's `<SmartFeed>` (the code already redirected `/feed`→`/` for visitors + middleware special-cased it). Page deleted; `/feed` dropped from middleware PROTECTED_EXACT + the special-case removed; `MyFeeds` "View Smart Feed" → `/`; `middleware.test.ts` updated (84/84). `SmartFeed` + `/api/feeds/smart` stay on Home. |
| 🗑️ | ~~`/feeds`~~ | ~~`feeds.astro`~~ | **RETIRED Conv 331** (user decision). Was the Discover "feeds to follow" directory (`FeedsDiscoveryGrid` + `FeedsDirectory`) reachable only via the My-Feeds dashboard panel + Home end-of-feed nudge + the legacy AppNavbar DiscoverSlidePanel. Page + both orphaned islands deleted; `SmartFeed` "discover more" → `/communities`; `MyFeeds` "See All"/"+N more" removed (panel now lists all feeds inline); DiscoverSlidePanel "Feeds" item + its `FeedIcon` import removed. (`FeedAllTab`/`FeedRoleTab` kept — still used by `/old` ExploreFeeds; die with [OLD-PORTED-CLEANUP].) |
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
| ☑ | `/session/[id]` | `session/[id].astro` | **SWEPT Conv 308.** Page shell + island tree (SessionRoom → SessionPrepare / SessionParticipantCard / SessionCompletedView, + sibling SessionBooking on `/book`) clean Matt. **Tier-2 EXTRACTED: `StarRating`** (`ui/StarRating.tsx`, interactive + readonly fractional-fill) — unified 3 divergent star colourings (`#f5b800` / `amber-400` / `text-star`) onto `--star`; adopted in SessionCompletedView (main+sub), CourseReviewModal (local StarRow), SessionBooking `/book` readonly avg badge (backward-pointer re-glanced). **Conformance:** Colour `bg-gray-100`→`neutral-100` ×7 + star gold→`text-star` (stale "no token exists" comment retired — token existed since Conv 297); Type clean (★ glyph px = icon-exempt, primitive-owned); Spacing `gap-10`/`pl-10` (rendered 40px off-scale)→`gap-12`/`pl-12` (Conv-305 snap). **Tier-2 applied:** `Textarea` adopt ×3 (stuck-msg + comment + goals). C-keep: `bg-white` send-circle (no white token). Gate: tsc 0 / lint 0 / 105 booking tests; DOM+screenshot verified (interactive 4-gold+1-grey rgb 245,166,35; readonly half-star at 4.5; Textarea white-fill r12px placeholder preserved); prov:sweep clean for StarRating. Early/prepare composer DOM-verified Conv 308 (temp future-dated session): `gap-12`/`pl-12` = 12px, `bg-neutral-100` rgb(241,241,241); seed restored. **✅ [RG-SESSION] RESOLVED Conv 331 — sweep stands, no re-open.** The Conv-330 follow-up suspected SessionHistory.tsx + AvailabilityEditor.tsx routed via `/session/[id]`; Conv-331 triage disproved it — `[id].astro` renders ONLY `<SessionRoom>` (the swept tree), and the `SessionHistory` reference there is a doc-comment backref, not a render. Both components are orphaned (render nowhere): AvailabilityEditor DELETED Conv 331 (superseded by AvailabilityCalendar); SessionHistory KEPT + flagged [SESSHIST] (re-wire vs delete — has a maintained test + richer features than the live TeacherSessionsList). |

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
| ☑ | `/learning/[...tab]` | `learning/[...tab].astro` | **SWEPT Conv 318 — 7 components conformed, DOM-truth verified (member sarah.miller, both tabs).** Conv-255 pilot; [LEARN-ISLAND-RESTYLE] folds here. Conformed the 5 planned islands — **StudentDashboard, StudentSessionsList, EnrollmentCard, CertificatesSection, MyFeeds** — plus 2 sub-tree comps walked from them: **CollapsibleSection** (MyFeeds frame, also /old/dashboard — freeze lifted so the incidental restyle is OK) + cross-cutting **RecordingLink** (12 consumers; Rule-of-Three Fix — dropped `dark:`, secondary→neutral; → back-glance its swept consumers RG-SESSIONS/COURSES/PUBPROF under [XCUT-BACKREF]). **Decided (user, Conv 318): decorative (non-CTA/non-link) sky `primary-*` → brand-purple** (badge bg `brand-100` #ECEBFE / text `brand-500` / solid fills like progress bar + module circle `brand-300` #584DF4); **interactive sky split** — primary CTAs → `<Button>` (americana-blue, colour-neutral), inline text links → `text-primary-default`. Slate `secondary-{200/300/400}`→`neutral-300`, `600`→`neutral-500`, `700/900`→`neutral-700/900` (scale is {50,100,300,500,700,900}); spacing `X-N`→`X-(N×4)` literal-Matt; `rounded-xl/lg`→`12/8`; type→Matt tokens. **Honest-orphan keeps:** status pills (green/blue/amber/red) + stat colours, cert-type tints (blue/purple/green), feed-type tints, red new-post dots, green "Join Now"/live-session CTA, amber review-reminder→`warning-*` + star→`text-star`, avatar-initial `font-bold` (UserAvatar display-exception). **Tier-2:** `<Button>` adopted (primary/outlined/warning/danger variants). Gates green (tsc 0 / lint 0 / astro-check 0/0/0 / prov:sweep consistent / StudentDashboard.test 26/26). **DOM-truth (sarah.miller):** In-Progress badge #ECEBFE/brand-500, progress fill #584DF4, completed=green kept, neutral-300 borders, 12px radius, Buttons #0777B6/outlined, RecordingLink neutral-300 — **0 legacy-class leaks both tabs**. 🔴 [TZ-AUDIT]: StudentSessionsList.formatTime client:load hydration-mismatch (no timeZone) — tracked, not fixed inline. Not-rendered branches (verified structurally): Write-Review warning-Button + joinable green CTA (data-state). Step-7 user review delegated ("continue"). |
| ☐ | `/teaching/[...tab]` | `teaching/[...tab].astro` | **IN PROGRESS Conv 318 — [TEACH-ISLAND-RESTYLE] folds here.** Scoping pass (read-only): /teaching = **6 tab islands + sibling `TeacherCourseView` ≈ 4,300 ln / ~770 legacy-token occurrences** — too big for one /learning-sized pass. **Decision (user, Conv 318): decompose tab-by-tab** (vertical slices, decompose-by-cohesion) — one tab island = one conform/verify/mark unit. **7 [TCH-*] tab-unit tasks created (#25–31):** `[TCH-OVERVIEW]` #25 (Overview/TeacherDashboard) · `[TCH-ANALYTICS]` #26 (TeacherAnalytics) · `[TCH-AVAIL]` #27 (AvailabilityCalendar) · `[TCH-EARN]` #28 (EarningsDetail) · `[TCH-SESSIONS]` #29 (TeacherSessionsList) · `[TCH-STUDENTS]` #30 (MyStudents) · `[TCH-COURSEVIEW]` #31 (sibling `TeacherCourseView`, `/teaching/courses/[courseId]`). **`[TCH-OVERVIEW]` #25 ☑ COMPLETE (shell Conv 318 + 8 sub-components Conv 319):** `TeacherDashboard` is a thin composition shell (291 ln) over **8 sub-components (~914 ln; `TeacherCertifications` shared across 10 consumers)** — so the "overview tab" is a full /learning-sized unit (9 files / ~1,200 ln). Conformed `TeacherDashboard`'s OWN shell only this conv: skeleton, error→`<Button variant="danger">`, header→`text-h2-bold`, availability toggle (green-status kept + knob collapse-fix), quick-actions, View-Profile→`<Button variant="outlined">`. tsc clean. Committed shell as partial `ce1ce61f`. `ProgressionNudge`/`PromoteNudge` already conformed (0 legacy). **Conv 319 — conformed all 8 sub-components 3-axis:** DashboardStatCard (accent quartet kept), EarningsOverview (Request-Payout→americana `<Button>`, user decision; This-Month green kept), QuickActionButton, TeacherCertifications (shared 10× → `[XCUT-BACKREF]` #22 back-glance), TeacherPendingActions (amber callout→`warning-*`, count badge `warning-300`+white for sparse-scale collapse), TeacherUpcomingSessions (SSL-analogue; 🔴 `formatDate`/`formatTime` TZ hydration-mismatch left as-is → `[TZ-AUDIT]` #10, matches StudentSessionsList), TeacherStudentList (tabs active→americana, count badge→brand [forced — americana has no tint-bg]), AvailabilityQuickView. Gates green (tsc/eslint/astro-check 0/0/0 + 48/48 on EarningsOverview+TeacherStudentList+TeacherDashboard tests). **DOM-verified** live (teacher Marcus Thompson): `brand-100`→#ECEBFE, `brand-300`→#584DF4, Button+links→#0777B6 americana, warning/neutral/error resolve; 0 legacy leaks, 0 real transparency traps (1 `hover:bg-brand-100` false-positive confirmed). Code `05104f07`. **`[TCH-ANALYTICS]` #26 ☑ Swept (Conv 319):** TeacherAnalytics (436 ln) + shared **DateRangeSelector** (76 ln, also consumed by Admin/Creator analytics → `[XCUT-BACKREF]` #22) conformed 3-axis; MetricCard icon→brand tint, error→`error-*`/`<Button danger>`, `h-48`→`h-192` (bridge-shrink restore); **trend/threshold status hues (green/red/amber) + chart-series colours (#059669) kept honest-orphan**. Gates green (tsc/eslint/astro-check + 88/88 Teacher/Creator/Admin analytics tests — shared-component change safe). DOM-verified live (`/teaching/analytics`, Marcus Thompson): brand-100→#ECEBFE, neutral/status hues resolve, 0 leaks/traps, 7 sections. Code `eb0a416d`. **`[TCH-AVAIL]` #27 ☑ Swept (Conv 319):** AvailabilityCalendar (958 ln, largest) conformed — neutral/spacing/radius/type, Save→`<Button>`, Mark-Available/Today/select-focus→americana. **USER DECISION (Conv 319, playbook refinement):** the calendar's sky-blue "available"-state tints are KEPT as a semantic status hue (NOT recolored decorative→brand), parallel to red=blocked/amber=series-end/green=saved — migrated off the retired `primary-*` ramp to Tailwind `sky-*` (identical hex). **Emergent rule: map to a Matt token where a semantic one exists (red→error, amber→warning); keep an honest-orphan Tailwind hue where none does (sky=available, green=saved).** Gates green (tsc/eslint/astro-check; no component test — utils/API tests cover unchanged logic). DOM-verified live (`/teaching/availability`, Marcus Thompson): **sky-\* resolves** (new scale, 11 real cells), Save/Today/focus→#0777B6 americana, 0 real leaks. Code `c5d1a76f`. **`[TCH-EARN]` #28 ☑ Swept (Conv 319):** EarningsDetail (512 ln, 42 hues — highest; **shared with /creating earnings → `[XCUT-BACKREF]` #22**) conformed — neutral/spacing/radius/type; Request-Payout→americana `<Button>` (consistent w/ TCH-OVERVIEW EarningsOverview decision), Manage/Connect→outlined Button, error→`error-*`/danger Button, course-link/Stripe-link→americana. **Rich transaction-status palette KEPT honest-orphan** per the Conv-319 status-system rule (summary-card accents green/amber/blue/purple, transaction dots paid/pending/reversed, PayoutStatusBadge 4 statuses, active pill). Gates green (tsc/eslint/astro-check + EarningsDetail.test 38/38 — updated 3 class-selectors to conformed markup). DOM-verified live (`/teaching/earnings`, Marcus Thompson): status hues resolve, Request-Payout→#0777B6 americana, 0 leaks. Code `88a9bdb5`. **`[TCH-SESSIONS]` ☑ Swept (Conv 320):** TeacherSessionsList (399 ln) conformed mirroring the conformed StudentSessionsList — neutral palette, `rounded-12/8`, literal-px spacing (`pl-16`→`pl-64` preserves the per-student row indent under the bridge), americana `text-primary-default` (Course-Details link) + shared `<Button>` (Join/View), brand-tinted avatar/message-icon. **Status colours → Matt SEMANTIC tokens (USER decision, Conv 320):** completed→`success`, scheduled→`info`, in_progress→`warning`, cancelled→`error`; matching stat accents + rating stars (amber→`warning-500`) likewise; no_show→neutral. TZ formatting left → `[TZ-AUDIT]` #10. Gates green (tsc/astro-check/lint); DOM-verified live (`/teaching/sessions`, Marcus Thompson): all 4 semantic ramps resolve, `pl-64`→64px indent, 0 legacy leaks. Code `f2589d49`. **🟠 STATUS-TOKEN RULE CORRECTED (Conv 320, `[STATUS-TOKEN-BACKMAP]`):** Conv-319 had treated green/blue as honest-orphan (no token), but `success`/`info` ramps DO exist — so green→success, blue→info now MAP. Back-applied to the swept siblings (StudentSessionsList, TeacherAnalytics, EarningsDetail, AvailabilityCalendar banners), DOM-verified; KEPT genuinely-tokenless (chart `#059669`, EarningsDetail SummaryCard categorical quartet incl. tokenless purple, AvailabilityCalendar `sky/red/amber` cell-state legend). 2 class-coupled tests updated (69 green). Code `0ee17bd9`. Rule detail: `docs/decisions/05-ui-ux-components.md` §"Status-token correction (Conv 320)". **`[TCH-STUDENTS]` ☑ Swept (Conv 320):** MyStudents (784 ln) 3-axis conformed. Status pills → Matt semantic tokens (completed→success, in_progress→info, enrolled→warning, cancelled→error) per the corrected rule; invite banners + InviteButton → warning/success/neutral; `secondary-*`→`neutral-*`; americana Search/Clear/course-link (`<Button>`/`text-primary-default`); avatar placeholder → brand. **USER decisions (Conv 320):** certified \"Teacher\" badge → brand (`brand-100`/`brand-500`); accepted-invite \"Join Session\" CTA → americana `<Button>`. Progress fill 100%→`success-500`, <100%→`brand-300`. **Spacing ×4-restore** (bridge-shrunk legacy `N` rendered `N`px → restored to the Matt set {4,8,12,16,20,24,32,40,48,64}; off-set sizes via arbitrary `[Npx]`: `h-20`→`h-[80px]`, `w-40`→`w-[160px]`, `w-48`→`w-[192px]`). Radius `rounded-xl/lg`→12/8; type→Matt tokens. 43 tests green (4 class-coupled selectors updated). DOM-verified live (`/teaching/students`, Marcus): info pill #0777B6, `rounded-12`, `px-24`/`py-16` rows, americana Search #0777B6, `brand-300` progress fill, 0 legacy leaks. **Also fixed `TeacherSessionsList` `text-neutral-400`→`neutral-300`** (neutral-400 ∉ Matt scale → resolved to Tailwind-default grey; CourseCard:160 has the same → `[XCUT-BACKREF]` #22). Code `c86a604f`. **All 6 /teaching tabs ☑ Swept. Resume point: `[TCH-COURSEVIEW]` (sibling `TeacherCourseView`, `/teaching/courses/[courseId]`, 891 ln)** — last RG-WORKSPACES /teaching piece, then `/creating`. |
| ☑ | `/teaching/courses/[courseId]` | `teaching/courses/[courseId].astro` | **☑ Swept Conv 321 `[TCH-COURSEVIEW]`.** TeacherCourseView (891 ln) 3-axis conformed: `dark:` dropped; `secondary-*`→`neutral-*`, `primary-*`→`primary-default`/`brand`; status pills → Matt semantic (completed→success, scheduled/active→info, cancelled→error, no_show→neutral); stars amber→`warning-500`; cert-dot/Active-badge green→`success`; error+Retry→`error`/`<Button danger>`; View-Course-Page→`<Button outlined>`; spacing → Matt literal-px (bridge-shrink restore); type→Matt tokens. **USER calls (Conv 321):** StatCards restyled to the swept `TeacherSessionsList` plain semantic-number pattern (icon tiles dropped, `MoneyIcon` import removed); progress fill 100%→`success-500` / <100%→`brand-300` (MyStudents rule). Gates green (tsc/eslint/astro-check 0/0/0). **DOM-verified live (Marcus Thompson, both `crs-ai-tools-overview` + `crs-intro-to-n8n`, all 6 tabs):** 0 leaks in page-owned markup; pills resolve (info `#0777B6`, success `rgb(50,125,0)`, error `rgb(176,16,47)`, no_show neutral), progress `bg-brand-300` `rgb(88,77,244)` @17%, stars `warning-500`. 🟠 Embedded shared `CourseFeed` carries legacy slate/indigo/green tokens → carved out to `[COURSEFEED-CONF]` (cohesion; ripples to all consumers, like RecordingLink) — **☑ CONFORMED + DOM-verified Conv 325** (slate→neutral, indigo→`<Button>`/primary, red→error, amber→warning, literal-px spacing, type/radius tokens; RoleBadgeInline aligned to FeedActivityCard's canonical role→token map; verified via `/old/course/<slug>/feed`, 0 legacy leaks). Code: commit pending. |
| ☑ | `/creating/[...tab]` | `creating/[...tab].astro` | **☑ SWEPT Conv 324 — CR-STUDIO (all 5 units A–E) conformed; [CREATE-ISLAND-RESTYLE] folded here.** Scoping pass (Conv 321): /creating = **5 workspace tabs + 2 sibling routes ≈ 8,000+ ln** (bigger than all of /teaching) → **decomposed tab-by-tab (mirrors the Conv-318 /teaching decision):** `[CR-OVERVIEW]` (CreatorDashboard, 319 ln — thin shell over CreatorCourseCard/PendingApprovals/TeacherList/TeachingSummary + already-conformed DashboardStatCard/EarningsOverview/QuickActionButton/MyFeeds) · `[CR-STUDIO]` 🔴 (CreatorStudio + CourseEditor 1768/Resources/Homework/Curriculum editors ≈ 4,726 ln — NEEDS sub-decomposition) · `[CR-ANALYTICS]` (378 ln, quickest — TeacherAnalytics-analogue, shared DateRangeSelector done) · `[CR-EARN]` (CreatorEarningsDetail 582 ln/279 leg — densest) · `[CR-COMMUNITIES]` (~1,029 ln). Sibling routes: `[CR-APPLY]` (`/creating/apply`, CreatorApplicationForm 328 ln) · `[CR-COMMUNITY-MGMT]` (`/creating/communities/[slug]`, CommunityManagement 468 ln). **`[CR-OVERVIEW]` ☑ Swept Conv 321:** CreatorDashboard shell (319 ln) + 4 creator sub-comps (CreatorCourseCard/PendingApprovals/TeacherList/TeachingSummary) conformed — neutral/brand/americana, status badge green→success, pending callout→warning, toggles (discussion→americana, teaching→success), **My-Teaching purple KEPT honest-orphan** (non-semantic identity accent, no Matt token — consistent w/ kept DashboardStatCard quartet), error/CTAs→Button. DashboardStatCard/EarningsOverview/QuickActionButton/MyFeeds already-conformed (skip). Gates green (tsc/eslint/astro 0/0/0). DOM-verified live (Gabriel Rymberg, creator-gated): Create/Edit americana Buttons, status badge success (rgb 50,125,0), discussion toggle americana, warning stars; residual leaks = DashboardStatCard quartet + MyFeeds red (intentional keeps). Commit pending. **`[CR-ANALYTICS]` ☑ Swept Conv 322:** CreatorAnalytics route — orchestrator (`CreatorAnalytics.tsx`) + **8 exclusive sub-components** (MetricsRow/ProgressDistribution/EnrollmentTrendsChart/FunnelAnalysis/SessionAnalytics/CoursePerformanceTable/TeacherPerformanceTable/MaterialsFeedbackView) — conformed 3-axis against the conformed TeacherAnalytics template. **Scope surprise:** ~199 legacy colour occ across 9 files, **~11× the carried "378 ln/18 leg/quickest" estimate which counted only the orchestrator**; all CreatorAnalytics-exclusive (no ripple to conf-OUT AdminAnalytics). `secondary-*`→`neutral-*`, `primary-*`→`brand`(decorative)/americana `text-primary-default`(interactive), spacing→Matt literal-px ({4,8,12,16,20,24,32,40,48,64} bare, else arbitrary `[Npx]` — **out-of-set numbers fall back to Tailwind 0.25rem base, e.g. `w-80`=320px not 80px**), `rounded-lg`→`rounded-8`, type→Matt tokens. **Semantic maps:** Active/Completed→`success`, completion-rate thresholds→`success`/`warning`/neutral, star→`text-star`, sort-active chevrons→`brand`. **`<Button>` adoption:** Create-First-Course CTA(primary)/Retry(danger)/Submit-Response(primary Small)/Load-more(outlined Small); Respond→americana text-link. **Honest-orphan keeps:** SessionAnalytics blue "Avg Duration" + purple "Total Hours" tiles (category-accent quartet, per DashboardStatCard precedent), TeacherPerformanceTable gold/bronze rank medals (amber), chart-series hex `#2563eb`/`#059669` (data-viz; legend dots mirror via `bg-[#hex]`). 5 gates green (tsc/astro 0/0/0/lint/test **6741/6741**/build) + 152 analytics component tests. **DOM-verified live (Gabriel Rymberg, creator):** rounded-8→8px, border-neutral-300→rgb(218,218,218), text-h2-bold→24px/600, success-500→rgb(50,125,0), text-star→rgb(245,166,35), brand-100→rgb(236,235,254), 0 token-resolution failures; green Active badge + gold star confirmed live in Course Performance table. 🟠 `npm run dev` cold-start hit a transient Vite SSR "multiple copies of React" dep-version mismatch on first authed-route compile (self-resolved 2nd load; infra note, not conformance). Code `e1a25942`, docs `68559c9`. **`[CR-EARN]` ☑ Swept Conv 322:** CreatorEarningsDetail (582 ln, ~270 legacy occ + **61 `dark:` variants dropped**) conformed per the established TCH-EARN/EarningsDetail playbook — it is a structural twin of the conformed `/teaching` EarningsDetail. `secondary-*`→`neutral-{50,100,300,500,700,900}` (the Matt scale; **never 200/400/600/800**), `primary-*`→`brand`/americana, spacing→literal-px, `rounded-xl`→`rounded-12`/`-lg`→`-8`, type→Matt tokens. **Status → Matt semantic tokens** (corrected rule): course Active→`success`; txn dots paid/pending/reversed→`success`/`warning`/`error`; PayoutStatusBadge pending/processing/completed/failed→`warning`/`info`/`success`/`error`; Stripe dots→`success`/`warning`/`error`; payout messages→`success`/`error`. **`<Button>`:** Retry→danger, Request-Payout→americana primary (standing user decision), Stripe Manage/Connect→outlined; text links→americana; teacher-name highlight→brand. **Honest-orphan keeps:** the 4 summary cards (categorical quartet green/amber/blue/purple, per conformed EarningsDetail) + Creator-Royalty pill purple (creator identity, per CR-OVERVIEW My-Teaching precedent). 5 gates green (tsc/astro 0/0/0/lint/test **6741/6741**/build). **DOM-verified live (Gabriel Rymberg, creator):** rounded-12→12px, summary `text-h2-bold`→24px/600, `success-100`/`-500` resolve (Active badges + Stripe-connected dot), quartet + creator-pill render, Manage-Settings outlined `<Button>` (39px pill), 0 token failures. **🔴 Cross-cut fix (folded into this commit):** the Conv-322 CR-ANALYTICS files had used non-canonical `neutral-400` (13 occ — ∉ Matt scale {50,100,300,500,700,900}, so it resolved to Tailwind-default grey) → corrected to `neutral-300` per the /teaching `neutral-400→neutral-300` precedent. Code `9d7550ba`, docs `8512740`. **`[CR-COMMUNITIES]` ☑ Swept Conv 323:** the `/creating` communities **tab** — `CreatorCommunities` (206 ln) + 2 exclusive sub-comps `CommunityCard` (86) + `CreateCommunityModal` (161) = **~453 ln**; uniform legacy `@stand-in` (indigo/gray/green, raw `<button>`s, **no `dark:`, no raw hex**). 🟠 **Scope correction:** the carried "~1,029 ln" estimate had bundled the **sibling** CR-COMMUNITY-MGMT files (`CommunityManagement`/`CommunitySettings`/`CreateProgressionModal`/`ProgressionCard` ≈ 1,044 ln) which belong to `/creating/communities/[slug]` (#29), NOT this tab; `CommunityCard` verified **exclusive** to `CreatorCommunities` (the discover `ExploreCommunityCard` hit was a substring false-match) → **no cross-cut ripple**. 3-axis: `indigo`→`brand-{100,500}` (decorative icon tiles) / americana (interactive); `gray`→`neutral-{50,100,300,500,700,900}`; spacing→Matt literal-px (bridge-collapse restore — `p-4`→`p-16`, gap/space `gap-4`→`gap-16`, `py-12`→`py-48`, icon `w-4 h-4`→`w-16 h-16`, spinner `h-8 w-8`→`h-32 w-32`, toggle `h-6 w-11`→`h-24 w-[44px]`); `rounded-lg`→`rounded-8` (`rounded-full` kept); type→Matt tokens (`text-2xl`→`text-h2-bold`, `text-lg`→`text-h3-bold`, `text-sm/xs`→`body-default/small`; emoji glyph→`text-[20px]`). **`<Button>` adoption:** Create Community ×2 + modal Submit→primary; Cancel + card Manage→outlined; error Try-again→danger Small. **Semantic map:** Public badge green→`success-500`; toggle-on→americana `bg-primary-default`; focus→`primary-default`. 5 gates green (tsc/astro 0/0/0/lint/test **6741/6741**/build). **DOM-verified live (Gabriel Rymberg, creator):** Create btn americana `rgb(7,119,182)`/39px pill, StatCard border `rgb(218,218,218)`/rounded-8, icon tile brand-100 `rgb(236,235,254)`/brand-500 `rgb(58,48,201)`/40×40, stat value 24px/600, Manage outlined pill, Public `rgb(50,125,0)` success; modal: toggle americana 24×44 + knob 20×20 white, input neutral-300/8px/14px, footer outlined+primary pills, asterisk `rgb(176,16,47)` error; **0 forbidden tokens** (card + modal paths). Code `aab40134`, docs `6da653e`. **`[CR-STUDIO]` 🔴 sub-decomposition (Conv 324):** mapped the studio tree (`src/components/creators/studio/`; all 5 child comps **exclusive** — zero external importers) into **5 cohesion units + 1 cross-cut carve-out** (~684 legacy occ total, multi-conv): **A `[CR-ST-ENTRY]`** (CreatorStudio 389 + CreateCourseModal 406) · **B `[CR-ST-CURRIC]`** (CurriculumEditor 528) · **C `[CR-ST-HW]`** (HomeworkEditor 766) · **D `[CR-ST-RES]`** (ResourcesEditor 869) · **E `[CR-ST-SHELL]`** (CourseEditor own chrome 1768, minus the 3 child editors it mounts). Mount tree: CreatorStudio → {CreateCourseModal, CourseEditor → {Curriculum/Homework/Resources}}. Shared **ConfirmModal** (99 ln, ~19 consumers incl. conf-OUT admin/teachers/community/booking) carved to **`[CONFIRMMODAL-CONF]`** (sibling of COURSEFEED-CONF; kept honest within the units). **`[CR-ST-ENTRY]` (Unit A) ☑ Swept Conv 324:** decorative indigo→`brand` (stat icon tiles/prompt circle/spinners), interactive→americana (`<Button>` primary/outlined/danger-Small + `text-primary-default` ghost Edit + `focus:ring-primary-default`), `gray`→`neutral-{50,100,300,500,700,900}`. **Status badges:** Published→`success`, Draft→`warning`, **Retired→`neutral`** (USER-confirmed Conv 324 — kept distinct from Draft, deviating from literal archived→warning). **Level badges:** Conv-323 difficulty→semantic ramp (beginner→`success`/intermediate→`warning`/advanced→`error`) — accepted Beginner+Published both-success collision. Spacing bridge-restore ×4 literal-px (`p-4`→`p-16`, spinner `h-8`→`h-32`, icon `w-12`→`w-48`; off-set `py-0.5`→`[2px]`/`py-1.5`→`[6px]`), `rounded-lg`→`8`/badge `rounded`→`4`, type→Matt tokens. 7 class-coupled CreatorStudio.test selectors updated (41/41). 5 gates green (tsc 0/astro 0/0/0/lint/CreatorStudio.test 41/41/build). **DOM-verified live (Gabriel Rymberg):** Create btn americana `rgb(7,119,182)`/39px pill, stat icon `brand-100` `rgb(236,235,254)`/`brand-500` `rgb(58,48,201)`/40×40/rounded-8, border `rgb(218,218,218)`, h2 24px/600, `success-500` `rgb(50,125,0)`/warning/neutral-700 badges, **0 legacy leaks** on landing; modal: input neutral-300/8px/14px, Submit americana pill, Cancel outlined pill, header 20px/600, **0 leaks**. Code `2cf05892`. **`[CR-ST-CURRIC]` (Unit B) ☑ Swept Conv 324:** CurriculumEditor (528 ln — Curriculum tab + ModuleModal). Form CTAs→`<Button>` primary/outlined; module-row reorder/edit/delete kept raw icon-ghost (edit hover→`primary-default`, delete hover→`error-500`); `gray`→neutral, `indigo`→americana/brand, spacing ×4 bridge-restore, `rounded-lg`→`8`/badge→`4`, type→tokens. ConfirmModal kept honest. 5 gates green (tsc 0/astro 0/0/0/lint/build; no dedicated test). **DOM-verified live (Gabriel, `crs-intermediate-q-system`, 7 modules):** Add-Module americana 39px pill, rows `rgb(218,218,218)`/rounded-8, order circle neutral-100/32×32, h3 20px/600, ModuleModal input neutral-300/8px + americana/outlined footer; **0 leaks** (tab + modal, scoped past the still-legacy CourseEditor chrome). Code `fea60cf2`. **`[CR-ST-HW]` (Unit C) ☑ Swept Conv 324:** HomeworkEditor (766 ln — Homework tab: inline new-assignment form + per-card expandable edit forms + delete-confirm strip). Form/header CTAs→`<Button>`; inline Delete + compact delete-confirm-strip kept raw error-ramp (`bg-error-300 hover:-500`); checkbox accent→`primary-default`. **Semantic maps:** Required badge red→`error`, pending→`warning`, success/error messages→ramps. `gray`→neutral, `indigo`→americana/brand, spacing ×4, `rounded-lg`→`8`/badge→`4`, type→tokens. 5 gates green (tsc 0/astro 0/0/0/lint/build; no dedicated test). **DOM-verified live (Gabriel, `crs-intermediate-q-system`):** Add-Assignment americana 39px pill, card `rgb(218,218,218)`/rounded-8, Required `rgb(255,222,229)`/`rgb(176,16,47)` (error-100/500), form input neutral-300 + americana/outlined footer; **0 leaks** (tab+card+form). Code `f20d1b03`. **`[CR-ST-RES]` (Unit D) ☑ Swept Conv 324:** ResourcesEditor (869 ln — Resources tab: upload-file + add-link forms + resource cards display/edit/delete). Upload/Add-Link/Choose-File/edit CTAs→`<Button>` primary/outlined; inline Delete + confirm-strip raw error-ramp; edit icon-ghost raw. **Maps:** Public badge green→`success`, external-link→americana, file-type icon tile→neutral chip. `gray`→neutral, `indigo`→americana/brand, spacing ×4, `rounded-lg`→`8`/badge→`4`, type→tokens. 5 gates green (tsc 0/astro 0/0/0/lint/build; no dedicated test). **DOM-verified live (Gabriel, `crs-intermediate-q-system`):** Upload-File americana 39px pill, Add-Link + Choose-File outlined pills, card `rgb(218,218,218)`/rounded-8, upload-form input neutral-300; **0 leaks** (tab+card+form). Code `3a51646a`. **`[CR-ST-SHELL]` (Unit E) ☑ Swept Conv 324:** CourseEditor (1768 ln — shell + 7 co-located sub-comps: BasicInfo/Details/ListEditor/Prerequisites/PeerLoopFeatures/Teachers/Publishing tabs). Tab-bar active→americana underline+text/inactive→neutral; status badges Published→`success`/Draft→`warning`/Retired→`neutral`; CTAs→`<Button>` primary/outlined (Preview/Save/Publish/Unpublish/Certify-Small); thumbnail Upload-Image label→americana outlined pill. **Semantic maps:** prereq chips required/nice/not→`error`/`warning`/`success`; publish checklist→success-check/neutral-circle; missing-box→`warning`; Teacher activate/deactivate/revoke→`success`/`warning`/`error` compact (raw); **"About PeerLoop" info box→`brand`** (decorative-indigo→brand, brand-identity content). spacing ×4 (thumbnail `w-48`→`[192px]`/`h-28`→`[112px]`, avatars `w-9`→`[36px]`), `rounded-lg`→`8`, type→tokens. 5 gates green (tsc 0/astro 0/0/0/lint/build 7.19s; no dedicated test). **DOM-verified live (Gabriel, `crs-intermediate-q-system`):** **FULL-PAGE UNSCOPED leak = 0** (chrome + all tabs end-to-end), h1 24px/600, Published→`success`, Preview/Save americana 39px pills, active tab americana underline, inactive neutral-500; per-tab leak 0 across Basic/Details/PeerLoop/Teachers/Publishing; prereq chip→`error-100`/`error-500`, info box→`brand-100`/`brand-300`, checklist tick→`success-500` confirmed live (Teacher status buttons data-absent — no teachers/eligible on this course; verified in code). Code `1c8ced4d`. **✅ CR-STUDIO COMPLETE (all 5 units A–E ☑). RG-WORKSPACES /creating cluster 6/6 swept.** **Both cross-cut carve-outs ☑ CONFORMED + DOM-verified Conv 325** (0 legacy leaks): `[CONFIRMMODAL-CONF]` (ConfirmModal → `<Button>` danger/warning/primary + error tokens; 168 tests; back-glanced 3 swept routes) + `[COURSEFEED-CONF]` (community/CourseFeed conformed; RoleBadgeInline aligned to FeedActivityCard's canonical map; two-feeds split documented; FeedActivityCard scoped OUT). |
| ☑ | `/creating/apply` | `creating/apply.astro` | **☑ Swept Conv 323 `[CR-APPLY]`.** Become-a-creator pre-flow + nudge destination. Single island `CreatorApplicationForm` (328 ln, no sub-comps); page wrapper was already Matt. 3-axis: `secondary-*`→`neutral-{50,100,300,500,700,900}`, retired `primary-*`→americana `<Button>` (Go-to-Dashboard link / Submit-New-Application / Submit-Application) + focus `primary-default`, **status states green/amber/red→`success`/`warning`/`error`** (already-creator / under-review / denied + error banner), spacing→Matt literal-px (`p-8`→`p-32`, `h-12 w-12`→`h-48 w-48`), `rounded-xl`→`rounded-12`/`-lg`→`-8`/`-t-xl`→`-t-12` (icon circles + spinner `rounded-full` kept), type→Matt tokens (`text-lg`→`h3-bold`, `text-base`→`body-medium-bold`, `text-sm/xs`→`body-default/small`). **Page marker flipped `@stand-in`→`@matt-inspired`.** 5 gates green (tsc/astro 0/0/0/lint/test **6741/6741** incl. CreatorApplicationForm.test 15/15/build). **DOM-verified live:** already-creator state as Gabriel (panel success-100 `rgb(232,244,223)`/border success-300 `rgb(65,163,0)`/12px, heading success-500 20px/600, Dashboard americana pill) + **form state** as a non-creator (Alex Chen/newuser — card neutral-300/12px, header neutral-50/rounded-t-12, section-heading 16px/600 neutral-900, label 14px/600 neutral-700, asterisk error-500 `rgb(176,16,47)`, input rounded-8/neutral-300/14px/px-12 py-8, helper body-small/neutral-500, optional neutral-300, Submit americana pill); **0 forbidden tokens** both states. Code `89a73e49`, docs `09088ee`. |
| ☑ | `/creating/communities/[slug]` | `creating/communities/[slug].astro` | **☑ Swept Conv 323 `[CR-COMMUNITY-MGMT]`.** Creator community manage — page already `@matt-inspired`; conformed the **4 island internals** (~1,044 ln): `CommunityManagement` (468, orchestrator), `ProgressionCard` (206), `CommunitySettings` (238), `CreateProgressionModal` (132). 3-axis: `gray`→`neutral`, `indigo`→`brand`(decorative: icon tile, Creator/Learning-Path identity badges, avatar placeholder, editing-row border, Settings-active tint)/americana(interactive: Add/Save/Submit→`<Button>` primary, Cancel→outlined, Add-Course→`text-primary-default` link), `red`→`error`/danger; spacing→Matt literal-px, `rounded-lg/xl`→`8/12`, type→Matt tokens, toggle→americana. **Status → semantic** (Published `green`→`success`, Draft/Archived `yellow`→`warning`). **🟠 Course-level badges (USER decision Conv 323): mapped onto Matt semantic ramps as a difficulty gradient — beginner→`success`, intermediate→`warning`, advanced→`error`, unknown→`neutral`** (rather than kept honest-orphan); consequence: a "Beginner"+"Published" row shows two success-green pills. Icon-ghost buttons (reorder/edit/delete) + compact confirm-strip buttons + outlined-danger Archive-Community kept raw-tokenized ("no Button variant fits"). 5 gates green (tsc/astro 0/0/0/lint/test **6741/6741**/build). **DOM-verified live (Gabriel Rymberg, /creating/communities/q-system "The Q-System"):** icon tile brand-100/500 8px, h1 24px/600, Creator badge brand-100/500, Add-Progression outlined americana pill, Published+Beginner both success `rgb(50,125,0)`/success-100, Settings panel toggle americana 24×44 + Archive-Community outlined-danger (error-500 text/error-300 border) + Danger-Zone error-500; **0 forbidden tokens** (management + settings paths). Page comment's stale "[CREATE-ISLAND-RESTYLE] tracked" caveat updated. Code `12401b89`, docs `232bca3`. |

## RG-ADMIN — `/admin/*` — **[RG-ADMIN]** · ✅ COMPLETE (Conv 332–336) — shell + dashboard + 16/16 routes

**Conformance OUT (Conv 299)** — structural Tier-1/Tier-2 only, no app-wide type/spacing/colour
gate. RG-ADMIN runs its own **restyle policy** (DECIDED Conv 331, memory `project_admin_conformance_policy`):
dense-console relaxations A–D + a deliberate dark `neutral-900` "Admin" identity (americana
`info-500` accent, `admin-panel-settings` glyph, role chip), all `dark:` dropped. Multi-conv sweep.

**Shell already structurally Matt** (`AdminLayout` + `AdminNavbar`, Conv 193) — pages are thin
`.astro` wrappers mounting an island, so the per-route restyle is **island/body-only**, shell
untouched beyond its Conv-332 identity restyle. `/api/admin/*` unaffected.

**Progress — shell + dashboard + routes #1–#7 of 16 (Conv 332–333):**
- **Shell restyled (Conv 332):** `AdminLayout.astro` (body slate+`dark:`→`bg-neutral-50`) +
  `AdminNavbar.tsx` (dark `neutral-900` charcoal sidebar, `info-500` active-nav pill, gear glyph
  + "Admin" chips + role chip, 12px/10px Matt type — all slate/purple/`dark:`/`rounded-lg` gone).
  DOM-verified as admin on the persistent :4321 dev server.
- **`AdminDashboard` conformed:** all 72 `dark:` dropped, 3-axis conformance (secondary→neutral,
  primary-purple→info, status hues→Matt semantic, admin-tight type, bridge spacing restored,
  `rounded-lg`→`rounded-8`); logic verbatim. Gated + DOM-verified.
- **Shared `AdminActionMenu` primitive conformed** — RG-MOD's Conv-313 sweep skipped it
  (ModeratorQueue doesn't use it); surfaced when `/admin/topics` rendered its row-action menus.
  `gray→neutral`, danger `red-700`→`error-500`, focus-ring `indigo`→`info` + 2 latent bridge-shrink
  bugs fixed (dropdown `w-48`→`w-[192px]`, `ActionIcons` `w-4 h-4`→`size-16` ×6).
- **3 LOCKED sub-patterns** established for the remaining 12 routes: **(a)** action buttons →
  `<Button>` (its default `primary` variant IS the americana-blue #0777B6 = `info-500` — no new
  variant needed; money→`primary`, cancel→`default`, retry→`warning`, external→`outlined`,
  remove→`danger`); **(b)** admin forms → `form/Input` / `form/Textarea` / `form/Select`
  (14px field default is correct, not a density violation); **(c)** admin modals → `ui/Modal`.
- **Per-component conformance detail** (group token vocabulary + DOM-verify results) lives in the
  [conformance ledger § RG-ADMIN](../typo-fdn/migration-ledger.md).
- **✅ [FOOTER-CONF] (#26, OUT of RG-ADMIN scope) — DONE Conv 336:** shared `Footer.astro` (both compact +
  full variants + envBadgeStyles) conformed app-wide — dropped all `dark:`, `secondary-*`→neutral/text-*, legacy
  `primary`→info, DEV/STG badges `bg-blue/amber-100`→info/warning-100/500, admin-tight type. Surfaced + fixed the
  shared `DateRangeSelector` dropdown focus-ring (`primary-default`→`info-500`, the lone remaining analytics-page
  stray) → analytics routes 0-leak page-wide. **Known + ACCEPTED:** the footer's root marketing hrefs (`/privacy`,
  `/terms`, `/help`, …) 404 sitewide because RG-PUBLIC pages live only in `/old` — intentional-pending-redesign
  (see the RG-PUBLIC disposition note above), NOT a bug. Code `af8bf788` (footer) + `ba29f900` (DateRangeSelector).

**Conv 333 progress — routes #5–#7 of 16 (users, courses, enrollments):**
- **Routes #5–#7 swept:** `/admin/users` (UsersAdmin + UserDetailContent + UserEditModal→`ui/Modal`),
  `/admin/courses` (CoursesAdmin + CourseDetailContent), `/admin/enrollments` (EnrollmentsAdmin +
  EnrollmentDetailContent — same CRUD pattern, all decisions precedent-locked, no novel forks). 3 markers
  flipped `@stand-in`→`@matt-inspired`. 3 more latent `text-red-600` deep-links fixed→`text-info-500`.
- **Shared `FormModal` primitive conformed** (backward-pointer rule) — indigo×2 + gray×6 token-conform +
  Button-variant adoption; surfaced while sweeping `/admin/users`.
- **App-wide `UserAvatar` bridge-fix (highest blast radius):** its `sizeClasses` were 4×-shrunk since
  Conv 174 (in-set numeric `h-8/h-12/h-16/h-24` → 8/12/16/24px instead of intended 32/48/64/96px on
  **every consumer** ~15 live). Restored to bridge-safe utilities (in-set N→`h-N`px, off-set→arbitrary).
  `xs` (`h-6`) was correct by accident, unchanged. `/creator/[handle]` xl spot-checked (96px, no overflow);
  **the remaining ~15 consumers need a layout re-verify → [XCUT-BACKREF].**
- **Recurring bridge shrink-set trap** fixed in 5 places across the 3 routes (toggle knob, course
  thumbnail, rating star, list progress wrapper, module-row icons).

**Conv 334 progress — routes #8–#10 of 16 (recordings, teachers, sessions):**
- **Routes #8–#10 swept:** `/admin/recordings` (RecordingsAdmin + inline StatusBadge — quick win),
  `/admin/teachers` (TeachersAdmin + TeacherDetailContent), `/admin/sessions` (SessionsAdmin +
  SessionDetailContent — largest route, 706+273 ln). All three **zero-backward-pointer** — every
  shared dep (`Admin*` primitives, `ConfirmModal`, `FormModal`, `RecordingLink`) was already conformed
  by earlier convs, so each route was mechanical token swaps + Button/UserAvatar adoption. 3 markers
  flipped `@stand-in`→`@matt-inspired`.
- **`UserAvatar` adopted** on teachers (×1 sm) + sessions (×4: 2 sm row, 2 md detail), replacing inline
  avatar fallbacks (rides the Conv-333 app-wide bridge-fix).
- **3 more latent `text-red-600` deep-links fixed→`text-info-500`** (TeacherDetailContent ×2, SessionDetailContent ×1) —
  the admin "View X →" red-link copy-paste lineage; candidate for a single grep flush → [XCUT-BACKREF augment].
- **Decisions (all precedent-locked):** sessions 6 stat hues → semantic tokens (Total neutral / Today+Week info /
  Completed success / Cancelled error / With-Recording brand); detail-footer Buttons follow the Conv-332 reversibility
  rule; sessions date-range filters inline-conformed under relaxation C (not adopting `form/Input`).

**Conv 335 progress — routes #11–#14 of 16 (`/admin` dashboard, certificates, moderators, moderation):**
- **Routes #11–#14 swept:** `/admin` dashboard route page (**pure marker flip** — island `AdminDashboard`
  + shell already conformed Conv 332, re-verified this conv: 0 forbidden tokens, gates green, DOM-truth :4321);
  `/admin/certificates` (CertificatesAdmin 604 ln + CertificateDetailContent 154 ln); `/admin/moderators`
  (ModeratorsAdmin 647 ln + ModeratorDetailContent 121 ln); `/admin/moderation` (**BIGGEST — 4 components,
  1257 ln:** ModerationPage shell + ModerationAdmin 740 + SystemPromotionsModeration 149 + shared
  ModerationDetailContent 325). All **zero-backward-pointer** on their shared deps (`Admin*` primitives,
  `ConfirmModal`, `FormModal` already conformed). 4 markers flipped `@stand-in`→`@matt-inspired`.
- **Structural: certificates Revoke modal → shared `FormModal`** (−52 ln; removed `showRevokeModal`/`revokeReason`
  state, folded `handleRevoke` into `onSubmit`) — the established admin form-modal pattern (sub-pattern (c),
  8th consumer). Only `CreatorApplicationsAdmin`'s custom modal now remains in the admin tree (route still unswept).
- **Cross-surface consistency by reference:** `/admin/moderation`'s `ModerationDetailContent` badge helpers
  (`getReason`/`getPriority`/`getContentTypeBadgeClass`) **mirror RG-MOD's `ModeratorQueue` helpers verbatim**
  (priority→status tokens; reason mapped where valence clear; content-type honest-orphans kept — orange/purple/
  indigo/cyan/pink) so `/admin/moderation` ≡ `/mod` visually. 9 stale `ModerationDetailContent.test` badge-class
  assertions updated to the conformed RG-MOD strings → `ModerationAdmin`+`ModerationDetailContent`+`ModeratorQueue` 166/166.
- **`UserAvatar` adopted** across all four (certificates recipient sm; moderators row sm + detail md; moderation
  rows xs + detail sm). **Stat cards mapped by lifecycle meaning** (certificates Total neutral/Pending warning/
  Issued success/Revoked error; moderators Active neutral/Pending warning/Accepted success/Declined error).
  Footer/header Buttons adopted (moderation Dismiss default/Remove danger/Warn warning/Suspend `suspend` — mirrors
  RG-MOD action vocabulary). Tabs indigo→`info-500` + semantic count badges. 5 latent red-links→info.
- **High-volume mechanical conform** (moderation ~98 hues): color `replace_all` for 1:1 COLOR tokens, explicit
  size+weight edits handled separately (weight-on-token rule). `certificates`+`CertificateDetailContent` tests 58/58.

**Conv 336 progress — routes #15–#16 of 16 (creator-applications, analytics) → ✅ RG-ADMIN COMPLETE 16/16:**
- **Route #15 `/admin/creator-applications` swept:** `CreatorApplicationsAdmin` + `CreatorApplicationDetailContent`
  — the certificates twin, zero novel decisions. **Structural: Deny modal → `FormModal`** (sub-pattern (c), 9th
  consumer) — **retired the LAST hand-rolled `fixed inset-0` modal in the admin tree** (removed showDenyModal/
  denyReason/denyNotes/actionLoading state; folded handleDeny into the onSubmit). 4 stat hues, tabs→info + semantic
  badges, applicant→`UserAvatar sm`, expertise chips indigo→neutral, footer Deny→danger/Approve→primary, 🔴 red-link
  "View profile" + message/portfolio icons→info, 2 bridge-shrinks fixed. Marker `@stand-in`→`@matt-inspired`.
- **Route #16 `/admin/analytics` swept** (genuinely-different route — 6-section chart/metrics dashboard, 7 files
  ~57KB): `AdminAnalytics` + 6 `analytics/admin/*` section wrappers. **Zero backward-pointer** — every chart/table
  primitive (`AreaChart`/`PieChart`/`FunnelChart`/`BarChart`/`MetricsRow`/Course+TeacherPerformanceTable/
  `DateRangeSelector`) was already conformed under RG-WORKSPACES (Conv 318–324); only the section wrappers' chrome
  was raw. **Chart-palette = honest-orphan hex** (DECIDED Conv 336): mirror the conformed workspace charts — keep
  series colours as explicit hex (`#2563eb`/`#059669`) with a "data-viz convention; not Matt-tokenized" comment,
  tokenize only the chrome (cards, headers, KPI values, status hues, skeletons). DOM-verified 0-leak across all 7
  files. Marker `@stand-in`→`@matt-inspired`.
- **Cross-cut [FOOTER-CONF] #26 (app-wide):** shared `Footer.astro` conformed (both compact + full variants +
  DEV/STG badges `bg-blue/amber-100`→info/warning) — dropped all `dark:`, secondary→neutral, legacy primary→info.
- **`DateRangeSelector` dropdown focus-ring** `primary-default`→`info-500` — the lone remaining analytics-page
  stray (affects all analytics routes admin + workspace); analytics now 0-leak page-wide.

**✅ RG-ADMIN COMPLETE — 16/16 routes swept (Conv 332–336).** The detail rows below carry the per-route
Conv-332→336 notes.

**🟠 Conv 337 tail — [ADMIN-TEST-STALE] (5 stale admin tests fixed; baseline restored).** A full-suite
run during the unrelated spacing sweep surfaced 5 failures; `git stash` proved them **PRE-existing** (red on
the clean tree). All 5 were className-asserting tests left stale by the Conv-332→336 conformance restyle (the
elements still render — only the assertions referenced retired classes); the suite was evidently never run
end-to-end across those convs (Baseline Rule-2 carry-forward gap). Fixed the assertions/selectors to the
conformed classes: `bidirectional-links` `text-red-600`→`text-info-500` (test renamed red→info),
`SessionDetailContent` `bg-secondary-50`→`bg-neutral-50`, `AdminAnalytics` `.bg-red-50`→`.bg-error-100`,
`CoursesAdmin` `.bg-gray-200.rounded`→`.bg-neutral-100.rounded-4`, `EnrollmentsAdmin` filter
`text-2xl`/`font-bold`→`text-h2-bold`. **Suite restored 6737/6737 GREEN.** Code `838da44d`.

| Swept | Route | File | Port |
|-------|-------|------|------|
| ☑ | `/admin` | `admin/index.astro` | **☑ Swept Conv 335 — route #11 (pure marker flip).** Island `AdminDashboard` (544 ln) + `AdminLayout` shell already conformed Conv 332; re-verified this conv (read both in full — 0 `dark:`/`secondary-`/red-links, info-500 accent, conformed type tokens) → route was marker-only. Flipped `index.astro` `@stand-in`→`@matt-inspired`. 🔴→🟢 caught a marker-tally anomaly (`grep -rl '@stand-in'` false-positives on the `Was @stand-in` provenance breadcrumb of already-flipped pages) — verified benign, corrected tally. Gates green (tsc 0 / astro 0/0/0 1432 / lint 0), DOM-verified :4321 (h1 "Dashboard", stat-icon info-500 `rgb(7,119,182)`/info-100, sidebar neutral-900 `rgb(31,31,31)`, 13 cards, 0 red-links). Code `fd7cb23d`. |
| ☑ | `/admin/analytics` | `admin/analytics.astro` | **☑ Swept Conv 336 — route #16 (genuinely-different route: 6-section chart/metrics dashboard, 7 files ~57KB).** `AdminAnalytics` + `AdminKPICards` + Revenue/Users/Courses/Teacher/Engagement sections. **Zero backward-pointer** — every chart/table primitive (`AreaChart`/`PieChart`/`FunnelChart`/`BarChart`/`MetricsRow`/Course+TeacherPerformanceTable/`DateRangeSelector`) already conformed under RG-WORKSPACES (Conv 318–324); only section-wrapper chrome was raw. **Chart-palette kept as honest-orphan hex** (DECIDED Conv 336, mirrors conformed workspace charts: series colours `#2563eb`/`#059669` + "data-viz; not Matt-tokenized" comment; legend swatches mirror via `bg-[#hex]`) — tokenize chrome only. Cards→white/neutral-300/r8/p24, section h2→body-large-medium, KPI/metric value→h2/h3-bold, status good/warning/bad→success/warning/error, KPI icon-chips→info-100/500, trend up/down→success/error, flywheel-health→semantic tints, 2 leaderboard tables admin-tight, 2 inline avatars→`UserAvatar xs`, rating star→`text-star`, error card→Button primary, skeletons→neutral-300/100. Marker `@stand-in`→`@matt-inspired`. Gates green, DOM-verified :4321 (**0 leaks in the 7 files**; page strays were Footer + DateRangeSelector focus-ring, fixed separately). Code `036969fc`. |
| ☑ | `/admin/announcements` | `admin/announcements.astro` | **☑ Swept Conv 332 — route #3.** First form-heavy route. Adopted `form/Input` ×4 + `form/Textarea` for the inline authoring form (`type="datetime-local"` forwards via the primitive `...rest`); checkbox inline-conformed; submit→Button primary; two-step Remove (outlined-error trigger → `danger` confirm). All 25 `dark:` dropped, badges→semantic. Locked sub-pattern (b). Gates green, DOM-verified (4 Input primitives r12, Textarea min-h-96). Code `036a56fe`. |
| ☑ | `/admin/certificates` | `admin/certificates.astro` | **☑ Swept Conv 335 — route #12.** CertificatesAdmin (604 ln) + CertificateDetailContent (154 ln). Composes already-conformed `Admin*` primitives + `ConfirmModal` → zero backward-pointer. **Structural: hand-rolled Revoke modal → shared `FormModal`** (−52 ln; removed `showRevokeModal`/`revokeReason` state, folded `handleRevoke` into `onSubmit`) — sub-pattern (c), 8th consumer. Recipient avatar→`UserAvatar sm`; typeColors blue/purple/green→info/brand/success (purple→brand precedent); 4 stat hues (Total neutral/Pending warning/Issued success/Revoked error); tabs→info-500 + semantic count badges; detail-footer Buttons (View-Public outlined href / Approve primary / Reject+Revoke danger); error-retry→primary; 🔴 2 red-links→info-500. Marker `@stand-in`→`@matt-inspired`. Gates green, `CertificatesAdmin.test`+`CertificateDetailContent.test` 58/58 (no edits), DOM-verified :4321 (9 certs, FormModal renders). Code `a1be3f53`. |
| ☑ | `/admin/courses` | `admin/courses.astro` | **☑ Swept Conv 333 — route #6.** CoursesAdmin + CourseDetailContent. `gray→neutral`, `indigo→info`, admin-tight type, bridge spacing restored; stat cards→success/info, rating→`text-star`, thumbnail/star bridge-shrink fixed. 🔴 Fixed 2 latent `text-red-600` deep-links (View course + View creator)→`text-info-500`. Marker `@stand-in`→`@matt-inspired`. Gates green (tsc 0 / lint / astro 0/0/0), DOM-verified. Code `bb1ea2fb`. |
| ☑ | `/admin/creator-applications` | `admin/creator-applications.astro` | **☑ Swept Conv 336 — route #15 (the certificates twin, zero novel decisions).** `CreatorApplicationsAdmin` + `CreatorApplicationDetailContent`, composing already-conformed primitives → zero backward-pointer. **Structural: hand-rolled Deny modal → shared `FormModal`** (sub-pattern (c), 9th consumer; removed showDenyModal/denyReason/denyNotes/actionLoading state, folded handleDeny into onSubmit, panelWasOpen capture preserves refetch-detail-only-from-panel semantic) — **the LAST hand-rolled `fixed inset-0` modal in the admin tree, now retired.** 4 stat cards→lifecycle hues (Total neutral/Pending warning/Approved success/Denied error); tabs→info active + semantic count badges; applicant→`UserAvatar sm`; expertise chips indigo→neutral; footer Deny→danger/Approve→primary; error card→Button primary; 🔴 red-link "View profile" + message-icon + portfolio→info; 2 bridge-shrinks fixed (ProfileIcon/MessagesIcon→size-16/20). Marker `@stand-in`→`@matt-inspired`. Gates green (tsc 0 / astro 0/0/0 / lint), DOM-verified :4321 (h1 24px neutral, 4 stat hues, tabs info + badges, avatar 32px, red-link→info, footer Deny danger/Approve info, Deny FormModal renders + closes on Cancel). Code `421aca54`. |
| ☑ | `/admin/enrollments` | `admin/enrollments.astro` | **☑ Swept Conv 333 — route #7.** EnrollmentsAdmin + EnrollmentDetailContent (same CRUD pattern, decisions precedent-locked — no novel forks). `UserAvatar` sm/md adopted; progress bars→`info-500`; 4 stat cards (neutral/info/success/error); detail-footer normalized to Button `primary`/`danger`/`warning`/`default` (Force-Complete→primary, Full-Refund→danger, Partial-Refund→warning, Cancel→default — sub-pattern (a)); reassign `<select>` inline-conformed (relaxation C); 3 indigo links→info; bridge-fixes (thumbnail / progress wrapper / module icons). Marker `@stand-in`→`@matt-inspired`. Gates green (tsc 0 / lint), DOM-verified (avatar 32/48px, progress info-500 in 128px track, footer pills, 0 indigo). Code `bb1ea2fb`. |
| ☑ | `/admin/moderation` | `admin/moderation.astro` | **☑ Swept Conv 335 — route #14 (BIGGEST, 4 components, 1257 ln).** `ModerationPage` (43 ln tab shell) + `ModerationAdmin` (740) + `SystemPromotionsModeration` (149) + shared `ModerationDetailContent` (325); ~98 hues. All compose conformed primitives + Confirm/FormModal → zero backward-pointer, no custom modals. **Badge helpers (`getReason`/`getPriority`/`getContentTypeBadgeClass`) mirror RG-MOD's `ModeratorQueue` verbatim** (priority→status tokens; reason mapped where valence clear — harassment→error/spam→warning; content-type orphans kept honest — indigo/cyan/pink) so `/admin/moderation` ≡ `/mod` visually. All avatars→`UserAvatar` (xs dense rows, sm detail); **footer Buttons mirror RG-MOD vocabulary** (Dismiss default/Remove danger/Warn warning/Suspend `suspend`); SystemPromotions hand-rolled table conformed (Remove→danger Button); date-range filters inline-conformed (relaxation C). High-volume: color `replace_all` for the mechanical swaps + explicit size/weight. Markers `@stand-in`→`@matt-inspired` (tab page). 🔴 9 stale `ModerationDetailContent.test` badge-class assertions updated → conformed RG-MOD strings → `ModerationAdmin`+`ModerationDetailContent`+`ModeratorQueue` 166/166. Gates green, BOTH tabs DOM-verified :4321. 10 honest-orphan hues intentionally retained. Code `d0600680`. |
| ☑ | `/admin/moderators` | `admin/moderators.astro` | **☑ Swept Conv 335 — route #13.** ModeratorsAdmin (647 ln) + ModeratorDetailContent (121 ln). Already used Confirm+FormModal → zero backward-pointer, no custom modal. `StatCard` helper rewritten tinted→white-card + 4 lifecycle hues (Active neutral/Pending warning/Accepted success/Declined error); `TabButton` indigo→info-500 accent + semantic count badge; header Invite + footer Remove/Resend/Revoke→Button (Invite/Resend primary, Remove/Revoke danger); both avatars→`UserAvatar` (sm row 32px, md detail 48px); View-public-profile indigo→info; expired-date red-500→error-500. Marker `@stand-in`→`@matt-inspired`. Gates green (no dedicated test — the 2 `Moderator*` tests cover ModeratorInvite/ModeratorQueue, independent), DOM-verified :4321 (Invite primary info-500, stat hues, Remove danger, detail avatar 48px, link→info). Code `44562010`. |
| ☑ | `/admin/payouts` | `admin/payouts.astro` | **☑ Swept Conv 332 — route #1.** PayoutsAdmin (843 ln) + PayoutDetailContent (161 ln). `gray→neutral`, `indigo→info`, status hues→semantic, admin-tight type, bridge spacing restored. Adopted `<Button>` for 6 action buttons (Process-All/Create/Process→`primary`, Cancel→`default`, Retry→`warning`, View-in-Stripe→`outlined`) — established sub-pattern (a). 🔴 Fixed latent bug: "View profile" link was `text-red-600`→info-blue. Marker `@stand-in`→`@matt-inspired`. Gates green, payouts tests 65/65, DOM-verified (Button pills `rgb(7,119,182)` r39). Code `8caf8754`. |
| ☑ | `/admin/promotion-settings` | `admin/promotion-settings.astro` | **☑ Swept Conv 332 — route #2.** PromotionSettingsAdmin (265 ln), already `@matt-inspired`. Dropped all 24 `dark:`, `secondary→neutral`, Configured/Not-set badges→success/warning, 2 buttons→`<Button primary>`. Forms handled by the conformed `FormModal` primitive. Gates green, DOM-verified (warning badge `rgb(180,83,9)`, blue Button pills, neutral-50 tiles). Code `036a56fe`. |
| ☑ | `/admin/recordings` | `admin/recordings.astro` | **☑ Swept Conv 334 — route #8 (quick win).** RecordingsAdmin (171 ln) + inline StatusBadge. **Both subcomponents already conformed** (`AdminPagination` RG-MOD Conv 312, `RecordingLink` already Matt) → zero backward-pointer. `secondary→neutral`/`text-text-*`, Refresh→`<Button variant="primary" property1="Small">`, error card `red→error`, 3 stat cards neutral-300/r8/p16, StatusBadge published/processing/unpublished→`success`/`warning`/`neutral`; admin-tight type; bridge spacing restored (`gap-4`/`p-4`/`px-4`/`p-8`→16/16/16/32, badge snap-up `py-0.5`→`py-4`). 🔴 carry-forward "0/0/0 trivial" was *gate*-counts not token-counts. Marker `@stand-in`→`@matt-inspired`. Gates green (tsc 0 / astro 0/0/0 1432 / lint 0), DOM-verified :4321 (8 real recordings: Refresh `rgb(7,119,182)` r39, stat p16, published badge success-100/500 pill). |
| ☑ | `/admin/sessions` | `admin/sessions.astro` | **☑ Swept Conv 334 — route #10 (largest, 706+273 ln).** SessionsAdmin + SessionDetailContent. All shared deps already conformed (FormModal/ConfirmModal/RecordingLink/Admin* primitives) → zero backward-pointer. `gray→neutral`/`text-text-*`; **4 avatars → UserAvatar** (2 sm row, 2 md detail); renderRating ★ → text-star/neutral-300. 6 stat cards: Total neutral / Today+Week info / Completed success / Cancelled error / With-Recording brand. Detail-footer 4 Buttons (View-Recording primary, Delete-Recording danger, Resolve-Issue warning, Edit-Notes default); error-Retry primary; date filters inline-conformed. **🔴 red-link fixed** (View course → info). Marker `@stand-in`→`@matt-inspired`. Gates green (tsc 0 / astro 0/0/0 1432 / lint 0), DOM-verified :4321 (12 sessions: 6 stat hues, list star gold, panel avatars 48px, View-course info, Edit-Notes default pill). |
| ☑ | `/admin/teachers` | `admin/teachers.astro` | **☑ Swept Conv 334 — route #9.** TeachersAdmin (565 ln) + TeacherDetailContent (203 ln). Composes already-conformed `Admin*` primitives; `ConfirmModal` already conformed (Conv 325) → zero backward-pointer. `gray→neutral`/`text-text-*`, **avatar→`UserAvatar sm`**, stat cards Active→success / Students→info / Avg-Rating→`text-star`; row rating star→`text-star`. Error-Retry→`<Button primary>`; detail-footer View-Public→`outlined`, Deactivate→`warning`, Activate→`primary`. Admin-tight type; skeleton→neutral-100/rounded-4/h-16; bridge spacing restored. **🔴 2 red-links fixed** (TeacherDetailContent View profile + View course → info). Marker `@stand-in`→`@matt-inspired`. Gates green (tsc 0 / astro 0/0/0 1432 / lint 0), DOM-verified :4321 (7 teachers: avatar 32px, AvgRating 4.9 gold, both red-links→info `rgb(7,119,182)`, footer outlined+warning pills). |
| ☑ | `/admin/topics` | `admin/topics.astro` | **☑ Swept Conv 332 — route #4.** TopicsAdmin (522 ln). Adopted `ui/Modal` for the hand-rolled TopicModal (now `ui/Modal` + 3 `form/Input` + Button footer; custom auto-slug logic preserved) — established sub-pattern (c). Header Add-Topic + error-Retry → Button. `gray→neutral`, stat values→h2-bold, marker `@stand-in`→`@matt-inspired`. Surfaced + conformed the shared `AdminActionMenu` primitive (see group note). Gates green, `CategoriesAdmin.test` 47/47, DOM-verified topics page + modal + action menu (192px dropdown / 16px icons, 0 non-Footer legacy). Code `06c64430`. |
| ☑ | `/admin/users` | `admin/users.astro` | **☑ Swept Conv 333 — route #5.** UsersAdmin + UserDetailContent + UserEditModal. UserEditModal adopts `ui/Modal` shell (drops bespoke backdrop/header; keeps custom toggle body, indigo→info-500 + bridge-shrink fixed) — sub-pattern (c). Inline indigo avatar fallbacks → adopted shared `UserAvatar`. `gray→neutral`, admin-tight type, bridge spacing restored. 🔴 Fixed latent `text-red-600` "View profile" deep-link→`text-info-500`. Marker `@stand-in`→`@matt-inspired`. **Surfaced + fixed the shared `FormModal` primitive** (indigo×2 + gray×6 token-conform; sub-pattern (c) backward-pointer) **and the app-wide `UserAvatar` bridge-fix** (see group note). Gates green (tsc 0 / lint / astro 0/0/0), DOM-verified (table avatar 32px, detail 64px, 0 indigo). Code `bb1ea2fb`. |

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
