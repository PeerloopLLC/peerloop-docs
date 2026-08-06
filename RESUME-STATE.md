# State — Conv 433 (2026-08-05 ~15:47)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

First conv of a new mode: the user presents client UI requests one at a time. Request #1 was the
course card's community footer — adopt the client's band background and logo treatment. That
shipped as `[COMM-BAND-ADOPT]`, then widened into `[COMM-IDENT]` when propagating the treatment to
the `/communities` card exposed that the same asset means two different things on the two surfaces.
Deployed to staging (`fe385247`) and verified live. Suite **6335 → 6347**, five gates green.

## Key Context

- **The reusable lesson is about propagation, not colour.** `communities.logo_url` renders on both
  catalog cards. On the **course** card it is a *foreign* entity — a seal bridging the cover→band
  seam that names another community, which is what justifies the overhang and white ring. On the
  **community** card it is the card's *own* subject, with no seam to bridge. Identical asset,
  opposite meaning. The medallion was propagated, looked like a consistency win, and was reversed.
  Before moving a visual treatment between surfaces, ask what the element *means* on each.

- **A test assertion inverted twice in one conv is a smell, and it fired here.** The
  `CommunityCatalogCard` medallion guard was flipped to assert the treatment, then flipped back.
  The churn meant it was implicitly asking "does this match the course card?" — a question about
  another file. It is now written against the meaning ("the logo is this card's own subject").
  Contrast the *tokenisation* guard in the same file, which survived both reversals untouched
  because it encodes a discipline, not a decision: adopting the client's COLOUR must never mean
  inlining his HEX.

- **Check write paths before believing a field is supported.** `logo_url` and `cover_image_url`
  look symmetric in the schema and are not — the logo has a real R2 upload endpoint with delete
  plus an instant-managed settings control; the cover is a **pasted URL in a text box**, no upload,
  no storage. That is *why* the seed uses picsum. Same class as Conv 432's `primary_topic_id`
  finding. Tracked as `[COMM-IMG]` (#2 in 🎯 Now) — **`/communities` cannot be judged visually
  until it lands**, because the seed "logos" are random photographs.

- **A pre-Conv-423 branch's spacing classes may port 1:1 — verify, don't assume either way.** Every
  number in the client's `CommunityBand.tsx` (`gap-8`, `px-24`, `py-8`, `left-20`) was already
  among the ten `--spacing-N` names his branch overrode to literal px, so all resolved identically
  under our base. One command against his `tokens-tailwind-bridge.css` removed the whole risk.

- **Two premises stated in the request did not survive checking.** The card was described as being
  on the home page; `CommunityAffiliation` has exactly two consumers and `index.astro` renders
  neither — it is `/courses` plus the community Courses tab. And the change reverses a MERGE-BRIAN
  §1 "not adopted" note whose stated reason (per-community `accent_color`) is moot — the client
  disabled that tinting on his own branch in his Conv 373. Both docstrings corrected.

- **New tokens:** `--brian-band` (#e3f1fc) / `--brian-band-line` (#d3e7f8) in the existing `brian-*`
  namespace for verbatim client palette values. New component API: `CommunityAffiliation` takes
  `presentation: 'inline' | 'band'` — `CourseHeader` uses `inline` on its dark hero and must stay
  that way; `tests/components/entity/CommunityAffiliation.test.tsx` is the only thing guarding it,
  since `CourseHeader` has no tests of its own.

- **Working model for this mode:** implement each client request as it lands, track it under its own
  `[CODE]`, and fold the batch into **CD-040** via `/w-add-client-note` once several accumulate —
  rather than opening an RFC folder per one-liner.

- For the task backlog see `CURRENT-TASKS.md` — do not re-list here. Two new items landed this
  conv: `[COMM-IMG]` (#2) and `[CD035-STALE]` (#3, CD-035 reads 0/34 done but CD-039 shipped part
  of its checklist and the component it names no longer exists).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
