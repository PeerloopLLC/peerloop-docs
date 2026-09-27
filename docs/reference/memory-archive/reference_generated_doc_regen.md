---
name: reference-generated-doc-regen
description: "Generated/projection docs (route maps) auto-regenerate at r-end Step 5c via regen-generated-docs.mjs — never TaskCreate a 'regen stale route docs' item"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 983906c1-fcf6-49de-a08a-e54f254b2e52
---

**[DOCGEN] mechanism (Conv 246).** Docs that are pure *projections of code* (the route maps) regenerate **deterministically at r-end Step 5c** — they must **never** be tracked as a "regenerate stale route docs" task (that was the recurring #22 [DOCS-ROUTES-STALE] anti-pattern). The category `generated` now has teeth.

**How it works:**
- `.claude/config.json` docsRegistry → group `route-docs-generated` (category `generated`) carries a `regen: { cwd:"code", commands:[route-matrix.mjs, route-api-map.mjs], inputs:["src/pages/**","src/components/**","src/lib/**"], alsoWrites:["tests/plato/route-map.generated.ts"] }` binding. Placed **above** `architecture-active` so first-match-wins resolves the `.md` files to `generated`, not `driftCheck`.
- r-end **Step 5c** runs `.claude/scripts/regen-generated-docs.mjs` (before commit + before `advance-drift-baseline.sh`, which would otherwise zero the change set). For each generated group it re-runs `commands` **only if** this conv's code changes (vs `.drift-baseline-sha`) touched an `inputs` glob, then `git add`s output in BOTH repos. Idempotent + inputs-gated so day-stamped docs (`page-connections.md`) don't churn on doc-only convs.
- r-end Agent 3 (docs) no longer regenerates route docs (priority-2 removed) and treats `generated` docs as out-of-scope.

**The 5 generated route docs:** `route-api-map.md`, `page-connections.md`, `ROUTE-GRID-MAP.tsv`, `ROUTE-GRID-REFERENCE.tsv`, `ROUTE-ADJACENCY-MATRIX.tsv` (+ code-repo `tests/plato/route-map.generated.ts`). **`route-stories.md` is NOT generated** — it's hand-written (canonical story↔route map), stays `driftCheck`.

**To add a future generated doc:** add a `generated` group with a `regen` binding — no script edit (the gate iterates all such groups). **#25 [APIMAP-LIB-BLIND] fixed same conv:** `route-api-map.mjs` now traces `@lib/` fetch with an ambient-auth suppress-list (`AMBIENT_LIB=['current-user']`) so route-specific helpers surface while ambient `/api/me/full` doesn't spray. Related: [[project_route_gen_cross_repo]], [[feedback_check_docs_on_how_questions]]. Follow-up: [DOCGEN-SPEC] (document in doc-sync-strategy.md).
