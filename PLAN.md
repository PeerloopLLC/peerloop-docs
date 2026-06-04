# PLAN.md

This document tracks **current and pending work**. Completed blocks are in [plan/COMPLETED.md](plan/COMPLETED.md).

The `plan/` subdirectory holds per-block plan files for large blocks. Currently migrated:
- **MATT family** — `plan/matt/` (README + per-phase files + cutover + standin-matt). Phases 1–4.5 ✅; Phase 5 🔥; Phase 6 → ongoing; Phase 7 pending. Cutover ✅ shipped Conv 197.
- **Conv 211 migration (Fork C — large blocks >80 lines)** — `plan/deployment/`, `plan/calendar/`, `plan/package-updates/`, `plan/mvp-golive/`, `plan/cert-approval/`, `plan/admin-review/`, `plan/stripe-e2e-dev/`. Each as `<slug>/README.md` (Fork Y hybrid — all 7 have sub-sections so all get subdirs).

Other named blocks still live inline below; per-block extraction happens incrementally as each block needs attention.

---

## Block Sequence

### ACTIVE

| Block | Name | Status |
|-------|------|--------|
| MATT-DESIGN-PUSH | Matt Design System — tokens, shell, primitives, page conversion, doc graduation | 🔥 IN PROGRESS — **Phase 5** (course-tab family ✅ Convs 188-190; Enroll-family precheckout ✅ Conv 232 — `/precheckout` standalone + `/benefits` tab; Enrollment **success** page ✅ Conv 233 Phase 1 — `@matt-source 579:16885`, fixes Stripe `success_url` 302-bounce + `[CH-VARIANTS]` Enrolled variant; **booking page `@stand-in` ✅ Conv 234** [BOOK-ROUTE] — root `/course/[slug]/book` (legacy `SessionBooking` wizard on the Matt shell + course SubNav rail), closes the success-page "Schedule Session 1" 404; **ENROLL-NAV ✅ Conv 235** — dual-zone course SubNav (Explore + gated enrollment Journey state machine) + new "My Sessions" Explore tab + new root `/session/[id]` `@stand-in` (Prepare/Join 404 fix; rail persists across the whole funnel; success page got the rail too); **[SESS-GRAD] ✅ Conv 239** — `/session/[id]` graduated `@stand-in → @matt-inspired` (merge: full legacy join/rate/cancel state machine re-skinned to Matt tokens + static Matt Prepare surface/checklist/notes/chat; `SessionJoinableView` folded in; SSR/client TZ hydration bug fixed; suite 6447; browser-verified). **Strategic Matt phase-out** (Conv 239): client phasing out Matt → pages default `@matt-inspired`, decided page-by-page, function-first, never lose `/old/*` function. `/book` stays `@stand-in` → [BOOK-WIZARD-MATT] #27; two-tier Journey rework → [JOURNEY-LOOP] #26; 5 other routes pending; success Phase 2 composer [SUCCESS-COMMUNITY] + CourseHeader Scheduled variant still pending). Phases 1–4.5 ✅ (13/13 Matt-named primitives + per-icon viewBox + Course In Feed re-render Conv 187). Phase 6 → ongoing per-page; Phase 7 pending. → [plan/matt/README.md](plan/matt/README.md) |
| NAV-RETROFIT | Legacy→Matt incremental migration — retrofit legacy shell onto Matt's design | 🔥 IN PROGRESS (Conv 191, demo-driven). **Root cause found ([DEMO-HOME]):** Conv 174 added `@import tokens-tailwind-bridge.css` to `global.css`; the bridge's `@theme` `--spacing-*` block aliases Tailwind's numeric scale to Matt's literal-px scale (`--spacing-64: var(--space-64)` = 64px), silently shrinking EVERY legacy spacing utility in the set {4,8,12,16,20,24,32,40,48,64} ~4× app-wide since Conv 174 (`w-64`→64px, `h-4`→4px). Tests never caught it (CSS not unit-tested); `/matt` unaffected (uses arbitrary `[Npx]` + bare numerics that EXPECT Matt's scale). **Strategy (user decision):** `/matt` is the final design destination — do NOT revert the override (would break `/matt`); instead migrate legacy components ONTO Matt's design incrementally. **Approach B chosen** (restyle legacy in place, preserve behavior; approach A = swap to Matt components, possibly later). **Conv 191 DONE — AppNavbar step 1 + bidirectional demo bridge:** `<aside>` `w-64`→`w-[220px]` + `AppLayout` main `lg:ml-64`→`lg:ml-[220px]`; rows restyled to Matt (`text-body-medium-bold` label + 12px `text-body-small` desc via `line-clamp-2`, `gap-[12px]`, brand-blue flat "Selected" active — white pill deferred until grey shell); chevrons `h-4 w-4`→`size-[16px]` (Discover + user item + dropdown close); both slideouts (`DiscoverSlidePanel`, `UserAccountDropdown`) `left-64`→`left-[220px]`. Bidirectional nav: AppNavbar "New Design"→`/matt/` (top item, SparklesIcon); Matt `Sidebar.tsx` NAV+COLLAPSED_NAV "Classic App"→`/` (arrow-left, marked **TEMP demo bridge** for easy removal). Round-trip verified in Chrome bridge; all 5 gates green (tsc/check 1264 0/0/0/lint/test 6453/build 6.43s). **Conv 191 follow-up — 3 View-Transition regressions found+fixed via the / → New-Design → Classic-App round-trip** (all DOM-verified, NOT screenshot — see `feedback_dom_truth_over_screenshots.md`): (1) navbar items bunched (island-unique `py-[10px]` dropped when /matt CSS swapped in → standard `gap-3/px-2/py-2.5/p-3`); (2) Messages quick-action card vanished (inline reveal `<script>` doesn't re-run on VT → bound to `astro:page-load`); (3) Discover/User slideouts behind navbar (island-unique `left-[220px]` dropped + a **duplicate-`style` JSX bug** that silently dropped the first fix → merged into single inline `style`, DOM-confirmed left:220 flush + on-top). Sweep: only `index.astro` had a VT-fragile inline script; AdminNavbar shares the bug class (admin-only, [NAV-SIBLINGS]). **Conv 192 — home-page spacing fixes + [LEGACY-SPACING-AUDIT] resolved (do-nothing-broad):** Fixed the home footer (`Footer.astro` full + compact variants — 7 hijacked-step utilities → arbitrary px `py-[48px]`/`px-[16px]`/`lg:px-[32px]`/`gap-[32px]`/`pt-[32px]`/`gap-[16px]`/`mt-[16px]`) and the dashboard main panel (`index.astro` — icon containers + clock `h-12 w-12`→`h-[48px] w-[48px]` were clipping 24px glyphs to 12px boxes; `mb-8`→`mb-[32px]`, `gap-4`→`gap-[16px]`, `mb-4`→`mb-[16px]`, `py-8`→`py-[32px]`), both DOM-verified in Chrome bridge. **[LEGACY-SPACING-AUDIT] quantified + decided:** override hijacks **3,894** utilities across **354 legacy files** vs only **11 `matt/` files** that depend on the new meaning — asymmetry would justify reverting, BUT user chose **do-nothing-broad / fix per-component as legacy→Matt conversion reaches each** (the mechanical sweep would be thrown away by the migration; reaffirms Conv 191 "don't revert"). Remediation recipe per component: convert hijacked-step utilities to arbitrary `[Npx]`. **Conv 193 — AdminNavbar retrofit + both-nav icon swap; group #4–#8 resolved.** **[NAV-SIBLINGS] narrowed to AdminNavbar-only + DONE** (Decision: AppHeader excluded — speculative, never client-reviewed, public-facing visitor→member surface most likely to be redesigned; MoreSlidePanel deferred → new [MSP-COUPLING]): AdminNavbar un-broke 9 hijacked-step spacing utils (avatars `h-8`→`size-[32px]`, header `h-16`→`h-[64px]`, paddings `p-4`→`p-[16px]`, etc.) + rail `w-64`→`w-[220px]` + coupled `AdminLayout` `lg:ml-64`→`lg:ml-[220px]` + content padding + stale docstring; dark theme kept. **[NAV-ICON-SWAP] DONE** (user directive: match from Matt43 ∪ Material Design icons, dashed-border any unmatched): probed both navs' icon inventories + Matt's 43-set — Matt's set is product-oriented (no nav-chrome/admin-tooling glyphs), so ~half the nav icons had no Matt equivalent; harvested 10 Material-outlined icons (menu, search, admin-panel-settings, chevron-right, group, label, assignment, videocam, warning, person-add) via curl from the marella mirror into the MattIcon registry (**43→53**, fills normalized to `currentColor` — MattIcon wrapper is `fill="none"` so harvested paths MUST carry explicit fill); swapped BOTH AppNavbar + AdminNavbar to MattIcon; removed legacy `@components/ui/icons` imports from both; zero dashed-border cases (Material covered every gap); all 21 referenced names validated to resolve to real files; provenance documented in MEMORY.md. **[LEGACY-SPACING-AUDIT] recipe applied** to AdminNavbar (the per-component remediation form, as decided Conv 192). **[NAV-APP-A] deferred — continue approach B** (approach-A component swap would moot #4/#5 work; matches standing Conv 191 decision). **[VTPRD] DROPPED** (no recoverable scope — deleting beat guessing). VT-drop learning: arbitrary utilities are safe within a route family (AdminNavbar persists only admin→admin, every admin route generates its classes) — only cross-family island-unique arbitrary utilities (Conv 191 slideout offsets) need inlining. Baselines: tsc 0; astro check 1271 0/0/0; lint; build. **NOT visually verified** — both navs auth-gated; mechanism proven (harvested `menu` icon renders in real SSR output, zero placeholders) but logged-in look unconfirmed. AppHeader intentionally NOT retrofitted (speculative public surface). **Conv 194 — both Conv 193 PENDING items closed + 1 latent bug fixed + 1 new bug found.** **[MSP-COUPLING] RESOLVED by deletion** — live-DOM check showed `MoreSlidePanel.tsx` is dead code (superseded by `UserAccountDropdown`, zero consumers); every feature has a home (dark-mode + Help + Settings in UserAccountDropdown; Privacy in Footer); deleted file + barrel export + stale `AppLayout.astro` comment (incl. 256px→220px rail drift). **[LH-VERIFY] DONE** — both navbars visually verified in Chrome bridge: AppNavbar (Guy session, 220px rail @left:0, 0 dashed icons, slideouts at left:220) + AdminNavbar (Brian session, 220px rail, main margin-left:220px, 15 MattIcons, 0 dashed, 14 links; flat-list by design, no slide-out). **[MPB] FIXED** — AppNavbar slide-out panels (`DiscoverSlidePanel` + `UserAccountDropdown`) bled ~220px over content below `lg` (closed `-translate-x-full` from left:220 was only occluded by the rail, not truly off-viewport; rail goes off-canvas below lg, exposing them); fixed with self-sufficient inline closed-transform `translateX(calc(-100% - 220px))` (viewport-independent, survives VT swaps) in both panels. **NEW BUG [ADMIN-REDIRECT-BLANK]** — authenticated non-admin hitting `/admin/*` gets a blank 15-byte 200 instead of redirect to `/`; clean dev restart falsified the optimize-deps hypothesis; mechanism unexplained (why `AdminLayout` line 37 `Astro.redirect('/')` yields blank 200 while line 34 `/login` redirect yields clean 302) → deferred to DEFERRED #27. Also confirmed [CRS-MOBILE] + course-page entity-vis audit (no issues; see those subtasks). Branch `jfg-dev-13-matt`. |
| MATT-CUTOVER | Make Matt the primary app — provenance attribution + route flip | 🟢 SUBSTANTIALLY COMPLETE — Conv 197 [PROV] + [ROUTE-FLIP] both done (43 legacy pages → `/old/`, 9 Matt → root, namespace dissolved); Conv 198 post-flip doc reconciliation; Conv 199 [PROV-SWEEP] + [PROV-MATCH]. Remaining: [PROV-MATCH-AUTO] (Figma-matching automation). → [plan/matt/cutover.md](plan/matt/cutover.md) |
| ROUTE-MIGRATION | Forward-migrate legacy `/old/*` flows onto the new root routes (post-ROUTE-FLIP) | 🔥 IN PROGRESS (Conv 201). **Context:** Conv 197 [ROUTE-FLIP] moved legacy flows to `/old/*` and promoted Matt pages to root, but per user decision there is **no redirect layer** — unbuilt root routes 404. The legacy infra (middleware prefixes, `/login` redirect target, ~30 component hrefs) still pointed at the old root paths, breaking auth app-wide. User strategy (manual-programmer sequence): **(1)** wire the minimum to make the app usable (login/logout/home); **(2)** stub every main-nav menu item at root; **(3)** verify the minimal app works; **(4)** convert `/old/*` pages → new routes one at a time, retiring `/old` incrementally. **Phases 1–3 DONE + browser-verified (Conv 201):** [RTMIG-1] `/login`+`/signup` promoted to root (reuse `AutoOpenAuthModal`, new `AppLayout`, redirect authed→`/`); `AuthModalRenderer` re-homed into `AppLayout` (was mounted only in legacy AppNavbar → modal dead app-wide after flip); post-login default `/dashboard`→`/` in `auth-modal.ts`; root `/` confirmed canonical Home (former `/matt/index`, stale "stub" comment corrected). [RTMIG-2] honest stubs for the two missing nav routes `/earnings` + `/profile` (AppLayout+SubNav+empty-state pattern from Conv 193); `/earnings` added to middleware `PROTECTED_EXACT`. [RTMIG-LOGOUT] logout button wired into `/profile` (deferred here from Phase 1 per decision A). [RTMIG-3] full nav status sweep = zero 404s (public 200 / protected 302→login); live-verified login→home→logout + protected-route redirect with `returnUrl` round-trip. [RTMIG-SIGNUP] `/onboarding` promoted to root (thin port reusing `OnboardingProfile`; post-signup landing was 404ing same dead-route class); full signup→account→`/onboarding` happy-path browser-verified (real topic-picker renders). All bugs fixed were string-valued route refs invisible to `tsc` — only the browser caught them. Gates: astro check + tsc 0 errors. **Conv 202 — pre-flip reference env stood up + deep-link fix RETIRED + [RTMIG-4] gap analysis → RESCOPE NEEDED.** The live branch can't browse legacy `/old/*` look+behavior (deep nav links lack the `/old/` prefix → 404 by design, since there is no redirect layer). Considered three in-branch patches (client-side href rewrite / `basePath` prop threading / middleware 404→`/old` fallback) and **rejected all** — the middleware fallback in particular would silently mask the very 404s that are RTMIG's verification signal. Chosen durable solution: **a pre-flip git worktree as a zero-debt reference environment** ([PREFLIP-WT]). `git worktree add ~/projects/Peerloop-preflip 846bab9f^` (detached HEAD `608346a2`, the parent of the Conv 197 ROUTE-FLIP commit — `/matt` present, `/old` absent = genuine pre-flip app); copied `.dev.vars`, recreated `.env` symlink, `npm install`, `npm run db:setup:local:dev`, `npm run dev -- --port 4331`. /chrome bridge confirmed port/URL-based (directory-agnostic) → :4321 live + :4331 reference coexist and are both fully browsable; toured the legacy app logged-in as admin (Dashboard/Discover/Course/Messages/Learning/Admin). User declared the worktree **satisfies all requirements of the proposed `/old` deep-link fix → retired that need entirely**. Reproduction tooling: `peerloop-ref` shell alias (machine-local), committed idempotent bootstrap `scripts/setup-preflip-ref.sh` (worktree add + .dev.vars copy + install + seed + append alias) for M4Pro, named folder `Peerloop-preflip (:4331 ref)` added to `peerloop.code-workspace` (travels via git), memory `project_preflip_worktree_reference.md`. **[RTMIG-4] gap analysis (RESCOPE NEEDED next conv):** ~90 `/old` pages have NO root equivalent; Matt designed only **9** pages and they're **already at root** (moved by ROUTE-FLIP). So RTMIG-4 is fundamentally a *routing migration of legacy pages*, NOT a build-to-Matt-design (can't be, without blocking on 90 nonexistent designs; Matt redesign is the separate later MATT-EXEC-*/MMP-* track). The open methodology fork is which *shell* legacy bodies land in at root: **(A)** port legacy body into Matt shell `@layouts/AppLayout.astro` [CC recommended, follows Conv 201 root pattern], **(B)** port legacy as-is with the legacy shell, **(C)** migrate only the Matt-designed pages. 90 pages × an unresolved A/B/C fork is too coarse for one task → user stopped before any code; decompose + resolve the fork at the start of the next conv. **Conv 203 — RTMIG-4 fork RESOLVED = A + Home recreated as the pilot + route-honesty hardening + Home-slice primitives.** **Methodology fork resolved = approach A** (port legacy body into Matt shell): consistent nav everywhere, follows the Conv 201 root pattern; Home was never a real Matt design (only a shell preview) so it's A-by-nature. **Home port complete (RTMIG-4 pilot):** `src/pages/index.astro` rebuilt from the `/old` dashboard inside the Matt shell (header + OnboardingNudgeBanner + 2 ActionCards + Recent-Activity EmptyState + auth-reveal script); browser-verified. Per-page loop established: build in Matt shell → middleware PROTECTED_PREFIXES + hrefs → repoint e2e → browser-verify vs :4331 → retire `/old` copy. **Route-honesty hardening (Decision: links to unconverted pages must 404 — no resolving placeholder stubs):** deleted 6 placeholder routes (`/saved` `/todo` `/teachers` `/earnings` `/notifications` `/messages`) so links 404 honestly; removed Peer Teachers + Earnings from Sidebar NAV/COLLAPSED_NAV; kept `/teachers/[handle]` as StudentTeacherAnchor target; functional real-data `/courses` retained; memory `project_route_404_honesty_standin.md`. **Primitives showcase archived** `/` → `/dev/primitives` (+ `/dev/saved` + `/dev/todo` dev mirrors, dev subnav trimmed to Overview/Saved/To-Do); Decision: page owns its own SubNav (slot-based opt-in — structural, not new). **New `@stand-in` transient provenance marker** on 7 pages (login, signup, onboarding, profile, courses, course/[slug]/[...tab], teachers/[handle]) — "not ours, not Matt, stand-ins to redesign"; greppable, NOT formalized in prov-sweep (self-erasing at retrofit; `grep -rl '@stand-in' src/pages` = remaining-retrofit counter). **Home-slice MATT-EXEC-EXT primitives built** (#7 EXT slice done): new `EmptyState.astro` (+retrofit `/dev/saved`) + `ActionCard.astro` (both registered in prov-candidates `PHASE6_EXTRAPOLATION_CANDIDATES`, unmarked=ours), harvested Material `clock.svg` (icon-provenance entry), restyled `OnboardingNudgeBanner` to Matt (MattIcon + tokens + Button). **Fixed a latent prov-sweep bug** (4c untracked-note check read only COMPONENT_CANDIDATES, not PHASE6 → false UNTRACKED on the new primitives; fixed by unioning both arrays). Gates green (tsc/astro check/prov-sweep/route-map); route map regenerated (109 routes). **Remaining:** [RTMIG-4] **(approach A locked; Home pilot DONE — ~89 legacy pages remain)** per-page `/old`→root conversion via the Matt-shell loop; also fix middleware PROTECTED_PREFIXES still listing root paths whose pages are under `/old`, and `/profile`→`/@me` once `/@handle` routes migrate), [STANDIN-MATT] (#25 — approach A applied to the 7 `@stand-in` pages; same workstream as RTMIG-4, treat as one), [PREFLIP-M4PRO] (#24 — retrofit M4Pro worktree + `peerloop-ref` alias), [PREFLIP-WT] (remove the pre-flip reference worktree when RTMIG-4 inspection is done), [E2E-MIG] (re-point e2e to new routes incrementally), [E2E-GATE] (structural-change tier + goto-target resolver check — the five-gate baseline runs vitest only; playwright e2e is outside `/w-codecheck` + `/r-end` by construction, which is why the relocation's dead routes went undetected; diagnostic prototype at `.scratch/e2e-route-map.mjs`). **Next-conv ordering directive:** [PREFLIP-M4PRO] (#24) FIRST, [STANDIN-MATT] (#25) SECOND. **Conv 216 — [VISITOR-SURFACE] Visitor account surface + shared theme toggle (overlay-free; client rejected popovers).** Reviewed the Conv 212 `/profile` conversion + the pre-flip `608346a2` AppNavbar bottom-chip behaviour: legacy chip was auth-conditional — logged-in → `UserAccountDropdown` **slide-out popover** (View Profile `/@handle` · Settings `/settings` · Interests · dark-mode · Help · Sign out; click-outside/Esc close); visitor → inline `renderAuthStatusUI` (Create-account / Log-in **modals** + session-expired "Welcome back"+email-prefill + error/Retry). Two findings: dark-mode was trapped in the logged-in dropdown (visitors had it **nowhere**, legacy included); and `/profile` (private hub) vs public `/@handle` were always **separate** → the old **"redirect `/profile`→`/@me`" plan note is DROPPED** (private hub stays `/profile`; public profile = `/@handle` + `/@me` self-alias, migrated under RTMIG-4; Account-tab "View public profile" link lights up then). **Decisions (user):** no popover/overlay (matches the Conv 212 SubNav-tabs call); `/login`+`/signup` stay standalone form pages (timeout/redirect targets) — Visitor/Profile surfaces hold **links/actions**, not embedded forms. **Built:** new public `src/pages/visitor.astro` (`@matt-inspired`, `noNav`; AppLayout, no SubNav; Log in→`/login` + Sign up→`/signup` Button links + shared `<ThemeToggle>`; authed→`/profile` bounce); new shared `src/components/ui/ThemeToggle.tsx` (Matt-token switch; reads/writes localStorage `theme`, applies `.dark`, persists-on-mount; registered in prov-candidates PHASE6_EXTRAPOLATION_CANDIDATES); `/profile` Account tab inline dark-mode button → `<ThemeToggle client:load />` (dark-mode inline-script branch removed, logout kept); `Sidebar.tsx` visitor chip `profileHref` `/login`→`/visitor`; middleware.test +1 (`/visitor` public-browsable). **Latent bug fixed:** `lock.svg` (harvested Conv 212) had no `icon-provenance.ts` entry → Conv 212's "prov-sweep green" was wrong/not-run; backfilled (`'lock': source 'ours'`). Gates ALL green: tsc 0 · astro check 1293 0/0/0 · lint · tailwind-v4 · prov-sweep consistent · build · test **6456/6456**; route maps regenerated (both repos). **Browser-verified (Chrome bridge, :4321):** logged-out chip→`/visitor` (text "Visitor"); logged-in chip→`/profile`; authed hit on `/visitor`→bounced to `/profile`; `/visitor` renders Log-in/Sign-up links logged-out; `<ThemeToggle>` round-trips on BOTH `/visitor` and `/profile` (off→dark/'dark'→light/'light', DOM+localStorage confirmed). **Conv 219 — [RTMIG-TIER] strategy adopted (governs RTMIG-4 #8 going forward):** per page, **Tier-1** = compose obvious *existing* primitives + Matt tokens + shell + 404-honest routing **now**; **Tier-2** = extract NEW / extend existing primitives **later** from Rule-of-Three evidence (a consolidation pass). Resolves the page-conversion crawl (root cause: trying to make every page conversion *also* a primitive-design exercise from n=1). The `prim-treewalk` v2 sensor + `.scratch` reports are the Tier-2 deferral memory. This **pauses [PROFILE-PRIM-SWEEP] (#22)** → reframed as the Tier-2 remainder; the Tier-1 cut is [PROFILE-TIER1] (#3). See PRIM-REGISTRY row W4 for the tooling/partials. **Conv 221 — DISC-DROP reframed as the discover-destination migration umbrella + first /old/* page ported (communities, Tier-1).** **[SBAR-DISC] DONE (DISC-DROP Stage 3):** added Communities (group icon) / Feeds (feed icon) / Members (student-teacher icon) as flat top-level Sidebar.tsx NAV + COLLAPSED_NAV items (peers of Courses) at un-prefixed root URLs (`/communities`,`/feeds`,`/members`, matching the /courses precedent) that **404 honestly** until ported; Leaderboard excluded (not porting yet). Decisions (user): representation B (flat top-level, not a "Discover" parent, not a slideout) + nav-first (accept 404s now). Committed `ce26cbe1`. **[DISC-COMM] DONE (core build) — first Tier-1 port of an /old/* page:** ported `/old/discover/communities` → root `/communities` at fidelity **A (courses-parity** — mirror the Convs 204-205 /courses build, NOT a strict shell-wrap; user framed communities as "same role as /courses"). Built `src/pages/communities.astro` (`@matt-inspired`; AppLayout shell + breadcrumb + SectionTitle + OnboardingNudgeBanner + recommendations + role tabs + search + catalog), new `CommunityCatalogCard.tsx` (Matt browse card, stacked+overlay variants, stretched-link to root `/community/[slug]`, **404-honest** forward link), inline-Matt islands `Communities{RoleTabs,Catalog,Filters}.tsx` (coordinate via URL hash + `communities:*` events; legacy ExploreTabBar NOT mutated), Matt-restyled `RecommendedCommunities.tsx` (MattIcon header/dismiss, Matt skeletons, tiles the overlay card); registered `CommunityCatalogCard` in `matt-inspired-registry.ts` PHASE6_EXTRAPOLATION_CANDIDATES (cross-ref PRIM-REGISTRY). **Endpoint-parity check:** new page matches legacy except it omits admin-gated `/api/admin/intel/communities` attention badge — an intended courses-parity drop (/courses also lacks admin-intel); restoration tracked under [ROLE-AWARE]. **Route-honesty empirically confirmed:** traversed the /communities component tree — zero hrefs/onClicks contain `old/` (the route-flip never wrote `/old/` into hrefs, only relocated page files); community cards forward to root `/community/[slug]` which has no root route → all 404 → **404-honesty IS the vetting gate** (forward links self-seal, can't surface unvetted content until that route is deliberately built). **Discover-destination Tier-1 port recipe** (new pattern): mirror /courses = Matt shell + Matt-restyled recommendations + inline-Matt role tabs + Matt catalog card + search-only filter; forward-link to root detail routes (404-honest). 🔴 **SUPERSEDED Conv 222 (historical record only):** this filter-only recipe was wrong — it silently dropped legacy's distinct per-role views. The corrected **per-role dispatcher** recipe lives in the DISC-ROLE-VIEWS section (Strategy block) + the DISC-DROP #21 🔴 block. Do not follow this version. Gates ALL green: tsc 0 · astro check 1299 0/0/0 · lint · prov:sweep consistent · build · full suite **6456/6456** (371 files). `RecommendedCommunities.test` updated ("by Creator One"→"Creator One", Matt card shows bare creator name; intended). **Task reorg (user-approved):** [DISC-DROP] (#5) reframed as the discover-destination umbrella (Stage 3 ✅ = SBAR-DISC; Stage 4 = repoint hrefs, NEVER delete /old); [DISC-COMM] (#29) created as the pilot; [DISC-RTB-RECONCILE] (#6) annotated with Rule-of-Three instance count + Tier-2 shared-RoleTabBar target; [RTMIG-4] (#7) annotated to EXCLUDE discover destinations (no double-counting). **/old retention rule (user, durable):** "retire /old/<x>" = repoint inbound hrefs ONLY; the /old page stays live as the client's page-by-page comparison baseline. Bulk /old deletion is a single end-of-migration step gated on **all-converted + client-vetted**, NEVER part of a per-page loop (memory `project_old_pages_no_delete_until_vetted.md`). **DISC-COMM DONE Conv 222:** repointed all 7 inbound `/discover/communities` hrefs → `/communities` (DiscoverSlidePanel, DiscoverFeedsGrid, FeedAllTab×2, FeedsHub×2, HomeFeed; /old left live); user browser-verified /communities. The Conv-221 role-tab investigation found the filter-only port dropped per-role fidelity → corrected via new sub-block **[DISC-ROLE-VIEWS]** (see its section + DISC-DROP #21). **New tasks:** [ROLE-AWARE] (#30, restore admin-intel for communities + /courses + role-aware feature audit, blocked by #6+#13 — latent until the role-aware tab bar lands), [CAT-SORT] (✅ DONE Conv 223 under DRV-B2 — Matt sort control on both catalogs + shared `ui/CatalogPagination`), [MW-COMMUNITY-STALE] (stale `/community` protected-prefix in middleware:45). **Folded-in cleanup debts (from DISC-DROP, completed Conv 229):** (a) `RecommendedCourses` loading skeleton still light-styled while its overlay cards are dark — load-state polish; (b) extract a shared role/ratingLabel helper across `CoursesRoleTabs` / `CoursesCatalog` / `RecommendedCourses`. **Conv 237 — [COMM-DETAIL] /community/[slug] detail family BUILT (approach C; 3rd `[...tab].astro` + `_*-tabs.ts` + `SubNav` family after /course + /profile).** Ported legacy `/old/community/[slug]/*` (the 4-tab, 628-line `CommunityTabs` island) → root `/community/[slug]` catch-all: **About (default — decision B, a NEW overview legacy lacked) / Course Feed / Courses / Resources / Members**; `@matt-inspired` (Matt drew no community-detail frame — same footing as /profile). About content all REAL data via existing loaders + a new `bio` join (`u.bio_short` added to `fetchCommunityDetailData`): full description, At-a-glance stats, Meet-the-host, Learning-paths (progressions group-level, hidden for system). **Decompose:** feed = `CommunityFeed`/`TownHallFeed` islands; courses = server cards; resources + members = NEW client islands (`CommunityResourcesTab` / `CommunityMembersTab`, faithful extractions — members search now WIRED, was a dead input in legacy). **The Commons** (`isSystem`) drops the Courses tab + `/courses` redirects to bare. Membership actions (Manage / Leave) → header CTAs, NOT the SubNav; `?tag=` chips dropped (decorative in legacy — TownHallFeed never consumed `tag` → [COMM-TAG-FILTER] #2); legacy "Leave" had no handler (rendered faithfully, flagged). **`/communities` now pins The Commons** (cover image + link) above the joinable grid (grid still excludes it — everyone's auto-joined) — fulfilling the previously-404 home `FeedsHubPanel` + `FeedDirectoryCard` + `FeedActivityCard` targets. **Browser-verified (8 checks, :4322):** regular 5-tab + system 4-tab (no Courses) + island hydration + gated upload + home card resolves + pinned cover image. Stale "404-honest until ported" comments corrected (`communities.astro`, `CommunityCatalogCard`, `FeedDirectoryCard`). Gates ALL green: tsc 0 · astro check 0/0/0 (1326) · lint · build · suite **6460/6460** (371). **Three feed surfaces clarified** (recurring confusion): `/feed` (singular, personal smart/aggregated — NO route yet, 404) vs `/feeds` (plural, discovery directory — built) vs `/community/the-commons/feed` (townhall). Follow-ups: [COMM-TAG-FILTER] (#2), Tier-2 token sweep of the 2 islands, Leave-button wiring, moderator-toggle click-test. **NEXT CONV: [FEED-DETAIL] (#3)** — same treatment for `/old/feed/*` → root `/feed/[slug]` (the 4th `[...tab].astro` family). Branch `jfg-dev-13-matt`. **Conv 238 — [FEED-DETAIL] DONE (re-scoped) + feed nav + link-honesty; [COMM-TAG-FILTER] designed.** FEED-DETAIL's `/feed/[slug]` premise was wrong — legacy `/feed` is a single SmartFeed page, not a multi-tab family. Ported `/old/feed` → root `src/pages/feed.astro` (`@matt-inspired`, Matt shell + prop-less `SmartFeed` island, auth-gated via existing `PROTECTED_EXACT` guard) — fixes ~7 dead `/feed` links + middleware. Wired **"My Feed" → `/feed`** into Sidebar NAV+COLLAPSED_NAV (after Home; new harvested `sparkles` MattIcon, provenance-tracked; `matchHref` `+'/'` guard confirmed no `/feed`↔`/feeds` cross-activation). Repaired stale post-flip links the route-flip/Conv-222 missed: `/feeds` Join CTAs (`api/feeds/discover.ts:222/250`) + smart-feed discovery CTAs (`enrichment.ts:179/180`) + **DiscoverSlidePanel** Feeds→`/feeds` & Courses→`/courses` (`:46/:53`), all `/discover/{community,course,feeds,courses}/…` → root. 5 gates green (suite 6460); browser + curl verified. **[COMM-TAG-FILTER] (#1) found to be a net-new feature, not a wiring task** (legacy chips were hardcoded `['general','announcements','help']` over a `feed_activities` table with NO tag column + Stream posts with no tag field) → design written at [plan/comm-tag-filter/README.md](plan/comm-tag-filter/README.md) with both decisions LOCKED (channels model + `community_channels` table); build-ready, deferred to its own conv (only a courtesy Matt check remains). New debt surfaced: **[PROV-SWEEP-DEBT]** (6 pre-existing `prov:sweep` errors, not in the 5-gate baseline). 🟠 also noted: `StudentDashboard` "browse courses" link still → `/discover/courses` (stale, courses-domain, deferred). |
| BBB-RECORDING | BBB Recording Investigation — diagnose empty recordings, fix `autoStartRecording`, build account-wide diagnostic endpoint | 🔥 IN PROGRESS (Convs 159-164: [REC-LABEL] complete Conv 163; [BR-NAVBAR-HYDRATE] complete Conv 164; only [BR-STATUS] + [BR-ZERO-REPRO] deferred. [CRT] promoted to own block.) |
| CALENDAR | Platform Calendar — custom multi-view calendar component for all roles | 📋 PENDING → [plan/calendar/README.md](plan/calendar/README.md) |
| ADMIN-REVIEW | Admin System Review — testing gaps, UI consistency, cross-links, menu restructure | 📋 PENDING (promoted Conv 095) → [plan/admin-review/README.md](plan/admin-review/README.md) |
| PACKAGE-UPDATES | Package Version Upgrades — all dependencies current, new branch | ✅ COMPLETE (Convs 104-114, PR #26 merged into `staging`). CF Pages→Workers migration spawned as separate CF-WORKERS block and also complete. → [plan/package-updates/README.md](plan/package-updates/README.md) |
| PRIM-REGISTRY | Vetted-primitive registries + `data-prov` runtime conformity | 🔥 IN PROGRESS (Conv 216). **Problem:** a page can be marked `@matt-inspired` while internally using unvetted legacy UI — `/profile/*` proved it (5 embedded settings islands = **105 legacy-token usages, 0 Matt tokens**; the page marker doesn't propagate). Two gaps: no browsable vetted-primitive catalog; no way to tell from a rendered page whether it contains unvetted UI. **Decisions (user, Conv 216):** approach **B** = two dedicated registry files; **3-value `data-prov` stamp** (`matt-sourced`/`matt-inspired`/`legacy`) on each primitive's outermost element so conformity is a one-line DOM query. Spec = `docs/as-designed/matt-provenance.md §12`. **W1 ✅ spec (§12).** **W2 ✅ registries:** `scripts/matt-inspired-registry.ts` (renamed from `prov-candidates.ts`, which is now a back-compat re-export; the hand-maintained "ours" half) + `scripts/matt-sourced-registry.generated.ts` (**35** primitives, GENERATED from the `@matt-source` markers via `npm run gen:registries` = `scripts/gen-registries.ts`; markers stay SoT per §4, registry is a derived projection — 41 grep-files − 2 non-component − 4 prose-only = 35; generator idempotent). Gates: prov-sweep consistent, tsc clean. **W3 ✅ [PRIM-STAMP] (#21, Conv 217):** stamped all **59** vetted primitives (35 matt-sourced + 24 matt-inspired) on their outermost rendered element; the precursor `data-matt` attribute (unreferenced) **fully retired** per user decision B (kept the distinct `data-matt-preview` in the dev showcase). §12c conformity assertions wired into `npm run prov:sweep` (registry⟺marker⟺stamp; UNSTAMPED/UNTRACKED/NODE-MISMATCH/BAD-CLASS fail the gate; `legacy` stamps exempt from UNTRACKED). New DOM page-conformity report `npm run prov:page-report` (`scripts/prov-page-report.ts`, jsdom; `PROV_BASE`/`PROV_COOKIE` env). Edge cases resolved (matt-provenance.md §12b): conditional-render branches stamp each branch; `UserIcon` roleDot wrapper stamped; `Input` forwards an optional `data-prov` override to its root so composing wrappers (`PasswordInput`/`SearchInput`) own the DOM-root identity; `_SocialPostDemo` wrapped in a stamped div. Validation: `/dev/primitives` = 81 sourced + 152 inspired, 0 legacy, 0 uncovered; `/courses` surfaced 1 genuine uncovered interactive (raw "Dismiss recommendations" button → [PRIM-COURSES-DISMISS] #23). ALL gates green: tsc 0 · astro check 1293 0/0/0 · lint · tailwind · prov-sweep · test **6456/6456** · build. **W4 ✅ Tier-1 done (Conv 219-220) under the [RTMIG-TIER] strategy:** the single-pass profile primitive sweep is split. **Tier-1 cut = [PROFILE-TIER1] (#3) ✅ COMPLETE Conv 220:** Tier-1 primitive-swap surface done across all 5 profile-tab islands (Notification + Stripe prior; TopicPicker + SecuritySettings + ProfileSettings this conv). TopicPicker: native level `<select>`→Matt `Select` (only clean fit; topic-card accordion ≠ SelectableCard, Select-All text-link → [TXTBTN] #24, no Badge/Checkbox primitive). SecuritySettings: email `<input>`→Matt `Input`, Change-Password `<a>`→`Button` primary, Sign Out→`Button` outlined; modal Cancel+Delete pair deferred together (pairing-consistency; Delete danger-blocked). ProfileSettings (depth B chosen): local `Input` wrapper recomposed onto `FormField`+aliased Matt `Input` (prefix→leadingIcon, badge/spinner→labelAccessory) — external API unchanged, 0 call-site edits across ~11 sites; Save button→Matt `Button`. New pattern: aliased default import to compose a Matt primitive inside a same-named local wrapper. All 5 baseline gates green this conv (tsc 0 · astro check · lint · **6456/6456 tests**, 0 regressions from DOM-bearing recomposition · build). **Stale worklist candidate noted:** SecuritySettings `:236` "device row" is the loading skeleton, not a real device row. **Tier-2 remainder = [PROFILE-PRIM-SWEEP] (#22, PAUSED):** extract/extend NEW primitives deferred to a Rule-of-Three consolidation pass; = the former `[PROF-TAB-REDESIGN]`. **Blocked on:** Matt `Button` has no danger variant; `form/` has no `Textarea`/`Switch`/`Checkbox`/`Card` primitive. Deferred items: TopicPicker topic-card/checkbox/count-badge, SecuritySettings modal Cancel+Delete pair + Delete Account + Retry, ProfileSettings `TextArea`/`Toggle` wrappers. **Conv 219 tooling + partials:** `scripts/prim-treewalk.ts` rewritten to **v2** (3 stacking AST signals — interactive-cluster / loop-repeated / legacy-tokens; reframed verdict→"primitive candidates to confirm"; clickable lines + narrowed strong/weak report; `npm run prim:treewalk`); new `/w-prim-candidates` skill (sensor + agent narrowing table + `.scratch` output) — agent-narrated now, deterministic match index ([PRIM-MATCH-INDEX] #1) later. **StripeConnect Tier-1 partial done:** `SkeletonCard` gained a `leadingBadge` prop; new `ErrorRetryCard` pre-primitive (composes FormBanner + Button + inlined Matt card chrome, since `Card` is Astro-only and can't be React-composed — left **unstamped**: not legacy, not registered, children self-stamp; §12 pre-primitive note → [PRIM-DOC] #2); loading→SkeletonCard, error→ErrorRetryCard swapped; purple Connect button kept raw as an intentional Stripe-brand honest-orphan. tsc clean; sensor confirmed 3→2 strong. **New pre-primitive tier + JFG annotation protocol** (`.scratch/JFG.md`; in-file located instruction channel, command never persists past action) established this conv. Run `PROV_COOKIE=<session> npm run prov:page-report /profile …` for the worklist. Open follow-ups: [PRIM-MATCH-INDEX] #1, [PRIM-DOC] #2, [PRIM-ORPHAN-ACK] #5, [PRIM-COURSES-DISMISS] #27. **Conv 221:** registered new `CommunityCatalogCard` in `matt-inspired-registry.ts` PHASE6_EXTRAPOLATION_CANDIDATES (built for the /communities Tier-1 port — see ROUTE-MIGRATION row); prov:sweep consistent. Branch `jfg-dev-13-matt`. |

### ON-HOLD

| Block | Name | Notes |
|-------|------|-------|
| DEPLOYMENT | Deployment automation + prod cutover — spawned from CF-WORKERS | PAGES-DISCONNECT done (Conv 116). Staging green. Remaining: GHACTIONS, PROD, STAGING-DOMAIN, DB-SYNC. Deferred Conv 129 — no sub-block urgent. → [plan/deployment/README.md](plan/deployment/README.md) |
| INTRO-SESSIONS | Intro Sessions — free 15-minute pre-enrollment calls | Schema exists (`intro_sessions`); feature not built. Discovered in TERMINOLOGY review Session 348. |
| ~~DEV-STAGING-SSR~~ | ✅ **RESOLVED Conv 177** via `[DSSR-SCOPE]` fix | The Conv 122 root-cause hypothesis (two React copies via `@astrojs/cloudflare` 13) was wrong. Real cause: Vite cold-start dep-discovery race (industry-wide, see DEVELOPMENT-GUIDE.md § Vite SSR Cold-Start Dep Discovery). Fix: `astro.config.mjs` `vite.optimizeDeps.entries` + `include: ['astro/virtual-modules/transitions.js']`. Cold-start /matt/ now succeeds first try; production build clean (7.27s); preview /matt/ renders fully with `Sidebar.tsx` useState intact. Conv 176 stateless-primitives discipline retired. |

### DEFERRED

*Reorganized Conv 095. Previous numbering in git history.*

| # | Block | Name | Notes |
|---|-------|------|-------|
| 1 | SEEDDATA | Database Seeding & Empty State | 🟡 Nearly Complete (EMPTY_STATE deferred to POLISH) |
| 2 | POLISH | Production Readiness | Validation, roles, tech debt, security, deferred features |
| 3 | MVP-GOLIVE | Production Go-Live | Absorbs OAUTH, STAGING-VERIFY, CRON-CLEANUP, RECORDING-PERSIST → [plan/mvp-golive/README.md](plan/mvp-golive/README.md) |
| 4 | TESTING | Multi-User Testing | Merged: E2E-GAPS + E2E-LIFECYCLE + WORKFLOW-TESTS |
| 5 | IMAGES | Image Pipeline — uploads, management, optimization | Merged: FILE-UPLOADS + IMAGE-MGMT + IMAGE-OPTIMIZE |
| 6 | FEEDS-NEXT | Feed Enhancements — ranking, mobile, privacy, level matching, promotion | Merged: FEEDS + FEED-PROMOTION + FEED-PRIVACY + LEVEL-MATCH |
| 7 | OBSERVABILITY | Error Tracking, Analytics, Audit Logging | Merged: SENTRY + POSTHOG + AUDIT-LOG |
| 8 | CERT-APPROVAL | Certificate Lifecycle — student page, creator approval, PDF, public view | 7 admin/API endpoints built, 0 UI pages → [plan/cert-approval/README.md](plan/cert-approval/README.md) |
| 9 | PUBLIC-PAGES | Public Page Coherence — header unify, legacy cleanup, footer, personalization | |
| 10 | PAGES-DEFERRED | Deferred Pages (7) | Includes story IDs |
| 11 | RATINGS-EXT | Ratings Extensions — expectations, materials rating, display | |
| 12 | EXTRA-SESSIONS | Extra Session Purchases | Beyond course plan |
| 13 | COURSE-LIMIT | Creator Course Limit | Default 3, admin-adjustable |
| 14 | AVAIL-OVERRIDES | Availability Overrides | Schema exists; feature not built |
| 15 | EMAIL-TZ | Per-User Timezone in Emails | Requires `timezone` column on users |
| 16 | MSG-TEACHER | Message Teacher from Course Page | Messaging now open (Conv 110); needs UI button on course page |
| 17 | RESPONSIVE | Responsive & Mobile Review | Site-wide audit needed |
| 18 | ROUTE-AUDIT | Route & Sitemap Audit | Routes vs `url-routing.md`, public/auth boundaries |
| 19 | STUMBLE-REMNANTS | STUMBLE-AUDIT Remaining Items | JWT test, 2 client decisions (member_count fixed Conv 108) |
| 20 | STRIPE-E2E-DEV | Dev-Level Stripe Integration Stress Test — real browser, real Test-mode cards, real webhook tunnel | Prerequisite for go-live confidence. Conv 145 scoped. Tiered (A/B/C/D). Complements Conv 144 staging live-verification with higher-fidelity Dev-side coverage. → [plan/stripe-e2e-dev/README.md](plan/stripe-e2e-dev/README.md) |
| 22 | ADMIN-REDIRECT-BLANK | Non-admin hitting `/admin/*` gets blank page instead of redirect | Conv 194 — authenticated non-admin (Guy, `is_admin=0` confirmed in D1) gets a blank 15-byte 200 on all `/admin/*` instead of a redirect to `/`. Unauthenticated `/admin` → clean 302 → `/login` (no-session branch works); authenticated non-admin → `AdminLayout` line 37 `Astro.redirect('/')` yields blank 200, NOT 302. Clean dev restart falsified the Vite optimize-deps hypothesis. **Mechanism unexplained** — why does line 37's redirect differ from line 34's (`/login`, no-session) clean 302? Needs focused investigation. |
| 23 | PREFLIP-M4PRO | Retrofit MacMiniM4Pro pre-flip reference worktree + `peerloop-ref` alias | Conv 203 — **DO FIRST next conv.** Run the committed idempotent bootstrap `scripts/setup-preflip-ref.sh` on M4Pro to stand up the `~/projects/Peerloop-preflip` (:4331) reference worktree (worktree add `846bab9f^`/`608346a2` + `.dev.vars` copy + install + `db:setup:local:dev` + append `peerloop-ref` alias). Machine-local; the reference env currently exists only on M4. |
| 24 | STANDIN-MATT | Retrofit `@stand-in` pages to Matt-style (approach A) | ✅ COMPLETE (Convs 207-208, 212) — login/signup/onboarding/404 + /profile account-hub. Archived → [plan/COMPLETED.md](plan/COMPLETED.md). Detail → [plan/matt/standin-matt.md](plan/matt/standin-matt.md). Per-tab fidelity → [PROFILE-PRIM-SWEEP] (#22, formerly [PROF-TAB-REDESIGN]; now W4 of the PRIM-REGISTRY block). **⚠️ Conv 234: 1 NEW `@stand-in` reintroduced** — `/course/[slug]/book` ([BOOK-ROUTE] tactical rehost: legacy `SessionBooking` wizard on the Matt shell). **⚠️ Conv 235: 1 MORE `@stand-in`** — root `/session/[id]` (ENROLL-NAV Prepare/Join 404 fix, legacy session room rehosted on the Matt shell). **✅ Conv 239 [SESS-GRAD]: `/session/[id]` graduated `@stand-in → @matt-inspired`** (merge — full legacy state machine re-skinned + static Matt Prepare surface; see [MATT-EXEC-PG2]). `/book` REMAINS `@stand-in` → graduates under [BOOK-WIZARD-MATT] #27 (the booking-wizard Matt restyle, split out of [SESS-GRAD]). |
| 25 | ENROLL-NAV | Dual-zone course SubNav — Explore tabs + gated enrollment "Journey" zone | ✅ **BUILT Conv 235** (Scope A — whole state machine + rail + content port in one conv). Shipped: dual-zone `SubNav.astro` (divider + zone headers + done-✓ + muted disabled steps; flat callers unchanged), state-aware `buildCourseTabs(slug, journey)` (Benefits→Enroll Journey step; new enrolled-only **"My Sessions"** Explore tab), `computeCourseJourney()` state machine in `loaders/courses.ts` (Enroll→Payment→Book→Prepare/Join→Certificate; enrolled-only, +1 next-session query), new `MySessionsTab.astro` (`@matt-inspired`, SSR port of legacy SessionsTabContent). **Naming resolved:** Matt's "1:1 Sessions" label = the curriculum frame = existing Modules tab; the genuinely-dropped surface (student's personal *schedule*) ships as "My Sessions" in Explore, OUTSIDE the Journey. **2 review fixes:** rail added to `/success` (Payment step kept the nav); new root `/session/[id].astro` `@stand-in` (Prepare/Join was 404 — only `/old/session/[id]` existed; also fixes the same latent 404 in MyStudents/SessionHistory/StudentDashboard) carrying the course rail for the student viewer. 5 gates green (6460 tests); browser-verified as David. **⚠️ Conv 239: decision #5 + the "My Sessions in Explore" naming SUPERSEDED** — "My Sessions" moves INTO a two-tier Journey (one-time gates bracketing a recurring Sessions progress-cluster); reworked under [JOURNEY-LOOP] (DEFERRED #26). **Follow-ons:** [ENROLL-NAV-MATT-CONFIRM] #38 (4 Matt divergences); mobile zone-divider rendering; Certificate step route (CERT-APPROVAL). → [plan/enroll-nav/README.md](plan/enroll-nav/README.md) |
| 26 | JOURNEY-LOOP | Two-tier course Journey — one-time gates + recurring Sessions progress-cluster | 📋 PENDING (spawned Conv 239; supersedes ENROLL-NAV decision #5). The Journey becomes **two-tier**: one-time **gates** (Enroll / Payment / Certificate = real checkboxes) bracketing a recurring **Sessions progress-cluster** (My Sessions + Book + Prepare/Join) carrying an **"X of N sessions"** meter (not a checkbox — sessions repeat per module); **Certificate gates on `completed == total`**. "My Sessions" moves Explore→Journey. 7-step scope, **no new SQL/schema** (reuses `moduleInfo`/`getBookingEligibility`; the wizard already computes `totalModules/completedCount/scheduledCount/nextModule`). Novel rendering = a progress-bearing sub-group header + indented children in `SubNav.astro`. Open: overlap dedup of the wizard's own "Book Next / all-booked" affordances vs the Journey cluster (make the cluster canonical). Full scope → [plan/enroll-nav/README.md § EVOLVED](plan/enroll-nav/README.md). |
| 27 | BOOK-WIZARD-MATT `[CALENDAR2]` | Matt restyle of the booking wizard (`SessionBooking`) | 📋 PENDING (spawned Conv 239). `/course/[slug]/book` stays `@stand-in` — the legacy 4-step wizard (reschedule + invite modes + hand-rolled calendar + teacher/viewer TZ reconciliation, 888L) is genuinely page-worthy; its Matt restyle (date/time per Matt `622:15671`) graduates it `@stand-in → @matt-inspired`. Distinct from [BOOK-ROUTE] (the tactical rehost) and split out of [SESS-GRAD]. Related to the broader CALENDAR vision (SessionBooking step-2 picker) — mnemonic `[CALENDAR2]` to avoid collision with the platform-calendar CALENDAR block. |

---

## Cross-Conv Watch Tasks

Watch-type tasks that span multiple convs without a clear block home. Each lists an explicit trigger condition; they sit dormant until that condition fires. Consolidated Conv 211 from former Conv 150-157 / 179 / 206 drain sections. Watch-tasks already tracked in TodoWrite (`[DTUNE-WATCH]` #26, `[SKILL-DISCOVERY-AUDIT]` #27) are not duplicated here.

- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in `ClientRouter` `<script src>` — Astro 6.3.6/6.3.7 emits `<script type="module" src="/Users/jamesfraser/projects/Peerloop/node_modules/astro/components/ClientRouter.astro?astro&type=script&index=0&lang.ts">`. Root cause: `node_modules/astro/dist/vite-plugin-astro/compile.js:50` (`compileProps.filename` is absolute). Functionally a no-op (Vite serves 200 either way) but cross-machine portability hazard. **WAITING on upstream Astro fix post-6.3.7.** Verification probe after each Astro upgrade: `curl http://localhost:4321/ | grep -oE 'src="[^"]*ClientRouter[^"]*"'` — non-absolute path = fixed. (Conv 163, retested 177)

- [ ] **[PD]** Prod cron Worker deploy — block date 2026-04-28 has passed; verify whether prerequisites still hold when next picked up. (Conv 150 inception)

- [ ] **[RSC]** Conditional: pair `-c` with `-v` if MSI rsync ever gains `-v` for diagnostics — fires only on a specific edit to one of the three production rsync sites (`r-start/SKILL.md` Step 5.7 Phase 1, `r-commit/SKILL.md` Step 1.5, or `r-end/SKILL.md` Step 5b). Evaluated Conv 157: production rsync invocations don't use `-v`, so the cleaner-audit-logs benefit is invisible. Adding `-c` speculatively is over-engineering. Stays indefinitely until the trigger condition is met. (Conv 157)

- [ ] **[ASF]** Investigate `Astro.slots.has` + `&&` short-circuit interaction surfaced Conv 175 [MSH-VIZ] empty-pill bug. Conditional Fragment forwarding `<Fragment slot="x"><slot name="y" /></Fragment>` suppressed child's `<slot name="x">FALLBACK</slot>` even when slot `y` was empty; `Astro.slots.has` + `&&` short-circuit did not restore the fallback. Production workaround in place: defaults at the layout consumer via ternary inside unconditional Fragments. Root-cause investigation deferred — file an Astro issue or build a minimal repro if it bites again. Memory: `reference_astro_slot_forwarding.md`. (Conv 175)

- [ ] **[TDS-DRIFT]** `tech-doc-sweep` hook returned no recent changes despite the substantial `matt/*` additions across Convs 173-178. Investigate: drift baseline SHA at `.claude/.drift-baseline-sha` may be stale, or sweep matchers in `.claude/scripts/tech-doc-sweep.sh` may not detect `src/components/matt/*` / `src/styles/tokens-*.css` / `src/pages/matt/*` paths. Reproduce: `cat .claude/.drift-baseline-sha`, then `git -C ../Peerloop diff $(cat .claude/.drift-baseline-sha)..HEAD --stat -- 'src/components/matt/*' 'src/styles/tokens-*' 'src/pages/matt/*'`. (Conv 179)

- [ ] **[MEM-CAP]** Run `/r-prune-memory` when MEMORY.md auto-load utilization climbs above 80% (built Conv 213; **NOT** `/r-prune-claude`, which prunes the unrelated CLAUDE.md file). Conv 211 baseline 53% lines / 73% bytes; tripped 80% bytes Conv 213. Auto-load cap is 200 lines / 25 KB at every SessionStart (per `code.claude.com/docs/en/memory.md`); /r-start Step 5.7 Phase 2 emits a 🔴🔴🔴 alert at ≥80% on either axis. (Conv 179; skill + ref fix Conv 213)

- [ ] **[INV-PATH-FIX]** Sweep `.scratch/matt-figma/` references in code/docs → `.scratch/matt-main/`. `matt-figma` was the initial 229-file Figma export (Conv 169); `matt-main` is the curated 83-file build set (Conv 170 [MATT-ISOLATE]). Find with: `grep -rn 'matt-figma' docs/ && git -C ~/projects/Peerloop grep 'matt-figma' -- src/`. Replace path-by-path; verify each isn't an intentional historical reference. (Conv 179)

- [ ] **[COHERENCE-AMBIG-LOW]** Two LOW [AMBIGUITY] findings deferred for future calibration: §Critical Rule "multiple features" (unquantified threshold) and §Schema Discrepancy exception "unambiguously self-evident" (judgment-heavy). Accepted as natural judgment thresholds — revisit only if a concrete miscalibration appears. (Conv 206)

- [ ] **[GARBLE-WATCH]** (#36) Re-test the Conv-226 "garble" symptoms when an upstream Claude Code changelog fixes parallel tool-result delivery. Root-caused Conv 227 as an OPEN upstream bug cluster — harness parallel-tool cascade-cancel (#22264 → empty-in-UI then late/out-of-order delivery #63966/#63859/#63797) stacked with model confabulation (#63538); strongly correlated with Opus 4.8 + parallel batches + any one sibling failing (incl. our `guard-dangerous-bash.sh` PreToolUse block). Unfixed as of CC 2.1.159. Trigger: a changelog entry naming tool-result delivery / parallel-tool / cascade-cancel. Mitigation in place: verify suspicious-empty results out-of-band (cheap *different* probe), never re-spam identical calls, never narrate un-received output. Memory: `reference_term_garble_upstream_bug.md`. (Conv 227)

---

## BBB-RECORDING (Convs 159-161)

🔥 **ACTIVE** — Triggered by recording-gap in Conv 158 BBB testing. Conv 159: diagnosis confirmed `autoStartRecording` missing. Conv 161: **Blindside reply** — `getRecordings` requires `limit≤100` parameter (fixed both diagnostic surfaces); paginated `/admin/recordings` built with 2-call total derivation; all 7 user-facing recording-display surfaces verified on staging (1 of 8 orphaned recordings visible correctly). Conv 162: discovered 8th surface (TeacherTabContent My Sessions tab) and fixed it — verbatim mirror of student `SessionsTabContent` "Recording" affordance. Conv 163: [REC-LABEL] completed — shared `<RecordingLink>` component extracted, all 10 surfaces (8 + 2 admin added mid-conv) unified on Option B bordered-text "Recording" button; local dev seed now ships Sarah/Guy/Intro-to-n8n session with real Blindside `recording_url` (exact parity with staging); [DLE] investigation root-caused user-reported "loading errors" to existing [BR-NAVBAR-HYDRATE] (scope widened — not admin-only). Conv 164: [RV] 10-surface verification sweep confirmed all recording-button updates landed (Sarah/Guy/Brian role rotation, all 10 surfaces ✓). [BR-NAVBAR-HYDRATE] root-caused + fixed at AdminNavbar.tsx:90 via the established `isHydrated` flag pattern (single bug, single file — Conv 163 [DLE] "scope widened" was a misdiagnosis: the non-admin reproduction came from `data-astro-transition-persist` carrying the errored navbar across View Transitions, not a separate bug). [CRT] promoted to its own block. **Completed:** account-wide diagnostics, autoStartRecording fix deployed, paginated admin UI with 20-per-page paging, empirical UI verification on all surfaces, TeacherCourseView + TeacherTabContent recording-link bug fixes deployed to staging, 10-surface recording-link unification via `<RecordingLink>`, local dev seed parity with staging for recording flow, AdminNavbar hydration mismatch fixed.

**Subtasks:**

- [ ] **[BR-STATUS]** Add `sessions.recording_status` column with enum `none | requested | capturing | processing | published | failed` for richer post-session UI. Defer pending Blindside follow-up on server-level recording configuration + outcome of orphaned-recording investigation.

- [ ] **[BR-ZERO-REPRO]** Reproduce the 0-min empty-but-published recording state — external-blocked (needs fresh BBB test session). Prereq for [BR-STATUS] enum design (we need to know which post-session states are reachable in practice before fixing the column shape).

- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings during `npm run dev` / `npm run dev:staging` — watch-only; act if the warning recurs (i.e., trips dev server hot-reload or build). Carried from Conv 168 RESUME-STATE.

---

## Deferred: TESTING

**Focus:** Multi-user testing — E2E Playwright flows, branching workflow integration tests, admin test gaps
**Status:** 📋 PENDING
**Merged Conv 095:** E2E-GAPS + E2E-LIFECYCLE + WORKFLOW-TESTS + ADMIN-REVIEW.TESTING

### TESTING.E2E — Playwright Multi-User Flows

*Two-browser Playwright tests for flows not coverable by integration tests*

- [ ] Session invite: Teacher sends → Student accepts → Session created → Both in room
- [ ] Session invite variants: reschedule, expired, decline
- [ ] Booking wizard: teacher select → date → time → confirm → session room
- [ ] Booking reschedule: cancel old → pick new time
- [ ] Session lifecycle: join → video room → completion → rating (two-browser)
- [ ] Notifications: User A action → User B notification badge + page update
- [ ] Messages: User A sends → User B conversation + badge update

### TESTING.WORKFLOW — Branching Integration Tests

*Multi-step flows with decision-point variants. Shared setup → branch at decision point → verify different downstream state.*

| Workflow | Branches | Value |
|----------|----------|-------|
| **Booking→Session→Completion** | book, join/no-show, complete (single/final), cancel (on-time/late), reschedule (under/at limit) | Highest — most user-facing |
| **Completion→Cert→Teacher** | rate/skip, recommend/decline, certify/reject, first booking as Teacher (full flywheel) | High — core product thesis |
| **Payment** | checkout success/abandon, refund, dispute open/close (won/lost), payout fail | Medium — webhook chains |
| **Messaging** | start convo (allowed/403), send after relationship ends, admin bypass | Low — relationship gates removed (Conv 110 open messaging); admin rules still testable |

Existing partial coverage: `tests/api/sessions/`, `tests/api/webhooks/stripe.ts`, `tests/lib/messaging.test.ts`, `tests/integration/message-lifecycle.test.ts`, `tests/integration/notification-lifecycle.test.ts`

### TESTING.ADMIN — Admin Test Gaps

*From Conv 080 audit. 81 of 96 admin components/APIs tested (~1900 tests).*

**Category 1 — Decision Data (12 untested GET `[id].ts` endpoints):**
admin/enrollments, teachers, certificates, courses, sessions, users, payouts, topics, moderation, intel/courses, intel/dashboard, intel/communities. Highly templatable — same auth→404→200+shape pattern.

**Category 2 — Action Execution (2 components):**
ModeratorsAdmin (invite/revoke/remove), TopicsAdmin (reorder/CRUD). API tests exist but component→API wiring untested.

**Category 3 — Shared Infrastructure (5 primitives):**
AdminDataTable, AdminDetailPanel, AdminFilterBar, AdminPagination, AdminActionMenu. Tested indirectly. Recommended: test DataTable + DetailPanel directly (highest cascade risk), skip others.

---


## Nearly Complete: SEEDDATA

Database seeding strategy and empty state handling.
**Status:** 🟡 NEARLY COMPLETE (only EMPTY_STATE remaining, deferred to POLISH)

**Completed:** Full seed data overhaul (Session 285). All 59 tables seeded. Conv 083 password standardization (all `Password1`). PLATO seed path activated. Two parallel seed paths: SQL (`db:setup:*`) and PLATO (`plato:seed*`).

### SEEDDATA.EMPTY_STATE (Deferred → POLISH)
- [ ] Test each page with zero records
- [ ] Verify empty state messages display correctly
- [ ] Test first-user / first-course / first-enrollment flows

---

## Deferred: POLISH

Production readiness items.

### POLISH.VALIDATION
- [ ] API request body validation (Zod)
- [ ] Webhook payload validation (Stripe, BBB)
- [ ] Form validation schemas
- [ ] Environment variable validation

### POLISH.ROLES
- [ ] Course-scoped vs global role semantics
- [ ] Multi-role user navigation
- [ ] Admin impersonation model
- [ ] Admin user creation UI (from ROLES.CREATE_UI)

### POLISH.TECHNICAL_DEBT
- [ ] Status field inconsistency (boolean vs enum) + type-safe helpers
- [x] Full getNow() sweep (Conv 090)
- [ ] MergedPeople.tsx broken `/@[uuid]` URLs (Conv 047)
- [x] Replace all `prompt()` calls with FormModal (Conv 080)
- [x] `users.last_login` column is dead — never written to by any code, always NULL; admin analytics `/api/admin/analytics` queries it for "active in last 30/60 days" returning 0 for all users (Conv 111) — **Fixed Conv 112:** `recordLogin()` helper added to `session.ts`, called from all 4 auth endpoints
- [ ] Consolidate `detect-changes.sh` + `dev-env-scan.sh` from `r-end/scripts/` to `.claude/scripts/` — same pattern as Conv 133's consolidation (deferred from DOC-SYNC-STRATEGY Phase 2)
- [ ] Full resync of `docs/reference/resend.md` template table — phantom entries (`BookingConfirmationEmail`, `SessionCompletedEmail`) + ~9 real templates missing (SessionBooking, SessionCancelled, SessionRescheduled, FeedbackReminder, ModeratorInvite, EnrollmentConfirmation, CertificateIssued, 3× CreatorApplication); Conv 133 only fixed the 3 SessionInvite rows (deferred from DOC-SYNC-STRATEGY Phase 2)
- [x] **[LE-TRIAGE]** — Completed: see COMPLETED_PLAN.md §POLISH.LINT_EXHAUSTIVE_DEPS (Conv 147-149)


### POLISH.SECURITY_HARDENING
- [ ] Audit logging for admin actions (see OBSERVABILITY.AUDIT-LOG)
- [ ] Rate limiting on sensitive endpoints
- [ ] Explicit role checks where derived permissions are used
- [ ] Proper token refresh flow — refresh token currently used as direct auth credential in `getSession()` fallback, granting 7-day privileged API access after 15-min access token expires. Needs: refresh endpoint + client auto-refresh + getSession fix (Conv 112)

### POLISH.DEFERRED_FEATURES
- [ ] Session reminders (Cloudflare cron)
- [ ] Compatible member matching (Jaccard similarity)
- [ ] User → Member rename (platform-wide)
- [ ] Community filtering by topic on `/discover/communities`
- [ ] Remove MyXXX pages — pending client agreement (Conv 054)
- [ ] Smart Feed algorithm UX simplification (Conv 059)
- [ ] Student profile — "Following Courses" section using `GET /api/me/course-follows` (deferred from COURSE-FOLLOWS block, Conv 138)
- [x] Email notification fallback for session invites — Conv 130: 3 email templates (SessionInviteEmail, SessionInviteAcceptedEmail, SessionInviteDeclinedEmail); fire-and-forget on create/accept/decline paths; also fixed gap in decline.ts (missing in-app notification to teacher added). All use `session_booked` preference type.

---

## Deferred: PAGES-DEFERRED

**Focus:** 7 pages deferred per client directive — not yet designed for the Twitter-style left-side menu layout
**Status:** ⏸️ DEFERRED (post-MVP, pending client direction)
**Unimplemented stories:** 6 (US-S065, US-M004, US-C026, US-S081, US-P097, US-P099)

**Open question:** Current app pages use a Twitter-like left-side menu navigation. These more traditional/standard pages need layout decisions — do they use the same left-side menu pattern, or a different layout?

| Code | Page | Route | Stories | Notes |
|------|------|-------|---------|-------|
| HELP | Summon Help | `/help` | *(see GOODWILL block)* | Blocked on goodwill system |
| BLOG | Blog | `/blog` | — | Content not ready |
| CARE | Careers | `/careers` | — | Content not ready |
| CHAT | Course Chat | `/courses/:slug/chat` | US-S065, US-M004 | Superseded by community feeds |
| CNEW | Creator Newsletters | `/creating/newsletters` | US-C026 | Post-MVP |
| SUBCOM | Sub-Community | `/groups/:id` | US-S081, US-P097 | Post-MVP |
| CLOG | Changelog | `/changelog` | US-P099 | Gap story — no route exists yet |

---

## Deferred: RATINGS-EXT

**Focus:** Extended ratings features beyond core session/completion reviews
**Status:** 📋 PLANNING
**Tech Doc:** `docs/as-designed/ratings-feedback.md`

**Context:** Core rating system is complete (session assessments + completion reviews). These extensions add richer feedback dimensions and display.

### RATINGS-EXT.EXPECTATIONS

*Capture student goals/expectations at enrollment time*

- [ ] `enrollment_expectations` table (schema in tech-022)
- [ ] POST endpoint to capture expectations post-purchase
- [ ] Optional update after each session
- [ ] Display in completion review context ("did course meet expectations?")

### RATINGS-EXT.MATERIALS

*Separate course content quality rating from teaching quality*

- [ ] `course_reviews` table with optional sub-ratings (clarity, relevance, depth)
- [ ] Add `rating` and `rating_count` columns to `courses` table
- [ ] Two-part completion review modal (teaching + materials)
- [ ] Course page displays materials rating separately from Teacher rating
- [ ] Creator analytics: materials feedback breakdown

### RATINGS-EXT.DISPLAY

*Surface ratings in more places*

- [ ] Show completion reviews on Teacher public profile page
- [ ] Rating trend charts in Teacher/Creator analytics dashboards

---

## Deferred: EMAIL-TZ

**Focus:** Format notification/email times in recipient's local timezone
**Status:** 📋 PENDING
**Conv:** 002

**Context:** Conv 002 completed UTC-TIMES (session timezone normalization). Emails currently show times in UTC with "UTC" label. For polish, format in recipient's timezone — requires adding `timezone` column to users table and querying it during notification formatting.

- [ ] Add `timezone TEXT` column to users table (IANA timezone string, e.g., `America/New_York`)
- [ ] Populate during onboarding or profile settings (detect from browser `Intl.DateTimeFormat().resolvedOptions().timeZone`)
- [ ] Use `formatLocalTime(utcIso, userTimezone)` in session creation, reschedule, and cancellation email formatting
- [ ] Use `formatLocalTime()` in in-app notification text

---

## Deferred: PUBLIC-PAGES

**Focus:** Unified header/footer/nav/currentUser strategy for public-facing pages
**Status:** 📋 PENDING
**Session:** 385

**Context:** Session 385 audit found three layout/header components serving different page types, each with independent auth patterns:

| Layout | Header Component | Auth Pattern | Pages |
|--------|-----------------|--------------|-------|
| `AppLayout` | `AppNavbar.tsx` | `initializeCurrentUser()` (full `/api/me/full`) | ~54 authenticated pages |
| `AdminLayout` | `AdminNavbar.tsx` | `initializeCurrentUser()` (full `/api/me/full`) | 14 admin pages |
| `LandingLayout` | `Header.tsx` | `fetch('/api/auth/session')` (lightweight) | ~26 public pages |
| `LegacyAppLayout` | `AppHeader.tsx` | `fetch('/api/auth/session')` + notification count | Deprecated, still mounted |

**Problems to solve:**

1. **Header.tsx uses stale role booleans** — `/api/auth/session` returns `is_student`, `is_teacher`, `is_creator` as flat DB flags, not derived from actual course relationships. A user with `can_create_courses=true` but zero created courses shows "Creator Dashboard" link incorrectly.

2. **Header.tsx `getDashboardLink()` duplicates AppNavbar logic** — role-priority routing (admin → creator → teacher → student) is implemented independently in both components with different field names (`is_admin` vs `isAdmin`).

3. **No shared footer** — public and app pages have no consistent footer component. Marketing pages need footer nav (About, Privacy, Terms, etc.), app pages may need a slimmer version.

4. **AppHeader.tsx (legacy) is a dead-end** — has its own mobile sidebar with hardcoded routes that don't match AppNavbar. Should be removed once all pages use AppLayout.

5. **Public pages can't personalize for returning users** — e.g., `/courses` could show "Continue Learning" for enrolled courses, but Header.tsx doesn't initialize currentUser and there's no `getCurrentUserIfCached()` helper.

### PUBLIC-PAGES.HEADER-UNIFY

*Unify Header.tsx auth with currentUser cache*

- [ ] Add `getCurrentUserIfCached()` to `current-user.ts` — reads localStorage only, no fetch, returns `CurrentUser | null`
- [ ] Refactor `Header.tsx` to use `getCurrentUserIfCached()` instead of `/api/auth/session`
- [ ] Fall back to lightweight session fetch only if no cache exists (first-time visitor who never visited an AppLayout page)
- [ ] Replace stale `is_teacher`/`is_creator` booleans with currentUser's `isActiveTeacher()`/`hasCreatedCourses()` for accurate dashboard routing
- [ ] Extract shared `getDashboardLink(user)` utility used by both Header and AppNavbar

### PUBLIC-PAGES.LEGACY-CLEANUP

*Remove AppHeader.tsx and LegacyAppLayout*

- [ ] Audit which pages (if any) still use `LegacyAppLayout.astro`
- [ ] Migrate remaining pages to `AppLayout.astro`
- [ ] Delete `AppHeader.tsx` and `LegacyAppLayout.astro`
- [ ] Remove `AppHeader` from any component exports/barrels

### PUBLIC-PAGES.FOOTER

*Shared footer component for public and app pages*

- [ ] Design footer structure (links, social, copyright)
- [ ] Create `Footer.astro` component (zero JS, build-time)
- [ ] Add to `LandingLayout.astro`
- [ ] Decide whether app pages need a footer variant (likely no — sidebar layout doesn't need one)

### PUBLIC-PAGES.PERSONALIZATION

*Returning-user awareness on public pages (stretch)*

- [ ] `/courses` — show "Continue Learning" badge on enrolled courses via `getCurrentUserIfCached()`
- [ ] `/` (landing) — show "Go to Dashboard" instead of "Get Started" for cached users
- [ ] `EnrollButton` on public course pages — instant "Go to Course" for enrolled users (no fetch needed)

---

## Post-MVP Phases

*After PMF confirmation:*

| Phase | Purpose | Notes |
|-------|---------|-------|
| 11 | Goodwill Points System | 25 stories (23 P2, 2 P3). Points engine, summon help, tiers, anti-gaming. Detail in git history (removed Conv 095). Source: CD-010, CD-011, CD-023. |
| 12 | Gamification (leaderboards, badges) | Partially covered by GOODWILL |
| 13 | Database Backups & Disaster Recovery | |
| 14 | Full Legal/Compliance Review | |
| 15 | Scalability Optimization | |
| 16 | Mobile/PWA + R2 Video Streaming | |
| 17 | User Documentation/Help Center | |
| 18 | Localization/i18n | |
| 19 | Feature Flags | Re-add KV bindings + KV-backed flags. See `docs/reference/cloudflare-kv.md`. KV removed Conv 095. |
| 20 | Payment Escrow | Not implemented — immediate transfer + clawback. Client decides (US-P074/75/76). |
| 21 | Session Credits | Schema exists, dispute path works. Redemption depends on GOODWILL. |

*Additional deferred features:*
- Certificate PDF generation (→ CERT-APPROVAL.PHASE-3)
- "Schedule Later" video booking (from VIDEO block)
- Feed promotion (→ FEEDS-NEXT.PROMOTION, 3 stories)
- PLATO: supporting runs, browser tests, harvest, docs, persona tags, runner design flaw, next-gen (design in `plato.md`)

---

## Unimplemented Story Summary

**32 stories** remain unimplemented out of 402 total (92% complete). All are P2 or P3 — **zero P0/P1 gaps**.

| Block | Stories | Priority | Notes |
|-------|---------|----------|-------|
| GOODWILL | 25 | P2 (23), P3 (2) | Largest cluster — full subsystem |
| FEEDS-NEXT.PROMOTION | 3 | P2 (1), P3 (2) | Depends on GOODWILL + FEEDS-NEXT.RANKING |
| PAGES-DEFERRED (CHAT) | 2 | P2 | Superseded by community feeds |
| PAGES-DEFERRED (SUBCOM) | 2 | P3 | User-created study groups |
| PAGES-DEFERRED (CNEW) | 1 | P3 | Creator newsletters |
| PAGES-DEFERRED (CLOG) | 1 | P2 | Changelog — gap story, no route |
| **Total** | **34** | | |

*Source: [ROUTE-STORIES.md](docs/as-designed/route-stories.md) §10 (On-Hold) and §11 (Gap)*

*Note: Count is 34 including US-P053 and US-P082 which have routes (`/discover/leaderboard`) but are blocked on the goodwill points data they need to display.*

---

## Deferred: IMAGES

**Focus:** Image pipeline — upload endpoints, management UI, delivery optimization
**Status:** 📋 PENDING
**Merged Conv 095:** FILE-UPLOADS + IMAGE-MGMT + IMAGE-OPTIMIZE

**Current state:** R2 helpers exist (`src/lib/r2.ts`). Image display complete (Conv 023: unified fallback, community covers, FeedsHub images). Schema columns exist. No POST upload endpoints. Dev seed uses static placeholder avatar.

### IMAGES.UPLOADS — Upload Endpoints

- [ ] `POST /api/me/avatar` — accept image, validate size/type, resize to 200x200, upload to R2 `avatars/{user_id}/`
- [ ] `POST /api/courses/[slug]/materials` — file type validation, upload to R2 `courses/{course_id}/materials/`
- [ ] `POST /api/courses/[slug]/thumbnail` — course thumbnail upload (creator)
- [ ] `POST /api/communities/[slug]/cover` — community cover upload (creator)
- [ ] Profile settings UI: upload button, preview, remove option

### IMAGES.OPTIMIZE — Delivery Optimization (post-MVP)

- [ ] Choose service: CF Image Resizing (stay in ecosystem) vs Cloudinary (richer transforms)
- [ ] URL helper for transform URLs, responsive `srcset`, `loading="lazy"`, WebP/AVIF auto-format
- [ ] Trigger: image count >100, mobile perf bottleneck, or video thumbnails needed

---

## Deferred: FEEDS-NEXT

**Focus:** Feed enhancements — ranking, mobile performance, privacy, level matching, promotion
**Status:** 📋 PENDING
**Merged Conv 095:** FEEDS + FEED-PROMOTION + FEED-PRIVACY + LEVEL-MATCH
**Tech Doc:** `docs/reference/stream.md`

### FEEDS-NEXT.RANKING — Algorithmic Feed Ordering

*Requires paid Stream tier — awaiting client input*

- [ ] Confirm client wants ranked feeds (paid tier cost)
- [ ] Configure ranking formula: `decay_gauss(time) * pinned * priority * content_type_weights`
- [ ] User preference weights in D1 (announcements, courses, community)
- [ ] Pin posts: creator/admin pin/unpin action + `is_pinned` field in Stream activities

### FEEDS-NEXT.MOBILE — Feed Performance

- [ ] Verify pagination with `limit` + `offset`/`id_lt` in all queries
- [ ] Feed caching (React Query or similar)
- [ ] Loading skeletons for pagination
- [ ] 3G simulation testing

### FEEDS-NEXT.PRIVACY — Feed Visibility Toggle

*Schema: `communities.is_public` exists. Courses need `feed_public` column.*

- [ ] Privacy toggle UI + API for communities and course feeds
- [ ] SMART-FEED discovery already respects flags (Conv 017)

### FEEDS-NEXT.LEVEL-MATCH — Proficiency-Based Recommendations

*Schema ready: `user_tags.level` column (Conv 071)*

- [ ] Compare `user_tags.level` with `courses.level` in `scoreCandidates()`
- [ ] Boost/penalize course recommendations by alignment

### FEEDS-NEXT.PROMOTION — Paid/Points-Based Promotion (Post-MVP)

*Depends on GOODWILL (points) + RANKING (weighted display). 3 stories (US-S071, US-P085, US-C047).*

- [ ] Student: spend goodwill points to promote posts
- [ ] Creator: pay (Stripe) for promoted course placement

---

## Deferred: OBSERVABILITY

**Focus:** Error tracking, product analytics, user activity audit logging
**Status:** 📋 PENDING
**Merged Conv 095:** SENTRY + POSTHOG + AUDIT-LOG

### OBSERVABILITY.ERROR-TRACKING — Sentry

**Problem:** 176 API files use bare `console.error` (~292 call sites) — ephemeral on CF Workers.
**Tech Doc:** `docs/reference/sentry.md`

- [ ] Install `@sentry/astro` + `@sentry/cloudflare`, add DSN to envs
- [ ] Create `src/lib/sentry.ts` shared capture utilities
- [ ] Migrate routes in priority order: payment/webhook → auth → user-facing → admin → feed
- [ ] React Error Boundary on key components
- [ ] Wire user identification into CurrentUser
- [ ] Alert rules + Slack integration
- [ ] Source map upload in deploy pipeline

### OBSERVABILITY.ANALYTICS — PostHog

**Tech Doc:** `docs/reference/posthog.md`. Free tier covers Genesis (1M events/mo).

- [ ] Install `posthog-js`, add Astro/React integration
- [ ] Key events: `course_viewed`, `enrollment_started/completed`, `session_booked/completed`, `certificate_earned`, `became_student_teacher`
- [ ] Session replays
- [ ] Feature flags for A/B experiments

### OBSERVABILITY.AUDIT-LOG — User Activity Log

**Design:** Custom D1-backed. Schema and action codes designed (detail in git history, Conv 095). Recommendation: Option A (custom D1) for MVP, CF Workers Logs as complement.

- [ ] `audit_log` table in schema + `src/lib/audit.ts` with fire-and-forget `logAction()`
- [ ] Instrument: auth, enrollment, session, payment, certificate, admin, profile, course endpoints
- [ ] Admin UI: `/admin/audit-log` with date/user/action filters, single-user timeline, CSV export
- [ ] Retention: 90-day default, R2 archival for expired logs
- [ ] Subsumes ROLES.AUDIT (role changes logged here)

---

## Deferred: STUMBLE-REMNANTS

**Focus:** Deferred findings from STUMBLE-AUDIT walkthroughs (Conv 067-088)
**Status:** 📋 PENDING

### Cross-referenced (tracked in other blocks)

These items are already detailed in their respective blocks — listed here for traceability back to the walkthrough that found them.

**→ CERT-APPROVAL:**
- Broken route: `/course/[slug]/certificate` — page doesn't exist, linked from discover pages (Conv 068)
- No "Recommend for Certification" UI button (teacher side) — `POST /api/me/certificates/recommend` has zero UI consumers (Conv 082)
- Dashboard "Certification recommendation" attention item links to `/teaching/students` which has no recommend action — dead-end (Conv 082)
- Two parallel certification paths (creator direct vs recommend/approve) with no unified admin visibility (Conv 082)

**→ PLATO (Post-MVP):**
- Create `post-enrollment` instance and `multi-student` scenario (design in `plato.md`)

### Standalone items

- [x] The Commons `member_count` denormalized counter out of sync — fixed in seed SQL via `UPDATE communities SET member_count=N` after inserts (Conv 108).
- [ ] Expired/invalid JWT session tokens — no test coverage (requires infra-level test changes to mock token expiry)

### Client decisions required

- [ ] Remove MyXXX pages (`/courses`, `/feeds`, `/communities`) — redundant with unified dashboard? Needs client confirmation.
- [ ] Home page differentiation for new members — currently shows same Twitter-like feed for everyone (Conv 067)

