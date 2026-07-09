# lint-timezone.sh — Timezone Safety Linting

## Purpose

`lint-timezone.sh` detects timezone-unsafe date patterns in both test files and source code. Without this gate, developers (and Claude) introduce bare `new Date()` calls or local-time methods that silently produce different results depending on the machine's timezone. These bugs are invisible in local dev (same timezone every run) and only surface in production or CI.

## What It Checks

### Source files (`src/pages/api/`, `src/lib/`, `src/emails/`, `workers/`)

| Pattern | Severity | Safe alternative |
|---------|----------|-----------------|
| `new Date()` (zero-arg) | FAIL | `getNow()` from `@lib/clock` |
| `Date.now()` in comparisons | WARN | `getNow().getTime()` |

Suppression comment: `// getNow-exempt`

### Test files (`tests/`)

| Pattern | Severity | Safe alternative |
|---------|----------|-----------------|
| `.setHours()` | FAIL | `.setUTCHours()` |
| `.getHours()` | FAIL | `.getUTCHours()` |
| `new Date(year, month, day)` | FAIL | `new Date(Date.UTC(...))` or `utcDate()` helper |
| `.getDate()` | WARN | `.getUTCDate()` |
| `.getDay()` | WARN | `.getUTCDay()` |

Suppression comment: `// tz-exempt` — use for intentional local-time code (e.g., client-side calendar utils that use `getFullYear()`/`getMonth()`/`getDate()` by design).

## Enforcement

Two independent layers gate the guard: a Claude-session PreToolUse hook (local, blocks at commit time) and GitHub Actions CI (remote, blocks at merge time — added Conv 375).

### Layer 1: Claude Code PreToolUse hook

Registered in the **docs-repo** `.claude/settings.json` (that repo is `$CLAUDE_PROJECT_DIR` — the Peerloop CC home) as a `PreToolUse` hook on the `Bash` tool. When Claude runs a `git commit` targeting the Peerloop code repo, the hook runs `lint-timezone.sh` first. If it exits non-zero, the commit is **blocked** with a denial message showing the violations.

**Script:** `.claude/hooks/pre-commit-lint-tz.sh` (in peerloop-docs, not the code repo). Note: because the hook lives under `$CLAUDE_PROJECT_DIR` = peerloop-docs, a check of the *code* repo's `.claude/` will not find it — it is not absent, just repo-scoped to CC's home.

### Layer 2: GitHub Actions CI (added Conv 375, [TZ-LINT-CI])

`.github/workflows/ci.yml` runs on `push` and `pull_request`:

- The **Lint & Type Check** job runs `npm run lint:tz` as a step, so violations block the pipeline even for human/IDE commits the local hook never sees.
- The **Unit Tests** job runs under a `timezone: ['UTC', 'Pacific/Kiritimati']` matrix (`env: TZ`). UTC is production parity; the hostile `Pacific/Kiritimati` (+14) leg is what forces a *UTC-only* CI host to actually detect a `getUTC*`→`get*` host-local regression — see the Fragility note below.

### Gating matrix

| Scenario | Blocked at commit? | Caught before merge? | Why |
|----------|:---:|:---:|-----|
| Claude commits to Peerloop | Yes | Yes | PreToolUse hook intercepts `git commit`; CI re-checks on push/PR |
| Claude commits to peerloop-docs | No | n/a | Docs repo has no source/test code to lint |
| Human commits via terminal | **No** | **Yes** | No git pre-commit hook, but CI `lint:tz` + hostile-TZ matrix catch it on push/PR |
| Human commits via IDE | **No** | **Yes** | Same — CI is the backstop |
| CI/CD pipeline | — | **Yes** | `lint:tz` step + hostile-TZ test matrix in `ci.yml` (Conv 375) |

## Fragility Analysis

### Why this is fragile

1. **Claude-only gate.** The hook only fires inside Claude Code sessions. A developer running `git commit` directly bypasses it entirely. Since Claude is currently the sole committer this is acceptable, but it will break the moment a second developer joins or the user commits manually.

2. **Pattern matching on command strings.** The hook detects commits by regex-matching the Bash command for `git.*commit` and `Peerloop`. If Claude changes its commit command format (e.g., using a different path, a shell alias, or a subshell), the hook might not trigger. Conversely it over-matches: any Bash command whose text merely *contains* the substring `Peerloop … commit` (e.g. an `echo`/`printf` of a commit-related string) is treated as a commit and gated on `lint:tz`. This is a benign false-positive in practice — a green `lint:tz` always allows — but observed during the Conv 376 verification.

3. **~~No CI backstop~~ — resolved Conv 375.** `lint:tz` now runs in GitHub Actions CI (`.github/workflows/ci.yml`) on every push/PR, plus a hostile-TZ (`Pacific/Kiritimati`) test-matrix leg, so violations that slip past the local hook are caught before merge. (Previously the top fragility item: a missed violation lingered until the next manual `npm run lint:tz`.)

4. **WARNs are not gated.** Only FAIL-level patterns block commits. WARN-level patterns (`.getDate()`, `.getDay()`, `Date.now()`) are advisory. Some of these are genuine bugs waiting to happen, but gating on them would require fixing all existing warnings first.

5. **Suppression comments are honor-system.** Adding `// tz-exempt` or `// getNow-exempt` silences the linter with no review process. A careless exemption hides a real bug.

### Mitigation path (when needed)

When a second developer joins or CI is configured:

1. **Add a git pre-commit hook** via husky or lefthook that runs `npm run lint:tz`. This gates all committers, not just Claude.
2. ~~**Add `npm run lint:tz` to CI.**~~ **DONE (Conv 375).** Wired into `ci.yml`'s Lint & Type Check job, plus a hostile-TZ test-matrix leg (`['UTC', 'Pacific/Kiritimati']`) so a UTC-only CI host still enforces the UTC date contract.
3. **Audit `// tz-exempt` and `// getNow-exempt` comments periodically.** Grep for them and verify each is still justified.

## Commands

```bash
# Manual run (from Peerloop repo)
npm run lint:tz

# Or directly
./scripts/lint-timezone.sh
```

## History

- **Conv 089:** `lint-timezone.sh` created with test-file patterns
- **Conv 090:** Source-file section added (`getNow()` enforcement). Full sweep: 25 files converted, 12 exempted. User flagged recurring incomplete sweeps as a confidence issue.
- **Conv 091:** Promoted to Claude Code PreToolUse hook. Added `// tz-exempt` suppression for test files. Fragility documented.
- **Conv 375 ([TZ-LINT-CI]):** Scan dirs extended to `src/emails/` + `workers/` (0 new violations). Enforcement gained a CI backstop — `lint:tz` wired into `.github/workflows/ci.yml`'s Lint & Type Check job, plus a hostile-TZ (`Pacific/Kiritimati`, +14) `test`-job matrix leg so a UTC-only CI host detects host-local `getUTC*`→`get*` regressions. `src/components` (~60 client-side hits) + `.astro` (6) deferred as [TZ-LINT-SCAN2].
- **Conv 376 ([TZ-HOOK-CHECK]):** Fixed a latent bug that had made the Layer-1 PreToolUse hook **inert since Conv 091** — it emitted `permissionDecision:"deny"` **without** the required `hookSpecificOutput.hookEventName:"PreToolUse"` (and spliced multi-line lint output into JSON via a heredoc, producing invalid JSON), so Claude Code silently ignored the decision and every `git commit` proceeded regardless of `lint:tz`. The emit was rewritten to `jq -nc` (mirroring `guard-dangerous-bash.sh`), adding `hookEventName` and JSON-escaping the reason. **Verified live:** with a red `lint:tz`, a real `git commit` to the code repo is now denied at the PreToolUse gate — before the fix the identical commit passed straight through. The Conv-375 CI backstop had masked the impact (violations still caught at push/PR, just never at commit time).
