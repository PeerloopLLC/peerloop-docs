---
name: Hands-off pilot workflow
description: User mediates ALL project-file changes through Claude Code — never directly edits files in either repo. Designs can safely assume CC is the sole author of project state.
type: user
originSessionId: 31ca911f-5d4b-49e2-8629-fcb943aa0b59
---
The user does not edit project files directly — every change to either repo (peerloop-docs or Peerloop) flows through Claude Code as the agent of authorship. The user dictates intent, reviews diffs, approves commits, asks questions, redirects, but does not open files in another editor and modify them by hand. Think "pilot directing controls" rather than "co-editor sharing the buffer."

**Architectural implication:** designs that assume CC is the sole author of project files can be substantially simpler than designs defending against arbitrary out-of-band edits. The mediated-authorship invariant is load-bearing for several pieces of infrastructure:

- **[MSI] memory sync** — trusts the mirror at SessionStart because no one is editing live memory files between convs except CC. The "first /r-start data-loss window" only opens if CC itself wrote new live-only memories that haven't reached the mirror yet (closed by Step 5.7's halt-on-`Only in $LIVE`).
- **Skill state files** (`CONV-COUNTER`, `.conv-current`, `RESUME-STATE.md`, sync logs) — can rely on commit-then-push as the only valid mutation path; no need for filesystem-level locking, merge conflict tooling, or pre-write reconciliation.
- **Cross-machine concurrency** — bounded by /r-end → push → /r-start → pull discipline. No need for transactional file ops or distributed-locks; one machine writes at a time, mediated by CC, sync points are skill boundaries.
- **Drift detection** (`tech-doc-drift.sh`, `/w-codecheck`) — can use git commit history as ground truth for "what changed" since the user never makes uncommitted local edits.

**When to apply:** when designing infrastructure (skills, hooks, sync mechanisms, state files, drift checks) that touches project files, lean on this assumption. Do NOT spend complexity defending against arbitrary edits. The override case (rare emergency manual edit) is the user's responsibility to flag and route through CC on the next conv for review and re-commit.
