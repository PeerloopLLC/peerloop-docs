# Session Learnings - 2026-02-21

## 1. q-git-history Was Actively Filtering Out Useful Metadata
**Topics:** cc-workflow, dual-repo

**Context:** User wanted each commit in `/q-git-history` output to show which computer and which repo (code vs docs) it came from, for timecards that combine both repos.

**Learning:** The `Machine:` line was already present in every commit message (added by `/q-commit-local`), but `/q-git-history` had an explicit exclusion rule filtering it out alongside `Co-Authored-By:` and the bot signature. The repo name was only in a section header, not per-commit. The fix was entirely in the display layer — no commit format changes needed, and all existing commits retroactively benefit.

**Pattern:** When data seems missing from output, check whether it's being generated but filtered before display. Fixing the display layer is cheaper and retroactive compared to changing the data layer.

---

## 2. Peerloop Email Architecture: Transactional vs Notification
**Topics:** workflow, astro

**Context:** Added enrollment confirmation email to the Stripe webhook handler. Initially used `sendEmailToUser()` which checks user preference opt-out before sending.

**Learning:** `src/lib/email.ts` has two distinct send paths:
- `sendEmail()` — always sends (transactional: receipts, enrollment confirmations, password resets)
- `sendEmailToUser()` → `sendEmailIfAllowed()` — checks 7 preference columns before sending (notifications: session reminders, marketing, course updates)

The enrollment confirmation is transactional (user took an explicit action and expects confirmation), so it should use `sendEmail()` directly, bypassing preferences.

---

## 3. Peerloop Role Model: Capability Flags vs Derived State
**Topics:** auth, d1

**Context:** Documenting all role transition paths for `ROLE-TRANSITIONS.md`.

**Learning:** Peerloop uses two orthogonal role mechanisms:
- **Capability flags** on `users` table: `can_create_courses`, `can_moderate_courses`, `is_admin` — admin-controlled permissions that gate what a user *may* do
- **Derived state** from related tables: `is_creator` (has rows in `courses`), `is_student_teacher` (has rows in `student_teachers`) — reflects what the user *has done*

A user can have `can_create_courses = 1` but not yet be a "Creator" in the derived sense — they haven't created a course yet. This separation keeps the permission model clean: flags control access, tables reflect reality.

---

## 4. Stripe Connect Is Role-Agnostic
**Topics:** stripe

**Context:** Investigating how Student-Teachers set up Stripe accounts.

**Learning:** The entire Stripe Connect flow (`/api/stripe/connect`, `/api/stripe/connect-status`, `StripeConnectSettings` component) is shared between Creators and S-Ts. The only difference is a `role` metadata tag (`'creator'` vs `'student_teacher'`) set during account creation. Same Express account type, same onboarding flow, same UI component. The payment split percentages (70% S-T / 85% Creator) are applied at checkout time, not at account setup time.

---

## 5. Two S-T Certification Paths by Design
**Topics:** workflow, auth

**Context:** Tracing how a student becomes a Student-Teacher.

**Learning:** There are two intentionally different paths:
1. **Creator certifies directly** (1-step) — Creator owns the course and is trusted to manage their own S-Ts. Uses `POST /api/me/courses/[id]/student-teachers`.
2. **S-T recommends → Admin approves** (2-step) — Existing S-T recommends via teaching certificate (`POST /api/me/certificates/recommend`), then Admin approves (`POST /api/admin/certificates/[id]/approve`), which auto-creates the `student_teachers` record.

The 2-step path exists because S-Ts might have conflicts of interest (recommending friends), so Admin oversight is required.

---

## 6. No Self-Service Creator Application Flow
**Topics:** workflow

**Context:** Mapping all role transitions.

**Learning:** There is no "Apply to become a Creator" form or self-service path. The `/for-creators` marketing page exists but becoming a Creator requires Admin action (`PATCH /api/admin/users/[id]` to set `can_create_courses = 1`). This is likely intentional for the genesis cohort (curated creators), but should be noted as a potential future feature for scale.
