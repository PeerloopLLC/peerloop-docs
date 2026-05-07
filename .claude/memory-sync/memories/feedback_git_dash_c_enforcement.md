---
name: Always use git -C, never bare git, in dual-repo work
description: Every git invocation in dual-repo (peerloop-docs + Peerloop) sessions must use `git -C <abs-path>` to pin the target repo; bare `git` after a `cd ../Peerloop` lands commits in the wrong repo
type: feedback
originSessionId: c98bf91a-357a-4d96-9e58-484fbe76d41e
---
In dual-repo Peerloop sessions, **every git invocation must use `git -C <absolute-path>`**. Never run bare `git` from the bash subshell.

**Why:** A long-running bash conversation accumulates many `cd ../Peerloop && npm run ...` calls. The subshell cwd drifts from the docs repo to the code repo (or vice versa) silently, and a later bare `git add . && git commit` lands in whatever repo bash happens to be sitting in. Conv 109 had two confirmed violations of this — `/r-commit` succeeded by accident, but the next near-miss could land changes on the wrong branch with no warning.

**How to apply:**
- Use `git -C ~/projects/peerloop-docs ...` for the docs repo.
- Use `git -C ~/projects/Peerloop ...` for the code repo.
- The skill files for `/r-commit`, `/r-start`, `/r-end` already follow this convention via `$CLAUDE_PROJECT_DIR` — match that pattern for ad-hoc git work too.
- This applies to **every** git verb: `status`, `add`, `commit`, `log`, `diff`, `push`, `pull`, `rm --cached`, `ls-files`, `branch`, `checkout`. Not just write operations — read operations against the wrong repo also produce misleading output that gets cited downstream.
- Acceptable exception: `git -C` is unnecessary when the entire bash invocation is `cd /known/path && git ...` (the cd makes the target explicit), but `git -C` is preferred even there for grep-ability.
- If a Bash output ever says "On branch X" where X looks like the wrong repo's branch, **stop** and audit — don't assume the cwd is what it should be.

This was filed as [CD] across multiple convs (014, 109+) and is recurring enough to warrant a hard rule.
