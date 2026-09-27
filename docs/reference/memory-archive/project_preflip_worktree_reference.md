---
name: project_preflip_worktree_reference
description: "How to inspect /old (legacy) app look+behavior — pre-flip git worktree on :4331, NOT a deep-link fix"
metadata: 
  node_type: memory
  type: project
  originSessionId: 143c309a-28eb-4387-94cc-378397cfb624
---

To see what the **legacy `/old/*` pages look like and how they behave**, use the
**pre-flip git worktree**, NOT a deep-link/prefix fix.

**Decision (Conv 202):** We considered making `/old` self-navigable on the live
branch (client-side href rewrite / `basePath="/old"` prop on AppNavbar / middleware
404→/old fallback). All **retired** — a git worktree at the pre-ROUTE-FLIP commit
satisfies the requirement with zero scaffolding and zero removal-debt, and the live
branch stays honest (deep `/old` links 404 by design, which is the verification
signal RTMIG-4 depends on — a silent fallback would mask the string-route-ref bugs
we're hunting). See [[feedback_no_simplest_fix]].

**The worktree:**
- Location: `~/projects/Peerloop-preflip` (sibling of the code repo; machine-LOCAL,
  not pushed — git worktrees don't travel between M4 / M4Pro).
- **Recreate on another machine:** `bash ~/projects/Peerloop/scripts/setup-preflip-ref.sh`
  (idempotent: worktree add + .dev.vars copy + npm install + db:setup:local:dev +
  appends the `peerloop-ref` alias). The `peerloop.code-workspace` folder entry IS
  committed, so it travels via git — pull the docs repo and the worktree folder
  appears in VS Code once the worktree exists.
- Commit: detached HEAD `608346a2` = `846bab9f^` — the parent of Conv 197's
  `[ROUTE-FLIP] dissolve /matt namespace`. At this commit the **legacy app is at
  root `/`** and **Matt's WIP is at `/matt/*`**; `/old` does not exist yet.
- Server: `npm run dev -- --port 4331`. Aliased in `~/.zshrc` as **`peerloop-ref`**
  (cd + start). Its own `node_modules`, `.wrangler` local D1, and a copied `.dev.vars`
  are already set up — just run the alias.
- Seed login: all dev users share password `Peerloop2`; admin = `brian@peerloop.com`
  (all capability flags). Login is via the auth **modal** (click "Log in" → modal,
  not a `/login` form page).
- Inspect via /chrome bridge: works fully on :4331 (bridge is port/URL-based,
  directory-agnostic — two dev servers on :4321 + :4331 coexist).

**Teardown** when RTMIG-4 no longer needs it: kill :4331, then
`git -C ~/projects/Peerloop worktree remove ~/projects/Peerloop-preflip`. Tracked
as task `[PREFLIP-WT]`.
