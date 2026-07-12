---
name: project_diploma_vs_certificate
description: "Two SEPARATE completion credentials — Diploma (course completion, factual, auto, derived from enrollment, NOT a certificate) vs Certificate (teach-readiness, judgment, human-granted, certificates.type='teaching' only). Conv 389 [DIPLOMA] de-conflated them."
metadata: 
  node_type: memory
  type: project
  originSessionId: 0078bc74-9da2-4c9e-a073-e54b56f8df28
---

[DIPLOMA] Conv 389 — the app de-conflated two things it used to call "certificate". The original single concept was **teach-readiness** ("mastery" = able to teach); a completion event should NOT create a "certificate". Now two distinct credentials:

- **Diploma = course COMPLETION** (factual, "you finished"). Auto-awarded on completion. **Has NO table** — derived from the completed enrollment (`enrollments.status='completed'` + `diploma_awarded_at`), rendered at **`/diploma/{enrollmentId}`** (loader `ssr/loaders/diploma.ts`, page-code DIPL, `@matt-inspired`). Counted in `user_stats.courses_completed`. NOT a certificate.
- **Certificate = TEACH-readiness** (judgment, "you can teach it"). `certificates.type` is **`'teaching'` ONLY** — Conv 389 retired `'completion'` and `'mastery'` from the CHECK (`CHECK (type IN ('teaching'))`). Human-granted via recommend→approve (`me/certificates/recommend.ts` → `admin/certificates/[id]/approve.ts`, which upserts `teacher_certifications`). Rendered at **`/certificates/{id}`** (CDOC); `CertificateIssuedEmail` reworded to teaching copy. Recommend now requires the student to have COMPLETED the course (earned its Diploma) first.

**The completion side-effects hook: `src/lib/completion.ts` `onEnrollmentCompleted(db, enrollmentId, opts?)`** — the SINGLE place completion side-effects run. Idempotent via `enrollments.diploma_awarded_at` (never cleared, so awards fire at most once even across un-complete→re-complete). Bumps `courses_completed` (student) + `students_taught` (assigned teacher), fires `notifyEnrollmentCompleted` (student + teacher), sends `DiplomaEmail` (student, only when `resendApiKey` in opts). Called from ALL THREE completion paths:
  - `api/enrollments/[id]/progress.ts` (student self-marks all modules) — passes env → email sent.
  - `api/admin/enrollments/[id]/force-complete.ts` (admin override) — passes env → email sent.
  - `lib/booking.ts` `triggerPostSessionActions` (a completed session per module — the session path) — NO env in scope, so in-app notification + stat fire but NO Diploma email (documented limitation). This replaced booking's old inline `courses_completed++`/`students_taught++`/notify block, which previously was the ONLY path that bumped the stat and never issued any credential.

**History (do not repeat the mistake):** Conv 389 first shipped completion as an auto-issued `certificates` row (`issueCompletionCertificate`, since DELETED). User flagged the conflation ("mastery was my word for able-to-teach; a completion shouldn't be a certificate") → reshaped to the Diploma model above. `src/lib/certificates.ts` was deleted; the old `/certificates/[id]` completion page was repurposed to render teaching certs.

**Still PARKED after Conv 389** (see [CERT-MASTERY-UI] / [DIPLOMA-UI] in CURRENT-TASKS): the `/learning` student view does NOT yet show Diplomas (its `CertificatesSection` reads `/api/me/certificates` = teaching certs only); a DiplomasSection + `/api/me/diplomas` is unbuilt. Display components (`CertificateDetailContent`, `CertificatesAdmin`, `TeacherProfile`, `ssr/loaders/teachers.ts`) still list `completion`/`mastery` in their local unions/label-maps (dead but harmless — cosmetic cleanup pending). Mastery/teaching grant UI is [CERT-MASTERY-UI].

Related: [[reference_chrome_bridge_island_stale_cache]] (dev-login for browser-verifying gated flows).
