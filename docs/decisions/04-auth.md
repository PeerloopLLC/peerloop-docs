> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 4. Authentication & Authorization

### Per-User Private File Downloads Use `Cache-Control: private, no-store` (Conv 345)
**Date:** 2026-06-28 (Conv 345)

The authed homework-submission download route (`GET /api/homework/submissions/[id]/download`, access = owner-student / course-creator / certified-teacher / admin) sets `Cache-Control: private, no-store`, NOT the `private, max-age=3600` copied from the resources download route. `max-age` on a per-user authorization-gated resource is a shared-browser data-exposure risk — a later user on the same browser is served a cached 200 of an earlier user's private file without a fresh auth check (reproduced live during DOM-verification). Resources tolerate `max-age` because they are enrollment-gated (same bytes for every enrolled user); per-user-private submissions do not. Generalizes: any per-user private file download uses `no-store` so the authorization check runs on every request.

**Rationale:** `no-store` forces re-authorization on every fetch and prevents cross-user browser-cache reuse of a private file. Locked with a test assertion.

**See:** `src/pages/api/homework/submissions/[id]/download.ts`; Conv 345.

### System-Promotion Moderation: System-Only Scope, Admin-Gated, No `moderation_actions` Log (FEED-U3c)
**Date:** 2026-06-12 (Conv 276)

The System-promotion moderation list/remove (`listSystemPromotions` / `removeSystemPromotion`, `GET\|POST /api/admin/moderation/promotions`) is: (a) **scoped to `to_feed_type='system'` only** — `removeSystemPromotion` is scope-guarded so the admin path can never delete a community/course promotion; (b) gated with **`requireRole(['admin'])`**, not the moderator-scoped `requireModerationAccess`; (c) writes **no `moderation_actions` audit row** on removal.

**Rationale:** (a) the threat is non-admin content (a community creator / certified teacher with the password) reaching the admin-only platform-wide System feed; (b) System promotions are a platform concern and the `/admin` page is admin-gated by middleware; (c) `moderation_actions.flag_id` is `NOT NULL → content_flags` — a promotion take-down isn't a flag resolution, so logging there would require fabricating a flag. An audit-log enhancement is a possible follow-up.

**See:** `src/lib/promotion/moderation.ts`, `src/pages/api/admin/moderation/promotions/`; Conv 276.

### PROMOTE-PIPELINE Password Gate: One Global Secret, Per-Promotion, bcrypt in `platform_stats`, Every Step
**Date:** 2026-06-10 (Conv 262)

Post-promotion (Course→Community→System escalation) is gated by a shared password with this policy: **one global password** (not per-feed/per-role), entered **per-promotion** (no session state), stored as a **bcrypt hash in `platform_stats`** (key `promotion_gate_password_hash`), gating **every escalation step**. `canPromote` is deliberately distinct from `canPost` — it lets a teacher/creator escalate INTO a feed they couldn't normally post to (notably the admin-only System feed); the password is what makes that bypass safe pre-payment.

**Rationale:** Without payment the password is the sole anti-spam control, so gate every step; one global secret matches "distribute to trusted promoters"; per-promotion avoids session-state complexity; reuse existing bcrypt (`src/lib/auth/password.ts`) + `platform_stats` settings pattern — no new infra.

**See:** `src/lib/promotion/gate.ts`, `src/pages/api/admin/promotion-password.ts`.

### Inbound Promoted-To Visitor = Posture A (Read-Only Source Feeds)
**Date:** 2026-06-11 (Conv 263)

A logged-in non-member who reaches a source feed via a promotion may **view** it but may not react/comment/post unless they join/enroll — reacting and commenting count as participation and are gated identically to posting (posture A, chosen over B = lightweight-engage and C = full member-gate-even-to-view). This closes a latent hole: `POST /api/feeds/{course|community}/[slug]/{reactions,comments}` currently check only `Authentication required` (401), NOT membership — so a logged-in non-member can react/comment with just an activityId. The new-post path is already gated (`checkPostingRights`); reactions/comments were left open. The fix unifies all six endpoints behind one `canParticipate` predicate + a "Join to participate" CTA + 403 tests, owned by `[VISITOR-GATING]` #29 (PRIORITIZED).

**Rationale:** Cleanest conversion funnel; consistent with the browse-vs-act model. Promotion makes the existing gap load-bearing.

### Feed participation gate: one `canParticipate` predicate; System feed = admin-only
**Date:** 2026-06-11 (Conv 264)

Posture-A (Conv 263) built out. All six mutating feed endpoints (`POST`/`DELETE` on `{community,course,townhall}×{reactions,comments}`) now call a single `canParticipate` predicate (`src/lib/feed-participation.ts`) after input validation, before the Stream call — denying with 403/404; `GET` (read) stays open. The three rules: **community** → member; **course** → creator/admin/teacher/enrolled; **system (townhall)** → **admin-only**, consistent with the source townhall feed's SYS-RENAME (Conv 259) lockdown (members never reach the System feed directly — they receive its content via Announcements, deferred). The source handlers (`course/[slug].ts`, `community/[slug].ts`) were refactored to consume the shared `checkCourseParticipation`/`checkCommunityParticipation` rather than their prior inline copies, making the predicate the single source of truth.

**Rationale:** Reactions/comments are participation and must gate identically to posting; extracting the rule (rather than reinventing it) collapses the duplicate logic the source handlers already carried into one predicate. Admin-only for System matches its existing feed-level lockdown.

**See:** `src/lib/feed-participation.ts`. Follow-up `[SYS-GET-GATE]` #37 — townhall comments GET is currently auth-only though the System feed is admin-only to view.

### COMMUNITY-RESOURCES upload auth: creator + platform admin only
**Date:** 2026-04-14 (Conv 117)

Upload of community resources (`POST /api/me/communities/[slug]/resources`) restricted to the community's creator (`communities.creator_id === userId`) OR platform admin (`users.is_admin = 1`). Moderators, teachers, and regular members cannot upload in MVP.

**Rationale:** Resources are reference material defining the community. Moderators moderate content; they don't author it. Starting strict is reversible; starting loose is hard to tighten.

### Auth permission helpers: 3 narrow shapes, not one composite
**Date:** 2026-04-15 (Conv 123)

`src/lib/auth/session.ts` exports three narrow helpers — `isUserAdmin(db, userId)` (boolean), `getUserPermissionFlags(db, userId)` (`{is_admin, can_moderate_courses}`), `getAllAdminUserIds(db)` (array). Each matches exactly one SQL query shape. Call sites whose queries are a *superset* (extra fields, extra filters — e.g., moderator endpoints selecting `id, name, handle, is_admin WHERE deleted_at IS NULL`) stay inline rather than being forced through a helper.

**Rationale:** "Same SQL shape → same helper" is the right discriminator; "same caller intent" is a red herring. Forcing superset queries through a boolean helper would split one round-trip into two and regress ergonomics. One composite `getUserPermissions()` would overfetch and obscure what each site actually needs.

**Consequences:** 9 inline `SELECT is_admin ...` sites migrated (download, expectations, feeds, me/communities resources, messaging ×2, creators/apply, checkout/create-session). 3 moderator sites intentionally kept inline. `@lib/auth` barrel exports all three. `[RA-JWT]` (embed `isAdmin` in JWT) filed as a future security+product decision — keeping per-request lookup for now due to revocation latency concerns.

### Do NOT embed `isAdmin` in JWT claims — keep per-request DB lookup
**Date:** 2026-04-15 (Conv 125)

`[RA-JWT]` decision: the `isUserAdmin(db, userId)` helper pattern stays. `isAdmin` is not added to `PeerloopTokenPayload`. Admin-gated request paths continue to issue one DB round-trip per call; the 6 current gate sites (plus the one discovered during this brief at `src/lib/ssr/loaders/communities.ts:471-476`, filed as `[RA-SSR-LOADER]`) trade ~5-20ms per request for instant admin-revocation.

**Rationale (load-bearing — the audit report framed this wrong):**
1. **The refresh-token-as-auth fallback widens the revocation window to 7 days, not 15 minutes.** `getSession()` (`src/lib/auth/session.ts:88-94`) treats a valid refresh token as a valid auth credential when the access token is missing or expired. Any claim embedded in the refresh token is therefore trusted for its full 7-day TTL. The naive "access-token TTL bounds staleness" argument is incorrect under the current session architecture.
2. **Revocation for security-sensitive gates must be instant.** Resource download, feed moderation, and SSR admin gates each carry data-exfiltration or content-integrity risk if a compromised admin token survives revocation. The DEPLOYMENT block will add payout-related admin gates, raising the severity bar further.
3. **Performance savings are negligible at MVP + 10x scale.** 6 gate sites × ~10ms D1 round-trip × rare-admin traffic = microseconds of aggregate latency. Not a bottleneck worth trading revocation latency against.
4. **The helper layer already provides the DRY win.** Conv 123 `[RA-ADM]` moved 9 sites to `isUserAdmin`/`getUserPermissionFlags`/`getAllAdminUserIds`. The ergonomic benefit of embedding (1 line per site) is already captured.

**Options considered:**
- **Naive embed in both tokens** — rejected: 7-day staleness window incompatible with security-sensitive gates
- **Access-token-only embed + access-token rotation on refresh** — rejected for MVP: ~2-3 hr engineering for microsecond-scale latency savings; the TODO at `session.ts:91` (`// could refresh access token here`) would need to be implemented and tested
- **Revocation blacklist in KV/D1** (audit's C.1-c) — deferred: adds the cache hit it was trying to eliminate; re-evaluate only if per-request DB load becomes a measured problem
- **Keep status quo** ← **chosen**

**Revisit trigger:** Re-evaluate if *both* of these become true:
- P95 latency on admin-gated endpoints measurably regresses (>100ms attributable to the `isUserAdmin` hop)
- We can design an embedding that preserves instant revocation (e.g., access-token-only + refresh-token rotation, with per-gate DB fallback for security-critical operations like payouts)

**See:** `src/lib/auth/session.ts` (helpers), `src/lib/auth/jwt.ts` (current payload shape), Conv 125 RESUME-STATE for the full brief.

### Admin-Role Redirect Lives in Middleware, Not the Layout (corrects Conv 083)
**Date:** 2026-06-08 (Conv 250)

The admin-role gate (non-admin on `/admin/*` → redirect `/`) lives in `src/middleware.ts`, after the session check, NOT in `AdminLayout.astro`. The `AdminLayout` role-redirect block + its now-unused imports were removed. Pattern: `if ((pathname === '/admin' || pathname.startsWith('/admin/')) && !session.roles.includes('admin')) return context.redirect('/')`.

**Rationale:** A `return Astro.redirect()` inside a *layout* component (not the page top-level) halts that component's render into empty output rather than emitting the redirect Response — only middleware or page frontmatter can return the HTTP-level Response. A non-admin therefore got a blank 15-byte 200 instead of a 302 (`[ADMIN-REDIRECT-BLANK]`). Middleware already classified `/admin/*` as a `PROTECTED_PREFIX` for the session check, so the role gate is its natural sibling (clean 302).

**Consequences:** Corrects the Conv-083 "Admin Auth Guard in Layout" entry — the role-based redirect moves to middleware; `middleware.test.ts` gained an admin-gate suite (and dropped /admin from the student-pass list).

**See:** `src/middleware.ts`, `src/layouts/AdminLayout.astro`, `tests/middleware.test.ts`; Conv 250 Decisions §3, Learnings §1.

### ROLE-SEMANTICS: Two-Axis Role Model — Capability `canX` vs Identity `isX` (Access Gates Stay on Capability)
**Date:** 2026-06-08 (Conv 252)

Role checks split into two canonical axes, implementing the Session-319 Permission-vs-State distinction site-wide:

- **Capability `canX`** (permission, e.g. `canCreateCourses`) — gates ACTIONS / access. `if (!is_creator) → 403` is an ACCESS gate and belongs here.
- **Identity `isX`** (behavioral, derived from data) — gates NAV / display / nudges.

Canonical surfaces: behavioral getters `get isCreator/isTeacher/isStudent/isModerator` on `CurrentUser` (`src/lib/current-user.ts`; moderator/admin are assigned, not derived) + matching server SQL fragment builders `isCreatorSubquery(userRef)`/`isTeacherSubquery(userRef)` on `roles.ts` (pure strings, no DB import → client-bundle-safe). 6 pure-behavioral inline `/api/me` SQL sites (7 instances) deduped onto the fragments.

**Migration rule (RS-HYBRID-FLIP, #24):** do NOT naively flip hybrid `is_creator` sites to behavioral — split each site **by purpose**: access → `canX`, identity/display/nudge → `isX`. A naive flip would 403 every approved-but-0-course creator.

**Security rule:** never gate on `requireRole(['creator'])`/`['teacher']` until `getUserRoles()` is behavioral. Today `getUserRoles()` bakes a **permission-based** roles array into the JWT and `requireRole` only ever checks `['admin']`/`['moderator']` (assigned), so creator/teacher identity is security-neutral now — but a future `requireRole(['creator'])` would read the stale permission flag.

**JWT exception (Tier-3, Conv 253):** display/nav/label derivations were flipped behavioral — `roles.ts userRoles`/`describeRoles` + the AppLayout Sidebar SQL now compute Creator/Teacher via `isCreatorSubquery`/`isTeacherSubquery` (closes the live granted-but-0-course Sidebar↔profile-header mismatch). `getUserRoles()` (JWT `session.roles`) deliberately **stays permission-based**, documented inline: the JWT is set at login, so a behavioral value would freeze and go stale mid-session until re-login, whereas permission flags only change via admin-action-plus-re-login anyway. The "identity = behavioral" rule therefore does NOT extend to the auth-snapshot boundary. Locked by `tests/lib/roles-labels.test.ts` (7 tests). ROLE-SEMANTICS core closed.

**Revoke edge (accepted default):** `can_create_courses` is admin-revocable and creation requires it. An admin-revoked ex-creator with existing courses loses `/creating` access but the creator badge still shows (behavioral). Revisit only if orphaned-course management bites.

**Moderator fragment + nav signal (RS-MOD-FRAG / MOD-NAV, Conv 254):** the community-mod identity fragment is named `isCommunityModeratorSubquery` (NOT a bare `isModeratorSubquery`) — the Moderator *role label* reads the `can_moderate_courses` permission, while this fragment reads the `community_moderators` table (behavioral); a bare name beside `isCreator/isTeacher` would falsely imply it is THE canonical moderator check. The fragment is one scalar `(SELECT COUNT(*) > 0 …)` form serving both filter (`WHERE`) and projection (`as is_x`) sites. The AppLayout Sidebar moderation nav signal computes `isModerator = can_moderate_courses OR isCommunityModeratorSubquery` and renders the `/mod` item only when `isModerator && !isAdmin` — mirrors the `/mod` middleware gate (`requireModerationAccess`) so nav visibility matches access, while `!isAdmin` keeps admins on `/admin` (their moderation entry) without a redundant item.

**Rationale:** `canX` answers "may this user do X?"; `isX` answers "has this user done X?". Conflating them breaks on new-creator (perm=1, courses=0) and revoked-creator (perm=0, courses>0) edges. A 3-parallel-Explore blast-radius audit found `is_creator` had 3 competing definitions (behavioral, hybrid-access, and `roles.ts userRoles()` permission-based) and that the hybrid gates were access gates wrongly slated for a behavioral flip.

**See:** `src/lib/current-user.ts`, `src/lib/roles.ts`, `tests/lib/current-user-role-identity.test.ts`, `tests/lib/roles-sql.test.ts`; Conv 252 Decisions §3–4; PLAN.md ROLE-SEMANTICS. Extends "Creator Access: Permission Flag vs Course State" (Session 319).

### COMMUNITY-RESOURCES download auth: any authenticated member
**Date:** 2026-04-14 (Conv 117)

Download (`GET /api/community-resources/[id]/download`) requires authentication + community membership. Creator and platform admin always have access regardless of membership row. Public vs private community flag does NOT affect download auth — to download, the user must join. Link-type resources return 400 (clients use `external_url` directly).

**Rationale:** Public/private is about discoverability and posting, not resource access. Auth chain is ordered cheapest-first: creator check (cached value) → admin check (indexed PK) → membership check (two-column lookup), short-circuiting at each tier.

---

### Custom JWT Authentication
**Date:** 2025-12-26

Use custom JWT with `jose` + `bcryptjs` + `arctic` (OAuth library).

**Rationale:** Safer than Clerk for edge deployments; Clerk has known compatibility issues with Astro + Cloudflare Pages.

### Admin Auth Pattern
**Date:** 2025-12-29

Use existing `requireRole()` function directly in API handlers. No separate admin middleware file needed.

**Rationale:** Auth system already has role-based control built in; no need for additional abstraction.

### OAuth User Creation
**Date:** 2025-12-28

OAuth creates users automatically if they don't exist. OAuth users have empty `password_hash` - cannot login with password.

### Email Verification Deferred
**Date:** 2025-12-27

Email verification deferred to Block 9 (Notifications).

**Rationale:** Block 9 handles notification infrastructure; OAuth users already verified via provider.

### Admin User Creation Requires Password
**Date:** 2026-01-25

Admin-created users via `POST /api/admin/users` must have a password. The endpoint returns 400 if password is not provided.

**Options Considered:**
1. Allow NULL `password_hash` with email-invite flow (user sets password via welcome email)
2. **Require password** (admin communicates credentials out-of-band) ← **Chosen**
3. Auto-generate random password and return in response

**Rationale:** For MVP/Genesis cohort (60-80 students with direct contact), requiring password is simplest:
- No dependency on email system (Resend domain verification not yet complete)
- User can log in immediately after admin creates account
- Admin can share credentials during onboarding calls/meetings
- No NULL handling complexity in login logic

**Post-MVP:** May revisit Option 1 (email-invite flow) for scalable self-service user creation once email infrastructure is fully configured.

**See:** `src/pages/api/admin/users/index.ts`

### JWT Auth Over Astro Sessions
**Date:** 2026-02-16

Stay with custom JWT authentication (stateless, cookie-based). Astro Sessions (server-side KV storage) evaluated and deferred to post-MVP.

**Rationale:** JWT is already built, tested across 169 API test files, and framework-agnostic. The stale-role gap (up to 15 min) is mitigated by short access token TTL and D1 re-checks on critical endpoints. Astro Sessions would add KV infrastructure dependency and couple the auth system to Astro.

**See:** `docs/as-designed/auth-sessions.md`

### Modal-Based Auth for Login and Signup
**Date:** 2026-02-16 (Session 220)

Login and signup use modals over AppLayout instead of standalone pages. The `/login` and `/signup` routes render AppLayout with `AutoOpenAuthModal` which auto-opens the appropriate modal. Dismissing leaves the user browsing as a visitor. Cross-modal switching (login ↔ signup) preserves `pendingAction` for flows like "try to enroll → auth → complete → enrollment fires."

**Rationale:** Matches the Twitter/X pattern. Enables in-context auth without page navigation. Forms are modal-only (`onSuccess` required, no redirect logic).

**See:** `src/lib/auth-modal.ts`, `src/components/auth/AuthModalRenderer.tsx`

### Password Reset as Standalone Page
**Date:** 2026-02-16 (Session 220)

Password reset uses a standalone page (`/reset-password`) within AppLayout, not a modal.

**Rationale:** Multi-state UI (form → "check your email" confirmation), reached from two contexts (login modal and settings page), and future token flow (`/reset-password?token=xyz`) all require a real page.

**See:** `src/pages/reset-password.astro`, `src/components/auth/PasswordResetForm.tsx`

### Feed Access Models
**Date:** 2026-01-20

Three community feeds with distinct access patterns:

| Feed | View | Post |
|------|------|------|
| TownHall (FEED) | Authenticated | Authenticated |
| Instructor (IFED) | Enrolled in instructor's course | Same |
| Course (CDIS) | Public | Enrolled/completed students |

**Rationale:** TownHall is platform-wide community. IFED is instructor-exclusive (social proof for paid community). CDIS allows public viewing (marketing) but restricts posting to maintain quality.

### canModerateFor() Four-Tier Check
**Date:** 2026-02-23 (Session 261, updated Session 265)

`canModerateFor(courseId)` checks four conditions in order: `isAdmin`, `isCreatorFor(courseId)`, `canModerateCourses` (global moderator), and `communityModeratedCourseIds.has(courseId)` (community moderator). The fourth check resolves community moderator authority through the Community → Progression → Course chain.

**Trigger:** Session 261 audit revealed only admin + creator were checked. Session 265 implemented the community moderator check.

**Rationale:** Each tier represents a different scope: admin (platform-wide), creator (own courses), global moderator (all courses), community moderator (courses within their assigned community). The pre-computed `communityModeratedCourseIds` Set enables O(1) lookup on the client side.

**See:** `src/lib/current-user.ts`, `src/pages/api/me/full.ts` (fetchCommunityModeratedCourseIds), `docs/reference/ROLES.md`

### Two-Tier Moderator Model
**Date:** 2026-02-23 (Session 263)

Peerloop uses a two-tier moderation model instead of a single global moderator flag:

| Tier | Name | Scope | Appointed By | Database |
|------|------|-------|-------------|----------|
| 1 | Global Moderator | All feeds, all communities | Admin (invite or direct toggle) | `users.can_moderate_courses` flag |
| 2 | Community Moderator | One community + its course feeds | Creator (from member list); Admin can also appoint | `community_moderators` table |

**Trigger:** Client needs per-community moderation. Single global flag insufficient — Creators need to appoint trusted community members for day-to-day feed oversight when they and their teachers are unavailable.

**Options Considered:**
1. **Add `moderator` to `community_members.member_role` enum** — Rejected. Dual-role problem: a user who is both a member and a moderator would need to change their `member_role` field. Current enum values (`creator`, `teacher`, `member`) are mutually exclusive in intent. Adding `moderator` conflates membership role with moderation authority.
2. **Separate `community_moderators` table** ← **Chosen.** Follows the `teacher_certifications`[^tc] pattern: per-entity relationships with their own metadata (appointed_by_user_id, revoked_by_user_id, revoke_reason). User keeps their `community_members.member_role = 'member'` AND gets a `community_moderators` row.
3. **Per-course `course_moderators` table** — Rejected. Too granular. Community is the natural scope unit — courses inherit moderation via Community → Progression → Course chain. Per-course assignment would create N moderator rows for N courses in a community when the intent is community-wide.

**Stewardship Stack (hierarchical oversight model):**
```
Creator → Teachers → Community Moderator → Global Moderator
(community owner)  (course support)  (day-to-day feed)   (platform policy)
```

**Rationale:** Community is the natural scope unit for moderation. Creators own communities. Courses belong to communities via progressions. Moderating a community implicitly covers all its course feeds. This matches how Discord and Reddit scope moderator authority (server/subreddit level, not channel level).

**See:** `docs/reference/ROLES.md` (§5 Moderator Two-Tier Model), `docs/reference/DB-GUIDE.md` (Moderation System section)

### Community Moderator Direct Appointment (Not Invite)
**Date:** 2026-02-23 (Session 263)

Community Moderators are appointed directly by the Creator from the community member list. No email invite flow — the user is already a known community member.

**Contrast with Global Moderators:**
- **Global Moderator:** Admin sends email invite → user accepts → `can_moderate_courses` set. Invite flow needed because the person may not have a Peerloop account yet.
- **Community Moderator:** Creator selects from existing member list → `community_moderators` row created immediately. No invite needed because the person is already a registered, active community member.

**Options Considered:**
1. **Reuse the moderator invite email flow** — Rejected. User is already known (they're in the community member list). An invite-accept roundtrip adds friction for no benefit. The invite flow exists for Global Moderators precisely because the invitee might not have an account.
2. **Direct appointment from member list** ← **Chosen.** Simpler UX. Creator sees member list → clicks "Appoint as Moderator" → done. Revocation is equally direct.

**Rationale:** The invite flow was designed for recruiting new platform moderators who might not exist in the system. Community moderators are selected from people who are already active members. A direct appointment is the right UX for this scenario.

**See:** `docs/reference/ROLES.md` (Tier 2: Community Moderator → How to Become)

### Two-Tier Moderation Access Pattern (requireModerationAccess)
**Date:** 2026-02-23 (Session 267)

All 6 moderation endpoints use `requireModerationAccess(cookies, jwtSecret, db)` instead of `requireRole(['admin', 'moderator'])`. The helper returns `{ session, scope }` where scope is `{ type: 'global' }` for admin/moderator (JWT) or `{ type: 'community', communityIds: [...] }` for community moderators (DB query).

**Tier capabilities:**
- **Tier 1 (global):** See all flags, dismiss, remove, warn, suspend
- **Tier 2 (community):** See community-scoped flags only, dismiss, remove. Cannot warn or suspend (enforced by `canPerformElevatedAction(scope)`)

**Scope enforcement:** Out-of-scope flags return 404 (not 403) to prevent information leakage. Queue listing (`GET /api/admin/moderation`) adds `WHERE community_id IN (...)` for Tier 2. Stats are also scoped.

**Flag community scoping:** `content_flags.community_id` (nullable, ON DELETE SET NULL) + `feed_group` track which community a flag belongs to. Townhall and profile flags have null community_id, making them invisible to Tier 2 moderators (SQL IN naturally excludes NULLs).

**Rationale:** DB-backed scope is always fresh (no stale JWT claims). JWT check happens first (fast path for admins). Typed scope object lets each endpoint enforce its own rules.

**See:** `src/lib/auth/moderation.ts`, moderation endpoints in `src/pages/api/admin/moderation/`

### Creator Access: Permission Flag vs Course State
**Date:** 2026-03-01 (Session 319)

Two distinct concepts for "is creator" exist and must be used differently:

- **Permission** (`can_create_courses` flag): "May this user create?" — set by admin approval
- **State** (course count subquery): "Has this user created?" — derived from data

**Gate rules:**
- **Create** new courses/communities → Permission only (`can_create_courses = 1`)
- **View/manage** dashboard, courses, earnings, analytics, communities → Permission OR State

**Revocation policy:** When admin revokes permission, only creation of new resources is blocked. Full access to existing courses/communities is retained (managed via ownership checks).

**Rationale:** New creators (permission=1, courses=0) must access the dashboard. Revoked creators (permission=0, courses>0) must manage existing content. The OR gate handles both. POST endpoints stay permission-only as a creation guard.

> **Insight:** Permission and state answer fundamentally different questions. Most access control systems conflate them — checking "has this user done X?" as a proxy for "may this user do X?" works until the first edge case (new user who hasn't done X yet, or revoked user who has). Separating them explicitly in the gate pattern prevents an entire category of chicken-and-egg bugs. (Session 319)

**See:** `POLICIES.md` for full policy.

### useCreatorGate Hook for Client-Side Access Gating
**Date:** 2026-03-01 (Session 320)

All `/creating/*` page components use the `useCreatorGate()` hook for client-side access gating. The hook reads `CurrentUser` global state (Permission OR State = Pattern C) with a stale-cache refresh fallback, and returns `{ status: 'loading' | 'creator' | 'not-creator', hasCourses: boolean }`.

**Components:** CreatorDashboard, CreatorStudio, CreatorAnalytics, CreatorCommunities, CreatorEarningsDetail.

**Rationale:** Before the hook, 5 components used 4 different access patterns — some checked 403 responses inline, one pre-fetched `/api/me/courses` just for a course count, and two had no check at all. The `CurrentUser` global already contains `canCreateCourses` and `hasCreatedCourses()`, making separate API calls redundant. The hook provides consistent "Creator Access Required" UI across all pages and eliminates unnecessary network requests.

**Stale-cache recovery:** If cached `CurrentUser` says "not creator," the hook calls `refreshCurrentUser()` before denying access. This handles the scenario where admin just approved a creator application while the user's tab was open.

**Security model:** The client-side gate is purely UX — it prevents wasted API calls and shows a friendly message. Server-side API gates (Pattern C on each endpoint) remain the authoritative security enforcement layer.

**See:** `POLICIES.md` §1 "Client-Side Creator Gate". `src/components/auth/useCreatorGate.ts`.

### Enforce Teacher-Enrollment Match on Session Booking
**Date:** 2026-03-04 (Session 325), updated 2026-03-16 (Session 389)

`POST /api/sessions` validates that the `teacher_id` matches `enrollment.assigned_teacher_id`[^at]. Returns 403 "Teacher does not match your enrollment" if mismatched. A student enrolled with teacher A can only book sessions with teacher A.

**Update (Session 389):** When `assigned_teacher_id` is NULL (student enrolled without selecting a teacher), the first booking assigns the selected teacher by backfilling `assigned_teacher_id` and `teacher_certification_id` on the enrollment. Subsequent bookings enforce the match. This supports the enrollment flow where `EnrollButton` doesn't always pass a `teacherId` (e.g., course detail page with no teacher pre-selected).

**Rationale:** The enrollment establishes the student→teacher relationship. Downstream actions must validate against this binding, not just validate entities independently. The NULL-backfill pattern treats "not yet assigned" differently from "assigned to someone else" — the former is a deferred choice, the latter is a security boundary.

**See:** `src/pages/api/sessions/index.ts`, `docs/as-designed/session-booking.md`

### Messaging Access Control: Open Member-to-Member DMs
**Date:** 2026-04-13 (Conv 110) — *supersedes Session 338 relationship-gated model*

Any authenticated member can message any other non-deleted member. No relationship requirement. Admin rules unchanged: anyone can message admin (support channel), admin can message anyone.

Enforcement still uses a two-layer model: Layer 1 (UX) controls button visibility on audited surfaces. Layer 2 (API) is the authoritative security boundary. The policy check simplified from 3 relationship queries to 1 existence check.

**Rationale:** Client-approved for Genesis Cohort. At 60-80 users, abuse is manageable through admin oversight. Relationship gating was architecturally sound but premature at this scale — the infrastructure cost (3 queries, 6 EXISTS clauses, 28 surface audits) outweighed the benefit.

**See:** `POLICIES.md` section 4 (rules), `docs/as-designed/messaging.md`

> **Insight:** The three-function architecture (`canMessage`, `getMessageableFlags`, `messageableContactsSQL`) survived the policy reversal intact — only internal rules simplified, not function signatures or API contracts. This validates separating access-pattern interfaces from policy logic: when the policy changed, callers needed zero updates. (Conv 110)

### Messaging Three-Function Architecture (Retained)
**Date:** 2026-03-05 (Session 341), simplified Conv 110

The messaging check is implemented as three functions in `src/lib/messaging.ts`, each serving a different query pattern:

| Function | Use Case | Performance |
|----------|----------|-------------|
| `canMessage(db, senderId, recipientId)` | API gates (conversation creation, message sending) | Delegates to batch |
| `getMessageableFlags(db, senderId, ids[])` | List annotation (show/hide Message button per user) | O(1 query) — simple existence check |
| `messageableContactsSQL(db, senderId)` | Search filtering (returns SQL WHERE clause) | O(1 query) — `u.deleted_at IS NULL` |

`getMessageableFlags` returns `Record<string, boolean>` (annotation flags), not a filtered list. This lets callers show all users but conditionally render the Message button — display logic stays separate from messaging logic.

**Rationale:** Three functions cover all three access patterns with the policy rules defined in exactly one place. Architecture proved durable across a full policy reversal (relationship-gated → open).

**See:** `src/lib/messaging.ts`, `docs/as-designed/messaging.md`

### Astro Middleware for Centralized Authentication Guards
**Date:** 2026-03-29 (Conv 053)

Centralize authentication enforcement in `src/middleware.ts` with route classification. Middleware checks JWT only (no DB queries). Routes classified as `PROTECTED_PREFIXES` (match path + sub-paths, e.g., `/admin/*`) and `PROTECTED_EXACT` (match bare path only, e.g., `/community` but not `/community/[slug]`). Individual pages and API endpoints retain authorization logic (role checks, enrollment verification).

**Rationale:** Single point of enforcement, easy to extend. The two-set route classification handles Peerloop's "bare = my" URL convention (`/courses` = My Courses, `/community` = My Communities) where the bare path is member-only but sub-paths are public.

> **Insight:** When URL conventions use the same base path for both authenticated (bare) and public (with slug) content, a simple prefix match either over-blocks or under-blocks. Splitting into prefix + exact-match sets keeps the middleware declarative without restructuring URLs.

**See:** `src/middleware.ts`, `tests/middleware.test.ts` (86 tests)

### Onboarding Is UX, Not a Security Gate
**Date:** 2026-03-29 (Conv 053)

Removed onboarding enforcement from middleware entirely. OAuth callback redirects fresh users to `/onboarding` as a first-touch nudge. Pages that use interest data show component-level nudges ("complete your profile" banner). Users who skip onboarding get a degraded experience but are not trapped.

**Rationale:** Onboarding completion is a UX concern, not a security concern. Middleware should only handle authentication ("are you logged in?"), not UX flows. Simplified middleware by ~80 lines and removed `peerloop_onboarded` cookie infrastructure.

### Remove Username Field from Signup — Auto-Generate Handle Server-Side
**Date:** 2026-03-31 (Conv 067)

Username/handle field removed from the signup form entirely. Server auto-generates handle from the user's name (lowercase, strip non-alphanumeric, max 20 chars) with incrementing collision suffix (`testwalker`, `testwalker1`, `testwalker2`...). Users customize their handle later in profile settings.

**Rationale:** The handle field caused the most UX stumbles during STUMBLE-AUDIT: 3 different validators with conflicting rules, unclear auto-generation, poor collision UX, and the field felt optional but was required. Removing it reduces signup to 4 fields and follows Twitter/Discord patterns. Eliminates 4 open issues at once.

> **Insight:** When a form field generates multiple UX issues (confusion, validation mismatch, collision handling), removing it entirely is often better than fixing each issue individually. Auto-generation with later customization follows established patterns and reduces signup abandonment risk.

**See:** `src/pages/api/auth/register.ts`, `src/components/auth/SignupForm.tsx`

### Post-Signup Redirect to /onboarding
**Date:** 2026-03-31 (Conv 067)

`handleAuthSuccess()` now distinguishes signup from login via a `wasSignup` flag. After signup with no pending action (e.g., no returnUrl from ModeratorInvite), new members redirect to `/onboarding`. Login behavior unchanged — returns to previous page or home.

**Rationale:** Complements the "Onboarding Is UX, Not a Security Gate" decision (Conv 053). While onboarding isn't enforced, directing new signups there immediately gives the best first-touch experience. Pending actions (returnUrl) take priority over the onboarding redirect.

**See:** `src/lib/auth-modal.ts`

### Handle Validation: Social Platform Standard
**Date:** 2026-04-01 (Conv 068)

Unified three conflicting handle validators to a single pattern: `^[a-zA-Z][a-zA-Z0-9_]{2,19}$` — must start with letter, letters/numbers/underscores only, 3-20 chars. Single source of truth in `auth/index.ts` with `isValidHandleFormat()` boolean export for call sites.

**Rationale:** Matches Twitter/Instagram conventions. Hyphens in handles create @mention parsing ambiguity. Max 20 aligns with auto-generation cap. Existing auto-generated handles (lowercase alphanumeric) are already compliant.

> **Insight:** When multiple validators for the same field diverge across codebase locations, the fix isn't reconciling them — it's extracting a single source of truth and importing everywhere. Divergent copies will always drift again.

**See:** `src/lib/auth/index.ts`, `src/pages/api/me/profile.ts`, `src/components/settings/ProfileSettings.tsx`

### Admin Auth Guard in Layout, Not Pages
**Date:** 2026-04-03 Conv 083

Auth guard in `AdminLayout.astro` using `getSession()` + role check + `Astro.redirect()`, rather than per-page guards. Three-layer redirect: no JWT secret -> login, no session -> login with redirect, session but not admin -> redirect to homepage.

**Rationale:** Secure by default — any page using AdminLayout gets admin-only access automatically. Single enforcement point eliminates the risk of forgetting a guard on new admin pages (13 pages were unguarded before this).

> **Insight:** When a group of pages shares a layout, put access control in the layout rather than individual pages. This inverts the default from "open unless explicitly guarded" to "guarded unless explicitly exempted."

> **Superseded in part (Conv 250):** the role-based *redirect* moved to `middleware.ts` — see "Admin-Role Redirect Lives in Middleware, Not the Layout". A `return Astro.redirect()` inside a layout halts render into a blank 200 rather than emitting a 302.

**See:** `src/layouts/AdminLayout.astro`

### Prod admin seed password: rotate to "Peerloop2", apply deferred
**Date:** 2026-05-21 (Conv 168)

`migrations/0002_seed_core.sql:172` seeds the prod admin row (`usr-admin` / admin@peerloop.com) with a bcrypt hash of `Password1`. The dev seed was rotated to `Peerloop2` in Conv 167 [SEED-PW]. The prod seed still ships `Password1`, and the live prod D1 admin row also still uses `Password1` because seed re-runs hit PK collision on `users.id` and do not update existing rows.

**Decision:** prod admin password = `Peerloop2` (matches dev). Application is **deferred** in Conv 168 — neither the seed file nor live prod D1 is changed this conv.

**Rationale:** Operationally simpler to have one shared admin password across dev/staging/prod given the small team and pre-launch stage. `Peerloop2` is now present in 13+ dev/script/test files so it is not a secret; treating prod as if it were a stronger secret while it shares the dev value would be theatre. The deferred apply is a coordination decision — wants to bundle the seed edit + the live `wrangler d1 execute` UPDATE against `peerloop-db` prod in one synchronous step rather than leaving prod and seed in disagreement for any window. Captured here so the choice doesn't need to be re-litigated when the apply step runs.

**What still needs to happen when this is un-deferred** (tracked in PLAN.md [PROD-PW]):
1. Edit `migrations/0002_seed_core.sql:172` — replace the `Password1` hash with the bcryptjs cost-10 hash for `Peerloop2` (`$2b$10$tQMUTTuSbJiuqpITHrCN7.PMrqqkJTZROlbhZkPfvLKYEtcAsflXi`, generated Conv 167 [SEED-PW] and currently used in `src/lib/mock-data.ts:1485`).
2. Run `wrangler d1 execute peerloop-db --remote --command="UPDATE users SET password_hash = '<hash>' WHERE id = 'usr-admin'"` against prod to rotate the existing row.
3. Verify by logging into prod as admin@peerloop.com / Peerloop2.

**Counter-option not chosen:** A strong random password stored in 1Password would be more durable for a post-launch system. Revisit if/when the team grows or external auditors look at credential management.

---

### Session-Expired Re-Login Is Modal-Only (Prefill via AuthModal) — Inline Banner Retired with AppNavbar
**Date:** 2026-06-27 (Conv 340)

The "Welcome back / Log In Again" inline session-expired banner lived in the legacy `AppNavbar`, deleted in the Conv-339 `/old` retirement. The Matt shell ships no inline-banner replacement.

**Decision:** Modal-only re-login is the intended design. When a session expires, the user re-authenticates through `AuthModal` (email prefilled via the `initialEmail` thread); the inline "Welcome back" banner is **not** rebuilt. Documented as an accepted simplification — no `[SESSEXP-UX]` rebuild task.

**Rationale:** The email-prefill capability — the only load-bearing part of the old banner — survives in `AuthModal` via `initialEmail`. The inline banner was redundant chrome on top of that, and rebuilding it would re-introduce navbar-coupled UI the Matt shell deliberately shed.

**See:** `docs/as-designed/auth-sessions.md`; `docs/as-designed/state-management.md`; Conv 340.

---

