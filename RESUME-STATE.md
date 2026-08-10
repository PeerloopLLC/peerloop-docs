# State — Conv 434 (2026-08-10 ~14:42)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Client-change mode, continued from Conv 433. Two of five planned requests were delivered — the `/courses`
topic-pill hover elevation and the per-card journey CTA — and the rest of the conv went into the defects the
second request exposed, plus the flywheel flow it implied. Three previously-declined MERGE-BRIAN mechanisms
were adopted, a student can now ask to be certified to teach a course they completed, and creators have a
surface to act on those requests. Suite 6352 → 6375; six gates green (a new one was added).

## Key Context

- **The reusable move, and it worked three times: dissolve the objection rather than overrule it.** Each
  mechanism the client asked back had been declined for a *carrier* problem, not a design problem — raw hex for
  the pill shadows, a divergent client snapshot for the card CTA. Adopting them meant naming the values and
  sharing the resolver. `plan/merge-brian/NOT-ADOPTED.md` now carries **five** amended rows (two from Conv 433,
  three from this conv) and records that framing explicitly; re-read them before the client walkthrough.

- **`buildCoursePrimaryCta` now lives in `@lib/course-cta` and is the ONLY place a course CTA is decided.**
  Three surfaces call it — `/courses`, `/course/[slug]`, and the community Courses tab. Do not add a fourth
  implementation: the parity test in `tests/lib/course-cta.test.ts` exists to fail if one appears. Feeding it
  correctly matters as much as calling it — `nextSessionId` was added to the `/api/me/full` snapshot with a
  predicate deliberately matched to `computeCourseJourney` (scheduled OR in_progress, no future-only filter),
  because the existing `nextSessionAt` answers a different question and would have re-created the divergence.

- **`myCourseIds` was one bug wearing four hats.** It suppressed the enrol CTA for enrolments + teaching certs
  + created courses + *community-moderated* courses alike. Now: creators only. Everything else routes through
  the resolver. That single unpicking fixed a moderator seeing blank cards, a certified teacher being told to
  "Teach this course", a certified teacher who never enrolled getting nothing at all, and cancelled enrolments
  disagreeing between surfaces.

- **The teaching-request flow is live but its POST is untested — `[TREQ-TEST]`, #1 in the queue.** The
  idempotent replay (second call → 200 `alreadySent`, no second message) is the only thing keeping the
  "Teach this course" CTA from being a spam button aimed at a real inbox, and it is currently verified by hand
  only. `enrollments.teaching_request_sent_at` is the stamp; `/creating/requests` is where the creator acts.

- **`recommend.ts` now accepts the course CREATOR as well as a certified teacher — a documented model/code
  contradiction resolved in favour of the docs.** CLAUDE.md always said creators certify teachers; the endpoint
  said teacher-only. Creators are not reliably certified for their own courses (seed: Guy 4/4, Gabriel 0/2).
  Note there were **two** gates, not one — a positive test caught the second, which would have left the fix inert.

- **A whole defect class was invisible to every gate until this conv.** Invented Tailwind token names and
  MattIcon names fail silently; `npm run check:tokens` (`scripts/check-token-names.ts`, in `verify` and
  `/w-codecheck` #10) now catches them, and found 6 pre-existing `text-warning-600/700` defects on its first
  run. It polices only project-owned families so false positives stay at zero.

- **Local dev data was deliberately altered for testing.** Jennifer Kim is reset to an unsent state so the
  request flow can be demoed end to end; her seeded `cert-jennifer-cc-teach` was deleted (it caused a 409).
  Amanda Lee is left mid-flow with a pending recommendation. `npm run db:setup:local:dev` restores the original
  seed. Related: `[SEED-NOTIF-STALE]`.

- **The dev server bricked three times** on the `[DEVSRV-STALE]` Vite dep-optimizer cache, each time triggered
  by new imports. Expect it after import-heavy work: `npx astro dev stop` → `rm -rf node_modules/.vite` → restart.

- **Scripted edits damaged `CURRENT-TASKS.md` twice this conv** — the second was a slice-order bug that
  duplicated a body and orphaned another, caught only by `/r-commit`'s board gate. Use targeted anchored `Edit`s
  on that file per `[EDITSAFE]`.

- For the task backlog see `CURRENT-TASKS.md` — do not re-list here. Five items landed this conv:
  `[TREQ-TEST]` (#1), `[CD040-BATCH]` (#2), `[DIPL-SHELL]`, `[CTA-HOST-GUARD]`, `[SEED-NOTIF-STALE]`.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
