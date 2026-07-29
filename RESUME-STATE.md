# State — Conv 430 (2026-07-29 ~08:43)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Two tasks closed, and both of them turned out to be smaller than their descriptions said —
because in each case the thing the task asked me to build already existed. `[WS-DATA-MODEL]`
(the item that had blocked two prior tasks) resolved to *scoping* a principle decided in Conv 014,
not authoring a new one; its audit then found two live user-facing defects, both fixed. `[PRUNESAFE]`
made the `/r-end` Extract prune structural rather than agent-self-reported, in time to protect this
conv's own Extract. 1 code commit + 3 docs commits, all pushed. Suite 6219 → **6235**; five gates
green; `prov:sweep` consistent.

## Key Context

- **Next up (my recommendation, your call):** `[REC-MOBILE]` — no recommendations surface below the
  `lg` breakpoint after the rail rehome, a real user-facing gap that wants live measurement at real
  viewports (see `[MINWIDTH]`/`reference_responsive_iframe_harness` — media queries key off the
  iframe, not the viewport). `[BRIAN-ARTIFACTS]` still sits at #1 but is externally blocked on the
  client. Cheaper alternatives: `[PROVDOC]`, `[RATING-COUNT-DEAD]`, or the `[A11Y]`/`[RHOOKS]` lint
  triage (164 warnings the gates report every run).

- **The transferable lesson, twice over: check whether the rule already exists.** `[WS-DATA-MODEL]`
  had been logged across two convs as "never been decided". It *had* been —
  `state-management.md:288`, "Principle: Consume What's Loaded", Conv 014, with the freshness split
  already stated at `:281`. I repeated the task's framing before reading the doc and had to correct
  it mid-task. **A task's own description is a hypothesis, and that includes its claims about what
  has *not* happened.** Grep `docs/as-designed/` for the concept before designing a convention.

- **Option (a) of that task was not implementable at all** — "CurrentUser-first everywhere, shed the
  aggregate endpoints" can't happen, because both endpoints are mostly other users' rows and money.
  Worth verifying each option is *achievable* before offering a pick; an option list is a claim about
  the world too.

- **The audit's side questions outproduced its main question.** The main one resolved to "the
  existing principle". The prerequisite checks found `[MEFULL-SOFTDEL]` (a soft-deleted course left
  `isCreator === true`, so the Sidebar offered a workspace that rendered empty) and `[CMPL-NOBUMP]`
  (**`/learning` showed "Continue Learning" for a completed course** — `onEnrollmentCompleted` has 3
  call paths and only 2 bumped `data_version`; the third is the BBB-webhook/cron path). Both fixed,
  guards calibrated both ways.

- **`[PRUNESAFE]` is fixed but not yet *proven in the wild*.** Its first live run this conv was
  86/86 in-span, 0 ignored — the Conv-429 condition didn't recur, so the guard had nothing to reject.
  It stands on `extract-prune.test.sh` (19 assertions, calibrated in both directions). If a future
  `/r-end` prints a non-zero `IGNORED (out-of-span)` count, that is the guard doing its job, not an
  error.

- **`StudentDashboard.test.tsx` mocks `CurrentUser` as a hand-rolled partial duck-type** — adding one
  getter to the real class broke 23 tests there. The new `DiplomasSection.test.tsx` builds a real
  `CurrentUser` from a `MeFullResponse` fixture instead. Prefer that shape when touching the class.

- **MEMORY.md is at ~78% of the byte cap** and this conv edited one memory file. `[MEM-PRUNE]` fires
  at 80%, and Conv 396 already spent its two biggest levers.

- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
