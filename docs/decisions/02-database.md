> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 2. Database & Data Model (High Impact)

### PROMOTE-PIPELINE Lineage: Dedicated `post_promotions` Event Table + Role Matrix
**Date:** 2026-06-10 (Conv 262)

Post-promotion stores lineage in a **dedicated `post_promotions` event table** (not columns-only) plus a `feed_activities.promoted_from_activity_id` reference column. Promoter eligibility uses a **role matrix** (admin / creator / certified-teacher), not admin-only. Promotion creates a **NEW activity** in the target feed referencing the source — it is not a move. The course→community link traverses progression: `courses.progression_id → progressions.community_id` (nullable `progression_id` ⇒ no parent community ⇒ not promotable). Feeds are dual-keyed: D1 `feed_activities.feed_id` uses slug (`'the-commons'` for system) while Stream `feed()` uses `community.id` (or `'main'`/group `'townhall'` for system); `resolvePromotionTarget` returns both keyings.

**Rationale:** Durable picks — payment, the Promoted lane, and audit all need an event record; the role matrix is the real end-state (admin-only would be throwaway). The `src/lib/promotion/` module mirrors `src/lib/discovery-rails/` (typed module + barrel + pure-D1 functions + colocated tests).

**See:** `migrations/0001_schema.sql`, `src/lib/promotion/{target,permissions,promote}.ts`.

### Session↔Module is 1:1; Matt's nested "Module" Means Sub-Module
**Date:** 2026-05-24 (Conv 188)

Every 1-on-1 session has exactly one Module. Matt's (and creators') Modules-frame language that groups "N Modules" under a single "1-on-1 Session" is a terminology misuse — those nested items are **Sub-Modules**, a subdivision that happens *within* the single session/Module. There is NO session→many-modules data model, and none will be added to the schema.

**Rationale:** User clarified the real product model when Matt's Modules frame appeared to conflict with the 1:1 session-module design (raised as [MOD-SCHEMA]). The subdivision a creator handed Matt still occurs inside one session; no new grouping table is warranted.

**Consequences:** [MOD-SCHEMA] resolved (no schema change); [MODTAB] builds each Modules-tab card as one session/Module carrying an inner "N Sub-Modules" count. Captured in `memory/project_module_submodule_model.md`.

### COMMUNITY-RESOURCES schema parity with session_resources
**Date:** 2026-04-14 (Conv 117)

`community_resources` table restructured pre-launch to match `session_resources` shape: replaced `url NOT NULL` + `file_size` with nullable `r2_key` + `external_url` + `size_bytes` + `mime_type`. Aligned `type` CHECK values with session_resources (`document/image/audio/video_link/other`). Direct edit to `migrations/0001_schema.sql` — no `0003_*.sql` added.

**Rationale:** Client-reported bug (CB3) exposed that `community_resources` could not represent file uploads — single `url` column was overloaded. Session_resources already solved this cleanly. Asymmetry was the bug; removing it removes the need for workaround code. Pre-launch convention is direct-edit.

**Consequences:** Local D1 reset + migrate clean. All 6 SSR Astro callers + `CommunityTabs` + tests updated for new type enum. Staging needs reset+migrate on next deploy. Enables cross-table helpers and shared upload UI between community and session resources.

### COMMUNITY-RESOURCES pre-computed `downloadUrl` in SSR loader
**Date:** 2026-04-14 (Conv 117)

SSR loader (`src/lib/ssr/loaders/communities.ts`) pre-computes a `downloadUrl` field per resource: `r2_key ? '/api/community-resources/{id}/download' : external_url`. Components render `href={resource.downloadUrl}` blindly, not knowing whether the URL streams from R2 or passes through to an external link.

**Rationale:** Loader becomes single source of URL-shape truth. Components stay dumb. Tests assert one field instead of three.

---

### Community member/resource role types narrowed to `'creator' | 'member'`
**Date:** 2026-04-15 (Conv 123)

Post-Conv-120 (COMMUNITY-TEACHER-KILL narrowed DB CHECK to `('creator','member')`), all Astro/TSX types still permitted a third `'teacher'` value via a shared `transformRole()` helper. Narrowed `CommunityMembership.role`, `CommunityDetailMember.role`, `CommunityDetailResource.uploadedBy.role`, `CommunityListItem.membership.role`, `CommunityTabs.Member.role`, `CommunityTabs.Resource.uploadedBy.role` to `'creator' | 'member'`. Deleted `transformRole` from 6 Astro pages. `RoleBadge` collapsed from 3-key config lookup to a single conditional.

**Rationale:** The helper encoded a dead branch matching the pre-Conv-120 DB state — a future trap if the 3-value type later ambiguously re-entered the codebase. Explicit type narrowing + `as 'creator' | 'member'` casts at 4 DB-row mapping sites closes the migration fully.

**Consequences:** 18 Astro/TSX edits; all 5 baselines green (tsc, astro check, lint, 6447 tests, build). `CommunityTabs.Resource.uploadedBy.role` set-but-not-read flagged as micro-cleanup follow-up. Pattern: when a config-lookup component's type narrows to one meaningful key, the lookup disappears.

### COMMUNITY-TEACHER-KILL: retire `community_members.member_role='teacher'`
**Date:** 2026-04-14 (Conv 119)

`community_members.member_role` CHECK narrows from `('creator','teacher','member')` to `('creator','member')`. No application code ever writes `'teacher'` — 3 INSERT sites hardcode `'creator'` or `'member'`, dev seed was the only source. All 20+ consumers (6 Astro `canUploadResources` gates, `CommunityTeachingTab.tsx`, `CommunityRolePillFilters.tsx`, `ExploreCommunities.tsx` teachingCount, `CommunityManagement.tsx` badge, TS types) either drop the check or re-derive from `teacher_certifications`.

**Rationale:** The value was unreachable from app code but silently populated by dev seed, so dev UI showed populated "Teaching" tabs/pills/badges while prod showed empty. A schema CHECK that permits a value no writer produces is dead code; killing it removes the source of the drift. Auto-maintaining it from `teacher_certifications` would add a sync surface for a concept already course-scoped. Tracked as PLAN task #28; blocks #18, #19, #26.

---

### "Teachers in community X" re-derived from `teacher_certifications JOIN courses ON community_id`
**Date:** 2026-04-14 (Conv 119)

The "Communities where I'm teaching" UX (discover tab, role pill filter, teachingCount badge) is retained but recomputed from `teacher_certifications` joined to `courses` by `community_id`, rather than read from `community_members.member_role='teacher'` (which is being killed — see above).

**Rationale:** Teacher is course-scoped per `GLOSSARY.md`; the data already exists in `teacher_certifications`. `CurrentUser.teacherCertifications` carries course metadata client-side, so a derived getter (e.g., `getTeachingCommunityIds()`) can satisfy client gates without new API surface. This is a computation change, not a feature scope change.

---

### TAG-TAXONOMY: categories→topics, topics→tags, drop courses.category_id
**Date:** 2026-03-28 (Conv 048)

Renamed `categories` → `topics` (15 display groups), `topics` → `tags` (55 atomic items). Dropped `user_interests`, `user_topic_interests`, `experience_level`. Repurposed `course_tags` from free-text to FK-based many-to-many. Dropped `courses.category_id` — course-topic relationships derived via `course_tags → tags.topic_id`.

**Rationale:** Original 5-table taxonomy (categories, topics, user_topic_interests, user_interests, course_tags) had confusing near-synonym names and redundant data paths. User mental model: "tags are things you attach, topics are groups you browse by." Multi-tag courses enable cross-topic discovery. Smart feed scoring moves from binary category match to graduated tag overlap.

**Consequences:** ~30 source files + ~150 test files across 6 implementation phases. Breaking change — app non-functional between Phase 1 (schema) and Phase 5 (components).

> **Insight:** Schema naming that mirrors the user's vocabulary rather than database-design conventions reduces cognitive load across the entire team. Map every table/column to its actual readers — columns written but never read are dead weight.

### TAG-TAXONOMY API: Clean Break Naming, No Aliases
**Date:** 2026-03-28 (Conv 049)

All API parameters, response fields, and variable names use new taxonomy terms (`topics`, `tags`, `topicId`, `tagId`) with zero backward-compatibility aliases. `?category=` → `?topic=`, `category_id` removed from all responses, course detail views return `tags: {id, name, topic_id}[]` instead.

**Rationale:** No external consumers depend on these API shapes yet (pre-launch). Aliases create ambiguity about which naming is "current" and accumulate as tech debt. User directive: "actively remove conveniences like aliases unless they have strategic benefit."

**Consequences:** Every frontend component fetching taxonomy data needs updating (Phase 5). Server-side topic filtering uses EXISTS subqueries through `course_tags → tags → topics` instead of direct `category_id` match.

### Schema Column Naming Convention
**Date:** 2026-03-05 (Session 346)

Adopted conventions for all schema columns: entity PKs keep `id`; FKs referencing users use `{role}_id`; actor columns use `{action}_by_user_id`; booleans use `is_`/`has_` prefix; scoped roles prefix with domain (`member_role` not `role`).

**Trigger:** `st.id` (per-course certification record) was used where `user_id` (per-person) was needed, causing duplicate teacher cards. The ambiguous column name masked the semantic error.

**Consequence:** ~926 column rename occurrences planned across schema, src, and tests. Organized as Phase 3 of TERMINOLOGY block. Includes SQL sweep for latent bugs.

**See:** `GLOSSARY.md` §4, PLAN.md TERMINOLOGY.SCHEMA

### DATE-FORMAT: Canonical Date/Time Storage and Display
**Date:** 2026-03-18 (Conv 010)

All timestamps are stored as **UTC ISO 8601 with Z suffix**: `2026-03-18T23:41:25Z`. No exceptions.

**Storage rules:**
- Application code must use `toUTCISOString()` from `src/lib/timezone.ts` when writing timestamps
- Schema defaults use `strftime('%Y-%m-%dT%H:%M:%fZ', 'now')` (`%f` = `SS.SSS` for millisecond precision matching JS)
- Seed data must use ISO 8601 with Z: `'2024-09-10T00:00:00Z'`, not `'2024-09-10 00:00:00'`
- Date-only values (e.g., `certified_date`) still use full ISO 8601 at midnight UTC: `'2024-01-15T00:00:00Z'`

**Display rules — never use raw `toLocaleDateString()`:**

| Function | Use for | Example output |
|----------|---------|----------------|
| `formatDateUTC(str, 'short')` | Date-only values (completed_at, certified_date) | `3/18/2026` |
| `formatDateUTC(str, 'medium')` | Date-only with month name | `Mar 18, 2026` |
| `formatDateUTC(str, 'long')` | Formal date display | `March 18, 2026` |
| `formatDateTimeUTC(str)` | Admin timestamps, audit logs | `Mar 18, 2026, 11:41 PM` |
| `formatLocalTime(str, tz)` | Session times (user's timezone matters) | `{ date: 'Monday, March 18', time: '4:41 PM' }` |

**Why:** SQLite's `datetime('now')` produces `2026-03-18 23:41:25` (no timezone marker). JavaScript's `new Date()` parses this as **local time**, but ISO strings with `Z` as **UTC**. Mixing formats causes dates to shift by ±1 day depending on the browser's timezone. A single canonical format eliminates the ambiguity.

**Migration complete (Conv 011):** 130+ files migrated across 5 phases — schema defaults (66), seed data (6), app writes (49 `datetime('now')` + 17 `now()` deprecation), display (58 components), verification (5901 tests passing). `now()` in `db/index.ts` marked `@deprecated` — use `toUTCISOString()` from `timezone.ts` instead.

**DATETIME-FIX addendum (Conv 027):** The Conv 011 migration converted all INSERT/UPDATE writes to ISO format but missed **read-side comparisons**. Six SQL queries used `datetime('now', '-7 days')` (space at position 10) to compare against stored ISO values (T at position 10). Since `T` (ASCII 84) > ` ` (ASCII 32) in lexicographic comparison, these comparisons were always true — silently returning all rows instead of the intended time window. Fixed by replacing `datetime('now', ...)` with `strftime('%Y-%m-%dT%H:%M:%fZ', 'now', ...)` in all comparisons. `date('now', ...)` comparisons are safe (10-char prefix sorts correctly). See `docs/reference/DB-GUIDE.md` § "SQLite DateTime Comparison Caveat".

**DATETIME-FIX addendum 2 (Conv 028):** Found the same bug in **datetime arithmetic comparisons**: `datetime(s.scheduled_end, '+1 hour') < ?` in `detectStaleInProgress()` and `datetime(?, '-5 minutes')` in `reconcileBBBSessions()`. Both fixed with `strftime('%Y-%m-%dT%H:%M:%fZ', ...)`. Added dual defense: CLAUDE.md "SQLite Datetime Rule" section (prevents AI-authored code) + `/w-codecheck` check #5 (grep-based lint, catches manual edits). Edge-case test added for the 1-hour grace period.

All formatting functions live in `src/lib/timezone.ts`. The `parseUTCDate()` bridge handles both old and new formats for any residual data.

### User Role System - Capabilities + Course Relationships
**Date:** 2026-02-02 (Session 161, supersedes 2026-01-29)

User permissions split into two categories:

**Capability Flags (what you CAN do):**
- `can_create_courses` - permission to author courses (admin grants)
- `can_take_courses` - permission to enroll (default: true)
- `can_teach_courses` - permission to be certified as teacher (admin grants)
- `can_moderate_courses` - permission to be granted mod rights (admin grants)
- `is_admin` - global admin flag (NOT course-specific)

**Course Relationships (what you ARE for specific courses):**
- `teacher_certifications`[^tc] table - teacher certification per course
- `enrollments` table - student status per course

**Removed from Schema (Session 161):**
The following deprecated flags have been REMOVED from the schema entirely:
- `is_student` - use `can_take_courses` capability
- `is_teacher`[^it] - derive from `teacher_certifications`[^tc] table
- `is_creator` - derive from `courses` table (see Permission vs State below)
- `is_moderator` - will be course-specific (future)

**Rationale:** Separates "capabilities" (admin-controlled permissions) from "roles" (course-specific relationships). A user can be a student for Course A and Teacher for Course B. Keeping deprecated flags (even with comments) led to code using the wrong fields. Removing them forces correct usage.

**See:** `src/lib/current-user.ts`, `migrations/0001_schema.sql`

### Permission vs State: The Critical Distinction
**Date:** 2026-02-02 (Session 162)

There are TWO distinct concepts that were conflated in the old `is_creator` and `is_teacher`[^it] flags:

| Concept | Type | Meaning | Storage | Can be revoked? |
|---------|------|---------|---------|-----------------|
| **Permission** | Future-looking | Can user do X? | `users.can_*` columns | Yes (admin) |
| **State** | Backward-looking | Has user done X? | Derived from tables | No (historical fact) |

**For Creators:**
- `can_create_courses = 1` → User has permission to create new courses (admin grants)
- `is_creator` (derived) → User has created course(s): `EXISTS (SELECT 1 FROM courses WHERE creator_id = ?)`

**For Teachers:**
- `can_teach_courses = 1` → User has permission to become a teacher (admin grants)
- `is_teacher`[^it] (derived) → User is certified for course(s): `EXISTS (SELECT 1 FROM teacher_certifications[^tc] WHERE user_id = ? AND is_active = 1)`

**Key Scenario - The Revoked Creator:**
```
User creates courses → is_creator = YES (historical fact)
Admin revokes permission → can_create_courses = 0
Result: User can't create NEW courses, but existing courses remain valid
        User should still access Creator Dashboard to manage existing courses
```

**Access Control Pattern:**
```sql
-- Creating new course: permission only
WHERE can_create_courses = 1

-- Creator dashboard access: permission OR has courses
WHERE can_create_courses = 1
   OR EXISTS (SELECT 1 FROM courses WHERE creator_id = user_id)

-- Browse Creators page: has courses only
WHERE EXISTS (SELECT 1 FROM courses WHERE creator_id = user_id AND deleted_at IS NULL)
```

**UI Pattern for "Create Course" button:**
- Always visible (consistency)
- Enabled only if `can_create_courses = 1`
- Disabled state shows tooltip explaining requirement

**Rationale:** This distinction allows admins to revoke creation permission while preserving existing work. A creator's courses don't disappear when they lose permission - they just can't create more.

**See:** Implementation plan in `docs/sessions/2026-02/2026-02-02_Session-162_Implementation-Plan.md`

### Creator Auto-Added as Teacher with Self-Service Control
**Date:** 2026-01-29 (Session 148)

When a Creator creates a course, they are automatically added as a Teacher for that course. The Creator can then add or remove themselves as a teacher for their own course via self-service.

**Business Rules:**
- Creator must have `can_teach_courses=1` to be eligible for auto-teacher assignment
- Creator is auto-added as teacher when course is created
- Creator can opt out (remove themselves as teacher) at any time
- Creator can re-add themselves as teacher later

**Rationale:** Most Creators will want to teach their own course initially. Self-service control allows them to step back and let other teachers handle teaching without admin intervention.

**See:** `migrations/0002_seed.sql` (Guy/Gabriel have `can_teach_courses=1`)

### D1 as Canonical Source for Data
**Date:** 2025-12-29

D1 schema is the canonical source of truth. `mock-data.ts` syncs TO D1, not vice versa.

**Rationale:** D1 migrations define canonical data; runtime mapping adds unnecessary complexity.

### Migration Architecture - Production-Safe Split Seeds
**Date:** 2026-02-05 (Session 190, supersedes 2025-12-30)

Split migrations for production safety:

```
migrations/              # PRODUCTION-SAFE (applied everywhere)
├── 0001_schema.sql      # Table definitions
└── 0002_seed_core.sql   # Essential data only (topics, tags, admin, The Commons)

migrations-dev/          # DEV ONLY (local + staging only)
└── 0001_seed_dev.sql    # Test users, courses, communities
```

**Commands:**
- `npm run db:setup:local` - Full setup with test data
- `npm run db:setup:local:clean` - Production-like (no test data)
- `npm run db:migrate:prod` - Requires typing "production" to confirm
- `npm run db:seed:prod` - **BLOCKED** (errors immediately)
- `npm run db:reset:prod` - **BLOCKED** (errors immediately)

**Rationale:** Production should never have test data. Blocking commands is safer than confirmation prompts. Separate directories ensure dev seed is never in production migration path.

**See:** `docs/as-designed/migrations.md`, `migrations/README.md`

### Layered Dev Seed: Optional Stripe Accounts via Separate File
**Date:** 2026-02-22 (Session 247)

Stripe sandbox account IDs are in a separate, opt-in seed file rather than baked into the main dev seed:

```
migrations-dev/
├── 0001_seed_dev.sql        # Users with NULL Stripe fields (automatic)
└── 0002_seed_stripe.sql     # Real Stripe sandbox acct_ IDs (opt-in)
```

**Commands:**
- `npm run db:setup:local` — Full setup, all users have NULL Stripe (test onboarding flows)
- `npm run db:seed:stripe:local` — Apply real Stripe account IDs (test payment flows)
- `npm run db:seed:stripe:staging` — Same for staging D1

**Users covered:** Guy Rymberg (creator), Sarah Miller (teacher), Marcus Thompson (teacher) — enables full creator→teacher payment split testing.

**Key convention:** `0002_seed_stripe.sql` uses only UPDATE statements (not INSERTs). Users must exist from `0001` first. Placeholder `acct_REPLACE_*` values must be replaced with real Stripe test-mode Express account IDs from the Stripe Dashboard.

**Also:** Removed fake mock IDs (`acct_mock_sarah`, `acct_mock_marcus`) from `0001_seed_dev.sql`. Mock IDs passed `IS NOT NULL` checks but failed at runtime against Stripe API — a phantom state that masked real integration issues.

**Rationale:** Base seed should represent honest application state (no Stripe = not onboarded). Stripe accounts are test infrastructure, not core dev data. Separation allows testing both flows: fresh-install (no Stripe) and payment testing (with Stripe).

**See:** `migrations-dev/README.md`, `migrations-dev/0002_seed_stripe.sql`

### Dev Seed Must Exercise Nullable-but-Gated Columns
**Date:** 2026-05-20 (Conv 163)

When a feature is gated on a nullable column being non-NULL (e.g., recording-link surfaces gated on `sessions.recording_url IS NOT NULL`), the dev seed must populate at least one row that exercises the gated state. Otherwise every developer testing that feature does the same hand-population dance. Canonical pattern: `migrations-dev/0001_seed_dev.sql` ends with `UPDATE sessions SET recording_url = '<real Blindside URL>' WHERE id = 'ses-sarah-n8n-1'` so every fresh local DB has one recording-having session that exactly mirrors the equivalent staging session (same student/teacher/course slug/scheduled date).

**Rationale:** Pre-Conv 163 the seed had `recording_url TEXT` defined on `sessions` but the INSERT statements omitted the column — every seeded session shipped with NULL, and the surfaces under test were invisible. "Switch from staging to local for this same flow" is frictionless only when the local data matches by exact identity, not near-match (mismatched course slug shows differently in the UI).

**Consequences:** Future seeds for nullable-but-gated columns should follow the same UPDATE-at-end pattern. When adding a new gated feature, audit `migrations-dev/0001_seed_dev.sql` for at least one row exercising the gated state.

**See:** `migrations-dev/0001_seed_dev.sql` (Sarah/Guy/Intro-to-n8n session block + final UPDATE)

### INSERT OR IGNORE for Idempotent Migrations
**Date:** 2025-12-29

Use `INSERT OR IGNORE INTO` for all seed data inserts.

**Rationale:** Handles composite unique constraints better; fully idempotent; safe to re-run.

### Soft Delete Strategy
**Date:** 2025-12-29

Use soft delete with `deleted_at` timestamp for users, courses, enrollments. Added fields: `deleted_at`, `suspended_at`, `suspended_reason`.

**Rationale:** Preserves audit trail; allows recovery; maintains referential integrity.

### Dual-Machine D1 Development
**Date:** 2025-12-27
**Superseded:** 2026-02-19 — MBA-2017 retired, replaced by MacMiniM4. Both machines (MacMiniM4-Pro, MacMiniM4) now have full local D1 support. REST API fallback removed.
**Renamed:** 2026-05-21 (Conv 168 [MND]) — `MacMiniM4-Pro` → `MacMiniM4Pro` (no hyphen).

- MacMiniM4Pro: Use local D1 (`--local`)
- MacMiniM4: Use local D1 (`--local`)

**Rationale:** Both machines share same `wrangler.toml`; local and remote databases are completely separate.

### Local Dev Server Against Remote Staging D1
**Date:** 2026-02-21 (Session 236)

Use `npm run dev:staging` to run the local Astro dev server connected to the remote staging D1 database. Implemented via an env-var-gated `platformProxy` option in `astro.config.mjs`: when `USE_STAGING_DB=1`, the Cloudflare adapter calls `getPlatformProxy({ environment: 'preview', remoteBindings: true })`, which uses the `[env.preview]` D1 binding (`peerloop-db-staging`).

**Trigger:** Need to reproduce bugs that staging users report, using the same data they see.

**Options Considered:**
1. Separate `astro.config.staging.mjs` — duplicates most config
2. `wrangler pages dev dist --remote` — requires build step, loses HMR ← Rejected
3. Env-var-gated `platformProxy` in existing config ← Chosen

**Rationale:** Single config file, no build step, preserves hot-reload, zero impact on default `npm run dev`. Note: writes from local dev **modify the staging database**.

> **Insight:** The Astro Cloudflare adapter's `platformProxy` option is a direct passthrough to wrangler's `getPlatformProxy()`. This means any option wrangler supports (environment selection, remote bindings, custom config paths) is available without Astro-specific configuration. The adapter is thinner than it appears. (Session 236)

**See:** `astro.config.mjs`, `package.json` (`dev:staging` script)

### D1 Reset Strategy - Schema-Driven Drop Order
**Date:** 2026-01-24

Reset D1 databases by parsing `0001_schema.sql` to determine FK dependencies, then dropping tables in reverse dependency order (children before parents).

**Implementation:**
- **Local D1:** Delete SQLite files directly (`.wrangler/state/v3/d1/miniflare-D1DatabaseObject/*.sqlite*`)
- **Remote D1:** Parse schema for `REFERENCES` clauses, topological sort, drop in reverse order

**Options Considered:**
1. `PRAGMA foreign_keys = OFF` ← **Doesn't work** - D1 enforces at platform level
2. `PRAGMA defer_foreign_keys = ON` ← **Doesn't help DROP TABLE** - only defers constraint check
3. Schema-driven dependency order ← **Chosen**

**Rationale:** D1's foreign key enforcement is immutable. The only reliable approach is to respect the FK graph. Parsing the schema file makes `0001_schema.sql` the single source of truth for both creation AND destruction order. Self-maintains as schema evolves.

**See:** `scripts/reset-d1.js`, [Cloudflare D1 Foreign Keys docs](https://developers.cloudflare.com/d1/sql-api/foreign-keys/)

### Three-Table Moderation Design
**Date:** 2026-01-21

Content moderation uses three separate tables instead of a single monolithic table:
- `content_flags` - Flagged content with cached snapshot and review status
- `moderation_actions` - Log of every action taken (dismiss, remove, warn, suspend)
- `user_warnings` - Warning records linked to users for escalation tracking

**Rationale:** Multiple actions can occur per flag; warning history needed for escalation decisions; clear separation of concerns aids querying and maintenance.

**See:** `migrations/0013_moderation.sql`, `src/pages/api/admin/moderation/`

### Two-Tier Rating System (User vs Course-Specific)
**Date:** 2026-02-04 (Session 178)

Ratings are stored at two distinct levels:

| Level | Table | Purpose | Updated By |
|-------|-------|---------|------------|
| **User-level** | `user_stats.average_rating` | Overall rating across all roles | Session ratings |
| **Teacher-course-level** | `teacher_certifications.rating`[^tc] | Rating for teaching specific course | Completion reviews only |

**Session ratings** (`session_assessments`) are diagnostic - quick pulse checks after each session. They update `user_stats` but do NOT affect teacher profile ratings.

**Completion reviews** (`enrollment_reviews`) are evaluative - comprehensive feedback when student completes the full course journey. These alone feed into `teacher_certifications.rating`[^tc].

**Rationale:** Session ratings are noisy and don't reflect overall experience. Completion reviews provide meaningful, comparable data for teacher profiles. Matches how Airbnb/Coursera work (rate after experience ends).

**See:** `src/pages/api/enrollments/[id]/review.ts`, `src/pages/api/sessions/[id]/rating.ts`

### Topics Table (Hybrid Taxonomy) for Onboarding
**Date:** 2026-02-22 (Session 252)

> **Superseded by TAG-TAXONOMY (Conv 048).** The `topics` table was renamed to `tags`, `categories` renamed to `topics`, and `user_interests`/`user_topic_interests` replaced by `user_tags`. See the Conv 048 decision above.

~~New `topics` table provides curated subtopics linked to parent categories. Used for member onboarding interest selection and future discover page filtering. ~55 topics (3-5 per category), admin-controlled.~~

~~**Rationale:** More structured than freeform `course_tags` (curated, consistent) but lighter than a full subcategories hierarchy. Existing `user_interests` table kept as-is; onboarding also syncs topic names there for backward compatibility.~~

**See:** `migrations/0001_schema.sql` (topics/tags tables), `migrations/0002_seed_core.sql` (topic/tag seeds)

### Separate member_profiles Table for Onboarding Data
**Date:** 2026-02-22 (Session 252)

Onboarding questionnaire answers (goal_learn, goal_teach, referral_source, profession, onboarding_completed_at) stored in a separate `member_profiles` table keyed by `user_id`, not as additional columns on `users`.

**Rationale:** The `users` table (30+ columns) is read on every authenticated page load via `/api/me/full`. Only `onboarding_completed_at` is surfaced in `CurrentUser` (via LEFT JOIN) for conditional navbar menu visibility. Keeps onboarding concerns isolated.

**See:** `src/pages/api/me/full.ts` (LEFT JOIN), `src/lib/current-user.ts` (hasCompletedOnboarding)

### Community Recommendations via Transitive Progression Chain
**Date:** 2026-02-22 (Session 259)

> **Partially superseded by TAG-TAXONOMY (Conv 048).** The old transitive chain via `category_id` no longer exists. `courses.category_id` was dropped; course-topic relationships now go through `course_tags → tags.topic_id → topics`. The recommendation logic in `src/pages/api/recommendations/communities.ts` may need updating to use the new tag-based path: `user_tags → tags.topic_id → topics → course_tags → courses.progression_id → progressions.community_id → communities`.

~~Communities don't have a direct `category_id`. Recommendations match transitively through existing relationships: `user_topic_interests` → `topics.category_id` → `courses.category_id` → `courses.progression_id` → `progressions.community_id` → `communities`.~~

~~**Rationale:** The schema already models this relationship — courses belong to categories AND progressions, progressions belong to communities. Using the existing chain avoids schema changes and naturally aligns with the platform's content structure. Falls back to popular communities when no transitive matches exist.~~

**See:** `src/pages/api/recommendations/communities.ts`

### Separate availability_overrides Table for Date-Specific Changes
**Date:** 2026-02-25 (Session 287)

Recurring availability rules stay in the `availability` table (keyed by `day_of_week`). Date-specific overrides (vacations, extra hours, blocked days) go in a new `availability_overrides` table (keyed by specific `date`). Calendar rendering: expand recurring rules for the visible month → overlay overrides → show merged result.

**Rationale:** Different data shapes — recurring has `day_of_week` (0-6), overrides have a specific ISO date. Combining them in one table requires nullable columns and `is_recurring` filtering on every query. Separate tables give clean queries and clear semantics.

**See:** `CURRENT-BLOCK-PLAN.md` (S-T-CALENDAR.SCHEMA section)

### Per-Course teaching_active Toggle for Creator-as-Teacher
**Date:** 2026-02-25 (Sessions 287, 289)

Add `teaching_active INTEGER NOT NULL DEFAULT 1` to `teacher_certifications`[^tc] table alongside existing `is_active`. Two independent boolean states controlled by different actors: `is_active` (admin-controlled certification) and `teaching_active` (user-controlled booking visibility). When `teaching_active=0`, the availability endpoint returns empty slots with `teaching_paused: true`. When `is_active=0`, the toggle endpoint returns 403.

**Rationale:** `teacher_certifications`[^tc] is already one-row-per-course, so per-course is the natural granularity. Separate columns avoid conflating admin authority with user preference. The toggle endpoint only writes `teaching_active`; admin endpoints only write `is_active`.

**See:** `docs/as-designed/availability-calendar.md`, `src/pages/api/me/teacher/[courseId]/toggle.ts`

### Availability is Per-Person (user_id), Not Per-Course
**Date:** 2026-02-25 (Session 288)

Availability tables (`availability`, `availability_overrides`) use `user_id` referencing `users(id)`. No `course_id` column. A teacher's time is personal — they can't teach two courses simultaneously. Per-course opt-in/out is handled by `teaching_active` on `teacher_certifications`[^tc].

**Rationale:** Simpler UX (one calendar), no cross-course double-booking risk, matches existing codebase pattern where all scheduling tables use `user_id`. CERT-AUDIT added to PLAN.md deferred queue for future `st_id` audit trail work.

**See:** `CURRENT-BLOCK-PLAN.md` (Schema Changes section, Session 288 decision note)

### DST-Safe Week Counting for Recurring Availability
**Date:** 2026-02-25 (Session 289)

Calendar-week boundaries must use calendar-day math (`Math.round(ms / msPerDay)` then `/7`), not millisecond division (`ms / msPerWeek`). DST transitions add/remove an hour, causing `Math.floor` on raw milliseconds to under/over-count weeks. Applied in both `availability-utils.ts` (client-side merge) and `teachers/[id]/availability.ts` (server-side slot generation).

**Rationale:** US spring forward (March 8, 2026) caused a 2-week recurring rule to incorrectly include week 3. `Math.round` on the day difference absorbs the ~1 hour DST shift without requiring a date library.

**See:** `docs/as-designed/availability-calendar.md` (DST-safe week counting section)

### Override Merge: Full Replacement, Not Layering
**Date:** 2026-02-25 (Session 288)

When `availability_overrides` exist for a date, they fully replace recurring rules for that date. Blocked overrides produce zero slots. Available overrides produce only the override's time range — the original recurring slot is suppressed.

**Rationale:** Simpler mental model: "I overrode March 15" means only override times show, not a confusing mix. Implemented in `availability-utils.ts` `buildMonthView()` and `GET /api/teachers/[id]/availability`.

---

### enrollments.assigned_teacher_id[^at] Stores users.id (Not teacher_certifications[^tc].id)
**Date:** 2026-03-04 (Session 324)

The `enrollments.assigned_teacher_id`[^at] FK references `users(id)` (`usr-xxx`), not `teacher_certifications(id)`[^tc] (`st-xxx`). The checkout→webhook pipeline was inserting `teacher_certifications.id` causing FK violations. Fixed by resolving `tc.id` → `tc.user_id` in `create-session.ts` and passing both IDs through Stripe metadata: `teacher_certification_id` (st-xxx, for webhook JOINs) and `assigned_teacher_id` (usr-xxx, for enrollment FK).

**Rationale:** 10+ existing consumers (admin, analytics, reviews, reassign-teacher) already correctly use `usr-xxx`. Fixing the pipeline at source was a 3-file change vs rewriting all consumers.

**See:** `src/lib/stripe.ts` (metadata), `src/pages/api/checkout/create-session.ts`, `src/lib/enrollment.ts`

### Positional Module Assignment for Sessions (Implemented)
**Date:** 2026-03-05 (Session 331, replaces Session 325 plan)

Module assignment is computed positionally at read time, not stored at booking time. Sort an enrollment's non-cancelled sessions by `scheduled_start ASC`; the Nth session teaches the Nth module (by `module_order`). `module_id` column added as nullable — NULL while `scheduled` or `in_progress` (computed dynamically), set permanently when session transitions to `completed` via BBB webhook. Sequential completion enforced: if earlier sessions are still `scheduled`, the completing session gets `module_id = NULL` (out-of-order guard).

**Trigger:** Session 325 planned storing `module_id` at booking time. During Session 331 design, realized cancellations cause stored module_ids to go stale — if session 2 of 3 is cancelled, session 3 should shift to cover module 2 automatically.

**Rationale:** Late binding keeps module order always sequential without data migration on cancellation. The computation cost (3 queries + zip) is negligible for enrollment-scoped data (3-10 sessions). Cancellation reflow is automatic.

**Implementation:** `src/lib/booking.ts` provides `resolveModuleAssignments()` as single source of truth. Session limit enforced: 422 when `completed + scheduled >= module count`. Cancelled sessions free slots. All API responses include computed module info.

**Frozen vs computable split (Session 332):** Sessions are classified as "frozen" (has non-null `module_id`) vs "computable" (null `module_id`), not by status. An `in_progress` session hasn't had its `module_id` written yet (that happens in the BBB webhook on completion), so it must be positionally computed like `scheduled` sessions.

> **Insight:** This is a form of late binding — deferring the module-to-session relationship until the last possible moment (read time for scheduled, completion time for historical). It avoids the classic problem of stored denormalized data going stale, at the cost of a small per-read computation that's negligible for the data volumes involved. (Session 331)

**See:** `src/lib/booking.ts`, `src/pages/api/webhooks/bbb.ts`, `docs/as-designed/session-booking.md`

### Session Completion Healing — Shared `completeSession()` Function
**Date:** 2026-03-05 (Session 334)

Extracted session completion logic from BBB webhook `handleRoomEnded` into a shared `completeSession(db, sessionId, endedAt?)` function in `src/lib/booking.ts`. Three callers: BBB webhook, `POST /api/sessions/[id]/complete` (teacher/creator manual), admin `PATCH /api/admin/sessions/[id]`.

**Trigger:** BBB webhook `room_ended` was the only code path that completed sessions and froze `module_id`. If the webhook failed, sessions were stuck in `in_progress` with no recovery. Admin PATCH could set status but skipped module freezing, creating data gaps.

**Options Considered:**
1. Poll BBB API on a cron — BBB doesn't retain meeting info long, adds external dependency
2. Auto-complete sessions after `scheduled_end` — too aggressive, no human confirmation
3. Teacher/Creator manual endpoint + shared function ← Chosen

**Rationale:** Follows the proven Stripe enrollment healing pattern (extract shared function → multiple callers). Teachers and creators have direct knowledge of whether a session happened. No external API dependency. Idempotent — safe to call from multiple surfaces concurrently.

**Consequence:** `completeSession()` handles sequential completion checks, `module_id` freezing, and ended_at timestamp. All completion paths produce identical database state.

> **Insight:** The "extract shared function from webhook" pattern is a reliable resilience technique. Webhooks are inherently unreliable (network failures, service outages, configuration drift). By making the webhook handler a thin caller of shared logic, you create room for manual, SSR, and cron-based healing surfaces without duplicating business rules. Stripe enrollment healing proved this in Session 324; session completion now follows the same arc. (Session 334)

**See:** `src/lib/booking.ts` (`completeSession`), `src/pages/api/sessions/[id]/complete.ts`, `src/pages/api/webhooks/bbb.ts`

### Session Invite Model for Instant Booking ("Book Now")
**Date:** 2026-03-17 Conv 004

Teacher-initiated instant session booking via a Session Invite model. Teacher sends a 30-minute-expiry invite scoped to an enrollment, delivered via the existing notification system. Student accepts with one click → session created at now+5min → both redirect to session room. Two modes: new booking (bookable modules available) or reschedule (auto-cancels next upcoming scheduled session). One pending invite per enrollment at a time.

**Rationale:** Client required teacher authorization for instant booking. Notification-based delivery reuses existing infrastructure without requiring real-time signaling (WebSocket/polling). Lazy expiry (check on access, no background job) suits Cloudflare Workers' stateless model. Positional module assignment, overbooking guards, and conflict checks all work unchanged.

> **Insight:** The "invite as authorization token" pattern cleanly separates the authorization decision (teacher) from the action (student). The invite record serves triple duty: authorization proof, audit trail, and notification linkage. This avoids coupling the booking system to a real-time coordination layer while still ensuring both parties consent. (Conv 004)

**See:** `docs/requirements/rfc/CD-037/`, `src/pages/api/session-invites/`, `src/lib/notifications.ts` (notifySessionInvite, notifySessionInviteAccepted), `docs/as-designed/session-room.md` §Session Invites

---

### Notification action_label: Store Label at Creation Time
**Date:** 2026-03-11 (Session 372)

Notifications store an `action_label TEXT` column alongside `action_url`. Each notification helper sets a contextual label ("Go to Session", "Browse Courses", "Review Application") at creation time. The UI component renders this label as an explicit button, falling back to "View" for notifications without a label.

**Rationale:** The notification creator has the best context for what the button should say. Client-side derivation from `type` would require a parallel mapping table and couldn't handle the generic `notifySystem` helper which takes arbitrary URLs.

**See:** `src/lib/notifications.ts` (all helpers), `migrations/0001_schema.sql` (notifications table)

### User Tags Level: Per-Topic Conceptually, Per-Tag in Storage
**Date:** 2026-04-01 (Conv 071)

Store `level TEXT NOT NULL DEFAULT 'beginner'` on `user_tags` (denormalized per-tag), but TopicPicker enforces same level for all tags within a topic (per-topic conceptually). API accepts both `tags: [{tagId, level}]` (new) and `tagIds: string[]` (legacy, defaults to 'beginner').

**Rationale:** Makes future Smart Feed level matching a trivial join (`user_tags.tag_id = course_tags.tag_id` + compare levels). A separate `user_topic_levels` table would normalize but add an extra join for no practical benefit. The denormalization is controlled — UI enforces the invariant.

**Consequences:** Deferred block LEVEL-MATCH (#40) in PLAN.md for Smart Feed scoring integration.

**See:** Conv 071 Decisions.md, `migrations/0001_schema.sql` (user_tags table)

### Onboarding Goals: Boolean Columns over Enum
**Date:** 2026-04-02 (Conv 076)

Replace `primary_goal TEXT` with independent `goal_learn INTEGER` / `goal_teach INTEGER` boolean columns in `member_profiles`. Learn and Teach are independent selections, not mutually exclusive — "Both" was an artifact of the old single-column design.

**Rationale:** Independent booleans scale to future goal additions without combo value explosion. Each new option is an additive column rather than an exponential expansion of valid enum strings. No existing users at this stage means schema can change freely.

> **Insight:** When modeling user preferences that may grow over time, independent boolean flags are more durable than enum columns with combo values.

### ESCROW Deferred to Post-MVP
**Date:** 2026-04-07 Conv 095

Escrow/hold-period functionality moved to Post-MVP. Current payment flow uses immediate transfers (pay now, clawback on refund). Zero schema columns, zero code exist for escrow. Client to decide post-launch if hold periods are needed.

**Rationale:** P0 priority on escrow stories was assigned before "pay immediately, clawback on refund" was adopted as the payment model. The current flow works without escrow. Business policy decision (hold duration, conditions) must come from the client.

---

### COMM-TAG-FILTER: Community Feed Filtering = Channels Model + `community_channels` Table
**Date:** 2026-06-03 (Conv 238)

Community feed filtering is modeled as **channels** (per-community posting categories), stored in a new `community_channels` table (seed the Commons with general/announcements/help). Rejected: reusing the 55-tag topic taxonomy (wrong purpose — taxonomy is for skill-matching, and the chip count is unusable for feed filtering) and a fixed-list/hardcoded vocabulary. Legacy chips were hardcoded `['general','announcements','help']`; `feed_activities` has no tag column, Stream posts carry no tag field, and the townhall API is limit/offset only — so "real" filtering has no backing data and is a net-new feature, not a wiring task. LOCKED Conv 238.

**Rationale:** Channels are the honest "town hall" model; a table generalizes per-community without a second migration. Build deferred to its own conv (schema→composer→API→UI→backfill); design at `plan/comm-tag-filter/README.md`.

