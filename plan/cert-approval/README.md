# CERT-APPROVAL — Certificate Lifecycle

**Focus:** Full certificate lifecycle — creator approval UI, student certificate page, PDF generation & R2 storage, dead link fixes
**Status:** 📋 PENDING
**Origin:** Session 359 (capabilities review), Conv 007 (seed data review), Session 390 (LearnTab blocker), Conv 042 (CompletedTabContent dead link)

**⚠️ Conv 389 (DIPLOMA) reframe — this block is now TEACHING-certificate-only.** Course-completion credentials were split OUT: completion is now a **Diploma** (no `certificates` row — derived from the completed enrollment, rendered at `/diploma/[enrollmentId]`; see [plan/COMPLETED.md](../COMPLETED.md) #79). `certificates.type` CHECK was tightened to `('teaching')` (`completion`/`mastery` retired). Consequences for the phases below: (1) any "completion certificate" surface is now a Diploma and out of scope here; (2) **Phase-4's public `/certificates/[id]` page now EXISTS** (built Conv 389 — no-auth SSR teaching-cert display reusing the verify-loader pattern); remaining Phase-4 refinements (Share button, QR, OG tags) still open.

## What Exists

| Piece | Status | Location |
|-------|--------|----------|
| `certificates` table | ✅ Full schema | `migrations/0001_schema.sql:684` — id, user_id, course_id, type (`'teaching'` only — completion/mastery retired Conv 389), status (pending/issued/revoked), certificate_url (still NULL for teaching certs), recommended_by, issued_by |
| Admin list/create | ✅ Built | `GET/POST /api/admin/certificates` — paginated listing with status/type filters + stats |
| Admin approve | ✅ Built | `POST /api/admin/certificates/[id]/approve` — pending→issued, syncs `teacher_certifications` for teaching certs, sends email via Resend (`CertificateIssuedEmail`) + notification |
| Admin reject | ✅ Built | `POST /api/admin/certificates/[id]/reject` — hard-deletes pending cert |
| Admin revoke | ✅ Built | `POST /api/admin/certificates/[id]/revoke` — issued→revoked, deactivates teaching cert if applicable |
| Teacher recommend | ✅ Built | `POST /api/me/certificates/recommend` — teacher recommends enrolled student, creates `pending` cert (validates: active teacher, certified for course, student enrolled, student completed for teaching certs). **Widened Conv 434** — **both** authorization gates now also accept the **course creator**, matching CLAUDE.md's product model (creators certify teachers), which the endpoint as built contradicted. Necessary, not cosmetic: creators are not reliably certified for their own courses (dev seed: Guy 4/4, Gabriel 0/2), so without it half the courses dead-end. A *positive* test (creator **can** recommend) is what exposed the second gate — an earlier global "are you a teacher at all" check rejected non-teaching creators before the widened per-course check was reached, so updating only the existing negative test would have passed while the feature stayed inert. Negative test retained so the widening cannot drift into "any authenticated user" |
| Teaching request (student → creator) | ✅ Built Conv 434 | `[TEACH-REQ]` — `POST /api/me/courses/[courseId]/teaching-request` (idempotent) sets `enrollments.teaching_request_sent_at`, DMs the course creator with course + student detail via `sendDirectMessage` (**extracted** from `POST /api/conversations`, not copied — the original also bumps `updated_at` and the sender's `last_read_at`), and notifies with `actionUrl` → `/creating/requests`. Student surfaces: `/course/[slug]/teach` request page + a "Request has been sent" state on all three CTA surfaces |
| Creator request queue | ✅ Built Conv 434 | `[TEACH-REQ-CREATOR-PATH]` — `GET /api/me/teaching-requests` (scoped by **authorship**) + `CreatorTeachingRequests.tsx` as a **Requests** tab in `/creating`; reuses `RecommendCertButton`, so the creator's next step (recommend → pending cert → admin approval) is in place |
| My certificates | ✅ Built | `GET /api/me/certificates` — user's own certs with course/issuer joins |
| Public verify | ✅ Built | `GET /api/certificates/[id]/verify` — no-auth verification endpoint |
| CompletedTabContent | ✅ Rewired to Diploma | `src/components/discover/detail-tabs/CompletedTabContent.tsx` — "Your Diploma" view links `/diploma/[id]` (Conv 391 [DIPLOMA-UI-GAPS]); old dead `/course/[slug]/certificate` link removed |
| LearnTab | ✅ Rewired to Diploma | `src/components/courses/LearnTab.tsx` — completion card links "View Diploma" → `/diploma/[id]` (Conv 391 [DIPLOMA-UI-GAPS]) |

## What's Missing

**The certificate lifecycle has 5 gaps:**

1. **Creator has no approval UI** — Only admin can approve/reject. The flywheel requires creators to certify their own students. Creator dashboard has no pending-certificates view. **Partially eased Conv 434:** creators now have a `/creating/requests` queue and can *recommend* from it (creating a `pending` cert), but the approve/reject half is still admin-only.
2. **Creator not notified** — When a teacher recommends a student, no notification goes to the course creator. Only admin would see it. **Half-closed Conv 434:** the creator *is* now notified — and DM'd — when a **student** requests to teach the course (`[TEACH-REQ]`, `actionUrl` → `/creating/requests`). The **teacher→creator** recommendation notification (`cert.recommendation_received`) is still missing.
3. **No student certificate page** — `/course/[slug]/certificate` doesn't exist. The two UI elements that formerly linked to it (CompletedTabContent, LearnTab) were rewired to the **Diploma** (`/diploma/[id]`) in Conv 391 [DIPLOMA-UI-GAPS], since completion is a Diploma now; a per-course *completion*-cert page is no longer needed. Any remaining teaching-cert display uses `/certificates/[id]` (built Conv 389).
4. **No PDF generation** — No library installed, no template designed, `certificate_url` is always NULL. R2 helpers exist (`src/lib/r2.ts`) but no cert-specific upload code.
5. ~~**No public certificate view**~~ **ADDRESSED (Conv 389)** — `/certificates/[id]` shareable HTML page now exists (teaching-cert, no-auth SSR). The verify endpoint remains JSON-only for programmatic checks.

## CERT-APPROVAL.PHASE-1 — Dead Link Fix + Student Certificate Page

*Minimum viable: show certificate status to students who earned one, fix dead links*

- [ ] Create `/course/[slug]/certificate` page (Astro SSR)
  - Fetch user's certificate for this course via `GET /api/me/certificates` (filter by course)
  - States: not-authenticated → login redirect, no-certificate → "not earned", pending → "awaiting approval", issued → certificate display, revoked → revoked message
  - Issued state: show course name, student name, issue date, certificate ID, issuer name, type badge
  - If `certificate_url` exists: "Download PDF" button (for Phase 3)
  - If `certificate_url` is NULL: "PDF coming soon" note (graceful degradation)
  - Public share link: `/certificates/[id]/verify` (already exists as API, needs HTML page — see Phase 4)
- [x] Fix CompletedTabContent dead link — ✅ **Conv 391** [DIPLOMA-UI-GAPS]: rewired to the Diploma (`/diploma/[id]`) instead of a per-course completion-cert page (completion is a Diploma now, out of scope here); dead `/course/[slug]/certificate` link + "coming soon" disclaimer removed
- [x] Fix LearnTab TODO — ✅ **Conv 391** [DIPLOMA-UI-GAPS]: completion celebration card now links "View Diploma" → `/diploma/[id]`
- [ ] Tests: certificate page rendering (all 5 states), auth redirect, data display

## CERT-APPROVAL.PHASE-2 — Creator Approval Flow

*Creator-facing certification management — the flywheel step where creators certify graduates*

- [ ] `GET /api/me/courses/[id]/pending-certificates` — list pending certs for a creator's course
- [ ] `POST /api/me/courses/[id]/certificates/[certId]/approve` — creator approves (reuse approve logic from admin endpoint, verify creator owns course)
- [ ] `POST /api/me/courses/[id]/certificates/[certId]/reject` — creator rejects with reason
- [ ] Creator notification: when teacher recommends a student, notify the course creator (new notification type: `cert.recommendation_received`)
- [ ] Creator dashboard UI: "Pending Certifications" section or tab showing students awaiting approval
  - Student name, course, recommending teacher, recommendation date
  - Approve / Reject buttons with confirmation
- [ ] Student notification on approval/rejection (approval notification already exists via admin flow — verify it fires for creator approval too)
- [ ] Tests: creator approval/rejection, authorization (only course creator can approve), notification delivery
- [x] Build "Recommend for Certification" UI button on teacher-facing student views (Conv 082: `POST /api/me/certificates/recommend` has zero UI consumers) — ✅ **Conv 390** ([CERT-MASTERY-UI] A): shared `RecommendCertButton` (confirm→POST→optimistic "Recommended" pill) on both `MyStudents` (`/teaching/students`) + `TeacherCourseView`; `hasPendingCertRecommendation` flag added to `me/teacher-students.ts` + `teaching/courses/[courseId].ts`; DOM-verified end-to-end
- [x] Fix dashboard attention item "Certification recommendation" → link to actionable destination (currently `/teaching/students` has no recommend action) — ✅ **Conv 390**: the recommend action now lives on `/teaching/students` (exactly where `TeacherPendingActions`/`NeedsAttention` already pointed), closing the dangling loop
- [x] **Student-initiated entry into the pipeline** — ✅ **Conv 434** (`[TEACH-REQ]`): a student who has completed a course can request to teach it from the course card / detail page / community tab; `POST /api/me/courses/[courseId]/teaching-request` is idempotent, stamps `enrollments.teaching_request_sent_at`, DMs the **course creator** with the course + student detail and notifies them. Routed to the creator (not the assigned teacher) per user decision — it matches the product model *creators certify teachers*, and required widening `recommend.ts` to accept the creator, since a creator is not reliably certified for their own course and the request would otherwise arrive at someone who cannot act on it
- [x] **Creator-facing queue of inbound teaching requests** — ✅ **Conv 434** (`[TEACH-REQ-CREATOR-PATH]`): new **Requests** tab at `/creating` backed by `GET /api/me/teaching-requests` (authorship-scoped), reusing `RecommendCertButton` so the creator acts in place; notification `actionUrl` repointed here. **Chosen over widening `/teaching/courses/[id]`'s guards** — that workspace's student list is scoped `WHERE assigned_teacher_id = <viewer>`, so a creator who is not the assigned teacher would have landed on an **empty** list, which reads as the request having vanished (worse than the redirect). Verified on both an uncertified creator (reaches it) and a certified one (acts on it). Does **not** close the creator approve/reject items above — the creator still recommends into the admin-approval path
- [ ] Unified admin visibility for both certification paths (creator direct writes to `teacher_certifications` only; recommend/approve writes to `certificates` then syncs — admin Certificate Management page only shows `certificates` table)

## CERT-APPROVAL.PHASE-3 — PDF Generation & R2 Storage

*Generate certificate PDFs on approval and store to R2*

- [ ] Choose PDF library — candidates: `pdf-lib` (lightweight, no native deps, CF Workers compatible), `@react-pdf/renderer` (React-based templates), or server-side HTML→PDF
  - **Constraint:** Must work in Cloudflare Workers environment (no Puppeteer/Chrome)
- [ ] Design certificate template: course name, student name, date, certificate ID, type badge, creator signature area, verification QR code
- [ ] `generateCertificatePDF(cert)` function in `src/lib/certificates.ts`
- [ ] Hook into approve endpoint: generate PDF → upload to R2 at `certificates/{cert_id}/certificate.pdf` → store URL in `certificates.certificate_url`
- [ ] Update student certificate page: when `certificate_url` exists, show "Download PDF" button
- [ ] Seed data: add sample certificate URLs once generation works
- [ ] Tests: PDF generation, R2 upload, URL storage

## CERT-APPROVAL.PHASE-4 — Public Certificate Page (Optional)

*Shareable HTML certificate view — currently verify endpoint is JSON-only*

- [x] Create `/certificates/[id]` public page (no auth required) — ✅ **built Conv 389** (DIPLOMA); no-auth SSR teaching-cert display reusing the verify-loader pattern
  - Shows: recipient, course, issuer, date, type, validity status
  - Revoked certs: show revoked status with date
  - [ ] QR code linking back to this page for physical certificate verification (refinement — not yet built)
- [ ] Update student certificate page: "Share" button with copyable public URL
- [ ] Consider: Open Graph meta tags for social sharing preview
