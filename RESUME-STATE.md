# State — Conv 429 (2026-07-29 ~06:49)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

A dev-tooling batch that kept turning into something larger. Closed `[DEVSRV-KILL]` and
`[DEVSRV-STALE]` (all three brick variants root-caused, including one recorded as "never fully
root-caused"), guarded the port-kill pattern at the hook layer and swept it out of four other places,
then — following the user's steer to trace three creator-course cards before deleting one — found and
fixed **a live user-facing defect on two `/creating` surfaces**, and closed `[PROV-DANGLE]` after
discovering the provenance gate validated only one of its two arrays. 4 code commits + 6 docs commits,
all pushed. Suite 6217 → **6219**; five gates green throughout; `prov:sweep` green.

## Key Context

- **Next up (my recommendation, your call):** `[WS-DATA-MODEL]`. It is now the single item with the
  most downstream drag — it has **blocked two tasks** (Conv 428's `/teaching` mixed-sourcing, and this
  conv's `[CRS-CREATED-CARD]` rehome option), and the update-plan agent flagged it as accumulating. It
  is `[Opus]`-tagged and wants its own conv: 3 dashboards + 2 endpoints + tests. Everything else on the
  board is small by comparison. Cheap alternatives if you'd rather warm up: `[PRUNESAFE]`,
  `[PROVDOC]`, `[RATING-COUNT-DEAD]`.

- **The user's steer is what found the bug, and that is the transferable lesson.** I had recommended
  deleting `CourseCreatedCard` on a correct field-by-field comparison. "Trace the origin of these three
  cards, I think there is more going on" turned a cleanup into a defect fix: the orphan was **the only
  place a correct three-state course status existed**. `courses.is_active` and `is_retired` are
  independent columns, neither creator endpoint SELECTed `is_retired`, and both cards rendered two
  states — so **a retired course displayed as "Active"/"Published" to its own creator** while
  `publish`/`unpublish` both reject it. **Ask what dead code *knows*, not who calls it.**

- **Three self-corrections this conv, all caught fast.** (1) Flagged Conv 321 as dropping three action
  links — it converted `<a href>`→`<Button href>`, nothing lost. (2) Logged `[PROV-DANGLE]` as
  "the sweep is one-directional" — wrong; section 4b already checks `COMPONENT_CANDIDATES`, the defect
  was **asymmetry** with the never-validated `PHASE6_EXTRAPOLATION_CANDIDATES`. (3) The `/r-end` prune
  gutted the Extract and had to be rebuilt by hand. Pattern: **read the implementation before writing
  the task that describes why it failed.**

- **`[PRUNESAFE]` is a live hazard in the r-end skill itself.** Step 4b honours whatever line numbers
  the learn-decide agent reports; this conv it reported 140, many merely referenced, and the prune cut
  §Completed from 8 items to 1. The Extract was restored manually, but **the next conv will hit this
  again** unless the manifest is intersected with the §Learnings/§Decisions line spans. Fix is
  specified in the task.

- **`prov:sweep` is green in both directions now.** Conv 428 cleared the stamped-but-unregistered
  errors; this conv added the missing existence check for Phase-6 entries and cleared 8 rows that had
  accumulated across six convs. Deleting a registered component now fails the gate until its row goes
  too. **Green gates conceal drift as effectively as red ones — nothing prompts a look at green.**

- **Dev-server teardown changed shape.** `npm run dev` **daemonizes and returns exit 0** on astro 7, so
  nothing tears it down for you — always `npx astro dev stop`. **Never** `lsof -ti:PORT | xargs kill`:
  it returns the browser's pid too (measured), and a hook rule now escalates it. The preflip worktree
  runs astro **6.3.7**, where `astro dev stop` *starts* a pre-flip server on :4321.

- **MEMORY.md is at 78% of the byte cap** and this conv added to three memory files. `[MEM-PRUNE]`
  fires at 80% and Conv 396 already spent its two biggest levers.

- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
