# Session Learnings - 2026-02-28

## 1. "Needs Updating" Often Means "Completely Dead"
**Topics:** docs-infra, workflow

**Context:** Session 307's MARKED-FOR-DELETION manifest flagged three audit scripts (`audit-api-coverage.mjs`, `audit-test-sufficiency.mjs`, `reconcile-planned-apis.mjs`) as "may need updating after deletion but are not dead themselves."

**Learning:** When an artifact's entire input pipeline is deleted, the script is dead — not updatable. All three scripts read exclusively from `src/data/pages/` and `scripts/page-tests/`, both deleted. The Session 307 assessment that they "serve broader purposes" was wrong; reading the actual code showed 100% dependency on the PageSpec system. The key test is: does the script have *any* input that still exists?

---

## 2. Symlinks Cause Stale IDE Views
**Topics:** workflow, dual-repo

**Context:** After renaming `docs/pagespecs` to `docs/pagespecs.bak` in the peerloop-docs repo, the user still saw it in VS Code's file explorer under the Peerloop repo (which has a `docs → ../peerloop-docs/docs` symlink).

**Learning:** VS Code's file watcher can lag behind filesystem changes when viewing through symlinks. The file was gone from disk but the IDE showed a stale entry. This is a gotcha when working in the dual-repo setup — always verify with filesystem commands rather than trusting the IDE tree after cross-repo file operations.

---

## 3. Rename-and-Build Is an Efficient Dead Code Test
**Topics:** workflow, docs-infra

**Context:** Needed to determine if `docs/pagespecs/` and `Peerloop/_src/` were referenced by any build-time code.

**Learning:** Rather than exhaustively grepping for references, renaming directories and running `npm run build` + `tsc --noEmit` gives a definitive answer. If build and types pass clean, nothing in the compiled codebase depends on those files. This is faster and more reliable than text search for detecting runtime dependencies.

---

## 4. Archive Folders Are Unnecessary When Git History Exists
**Topics:** docs-infra

**Context:** Over Sessions 307-311, we progressively archived PageSpec artifacts into `docs/archive/` — 312 files, 17MB. Then realized the archive itself served no purpose.

**Learning:** Archiving deleted files into the same repo just moves clutter around. Git history already preserves everything with full context (commit messages explain why files were deleted). The archive pattern made sense as an intermediate step during the multi-session cleanup, but once complete, the archive was dead weight. For future large deletions: delete directly, rely on git history.
