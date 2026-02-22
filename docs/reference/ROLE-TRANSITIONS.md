# Role Transitions in Peerloop

How users acquire each role in the system. Peerloop roles are **not mutually exclusive** — a single user can hold multiple roles simultaneously (e.g., Creator + Student-Teacher + Moderator).

---

## Permission Model

Every user has **capability flags** (permissions) and **derived state** (from table relationships):

| Column | Type | Default | Description |
|--------|------|---------|-------------|
| `can_take_courses` | flag | `1` | Can enroll in courses (Student) |
| `can_create_courses` | flag | `0` | Can create courses (Creator) |
| `can_teach_courses` | flag | `0` | Can teach courses |
| `can_moderate_courses` | flag | `0` | Can moderate (Moderator) |
| `is_admin` | flag | `0` | Full admin access |
| `is_creator` | derived | — | Has active courses in `courses` table |
| `is_student_teacher` | derived | — | Has active record in `student_teachers` table |

---

## 1. Visitor → Student (User)

**Trigger:** Self-service registration

**Paths:**
- Email/password registration (`POST /api/auth/register`)
- Google OAuth (`/api/auth/google/callback`)
- GitHub OAuth (`/api/auth/github/callback`)

**What happens:**
1. User fills out registration form (name, email, handle, password) or authenticates via OAuth
2. System creates `users` row with `can_take_courses = 1` (all other capabilities = 0)
3. System auto-joins user to "The Commons" community and follows its Stream feed
4. User is logged in and can browse/enroll in courses

**UI:** `/register` page, or OAuth buttons on login page

**Who authorizes:** Self-service (no approval needed)

---

## 2. Student → Enrolled Student

**Trigger:** Course enrollment via Stripe checkout

**Paths:**
- Student clicks "Enroll" on a course page → Stripe Checkout → payment completes

**What happens:**
1. Student clicks Enroll on a course (`/courses/[slug]`)
2. `POST /api/checkout/create-session` creates a Stripe Checkout Session
3. Student completes payment on Stripe's hosted checkout page
4. Stripe fires `checkout.session.completed` webhook
5. `handleCheckoutCompleted` in `/api/webhooks/stripe` creates:
   - `enrollments` row (status: `enrolled`)
   - `transactions` row with payment details
   - `payment_splits` rows (70% S-T / 15% Creator / 15% Platform)
   - Stream follow (user's timeline follows the course feed)
6. Enrollment confirmation email sent to student

**UI:** "Enroll" button on course page → Stripe Checkout

**Who authorizes:** Self-service (payment is the gate)

---

## 3. Visitor → Creator

**Trigger:** Admin grants `can_create_courses` capability

**There is no self-service path to become a Creator.** The `can_create_courses` flag starts at `0` for all new users and can only be set by an Admin.

**Paths:**

### Path A: Admin creates user with Creator capability
1. Admin goes to Users Admin panel (`/admin/users`)
2. Creates new user with `capabilities.can_create_courses = true`
3. `POST /api/admin/users` inserts user with `can_create_courses = 1`

### Path B: Admin upgrades existing user
1. Admin goes to Users Admin panel → finds user → Edit
2. Toggles `can_create_courses` capability on
3. `PATCH /api/admin/users/[id]` updates the flag

**What happens after:**
- User with `can_create_courses = 1` can access Creator Studio
- `POST /api/me/courses` (create course) checks this flag before allowing course creation
- Once they create a course, `is_creator` becomes `true` (derived from courses table)

**UI:** Admin Users panel → user detail → capabilities toggles

**Who authorizes:** Admin only

---

## 4. Student → Student-Teacher

**Trigger:** Certification after course completion

**Prerequisite:** Student must have `status = 'completed'` enrollment for the course.

### Path A: Creator certifies directly (1 step)
1. Creator opens their course in Creator Studio → "Student-Teachers" tab
2. System shows "Eligible to Certify" list (students who completed the course)
3. Creator clicks **"Certify"** next to a student
4. `POST /api/me/courses/[id]/student-teachers` creates `student_teachers` row with `is_active = 1`
5. Student immediately becomes a Student-Teacher for that course

**UI:** Creator Dashboard → Course Editor → Student-Teachers tab → "Certify" button

**Who authorizes:** Creator (course owner)

### Path B: S-T recommends → Admin approves (2 steps)
1. An existing S-T recommends a student for a **teaching certificate**
2. `POST /api/me/certificates/recommend` creates a `certificates` row with `status = 'pending'` and `type = 'teaching'`
3. Admin sees pending certificate in Certificates Admin panel
4. Admin clicks **"Approve"**
5. `POST /api/admin/certificates/[id]/approve` both:
   - Updates certificate to `status = 'issued'`
   - Creates `student_teachers` row with `is_active = 1` (or reactivates existing)
6. Student receives certificate email and becomes S-T

**UI:**
- S-T: Teacher Dashboard → student list → "Recommend for Certification"
- Admin: Admin → Certificates → pending tab → "Approve"

**Who authorizes:** S-T recommends, Admin approves

### After becoming S-T:
- S-T navigates to Settings → Payments → "Connect with Stripe" to set up Stripe Express account
- Once Stripe is connected, S-T receives 70% of enrollment fees for students they teach

---

## 5. Outside User → Moderator (Invitation)

**Trigger:** Admin sends email invitation

**Path:**
1. Admin opens Moderators Admin panel
2. Enters email address of person to invite → clicks "Send Invite"
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

**UI:** Admin → Moderators → "Invite Moderator" → email form

**Who authorizes:** Admin sends invite, recipient accepts

---

## 6. Existing User → Moderator

**Two paths:**

### Path A: Admin invitation (same as above)
Admin sends invite to the user's existing email address. User logs in and accepts.

### Path B: Admin direct toggle
1. Admin opens Users Admin panel → finds user → Edit
2. Toggles `can_moderate_courses` capability on
3. `PATCH /api/admin/users/[id]` updates the flag

**UI:** Admin → Users → user detail → capabilities toggles

**Who authorizes:** Admin only

---

## 7. User → Admin

**Trigger:** Admin grants `is_admin` flag

**There is no self-service, invitation, or application path for Admin.** It is set exclusively by an existing Admin.

**Paths:**

### Path A: Admin upgrades existing user
1. Admin opens Users Admin panel → finds user → Edit
2. Toggles `is_admin` capability on
3. `PATCH /api/admin/users/[id]` updates the flag

### Path B: Admin creates user with Admin capability
1. Admin creates new user via Users Admin panel
2. Sets `capabilities.is_admin = true` during creation
3. `POST /api/admin/users` inserts user with `is_admin = 1`

### Path C: Seed data (bootstrap)
- The initial admin is created in `migrations/0002_seed_core.sql` with `is_admin = 1`
- This is the only way to bootstrap the first admin in a fresh system

**UI:** Admin → Users → user detail → capabilities toggles

**Who authorizes:** Existing Admin only (or seed data for first admin)

---

## Summary: Authorization Matrix

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

## Role Capability Quick Reference

| Role | Key Gate | How Checked |
|------|----------|-------------|
| Student | `can_take_courses = 1` | Default on registration |
| Creator | `can_create_courses = 1` | Admin-set flag |
| Student-Teacher | `student_teachers.is_active = 1` | Derived from table |
| Moderator | `can_moderate_courses = 1` | Admin-set flag or invite acceptance |
| Admin | `is_admin = 1` | Admin-set flag or seed data |
