> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## Decision Log

For historical decisions and the full rationale behind each choice, see the session files in `docs/sessions/YYYY-MM/`.

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
