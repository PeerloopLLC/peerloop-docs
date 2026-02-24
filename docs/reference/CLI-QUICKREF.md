# CLI Quick Reference

A concise summary of all CLI commands. Use this as your starting point to find any command.

| Need details? | Go to |
|---------------|-------|
| npm script commands | [CLI-REFERENCE.md](CLI-REFERENCE.md) |
| Testing commands | [CLI-TESTING.md](CLI-TESTING.md) |
| Setup & installation | [CLI-MISC.md](CLI-MISC.md) |
| API endpoints | [API-REFERENCE.md](API-REFERENCE.md) |
| Test file inventory | [TEST-COVERAGE.md](TEST-COVERAGE.md) |
| All scripts & utilities | [SCRIPTS.md](SCRIPTS.md) |

---

## Development Commands

> Details: [CLI-REFERENCE.md](CLI-REFERENCE.md#development-commands)

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run dev:staging` | Dev server with remote staging D1 |
| `npm run build` | Build for production |
| `npm run preview` | Preview production build locally |
| `npm run start` | Alias for `dev` |
| `npm run check` | Run Astro diagnostics |
| `npm run typecheck` | Run TypeScript type check |
| `npm run lint` | Run ESLint |
| `npm run lint:fix` | Run ESLint with auto-fix |
| `npm run format` | Format code with Prettier |
| `npm run format:check` | Check formatting without changes |
| `npm run check:tailwind` | Check for Tailwind v4 compatibility issues |

---

## Database Commands

> Details: [CLI-REFERENCE.md](CLI-REFERENCE.md#database-commands) | [tech-024-migrations.md](../tech/tech-024-migrations.md)

### Setup Commands (Full Reset + Migrate + Seed)

| Command | Description | Test Data |
|---------|-------------|:---------:|
| `npm run db:setup:local` | Reset + migrate + dev seed | ✓ |
| `npm run db:setup:local:clean` | Reset + migrate only (production-like) | |
| `npm run db:setup:staging` | Reset + migrate + dev seed (staging) | ✓ |
| `npm run db:setup:staging:clean` | Reset + migrate only (staging) | |

### Individual Commands

| Command | Description | Local | Staging | Prod |
|---------|-------------|:-----:|:-------:|:----:|
| `npm run db:migrate:local` | Apply migrations | ✓ | | |
| `npm run db:migrate:staging` | Apply migrations | | ✓ | |
| `npm run db:migrate:prod` | Apply migrations (⚠️ requires confirmation) | | | ✓ |
| `npm run db:seed:local` | Apply dev seed data | ✓ | | |
| `npm run db:seed:staging` | Apply dev seed data | | ✓ | |
| `npm run db:seed:stripe:local` | Apply Stripe sandbox account IDs (opt-in) | ✓ | | |
| `npm run db:seed:stripe:staging` | Apply Stripe sandbox account IDs (opt-in) | | ✓ | |
| `npm run db:seed:prod` | 🚫 BLOCKED for safety | | | |
| `npm run db:reset:local` | Delete SQLite files | ✓ | | |
| `npm run db:reset:staging` | Reset staging DB | | ✓ | |
| `npm run db:reset:prod` | 🚫 BLOCKED for safety | | | |
| `npm run db:studio:local` | Open D1 Studio | ✓ | | |
| `npm run db:studio:staging` | Open D1 Studio | | ✓ | |
| `npm run db:studio:prod` | Open D1 Studio (⚠️ requires confirmation) | | | ✓ |
| `npm run db:validate` | Validate SQL syntax | ✓ | ✓ | ✓ |

*Production commands require typing "production" to confirm.*
*`db:seed:prod` and `db:reset:prod` are blocked to prevent accidental test data or data loss.*

---

## Testing Commands

> Details: [CLI-TESTING.md](CLI-TESTING.md)

| Command | Description |
|---------|-------------|
| `npm run test` | Run unit tests (Vitest) |
| `npm run test:unit` | Run unit tests only |
| `npm run test:integration` | Run integration tests only |
| `npm run test:api` | Run API tests only |
| `npm run test:watch` | Run tests in watch mode |
| `npm run test:ui` | Run tests with Vitest UI |
| `npm run test:e2e` | Run E2E tests (Playwright) |
| `npm run test:all` | Run all tests (unit + E2E) |
| `npm run test:reset-db` | Reset test database state |

### Page Test Scripts

Run all tests (component + API) for a specific page:

```bash
./scripts/page-tests/test-<CODE>.sh          # Run full suite
./scripts/page-tests/test-<CODE>.sh --quick  # Component test only
```

**22 scripts available** (as of Session 120):

| Category | Scripts |
|----------|---------|
| Course | CBRO, CCNT, CDET, CDIS, CSUC |
| Community | FEED, IFED |
| Creator/ST | CANA, CPRO, CRLS, STDR, STPR, STUD, TANA |
| Dashboard | CDSH, SDSH |
| Session | SBOK, SROM |
| Settings | SNOT, SPAY, SPRF, SSEC |
| Marketing | TERM |

*Scripts created via `/L-test-plan` verification. See PLAN.md TESTING.PAGELIST for full progress (27/60 = 45%).*

---

## Cloudflare Commands

> Details: [CLI-REFERENCE.md](CLI-REFERENCE.md#cloudflare-commands)

| Command | Description |
|---------|-------------|
| `npm run cf:dev` | Run Wrangler Pages dev server |
| `npm run cf:deploy` | Deploy to Cloudflare Pages |
| `npm run cf:tail` | Tail deployment logs |

---

## R2 Storage Commands

> Details: [CLI-REFERENCE.md](CLI-REFERENCE.md#r2-commands)

| Command | Description | Local | Remote |
|---------|-------------|:-----:|:------:|
| `npm run r2:list:local` | List objects in local R2 bucket | ✓ | |
| `npm run r2:list:remote` | List objects in remote R2 bucket | | ✓ |

*Local commands require Mac Mini with R2 setup*

---

## Build Scripts

> Details: [CLI-REFERENCE.md](CLI-REFERENCE.md#build-scripts)

| Command | Description |
|---------|-------------|
| `npm run parse-page` | Parse single page markdown |
| `npm run parse-all-pages` | Parse all page markdowns |
| `npm run generate-pages` | Generate all Astro pages |
| `npm run mock-diagram` | Generate mock data diagram (Markdown) |
| `npm run mock-diagram:html` | Generate mock data diagram (HTML viewer) |
| `npm run pages-map` | Preview PAGES-MAP.md from page JSONs (dry-run) |
| `npm run pages-map:write` | Generate PAGES-MAP.md from page JSONs |
| `npm run site-map` | Preview SITE-MAP.md Mermaid diagrams (dry-run) |
| `npm run site-map:write` | Generate SITE-MAP.md with page interconnections |

---

## Utility Scripts

> Details: [CLI-MISC.md](CLI-MISC.md#environment-validation)

| Command | Description |
|---------|-------------|
| `bash scripts/link-docs.sh` | Create docs/ and research/ symlinks to peerloop-docs repo |
| `npm run env:check` | Validate development environment (Node, npm, wrangler, stripe, etc.) |
| `npm run check:tailwind` | Check for Tailwind v4 compatibility issues |
| `npm run test:coverage` | Audit PageSpec test coverage (dry run) |
| `npm run test:coverage:write` | Update PageSpec testCoverage sections |
| `npm run stripe:listen` | Start Stripe CLI webhook listener (forwards to localhost:4321) |

---

## Validation Scripts

> Details: [CLI-REFERENCE.md](CLI-REFERENCE.md#validation-scripts)

| Command | Description |
|---------|-------------|
| `npx tsx scripts/validate-page-spec.ts <file>` | Validate PageSpec JSON against Zod schema |

**Example:**
```bash
npx tsx scripts/validate-page-spec.ts src/data/pages/admin/student-teachers.json
```

**Exit codes:** 0 = valid, 1 = invalid/error

---

## API Endpoints

> Details: [API-REFERENCE.md](API-REFERENCE.md)

### Authentication

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/auth/register` | POST | Create new account |
| `/api/auth/login` | POST | Email/password login |
| `/api/auth/logout` | POST | Clear session |
| `/api/auth/session` | GET | Get current user |
| `/api/auth/reset-password` | POST | Request password reset |
| `/api/auth/google` | GET | Initiate Google OAuth |
| `/api/auth/google/callback` | GET | Google OAuth callback |
| `/api/auth/github` | GET | Initiate GitHub OAuth |
| `/api/auth/github/callback` | GET | GitHub OAuth callback |

### Courses

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/courses` | GET | List courses (filter, search, paginate) |
| `/api/courses/[slug]` | GET | Get course by slug |
| `/api/courses/[id]/reviews` | GET | Get course reviews/testimonials |
| `/api/courses/[id]/curriculum` | GET | Get course modules/curriculum |
| `/api/courses/[id]/resources` | GET | Get course resources (auth required) |

### Creators

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/creators` | GET | List creators (filter, search, paginate) |
| `/api/creators/[handle]` | GET | Get creator by handle |
| `/api/creators/[id]/courses` | GET | Get creator's courses |
| `/api/creators/apply` | GET | Check creator application status (auth required) |
| `/api/creators/apply` | POST | Submit creator application (auth required) |

### Creator Community & Progression Management

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/me/communities` | GET | List creator's communities with stats |
| `/api/me/communities` | POST | Create community + default progression + membership |
| `/api/me/communities/[slug]` | PATCH | Update community settings |
| `/api/me/communities/[slug]` | DELETE | Archive community (soft-delete) |
| `/api/me/communities/[slug]/progressions` | GET | List progressions with nested courses |
| `/api/me/communities/[slug]/progressions` | POST | Create progression |
| `/api/me/communities/[slug]/progressions/[id]` | PATCH | Update progression |
| `/api/me/communities/[slug]/progressions/[id]` | DELETE | Archive progression |
| `/api/me/communities/[slug]/members` | GET | List community members with roles |
| `/api/me/communities/[slug]/progressions/reorder` | PATCH | Reorder progressions |

### Creator Course Management

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/me/courses` | GET | List creator's courses with stats |
| `/api/me/courses` | POST | Create new course (requires `progression_id`) |
| `/api/me/courses/[id]` | GET | Get course details for editing |
| `/api/me/courses/[id]` | PUT | Update course details |
| `/api/me/courses/[id]` | DELETE | Delete draft course (soft delete) |
| `/api/me/courses/[id]/curriculum` | GET | Get course modules |
| `/api/me/courses/[id]/curriculum` | POST | Add new module |
| `/api/me/courses/[id]/curriculum/[moduleId]` | GET | Get single module with lessons |
| `/api/me/courses/[id]/curriculum/[moduleId]` | PUT | Update module |
| `/api/me/courses/[id]/curriculum/[moduleId]` | DELETE | Delete module |
| `/api/me/courses/[id]/curriculum/reorder` | POST | Reorder modules |
| `/api/me/courses/[id]/homework` | GET | Get course homework assignments |
| `/api/me/courses/[id]/homework` | POST | Create homework assignment |
| `/api/me/courses/[id]/homework/[assignmentId]` | GET | Get single homework assignment |
| `/api/me/courses/[id]/homework/[assignmentId]` | PUT | Update homework assignment |
| `/api/me/courses/[id]/homework/[assignmentId]` | DELETE | Delete homework assignment |
| `/api/me/courses/[id]/resources` | GET | Get course resources |
| `/api/me/courses/[id]/resources` | POST | Add course resource |
| `/api/me/courses/[id]/resources/[resourceId]` | GET | Get single resource |
| `/api/me/courses/[id]/resources/[resourceId]` | PUT | Update resource |
| `/api/me/courses/[id]/resources/[resourceId]` | DELETE | Delete resource |
| `/api/me/courses/[id]/student-teachers` | GET | Get course student-teachers |
| `/api/me/courses/[id]/student-teachers/[stId]` | GET | Get single student-teacher details |
| `/api/me/courses/[id]/student-teachers/[stId]` | PUT | Update student-teacher (activate/deactivate) |
| `/api/me/courses/[id]/publish` | PUT | Publish course (validates checklist) |
| `/api/me/courses/[id]/unpublish` | PUT | Unpublish course (return to draft) |
| `/api/me/courses/[id]/thumbnail` | POST | Upload course thumbnail to R2 |

### Creator Dashboard & Analytics

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/me/creator-dashboard` | GET | Get creator dashboard data (stats, courses, pending) |
| `/api/me/creator-earnings` | GET | Get creator royalty earnings (15% share, by course) |
| `/api/me/creator-analytics` | GET | Creator analytics summary KPIs |
| `/api/me/creator-analytics/courses` | GET | Creator course performance metrics |
| `/api/me/creator-analytics/enrollments` | GET | Creator enrollment trends |
| `/api/me/creator-analytics/funnel` | GET | Creator conversion funnel data |
| `/api/me/creator-analytics/progress` | GET | Student progress distribution |
| `/api/me/creator-analytics/sessions` | GET | Session analytics for creator's courses |
| `/api/me/creator-analytics/st-performance` | GET | Student-Teacher performance on creator's courses |

### Users

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/users` | GET | List users (filter by role, search, paginate) |
| `/api/users/[handle]` | GET | Get user by handle with full profile |
| `/api/users/check-handle` | GET | Check if handle is available |
| `/api/users/search` | GET | Search users by name/handle |

### User Profile & Account (Requires auth)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/me/profile` | GET/PUT | Get or update user profile |
| `/api/me/account` | GET/PUT/DELETE | Manage account (email, password, delete) |
| `/api/me/settings` | GET/PUT | Get or update user settings (preferences) |
| `/api/me/full` | GET | Get full user data (profile + enrollments + roles) |
| `/api/me/onboarding-profile` | GET/POST | Get or save onboarding profile + topic interests |

### Conversations (Requires auth)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/conversations` | GET/POST | List conversations or start new one |
| `/api/conversations/[id]` | GET/DELETE | Get or delete conversation |
| `/api/conversations/[id]/messages` | GET/POST | Get messages or send message |
| `/api/conversations/[id]/read` | POST | Mark conversation as read |

### Enrollments

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/enrollments` | GET | List enrollments (filter by student/course/ST) |
| `/api/me/enrollments` | GET | Get current user's enrollments with progress |
| `/api/enrollments/[id]/progress` | GET | Get module completion progress |
| `/api/enrollments/[id]/progress` | POST | Mark module complete/incomplete |
| `/api/enrollments/[id]/review` | GET | Check if completion review exists |
| `/api/enrollments/[id]/review` | POST | Submit course completion review (updates ST rating) |

### Resources

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/resources/[id]/download` | GET | Download resource file from R2 (auth required) |

### Checkout & Payments

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/checkout/create-session` | POST | Create Stripe Checkout session for enrollment |
| `/api/webhooks/stripe` | POST | Handle Stripe webhook events (7 handlers: checkout, refund, account, transfer, 2 dispute, payout) |

### Stripe Connect

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/stripe/connect` | POST | Create Stripe Express account for creator/S-T |
| `/api/stripe/connect-link` | GET | Get onboarding or dashboard URL |
| `/api/stripe/connect-status` | GET | Check connected account status |

### Recommendations

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/recommendations/courses` | GET | Personalized course recommendations (optional auth, popular fallback) |
| `/api/recommendations/communities` | GET | Personalized community recommendations (optional auth, popular fallback) |

### Platform

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/stats` | GET | Get platform statistics |
| `/api/categories` | GET | Get course categories |
| `/api/topics` | GET | Get categories with topics (for onboarding) |
| `/api/testimonials` | GET | Get testimonials (featured or all with filters) |
| `/api/leaderboard` | GET | Get community rankings (teachers, learners, rated) |

### Marketing

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/team` | GET | Get active team members |
| `/api/faq` | GET | Get FAQ entries (optional category filter) |
| `/api/contact` | POST | Submit contact form |

### Stories

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/stories` | GET | List success stories (filter by type) |
| `/api/stories/[id]` | GET | Get single story by ID |

### Student-Teachers

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/student-teachers` | GET | List student-teachers (filter by course, active status) |

### Homework

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/courses/[id]/homework` | GET | List homework assignments for course (auth required) |
| `/api/homework/[id]` | GET | Get assignment details (auth required) |
| `/api/homework/[id]/submit` | POST | Submit homework (auth required) |
| `/api/homework/[id]/submissions` | GET | List all submissions (ST/Creator only) |
| `/api/homework/[id]/submissions/me` | GET | Get my submission (auth required) |
| `/api/homework/[id]/submissions/[subId]` | PATCH | Grade/review submission (ST/Creator only) |
| `/api/submissions/[id]` | PUT | Update submission before review (auth required) |

### Stream.io / Community (Requires auth)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/stream/token` | POST | Generate Stream.io user token |
| `/api/feeds/townhall` | GET | Get townhall feed activities |
| `/api/feeds/townhall` | POST | Post activity to townhall |
| `/api/feeds/townhall/reactions` | POST | Add reaction to activity |
| `/api/feeds/townhall/reactions` | DELETE | Remove reaction from activity |
| `/api/feeds/townhall/comments` | GET | Get comments for activity or replies |
| `/api/feeds/townhall/comments` | POST | Add comment or reply |
| `/api/feeds/townhall/comments` | DELETE | Delete comment |
| `/api/feeds/course/[slug]` | GET | Get course discussion feed (public view) |
| `/api/feeds/course/[slug]` | POST | Post to course discussion (enrolled only) |
| `/api/courses/[slug]/discussion-feed` | GET | Get discussion feed status (creator) |
| `/api/courses/[slug]/discussion-feed` | POST | Enable/disable course discussion |
| `/api/feeds/community/[slug]` | GET | Get community feed activities |
| `/api/feeds/community/[slug]` | POST | Post to community feed (members only) |
| `/api/feeds/community/[slug]/reactions` | POST | Add reaction to community activity |
| `/api/feeds/community/[slug]/reactions` | DELETE | Remove reaction from community activity |
| `/api/feeds/community/[slug]/comments` | GET | Get comments for community activity |
| `/api/feeds/community/[slug]/comments` | POST | Add comment to community activity |
| `/api/feeds/community/[slug]/comments` | DELETE | Delete comment from community activity |
| `/api/feeds/timeline` | GET | Get aggregated timeline from all followed sources |

### Communities

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/communities` | GET | List communities (mine, all, discover) |
| `/api/communities/[slug]` | GET | Get community detail with members/resources |
| `/api/communities/[slug]/join` | POST | Join community (creates membership + Stream follow) |
| `/api/communities/[slug]/join` | DELETE | Leave community (removes membership + Stream unfollow) |
| `/api/communities/[slug]/progressions` | GET | Get community progressions with courses |
| `/api/communities/[slug]/moderators` | GET | List active community moderators |
| `/api/communities/[slug]/moderators` | POST | Appoint community moderator (creator/admin) |
| `/api/communities/[slug]/moderators/[userId]` | DELETE | Revoke community moderator (creator/admin) |

### Health

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/health/db` | GET | Check D1 database connectivity |
| `/api/health/r2` | GET | Check R2 storage connectivity (write/read/delete test) |
| `/api/health/kv` | GET | Check KV namespace connectivity (write/read/delete test) |

### Admin (Requires admin role)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/admin/users` | GET | List users (paginated, filterable) |
| `/api/admin/users` | POST | Create new user |
| `/api/admin/users/[id]` | GET | Get user details with stats |
| `/api/admin/users/[id]` | PATCH | Update user fields |
| `/api/admin/users/[id]` | DELETE | Soft delete user |
| `/api/admin/users/[id]/suspend` | POST | Suspend user account |
| `/api/admin/users/[id]/unsuspend` | POST | Restore suspended user |
| `/api/admin/categories` | GET | List categories with course counts |
| `/api/admin/categories` | POST | Create new category |
| `/api/admin/categories/[id]` | GET | Get category details |
| `/api/admin/categories/[id]` | PATCH | Update category |
| `/api/admin/categories/[id]` | DELETE | Delete category (if no courses) |
| `/api/admin/categories/reorder` | POST | Bulk update display order |
| `/api/admin/courses` | GET | List courses (paginated, filterable) |
| `/api/admin/courses` | POST | Create new course |
| `/api/admin/courses/[id]` | GET | Get course detail with stats |
| `/api/admin/courses/[id]` | PATCH | Update course fields |
| `/api/admin/courses/[id]` | DELETE | Soft delete course (if no enrollments) |
| `/api/admin/courses/[id]/feature` | POST | Set featured badge |
| `/api/admin/courses/[id]/feature` | DELETE | Remove featured badge |
| `/api/admin/courses/[id]/suspend` | POST | Deactivate course |
| `/api/admin/courses/[id]/unsuspend` | POST | Reactivate course |
| `/api/admin/courses/[id]/badge` | POST | Set promotional badge |
| `/api/admin/enrollments` | GET | List enrollments (paginated, filterable) |
| `/api/admin/enrollments` | POST | Create manual/comp enrollment |
| `/api/admin/enrollments/[id]` | GET | Get enrollment detail with progress |
| `/api/admin/enrollments/[id]` | PATCH | Update enrollment fields |
| `/api/admin/enrollments/[id]` | DELETE | Soft delete enrollment |
| `/api/admin/enrollments/[id]/reassign-st` | POST | Change assigned Student-Teacher |
| `/api/admin/enrollments/[id]/cancel` | POST | Cancel enrollment with reason |
| `/api/admin/enrollments/[id]/refund` | POST | Process Stripe refund (full/partial) |
| `/api/admin/enrollments/[id]/force-complete` | POST | Override to complete status |
| `/api/admin/student-teachers` | GET | List STs (paginated, filterable by course/status) |
| `/api/admin/student-teachers/[id]` | GET | Get ST detail with teaching stats |
| `/api/admin/student-teachers/[id]` | DELETE | Revoke ST certification |
| `/api/admin/student-teachers/[id]/activate` | POST | Enable ST to accept students |
| `/api/admin/student-teachers/[id]/deactivate` | POST | Disable ST from accepting students |
| `/api/admin/payouts` | GET | List payouts (paginated, filterable by status/recipient) |
| `/api/admin/payouts` | POST | Create payout from pending splits |
| `/api/admin/payouts/pending` | GET | Get pending splits grouped by recipient |
| `/api/admin/payouts/batch` | POST | Batch process all pending payouts |
| `/api/admin/payouts/[id]` | GET | Get payout detail with splits |
| `/api/admin/payouts/[id]` | DELETE | Cancel pending payout |
| `/api/admin/payouts/[id]/process` | POST | Execute Stripe transfer |
| `/api/admin/payouts/[id]/retry` | POST | Retry failed payout |
| `/api/admin/sessions` | GET | List sessions (paginated, filterable) |
| `/api/admin/sessions/[id]` | GET | Get session detail with assessments |
| `/api/admin/sessions/[id]` | PATCH | Update admin notes or status |
| `/api/admin/sessions/[id]/recording` | GET | Fetch recording URL from BBB |
| `/api/admin/sessions/[id]/recording` | DELETE | Delete recording |
| `/api/admin/sessions/[id]/resolve` | POST | Apply dispute resolution |
| `/api/admin/dashboard` | GET | Get aggregated platform metrics and alerts |
| `/api/admin/analytics` | GET | Admin analytics summary KPIs |
| `/api/admin/analytics/revenue` | GET | Revenue trends and distribution |
| `/api/admin/analytics/users` | GET | User growth and funnel |
| `/api/admin/analytics/courses` | GET | Course and creator metrics |
| `/api/admin/analytics/student-teachers` | GET | S-T pipeline and flywheel metrics |
| `/api/admin/analytics/engagement` | GET | Session and engagement metrics |
| `/api/admin/moderation` | GET | List flagged content (admin/mod) |
| `/api/admin/moderation/[id]` | GET | Get flag details with history (admin/mod) |
| `/api/admin/moderation/[id]` | PATCH | Update flag priority (admin/mod) |
| `/api/admin/moderation/[id]/dismiss` | POST | Dismiss flag (admin/mod) |
| `/api/admin/moderation/[id]/remove` | POST | Remove flagged content (admin/mod) |
| `/api/admin/moderation/[id]/warn` | POST | Issue warning (admin/mod) |
| `/api/admin/moderation/[id]/suspend` | POST | Suspend user (admin/mod, perm=admin only) |
| `/api/admin/moderators/invite` | POST | Create and send moderator invitation |
| `/api/admin/moderators` | GET | List moderators or invites (view=moderators\|invites) |
| `/api/admin/moderators/[id]/revoke` | POST | Revoke pending invitation |
| `/api/admin/moderators/[id]/resend` | POST | Resend invitation email |
| `/api/admin/moderators/[id]/remove` | POST | Remove moderator role from user |

### Moderator Invites (Public token-based)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/moderator-invites/[token]` | GET | Validate invite token and get details |
| `/api/moderator-invites/[token]/accept` | POST | Accept invitation (requires auth) |
| `/api/moderator-invites/[token]/decline` | POST | Decline invitation |

### Content Flagging

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/flags` | POST | Flag content for moderation (requires auth) |

### Teaching / Student-Teacher (Requires auth)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/me/teacher-dashboard` | GET | Get S-T dashboard data (stats, students, sessions) |
| `/api/me/availability` | GET | Get current user's weekly availability pattern |
| `/api/me/availability` | PUT | Update weekly availability slots |
| `/api/me/st-earnings` | GET | Get S-T earnings (summary, by course, transactions) |
| `/api/me/st-students` | GET | Get S-T's assigned students (filterable, paginated) |
| `/api/me/st-sessions` | GET | Get S-T's session history (filterable, paginated, stats) |
| `/api/me/payouts/request` | POST | Request payout of available balance |
| `/api/student-teachers/[id]/availability` | GET | Get ST's available time slots for booking |
| `/api/me/st-analytics` | GET | S-T analytics summary KPIs |
| `/api/me/st-analytics/earnings` | GET | S-T earnings time series |
| `/api/me/st-analytics/sessions` | GET | S-T session metrics and patterns |
| `/api/me/st-analytics/students` | GET | S-T student progress distribution |

### Video Sessions (Requires auth)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/sessions` | GET | List sessions (filter by enrollment/user) |
| `/api/sessions` | POST | Create/book a session |
| `/api/sessions/[id]` | GET | Get session detail |
| `/api/sessions/[id]` | PATCH | Reschedule session (new date/time) |
| `/api/sessions/[id]` | DELETE | Cancel session |
| `/api/sessions/[id]/join` | POST | Get BBB join URL |
| `/api/sessions/[id]/rating` | POST | Rate session (post-session) |
| `/api/sessions/[id]/recording` | GET | Get recording URL (completed sessions) |
| `/api/webhooks/bbb` | POST | Handle BigBlueButton webhook events |

### Certificates

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/me/certificates` | GET | Get current user's certificates |
| `/api/me/certificates/recommend` | POST | S-T recommends student for certification |
| `/api/certificates/[id]/verify` | GET | Public certificate verification |
| `/api/admin/certificates` | GET | List certificates (admin, filterable) |
| `/api/admin/certificates` | POST | Manually issue certificate (admin) |
| `/api/admin/certificates/[id]` | GET | Get certificate detail (admin) |
| `/api/admin/certificates/[id]` | DELETE | Delete certificate (admin) |
| `/api/admin/certificates/[id]/approve` | POST | Approve pending certificate (admin) |
| `/api/admin/certificates/[id]/reject` | POST | Reject pending certificate (admin) |
| `/api/admin/certificates/[id]/revoke` | POST | Revoke issued certificate (admin) |
| `/api/admin/creator-applications` | GET | List creator applications (admin, filterable) |
| `/api/admin/creator-applications/[id]` | GET | Get creator application detail (admin) |
| `/api/admin/creator-applications/[id]/approve` | POST | Approve creator application (admin) |
| `/api/admin/creator-applications/[id]/deny` | POST | Deny creator application (admin) |

### Notifications (Requires auth)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/me/notifications` | GET | List notifications (filter, paginate) |
| `/api/me/notifications` | DELETE | Clear all read notifications |
| `/api/me/notifications/count` | GET | Get unread notification count |
| `/api/me/notifications/read-all` | PATCH | Mark all notifications as read |
| `/api/me/notifications/[id]` | DELETE | Delete single notification |
| `/api/me/notifications/[id]/read` | PATCH | Mark single notification as read |
