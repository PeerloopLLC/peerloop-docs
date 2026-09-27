---
name: project_route_gen_cross_repo
description: Route-doc regeneration writes BOTH repos — code-repo route-map.generated.ts AND docs-repo route docs; expect the code repo dirty after a docs-only-looking regen
metadata: 
  node_type: memory
  type: project
  originSessionId: 9ca55316-df4a-454b-9749-cda89adba1e1
---

Running the route-doc generators from the code repo — `cd ~/projects/Peerloop && node scripts/route-api-map.mjs` (and `route-matrix.mjs`) — rewrites generated artifacts on **both** sides of the dual-repo boundary in one invocation:

- **Code repo:** `tests/plato/route-map.generated.ts`
- **Docs repo:** `docs/as-designed/route-api-map.md`, `page-connections.md`, `ROUTE-ADJACENCY-MATRIX.tsv`, `ROUTE-GRID-MAP.tsv`, `ROUTE-GRID-REFERENCE.tsv` (docs reached via the `Peerloop/docs → ../peerloop-docs/docs` symlink).

**Why:** It's counterintuitive — "route docs" sounds docs-repo-only, so the code-repo change is easy to miss. Verified empirically Conv 201: the `/r-end` docs agent regenerated route docs (after 5 new root routes landed) and `tests/plato/route-map.generated.ts` showed up as a code-repo modification.

**How to apply:** Whenever route docs are regenerated (e.g. the `/r-end` docs agent after pages change, or a manual `[E2E-MIG]`/`[RTMIG-4]` step), **`git status` BOTH repos** before committing — a commit flow that assumes "only docs changed" will strand the code-repo file. This is the dual-repo analogue of always using `git -C` ([[feedback_git_dash_c_enforcement]]): route changes ripple across the boundary, so both repos need an end-of-conv commit.
