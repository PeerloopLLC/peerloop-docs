# State — Conv 435 (2026-08-10 ~17:36)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Cleared two pieces of Conv-434 debt — the untested teaching-request POST and the unwritten client RFC — then
took a new client request (the `/courses` right panel on detail pages) from ask to shipped phase A, and brought
staging current after finding it two convs behind with a missing column. Suite 6375 → 6383; six gates green.
The remainder of the panel work is parked on the client's verdict.

## Key Context

- **A green gate set is not evidence that a page lays out.** Phase A's first cut made `AppLayout`'s content
  row `lg:flex-row` whenever a right panel was present. In the default top-strip layout that turned the
  full-width SubNav strip into a flex column: it took **643px of a 948px row and collapsed the content div to
  `w=0`** — a course page rendering nothing — while `tsc`, `astro check`, ESLint, `npm run build` and 6383
  tests all passed. Caught only by measuring boxes in the iframe harness. Any future change to that row needs
  the same measurement; there is still **no automated guard**, which is one of the parked decisions.

- **`[RAIL-DETAIL]` is ONE parked task, gated on the client accepting the panel on `/course/{slug}`.** Its body
  leads with a WHAT'S LEFT block: phase B (migrate `/`, `/courses`, `/communities` onto the shared shell — the
  part that actually removes the drift risk), phase C (`/community/[slug]`, and `/@[handle]` whose
  `max-w-4xl mx-auto` cap is the real obstacle), the 422px rail-mode column, the regression guard, and folding
  into CD-041. Tagged `[Opus]`. If he rejects the panel, phase A comes back out and all of it dissolves —
  which is why it is one task and not five.

- **The rail width rule is load-bearing for phase B.** The component default is `lg:flex-1`; `/course/[slug]`
  overrides it to `lg:w-[284px]`. On the three listing pages the rail is the *remainder* beside a
  `max-w-[640px]` content column (measured 284px @≥1440, 273 @1280), so leaving the default alone is what makes
  phase B a visual no-op. Do not "tidy" the override away.

- **`[SLOT-COLLIDE]` is a mistake I made, not inherited.** `AppLayout`'s new slot is named `right-panel`, and
  `ListingShell` already had a `right-panel` slot meaning the *filter aside* — which renders on the **LEFT** in
  side-rail mode. Renaming is cheapest now (one consumer) and gets worse after phase B adds three.

- **Staging is CURRENT at Conv 435 and verified live.** The real finding was that **Conv 434 changed the schema
  and never deployed**: staging sat two convs behind, missing `enrollments.teaching_request_sent_at`. Reseed was
  NOT needed (seed files last changed Conv 432); one additive `ALTER` closed it. **ALTER before deploy** — the
  reverse order 500s `/courses` and `/course/{slug}`. Cron needed nothing (deployed 2026-07-29, after its last
  code change). Nothing detects this drift automatically; the name-level signature diff that found it is ~6
  lines and could become a `check:staging-drift` gate (offered, not taken up).

- **`wrangler deployments list` prints OLDEST-FIRST.** A truncated head of it nearly became a report that
  staging's cron was four months stale. Count entries and read the tail.

- **CD-040 is retrospective and says so.** `docs/requirements/rfc/CD-040/original.txt` is a *reconstruction*
  from both convs' Extracts, because this batch arrived verbally rather than as one pasted note. Before the
  client walkthrough, read it together with the five amended rows in `plan/merge-brian/NOT-ADOPTED.md` — the
  framing that matters is that each objection was **dissolved, not overruled**.

- For the task backlog see `CURRENT-TASKS.md` — do not re-list here. Three items landed this conv:
  `[SLOT-COLLIDE]`, `[QSLOT]`, and the re-scoped `[RAIL-DETAIL]`.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
