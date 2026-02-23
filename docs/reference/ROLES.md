# Roles in Peerloop

Comprehensive reference for all platform roles: how they're acquired, what they can do, and what they can't.

Peerloop roles are **not mutually exclusive** — a single user can hold multiple roles simultaneously (e.g., Creator + Student-Teacher + Moderator). Roles are additive: each new role adds capabilities on top of existing ones.

Roles operate on **two layers**: platform-level capabilities (admin-granted flags like `can_create_courses`) and course-scoped relationships (derived from enrollments, certifications, and course ownership). See [Platform vs Course Scope](#platform-vs-course-scope) for details.

---

## Permission Model

Every user has **capability flags** (admin-controlled permissions) and **derived state** (from table relationships):

| Column | Type | Default | Description |
|--------|------|---------|-------------|
| `can_take_courses` | flag | `1` | Can enroll in courses (Student) |
| `can_create_courses` | flag | `0` | Can create courses (Creator) |
| `can_teach_courses` | flag | `0` | Can be certified as Student-Teacher |
| `can_moderate_courses` | flag | `0` | Can moderate content (Moderator) |
| `is_admin` | flag | `0` | Full admin access |
| `is_creator` | derived | — | Has active courses in `courses` table |
| `is_student_teacher` | derived | — | Has active record in `student_teachers` table |

### Platform vs Course Scope

Roles operate on **two layers**. Some are purely platform-level, some require a specific course context, and some span both:

| Layer | Role | Platform Capability | Course Relationship | Notes |
|-------|------|:---:|:---:|-------|
| **Platform-only** | Visitor | — | — | No account; no capabilities |
| **Platform-only** | User (base) | `can_take_courses` | — | Registered but not enrolled in anything |
| **Platform-only** | Admin | `is_admin` | — | Global; no per-course dimension |
| **Course-scoped** | Enrolled Student | `can_take_courses` | `enrollments` row | Student *of* Course X |
| **Course-scoped** | Student-Teacher | `can_teach_courses` | `student_teachers` row | S-T *for* Course X |
| **Both layers** | Creator | `can_create_courses` | `courses.creator_id` | Platform flag gates access; course relationship determines *which* courses |
| **Both layers** | Moderator | `can_moderate_courses` | (future: `course_moderators`) | Platform flag grants global moderation; per-course assignment deferred |

**How this works in practice:**

- **Platform capability** = "Am I *allowed* to do this kind of thing?" (admin-granted)
- **Course relationship** = "Do I *actually have* this role for *this specific course*?" (earned/assigned)

Example: A user with `can_teach_courses = 1` has **permission to teach**, but they're only a Student-Teacher **for Course X** when they have a `student_teachers` row linking them to that course. The platform flag is a prerequisite; the course relationship is the actual state.

**The CurrentUser class reflects this split:**
- `user.canTeachCourses` → platform capability (boolean)
- `user.isStudentTeacherFor(courseId)` → course-scoped relationship (requires courseId)
- `user.canCreateCourses` → platform capability
- `user.isCreatorFor(courseId)` → course-scoped: did they create *this* course?

**Moderator is the hybrid case.** Today, `canModerateFor(courseId)` returns true for admins, course creators, or anyone with `can_moderate_courses`. When the `course_moderators` table is added, moderators will also be assignable per-course — similar to how S-Ts are certified per-course.

---

## 1. Student

**The base role — every registered user starts here.**

### How to Become

**Trigger:** Self-service registration

**Paths:**
- Email/password registration (`POST /api/auth/register`)
- Google OAuth (`/api/auth/google/callback`)
- GitHub OAuth (`/api/auth/github/callback`)

**What happens:**
1. User registers (name, email, handle, password) or authenticates via OAuth
2. System creates `users` row with `can_take_courses = 1` (all other capabilities = 0)
3. System auto-joins user to "The Commons" community and follows its Stream feed
4. User is logged in and can browse/enroll in courses

**Who authorizes:** Self-service (no approval needed)

### Capabilities

- Browse and discover courses, creators, communities, and teachers
- Enroll in courses via Stripe Checkout
- Track learning progress through course modules
- Attend video sessions with assigned Student-Teacher
- Submit homework and assignments
- Rate Student-Teachers after sessions
- Receive certificates upon course completion
- Participate in course and community feeds
- Manage profile, notification, and security settings
- Complete onboarding questionnaire

### Accessible Pages

| Route | Purpose |
|-------|---------|
| `/` | Home feed |
| `/discover/*` | Browse courses, creators, communities, teachers, leaderboard |
| `/courses` | My enrolled courses |
| `/course/[slug]` | Course detail, lessons, feed, resources, teachers |
| `/course/[slug]/book` | Book session with assigned S-T |
| `/course/[slug]/learn` | Course learning content |
| `/learning` | Student dashboard (progress, current courses) |
| `/community/*` | Community pages |
| `/feed` | Activity feed |
| `/messages` | Direct messages |
| `/notifications` | Notification center |
| `/settings/*` | Profile, notifications, security, payments |
| `/onboarding` | Onboarding profile questionnaire |
| `/@[handle]` | Public profiles |

### Key API Endpoints

| Endpoint | Purpose |
|----------|---------|
| `GET /api/me/enrollments` | List enrollments |
| `POST /api/checkout/create-session` | Start Stripe checkout for enrollment |
| `POST /api/sessions/[id]/join` | Join video session |
| `POST /api/sessions/[id]/rating` | Rate a session |

### Restrictions

- Cannot create courses (no access to `/creating/*`)
- Cannot teach (no access to `/teaching/*`)
- Cannot moderate content
- Cannot access admin panel (`/admin/*`)

### Navigation Menu

| Item | Visible? |
|------|----------|
| Learning | Yes (`canTakeCourses`) |
| Teaching | No |
| Become a Creator | Yes (shown until `canCreateCourses` is granted) |
| Creating | No |
| To Admin | No |

---

## 2. Student → Enrolled Student

**Triggered by course enrollment via Stripe checkout.**

### How to Become

1. Student clicks "Enroll" on a course page (`/course/[slug]`)
2. `POST /api/checkout/create-session` creates a Stripe Checkout Session
3. Student completes payment on Stripe's hosted checkout page
4. Stripe fires `checkout.session.completed` webhook
5. `handleCheckoutCompleted` in `/api/webhooks/stripe` creates:
   - `enrollments` row (status: `enrolled`)
   - `transactions` row with payment details
   - `payment_splits` rows (70% S-T / 15% Creator / 15% Platform)
   - Stream follow (user's timeline follows the course feed)
6. Enrollment confirmation email sent to student

**Who authorizes:** Self-service (payment is the gate)

### Additional Capabilities (beyond base Student)

- Access course curriculum and lessons for enrolled course
- Attend scheduled video sessions with assigned Student-Teacher
- Submit homework for enrolled course
- Track module-by-module progress
- Access course community feed

---

## 3. Creator

**Course author and instructional designer.**

### How to Become

**There is no self-service path to become a Creator.** The `can_create_courses` flag starts at `0` for all new users and can only be set by an Admin.

#### Path A: Creator application (recommended)
1. User clicks "Become a Creator" in navbar → navigates to `/creating/apply`
2. Fills out application form
3. `POST /api/creators/apply` creates application record
4. Admin reviews at `/admin/creator-applications`
5. Admin approves → `can_create_courses` set to `1`
6. "Creating" appears in user's navbar

#### Path B: Admin creates user with Creator capability
1. Admin goes to Users Admin panel (`/admin/users`)
2. Creates new user with `capabilities.can_create_courses = true`
3. `POST /api/admin/users` inserts user with `can_create_courses = 1`

#### Path C: Admin upgrades existing user
1. Admin goes to Users Admin panel → finds user → Edit
2. Toggles `can_create_courses` capability on
3. `PATCH /api/admin/users/[id]` updates the flag

**Who authorizes:** Admin only

### Capabilities

All Student capabilities, plus:

- Author and publish courses (curriculum, modules, lessons)
- Manage course settings (pricing, description, thumbnail)
- Create and grade homework/assignments
- Certify Student-Teachers for their courses
- View course analytics (revenue, student metrics, S-T performance)
- Track creator earnings (15% royalty when S-Ts teach their courses)
- Feature and retire courses
- Access Creator Studio

### Accessible Pages

All Student pages, plus:

| Route | Purpose |
|-------|---------|
| `/creating` | Creator dashboard (manage courses) |
| `/creating/studio` | Course editor (curriculum, modules) |
| `/creating/analytics` | Revenue, student metrics, S-T performance |
| `/creating/earnings` | Creator income tracking |
| `/creating/apply` | Creator application (before approval) |

### Key API Endpoints

| Endpoint | Purpose |
|----------|---------|
| `GET/POST /api/me/courses` | List/create courses |
| `GET/PUT /api/me/courses/[id]/curriculum` | Manage modules/lessons |
| `POST /api/me/courses/[id]/student-teachers` | Certify S-Ts |
| `POST /api/me/courses/[id]/publish` | Publish course |
| `GET /api/me/creator-dashboard` | Dashboard data |
| `POST /api/creators/apply` | Submit application |

### Restrictions

- Cannot moderate content (unless also Moderator)
- Cannot access admin panel (`/admin/*`)
- Can only manage courses they created
- Cannot approve other creators' applications

### Navigation Menu

| Item | Visible? |
|------|----------|
| Learning | Yes |
| Teaching | Only if also S-T |
| Become a Creator | No (hidden via `excludeCapabilities`) |
| Creating | Yes (`canCreateCourses`) |
| To Admin | No |

---

## 4. Student-Teacher (S-T)

**Certified peer instructor — earned through course completion.**

### How to Become

**Prerequisite:** Student must have `status = 'completed'` enrollment for the course.

#### Path A: Creator certifies directly (1 step)
1. Creator opens their course in Creator Studio → "Student-Teachers" tab
2. System shows "Eligible to Certify" list (students who completed the course)
3. Creator clicks "Certify" next to a student
4. `POST /api/me/courses/[id]/student-teachers` creates `student_teachers` row with `is_active = 1`
5. Student immediately becomes a Student-Teacher for that course

**Who authorizes:** Creator (course owner)

#### Path B: S-T recommends → Admin approves (2 steps)
1. An existing S-T recommends a student for a teaching certificate
2. `POST /api/me/certificates/recommend` creates a `certificates` row with `status = 'pending'` and `type = 'teaching'`
3. Admin sees pending certificate in Certificates Admin panel
4. Admin clicks "Approve"
5. `POST /api/admin/certificates/[id]/approve` both:
   - Updates certificate to `status = 'issued'`
   - Creates `student_teachers` row with `is_active = 1` (or reactivates existing)
6. Student receives certificate email and becomes S-T

**Who authorizes:** S-T recommends, Admin approves

#### After becoming S-T:
- S-T navigates to Settings → Payments → "Connect with Stripe" to set up Stripe Express account
- Once Stripe is connected, S-T receives 70% of enrollment fees for students they teach

### Capabilities

All Student capabilities, plus:

- View and manage assigned students
- Conduct video teaching sessions
- Set weekly teaching availability
- Track session history
- View earnings and request payouts
- Access S-T analytics (performance, ratings)
- Recommend students for S-T certification
- Rate students after sessions (mutual feedback)

### Accessible Pages

All Student pages, plus:

| Route | Purpose |
|-------|---------|
| `/teaching` | Student-Teacher dashboard |
| `/teaching/students` | Manage assigned students |
| `/teaching/sessions` | View scheduled teaching sessions |
| `/teaching/availability` | Set weekly availability |
| `/teaching/earnings` | Commission earnings (70%) |
| `/teaching/analytics` | Performance metrics and ratings |

### Key API Endpoints

| Endpoint | Purpose |
|----------|---------|
| `GET /api/me/st-students` | List assigned students |
| `GET /api/me/st-sessions` | List teaching sessions |
| `GET /api/me/st-earnings` | Earnings data |
| `POST /api/me/availability` | Update teaching availability |
| `GET /api/me/teacher-dashboard` | Dashboard data |
| `POST /api/me/certificates/recommend` | Recommend student for S-T |

### Database

- `student_teachers` table: per-course certification (user_id, course_id, certified_date, is_active, rating)
- `enrollments.student_teacher_id`: links students to their assigned S-T
- Certification is **per-course** — a user can be S-T for Course A but not Course B

### Restrictions

- Cannot create/edit courses (unless also Creator)
- Cannot moderate content (unless also Moderator)
- Cannot access admin panel (`/admin/*`)
- Can only view students assigned to them
- Teaching scope limited to courses they're certified for

### Navigation Menu

| Item | Visible? |
|------|----------|
| Learning | Yes |
| Teaching | Yes (`canTeachCourses`) |
| Become a Creator | Yes (unless also Creator) |
| Creating | Only if also Creator |
| To Admin | No |

---

## 5. Moderator

**Community content moderator — invited by admin.**

### How to Become

#### Path A: Admin invitation (primary path)
1. Admin opens Moderators Admin panel (`/admin/moderators`)
2. Enters email address → clicks "Send Invite"
3. `POST /api/admin/moderators/invite` creates `moderator_invites` row and sends invitation email via Resend
4. Recipient receives email with invite link (`/invite/mod/[token]`)
5. Recipient clicks link:
   - **If no account:** Redirected to register, then back to accept
   - **If has account:** Logs in (if needed), then accepts
6. `POST /api/moderator-invites/[token]/accept` sets `can_moderate_courses = 1` on their user record
7. Invite status updated to `accepted`

**Validation:**
- Authenticated user's email must match the invite email
- Invite must be `pending` and not expired (1-30 day window, default 7)
- User must not already be a moderator

**Who authorizes:** Admin sends invite, recipient accepts

#### Path B: Admin direct toggle
1. Admin opens Users Admin panel → finds user → Edit
2. Toggles `can_moderate_courses` capability on
3. `PATCH /api/admin/users/[id]` updates the flag

**Who authorizes:** Admin only

### Capabilities

All capabilities from their other roles (usually Student or S-T), plus:

- Review flagged content (posts, comments, profiles)
- Take moderation actions: dismiss, warn, suspend, remove
- Moderate any course (via `canModerateFor(courseId)` — global capability)

### Key API Endpoints

| Endpoint | Purpose |
|----------|---------|
| `GET /api/admin/moderation` | List flagged content |
| `POST /api/admin/moderation/[id]/dismiss` | Dismiss flag |
| `POST /api/admin/moderation/[id]/warn` | Warn user |
| `POST /api/admin/moderation/[id]/suspend` | Suspend content |
| `POST /api/admin/moderation/[id]/remove` | Remove content |

### Restrictions

- Cannot access full admin panel (`/admin/*` — only moderation endpoints)
- Cannot approve creator applications
- Cannot manage payouts or enrollments
- Cannot suspend/remove other moderators
- Cannot manage users or courses

### Navigation Menu

Same as their base role (Student, S-T, or Creator). No dedicated moderator nav item yet.

---

## 6. Admin

**Platform operator — full system access.**

### How to Become

**There is no self-service, invitation, or application path for Admin.** It is set exclusively by an existing Admin.

#### Path A: Admin upgrades existing user
1. Admin opens Users Admin panel → finds user → Edit
2. Toggles `is_admin` capability on
3. `PATCH /api/admin/users/[id]` updates the flag

#### Path B: Admin creates user with Admin capability
1. Admin creates new user via Users Admin panel
2. Sets `capabilities.is_admin = true` during creation
3. `POST /api/admin/users` inserts user with `is_admin = 1`

#### Path C: Seed data (bootstrap)
- The initial admin is created in `migrations/0002_seed_core.sql` with `is_admin = 1`
- This is the only way to bootstrap the first admin in a fresh system

**Who authorizes:** Existing Admin only (or seed data for first admin)

### Capabilities

All other role capabilities, plus:

- Full user management (create, suspend, delete, role assignment)
- Creator application review, approval, and denial
- Course management (feature, suspend, unpublish any course)
- Category management (create, edit, delete)
- Moderator invitation and removal
- Enrollment management
- Student-Teacher oversight
- Payout processing and management
- Certificate approval and rejection
- Platform analytics
- Full moderation access

### Accessible Pages

All user-facing pages, plus:

| Route | Purpose |
|-------|---------|
| `/admin` | Admin dashboard (overview) |
| `/admin/users` | User management |
| `/admin/courses` | Course management |
| `/admin/categories` | Category management |
| `/admin/enrollments` | Enrollment management |
| `/admin/student-teachers` | S-T oversight |
| `/admin/sessions` | Session management |
| `/admin/payouts` | Payout processing |
| `/admin/certificates` | Certificate approval |
| `/admin/creator-applications` | Creator application review |
| `/admin/moderation` | Moderation queue |
| `/admin/moderators` | Moderator management |
| `/admin/analytics` | Platform metrics |

### Key API Endpoints

All `/api/admin/*` endpoints are admin-only:

| Endpoint Group | Purpose |
|----------------|---------|
| `/api/admin/users/*` | User CRUD, capability toggles |
| `/api/admin/courses/*` | Course management |
| `/api/admin/creator-applications/*` | Approve/deny applications |
| `/api/admin/certificates/*` | Certificate approval |
| `/api/admin/enrollments/*` | Enrollment management |
| `/api/admin/student-teachers/*` | S-T analytics |
| `/api/admin/payouts/*` | Payout processing |
| `/api/admin/moderation/*` | Moderation actions |
| `/api/admin/moderators/*` | Moderator invites |
| `/api/admin/categories/*` | Category CRUD |
| `/api/admin/analytics/*` | Platform metrics |
| `/api/admin/dashboard` | Admin overview data |

### Restrictions

None — full access to all platform features.

### Navigation Menu

| Item | Visible? |
|------|----------|
| Learning | Yes |
| Teaching | If also S-T |
| Creating | If also Creator |
| To Admin | Yes (`isAdmin`) |

---

## Authorization Matrix

| Transition | Self-Service | Creator | S-T | Admin | Invite |
|------------|:---:|:---:|:---:|:---:|:---:|
| Visitor → Student | Yes | — | — | — | — |
| Student → Enrolled | Yes (payment) | — | — | — | — |
| Visitor → Creator | — | — | — | Yes | — |
| Student → S-T (direct) | — | Yes | — | — | — |
| Student → S-T (recommend) | — | — | Recommends | Approves | — |
| Anyone → Moderator (invite) | — | — | — | Yes | Yes |
| User → Moderator (direct) | — | — | — | Yes | — |
| User → Admin | — | — | — | Yes | — |

---

## Capability Quick Reference

| Role | Key Gate | How Checked | Default |
|------|----------|-------------|---------|
| Student | `can_take_courses = 1` | Capability flag | Yes (on registration) |
| Creator | `can_create_courses = 1` | Capability flag | No (admin grants) |
| Student-Teacher | `student_teachers.is_active = 1` | Derived from table | No (certification) |
| Moderator | `can_moderate_courses = 1` | Capability flag | No (invite or admin) |
| Admin | `is_admin = 1` | Admin flag | No (admin grants or seed) |

---

## CurrentUser Runtime Methods

The `CurrentUser` class (`src/lib/current-user.ts`) provides runtime role checking:

**Global capabilities (readonly properties):**
- `canCreateCourses`, `canTakeCourses`, `canTeachCourses`, `canModerateCourses`, `isAdmin`

**Course-specific methods:**
- `isStudentFor(courseId)` — has enrollment (any status)
- `isActiveStudentFor(courseId)` — enrolled or in_progress
- `hasCompletedCourse(courseId)` — completed
- `isStudentTeacherFor(courseId)` — active ST certification
- `isCreatorFor(courseId)` — created this course
- `canModerateFor(courseId)` — admin, creator, or canModerateCourses
- `getRoleFor(courseId)` — highest role: creator > student_teacher > student > null

**Navigation filtering:** AppNavbar uses these to show/hide menu items dynamically. AdminNavbar shows all items (admin sees everything).
