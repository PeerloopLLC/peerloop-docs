> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## Decision Log

For historical decisions and the full rationale behind each choice, see the session files in `docs/sessions/YYYY-MM/`.

### Matt's Figma Is Now Layout-Only; CC Owns Page Consistency; Tablet = Wider-Mobile
**Date:** 2026-06-15 (Conv 289)

The Matt phase-out reaches its endpoint: **Matt's Figma is consulted for LAYOUT only — not page designs.** CC has taken the mantle of making the app look and feel consistent using Matt's layout system + tokens; we no longer port Matt *page* frames. The **sole live exception is the mobile treatment**, which is novel and well-framed by Matt (base/sm/md page templates + populated mobile course pages, e.g. `1149:35443`, `1113:13756`) — mobile presentation is the active foundation piece. **Tablet (md, 768–1023) = "wider mobile," not desktop** (client preference): the viewport is desktop-sized, but the client wants it to lean heavily toward a wider mobile version; this aligns with the existing shell-swap-at-`lg` (md already renders in the no-card / floating-pill / single-column regime). Inconsistencies handled as they surface.

Page conversion continues on the Tier-1/Tier-2 model (see §"Tier-1/Tier-2 Page-Conversion Strategy" in `11-new-routing.md`) but is now driven by **CC's consistency judgment on the locked layout foundation**, not by waiting for Matt page frames. The layout foundation itself was locked Conv 289 ([LAYOUT-SG]: desktop 1248-cap shell + mobile/tablet shell + the `08-layout-and-margins.md` §8.3.3 spec).

**Rationale:** Matt's page frames stopped arriving; the desktop + mobile layout system he *did* draw is complete enough to be the durable foundation. Treating absent page frames as blockers would stall page conversion indefinitely. Making Matt layout-only lets the migration finish on Peerloop's own terms with a consistent, Matt-grounded shell. **Supersedes** the Conv-239 "Matt Phase-Out — Pages Default to @matt-inspired" execution posture: Matt frames are no longer even a preferred-when-available *page* spec — they are layout-only. The no-`/old/*`-function-loss floor still holds.

**See:** `docs/as-designed/matt-design-system/08-layout-and-margins.md` §8.3.3, PLAN.md §LAYOUT-SG, `11-new-routing.md` §Tier-1/Tier-2 Page-Conversion Strategy

### Cap AppLayout for the Margin-Jar Fix — No New ContentShell (LAYOUT-SG)
**Date:** 2026-06-15 (Conv 289)

The LAYOUT-SG margin-jar fix is solved by adding a `max-w-[1248px] mx-auto` cap+centering wrapper around the existing sidebar+card group inside `AppLayout` (`lg:justify-center`; grey page stays full-bleed). **No new `ContentShell` is built** — superseding the LAYOUT-SG spec's "build ContentShell" step.

**Rationale:** `AppLayout.astro` already hosts the white card, grey bg, mobile pills, and a left `sub-nav` slot (NAV-RETROFIT); only the `1248` cap was missing. Capping the existing shell fixes the jar app-wide; DOM-verified content=964px exact at 2xl, `/courses` + `/course/[slug]` pixel-identical (card x=387).

**See:** `docs/as-designed/matt-design-system/08-layout-and-margins.md` §8.5, `src/layouts/AppLayout.astro`

### Q2 — Utility Column Sits LEFT Across Page Types (LAYOUT-SG)
**Date:** 2026-06-15 (Conv 289)

The utility column (listing filters, entity SubNav, enrollment rail) sits **LEFT** across all page types on desktop. Client-decided; resolves the prior inconsistency (entity SubNav already left, listing filters were right). `ListingShell`'s filter panel migrated right→left via an `lg:order` swap.

**Rationale:** Client call. Standardizes the layout convention so all utility surfaces share one side.

**See:** `docs/as-designed/matt-design-system/08-layout-and-margins.md` §8.5.3, `src/components/layout/ListingShell.astro`

### Test Expectations Track Settled Behavior, Not In-Flight UI; Ground-Truth Divergence = Stale-Test
**Date:** 2026-06-15 (Conv 287)

When an e2e/integration assertion diverges from runtime, resolve it against **ground truth** (code comments, seed rows, schema) first. Ground-truth-confirmed app/seed intent = **stale test** → update the expectation (§Schema Discrepancy Discipline code-design-intent exception, no halt). Do **not** update expectations to match **in-flight** UI (e.g. dashboard headings changing when client-blocked ROLE-STUDIOS ships) — that creates false-green that re-breaks when the feature lands. Defer in-flight-coupled expectations; fix only already-shipped drift. Corollaries: a shared-helper fix only protects importers (grep the buggy pattern suite-wide for inline copies); bucket failures by spec + error-signature before fixing.

**Rationale:** Test expectations are only meaningful against settled behavior; verifying against ground truth separates stale tests from real bugs and avoids false-green churn.

**See:** `e2e/seed-data-verification.spec.ts`, `src/lib/current-user.ts`, PLAN.md §E2E-MIG

### Course SubNav Journey: Two-Tier Model — One-Time Gates + a Recurring Sessions Progress-Cluster
**Date:** 2026-06-04

The course SubNav's "Journey" zone stops being a flat checkbox ladder. It has **two kinds of item**: **one-time gates** (Enroll, Payment, Certificate — binary, ordered, genuine checkboxes) and a **recurring Sessions loop** (the session list + Book + Prepare/Join), which repeats once per module (1:1 session↔module) and is therefore **progress-bearing, not a checkbox**. The Journey renders the gates bracketing a single **Sessions cluster** carrying an "X of N complete" meter; **Certificate gates on `completed == total`**. **"My Sessions" moves from the Explore zone into this Journey cluster.** **Book** stays a **distinct, addressable rail action that opens its own page** — the multi-step booking wizard (teacher → hand-rolled calendar → time → confirm, plus reschedule + "start-now" invite modes + teacher/viewer timezone reconciliation) is page-worthy, not overlay-worthy. Progress reuses the **existing** `moduleInfo` / `getBookingEligibility` (`totalModules` / `completedCount` / `scheduledCount` / `nextModule`) — **no new schema**.

**Supersedes** ENROLL-NAV locked decision #5 ("Sessions list ABOVE in Explore, Book action BELOW") and the Conv-235 "My Sessions in Explore" naming resolution. **Rationale:** the enrollment's substance *is* the sessions, so the loop belongs in the Journey — but it's a repeating activity, not a one-time gate, so it's modeled as progress, not a checkmark. Confirmed by reading the legacy wizard (Conv 239): it already computes the X-of-N session model, so the meter + gate have a ready-made source. Tracked: **[JOURNEY-LOOP]** (rail + `computeCourseJourney` rework) now; **[BOOK-WIZARD-MATT]** (`[CALENDAR2]`, the wizard's Matt restyle) deferred.

### Matt Phase-Out — Pages Default to @matt-inspired, Decided Page-by-Page (Function First)
**Date:** 2026-06-04

The client is phasing out Matt's design involvement under time constraints. Matt's designs become **"nice-to-have":** we prefer his style when a frame exists for a specific page, but the **default posture flips** — most pages are now `@matt-inspired`, decided **page-by-page**, and we decide **what each page is functionally first, then drape Matt's style onto it**. The **non-negotiable floor is that no `/old/*` functionality is lost**. When a Matt frame is a redesign that omits working behavior, we **merge**: keep 100% of legacy function, adopt Matt's style + any net-new surfaces, and use **static data for anything with no schema** (CREATOR_STATIC precedent), then revisit.

**Rationale:** Matt's frames stop arriving; treating them as hard specs would stall the migration. The migration finishes on Peerloop's own functional terms with Matt's design language as a preferred-but-optional skin. First application: `/session/[id]` ([SESS-GRAD], Conv 239) — Matt's `622:17884` "Session Prepare" (checklist/notes/chat) merged onto the full legacy join/rate/cancel state machine, prepare surfaces static. Supersedes the Figma-spec-dependence in `project_matt_collaboration_style` for execution sequencing.

### /members Keeps the Server-Driven Directory Pattern (Not the Per-Role Dispatcher)
**Date:** 2026-05-31

The `/members` root port keeps a single server-driven `MembersDirectory` island with multi-select role pills + sort + Load-More, conforming only the Matt visual grammar (search/sort/count/card grid via Matt primitives). It does NOT adopt the 3-island single-select per-role dispatcher used by /courses and /communities.

**Rationale:** On /courses the role tabs mean "courses where I am X" (viewer relationship); on /members the roles mean "users who HAVE role X" (entity property), are multi-selectable, and are server-paginated. The dispatcher's defining concept has no referent on /members; forcing it would drop legacy behavior (a failed port). Role-tab-bar/role-color reconciliation deferred to [DISC-RTB-RECONCILE]/[RTB].

### Moderator Source of Truth: community_moderators (Not can_moderate_courses)
**Date:** 2026-05-31

`/api/members` derives the moderator signal from `community_moderators` (EXISTS, `is_active=1`) for filter clause, role-sort, and `isModerator` badge. The dead `can_moderate_courses` column was dropped from the query.

**Rationale:** `can_moderate_courses` is a capability flag the seed only grants to admins; real community moderators (Sarah, Marcus) live in `community_moderators`. This matches the moderation lens used elsewhere. +2 regression tests lock it in. Admin directory privacy (`privacy_public=0`) left unchanged per user.

### Catalog Filter Islands Are Tab-Aware; All-Tab Restores Full Legacy Functionality
**Date:** 2026-05-31

[DRV-B2] restored full legacy All-tab functionality dropped by the Conv-205/221 filter-only ports: /courses gets duration filter + 5-way sort + result count + 12/page pagination + removable active-filter pills + per-card CTA; /communities gets sort + count + pagination. Filter islands are tab-aware — attribute controls (level/topic/duration/sort) + pills render only on the "all" tab; search persists on role tabs. New shared `ui/CatalogPagination` primitive.

**Rationale:** A port = faithful functionality + Matt styling, co-equal (`feedback_port_functionality_and_styling`); the All-tab is the catalog and must carry the catalog's full legacy controls.

### Session Completion: Teacher/Creator Only — Students Cannot Complete
**Date:** 2026-03-24

Students are not authorized to call `POST /api/sessions/:id/complete`. Only the session's teacher or the course creator can mark a session as completed. Students who encounter a stuck session see an inline message form to notify the teacher.

**Rationale:** Completion triggers `module_id` freezing and enrollment progress tracking. Allowing students would let a no-show student mark the session as `completed` (getting module credit) instead of `no_show`. The teacher is the authority on whether the session actually occurred.

### Session Completion Defense-in-Depth Chain
**Date:** 2026-03-24

Five layers ensure sessions transition out of `in_progress`, in order of timeliness: (1) BBB `meeting-ended` webhook (real-time), (2) empty-room detection on `user-left` webhook (real-time), (3) client-side "Complete Session Now" button for teacher after `scheduledEnd` (user-initiated), (4) admin batch cleanup endpoint (manual), (5) Cloudflare Cron Trigger (deferred to pre-launch, CRON-CLEANUP block).

**Rationale:** No single mechanism is reliable. BBB webhooks can fail silently, users can close browser tabs without triggering `user-left`, and admin cleanup requires human action. Each layer catches what the previous one misses.

### completeSession() as Post-Completion Pipeline
**Date:** 2026-03-24

`completeSession()` orchestrates all post-completion behavior as a single pipeline: status transition → module freeze → module backfill (for out-of-order completions) → enrollment completion check → post-session actions (notifications + stats, async non-blocking). All completion paths (BBB webhook, manual endpoint, admin) get the full pipeline automatically.

**Rationale:** Centralizing in one function eliminates duplication across 3+ callers and guarantees consistency. Backfill and enrollment check are synchronous (their results inform notifications). Post-session actions are fire-and-forget to avoid blocking the completion response on notification/stats failures.

> **Insight:** This is a lightweight saga pattern — a sequence of steps where each informs the next, with the final step being non-blocking. Unlike a traditional saga, there's no compensation (rollback) because each step is independently valuable and idempotent.

### Publishing Gate: Tag-Based (Post TAG-TAXONOMY)
**Date:** 2026-04-01

Publishing checklist requirement changed from "Topic selected" (`!!course.topic_id`) to "At least one tag assigned" (`course.tags.length > 0` frontend, `COUNT(*) FROM course_tags` backend). Post TAG-TAXONOMY refactor, courses are discoverable via tag:tag matching — whether tags have topic associations is a data quality concern, not a publishing gate.

**Rationale:** The `courses.topic_id` column was removed in TAG-TAXONOMY (Conv 048-054) but the publish checklist still checked it. Tags are the discoverability mechanism; at least one tag is the minimum requirement.

### Enrollment: Teacher Defaults to Course Creator
**Date:** 2026-04-01

In `createEnrollmentFromCheckout()`, if `assigned_teacher_id` is null/empty in Stripe metadata, look up the course creator and assign them as the default teacher.

**Rationale:** For creator-taught courses (the most common case), the creator IS the teacher. Peer-teacher courses require explicit teacher selection during checkout, so metadata will have the value. This ensures every enrollment has a teacher assigned.

### PLATO Segments: Composability + Restartability
**Date:** 2026-04-01

Segments are named step groups (2-3 steps) with goals, transparent context flow, and DB snapshots at boundaries. New types: `PlatoSegment`, `SegmentRef` as `ChainEntry` variant. Future consideration: `$flow.state` (Node-RED `msg` pattern) for self-aware segments.

**Rationale:** Merges two goals — composability (reuse segments across scenarios) and restartability (restore pre-failure snapshot, re-run segment). Transparent context avoids input/output contract overhead. Snapshots solve partial-write problem. Full design in `docs/as-designed/plato.md`.

> **Insight:** The Node-RED `msg` pattern — a single object traveling through all nodes as both data plane and control plane — maps cleanly to PLATO's `$context`/`$flow.state` split. Per-step namespaced context prevents collisions while flow-wide state enables cross-cutting concerns (skip directives, mode flags, completion tracking). This makes segments self-aware rather than runner-directed.

### Five-Gate Baseline: tsc + astro check + lint + test + build
**Date:** 2026-04-11 (Conv 104)

The Peerloop baseline check set is now five gates, not three. All must be green before claiming "clean baselines" anywhere (session docs, RESUME-STATE, PR descriptions, memory): `tsc --noEmit`, `npm run check` (astro), `npm run lint`, `npm test`, `npm run build`. `tsc --noEmit` does NOT scan `.astro` files — Astro provides its own TypeScript diagnostics via the Astro Language Server, surfaced by `astro check`. Enforced in CI (`lint-and-typecheck` job), `/w-codecheck` skill, `CLAUDE.md`, `docs/reference/BEST-PRACTICES.md`, and memory (`feedback_baseline_includes_astro_check.md`).

**Rationale:** /w-codecheck surfaced 10 `.astro` type errors invisible to tsc. Conv 100–103 baseline claims were retroactively incomplete. User principle: "We don't want to bypass issues as we do upgrades, refactors, etc, or really ever." Single-source enforcement prevents the gap from recurring.

### Stripe apiVersion Bumped to `.dahlia` with SDK v22 (No Cast)
**Date:** 2026-04-11 (Conv 104)

When upgrading Stripe SDK majors, bump `apiVersion` to match the SDK's pinned literal type rather than casting to preserve the old version. SDK v22 pins to `'2026-03-25.dahlia'`; we moved from `'2026-02-25.clover'`. Audit the `.clover → .dahlia` delta via Stripe changelog BEFORE merging; document the audit in `docs/reference/stripe.md` as a template for future bumps. Execute the changelog audit immediately while context is hot — do not defer.

**Rationale:** Casting to preserve the old apiVersion introduces a silent type/wire mismatch — exactly the footgun the pin is designed to prevent. The single-line change surface (centralized in `src/lib/stripe.ts`) makes bumping cheap; the risk is behavioral wire-shape changes, which the changelog audit handles.

### CourseTag: Rename Junction Row, Canonicalize Display Shape
**Date:** 2026-04-11 (Conv 104)

When a type name is used for two semantically different things, rename the wrong one — do NOT cast at call sites. `CourseTag` had three definitions (junction row + two display copies). Renamed the junction row → `CourseTagRow` in `src/lib/db/types.ts`, made `CourseTag = { tag_id: string; name: string }` the canonical display shape, and had `mock-data.ts` + `course-tabs/types.ts` re-export from `db/types`. Related: `CourseTabs.initialTab` widened to `TabId | (string & {})` to honestly match the runtime's `useState<string>` (the narrow type was a lie that passed tsc only because `.astro` was never scanned).

**Rationale:** Casting at each call site rots — every new page is another cast. Renaming consolidates the truth at one site and automatically fixes all downstream consumers that were already importing by name. Zero `.astro` file edits were needed.

> **Insight:** Duplicate type definitions are a symptom of the real bug — a contested name. Renaming the semantically-wrong definition is almost always the minimally-invasive durable fix, because consumers usually reach for the canonical path already. `(string & {})` is the standard TypeScript idiom for "literal union OR any string" while preserving autocomplete, and is worth reaching for whenever a React prop flows into open-string state.

### Unauthenticated Users Redirected to /signup (Not /login)
**Date:** 2026-04-12 (Conv 108)

When a visitor hits a protected route, they are redirected to `/signup`, not `/login`. The signup page has a "Sign in" toggle for returning members.

**Rationale:** Growth funnel optimization — new visitors are more valuable as signups. Existing users can switch to login. Unauthenticated users are Schrödinger's cat: both visitors and logged-out members.

### courses.primary_topic_id Restored to Schema
**Date:** 2026-04-12 (Conv 108)

`primary_topic_id TEXT REFERENCES topics(id) ON DELETE SET NULL` added back to the `courses` table after the package-upgrade branch dropped it, causing an E2E regression.

**Rationale:** Column is used by the discover/courses page for topic filtering. All seed courses assigned a topic ID. Schema, types, and seed data updated.

**See:** `migrations/0001_schema.sql`, `src/lib/db/types.ts`

### E2E Session-Completion Tests Use Pre-Completed Seed Session (Not BBB Webhook)
**Date:** 2026-04-12 (Conv 108)

`session-completion-flow.spec.ts` uses the pre-completed seed session `ses-david-n8n-1` to verify completion UI, rather than firing a BBB webhook.

**Rationale:** Miniflare `fetch failed` when E2E tests fire BBB webhooks — the dev server can't reach external services. Using seed data tests identical UI paths without external dependencies. Test is deterministic and covers both student and teacher perspectives.

**See:** `e2e/session-completion-flow.spec.ts`

---

### CourseFollowButton: Show Disabled Indicator for Enrolled Users (Not Hidden)
**Date:** 2026-04-19 (Conv 138)

When a user is enrolled in a course, the `CourseFollowButton` shows a disabled "Following (enrolled)" indicator rather than hiding the button entirely. Enrolled users already have a Stream timeline follow via enrollment, so the explicit follow action is unavailable — but the relationship is made visible.

**Rationale:** Hiding the button silently omits context. The disabled indicator communicates that the follow relationship exists (via enrollment) and explains why independent following is not available.

---

### Disputed Enrollment Download Access: Allowed
**Date:** 2026-04-18 (Conv 129)

Students with `disputed` enrollment status retain download access to course resources. Only `cancelled` enrollments and soft-deleted enrollments (`deleted_at IS NOT NULL`) are blocked from the download gate.

**Rationale:** Revoking access during an open dispute would be perceived as bad faith and could escalate the dispute. Access can be revoked after dispute resolution if needed.

> **Insight:** This pattern — permitting access during dispute rather than blocking — is standard in digital goods marketplaces where revoking during investigation creates adversarial dynamics. Review after resolution is the preferred enforcement point.

---

### useCallback-Wrap as Uniform Cat 3 Fix Pattern for react-hooks/exhaustive-deps
**Date:** 2026-05-06 (Conv 148)

When a `react-hooks/exhaustive-deps` warning surfaces for an in-component `async function fetchX()` called from `useEffect`, wrap as `useCallback` with closure deps and add the function to the effect's dep array. Apply uniformly across all flagged files — including single-callsite cases — rather than choosing per-file between inline-into-effect and useCallback.

**Rationale:** ~5 of 14 Phase 2 files used the fetch function from event handlers (`onClick={fetchX}`) or other effects in addition to the original useEffect — inlining would have required also rebuilding the call site as a useCallback handler anyway. A uniform pattern is mechanical, predictable, and easy to review. Per "default durable" (CLAUDE.md), wrapping costs a small amount of boilerplate but doesn't lose any behavior — and survives future scope changes (adding a new callsite from a handler later doesn't require revisiting). Also: when converting a hoisted `function` helper used in `useState` initializers, move the `useCallback` declaration to BEFORE the first reference and use the lazy initializer form `useState(fnRef)` instead of `useState(fnRef())`, since `const`-bound `useCallback` is not hoisted (TDZ).

---

### setCurrentUser Dedup Guard: (id, dataVersion) Tuple
**Date:** 2026-05-06 (Conv 149)

`setCurrentUser` in `src/lib/current-user.ts` now includes a 6-line dedup guard at the top: if `prev.id === next.id && prev.dataVersion === next.dataVersion`, the new `CurrentUser` instance is dropped and listeners are not notified. This prevents the focus-event render cascade where `AppNavbar`'s `window focus` handler calls `refreshCurrentUser()`, constructs a new `CurrentUser(data)` with no change, and notifies all subscribers — causing all `useMemo([currentUser])` and `useCallback([user])` extractions to recompute on every tab-back.

**Rationale:** `dataVersion` already exists for version polling (Conv 013); the server bumps it on every real data change. Using it as the equality signal reuses an existing invariant rather than inventing a new one (e.g., deep equality, client-side dirty flag). Fixes the issue at the singleton-update site so all `subscribeToUserChange` consumers benefit. O(1) check. Backed by a regression test.

**Consequences:** All `subscribeToUserChange` consumers only fire on real data changes. Test fixtures that simulate a server-driven update must bump `dataVersion` to model reality (3 existing test fixtures updated Conv 149).

**See:** `src/lib/current-user.ts` (`setCurrentUser`), `tests/lib/current-user-listeners.test.ts`

---

### Prod D1 Mutations Bundled into DEPLOYMENT.DB-SYNC (Atomic Convergence)
**Date:** 2026-05-21 (Conv 169)

When prod D1 carries known migration/schema drift and a separately-tracked prod data mutation (e.g., `[PROD-PW-APPLY]` password rotation) becomes actionable, do NOT apply the data mutation in isolation. Bundle the data mutation with the schema convergence into a single sub-block under the existing `Active: DEPLOYMENT` block in PLAN.md. The bundle is applied as one atomic step when DEPLOYMENT is actively worked.

**Rationale:** Applying mutations one-by-one over multiple convs leaves prod in successively-different intermediate states, none of which matches any reference (local, staging, or seed file). Bundling makes the diff a single atomic step. Extends the DECISIONS.md §4 PROD-PW principle ("bundle so live prod and seed never disagree") from the single-shot password case to the general "any prod mutation while prod is drifted" case. Conv 169 surfaced the drift during PROD-PW-APPLY prep: prod's `d1_migrations` tracker had `0002_seed.sql` (old filename pre-seed-split rename), and migrations 0003 + 0004 were never applied — `feed_visits` and `feed_activities` tables missing on prod.

**Consequences:**
- New `DEPLOYMENT.DB-SYNC` sub-block in PLAN.md contains 5 atomic tasks: `[DB-SYNC-04]` apply migration 0004 + tracker row, `[DB-SYNC-03]` tracker row only for already-converged 0003, `[DB-SYNC-02-RENAME]` rename `0002_seed.sql` → `0002_seed_core.sql` in tracker, `[PROD-PW-APPLY]` absorbed with full 3-step procedure inline, `[DB-SYNC-VERIFY]` final convergence check
- Old `[PROD-PW-APPLY]` line in PLAN.md "Conv 168 Items" section marked with `[→]` redirect marker
- Migration-rename tracker discrepancy detection added to the audit playbook: check both (a) `wrangler d1 migrations list` AND (b) actual schema state via `SELECT name FROM sqlite_master` — the tracker can lie about applied files when renames have happened

**See:** `PLAN.md` § DEPLOYMENT.DB-SYNC sub-block, this file § Prod admin seed password (Conv 168)

---

### Matt-Design Tokens as Future Global Default, Consumed Only by `/matt/` Initially
**Date:** 2026-05-21 (Conv 169)

The Matt-designed style system (typography, colors, spacing, icons) is implemented as the future global default — CSS custom properties + Tailwind theme extension, named/structured as the canonical layer — but only `/matt/*` routes consume it initially via a dedicated `MattLayout.astro`. Existing routes keep their current styles untouched until each is individually migrated. The eventual flip (`/matt/` → `/`, current `/` → `/fraser`) becomes a layout-import swap, not a token rename migration.

**Rationale:** User scope direction: "scoped to /matt only. We will be moving other pages into /matt so that they conform to the style guide. Eventually we will be flipping /matt into / and the current / tree into /fraser." Two alternatives rejected:
- Hard isolation (Matt-prefixed utility classes, separate CSS namespace) — would require renaming every token reference at flip time
- Replace defaults immediately and re-skin existing pages as we go — too disruptive mid-flight; existing pages aren't ready

By treating tokens as future-canonical from the start, the `/matt/` constraint lives in *which layouts opt in*, not in token naming or namespacing.

**Consequences:**
- Token file location/naming reflects future-default identity (`tokens.css`, `theme.config.ts`), NOT `matt-tokens.css` or `matt-theme.config.ts`
- Existing layouts continue to use their current styles unchanged
- `/matt/*` routes opt in via `MattLayout.astro` (consumes the tokens); other layouts ignore them
- The flip from `/matt/` → `/` is a layout-import operation, not a token-rename operation
- All implementation deferred to next conv ([MATT-PRE-PLAN]); branch `jfg-dev-13-matt` from `jfg-dev-12`

**See:** `.scratch/matt-figma/_INVENTORY.md`, `.scratch/matt-figma/overview/pages-panel.md`

---

### `useRoleTabs` Owns the Shared Role-Tab Mechanics; Feeds Excluded by Structure
**Date:** 2026-05-31 (Conv 228)

Shared `useRoleTabs({validTabs, eventName, visibleTabs})` hook (`src/components/useRoleTabs.ts`) extracted from the Courses/Communities adapters; owns hash-init state, hash-sync + `<entity>:tabchange` dispatch, reset-on-logout, and map→`RoleTab[]`, while RECEIVING the caller's `useMemo`-derived `visibleTabs`. FeedsDirectory excluded by structure (inline catalog, no sibling-island event).

**Rationale:** Passing derived data in (not a derivation callback) keeps each adapter's memo deps natural and lint-clean and avoids the hook calling `useCurrentUser`; rejected option-1 (callback + deps) reintroduces the stale-memo problem. −57 net lines across the two adapters.

**See:** `docs/decisions/05-ui-ux-components.md` entry; `src/components/useRoleTabs.ts`; Conv 228 Decisions.md §2.

---

### Admin Attention Badge Restored on Listing Cards Only; Detail-Page Admin Tab Deferred to RTMIG-4
**Date:** 2026-05-31 (Conv 228)

Per-card admin-intel attention badge restored on `CourseCatalogCard` + `CommunityCatalogCard` (opt-in `adminBadgeCount?` → `<AdminBadge>`, admin-gated batch fetch keyed to visible "all"-page IDs). Detail-page "Admin" extra-tab NOT rebuilt — it belongs to not-yet-ported detail pages (RTMIG-4).

**Rationale:** The Conv 205/221 filter-only ports dropped only the listing surface; the batch endpoints + `AdminBadge` still exist, so restoration is pure client wiring (no API/schema change). Cards stay 404-honest; detail-page admin tab is out of scope until its page is ported.

**See:** `docs/decisions/05-ui-ux-components.md` entry; `CourseCatalogCard.tsx`, `CommunityCatalogCard.tsx`; Conv 228 Decisions.md §3.

### Leaderboard Discover-Destination Dropped (Not Ported to Root)
**Date:** 2026-06-01 (Conv 229)

The `/old/discover/leaderboard` destination will not be ported to root — the lone remaining DISC-DROP umbrella item, now dropped, which closes the umbrella (courses/communities/members/feeds already ported). No root `/leaderboard` link exists (leaderboard was excluded from the Matt sidebar in Conv 221), so nothing dangles.

**Rationale:** Product decision — leaderboard is not part of the root experience.

**See:** `docs/decisions/11-new-routing.md` entry; legacy `/old/discover/leaderboard.astro` + `api/leaderboard.ts` + `Leaderboard.tsx` retained under the /old-retention rule; Conv 229.

---


### FeedsHub Mounted on "/" via a Standalone Panel, SSR Auth-Gated
**Date:** 2026-06-01 (Conv 230)

The `/` landing FeedsHub surface ([HOME-FEEDSHUB], #28) is mounted as a standalone `src/components/feed/FeedsHubPanel.tsx` (`@matt-inspired`), mirroring `FeedsDirectory`'s `AllTabContent` rather than extracting a shared view or reusing `FeedsDirectory` as-is. Auth gating is SSR (`getSession` → `isAuthenticated` in `index.astro`): logged-in → "Your Feeds" (`FeedsHubPanel`, `client:only`) replaces the Recent-Activity empty state; visitor keeps current behaviour (deferred to #32). Registered in `scripts/matt-inspired-registry.ts`.

**Rationale:** Standalone duplication (~150 lines) keeps zero blast radius on the shipped `/feeds` surface; a whole-section swap wants SSR branching to avoid hydration flash; treated under full RTMIG/Tier-1 port discipline despite being a section-level insertion. Implements the `/` landing reserved in the Conv-224 `/feeds`-is-Discover-Destination decision.

**See:** `docs/decisions/01-architecture.md` entry; Conv 230.

---

### Precheckout Is an Addressable Route (`/course/[slug]/precheckout`) — Reverses Conv 187
**Date:** 2026-06-01 (Conv 232)

Matt's "enroll/purchase" frame (`558:15067`) is served as a real addressable route at `/course/[slug]/precheckout`, **reversing** the Conv 187 [MATT-EXEC-FLAGS] non-addressable classification. The standalone `precheckout.astro` sits beside the `[...tab].astro` catch-all; the shared body (`PrecheckoutContent.astro`) is also hosted in-shell as a `/benefits` SubNav tab.

**Rationale:** The deep-link audit still returned "No" on all three candidates, but the already-implemented `CourseHeader` CTA `<a href=".../checkout">`, the standalone-frame design, and the addressable Enroll-funnel siblings outweighed the strict test — a Conv-187 tiebreaker for a page presumed transient that no longer governs once the page is a real linked destination.

**See:** `docs/decisions/11-new-routing.md` entry; Conv 232.

---

### Per-Course Teacher-Earnings Aggregate: Mirror the Canonical Query, Honest Zero-State
**Date:** 2026-06-01 (Conv 233)

The precheckout earnings figure is computed from a real aggregate (`payment_splits` `recipient_type='teacher'` joined through `enrollments.course_id`), mirroring the canonical per-course query in `api/teaching/courses/[courseId].ts` with no `status` filter; surfaced as `teacherEarningsCents` on `CourseTabData`. Live whole-dollar total when >0, else forward-looking copy with no fabricated number (retires the static `$7,438` demo).

**Rationale:** Consistency with teachers' own-dashboard query + honest $0 handling; supersedes the Conv-189 static-demo earnings placeholder.

**See:** `docs/decisions/08-deployment-infra.md`; Conv 233.

---

### Success Page Ported to Matt-Source, Phased; Downstream Links 404-Honest
**Date:** 2026-06-01 (Conv 233)

Post-checkout success ported to new Matt-source route `src/pages/course/[slug]/success.astro` (`@matt-source 579:16885`), replacing the missing root route that `[...tab].astro` 302-bounced (`success` ∉ `VALID_TABS`). Phased (B): Phase 1 = congrats + first-session card (real curriculum data) + CourseHeader Enrolled hero + preserved self-heal/ExpectationsForm; composer deferred to Phase 2 (#38). "Schedule Session 1" → real `/course/[slug]/book` 404s honestly until ported.

**Rationale:** Matt redesign is more suitable than legacy; phasing closes the payment-flow break fast; 404-honesty per the one-page-at-a-time migration principle.

**See:** `docs/decisions/11-new-routing.md`; Conv 233.

---

### `checkout.session.expired` Webhook: Intentionally NOT Handled (No-Op)
**Date:** 2026-06-01 (Conv 233)

The `checkout.session.expired` case is deliberately unhandled — session creation writes nothing to D1 (enrollment row created only on success) and courses have no seats, so there is nothing to clean. The misleading `FUTURE` stub comment was replaced with an accurate no-op note.

**Rationale:** A handler would be dead code against never-implemented pending-row/seat-limit patterns.

**See:** `docs/decisions/08-deployment-infra.md`; Conv 233.

---

### Checkout Cancel Feedback via Transient Toast (Not a Page)
**Date:** 2026-06-01 (Conv 233)

`cancel_url` now appends `?enroll=cancelled` → `/course/[slug]`; a `CheckoutCancelToast.tsx` island fires a one-time "you weren't charged" toast via `showToast` and strips the param. Rejected: a dedicated cancel page; leaving it silent.

**Rationale:** Transient confirmation = overlay not an addressable page (routing-addressability rule); unhappy path undrawn by Matt; cheap + honest.

**See:** `docs/decisions/08-deployment-infra.md`; Conv 233.

### Booking Route — Tactical `@stand-in` Rehost Now, Matt Retrofit Parked
**Date:** 2026-06-01 (Conv 234)

Root `src/pages/course/[slug]/book.astro` built as an `@stand-in` rehost — legacy server logic + untouched `SessionBooking.tsx` wizard on the Matt `AppLayout` shell; full Matt restyle parked under [ENROLL-NAV]. Rejected: wrapper+teacher-select restyle; full Matt wizard port (multi-conv).

**Rationale:** Matt has no course-hosted booking design; full restyle overlaps PENDING CALENDAR and is multi-conv. Rehost closes the Conv-233 404 and walks the enroll→success→book funnel end-to-end without redoing work CALENDAR/ENROLL-NAV will own.

**See:** `docs/decisions/11-new-routing.md`; Conv 234.

---

### ENROLL-NAV — Dual-Zone Course SubNav (Spec-Only, 5 Decisions Locked)
**Date:** 2026-06-01 (Conv 234)

Course SubNav to become dual-zone (Explore zone above a divider, gated enrollment "Journey" funnel below). Spec-only this conv (`plan/enroll-nav/README.md`), build deferred (PLAN #25). 5 locked: one assigned teacher; Modules + "1:1 Sessions" kept separate ("Modules" name retained); Book = own Journey item → `/book`; Journey zone always shown w/ gated steps; Sessions-list above divider, Book action below.

**Rationale:** Re-homes the enrolled-operational tabs the Matt rewrite dropped; matches the user's browse-vs-directed framing; grounded in legacy `CourseTabs`. Diverges from Matt's flat rail → flag.

**See:** `docs/decisions/11-new-routing.md`; Conv 234.

---

### ENROLL-NAV BUILT — Dual-Zone SubNav + "My Sessions" Explore Tab + Funnel Rail Persistence
**Date:** 2026-06-01 (Conv 235)

The Conv-234 dual-zone SubNav spec is built. Matt's "1:1 Sessions" = the existing Modules tab; the dropped surface (student's personal *schedule*) is built as a new `@matt-inspired` "My Sessions" tab in the Explore zone, OUTSIDE the gated Journey state machine. `/success` (all viewers) + `/session/[id]` (student-only) now carry the course rail, diverging from Matt's rail-less success frame so the funnel never drops its own nav. 6 files + new `MySessionsTab.astro`; 5 gates green (6460), browser-verified as David. Divergences → [ENROLL-NAV-MATT-CONFIRM] #38.

**Rationale:** Modules = "what the course teaches", My Sessions = "what meetings / when"; distinct. Journey = directed funnel, schedule = revisitable dashboard ⇒ Explore. Built whole in one conv so one conversation informs the entire state machine + rail.

**See:** `docs/decisions/11-new-routing.md`; Conv 235.

---

### Root `/session/[id]` — `@stand-in` Rehost (closes Prepare/Join 404)
**Date:** 2026-06-01 (Conv 235)

Created `src/pages/session/[id].astro` as a `@stand-in` (legacy server logic verbatim on the Matt shell, `SessionRoom` island untouched). Closes the Prepare/Join 404 (root session route didn't exist post route-flip) and fixes the same latent 404 in MyStudents/SessionHistory/StudentDashboard. Follows the Conv-234 `/book` precedent; full Matt retrofit deferred to [MATT-EXEC-PG2] #9.

**Rationale:** Default-durable; rejected pointing links at `/old/session/[id]` (mixes /old into Matt pages) and disabling Prepare/Join.

**See:** `docs/decisions/11-new-routing.md`; Conv 235.

---

### COMM-DETAIL — `/community/[slug]` Detail Family (Triad Decompose, About Default, Commons Pinned)
**Date:** 2026-06-03 (Conv 237)

Ported `/old/community/[slug]/*` to root `/community/[slug]` mirroring `/course/[slug]`, via three locked decisions: (1) **Approach C full decompose** of the 628-line `CommunityTabs` island into per-URL server/island tabs — standardizes the `[...tab].astro` + `_*-tabs.ts` + `SubNav` triad across a 3rd page family (course / profile / community), `/profile` de-risks it; (2) **empty segment = NEW About/Overview default** (Feed moves to `/community/[slug]/feed`, canonical URL change); (3) **The Commons pinned on /communities** as a distinct card above the joinable grid (auto-join → not a join candidate but a real destination, mirrors `FeedsHubPanel`). SubNav holds destinations only — Manage/Leave → header, `?tag=` filters → tab body.

**Rationale:** SubNav-triad standardization payoff; schema-backed About overview; The Commons needs a reachable destination. Decorative `?tag=` chips + dead Leave button dropped → [COMM-TAG-FILTER]. `bio` (`u.bio_short`) threaded through `fetchCommunityDetailData`, no schema change. `/feed/[slug]` = 4th triad family. 5 gates green (6460/6460), browser-verified.

**See:** `docs/decisions/11-new-routing.md`; Conv 237.

---

### FEED-DETAIL — Single-Page `/feed` Port (Not a [...tab] Family)
**Date:** 2026-06-03 (Conv 238)

[FEED-DETAIL]'s "port to a 4th `/feed/[slug]` [...tab] family" premise was wrong — legacy `/feed` is a single 40-line SmartFeed page with no slug family, while ~7 components link to bare `/feed` (404). Re-scoped to a single-page `@matt-inspired` port (`src/pages/feed.astro`, Matt shell + existing `SmartFeed` island). Establishes the single-page legacy-port pattern, distinct from the triad. Discovery CTAs repointed to root (`discover.ts`/`enrichment.ts`/DiscoverSlidePanel). 5 gates green (6460/6460), browser + curl verified.

**Rationale:** Matches legacy reality + fixes the dead links; the triad is for multi-tab entity-detail, which a personal smart feed is not.

**See:** `docs/decisions/11-new-routing.md`; Conv 238.

---

### COMM-TAG-FILTER — Channels Model + `community_channels` Table
**Date:** 2026-06-03 (Conv 238)

Community feed filtering modeled as channels (per-community posting categories) in a new `community_channels` table (seed Commons general/announcements/help). Rejected the 55-tag topic taxonomy (wrong purpose) and a fixed hardcoded list. "Real" filtering has no backing data (no tag column, no Stream tag field, limit/offset-only townhall API) — net-new feature, not wiring. LOCKED Conv 238; build deferred to its own conv; design at `plan/comm-tag-filter/README.md`.

**Rationale:** Channels are the honest town-hall model; a table generalizes per-community without a second migration. Taxonomy is for skill-matching, not feed organization.

**See:** `docs/decisions/02-database.md`; Conv 238.

### JOURNEY-LOOP — Two-Tier Course Journey in the Builder, Flat `CourseJourneyState`
**Date:** 2026-06-04 (Conv 240)

The two-tier course Journey (one-time Enroll/Payment/Certificate gates bracketing a recurring "X of N" Sessions progress-cluster) is built in `buildCourseTabs` via a `CourseTabNavLink | CourseTabNavCluster` union, NOT in the data layer. `CourseJourneyState` stays flat — it already carries every field; nesting into `gates`/`sessions` is cosmetic churn for zero behavioral gain. No loader/schema change; change centralized to `_course-tabs.ts` + `SubNav.astro`. "My Sessions" moved Explore→Journey; Certificate gate done when `isComplete || completedCount===totalModules`.

**Rationale:** The conceptual two-tier split belongs at the render/builder layer where it materializes, not in the state shape. Documented as a deliberate spec deviation in `plan/enroll-nav/README.md`.

**See:** `docs/decisions/05-ui-ux-components.md`; Conv 240.

### Legacy Is the Functional Source of Truth; Matt Is the Skin (Happy-Path-Only)
**Date:** 2026-06-04 (Conv 242)

When a Matt frame redesigns a working legacy surface but omits non-happy-path behavior, keep the legacy functionality and drape Matt's style onto it — Matt's designs are happy-path-only. First applied to CALENDAR2: the booking re-skin merged date+time onto one screen (per Matt's `622:15671`) but KEPT the legacy confirm step + step indicator (carrying the booking summary + reschedule context Matt's single CTA drops), swapped Button/MattIcon, and left status colors as functional Tailwind.

**Rationale:** Matt's design is naive about the non-happy paths during booking; re-skinning while silently dropping behavior is a failed port, not a simplification.

### Relative Day/Time Display Is Formatted Client-Side in the Viewer's TZ (`<time datetime>` + `astro:page-load`)
**Date:** 2026-06-04 (Conv 242)

For TZ-fragile relative-time surfaces (CourseHeader Scheduled variant's "Tomorrow • 9:00 AM"), keep ISO UTC in the data and format day+time on the client in the browser's TZ via a `<time datetime={iso}>` upgraded by an `astro:page-load` script — the only option correct on both relative-day AND time-of-day. Reusable by [TZ-AUDIT].

**Rationale:** "Local" on a Cloudflare Worker = UTC, so any server-side day/time bucketing is off-by-one for far-TZ viewers; client-side formatting pre-solves a TZ-audit slice instead of adding debt.

### Milestone Composer Is a New Focused Island + Shared `postCourseFeed()` Helper (Not a `mode` Prop on MattCourseFeed)
**Date:** 2026-06-06 (Conv 243)

The enrollment-milestone composer on `/course/[slug]/success` (`@matt-source 729:15940`) ships as a new focused `MilestoneComposer.tsx` island, not a `mode="milestone"` branch on `MattCourseFeed`. The course-feed POST contract moves into a shared `src/lib/feeds.ts` `postCourseFeed(slug, text)` helper both islands call. Posting is real (enrolled student `canPost: true`). The embedded course card reuses `CourseEmbedCard` with a new `showCta?: boolean` prop (default true) passed `false` post-enrollment.

**Rationale:** The Figma frame diverges from MattCourseFeed, so a `mode` prop would bloat the shared Feed-tab component with milestone-only branching; a focused component + shared post helper keeps both lean, and extending `CourseEmbedCard` (default true) reuses the primitive with zero churn.

### NOTIF-PORT / MSG-PORT — `/notifications` + `/messages` to Root `@matt-inspired`
**Date:** 2026-06-06 (Conv 244)

Port both `/notifications` and `/messages` (currently `/old`-only; Matt `Sidebar.tsx` 404s on `/notifications`, omits `/messages`) to root `@matt-inspired` pages via the rebuild-new-leave-`/old` pattern. NOTIF-PORT first (1 island), MSG-PORT second (4 islands + Sidebar entry). Rejected: leaving the 404 honest as future RTMIG-4 items. Deferred to next conv (#46/#47).

**Rationale:** Matt is phasing out (Conv 239) so neither page gets a Matt frame — `@matt-inspired` is terminal; a live 404 in the canonical shell shouldn't persist. Messages is REST-polling, not Stream.io, de-risking the port.

### Admin-Role Redirect Lives in Middleware, Not the Layout (corrects Conv 083)
**Date:** 2026-06-08 (Conv 250)

The admin-role gate (non-admin on `/admin/*` → redirect `/`) moves to `src/middleware.ts` after the session check; the `AdminLayout.astro` role-redirect block + unused imports were removed. A `return Astro.redirect()` inside a layout component halts render into a blank 15-byte 200 instead of emitting a 302 (`[ADMIN-REDIRECT-BLANK]`) — only middleware/page frontmatter can return the HTTP-level Response. Corrects the Conv-083 layout-guard entry; `middleware.test.ts` gained an admin-gate suite.

**Rationale:** Route-level authorization that must redirect belongs where a Response can actually be returned. Middleware already classified `/admin/*` as a protected prefix, so the role gate is its natural sibling.

### RTMIG-TIER — Per-Cluster Dispositions (Cluster 0 Dashboard, Cluster 5 Hub+Spoke, Cluster 6 Delete, Clusters 2/3/4 → Studios)
**Date:** 2026-06-08 (Conv 251)

The 8-cluster route-migration backlog was dispositioned cluster-by-cluster. **Cluster 0 (Dashboard):** README "Ported (44): index/dashboard→`/`" conflated two pages — only `/old/index.astro` became `/`; `/old/dashboard.astro` (UnifiedDashboard) was never ported (→404). Decision A (port to root `/dashboard`) chosen then reopened by ROLE-STUDIOS; tally 44→43 / 52→53. **Cluster 6 (`/teachers`,`/creators`):** empty stubs superseded by `/members` → `git rm` both + repoint 8 links to `/members?roles=…` (no redirect, pre-prod rule). **Cluster 5 (`/@handle`,`/teacher`,`/creator`):** hub+spoke (not redundant), port all three + adopt `lib/ssr` loaders (teacher drop-in; creator adopt-with-reconciliation; predicate→ROLE-SEMANTICS). **Clusters 2/3/4 (`/creating`,`/teaching`,`/learning`):** NOT mechanically ported — fold hub-level differentiators into the dashboard, consolidate deep surfaces into Creator/Teacher Studios; `/old` stays live as reference.

**Rationale:** A summary dashboard holds hub-level differentiators but never deep functional surfaces (DASH-GAP); direct links honest sans redirect layer; adopting written-but-unwired loaders resolves silent drift. Spawned #21 ENTITY-ANCHOR, #22 SSR-LOADER-DEAD, #23 ROLE-SEMANTICS, #24 ROLE-STUDIOS (reopens cluster-0). RTMIG-TIER complete.

### ROLE-SEMANTICS — Two-Axis Role Model (Capability `canX` vs Identity `isX`; Access Gates Stay on Capability)
**Date:** 2026-06-08 (Conv 252)

Role checks split into two canonical axes (implementing the Session-319 Permission-vs-State distinction site-wide): capability `canX` (permission; gates ACTIONS/access — `if (!is_creator) → 403` belongs here) vs identity `isX` (behavioral; gates NAV/display/nudges). Canonical surfaces: behavioral `get isCreator/isTeacher/isStudent/isModerator` on `CurrentUser` (`current-user.ts`) + `isCreatorSubquery`/`isTeacherSubquery` SQL fragment builders on `roles.ts` (client-bundle-safe pure strings); 6 inline `/api/me` SQL sites (7 instances) deduped. Migration rule (RS-HYBRID-FLIP #24): split each hybrid site BY PURPOSE (access→`canX`, identity→`isX`), not a naive behavioral flip — the flip would 403 every approved-but-0-course creator. Security rule: never gate on `requireRole(['creator'])`/`['teacher']` until `getUserRoles()` is behavioral (today it's permission-based and `requireRole` only checks admin/moderator). Revoke edge accepted as default.

**Rationale:** `canX`="may this user do X?", `isX`="has this user done X?"; conflating them breaks new-creator (perm=1,courses=0) and revoked-creator (perm=0,courses>0) edges. A 3-parallel-Explore audit found `is_creator` had 3 competing definitions and the hybrid gates were access gates wrongly slated for a behavioral flip.

### ROLE-SEMANTICS Implementation — Hybrid Split, SQL Sweep, JWT-Stays-Permission (Tier-3)
**Date:** 2026-06-09 (Conv 253)

Executed the Conv-252 two-axis model. **RS-HYBRID-FLIP (#24):** 5 Tier-1 hybrid gates split by purpose (access→`canCreateCourses`, identity→`isCreator`) — NOT a naive behavioral flip, which would 403 approved-but-0-course creators; `ContextActionsPanel`'s `is_creator`/`is_teacher` fields were dead pass-throughs `getActionsForContext` never reads → deleted, not re-pointed. **RS-SQL-SWEEP (#25):** 40 inline identity-SQL instances (24 projections + 16 EXISTS filters) across 29 files routed onto `isCreatorSubquery`/`isTeacherSubquery` fragments; EXISTS filters reuse the existing `COUNT(*)>0` fragments (`AND (SELECT COUNT(*)>0 …)` ≡ `AND EXISTS(…)` in SQLite; `NOT EXISTS`→`NOT ${fragment}`) rather than adding EXISTS-form variants — one fragment form beats doubling the API for a short-circuit delta moot at 2-user scale. **Tier-3:** display/nav/label derivations (`roles.ts userRoles`/`describeRoles` + AppLayout Sidebar SQL) flipped behavioral (closes live granted-but-0-course Sidebar↔profile-header bug); `getUserRoles()` JWT deliberately stays permission-based (behavioral would go stale at the login snapshot for zero gating gain — `requireRole` gates only `['admin']`). New `tests/lib/roles-labels.test.ts` (7 tests). ROLE-SEMANTICS core CLOSED; tail = #26 RS-MOD-FRAG (isModeratorSubquery) + ports-coupled call-site migration. Gates: tsc / astro check 0·0·0 / lint / 6479/6479.

**Rationale:** Identity = behavioral, but only off the auth-snapshot boundary — the JWT freezes any baked value at login, so permission-in-JWT is correct by construction. Mechanical sweeps stayed safe via the surface-before-sweep discipline (narrow grep → SWAP/LEAVE/DEFER + 👉 → exact-string idempotent script with count assertion); a near-identical `has_active_courses` look-alike was excluded by the `IS NULL)`-paren delimiter.

### ROLE-SEMANTICS Tail — Community-Moderator Fragment + Sidebar Moderation Nav Signal (RS-MOD-FRAG / MOD-NAV)
**Date:** 2026-06-09 (Conv 254)

Closes the ROLE-SEMANTICS centralization. **RS-MOD-FRAG (#26):** community-mod identity centralized as `isCommunityModeratorSubquery(userRef)` on `roles.ts` (NOT a bare `isModeratorSubquery` as RESUME-STATE had named it) — the Moderator *role label* reads the `can_moderate_courses` permission while this fragment reads the `community_moderators` table (behavioral); a bare name beside `isCreator/isTeacher` would falsely read as THE canonical moderator check. Both `members/index` sites (an `EXISTS` filter + a `COUNT(*)>0` projection) collapse onto the one scalar `(SELECT COUNT(*) > 0 …)` form. **MOD-NAV (#24-new):** AppLayout computes `isModerator = can_moderate_courses OR isCommunityModeratorSubquery`; Sidebar shows the `/mod` item only when `isModerator && !isAdmin`, mirroring the `/mod` middleware gate so nav visibility matches access (admins stay on `/admin`). New `isModerator` field on `SidebarUser`. Gates: tsc 0 / lint / members 26/26.

**Rationale:** A one-definition-per-concept role module must name the column it queries, not the label it resembles. In SQLite boolean-filter position `EXISTS(SELECT 1 …)` and `(SELECT COUNT(*)>0 …)` reduce to the same 0/1, so one fragment serves both filter and projection — and ordering the fragment centralization ahead of the nav signal turned the would-be 3rd/4th inline copy into reuse.

### ROLE-STUDIOS Phase 2 — One Complete Workspace Per Conv, `/learning` First
**Date:** 2026-06-09 (Conv 255)

ROLE-STUDIOS Phase 2 (deconstruct `/dashboard` → 3 per-role workspaces) is ~16 surfaces across 3 workspaces — multi-conv scale. Decision: build one complete verified workspace per conv (rejected: all-hubs-with-stubbed-tabs, and a boundary-less N-conv sprint); `/learning` first as the pilot (thinnest at 2 surfaces, entry role) to front-load the reusable pattern (AppLayout shell + `[...tab]` SubNav + dedicated sidebar group + provenance + gates). The pilot follows the `/profile` scaffold precedent: Matt-shell + embed the existing student islands (StudentDashboard / StudentSessionsList), internal restyle deferred to [LEARN-ISLAND-RESTYLE] #20, no behavior dropped. `/creating` then `/teaching` follow in their own convs.

**Rationale:** Lands a whole verified unit on a clean boundary and makes the two heavy workspaces cheaper; the `/profile` precedent is established (not novel). Also resolved a plan-doc drift where the Phase-2 bullet (PLAN.md:213) + route-migration README cluster 4 had omitted the retained-thin `/learning` from Phase-0 resolution #1.

### Role-Workspace Sidebar IA — Dedicated "Workspaces" Group
**Date:** 2026-06-09 (Conv 255)

Role-workspace nav entries get a dedicated labeled "WORKSPACES" group in the expanded sidebar's top region (divider + uppercase label), between the top MainNav cluster and the bottom utility cluster — holding `/learning` now (ungated), with `/teaching`+`/creating` joining as gated siblings later. Rejected: top MainNav cluster, and bottom utility cluster (Admin/Moderation precedent). COLLAPSED_NAV rail gets a matching Learning icon.

**Rationale:** Novel sidebar IA that sets placement for all three workspaces; a dedicated group is most scalable for the trio and separates "do my role work" from discovery (top) and utility (bottom).

### ROLE-STUDIOS — Keep UnifiedDashboard Live for Client Comparison (Retirement Blocked)
**Date:** 2026-06-09 (Conv 256)

ROLE-STUDIOS Phase 2 performing workspaces `/creating` + `/teaching` built/verified (with the Conv-255 `/learning` pilot, Phase 2 performing workspaces COMPLETE); a thin TriageStrip island light-mounted on Home `/`. `UnifiedDashboard` / `Merged*` / `/old/dashboard.astro` NOT retired — client requested a side-by-side comparison of the old unified dashboard vs the new role workspaces. Phase 4 nudge layer design-first (`plan/role-studios/phase-4-nudges.md`, decisions A/B/C/D locked), build deferred to Conv 257.

**Rationale:** Client-sourced constraint; the comparison needs both surfaces live. Blocks Phase 3 retirement + Phase 5 orphan-tree removal until client signs off.

### HOME-FEED-MERGE: `/` Landing Feed via One Auth-Aware Endpoint (Server-Side Interleaving)
**Date:** 2026-06-10 (Conv 258)

Client directive: merge `/feed` content into Home (`/`); only the progression Nudge(s) + the feed remain of prior Home content. `/feed` stays a route but is auth-only (visitor → `/`) and removed from the Sidebar (route kept; mirrors Conv-250 `/feeds` removal). Home feed served by ONE auth-aware `/api/feeds/smart` with server-side interleaving (chosen over two endpoints + client merge); two internal aggregators (member gated-by-data + public marketing, NOT auth-gated). Design: 3 sources + gradient + S3-backfill; cursor Option A (mode-selected backbone, `(created_at, id)` tiebreaker, "caught up → discover" boundary, page-1 best-of-recent boost); visible "you're missing this" framing; quiet intent-preserving per-post CTAs + sticky sign-up bar; Home feed-leads + visitor thin-orienting-line. Updates the prior FeedsHub-on-`/`-landing direction for the Home feed surface.

**Rationale:** Server-side interleaving owns the source gradient so the client stays a dumb island; conversion via a concentrated loud ask over a credible quiet stream. Full design `plan/home-feed-merge/README.md`. A speculative client-meeting model (Discovery Rails / rail taxonomy / Commons → admin-only / promotion-in-MVP, `plan/home-feed-merge/client-meeting-2026-06-10-feeds.md`) is NOT adopted — gated on client sign-off on townhall retirement + promotion pricing.

### ROLE-STUDIOS — BLOCKED BY CLIENT (Deletion Path Gated on Old-vs-New Sign-Off)
**Date:** 2026-06-10 (Conv 258)

ROLE-STUDIOS marked ⛔ BLOCKED BY CLIENT. Phase-4 flywheel nudges verified complete (render-checks: S→T positive on a student/completed/non-teacher + course-card per-course gate; teacher+creator negative across all 4 surfaces; DOM-truth via D1-classification + dev-login switch + settle-then-read). The remaining deletion path — retire UnifiedDashboard, drop `AppNavbar.tsx:97` + AdminDashboardCard, Phase-5 orphan-tree removal (the `unified/` tree, ~9 of 13 files deletable since TriageStrip still imports PriorityHeader/NeedsAttention/types) — is gated on the client old-vs-new dashboard comparison sign-off (carried from Conv 256). Restyles / NUDGE-TC-V2 / deep-links / Home-rework remain available-but-parked. Supersedes the Conv-256 "Keep UnifiedDashboard Live for Client Comparison" status with the explicit block.

**Rationale:** Client-sourced constraint; the comparison needs both surfaces live, so the deletion cannot proceed. Stale-cache wrong-role nudge flash filed as [NUDGE-CACHE-FLASH] (fix: gate on a "classification fresh" signal); v2 T→C progression-gap deferred to [NUDGE-TC-V2].

### System Feed (formerly Townhall / The Commons) Is Admin-Only
**Date:** 2026-06-10 (Conv 259)

Feeds model adopted; the former "Townhall" feed / "The Commons" community becomes the unnamed System feed, the domain of Admins only. SYS-RENAME ran in two boundaries: C — mechanical `feed_type 'townhall'→'system'` enum rename (schema CHECKs, ~21 source files, dev seed, `getTownhall→getSystemFeed`, FeedActivityCard style keys, tests; D1 enum renamed while the Stream feed group stays `'townhall'`, the two being decoupled identifiers); then A — admin-only lockdown (`getFeeds` admin-only, member candidate query + badge counts exclude System via `is_system=0`, `/community/the-commons` 404s non-admins, `/communities` pin removed, `GET/POST /api/feeds/townhall` require admin +403, `autoJoinTheCommons` retired). Announcement data model + member/visitor fan-out deferred to [ADMIN-FEED-UI] #33 (interim: members get no System broadcast, acceptable pre-launch); cosmetic route/Stream/label rename split to [SYS-NAMING] #36.

**Rationale:** Each step small/verifiable; the announcement model belongs to ADMIN-FEED-UI; avoids a half-built announcement column. Admin-only-feed pattern: gate at `getFeeds` (isAdmin), member candidate query (`is_system=0`), badge query (`is_system=0`), community detail (404), feed API endpoints (`isUserAdmin`).

### Promotion Launch Gate = Shared Password (Admin-Managed via /admin/*), Payment Deferred
**Date:** 2026-06-10 (Conv 259)

Promotion is free to everyone at launch but gated behind a stored shared password, changeable only by Admins via an `/admin/*` interface; Stripe payment deferred. The `/admin/*` password UI folds into [ADMIN-FEED-UI] #33; policy/build tracked on [PROMOTE-PIPELINE] #32 with 4 OPEN clarifications (global-vs-per-level, per-promotion-vs-session, storage+hashing, which escalation levels gated) to resolve before building.

**Rationale:** Lightweight launch access-control (admins distribute/rotate the password to trusted promoters) without building payment first.

### Aggregated Home-Feed Post Is Display-Only (Teaser), Native Feeds Keep Interactivity
**Date:** 2026-06-10 (Conv 260)

The Matt-redesigned post in the **aggregated Home feed** ([POST-MATT]) is **display-only** social proof — reaction/comment pills are non-interactive; the user clicks through to the source. Interactivity stays on the legacy `FeedActivityCard` in the native course/community/system feeds (out of scope). Reused existing Conv-184 Matt primitives (`SocialPost`, `AnalyticCount`, `CourseAnchor`) — no new primitives — via a thin `FeedPost.tsx` adapter + one guarded `SocialPost.feedLink` prop. Two non-colliding click targets (embedded anchor → its promo CTA; "in {feed}" header link → home feed); no whole-card link. Matt's green CTA resolves to the existing Button `variant="course"` — no new green variant/token.

**Rationale:** Simpler AND better product — drives users into communities/courses (flywheel), sidesteps mixed-source reaction-API/optimistic/visitor problems, and matches what `SocialPost` (pure-render) + `FeedActivityCard`'s `showFeedLink` already pointed at; dissolves the interactivity-preservation port risk.

### DISCOVERY-RAILS: Precomputed Rails via Cron-Writer + KV-Reader (Compute-Fallback Endpoint)
**Date:** 2026-06-10 (Conv 261)

DISCOVERY-RAILS reintroduces a Cloudflare KV namespace (`DISCOVERY_CACHE`) — the first app-code KV use since removal Conv 095 (auth still uses JWT cookies). Rails (trending/popular/new × course/community) are precomputed daily by the **standalone cron Worker** (`workers/cron/`, already hosting `runSessionCleanup`) and written to KV; new scheduled jobs extend this Worker, not the main Astro Worker, because `@astrojs/cloudflare` v13 does not expose `workerEntryPoint` for a `scheduled()` export. `GET /api/discovery/rails` reads KV when the binding is present + blob version matches, **else computes on demand from D1** — a type-safe optional probe (`cfEnv.DISCOVERY_CACHE`) that needs no endpoint edit when the binding lands. Same KV id per env bound in both `wrangler.toml` (reader) and `workers/cron/wrangler.toml` (writer) so they share storage. Runtime tuning via `platform_stats` `discovery_%` dials (code-defaulted, no migration); trending = trailing-window enrollment/join velocity count, not a true prior-window delta (too noisy at Genesis scale).

**Rationale:** Compute-fallback keeps the feature functional before KV/cron exist; version guard self-invalidates a stale blob. Verified both paths live on staging (compute → kv after cron tick).

### Staging Is the Deploy Target; Production Is a Gated Launch Event
**Date:** 2026-06-10 (Conv 262)

For all feature work the deploy target is **staging**; production has never been deployed (MVP-GOLIVE ⏸️ DEFERRED — no prod secrets, prod D1 unmigrated). A "prod deploy" line in a feature task is mis-scoped → fold into MVP-GOLIVE; never run `deploy:prod`/`deploy:cron:prod` for features. This conv ran `deploy:cron:prod` literally and deployed `peerloop-cron` to prod from an unmerged dev branch; reverted (`wrangler delete --env production`), #30 re-scoped, prod cron folded into CRON-CLEANUP.

**Rationale:** Deploying from a dev branch with no prod secrets against an unmigrated prod D1 is not the controlled MVP-GOLIVE landing; `confirm-prod.js` is a human checkpoint — don't auto-answer it. Banked as memory `feedback_staging_is_deploy_target_prod_gated`.

### PROMOTE-PIPELINE Password Gate: One Global Secret, Per-Promotion, bcrypt in `platform_stats`, Every Step
**Date:** 2026-06-10 (Conv 262)

Post-promotion (Course→Community→System) is gated by **one global password**, entered **per-promotion**, stored as a **bcrypt hash in `platform_stats`** (`promotion_gate_password_hash`), gating **every escalation step**. `canPromote` is distinct from `canPost` — it lets a teacher/creator escalate INTO a feed they couldn't post to (incl. admin-only System); the password makes that bypass safe pre-payment.

**Rationale:** Without payment the password is the sole anti-spam control; one global secret matches "distribute to trusted promoters"; per-promotion avoids session state; reuse existing bcrypt + `platform_stats` — no new infra.

### PROMOTE-PIPELINE Lineage: Dedicated `post_promotions` Event Table + Role Matrix
**Date:** 2026-06-10 (Conv 262)

Promotion lineage stored in a **dedicated `post_promotions` event table** (not columns-only) + `feed_activities.promoted_from_activity_id`; promoter eligibility is a **role matrix** (admin/creator/certified-teacher), not admin-only; promotion creates a NEW activity referencing the source (not a move). Course→community link traverses progression (`courses.progression_id → progressions.community_id`, nullable ⇒ not promotable). Feeds dual-keyed: D1 by slug, Stream by id — `resolvePromotionTarget` returns both.

**Rationale:** Payment, the Promoted lane, and audit need an event record; the role matrix is the real end-state. The `src/lib/promotion/` module mirrors `src/lib/discovery-rails/`.

### PROMOTE-PIPELINE Delivery = Reference + Teaser Lane (D1 Only, No Stream Write)
**Date:** 2026-06-11 (Conv 263)

Promotion delivers cross-boundary via the pull model: a promoted post lives only in its origin Stream feed; a `post_promotions` D1 row references it (`source_activity_id`), and every higher-feed appearance is assembled at read time (lane query → enrich-by-id → display-only teaser). Stream is never written — no copy (engagement-split) and no `to`-target (SYS-RENAME made System admin-only + retired `autoJoinTheCommons`). Rewrites the shipped copy-based `promote.ts` (Conv 262) to reference-only; drops `post_promotions.target_activity_id`; adds `canPromote` to feed GET. Announcements reuse the pattern.

**Rationale:** Only the pull pattern (the one SmartFeed already uses) delivers cross-boundary uniformly at every level; cross-boundary is exactly what feed-level access control blocks. Full design in `plan/home-feed-merge/README.md`.

### Inbound Promoted-To Visitor = Posture A (Read-Only Source Feeds)
**Date:** 2026-06-11 (Conv 263)

A logged-in non-member reaching a source feed via a promotion may view but not react/comment/post unless they join/enroll (posture A, over B lightweight-engage and C view-gate). Closes a latent hole: reaction/comment endpoints check auth only (401), not membership. Unified behind one `canParticipate` predicate + "Join to participate" CTA + 403 tests, owned by `[VISITOR-GATING]` #29 (PRIORITIZED).

**Rationale:** Cleanest conversion funnel; consistent with browse-vs-act. Promotion makes the existing auth-only gap load-bearing.

### Feed participation gate: one `canParticipate` predicate; System feed = admin-only
**Date:** 2026-06-11 (Conv 264)

Posture-A (Conv 263) built out. All six mutating feed endpoints (`POST`/`DELETE` on `{community,course,townhall}×{reactions,comments}`) call a single `canParticipate` predicate (`src/lib/feed-participation.ts`) after input validation, before the Stream call (403/404 on deny); `GET` stays open. Rules: community→member; course→creator/admin/teacher/enrolled; system (townhall)→admin-only (matches SYS-RENAME Conv-259 lockdown; members get System content via Announcements, deferred). Source handlers `course/[slug].ts`/`community/[slug].ts` refactored onto the shared `checkCourseParticipation`/`checkCommunityParticipation`, making the predicate the single source of truth. Follow-up `[SYS-GET-GATE]` #37 (townhall comments GET still auth-only).

**Rationale:** Reactions/comments are participation, gate identically to posting; extracting the rule collapses duplicate source-handler logic into one predicate; admin-only System matches its existing lockdown.

### PROMOTE-PIPELINE: Reference Model (Model ①) supersedes copy; drop orphaned lineage columns
**Date:** 2026-06-11 (Conv 265)

Post-promotion converted from copy (Model ③) to **reference (Model ①)**: a promotion records one `post_promotions` event row referencing the canonical `source_activity_id` — no target activity row, no Stream `addActivity` copy. **Supersedes** the Conv-262 lineage decision. `post_promotions.target_activity_id` and `feed_activities.promoted_from_activity_id` (+ both indexes + `indexFeedActivity`'s param) dropped — neither has a writer under Model ①. Added a server `canPromote` flag on community + course feed GETs = role-allowed AND `resolvePromotionTarget !== null` AND not the System feed (gates the future per-post PromoteNudge, avoids 403-after-click). Lane *rendering* (Home/community teasers + admin System view) folds into `[HOME-FEED-MERGE]` #28 + `[ADMIN-FEED-UI]` #30 rather than a soon-replaced server injection.

**Rationale:** Reference is the durable lineage shape — copying duplicated content and orphaned the lineage column the moment no target row was created. Dropping the orphaned column + param in the same conv avoids dead schema/code shipping together. Lane injection has no durable server-only home that isn't redundant with the existing `/api/feeds/promoted` endpoint or sitting in #28's `getSmartFeed` rewrite path (mirrors the Conv-264 Join-CTA fold precedent).

### HOME-FEED-MERGE Marketing Feed: Rails-Backed Cards + Tier-5 Commons Anchor Retired
**Date:** 2026-06-11 (Conv 266)

The marketing (public/visitor) aggregator `getMarketingCandidates` (`src/lib/smart-feed/marketing.ts`) consumes an injected `DiscoveryRailsBlob` (Conv 261) for its suggestion cards — only the sample-post query is net-new; the 6 trending/popular/new × course/community rails are a pure mapping (no duplicate aggregation; `[RECO-UNIFY]` #31 removes that redundancy anyway). The Conv-258 always-full cascade's tier-5 "The Commons anchor" is dropped (tiers 1–4 only); `getMarketingCandidates` excludes `system` feeds entirely and no anchor sub-task is created.

**Rationale:** Dependency-injecting the rails blob keeps the builder unit-testable and reuses the exact card set. Tier-5's premise ("everyone's auto-joined the Commons") was deleted by SYS-RENAME (Conv 259) — `autoJoinTheCommons` retired + System feed made admin-only; tiers 1–4 already draw globally from all public content so always-full holds, and pulling Commons posts into a logged-out feed would leak admin-only content. Phase 3 must thread the real blob (KV-read + compute fallback); member-facing System content reaches users via Announcements (`[ADMIN-FEED-UI]` #30).

### HOME-FEED-MERGE: Two-Tier Rails Read Extracted to a Shared Lib Module
**Date:** 2026-06-11 (Conv 267)

Phase 3 extracts the KV-read + compute-fallback that fetches the `DiscoveryRailsBlob` into a shared `src/lib/discovery-rails/serve.ts` (`loadDiscoveryRailsBlob(db, kv?)` + `getDiscoveryRailsKV()`), consumed by both `/api/discovery/rails` (refactored onto it, behavior-identical) and the un-gated `/api/feeds/smart` — chosen over duplicating the two-tier logic in the smart endpoint, KV passed as a param to keep the read policy unit-testable. Phase 3 also un-gates `/api/feeds/smart` (drops 401 → `userId = session?.userId ?? null`, degrade-to-no-cards on blob failure) with auth-varying cache headers (visitor `public,max-age=60`+`Vary:Cookie` / authed `private,no-store`).

**Rationale:** One implementation, no drift between the two rails consumers; durable per §Solution Quality. `rails.ts` inline logic deleted (~40 lines), `X-Discovery-Source` preserved.

### HOME-FEED-MERGE Phase 6: Server-Built Auth-Branched CTA URLs; Destination-Level Signup Intent
**Date:** 2026-06-11 (Conv 268)

Home-feed discovery CTAs (sample-post `DiscoveryCard` + `SuggestionCard`, prop-less dumb renderers under the prop-less `SmartFeed` island) branch on viewer auth **server-side** via a shared `buildDiscoveryCtaUrl(feedType, feedId, via, viewerAuthenticated)` (`src/lib/smart-feed/cta.ts`): authed → direct entity link; visitor → `/signup?redirect=<encoded entity>` (`?via=` preserved inside). `getSmartFeed` computes `viewerAuthenticated = Boolean(userId)`, threading it into `cardToItem` + `enrichCandidates`/`toEnrichedCandidate` (default `false` = fail-safe). Signup is **destination-level** (land on the entity post-signup) — action-level `&action=join|enroll` auto-perform rejected.

**Rationale:** Server-payload branching keeps the cards dumb, keeps the visitor `ctaUrl` cache-stable, and sidesteps the [NUDGE-CACHE-FLASH] first-paint-staleness class (the orchestrator already has `userId`). Destination-level matches the design's "return them to X" phrasing AND the established `EnrollButton` `?redirect=` pattern; action-level is hostile (course enroll → Stripe checkout, can't drop a fresh signup onto a payment page). The `?redirect=` round-trip already existed (`signup.astro` → `AutoOpenAuthModal` → `handleAuthSuccess`); only the feed CTAs needed wiring. One helper for both ctaUrl sites = anti-drift; no client edit. Completes HOME-FEED-MERGE (all 7 phases).

### PROMOTE-PIPELINE Step 3: Promote Endpoint Speaks Stream Activity ID (Not `feed_activities.id`)
**Date:** 2026-06-11 (Conv 269)

The `POST /api/feeds/promote` body is `{ streamActivityId, password }`; it resolves the canonical row via `WHERE stream_activity_id = ?` (UNIQUE-indexed), not by the `feed_activities.id` FK the Conv-262 endpoint keyed on. Internal FK / `recordPromotion` / lane stay on `feed_activities.id` — only the client-facing contract speaks Stream id. Rejected: read path attaching `feedActivityId` per activity (endpoint unchanged).

**Rationale:** The client holds only the Stream activity id everywhere (reactions/comments already POST `activityId: activity.id`); resolving by Stream id matches the system-wide client identity model and scales free to future promote surfaces (home feed, nudge) — option B would repeat the read-path join per surface. The UNIQUE `idx_feed_activities_stream` also hardens the 1:1 lookup. Endpoint body renamed; dead "no Stream activity" guard dropped; 8 new endpoint tests.

### PROMOTE-PIPELINE: Promotion Is Idempotent (UNIQUE Index + Pre-Gate Early-Return)
**Date:** 2026-06-11 (Conv 269)

`post_promotions` gains `UNIQUE(source_activity_id, to_feed_type, to_feed_id)` (`idx_post_promotions_unique`); the endpoint pre-checks for an existing promotion and early-returns it (`{ alreadyPromoted: true }`, 200) before the password gate. A double-click / two promoters now produce one row.

**Rationale:** Under Model ① a promotion is one D1 row (no Stream copy), so idempotency is pure-data — UNIQUE index + pre-insert SELECT — else the Promoted lane surfaces the post twice. Pre-check runs before the gate so a re-clicker isn't re-challenged for a no-op. (Copy-Model ③ would mint a second Stream activity with its own engagement counter — un-dedupable.)

### Shared `PromoteButton` Across Both Live Feed Renderers; `SocialPost` Gains a Passive `actions` Slot
**Date:** 2026-06-11 (Conv 269)

One shared `src/components/feed/PromoteButton.tsx` (password modal + idempotent POST + "Promoted" flip), themed per surface via `className`, used by both live renderers: `FeedActivityCard` (community, refactored onto it) and `MattCourseFeed`→`SocialPost` (course). The display-only Matt `SocialPost` gained an optional `actions?: ReactNode` footer slot it merely renders — interactivity lives in the child; callers omitting `actions` render byte-identically. Rejected: duplicating modal+fetch in each.

**Rationale:** DRY — password/idempotency logic has one home, can't drift. The passive-slot pattern lets a display-only primitive host an interactive child without breaking its "no interactivity" contract. The second live renderer was discovered only via a DOM-truth browser check (course feed mounts `MattCourseFeed`, not legacy `CourseFeed`/`FeedActivityCard`; green unit tests don't reveal which island a route mounts).

### Canonical Feed Seed: `scripts/seed-feeds.mjs` Wired into `db:setup:local:dev`
**Date:** 2026-06-12 (Conv 271)

`scripts/seed-feeds.mjs` is the **single canonical feed seed** — it writes real activities to Stream and dual-writes the returned IDs into D1 (real Stream UUIDs, real reactions). The 28 dangling SQL `feed_activities` rows in `migrations-dev/0001_seed_dev.sql` are removed (breadcrumb left), and `db:setup:local:dev` now ends with `db:seed:feeds:local`. The script is creds-resilient (no-Stream-creds machines skip gracefully). Also fixed: the script wrote `feed_type='townhall'` failing the schema CHECK (`system`/`community`/`course`) — Stream group addressing (`'townhall'`) is now decoupled from D1 addressing (`feed_type='system'`).

**Rationale:** A pure-SQL seed can only store a dangling pointer — Stream activity IDs are minted by Stream at creation, so the seed must call the service, not fabricate IDs. Making the optional/untested script canonical surfaced the dormant `feed_type` CHECK failure that "worked in isolation" only because nobody exercised it.

### Discovery-Rail Source Tables Freshened via the Seed's Relative-Date Mechanism (PART C)
**Date:** 2026-06-12 (Conv 272)

The discovery rails compute `new` (created <30d) and `trending` (velocity <7d) signals, so source rows with fixed historical seed dates never populate them — 4/6 rails were empty in dev. Fixed by extending the seed's existing "TIMESTAMP FRESHNESS" section with a new PART C: DISCOVERY RAILS FRESHNESS that freshens the rail-source tables (courses / communities / progressions / community_resources / enrollments / community_members) with id-targeted, inversion-safe UPDATEs. Freshened dates store ISO `T`-format (`strftime('%Y-%m-%dT%H:%M:%fZ',…)`) to match the JS `.toISOString()` cutoff the compute compares against.

**Rationale:** Reuses the established, durable freshness mechanism rather than hardcoding new dates or leaving rails cold-start-empty. Inversion-safety: freshen rows with no conflicting dependents, or freshen the whole dependent sub-tree in step, else you invert a timeline.

### Promotion Expiry Is Computed From a Dial, Not a Stored `expires_at` Column (FEED-U3a)
**Date:** 2026-06-12 (Conv 274)

Promotion expiry is computed from the `promo_active_duration_days` platform_stats dial (lane filters on a `created_at` window) rather than a `post_promotions.expires_at` column. Dials seeded: `promo_active_duration_days`=14, `promo_retention_days`=60. `loadPromotionConfig` uses `LIKE 'promo\_%' ESCAPE '\'` (literal underscore — unescaped `'promo_%'` would match `promotion_gate_password_hash` and parseInt the bcrypt hash to NaN). `purgeExpiredPromotions` (shared fn, strftime ISO, non-positive-retention no-op guard) runs as a cron retention purge on `promo_retention_days`; `promoted.ts` defaults its window to the active-duration dial. Add `expires_at` only when paid variable durations are real.

**Rationale:** No schema change, no backfill; matches the lane's existing `created_at`-window behavior; the schema comment defers columns to avoid half-built artifacts.

### Entity-Promo (FEED-U3) Surfaces via the Marketing/Discovery Path, Not the Promoted Lane; A2 Composer Authors Into the Entity's Own Public Feed
**Date:** 2026-06-12 (Conv 274)

The entity-promo home-feed render path uses the marketing sample-post query (any public-feed post), NOT the Promoted lane — `getSmartFeed` never calls `getPromotedActivities` and `GET /api/feeds/promoted` has no UI consumer (the lane-on-feed-pages path is separate and unbuilt). An entity-promo is a Stream post with `postKind:'entity_promo'`+`promoEntityType`+`promoEntityId`, kept as `kind='sample-post'` (a new `kind='entity-promo'` would be silently dropped by the orchestrator's `e.kind === 'sample-post'` injectable filter) and discriminated at render via a `promoContext` field, with its anchor resolved from `promoEntityType:promoEntityId` (reusing `fetchDiscoveryAnchors`). The A2 composer (`createEntityPromo`) authors into the entity's own public feed (from=to=entity feed) and records a `post_promotions` row — chosen over authoring into the chain target + building the unbuilt lane consumer.

**Rationale:** Cross-boundary reach to non-members is already achieved by home discovery of a public-feed post; lowest-risk, coheres with the shipped backbone, no unbuilt-lane dependency. `post_promotions` row is for U3c moderation + a future lane, not home-feed visibility.

### Net-New Admin Pages Marked `@matt-inspired`, Not `@stand-in`
**Date:** 2026-06-12 (Conv 276)

Net-new admin pages (no `/old/admin` legacy origin, no Figma source frame) carry the `@matt-inspired` provenance marker rather than `@stand-in`. Established by `/admin/promotion-settings`: although every other admin page is `@stand-in` (rehosted from `/old/admin`), a page built fresh from existing admin primitives has no legacy origin, so the `@stand-in` "rehosted legacy" clause would be false.

**Rationale:** Honest provenance — `@stand-in` is the transient legacy-rehost marker; a page with neither a `/old` ancestor nor a Figma frame is `@matt-inspired` by definition. Sets the precedent for future net-new admin pages.

### System-Promotion Moderation: System-Only Scope, Admin-Gated, No `moderation_actions` Log (FEED-U3c)
**Date:** 2026-06-12 (Conv 276)

The System-promotion moderation list/remove is scoped to `to_feed_type='system'` only (scope-guarded delete), gated with `requireRole(['admin'])` (not `requireModerationAccess`), and writes no `moderation_actions` audit row on removal. Threat = non-admin content reaching the admin-only platform-wide System feed; System promotions are a platform concern; `moderation_actions.flag_id` is NOT NULL→content_flags so a promotion take-down isn't a flag resolution. Audit-log enhancement is a possible follow-up.

**Rationale:** Admin-only platform concern with a scope guard preventing collateral deletion of community/course promotions; reusing the flag-based moderation log would require fabricating a flag.

### Announcement Fan-Out = A+B (Read-Time Feed Pin + Optional Per-User Notify), D1-Only (FEED-U3c④)
**Date:** 2026-06-12 (Conv 277)

Platform-wide announcements (admin→all-members broadcast) deliver via A+B: every announcement renders in the home smart feed at read time (read-time fan-out, zero write amplification, mirrors promotion delivery model ①), and an optional `notify` flag additionally fans out a per-user 'system' notification (chunked over `getAllActiveUserIds`) for time-sensitive ones (e.g. maintenance). D1-only storage — text lives entirely in the `announcements` table; no Stream activity, no per-read Stream fetch. Pin contract = "pinned, first-page-only, never in the cursor," wired in the smart-feed orchestrator (parallel fetch + widened `FeedItem` union + prepend). Rejected: pure A (urgent message not guaranteed seen), pure B (buries feed-native posts), C/dedicated read path (most net-new code), Stream-backed (would only hold text D1 stores directly). Substrate parallels: `announcements`↔`post_promotions`, `announcement_dismissals`↔`smart_feed_dismissals`, dials↔`platform_stats`, `purgeExpiredAnnouncements`↔`purgeExpiredPromotions`.

**Rationale:** An announcement is structurally "a post broadcast to everyone," so reusing the settled promotion read-time substrate is low-risk and review-light; the 4 example announcements showed ①③④ are feed-native while only maintenance wants the bell.

### Announcements Stored D1-Only with Optional `active_until` Column (FEED-U3c④)
**Date:** 2026-06-12 (Conv 277)

Announcements are stored D1-only in a new `announcements` table + `announcement_dismissals` (idempotent per-user dismiss, mirrors `smart_feed_dismissals`). Unlike a promotion (dial-only expiry), an announcement carries an optional admin-set `active_until TEXT` column: NULL → falls back to an `announcement_active_duration_days` dial. A maintenance window has a precise real-world end the dial can't model, so this is a contained divergence from the promotion "no `expires_at`" stance. All active-window comparisons stay string-vs-string on canonical ISO `strftime` format (SQLite Datetime Rule); the dial path is inverted to `created_at > now + (-N days)` so the stored timestamp is never re-parsed; retention purge guards against purging a still-active (future `active_until`) row.

**Rationale:** A one-way broadcast needs no native reactions/comments and references no pre-existing post, so a Stream activity would only hold text D1 stores directly. The `active_until` divergence is the one case where a stored end-time beats a dial, kept optional so the common case still uses the dial.

### PromoteNudge Engagement Gate = Configurable `promo_nudge_min_engagement` Dial (FEED-U3d)
**Date:** 2026-06-13 (Conv 278)

The workspace PromoteNudge (which prompts a creator/teacher to run an EntityPromo) self-gates on entity traction via a new `promo_nudge_min_engagement` `platform_stats` dial (default 3), admin-editable in the existing `/admin/promotion-settings` page alongside the active-duration + retention dials. The gate is on *nudging*, not *promoting* — the `EntityPromoComposer` it reveals still lists every promotable entity; the floor only governs the unprompted nudge so we never push someone to spend a promo on a zero-traction entity. Engagement signal = `courses.student_count` / `communities.member_count`. `GET /api/feeds/promotable-entities` was extended with a per-entity `engagementCount` + a top-level `minEngagement`, and the nudge renders nothing unless the viewer owns ≥1 entity clearing the floor. 0 = always nudge. Rejected: capability-only (nudges empty entities), hardcoded fixed threshold (no admin control). Mounted on `/creating` + `/teaching` overview, mirroring the self-gating ProgressionNudge.

**Rationale:** Follows the established promotion-dial pattern (lifecycle dials already live in `platform_stats`, edited on the same admin page), so admin tunability is near-free and consistent; gating the *prompt* (not the action) keeps the manual composer fully open while preventing low-value nudges.

### U3d Per-Post Nudge Deferred — Post-Escalation Affordance Already Exists (FEED-U3d)
**Date:** 2026-06-13 (Conv 278)

U3d's plan named two surfaces (workspace card + "per-post (server `canPromote`)"). A Premise-Check Gate trace found the literal per-post affordance **already shipped** in PROMOTE-PIPELINE (Conv 262): `PromoteButton` → `POST /api/feeds/promote`, gated by the server `canPromote` flag, renders on every eligible entity-feed post (`FeedActivityCard`, `MattCourseFeed`). That is *post-escalation* (push an existing post up the chain), distinct from the *entity-promotion* model the workspace nudge drives. The genuinely-new per-post work — an *attention-drawing* nudge (ProgressionNudge-style callout pitching promotion on high-engagement posts, in the entity-promo model) — was deferred (user-chosen) to a scoped follow-up (`[U3D-POST]`) pending a tighter spec on placement, copy, and one-time-vs-persistent behavior. Shipping the workspace card this conv keeps U3d completable + verifiable; the mechanical per-post capability is unaffected (the existing button stays).

**Rationale:** Building a second per-post promote control on top of the existing always-on `PromoteButton` would be redundant clutter; a real "nudge" (attention-drawing prompt ≠ quiet action button) deserves its own spec rather than being conflated with the pre-existing escalation control.

### Per-Post Promote "Hot" Highlight: Dedicated Dial + Stateless In-Card Elevation (FEED-U3d [U3D-POST])
**Date:** 2026-06-14 (Conv 279)

Settled the deferred [U3D-POST] per-post promote nudge as two coupled decisions. (1) A 4th `promo_%` dial `promo_post_min_engagement` (default 3, `stat-promo-004`) governs the "hot" threshold — dedicated, **not** reused from the entity dial `promo_nudge_min_engagement`, since post interactions (reactions + comments) and entity members are different units. (2) The highlight is **stateless** (computed every render from live Stream `reaction_counts`, no localStorage) and rendered **in-card** by swapping the existing `PromoteButton` to an accented HOT_TRIGGER state owned *inside* the component, so the two render paths can't drift. New pure `lib/promotion/engagement.ts` (`postEngagement`/`isPromoteHot`). Only renders where `canPromote` is set (course + community feeds). Completes the FEED-U3 (home-feed-merge) block.

**Rationale:** Stateless sidesteps the [NUDGE-CACHE-FLASH] localStorage-staleness bug class; in-card elevation reuses one component, auto-covers every eligible feed, and centralizes styling so it can't drift; a dedicated dial keeps reaction-counts and member-counts from being conflated into one ambiguous integer. The dial pattern is a cheap, established extension (config + seed + admin endpoint/UI).

### SYS-RENAME: System Feed Renamed the-commons/townhall → `system` (Pre-Production Value Rename)
**Date:** 2026-06-14 (Conv 280)

The admin-only platform feed (formerly "The Commons" / "Town Hall") is renamed to **System** at the value level: slug `the-commons`→`system`, community id `comm-the-commons`→`comm-system`, name `The Commons`→`System`, route `/api/feeds/townhall`→`/api/feeds/system`, component `TownHallFeed`→`SystemFeed`, with canonical constants in new `src/lib/system-feed.ts`. The data model already keyed off `type:'system'`, so legacy names survived only as identifiers/comments; substantive+structural renamed now, ~26 cosmetic-residue files deferred to `[SYS-RENAME-COSMETIC]`. The one functional `townhall` value retained is the Stream feed group (`SYSTEM_STREAM_GROUP='townhall'`), because **Stream feed groups are dashboard-declared, not write-creatable** — renaming the group `townhall`→`system` 500'd at runtime (`FeedConfigException` "system feed group does not exist") since `db:seed` cannot provision an unregistered group. ~50 files changed + re-seed; 5 gates green (test 6713); browser-verified (`/community/system` "System", admin POST 200, non-admin 403, old route 404).

**Rationale:** Pre-production (no users, no real data, full seed control) is the one cheap window to rename values at the root before the slug/Stream group calcify post-launch; constant-izing-but-keeping-values leaves a permanent naming scar. The Stream group stays `townhall` (internal infra, never user-shown) behind the documented constant — zero user-facing benefit against a coordinated-dashboard-change cost.

### COMM-TAG-FILTER Deferred to Post-Production (Channels Model Retired as Port-Artifact)
**Date:** 2026-06-14 (Conv 280)

COMM-TAG-FILTER is deferred to post-production, superseding the Conv-238 build-ready LOCK. The channels design (`community_channels` table, general/announcements/help) stays on file as a "revisit-if-volume" note (`plan/comm-tag-filter/README.md`) but is not built for MVP. Channels were a port-artifact of the legacy Commons' decorative `?tag=` chips; their value scales with feed volume + modal variety, and after SYS-RENAME the system feed is admin-only/low-volume, so the member-town-hall premise that justified them is gone.

**Rationale:** No user/admin need at genesis-cohort scale (60–80 students); build the table/composer/filtering only if/when post-launch feed volume materializes.

### SYS-RENAME-COSMETIC: Cosmetic Rename = "Rename Branding, Preserve Live Values"
**Date:** 2026-06-14 (Conv 282)

Completed the deferred `[SYS-RENAME-COSMETIC]` cosmetic pass under a **"rename the *branding*, preserve the *value*"** rule. Comments/log strings → "system feed", file-local `townhall*` vars → `systemFeed*` (5 feed/discover components), duplicate `SYSTEM_FEED_ID` consolidated into canonical `SYSTEM_FEED_SLUG`. **Deliberate keepers** — every `townhall` that is a live Stream identifier: `SYSTEM_STREAM_GROUP='townhall'` (`system-feed.ts`), `seed-feeds.mjs` `feedGroup:'townhall'`, `tests/lib/promotion.test.ts` `streamGroup:'townhall'`, `townhall:main` Stream addresses in docs (Stream groups are dashboard-declared, not write-creatable — pointing code at a renamed group 500s with `FeedConfigException`). Excluded the cross-file `isTheCommons` prop rename (deferred). 18 code files + 13 reference docs corrected, incl. 3 factual auto-join-on-signup errors removed (ROLES/DB-API/google-oauth + the `0002_seed_core.sql` header).

**Rationale:** Three layers wear the word `townhall` (D1 `feed_type` enum — already renamed Conv 280; the live Stream feed group; the UI label); only the branding layer is safe to rename. Lowest-risk warm-up that still corrects genuine factual drift. Editing comments in applied D1 migrations is NOT risky here — wrangler tracks migrations by filename (no content hash), comments execute nothing, and `migrations/` is plain `.sql` with no drizzle journal.

### Feed Feature Seeds Split by FK Dependency: Announcements → SQL, Promotions → seed-feeds.mjs
**Date:** 2026-06-14 (Conv 283)

To seed the two D1-only feed features that had zero seed coverage, each lands where its FK dependencies are already satisfied. **Announcements** (FK → `users`) appended to `migrations-dev/0001_seed_dev.sql` (the SQL seed runs first in `db:setup:local:dev`). **post_promotions** (FK `source_activity_id → feed_activities`) seeded inside `scripts/seed-feeds.mjs` after Step 4 — `feed_activities` rows are written at runtime there, so a static SQL row would FK-fail; the FK is derived from `activity.index` via an inline `promoteTo` tag (reorder-proof). Rejected: new `0004_*.sql` (new npm wiring + still FK-fails); both-in-seed-feeds (announcements are pure-D1).

**Rationale:** Principled by data dependency — co-locate each seed with its already-satisfied prerequisites; reaches the default `db:setup:local:dev` chain (0001 + seed-feeds only) without new wiring.

### ListingShell Is a Page-Level Primitive, Not an AppLayout Slot (LIST-1COL / CD-039)
**Date:** 2026-06-14 (Conv 284)

The single-column "Twitter-style" listings shell — a centered ~640px content column plus a responsive right panel — lives as a page-level primitive `src/components/layout/ListingShell.astro` that listing pages opt into inside `AppLayout`'s default slot, **not** as a new `aside-right` slot baked into `AppLayout`. The shell's mobile contract is **reflow, not hide**: a filled (filter) panel reflows to the top of the column below `lg` (`order-1 lg:order-2`); only an empty placeholder panel is desktop-only (`hidden lg:block`).

**Rationale:** Lowest blast radius — `AppLayout` and ~80 other pages stay untouched, and it mirrors the established "pages compose primitives in the default slot" pattern. The reflow contract keeps filters reachable on mobile (an earlier `hidden lg:block` trapped them in a `display:none` aside).

### Monolithic-Filter Surfaces Split into Filter + List Islands via Window Events (LIST-1COL)
**Date:** 2026-06-14 (Conv 284)

To relocate a surface's filters into the `ListingShell` right panel, a monolithic single-island directory (filters as internal island state, e.g. `/members`) is split into a filters island + a list island coordinating via global `window` events (`members:filterchange` / `members:clearfilters`). Both islands seed initial state from the **same** source (`?roles=` + defaults) so the first fetch matches with no mount race, and the filter island skips its mount-time dispatch (the list does its own initial fetch) to avoid a double fetch.

**Rationale:** Filter and list islands can be placed independently in the DOM because their coordination is position-independent global events. Seeding both from one source and suppressing the filter island's initial dispatch are the two race-avoidance rules.

### ListingShell Right-Panel Branch Selection: Placeholder vs Filter-Rail (LIST-1COL / CD-039 Phase 4)
**Date:** 2026-06-14 (Conv 285)

Which `ListingShell` right-panel branch a listing page uses is decided by whether it has a *standalone filter island*. A page with a relocatable filter rail (`/communities`, `/members`) moves that rail into the `right-panel` slot. A page with **no** standalone filter island (`/feeds`) uses the **empty light-blue placeholder** branch and keeps any role/segment tabs **inline** in the column. Rejected: an event-bus split of data-coupled role-tabs-with-counts just to populate the panel.

**Rationale:** Role tabs are navigation coupled to counts, not relocatable filters — splitting them out would be large and fragile for no design payoff. Matches the `/communities` precedent (role tabs never moved; only standalone filter islands relocate). Refines the Conv-284 ListingShell entry.

### Select Primitive Gains a `clearable` Mode (Filter Dropdowns Return to "All")
**Date:** 2026-06-16 (Conv 292)

The `Select` form primitive gains a `clearable` prop: the placeholder empty option renders `disabled={!clearable}`, making it re-selectable so a value-selected dropdown can return to "All". Courses Level/Length/Topic opt in; Sort stays required. Rejected: per-filter explicit `{value:'', label:'All X'}` option per call site.

**Rationale:** One primitive change fixes all current and future filter-selects; the prior `<option value="" disabled>` placeholder trapped any value-selected dropdown.

### Dismissible UI Always Reappears on Reload in Dev/Staging (`ephemeral-dismiss.ts`)
**Date:** 2026-06-16 (Conv 292)

New `src/lib/ephemeral-dismiss.ts`: `readDismissed(key)` returns false (always-show) in dev (`import.meta.env.DEV`), localhost, or `*staging*` hostname; production persists. Wired into OnboardingNudgeBanner + RecommendedCourses + RecommendedCommunities. Rejected: manual localStorage clearing; build-time `PUBLIC_` env var (deferred).

**Rationale:** Dismissed-and-hidden UI is unaccounted for while building pages, and the client tests on staging; self-contained, no config wiring, covers the known staging URL. Caveat: hostname-substring detection; upgrade path = `PUBLIC_` env var.

### Classify a Hard-Hex Before Swapping: Primitive-Signature vs Convention vs Stray
**Date:** 2026-06-17 (Conv 295)

During a route sweep, classify a hard-coded hex before swapping it for a token: primitive-signature (matches a documented Matt primitive's Default — e.g. `#f6f6f6`+`rgba(88,77,244,.14)`=`AnalyticCount`; `#1f2937`=shared no-thumbnail fallback) → adopt the primitive; convention/recurring (≥3 sites) → tokenize app-wide once; true stray → per-route swap. Run remaining-site grep + registry read during assessment, not after editing. Established by reverting 4 route-2 (`/course/[slug]/[...tab]`) near-miss swaps.

**Rationale:** Classification-precedes-swapping prevents quietly diverging intentional Matt values; cross-cutting values are fixed app-wide. Early-port sweep precedent.

### CC-Owned Colour Foundation: Matt-Anchored Scales + Warning/Error Hues
**Date:** 2026-06-17 (Conv 295)

Derive tint/shade ramps from Matt's gray/green/blue anchor values (Matt provides anchors, not 50–950 ramps) + add warning(amber)/error(red, seeded from retracted carmine-red); author a style-guide sweep policy. Amends Conv-181 "tokenize only Matt-formalized variables" for blank categories per Conv-289 CC-ownership. [PALETTE-FDN] #31; RG-COURSES routes 3–5 parked.

**Rationale:** Adopts Matt's actual hues (brand alignment, minor pixel shift) and fills the only real gaps; makes future Tailwind-default findings mechanical instead of ad-hoc.

### PALETTE-FDN Landed: Provenance-Scoped Sweep + Status Roles Predetermined
**Date:** 2026-06-17 (Conv 296)

Executed the Conv-295 colour-foundation charter. Two refinements: (1) scope = provenance-scoped sweep of `@matt-source`/`@matt-inspired` surfaces only (3,708 utils / 198 files), NOT a 60–115-file app-wide swap — legacy/`@stand-in` ride their own RT-MIG sweeps; `/` + `/courses` re-aligned. (2) Status roles error/warning/success are PREDETERMINED + Matt-harmonized, separating "what the palette DEFINES" from "what we MIGRATE" — warning minted, sweep only quantifies/tunes. Neutrals ~6 steps, accents ≤3; blue split brand(purple-blue)/info(americana); error tuned off carmine `#FF0038`→`#E11D3F`. FeedActivityCard recolor deferred to ReactionButton extraction.

**Rationale:** Bounds the foundation and keeps route-touching in the RT-MIG sphere; defining status roles up front avoids blocking every status-colour finding on a usage hit.

### `/precheckout` Removed — Unknown Course Tabs Soft-Redirect to Course Root (Not 404)
**Date:** 2026-06-17 (Conv 297)

Delete `course/[slug]/precheckout.astro` (Matt subnavbar-experiment remnant; `/benefits` is now home off the Enroll subnav item), repoint CourseHeader non-enrolled CTA → `/benefits`, leave the `[...tab].astro` catch-all untouched so unknown course-tab segments 302→`/course/[slug]` rather than 404. RG-COURSES dropped 5→4 routes.

**Rationale:** The course is real, only the tab is invalid — a soft URL-rewrite landing matches the requirement and is consistent for all unknown course-tab segments; a hard 404 would need a special-case for worse UX. Distinct from route-honesty (404s for unconverted routes) — this normalizes a malformed sub-segment of an existing converted route.

### `--Alert-Default` Tuned to the PALETTE-FDN Error Hue, App-Wide
**Date:** 2026-06-17 (Conv 297)

Repoint `--Alert-Default: var(--carmine-red)` → `var(--error-300)` (`#FF0038` → `#E11D3F`) in `tokens-semantic.css`, unifying the app's two divergent error reds. Surfaced retrofitting ExpectationsForm onto Matt form primitives (FormField/Select/Input use `--Alert-Default`). 23 alert utils across 14 files now resolve to the tuned `#E11D3F`; DOM-verified.

**Rationale:** Completes the Conv-296 carmine tune; the semantic→primitive reference is the correct cascade direction. `--carmine-red` retained but unused.

### Home Right-Side "Coming Soon" Panel Is Bespoke in `index.astro`, Not the Shared Shell (HOME-RPANEL)
**Date:** 2026-06-18 (Conv 298)

Home (`/`) gets a bespoke two-column layout in `index.astro` — feed anchored left (`lg:w-[640px] lg:shrink-0`) + a light-blue flex-grow `<aside>` "coming soon" panel on the **right** (`hidden lg:block lg:flex-1`) — rather than reusing `ListingShell`'s placeholder. Panel growth caps at AppLayout's 1248px content-card max-width (accepted). Rejected: enabling the ListingShell panel as-is (renders LEFT per Q2/CD-039), and flipping the global panel side to RIGHT for all listing pages.

**Rationale:** The intent (decorative whitespace-absorber: fixed content + growing panel) is the inverse of ListingShell's flex model (fixed utility panel + growing list), and the shared shell renders LEFT. Diverging Home only keeps the 4 filter pages on the Conv-289 LEFT decision and keeps the shared shell single-purpose.

### Mint a 14px Paragraph Type Token (`text-body-default-prose`) — TYPO-FDN
**Date:** 2026-06-18 (Conv 298)

The two-regime leading model (dense lh-1.0 for 12–14px body/captions/headers; prose lh-1.5 for 16–20px paragraphs) is documented intent, not a bug. Matt's scale has no 14px *paragraph* token, so mint `text-body-default-prose` (14px/lh-1.5/ls-0, CC-marked) as a CC-ownership extension. Rejected: upsizing all paragraphs to Matt's 16px `text-body-medium` (client-visible), and changing `text-body-default`'s lh (breaks ~67 legit caption/label uses).

**Rationale:** Preserves the app's 14px density, fixes leading, leaves Matt's caption regime intact; the SmartFeed font drift is fixed by a written role-discipline (§09-typography), not a token-values change.

### Unified Feed-Card Spec + No-Arbitrary-px-for-Spacing Rule — TYPO-FDN
**Date:** 2026-06-18 (Conv 298)

Canonical card contract (matt-design-system §9.4a): `p-16` + `rounded-12` + per-slot type tokens (title `text-body-medium-bold`, body `text-body-default-prose`, label/meta `text-body-small(-medium)`, rhythm `mt-4`/`mt-8`/`gap-12`). Margin/padding/gap use scale classes only — no arbitrary `[Npx]`; off-scale values snap or are flagged as sanctioned optical exceptions. The TYPO-FDN ledger checks each card component against the spec.

**Rationale:** One contract all card components conform to; arbitrary-px spacing is what let cards of several origins drift. Off-scale px become explicit per-component snap-or-flag decisions.

### `@matt-source` Conformance Policy — Hybrid (Tokenize-Where-Equivalent, Keep Token-Less)
**Date:** 2026-06-18 (Conv 300)

Style-guide conformance reaches INTO `@matt-source` primitives — not exempt. Tokenize raw `text-[Npx]`/`font-*`/`leading-*` where a role token is exactly equivalent (zero visual change); keep genuinely token-less values (letter-spacing, emoji size, `#000`) as recorded exceptions. Shared `@matt-source` primitives (`SocialPost`/`EntityLink`/`EntityPill`/`IconLabelChip`) get ledger rows + migrate once, then verify per-route on each sweep. Small line-height corrections toward §09 count as conformance. Rejected: exempting `@matt-source`; full tokenize.

**Rationale:** A wrapper's "Type ☑" can be hollow — visible text is styled in the sub-primitives, so conformance must walk to where it lives. Governs the rest of the RTMIG-4 route sweep.

### Mint a 16/500 Body-Label Type Token (`text-body-medium-medium`) — RG-PROFILE (Conv 302)
**Date:** 2026-06-19 (Conv 302)

Settings form-control labels are 16px/500 (`font-medium`, no size); §09 has 16/400 and 16/600 but no 16/500, and `--h4` (16/500) is header-regime (lh 1.0) so semantically wrong for body labels. Mint `--body-medium-medium` (16px / 500 / lh-1.5 / ls-0.022em, body regime, CC-marked) in `tokens-typography.css` + register `text-body-medium-medium` in the Tailwind bridge. Rejected: `text-body-medium-bold` (16/600) and `text-body-default-medium` (14/500) — both change rendered weight/size.

**Rationale:** Only zero-visual-change option; faithful to the legacy 16/500; the gap recurs across all 4 settings islands. Follows the CC-mint precedent (`--body-default-prose` Conv 298; `--body-default-bold`/`--body-small-bold` Conv 300). Documented in §09 (§9.2b).

### Route-Sweep Spacing Convention: Bare Matt Numerics + Off-Set Normalized — RG-PROFILE (Conv 303)
**Date:** 2026-06-19 (Conv 303)

Route-sweep spacing conformance rewrites every numeric spacing util as its intended-px **bare Matt numeric** (`gap-6`/24px → `gap-24`, `gap-1`/4px → `gap-4`), not arbitrary `[Npx]`, and **normalizes off-set** numerics onto the nearest bridged collapse step {4,8,12,16,20,24,32,40,48,64}. Sub-scale token-less values (`py-0.5`=2px, `px-1.5`=6px) kept verbatim. StripeConnectSettings (shipped earlier with arbitrary `[Npx]` + collapse-only) retro-fixed to match. Rejected: arbitrary `[Npx]` + collapse-only; bare numerics, collapse-only.

**Rationale:** Consistency across /profile and future route-sweep work; refines the Conv-298 no-arbitrary-px card rule into the operative rewrite convention for the RTMIG-4 sweep. Bare numerics read as the Matt scale; off-set normalization removes legacy Tailwind-scale classes entirely.

### Spacing-Axis Snaps Off-Scale `@matt-source` Spacing, Even Figma-Exact Values (§170 Carve-Out) — CDETAIL-CONF (Conv 305)
**Date:** 2026-06-19 (Conv 305)

Carve-out to the Conv-300 `@matt-source` Conformance Policy, **spacing axis only**: off-scale `@matt-source` margin/padding/gap **snaps to the nearest 4px scale step** (round-half-up on ties) — NOT kept as a sanctioned exception — even when Figma confirms the off-scale value is Matt's exact value. Canonical case: CourseHeader's `px-[60px]`/`gap-[10px]`/`gap-[19px]` were Figma-verified (`517:8935`) as Matt's literal values, and the user still chose snap. The bridge only defines `{4,8,12,16,20,24,32,40,48,64}`px, so an off-scale arbitrary carries no token and would leak forever. Ties up (`gap-[10px]`→`gap-12`, `gap-[6px]`→`gap-8`); `px-[60px]`→`px-64`, `gap-[19px]`→`gap-20`, `gap-x-[30px]`→`gap-x-32`. SPACING-ONLY — Colour keeps its exception model. Rejected: one-off treatment of CourseHeader's snap.

**Rationale:** `[SPACING-4PX-SWEEP]` targets a strict scale; off-scale arbitraries carry no bridge token and leak forever. Exposed TeachersTab's stale Spacing ☑ (fixed same conv). Governs all remaining route-sweep / `[SPACING-4PX-SWEEP]` spacing work. Memory: `project_spacing_snap_over_matt_exception`.

### Button Gains a CC-Owned `danger` Variant Beyond Matt's Color-Collection (Conv 306)
**Date:** 2026-06-19 (Conv 306)

`Button.tsx` gains a `danger` variant (`text-white`, `bg-error-300 hover:bg-error-500`, `border-error-300`) — explicitly CC-owned, extending Button beyond Matt's Color-collection variant set. Dedups hand-rolled inline destructive buttons (`bg-error-300 text-white` in SecuritySettings/DeleteAccountModal) onto the primitive using the existing error ramp; additive (no regression). Rejected: leaving destructive buttons hand-rolled.

**Rationale:** Sets the precedent that CC may extend the Button variant model with documented, token-backed variants when Matt's enum lacks a needed role.

### Adopt the Shared `Modal` by Conforming It First; Fixes Latent Backdrop-Click Bug (Conv 306)
**Date:** 2026-06-19 (Conv 306)

DeleteAccountModal (conformant, bespoke) was the Modal adoption target, but `Modal`/`ConfirmModal`/`FormModal` were all legacy-styled (`dark:`/`secondary-*`/`text-lg`/`p-4`). Decision: conform `Modal.tsx` first (neutral tokens, scale spacing, fix the backdrop bug), then wrap DeleteAccountModal in it (red title in children, Cancel→`outlined`, Delete→`danger`). Rejected: adopting Modal as-is (regresses the conformant consumer); leaving DeleteAccountModal bespoke. Latent bug: the click handler was on the OUTER container (`e.target===e.currentTarget` guard) but a full-bleed `bg-black/50` overlay CHILD sat on top, so clicking the visible overlay never fired `closeOnBackdropClick` (default true) — handler moved onto the overlay div.

**Rationale:** Conforming the shared primitive fixes it for all 6 Modal consumers + realizes the dead `closeOnBackdropClick`; adopting a legacy primitive would have regressed a conformant consumer. Functional change — backdrop now closes as intended for all consumers.

### Status-Colour Ramps (warning/success/error) Already Exist — Status Banners Are a Token Swap, Not a Foundation Decision (Conv 306)
**Date:** 2026-06-19 (Conv 306)

Correction to earlier notes claiming "no Matt warning/success ramp" (which had framed PALETTE status as a foundation decision). `tokens-semantic.css`/`tokens-primitives.css` define `--success-100/300/500` (Matt greens), `--error-100/300/500` (Matt tint + tuned), and `--warning-100/300/500` (#FEF3E2/#F59E0B/#B45309, minted amber, structurally parallel), all exposed as `bg-/text-/border-{success,warning,error}-*` via the bridge. Raw `text-/bg-{green,red,amber,yellow}-*` STATUS banners are therefore a mechanical token swap. Applied: ProfileSettings + StripeConnect status banners/triad/checkmarks/errors tokenized.

**Rationale:** No missing-token decision was needed; the gap was a stale ledger note, not a real foundation gap. Caveat: ~1565 raw status-hue utilities exist app-wide but most are legitimate role-tints — only genuine status banners swap.

### StarRating Primitive — One Widget, Interactive + ReadOnly Fractional Modes; Rating Gold Unified on `--star` (Conv 308)
**Date:** 2026-06-20 (Conv 308)

Extracted `ui/StarRating.tsx` as a single `@matt-inspired` primitive replacing 3 hand-rolled ★-button widgets that coloured stars three ways (`text-[#f5b800]` / `text-amber-400` / `text-star`). Two modes: interactive 5-star input (integer pick + internal hover-preview + `onHoverChange`) and a `readOnly` fractional-fill display (half/partial stars via a width-clipped filled `★` overlaid on an empty `★`), plus `showValue` and sizes sm/md/lg. On-colour = `--star` (`text-star`), off = `text-border-default`. Adopted in SessionCompletedView (main+sub), CourseReviewModal (local `StarRow` removed, hover "Excellent" label preserved via `onHoverChange`), SessionBooking `/book` (readOnly avg ×2). SessionBooking's teacher-average spots upgraded from compact `★ 4.5` to 5-star fractional because they sit in the teacher-selection-by-comparison flow. Registered in `matt-inspired-registry`. Rejected: deferring to a cross-cutting task; keeping `/book` compact.

**Rationale:** Rule-of-Three met — one extraction collapses three colourings onto one token; the cost is a cheap `/book` back-pointer re-glance. Retired the stale "no token exists" comment in SessionCompletedView (the `--star` token has existed since Conv 297).

### FeedPost Reclassified as a Non-Primitive Adapter — Registry Entry ⟺ Stampable DOM Root (Conv 308)
**Date:** 2026-06-20 (Conv 308)

`FeedPost` returns `<SocialPost>` directly with no DOM root, so it stays unregistered + unstamped; SocialPost owns the provenance. Establishes the prov:sweep invariant: a registry entry requires a stampable DOM element, because the sweep is bidirectional — a file that stamps `data-prov-name` must be registered, AND a registered file must carry a matching `data-prov` stamp. Enrolling FeedPost flipped it into 2 UNSTAMPED errors; the fix is to drop its `Provenance: UNMARKED` note (detector greps literal `/Provenance:\s*UNMARKED/`) rather than register it. Same sweep enrolled 5 stampable-but-unregistered `@matt-inspired` primitives (CommunityAnchor, DiscoveryCard, StickySignupBar, MembersFilters, _FeedPostDemo); prov:sweep now exits 0. Rejected: registering FeedPost.

**Rationale:** A pass-through adapter has no DOM identity to stamp and can't collide with a Matt frame — the `UNMARKED` keyword was mis-applied. Adapters/wrappers reclassify at source; only components that render their own element enroll.

### SegmentedPills Becomes the Canonical Filter-Pill Primitive — `variant` Enum Bundles Each Look, Active Fill Fixed Blue (Conv 309)
**Date:** 2026-06-20 (Conv 309)

`SegmentedPills` is parameterized with a `variant: 'pills' | 'segmented' | 'tabs'` enum (each value bundles that site's layout/shape/inactive treatment) plus an optional `className`, and the active fill is **fixed to blue** (`--Primary-Default` = americana-blue). Collapses 5 hand-rolled filter rows onto one component: NotificationCenter (`pills`), `messages/matt/ConversationList` (`segmented`, full-width bordered track, `mx-12 mt-12` via className), SmartFeed/Home (`tabs`). Prior consumer CoursesCatalog shifts black→blue (the one accepted look change). Chosen over strict-adopt and converge-matching-subset-only; a `variant` enum is preferred over orthogonal boolean props because only specific combos are ever used (follows `Button`/`Select`). MembersFilters is a latent 4th adopter for when `/members` is swept.

**Rationale:** All live filter rows render blue active but the old primitive rendered near-black — token indirection (`--Text-Primary` → `--Primary-Default` = blue, while `--Text-Default` = gray-base) had hidden the mismatch from the class-string sensor. Parameterizing preserves each swept route's verified appearance + the `/messages` segmented affordance while deduping the copies; blue matches 4 of 5 live sites + brand.

### Radius Scale Lives in `@theme` (Bare `rounded-N` Utilities) — RG-COMMS (Conv 311)
**Date:** 2026-06-20 (Conv 311)

Moved the numeric border-radius scale (`--radius-{2,4,6,8,12,16,24}`) from `tokens-primitives.css :root` into the `@theme` block of `tokens-tailwind-bridge.css` (literal px; breadcrumb left). Tailwind v4 only generates `rounded-<key>` utilities from `--radius-<key>` declared in `@theme`; the `:root` scale had 0 `var(--radius-N)` references and was dead, so every bare `rounded-8/12/16` app-wide computed 0px (incl. `ui/Card.astro:40`). Omitted `--radius-full`/`--radius-0` (v4 built-ins). Mirrors the Conv-174 spacing-bridge mechanism.

**Rationale:** Idiomatic Tailwind v4 single-source; dead primitives (0 var refs) meant no migration risk. All bare `rounded-N` resolve app-wide; RG-COMMS fully clean.

### Button Gains CC-Owned `warning` + `suspend` Variants — Moderation Severity Ladder (Conv 313)
**Date:** 2026-06-20 (Conv 313)

`Button.tsx` gains two more CC-owned variants beside `danger` (Conv 306): `warning` (amber/warning ramp) and `suspend` (a documented **honest-orphan** orange — no Matt role scale). Minted during RG-MOD Tranche B to conform the 5 inline `<button>`s in `ModeratorQueue` onto the primitive (Dismiss→`default`, Remove/Retry→`danger`, Warn→`warning`, Suspend→`suspend`), footer now pill-shaped (`<Button property1="Small">`). Completes a reusable moderation severity ladder: neutral→warning→suspend→danger; the `ButtonVariant` union + 3 record maps gain both keys. Chosen over inline-restyling all 5 as square and Button-for-destructive-only (which mixes pill+square in one footer).

**Rationale:** Extends the Conv-306 CC-owned-variant precedent to dedup hand-rolled coloured moderation buttons and give the severity ladder reusable, token-backed primitive variants. User selected Button-primitive adoption explicitly.

### RG-PUBPROF — Flatten Public-Profile Deep Views to the Hub's White-Card Look (No Coloured Hero) (Conv 316)
**Date:** 2026-06-21 (Conv 316)

During the RG-PUBPROF sweep (cluster-5 hub+spoke: `/@[handle]` hub, `/teacher/[handle]` + `/creator/[handle]` spokes), the deep views were flattened to match the hub's flat white-card aesthetic instead of keeping their rich coloured gradient hero (`/teacher`'s white-on-blue text + translucent buttons; `/creator`'s `from-primary-900`). The deep-view header becomes a white UserCard-style header with white-card body sections; `/teacher` was restyled this conv (header restructure, not just token swaps) and the same recipe now applies to `/creator`. All deep-view-specific function is preserved (Book CTA, stats, availability, own-profile actions, 2-col layout). Chosen over conforming tokens *within* the coloured hero (which has no clean on-dark→Matt-token mapping).

**Rationale:** Unifies the profile surfaces (hub `/@handle` and spokes look the same) and removes the entire on-dark-token problem class (light-tint text→neutral, translucent buttons→standard `<Button>` variants on white); consistent with CC owning page consistency post-Matt-phase-out. Creator-purple / Teacher-blue role hues kept as honest-orphans (/mod precedent). Browser-verify caught a hydration-mismatch date bug (`formatDate` no-TZ → server "Dec 2023" vs client "Jan 2024"), fixed with `timeZone:'UTC'`.

### ROLE-STUDIOS — Individual Dashboards Approved; Composite Not Ported; Comparison Freeze Lifted (Conv 317)
**Date:** 2026-06-21 (Conv 317)

The client approved the individual role dashboards (`/learning`, `/teaching`, `/creating`) as the go-forward surfaces; the composite `/dashboard` (`UnifiedDashboard`) will **NOT** be ported and stays in `/old/*` as a deprecated reference. The Conv-256 old-vs-new appearance-freeze is therefore **lifted** — shared dashboard components (`EnrollmentCard` / `CertificatesSection` / `MyFeeds`) are now free to conform to Matt; doing so incidentally restyles the deprecated `/old/dashboard`, which is acceptable. Rejected: forking the 3 shared comps purely to pixel-freeze a deprecated page (not worth the permanent duplication). Supersedes the Conv-256 "Keep UnifiedDashboard Live for Client Comparison (Retirement Blocked)" entry (composite still kept, only the freeze lifts).

**Rationale:** The freeze's purpose — let the client choose between the unified composite and the per-role workspaces — is fulfilled. Unblocks the whole RG-WORKSPACES route group (`/learning` first, 5-component conformance planned). Recorded in memory `project_role_studios_deconstruct_nudges` + `plan/route-migration/README.md`.

### Legacy Sky (`primary-*`) Splits Two Ways by Role; Decorative Tints → Brand-Purple (Conv 318)
**Date:** 2026-06-22 (Conv 318)

Legacy `primary-*` (sky) conflated **two** distinct Peerloop blues, and conformance must split every occurrence by **role**: interactive → **americana-blue** (`<Button>` for buttons, `text-primary-default` for inline text links), decorative/tint/fill/badge → **brand-purple** (`brand-100` tint-bg / `brand-300` solid-fill #584DF4 / `brand-500` text+icon). The decorative case has no americana background scale, so brand is the only tokenized fill home — effectively forcing tinted decorative fills (progress bars, In-Progress badges, module circles, Smart-Feed pins) to render purple #584DF4. Established conforming the /learning (RG-WORKSPACES) dashboard components; carries forward to /teaching + /creating (same components). The closest sibling surface (/profile) had already done exactly this. Rejected: keeping sky as honest-orphan blue; splitting status-bearing sky blue while moving the rest. Paired sparse-scale re-grade (neutral {50,100,300,500,700,900}, brand {100,300,500}): `secondary-{200,300,400}`→`neutral-300`, `600`→`neutral-500`, `700`→`neutral-700`, `900`→`neutral-900`; spacing via uniform `X-N`→`X-(N×4)` literal-Matt transform.

**Rationale:** Keeps the conformed accent language consistent across the workspace routes; brand is the only tokenized background fill, so the decorative path is effectively forced. Status/cert/feed tints stay honest-orphans. DOM-truth (`getComputedStyle` resolving `bg-brand-100`→#ECEBFE) confirms the token is wired — static gates pass even on a non-existent token (computes transparent), so browser-verify is the one check that catches the resolution bug.

### Conformance Status-Token Rule: Map Where a Matt Token Exists, Keep Honest-Orphan Where None Does (Conv 319)
**Date:** 2026-06-22 (Conv 319)

Refines the Conv-318 sky-split rule: "decorative-sky→brand" applies only to genuinely *decorative* (non-semantic) tints. Where a hue carries **semantic status**, the disposition is: map to a Matt semantic token if one exists (red→`error-*`, amber→`warning-*`); keep an honest-orphan Tailwind hue if Matt has no matching token (sky=available, green=saved/positive, the categorical stat-accent quartet, the transaction-status palette). Per occurrence: (1) interactive → americana (`<Button>`/`text-primary-default`); (2) decorative non-semantic → brand; (3) semantic + Matt token → map; (4) semantic + no Matt token → honest-orphan Tailwind hue. A kept blue must migrate off the deprecated `primary-*` ramp to Tailwind `sky-*` (identical hex — `--color-primary-N` == Tailwind `sky-N`) to clear the `primary-[0-9]` leak grep without recoloring. Decided this conv while conforming AvailabilityCalendar (sky=available across the whole calendar) and EarningsDetail (rich transaction-status palette) under /teaching RG-WORKSPACES; applying brand blindly would have recolored a whole calendar purple and homogenized a money-status palette. Rejected: brand-purple per the literal decorative rule.

**Rationale:** Blue=available and the transaction palette are semantic colour systems, not decoration; Matt has no "available"/"success"/categorical tokens, so honest-orphan Tailwind hues are correct (same principle as green-saved). Recoloring would destroy coherent semantic colour. Extends the Conv-318 entry in `05-ui-ux-components.md` (latest-wins, folded in).
