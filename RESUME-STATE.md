# State — Conv 427 (2026-07-28 ~11:19)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Took `[REC-REHOME]` from "blocked, destination undecided" to built, and in doing so closed both of
MERGE-BRIAN's remaining gated carousel mechanisms (§2 M4, §3 N8) — **§3 is now complete; §2 has only
M3 left.** The recommendations moved out of the two listing columns into the right rail as
rails-backed lanes off the single Discovery Rails blob; both carousels and both
`/api/recommendations/*` endpoints are deleted. Code `9b0c5dff`, docs `d742c0b` + this conv's
bookkeeping commit; suite 6234 → 6210; 5 gates green.

## Key Context

- **Next conv (user's steer): MERGE-BRIAN §2 M3, and likely `[ROLE-CRS-LIST]` which gates it.** M3 is
  `[CRS-ROLE-TABS-OFF]` — hiding the As-Student / Teaching / Moderating role tabs on `/courses`. It
  cannot ship until `/teaching` (and the moderating lens) has a courses-list page, because
  `/courses#teaching` is currently the *only* list of the courses a teacher teaches. Same shape as the
  work just finished: build the destination first, then hide the old surface. `[ROLE-CRS-LIST]` is
  position 2 on the board and carries `[Opus]`.
- **The most transferable lesson: a task's own stated blocker is a claim, not a given.**
  `[REC-REHOME]` sat blocked two convs on "destination undecided — Home is obvious but `[FEEDS]` bars
  panel surfaces on `/`". Every load-bearing clause was wrong: `/feeds` had been **retired in Conv
  331** (the memory still called it the Discover destination), `[FEEDS]`'s bar named three specific
  composites in the **feed column** not all panels on `/`, and Home already shipped an equivalent
  surface via `SmartFeed`'s rails-backed `suggestion-card`s. Re-testing it took ~15 minutes and turned
  a product decision into a build. Apply the same suspicion to M3's blocker before starting.
- **Grep `plan/` and `lib/*/types.ts` headers for the feature noun before designing.** Two separate
  disposition walks invented a prerequisite task without noticing that `plan/home-feed-merge`
  **#34 `[RECO-UNIFY]`** already scoped this exact refactor, and that `lib/discovery-rails/types.ts`
  names the reco bands as its intended consumer in a comment. Once found, the build was much smaller —
  `lib/discovery-rails/client.ts` already had the cache + personalization lens (shipped Conv 261 with
  tests only; this conv is its first production consumer).
- **Personalization needed no new endpoint:** `CurrentUser` already carries `interestTopicIds` via
  `/api/me/full`. Check `src/lib/current-user.ts` before adding any per-viewer fetch to an island.
- **The three-state auth gate has now bitten three times** (`[MSGBOOT]` 417, `[COURSETAB-HASH]` 419,
  and pre-empted here). Any island whose output differs for members vs visitors must gate on
  `useAuthStatus() === 'loading'`, not `useCurrentUser()` truthiness — here the failure would have been
  silent (a member losing their For You lane on cold load), not a crash.
- **Verification method worth reusing:** for a ranked/deduped surface, compute the expected output from
  the source data *first*, then read the DOM and compare. Predicting marcus's For You order from the
  blob before looking is what made "it renders" into evidence the ranking works.
- **`prov:sweep` stays at its 11-issue `[PROV-SWEEP-DEBT2]` baseline** — new stamped components must be
  added to `scripts/matt-inspired-registry.ts` or it goes red (the Conv-425 lesson).
- Two items this conv surfaced and left on the board, both position 3-4: **`[OVERLAY-ORPHAN]`**
  (`variant="overlay"` now has zero call sites on both catalog cards — keep or delete; the Conv-425
  precedent argues delete, but that removed an *undocumented* stranded path) and **`[REC-MOBILE]`**
  (the rail is `hidden lg:block`, so nothing renders below `lg`).
- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
