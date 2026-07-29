# State — Conv 432 (2026-07-29 ~19:10)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

One task, `[COMM-TOPICS]`, which closed **DISCOVERY-ASIDE** entirely — all four phases now shipped.
Communities got first-class `community_tags`, unioned with the derived roll-up rather than replacing
it; the tag cap shipped on **two** axes instead of the specified one; and `courses.primary_topic_id`
was removed, reversing Conv 108. Then deployed and reseeded staging. Suite **6289 → 6335**, lint
**164 → 163**, five gates green, `prov:sweep` consistent. 2 code commits + docs; all pushed.

## Key Context

- **Both of this conv's `AskUserQuestion` picks were load-bearing, not stylistic.** That is the
  reusable lesson: the investigation found two *false premises in the plan itself*, and surfacing
  them as choices rather than proceeding on the durable default was what let the user own the scope
  widening. Worth repeating when a plan's stated premises don't survive contact with the code.

- **The cap was denominated in the wrong unit, and only checking the consumer revealed it.**
  `lanes.ts` ranks For You by **distinct topic** overlap, not tag count — five tags inside one topic
  score `overlap = 1`. The Conv-431 calibration (2.5 tags avg / max 3) was measuring the wrong thing;
  resolving the same seed through `tags.topic_id` gives **1.67 topics avg / max 2**. Shipped as
  `MAX_ENTITY_TAGS = 5` **and** `MAX_ENTITY_TOPICS = 3` because `smart-feed/scoring.ts` scores at tag
  granularity while the rails score at topic granularity — two payoffs, two caps. `user_tags` stays
  uncapped: interests are self-affecting.

- **A seed-only-written column is worse than a missing one.** `courses.primary_topic_id` had exactly
  one writer in the whole repo — the dev seed — so `/courses`' topic filter worked perfectly in demos
  and was broken for every course created through the product. Conv 108's rationale, *"all seed
  courses assigned a topic ID"*, was the tell in hindsight: that **was** the whole population. When a
  filter or ranking reads a column, grep the write paths, not just the reads.

- **`src/lib/entity-tags.ts` is the new shared surface** — `resolveEntityTags` (rejects, for user
  claims) vs `capTagsPreservingTopics` (truncates round-robin, for system defaults). Round-robin
  matters: a prefix truncation can spend the whole budget in one topic and drop the others, which is
  the signal the cap exists to protect.

- **Two SQLite gotchas now encoded in comments.** `COLLATE NOCASE` binds to the wrong operand under
  `IN` (use `lower()` both sides); and there is no LATERAL, so a correlated reference from inside a
  FROM-subquery is undependable — the community topic union is two concatenated scalar subqueries,
  normalised by `parseTopicIdList`.

- **Same unscoped-selector error as Conv 431, caught by re-measuring.** `a[href^="/community/"]`
  picked up `DiscoveryRailCard` links from the `lg:hidden` rails mount, which still hydrates at
  desktop width. Scope live DOM queries to `article[data-prov-name="..."]` — this codebase renders
  the same entity in multiple simultaneously-hydrated islands.

- **Staging has schema drift beyond what any one conv introduces.** A probe error revealed
  `enrollments.payment_intent_id` missing there — unrelated to this work. Reset+migrate is the
  reliable path; `ALTER` only fixes gaps you already know about. Staging was at the **feeds** seed
  level, so `db:setup:staging:feeds` is the restore command, not `:dev`. Also: after changing
  anything under `src/lib/`, check `workers/*/src/` — the cron worker imports `compute.ts` and needed
  its own deploy.

- For the task backlog see `CURRENT-TASKS.md` — do not re-list here. Two new/extended doc-drift items
  landed from the r-end docs agent (`[SCHEMADIAG]`, `[COMPDOC]`), both pre-existing.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
