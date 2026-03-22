# Session Decisions - 2026-02-21

## 1. Show Machine Name and Repo Tag Per Commit in q-git-history
**Type:** Implementation
**Topics:** cc-workflow, dual-repo

**Trigger:** Timecards combining commits from both repos (code + docs) didn't show which computer or which repo each commit came from.

**Options Considered:**
1. Add machine/repo info to commit messages (change `/q-commit`) — rejected, data already exists
2. Change `/q-git-history` to stop filtering Machine: lines and add repo tag per commit ← Chosen
3. Change `/q-timecard` to annotate when merging histories — more complex, downstream

**Decision:** Fix the display layer in `/q-git-history` only. Stop filtering `Machine:` lines from commit bodies (so they appear as bullets), and add `(code)` or `(docs)` tag to each commit's datetime header line.

**Rationale:** The data was already in every commit message — `Machine:` footer from `/q-commit-local` and the repo identity from git. The issue was purely that q-git-history was filtering it out. Fixing display is retroactive (works on all existing commits) and requires no changes to commit format or timecard processing.

**Consequences:** Updated `~/.claude/commands/q-git-history.md` (global skill). Committed and pushed to global-claude-skills repo.

---

## 2. Enrollment Confirmation Email Is Transactional (Always Sends)
**Type:** Implementation
**Topics:** workflow, stripe

**Trigger:** Added enrollment confirmation email to Stripe webhook. Needed to decide whether it respects user email preferences.

**Options Considered:**
1. Use `sendEmailToUser()` — respects `email_course_update` preference, user can opt out
2. Use `sendEmail()` directly — always sends, bypasses preferences ← Chosen

**Decision:** Enrollment confirmation is a transactional email. Use `sendEmail()` + `getUserEmail()` directly, bypassing the preference system.

**Rationale:** The user took an explicit action (paid for a course) and expects confirmation. Transactional emails (receipts, enrollment confirmations, password resets) should always send. Notification emails (session reminders, marketing) should respect opt-out. The two functions in `@lib/email` map cleanly: `sendEmail()` = transactional, `sendEmailToUser()` = preference-aware.

**Consequences:** Created `src/emails/EnrollmentConfirmationEmail.tsx` and wired into `handleCheckoutCompleted` in `src/pages/api/webhooks/stripe.ts`.

---

## 3. Created ROLE-TRANSITIONS.md Reference Document
**Type:** Strategic
**Topics:** docs-infra, workflow

**Trigger:** User needed comprehensive documentation of how users acquire each role in the system.

**Options Considered:**
1. Add to existing `research/` specs — already large, role transitions span multiple specs
2. Add to CLAUDE.md — too detailed for project guidance
3. Create standalone reference doc at `docs/reference/ROLE-TRANSITIONS.md` ← Chosen

**Decision:** Created `docs/reference/ROLE-TRANSITIONS.md` covering all 7 role transition paths with authorization matrix, API endpoints, UI locations, and lifecycle diagrams.

**Rationale:** Role transitions are cross-cutting (auth, payments, admin, creator tools) and don't fit cleanly into any single existing doc. A dedicated reference doc serves as a single source of truth for "how does someone become X?"

**Consequences:** New file at `docs/reference/ROLE-TRANSITIONS.md`. Documents: Visitor→Student, Student→Enrolled, Visitor→Creator, Student→S-T (2 paths), Outside User→Moderator, User→Moderator, User→Admin.
