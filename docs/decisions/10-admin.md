> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 10. Admin Implementation

### Diploma Visibility Lives on the Enrollments Admin (Row Action + Detail Field), Not a Separate Diplomas View (ADMIN-DIPLOMA-VIS, Conv 392)
**Date:** 2026-07-12 (Conv 392)

A completed-course **Diploma** surfaces in admin on the existing **Enrollments** admin — the list + detail admin APIs (`/api/admin/enrollments/index.ts` + `[id].ts`) return `diploma_awarded_at`; completed rows get a "View Diploma" row action (`EnrollmentsAdmin.tsx`); the detail panel's Status section shows a Diploma field (View-Diploma link + awarded date) (`EnrollmentDetailContent.tsx`). Chosen over a separate "Diplomas" admin view/list. This closed a real gap: completed courses were already visible via the Enrollments status filter, but a Diploma appeared NOWHERE in admin (the Certificates admin page is teaching-only post Conv-389).

**Rationale:** A Diploma has **no table** — it's derived from the completed enrollment (Conv-389 DIPLOMA model), so a separate Diplomas view would be a view over a non-existent table. A derived credential surfaces on its **source entity's** admin; Enrollments already IS the completion record. Verified live.

**See:** `src/pages/api/admin/enrollments/index.ts`, `[id].ts`, `src/components/admin/EnrollmentsAdmin.tsx`, `EnrollmentDetailContent.tsx`; `docs/decisions/02-database.md` (DIPLOMA model); `docs/sessions/2026-07/20260712_2027 Decisions.md` §3; Conv 392.

### ADMIN-CONF-POLICY — Admin = Dense Operational Console with a Distinct Identity (RG-ADMIN Restyle Policy)
**Date:** 2026-06-24 (Conv 331)

RG-ADMIN (16 routes / 33 components / ~1470 legacy-token hits incl. 122 `dark:` across 35 files — multi-conv) is restyled as a **dense operational console**, NOT a full Matt content-surface conform. Relaxations: **A** density bias, **B** neutral-led / minimal brand, **C** lightweight inline controls in tables, **D** flat data containers. Type regime: **12px base** (`text-body-small`) + **10px dense/meta** (`text-display-micro`) + headings down one step. Distinct admin identity: dark `neutral-900` sidebar, light-on-dark nav, "Admin" wordmark, `info`-blue accent (not brand-purple), role chip, shared page-header. Strict (no relaxation): drop all `dark:`, semantic-status colour, on-scale spacing. Chosen over full content-surface conformance.

**Rationale:** Admin serves ≤2 high-trust operators who want density/legibility; forcing the content aesthetic hurts usability. The 12-vs-14 type shift + dark sidebar give a deliberate "Admin" identity as operators cross between the light user app and admin pages. Builds on the RG-MOD precedent. The uniform-10px idea was countered to 12px-base + 10px-meta for legibility.

**Consequences:** Policy-setting only this conv (no admin editing). Recorded to memory `project_admin_conformance_policy.md` + route-migration README RG-ADMIN row + task #3. Multi-conv sweep deferred (start: shell + AdminDashboard). RG-ADMIN is the only remaining canonical RTMIG-4 sweep.

**See:** `memory/project_admin_conformance_policy.md`; `plan/route-migration/README.md`; Conv 331.

### RG-ADMIN Three Locked Sub-Patterns — Button / Form / Modal Primitive Adoption (Conv 332)
**Date:** 2026-06-24 (Conv 332)

Executing `[ADMIN-CONF-POLICY]` route-by-route, three primitive-adoption sub-patterns are LOCKED for all 16 admin routes:

- **(a) Action buttons → `<Button>`.** Inline admin `<button>`s adopt the shared `Button` with **no new variant**: money/primary actions→`primary`, cancel→`default`, retry→`warning`, destructive→`danger`, external deep-link→`outlined`. Key discovery: Button's default `variant="primary"` renders `bg-text-primary` = `#0777B6` = the americana-blue = exactly `info-500` (the admin accent). Matt "primary" is **blue**, not purple — the `primary-*` Tailwind ramp is a separate purple namespace. So the policy's "admin CTAs in info-blue, not brand-purple" needs no admin/info Button variant (unlike RG-MOD's minted warning/suspend).
- **(b) Admin forms → `form/Input` / `form/Textarea` / `form/Select`.** Hand-rolled `inputClass`/`labelClass` inputs adopt the form primitives. `datetime-local` forwards through the primitive's `...rest` spread. Inputs render at the 14px primitive default — correct for form fields, not a density violation. (Checkboxes stay inline-conformed.)
- **(c) Admin modals → `ui/Modal`.** Hand-rolled modals (bespoke backdrop/card/header) adopt `ui/Modal` (`isOpen`/`onClose`/`title`/`maxWidth` API; conformed backdrop + header; unpadded children); custom logic (e.g. TopicModal slug auto-gen) preserved. `FormModal` is NOT used where declarative fields don't fit custom field behavior.

Applied to routes #1–#4 (`/admin/payouts`, `/admin/promotion-settings`, `/admin/announcements`, `/admin/topics`). The shared `AdminActionMenu` primitive — skipped by RG-MOD's sweep because ModeratorQueue doesn't use it — surfaced unconformed at the first admin *table* route and was conformed in-place (it lives in `components/admin/` → RG-ADMIN scope), fixing 2 latent bridge-shrink bugs (`w-48`→48px dropdown, `w-4 h-4`→4px icons).

**Rationale:** Durable, design-system-consistent, dedups hand-rolled chrome, inherits future primitive improvements; matches the RG-MOD adopt-and-conform precedent. The americana-blue=primary discovery makes Button adoption zero-cost.

**Consequences:** The three patterns govern the remaining 12 admin routes. App-wide `Footer.astro` strays (`secondary-`/`dark:`, visible on admin pages) are out of RG-ADMIN scope → tracked separately as `[FOOTER-CONF]` #26.

**See:** `plan/typo-fdn/migration-ledger.md` (RG-ADMIN section); supersedes nothing — extends the Conv-331 ADMIN-CONF-POLICY entry above; Conv 332.

### RG-ADMIN Conform Conventions — Lifecycle-Meaning Stat Hues, RG-MOD Mirroring, FormModal Migration (Conv 335)
**Date:** 2026-06-25 (Conv 335)

Three conventions crystallized executing RG-ADMIN routes #11–#14 (`/admin` flip, `/admin/certificates`, `/admin/moderators`, `/admin/moderation`):

- **Stat-card hues map by lifecycle MEANING, not original colour.** White-card admin stat cards take a semantic value hue by what the stat *means*, not by preserving the legacy tint: Active/Total→`neutral` headline, Pending→`warning`, Accepted/Issued→`success`, Declined/Revoked→`error`. (Rejected mapping by original colour, which made "Active Moderators = warning" read as "something wrong".) certificates/moderators/moderation now share this convention.
- **Conform a sibling-of-an-already-conformed surface by mirroring, not reinventing.** `/admin/moderation` shows the *same flag data with the same badges* as `/mod`, so its `ModerationDetailContent` reason/priority/content-type badge helpers were mirrored **verbatim** from RG-MOD's already-conformed `ModeratorQueue` (priority→status tokens; reason mapped where valence is clear — harassment→error, spam→warning; content-type orphans kept honest — indigo/cyan/pink). Footer action Buttons mirror RG-MOD's action vocabulary: Dismiss=`default`, Remove=`danger`, Warn=`warning`, Suspend=`suspend` (the CC-owned graded-orange variant minted in RG-MOD Conv 313 — chosen over `danger` to keep the two surfaces visually identical). Resulting test-assertion failures are *confirmation*: the 9 stale `ModerationDetailContent.test` badge-class asserts were updated to the exact strings `ModeratorQueue.test` already asserts, proving one shared vocabulary.
- **Hand-rolled admin modals MIGRATE to `FormModal` (not inline-conform).** Refines sub-pattern (c) above: a bespoke `fixed inset-0` modal with declarative fields (e.g. certificates' Revoke modal — reason textarea) migrates to the shared `FormModal` (required-field validation + loading + danger submit), retiring ~52 ln rather than re-tokenizing the custom structure. (`ui/Modal` per sub-pattern (c) remains for modals whose custom field behavior doesn't fit `FormModal`.) Only `CreatorApplicationsAdmin`'s custom modal remains in the admin tree.

**Rationale:** Honest semantics + cross-surface consistency over preserving an arbitrary legacy palette; mirroring a sibling surface guarantees `/admin/moderation` ≡ `/mod` and turns test failures into a verification signal; FormModal migration dedups bespoke chrome. None are novel — all follow from the Conv-331/332 locked playbook, so routes #11–#14 were mechanical follow-through with no per-route pause.

**Consequences:** RG-ADMIN advanced 10/16 → 14/16 (2 routes left). 10 honest-orphan badge hues (orange/purple/indigo/cyan/pink) intentionally retained in `ModerationDetailContent.tsx` per the RG-MOD hybrid policy — not conformance violations.

**See:** `plan/typo-fdn/migration-ledger.md` (RG-ADMIN rows #11–#14); `plan/route-migration/README.md`; extends the Conv-332 Three Locked Sub-Patterns entry above; Conv 335.

### Admin Starting Point
**Date:** 2025-12-29

Start with Users Admin (most frequently used; establishes CRUD pattern).

**Rationale:** Exercises all patterns (list, filter, search, detail panel, actions).

### Course Sub-Table Editing
**Date:** 2025-12-29

Use single tabbed form for course editing (all sub-tables in one page).

**Rationale:** Keeps related data together; reduces navigation; matches common UX.

### Admin Implementation Order
**Date:** 2025-12-29

1. Users Admin (complete)
2. Topics Admin (formerly Categories Admin)
3. Courses Admin
4. Enrollments Admin
5. Student-Teachers Admin

### Moderator Suspension Limits
**Date:** 2026-01-21

Moderators can issue temporary suspensions (1d, 7d, 30d) but permanent suspensions require admin role.

**Rationale:** Moderators need authority to address violations promptly, but permanent bans are high-impact decisions requiring admin oversight. Inline role check in `suspend.ts` API.

**See:** `src/pages/api/admin/moderation/[id]/suspend.ts`

### Admin Bypasses CourseRole Type System
**Date:** 2026-03-29 Conv 055

Admin is a platform-level role, not a course relationship. Rather than adding 'admin' to `CourseRole = 'student' | 'teacher' | 'creator' | 'moderator'` (which would ripple through badge rendering, listing filters, and color lookups), admin bypasses `computeRoleTabs()` entirely. ExploreCourseTabs checks `currentUser.isAdmin` directly and constructs an `ExtraTabConfig` with `roleColor: 'red'`.

**Rationale:** Admin is orthogonal to course roles — an admin can simultaneously hold student+teacher+creator roles for the same course. The `roleColorClasses` map is string-keyed (not CourseRole-keyed), so adding `'red'` is a one-line change with no type system ripple.

> **Insight:** When extending a role-aware UI with a role that's orthogonal to the existing hierarchy, bypass the role computation rather than polluting the domain type. This keeps the domain type honest and limits blast radius.

### Admin Intel Endpoints Over Client-Side Aggregation
**Date:** 2026-03-29 Conv 055

New `/api/admin/intel/*` endpoints (course, user, community, batch courses) serve lightweight aggregated summaries (counts + most-recent items) for admin content on member-side pages. These are separate from existing admin list endpoints.

**Rationale:** Existing admin endpoints are paginated list endpoints with heavy SQL joins returning full table data. AdminIntel needs 3-4 simple indexed COUNT queries for a single entity — much lighter than calling 3-5 existing endpoints and extracting counts client-side. Server-side `requireRole(['admin'])` prevents non-admin clients from even attempting the calls.

### /discover/members as Admin-Only Page
**Date:** 2026-03-29 Conv 055

New admin-only `/discover/members` page alongside existing `/discover/teachers` and `/discover/creators` (which remain available to all users).

**Rationale:** Encourages admins to use the member-facing app (developing empathy for the user experience) while providing admin-specific member browsing capabilities. The existing discover pages serve different purposes than admin member browsing.

### ADMIN-INTEL 6-Phase Block Structure
**Date:** 2026-03-29 Conv 055

Admin capabilities on member-facing pages structured as 6 phases: (1) Foundation (color, API, badge, links), (2) Course/Community tabs, (3) Profile pages, (4) /discover/members, (5) Dashboard, (6) Bidirectional links. All phases depend on Phase 1; Phases 2-6 can proceed in parallel. Supersedes deferred block #38 ADMIN-PAGE-ROLE.

**Rationale:** Single-source component pattern (one admin component per entity type with compact/full variants) prevents duplication across 14+ surfaces. Foundation-first ensures reuse.

### Comprehensive Admin Intel API, Lean Rendering
**Date:** 2026-03-29 Conv 056

Intel API endpoints return everything known about an entity from an admin perspective. Components decide what to render. "Leaner" is an optimization task for later.

**Rationale:** Starting comprehensive avoids API changes as each phase discovers its needs. User directive: "LEANER IS AN OPTIMIZATION TASK." Components are the variable — they pick from the full payload. No API changes needed during Phases 2-6.

### CONTEXT-ACTIONS-FAB Deprecated
**Date:** 2026-03-29 Conv 056

Deferred block #37 CONTEXT-ACTIONS-FAB is deprecated, superseded by ADMIN-INTEL. The FAB was an early idea for baking admin functions into the member side. ADMIN-INTEL's entity-centric approach with single-source components (compact/full variants) covers the same need more comprehensively.

**Rationale:** User confirmed: "This was a VERY early idea... We can safely deprecate the entire idea." PLAN.md updated: #37 struck through.

### Admin Color bg-red-400
**Date:** 2026-03-29 Conv 056

Admin color is `bg-red-400` (changed from red-500 in Conv 055), adjusted if contrast is poor for lettering.

### AdminBadge: Round Badge with Count
**Date:** 2026-03-29 Conv 056

AdminBadge matches the size/shape of existing role badges (RoleBadge.tsx), uses red color, displays count for urgency guidance. Not a simple dot — a full round badge like roles have.

### FormModal Over InputModal for prompt() Replacement
**Date:** 2026-04-03 Conv 080

One multi-field `FormModal` component (text/textarea/select/number/email via `fields` array) replaces all 23 `prompt()` calls across 6 admin/moderation files. Constrained choices become `<select>` dropdowns (structurally impossible to enter invalid values). Multi-prompt sequences (e.g., suspend: duration→reason→notes) collapse into a single form. Same `useState<FormModalState | null>` callback-in-state pattern as ConfirmModal.

**Rationale:** Sequential prompt() popups and free-text input for constrained choices are poor UX and fragile to test. A single FormModal handles all use cases with proper form controls.

> **Insight:** When replacing browser `prompt()` calls, categorize the input patterns first (free text, constrained choice, numeric, multi-step). A single flexible form component with typed field definitions eliminates the category entirely rather than replacing 1:1.

### Bidirectional Admin↔Member Links: Dual-Link Pattern
**Date:** 2026-04-03 Conv 080

Each entity reference in admin detail panels must offer two links: admin context (`adminUrlFor`, primary) + member context (`memberUrlFor`, secondary). Admin-to-admin links are additive — never remove existing `memberUrlFor` links.

**Rationale:** Admin-to-member links keep admins "in touch" with what members experience and provide ADMIN-INTEL overlay access for in-context decisions. Admin-to-admin links provide entity-in-context-of-like-entities view. Both directions serve distinct, complementary purposes. The infrastructure (`admin-links.ts`) already supports both.

> **Insight:** In systems with parallel admin/member interfaces, bidirectional boundary crossing is a feature, not a deficiency. Admins who can freely switch between "entity among peers" (admin view) and "entity as experienced" (member view) make better-informed decisions.

### Account-Wide BBB Recordings Admin Endpoint + UI
**Date:** 2026-05-13 Conv 159

Built a durable admin surface for account-wide BBB recording state: `GET /api/admin/bbb/recordings` returns `{count, recordings: latest 20, fetched_at}` by calling `BBBProvider.getRecordings()` with no `meetingID` parameter. UI at `/admin/recordings` (Astro page + `RecordingsAdmin.tsx` React component) shows count card, "showing N of M" card, fetched_at timestamp card, manual Refresh button, and a 6-column status-badged table. Added to `AdminNavbar` under Management. Companion CLI script kept at `scripts/bbb-list-recordings.mjs` for command-line diagnostics. `VideoProvider.getRecordings()` signature relaxed to `getRecordings(roomId?: string)`.

**Rationale:** Recording issues will recur (vendor configuration drift, webhook regressions, server outages). Account-wide queries are diagnostically stronger than per-session checks — a single SUCCESS+0-result eliminates webhook-delivery, `BBB_SECRET` mismatch, `BBB_URL` misconfiguration, and `bbb_meeting_id` mismatch hypotheses at once. Durable admin UI lets non-CC users (Brian, future admins) diagnose recording state without running scripts or asking engineering. ~250 LOC across 4 new files; well-bounded.

**Consequences:** New admin nav entry visible to all admins. Endpoint queries BBB live on every request (no cache; manual Refresh deliberate, no polling). Latest-20 cap arbitrary, widenable. Pattern reusable for other external-service diagnostic dashboards (Stripe balance, Resend send queue) — count card + latest-N table + fetched_at + manual Refresh.

**See:** `src/pages/api/admin/bbb/recordings.ts`, `src/pages/admin/recordings.astro`, `src/components/admin/RecordingsAdmin.tsx`, `scripts/bbb-list-recordings.mjs`, `docs/reference/bigbluebutton.md` §Recording Lifecycle & Diagnostics

> **Insight:** External-service diagnostic dashboards benefit from deliberate friction (manual Refresh, no polling, prominent fetched_at timestamp). The friction signals "this is a point-in-time snapshot of vendor reality" rather than "live app state".

### `listAllRecordings` as BBB-Specific Method; Admin Recordings Paginated with 2-Call Total Derivation
**Date:** 2026-05-15 Conv 161

The `/admin/recordings` page was rewritten to use canonical admin pagination (20 per page, prev/next, items-per-page selector) backed by a new `BBBProvider.listAllRecordings({limit, offset}): Promise<{recordings, total}>` method. The method is BBB-specific and is NOT added to the shared `VideoProvider` interface — admin endpoint creates a BBB-specific provider via `createBBBProvider` and calls it directly. Endpoint uses `parsePagination` / `paginationOffset` / `createPaginatedResult` from `src/lib/db/index.ts` (the existing admin pagination convention). Blindside requires `limit=N` (N ≤ 100) on every `getRecordings` call — unbounded queries silently return zero results — and supports a non-standard `offset` extension. Blindside does not return a total count, so the endpoint makes two parallel BBB calls per request: one for the requested page, one with `limit=100` to derive total. Shared XML→Recording mapping logic extracted to private static `BBBProvider.extractRecordings(result)` helper.

**Rationale:** Pagination semantics are inherently vendor-specific (PlugNmeet may have entirely different paging or none); forcing the `VideoProvider` interface to support BBB's `{limit, offset, total}` shape would overreach. Reusing the established admin pagination helpers aligns the new endpoint with 10+ other admin endpoints. The 2-call cost (~14KB extra per request) is acceptable for an infrequent admin diagnostic surface and preserves an accurate total count.

**Consequences:** Endpoint at `/api/admin/bbb/recordings?page=N&limit=N` returns canonical paginated shape (`{items, total, page, limit, totalPages, hasMore, fetched_at}`). React component uses shared `AdminPagination`. Per-room `VideoProvider.getRecordings(roomId?)` interface unchanged. Diagnostic script `scripts/bbb-list-recordings.mjs` and per-room `BBBProvider.getRecordings()` both pass hardcoded `limit=100` (Blindside's max).

**See:** `src/lib/video/bbb.ts`, `src/pages/api/admin/bbb/recordings.ts`, `src/components/admin/RecordingsAdmin.tsx`, `scripts/bbb-list-recordings.mjs`, supersedes Conv 159 entry on this page's response shape.

> **Insight:** Vendor-specific provider methods (not in shared interface) for vendor-specific concerns keeps multi-provider abstractions clean while letting admin tools use vendor-extended features. The shared interface stays "what every video provider must do"; vendor-specific public methods sit alongside.

---

### `dist/server/wrangler.json` Is the Source of Truth for `wrangler deploy` Targeting
**Date:** 2026-05-15 Conv 161

`npm run deploy:staging` script reads `CLOUDFLARE_ENV=staging ENVIRONMENT=staging npm run build && wrangler deploy` — no `--env staging` flag on the wrangler invocation. The `@astrojs/cloudflare` adapter generates `dist/server/wrangler.json` at build time, scoped to whichever env is named in `CLOUDFLARE_ENV`. `wrangler deploy` reads that generated file, not the project's `wrangler.toml`. Env selection happens at build time, not at the CLI step.

**Rationale:** The wrangler.toml comment on line 109 suggested `--env staging` should appear on the deploy command, prompting a script-vs-doc audit. Inspection of `dist/server/wrangler.json` confirmed `targetEnvironment: staging`, `name: peerloop-staging`, D1 `peerloop-db-staging`, R2 `peerloop-storage-staging` — script is safe; the wrangler.toml comment is misleading.

**Consequences:** When auditing any Astro + Cloudflare deploy script, check the generated `dist/server/wrangler.json` over the source `wrangler.toml`. Reaffirms Conv 114's "Environments selected at build time via `CLOUDFLARE_ENV`" rule with a concrete verification recipe.

**See:** `src/astro.config.mjs:33` (adapter comment), `wrangler.toml:109`, `dist/server/wrangler.json` (generated)

---

### System Feed (formerly Townhall / The Commons) Is Admin-Only
**Date:** 2026-06-10 Conv 259

With the feeds model adopted, the former "Townhall" feed / "The Commons" community becomes the unnamed **System feed**, the domain of Admins only. SYS-RENAME executed in two boundaries: **C** — a mechanical `feed_type 'townhall'→'system'` enum rename (schema CHECKs, ~21 source files, dev seed, `getTownhall→getSystemFeed`, FeedActivityCard style keys, affected tests; the D1 enum renamed while the Stream feed group stays `'townhall'`, since the two are decoupled identifiers); then **A** — admin-only lockdown: `getFeeds` surfaces System only to admins, member candidate query + badge counts exclude System (`is_system=0`), `/community/the-commons` 404s non-admins, the `/communities` pin removed, `GET/POST /api/feeds/townhall` require admin (+403), and `autoJoinTheCommons` retired (file deleted, 3 callers removed). The Announcement data model + member/visitor fan-out is deferred to [ADMIN-FEED-UI] #33 — so interim, members get NO System broadcast until that ships (acceptable pre-launch). Cosmetic route/Stream/component/label rename split into [SYS-NAMING] #36.

**Rationale:** Keeps each step small/verifiable; the announcement model genuinely belongs to ADMIN-FEED-UI; avoids a half-built announcement column. New admin-only-feed pattern: gate at `getFeeds` (isAdmin), member candidate query (`is_system=0`), badge query (`is_system=0`), community detail page (404), and feed API endpoints (`isUserAdmin`).

---

### Promotion Launch Gate = Shared Password (Admin-Managed via /admin/*), Payment Deferred
**Date:** 2026-06-10 Conv 259

Promotion is free to everyone at launch but gated behind a stored shared password, changeable only by Admins via an `/admin/*` interface. Stripe payment is deferred to a later phase. The `/admin/*` password UI is folded into [ADMIN-FEED-UI] #33; the policy/build is tracked on [PROMOTE-PIPELINE] #32 with 4 OPEN clarifications (global-vs-per-level, per-promotion-vs-session, storage+hashing, which escalation levels gated) to resolve before building.

**Rationale:** Lightweight launch access-control — admins distribute/rotate the password to trusted promoters — without building payment first.

---


### PromoteNudge Engagement Gate = Configurable `promo_nudge_min_engagement` Dial
**Date:** 2026-06-13 (Conv 278)

The workspace PromoteNudge (prompts a creator/teacher to run an EntityPromo) self-gates on entity traction via a new `promo_nudge_min_engagement` `platform_stats` dial (default 3), admin-editable in the existing `/admin/promotion-settings` page alongside the active-duration + retention dials. The gate is on *nudging*, not *promoting* — the `EntityPromoComposer` it reveals still lists every promotable entity; the floor only governs the unprompted nudge. Engagement signal = `courses.student_count` / `communities.member_count`; `GET /api/feeds/promotable-entities` extended with per-entity `engagementCount` + top-level `minEngagement`; nudge renders nothing unless the viewer owns ≥1 entity clearing the floor; 0 = always nudge. Mounted on `/creating` + `/teaching` overview, mirroring the self-gating ProgressionNudge. Rejected: capability-only (nudges empty entities), hardcoded fixed threshold (no admin control).

**Rationale:** Follows the established promotion-dial pattern (lifecycle dials already live in `platform_stats`, edited on the same admin page), so admin tunability is near-free and consistent; gating the *prompt* (not the action) keeps the manual composer fully open while preventing low-value nudges.
