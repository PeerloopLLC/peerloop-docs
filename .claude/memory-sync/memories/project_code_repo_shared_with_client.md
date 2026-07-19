---
name: project_code_repo_shared_with_client
description: "The CODE repo is shared with the client, who commits with colliding Conv NNN prefixes — never trust a bare branch sweep there; the docs repo is ours alone."
metadata: 
  node_type: memory
  type: project
  originSessionId: 54d8ef40-f5e3-48ca-9c3d-6e2ec10264f8
  modified: 2026-07-19T19:03:08.843Z
---

**The `Peerloop` code repo is shared with the client (Brian, `brian@peerloop.com`), who drives his own Claude Code instances and commits using the SAME `Conv NNN:` prefix convention we do — with conv numbers that COLLIDE with ours.** His branches: `brian-July-7`, `brian-staging`. The `peerloop-docs` repo is **ours alone** — verified Conv 396: one branch (`main`), 1205 commits, every one authored *and* committed `Fraser Gorrie <fraser@meristics.com>`; zero `brian@peerloop.com` across `--all`.

**Why:** any tool that sweeps branches or greps `Conv NNN` in the code repo will silently ingest the client's work as if it were ours. Measured Conv 396: `timecard-day.js` swept `brian-July-7` and absorbed **6 of his commits into our Conv 371 bucket** on 2026-07-07 (billable delta happened to be 0m — his commits fell inside a window our own commits already bounded, which was luck, not design). His branch labels commits "Conv 371–375" that are entirely different work from our Convs 371–375, so they look legitimate on inspection. Also note **he did NOT use the dual-repo architecture** — code-only, so his conv labels have no heartbeat commits and no session docs / PLAN entries / RESUME-STATE narratives exist for any of his work.

**How to apply:**
- **Timecard surfaces are already guarded (Conv 396)** — `timecard-day.js` gates code-repo branches at `discoverCandidateBranches()` against `rTimecardDay.codeBranchAllowPattern` (`^jfg-dev`) in `.claude/config.json`; `/r-timecard` uses `--branches='jfg-dev*'`; `/w-timecard` pre-flight-checks HEAD. **Allowlist, not denylist** — a new client branch appears without warning.
- **The DOCS repo is deliberately NOT filtered** — it lives on `main` and holds the `Conv NNN start —` heartbeats that anchor every day window. Filtering it would silently zero every timecard.
- **Building any NEW tool that walks branches or greps conv numbers in the code repo? Apply the same allowlist.** Commit archaeology, `git log --all`, `--branches`, and `git branch --contains` (which ignores a `--branches` glob) are all exposed.
- **The allowlist dies on a history-preserving merge** — once his commits sit on a `jfg-dev*` branch, no branch filter can see them. This is a load-bearing reason [MERGE-BRIAN-JULY7] integrates his work as **squashed commits authored by us**. See `CURRENT-TASKS.md § [MERGE-BRIAN-JULY7]` and [[project_jfg_dev_branches_are_snapshots]].
- **🔻 It now constrains OUR branch naming too (Conv 397) — the whitelist cuts both ways.** Because `^jfg-dev` is an *allowlist*, **any branch we create that doesn't match it is invisible to every timecard surface** — no error, no warning, just zero billable minutes for the work on it. A descriptively-named branch (`rdoc-eval`, `a11y-linter`, `react-doctor-assess`) silently loses its own billing. **Name every new code branch `jfg-dev-NN`.** This is not implied by the branch-naming convention itself — it became true only when Conv 396 added the gate, and it is the reason Conv 397 ran its evaluation in place on `jfg-dev-14` rather than cutting a named branch.

Related: [[feedback_git_dash_c_enforcement]] (wrong-repo hazard), [[project_jfg_dev_branches_are_snapshots]] (never delete `jfg-dev-NN` or client branches).
