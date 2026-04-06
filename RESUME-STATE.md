# State — Conv 090 (2026-04-06 ~15:10)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 090 completed a full getNow() sweep across 37 code files — converting 25 files from bare `new Date()` to `getNow()` and adding `// getNow-exempt` comments to 12 files with legitimate uses. Also added mnemonic collision rule to global CLAUDE.md and evaluated/closed the futureSession() promotion task. All 6388 tests pass.

## Completed

- [x] Updated global CLAUDE.md with mnemonic collision rule (sequential numbering on collisions)
- [x] Full getNow() sweep — converted 25 files from bare `new Date()` to `getNow()`
- [x] Added `// getNow-exempt` comments to 12 files (~22 legitimate uses)
- [x] Verified lint-timezone.sh source section clean
- [x] Full test suite passing (366 files, 6388 tests)
- [x] Evaluated futureSession() promotion — no action needed (single-use, premature abstraction)

## Remaining

- [ ] Promote lint-timezone.sh to pre-commit hook or CI gate — root cause of recurring incomplete sweeps

## TodoWrite Items

- [ ] #3: [LG] Promote lint-timezone.sh to pre-commit hook or CI gate — lint-timezone.sh is advisory-only (manual run), not enforced via pre-commit hook or CI gate. This is the root cause of recurring incomplete getNow() sweeps.

## Key Context

- `getNow()` from `@lib/clock` is now used in 47+ server-side files (up from 22 after Conv 089)
- `lint-timezone.sh` source section is clean — all remaining flags are test-file patterns (pre-existing)
- `// getNow-exempt` suppression comment is used for legitimate uses (clock.ts itself, health checks, debug, DB utils, replication metadata, performance timing)
- User has low confidence in timezone handling due to recurring sweeps — promoting lint to hard gate would address this

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
