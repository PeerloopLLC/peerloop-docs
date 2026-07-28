# State — Conv 426 (2026-07-28 ~08:34)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Took MERGE-BRIAN §3 (communities) from an empty plan section to complete: censused 20 files at the
pivot, inventoried 16 mechanisms, dispositioned every one (2 ADOPT · 12 ADAPT · 2 DROP), then built
all 13 buildable ones across three tiers. Also created `plan/merge-brian/NOT-ADOPTED.md`, a
client-facing ledger of everything of Brian's that is *not* in our app, written for a live
walkthrough with him. Two of the three findings were pre-existing defects of ours, both fixed.
Code `bcccab92`, docs `27aa5c4` + this conv's bookkeeping commit; suite 6165 → 6234; 5 gates green.

## Key Context

- **§3 is complete for everything buildable. Only N8 remains**, gated on `[REC-REHOME]` — which this
  conv **widened to cover both recommendation carousels** (courses *and* communities), because each
  page is the sole consumer of its carousel and each carousel the sole caller of its API, and the two
  would compete for the same destination. **That destination is still the open decision** — Home is
  the obvious candidate but `[FEEDS]` (Conv 267) bars re-adding panel surfaces to `/`. Decide it once,
  for both, before starting.
- **The most transferable lesson: reading a client's fork is a free audit of your own codebase.** Two
  of the three §3 findings were *our* defects that Brian had already tripped over and fixed on his
  side — course-thumbnail uploads writing `/api/storage/{key}` URLs that no route served, and community
  Join/Leave dying on client-side navigation. Neither was discoverable from our own tests: the first is
  masked because seeds use external `picsum` URLs, the second only manifests when you reach a *second*
  community without a full page load. Treat a fork's bug-fix commits as pointing at our untested seams.
- **Confirm a plausible defect with a control before fixing it.** F4 was proved by showing the *working*
  case too: same page, same button, same user — hard load fires the POST, client-side arrival produces
  zero requests. Patch `window.fetch` to record and never settle (`return new Promise(() => {})`) so the
  handler fires without mutating state and without reaching `alert()`/`reload()` (a modal freezes the
  browser bridge).
- **jsdom collapses File bodies through a Request round-trip** — `size` reads 9 regardless of input,
  while `type`/`name` survive. It silently neutered a 2MB size-cap assertion. When a handler only
  consumes `request.formData()`, hand it the FormData directly.
- **Aggregates must copy the visibility predicate of the surface they summarise.** His per-community
  course counts filtered only `is_active = 1`; ours match `fetchCommunityProgressionsData`, so a card
  can't advertise courses the Courses tab won't list. Rating is review-count-weighted, not a flat mean.
- **Two of my own numbers were wrong and were caught by the r-end agents**, not by me: the disposition
  tally (2 ADOPT, not 3) and the new-test-file count (5, not 4 — `git show --stat` truncates long paths,
  so verify with `--name-only`). Both fixed everywhere.
- `NOT-ADOPTED.md` is kept current by **README ground rule 9**, not by a task: every disposition mirrors
  into it in the same conv. It now carries a "where his work fixed real defects on our side" section,
  which is the part worth leading with in the client conversation.
- Remaining MERGE-BRIAN: §4 (site-wide shell track — the architectural one), §5 (sessions-files feature
  decision), §6 (misc), plus §2's M3/M4 and §3's N8.
- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
