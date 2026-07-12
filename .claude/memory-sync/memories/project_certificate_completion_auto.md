---
name: project_certificate_completion_auto
description: "Completion cert = auto-issued on completion (factual); Mastery/Teaching = human recommend→approve + separate UI (judgement). Cert artifact = rendered /certificates/[id] page, distinct from /verify/[id]."
metadata: 
  node_type: memory
  type: project
  originSessionId: 0078bc74-9da2-4c9e-a073-e54b56f8df28
---

[CERT-AUTO] Conv 389 — the certificate model split (user decision):

- **Certificate of Completion = FACTUAL** ("did they finish the modules?") → **auto-issued** on course completion. No human judgement. Issued from `src/lib/certificates.ts::issueCompletionCertificate(db, {studentId, courseId}, {resendApiKey, appUrl})` — called from BOTH completion paths: `enrollments/[id]/progress.ts` (student self-complete, last module → enrollment 'completed') and `admin/enrollments/[id]/force-complete.ts`. Idempotent vs `UNIQUE(user_id,course_id,type)` (no duplicate row/email/notification on re-complete; does NOT resurrect a revoked cert). Attributed to the **course Creator** (`issued_by_user_id = courses.creator_id`, per docs GO-011 "Creator grants certificates"). Sets `certificate_url='/certificates/{id}'` (relative). Fires `notifyCertificateEarned` + `CertificateIssuedEmail` best-effort (email skipped when no `RESEND_API_KEY`).

- **Mastery / Teaching ("able to teach") = JUDGEMENT** → NOT auto-issued. Keep the existing human flow (`me/certificates/recommend.ts` → `admin/certificates/[id]/approve.ts`, `'mastery'`/`'teaching'` types + `teacher_certifications` upsert). User: "a different beast, needs a separate UI" → deferred to backlog **[CERT-MASTERY-UI]** (the grant/recommend + review UI is the gap; backend exists).

- **Two cert pages, distinct:** `/verify/[id].astro` (CVER) = public verification *statement*; `/certificates/[id].astro` (CDOC, `@matt-inspired`, added Conv 389) = the printable rendered *artifact* (the "generated certificate"; "download" = browser Print-to-PDF). Both reuse the CVER SSR loader `fetchCertificateVerifyData`. The email "View Certificate" button + `certificate_earned` notification link to `/certificates/{id}` — that page did NOT exist before Conv 389 (broken link; only `/verify` existed).

- **No PDF/R2 artifact** — HTML page chosen over generated PDF (user pick). `certificate_url` was NEVER populated before Conv 389; the completion path is the first writer.

- Canonical `Certificate` interface added to `db/types.ts`; 4 endpoints still duplicate the row shape inline (dedup folded into [CERT-MASTERY-UI]).

Related: [[reference_chrome_bridge_island_stale_cache]] (dev-login for browser-verifying gated flows).
