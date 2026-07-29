# State — Conv 431 (2026-07-29 ~13:45)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

A one-task conv that became a four-phase block. `[REC-MOBILE]` looked like a small mount change;
explaining *why it mattered* turned it into `DISCOVERY-ASIDE`, and Phases 1–3 all shipped —
narrow-screen recommendations restored on `/courses` + `/communities`, a Recently Visited lane with a
per-item remove, and cross-island + cross-tab sync. 3 code commits + 3 docs commits, all pushed.
Suite **6235 → 6289**; five gates green; `prov:sweep` consistent. Only Phase 4 (`[COMM-TOPICS]`)
remains, now `[Opus]`-tagged.

## Key Context

- **Next up:** `[COMM-TOPICS]` is #2 on the board (#1 `[BRIAN-ARTIFACTS]` stays externally blocked).
  It is `community_tags` — the *third* instance of the `user_tags`/`course_tags` pattern, so the table
  shape is precedent, not design. The real content is **governance**: cap the tag count (calibrated
  from real usage — 55 tags exist, courses average 2.5, max 3), union explicit with the derived
  roll-up, let moderators edit, give admins an override. **The cap must also be retrofitted onto
  courses**, where the hole already exists (`/api/me/courses/[id]/index.ts:434-450` is an unbounded
  `for` over `body.tags`). One decision is still open: **tag-level or topic-level** — I lean tags.

- **Why the cap is the non-negotiable piece.** The rails changed what a tag *is*: it went from a
  filing system the user pulls to a distribution channel the platform pushes, and `lanes.ts:124` ranks
  by overlap count — so claiming more topics ranks you higher. Creator-sole-source was fine for
  filing; it is hazardous for distribution.

- **Three premises in the task description were false, and each cost time to discover.** The
  `/communities` aside *already* used interests. `DiscoveryRails`' own doc comment claimed "no panel
  chrome" while `:146` renders one. And `feed_visits` looks exactly like a ready-made recency store
  but records the Feed *tab*, and writing to it would silently clear unread badges. Second conv
  running where the biggest saver was checking whether the thing being asked for already existed.

- **Three times a live probe read as a defect and was the instrument.** For You legitimately claiming
  a visited entity; `document.querySelector` returning the hidden island's button because the narrow
  mount precedes the `<aside>`; and measuring lane *headings* when only a *row* had changed. Measure
  at the granularity of the thing that changed, and scope DOM queries to the instance under test.

- **The dev seed masks two behaviours.** At 6 courses / 4 communities, For You claims nearly
  everything, so the recency lane rarely surfaces, and `maxItems={3}` never binds. Both are
  unit-tested; neither is provable live at this volume. Re-measure when either is next touched.

- `storage` events **cannot** sync two components in one document — the spec fires them only in *other*
  documents. Same-document sync needs a `window` `CustomEvent`; both are now wired in
  `lib/recent-visits.ts`.

- **MEMORY.md is at ~78% of the byte cap.** `[MEM-PRUNE]` fires at 80% and Conv 396 already spent its
  two biggest levers.

- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
