# State — Conv 428 (2026-07-28 ~17:45)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Closed **MERGE-BRIAN** — the ~33-conv client-branch review programme (Convs 396–428). Walked and built
the last four review units (§2 M3, §4, §5, §6), then cleared the four follow-ups they spun off, ran a
role-workspace consistency assessment that surfaced and fixed a live defect, and turned the
permanently-red `prov:sweep` gate green. 7 code commits + 10 docs commits; suite 6210 → **6217**;
five gates green throughout.

## Key Context

- **Next up (my recommendation, your call):** the **dev-tooling batch** — `[DEVSRV-STALE]`,
  `[DEVSRV-KILL]`, `[BRIDGE-RESIZE]`. These taxed this conv directly: a stale astro daemon served 500s
  and made `/teaching` look broken until diagnosed, and `[BRIDGE-RESIZE]` (resize_window silently
  ignores width) is why the `StickyViewTitle` viewport question could only be answered at 1059px
  rather than at the ~800px laptop height where it actually matters. They degrade live verification,
  which is what caught every real defect this conv.

- **The transferable lesson, now with a track record: a recorded blocker is a claim, not a fact.**
  Three consecutive convs have been collapsed by re-testing one — `[REC-REHOME]` (427),
  `[ROLE-CRS-LIST]` and §5 (428). The discipline that works: **check the claim against the code that
  CONSUMES the thing**, never the definition or the comment describing it. `[ROLE-CRS-LIST]`'s gate had
  four of five load-bearing claims false; §5's "feature decision" had already been decided in three
  earlier walks. Apply the same suspicion to `[CRS-CREATED-CARD]` and `[WS-DATA-MODEL]` before starting.

- **Gates did not catch any of this conv's three self-inflicted problems.** The `/courses#teaching`
  stranding (viewers trapped in a lens with no exit), the §4 relabel gap (`Teacher Management` missed
  because the census grepped exact `Teachers` tokens), and five deleted Done records — all had five
  green gates. **Live verification and re-reading found them.** Budget for verification, not just gates.

- **`prov:sweep` is GREEN** (11 → 0) and must stay that way. It had been red since Conv 416 and this
  conv reported it as "at baseline" eight times before the word was questioned. New stamped components
  must be added to `scripts/matt-inspired-registry.ts`, and a registered component must carry the
  stamp — `CourseRail` needed both.

- **Never normalise a failing gate.** That is the meta-lesson: the phrase "at baseline" was doing the
  concealing. If a gate is red and expected to be red, either fix it or turn it off — a detector
  reported as routinely failing has been switched off without anyone deciding to.

- **`[EDITSAFE]` refinement:** a unique anchor is not automatically a *correctly-placed* one. Five
  completion records went into a task **body** instead of `## ✅ Done this conv` and were deleted when
  that task closed. Check the section, not just the string.

- **MERGE-BRIAN's one open item is external** — the "approved Option B / mockup" artifacts Brian's
  commits cite exist nowhere in git. Tracked as `[BRIAN-ARTIFACTS]` (👀 watch). The client-facing
  `plan/merge-brian/NOT-ADOPTED.md` is closed out and ready to walk through with him; that conversation
  may reopen dispositions, which is expected and fine.

- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
