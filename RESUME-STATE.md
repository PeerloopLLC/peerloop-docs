# State — Conv 389 (2026-07-12 ~12:46)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 389 first built **[CERT-AUTO]** (auto-issue a course-completion *certificate*), then — after the user reframed the concept — **reshaped it into [DIPLOMA]**: course completion is now a **Diploma** (a non-certificate, derived from the completed enrollment) and `certificates` are **teach-readiness only**. Also shipped **[DIPLOMA-UI]** (the `/learning` Diplomas display). Everything is committed (Step 6 of this /r-end) and green (5 gates, suite 6888).

## Key Context

- **Task backlog is in `CURRENT-TASKS.md`** — do not re-list here. New low-pri follow-ups this conv: **[DIPLOMA-DOCS]** (route-stories.md "Certificate of Mastery" terminology) and **[DIPLOMA-SESS-EMAIL]** (session-path Diploma email). The active Opus-tier follow-up is **[CERT-MASTERY-UI]** — the teaching-certificate grant/recommend UI (backend exists) + cosmetic cleanup of dead completion/mastery labels + centralizing the duplicated `Certificate` row shape.
- **Two credentials, kept distinct** (memory `[[project_diploma_vs_certificate]]`): **Diploma** = course completion (factual, auto; no table — `enrollments.status='completed'` + new `diploma_awarded_at`; rendered `/diploma/[enrollmentId]`; counted in `user_stats.courses_completed`) vs **Certificate** = teach-readiness (`certificates.type='teaching'` ONLY — completion/mastery retired from the CHECK; human recommend→approve; `/certificates/[id]`). Never call a completion a "certificate".
- **Single completion hook:** `src/lib/completion.ts::onEnrollmentCompleted(db, enrollmentId, opts?)` — idempotent via `diploma_awarded_at`; called from ALL 3 completion paths (`progress.ts`, `admin/.../force-complete.ts`, and `booking.ts` session path, replacing its inline stat/notify block). The old `src/lib/certificates.ts` was deleted.
- **Gotchas:** (1) the session-completion path (booking.ts) does NOT send the Diploma email — no Resend key in scope ([DIPLOMA-SESS-EMAIL]). (2) A superseded commit `c1dfeb75` (the CERT-AUTO first cut, auto-issued a completion *certificate*) sits in `jfg-dev-14` history — its approach no longer reflects the codebase. (3) `certificate_url` stays NULL for teaching certs (the CERT-AUTO helper that set it was deleted).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
