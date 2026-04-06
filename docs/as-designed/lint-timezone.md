# lint-timezone.sh — Timezone Safety Linting

## Purpose

`lint-timezone.sh` detects timezone-unsafe date patterns in both test files and source code. Without this gate, developers (and Claude) introduce bare `new Date()` calls or local-time methods that silently produce different results depending on the machine's timezone. These bugs are invisible in local dev (same timezone every run) and only surface in production or CI.

## What It Checks

### Source files (`src/pages/api/`, `src/lib/`)

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

### Current: Claude Code PreToolUse hook

Registered in `.claude/settings.json` as a `PreToolUse` hook on the `Bash` tool. When Claude runs a `git commit` targeting the Peerloop code repo, the hook runs `lint-timezone.sh` first. If it exits non-zero, the commit is **blocked** with a denial message showing the violations.

**Script:** `.claude/hooks/pre-commit-lint-tz.sh`

### What is NOT gated

| Scenario | Gated? | Why |
|----------|--------|-----|
| Claude commits to Peerloop | Yes | PreToolUse hook intercepts `git commit` |
| Claude commits to peerloop-docs | No | Docs repo has no source/test code to lint |
| Human commits via terminal | **No** | No git pre-commit hook installed |
| Human commits via IDE | **No** | No git pre-commit hook installed |
| CI/CD pipeline | **No** | No CI configured yet |

## Fragility Analysis

### Why this is fragile

1. **Claude-only gate.** The hook only fires inside Claude Code sessions. A developer running `git commit` directly bypasses it entirely. Since Claude is currently the sole committer this is acceptable, but it will break the moment a second developer joins or the user commits manually.

2. **Pattern matching on command strings.** The hook detects commits by regex-matching the Bash command for `git.*commit` and `Peerloop`. If Claude changes its commit command format (e.g., using a different path, a shell alias, or a subshell), the hook might not trigger.

3. **No CI backstop.** There is no CI pipeline to catch violations that slip past the hook. A missed violation stays in the codebase until the next manual `npm run lint:tz` run.

4. **WARNs are not gated.** Only FAIL-level patterns block commits. WARN-level patterns (`.getDate()`, `.getDay()`, `Date.now()`) are advisory. Some of these are genuine bugs waiting to happen, but gating on them would require fixing all existing warnings first.

5. **Suppression comments are honor-system.** Adding `// tz-exempt` or `// getNow-exempt` silences the linter with no review process. A careless exemption hides a real bug.

### Mitigation path (when needed)

When a second developer joins or CI is configured:

1. **Add a git pre-commit hook** via husky or lefthook that runs `npm run lint:tz`. This gates all committers, not just Claude.
2. **Add `npm run lint:tz` to CI.** This is the final backstop — violations that slip through local hooks are caught before merge.
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
