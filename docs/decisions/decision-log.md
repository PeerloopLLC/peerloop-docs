> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## Decision Log

For historical decisions and the full rationale behind each choice, see the session files in `docs/sessions/YYYY-MM/`.

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
