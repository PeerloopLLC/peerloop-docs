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
- Skill files (`/r-commit`, `/r-start`, `/r-end`, etc.) use tilde-literal `~/projects/peerloop-docs` everywhere — match that pattern for ad-hoc git work. Do NOT use `$CLAUDE_PROJECT_DIR` in Bash command strings (see below).
- This applies to **every** git verb: `status`, `add`, `commit`, `log`, `diff`, `push`, `pull`, `rm --cached`, `ls-files`, `branch`, `checkout`. Not just write operations — read operations against the wrong repo also produce misleading output that gets cited downstream.
- Acceptable exception: `git -C` is unnecessary when the entire bash invocation is `cd /known/path && git ...` (the cd makes the target explicit), but `git -C` is preferred even there for grep-ability.
- If a Bash output ever says "On branch X" where X looks like the wrong repo's branch, **stop** and audit — don't assume the cwd is what it should be.

**Why tilde everywhere, not `$CLAUDE_PROJECT_DIR` or `$HOME`:** The Bash tool's permission gate flags any external `$VAR` expansion as `simple_expansion`, prompting the user. Tilde (`~`) is functionally equivalent to `$HOME` (both resolve to the current user's home) but does NOT trigger the prompt — it's treated as a literal-prefix expansion at shell parse time. **Crucially: tilde expands only OUTSIDE double quotes**, so the bash assignments must drop the surrounding double quotes (paths have no spaces, so unquoted is safe). spt-docs's `w-test-tilde` skill (their Conv 164) empirically confirmed: `$VAR` form hard-fails on `simple_expansion`; tilde form passes silently.

**Cross-machine reality:** M4 uses username `livingroom`, M4Pro uses `jamesfraser`. Literal `/Users/jamesfraser/...` substitution was attempted briefly Conv 162 and reverted for this reason — `~` is the ONLY portable form that's also prompt-free.

Conv 162 final form across r-start/r-commit/r-end (and 7 other skills):
- `$CLAUDE_PROJECT_DIR` → `~/projects/peerloop-docs` (outside quotes; cross-machine portable; no prompt)
- `$CLAUDE_PROJECT_DIR/../Peerloop` → `~/projects/Peerloop`
- `"$HOME/.claude/projects/..."` → `~/.claude/projects/...` (drop the surrounding double quotes)
- `SLUG="${CLAUDE_PROJECT_DIR//\//-}"` → `SLUG=$(echo ~/projects/peerloop-docs | tr / -)` (subshell does the tilde expand + path-to-slug conversion via tr)
- Local script vars (`$SLUG`, `$LIVE`, `$LOG_DIR`, `$DIFF_OUT`, etc., defined and consumed in the same bash block) are unaffected — the gate only flags external env-var references.

Verified empirically Conv 162: the substituted bash block (with `SLUG=$(echo ~/...)`, `LIVE=~/.claude/...`, etc.) executes cleanly and resolves to identical paths. Result: fully prompt-free for skill-issued Bash commands. Single-line `git -C ~/projects/peerloop-docs ...` style commands and multi-line memory-sync forensics blocks both run silently.

This was filed as [CD] across multiple convs (014, 109+) and is recurring enough to warrant a hard rule.

**Corollary — safety gates must DETECT the `git -C` form, not just CC USE it (Conv 214 [GUARD-VERIFY]).** Because the project mandates `git -C <dir> …` for *every* git verb, that is the form any real command takes — so adjacency-based safety rules `\bgit[[:space:]]+<sub>\b` (and `deny` prefixes like `Bash(git push --force:*)`) systematically MISS the form the project actually uses while catching the bare form it never uses. Two live instances were found in `guard-dangerous-bash.sh` and fixed: (1) the Conv 213 commit-message-strip never ran on `git -C … commit -m "…"`, so a message quoting `wrangler --remote`/`DROP TABLE` self-escalated; (2) the force-push rule never fired on `git -C … push --force`, AND the `deny` prefix can't see it either (command starts with `git -C …`, path varies → prefix-deny structurally can't cover it). Fix: a shared `GITOPTS` regex fragment absorbing `-C <path>`/`-c k=v`/`--opt[=val]`/`-x` between `git` and the subcommand. **When authoring ANY future git-related guard regex or deny rule, tolerate global options between `git` and the verb.** Textbook instance of [[feedback_heuristic_calibration]] (run the gate against the canonical case — here the `git -C` form — before commit).
