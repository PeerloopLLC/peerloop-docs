# State — Conv 091 (2026-04-06 ~15:52)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 091 promoted lint-timezone.sh to a Claude Code PreToolUse hook (blocks code repo commits on timezone-unsafe patterns), then implemented DEV-WEBHOOKS.SCRIPTS (orchestrator + trigger scripts) and DEV-WEBHOOKS.DATA-ALIGNMENT (Stripe fixture overrides, seed SQL markers). Docs agent also completed DEV-WEBHOOKS.DOCS updates during /r-end.

## Completed

- [x] [LG] Promote lint-timezone.sh to pre-commit hook (Claude Code PreToolUse hook)
- [x] docs/as-designed/lint-timezone.md — fragility analysis
- [x] DEV-WEBHOOKS.SCRIPTS — dev-webhooks.sh, trigger-webhook.sh, npm scripts
- [x] DEV-WEBHOOKS.DATA-ALIGNMENT — Stripe fixture overrides, seed SQL markers
- [x] DEV-WEBHOOKS.DOCS — CLI-QUICKREF, SCRIPTS.md, DEVELOPMENT-GUIDE.md updated by docs agent

## Remaining

- [ ] Verify docs agent covered CLI-TESTING.md webhook section (PLAN.md item)
- [ ] DEV-WEBHOOKS.BBB-VERIFY — staging verification, recording flow, recording_url strategy, deploy (has external dependencies)

## TodoWrite Items

- [ ] #9: [DWD] DEV-WEBHOOKS.DOCS subtask — verify docs agent coverage
- [ ] #10: [BV] DEV-WEBHOOKS.BBB-VERIFY — staging verification + recording flow

## Key Context

- lint-timezone.sh enforcement is Claude-only (PreToolUse hook) — no git hook or CI gate. Fragility documented in docs/as-designed/lint-timezone.md
- `// tz-exempt` suppression comment now supported in test files (parallels `// getNow-exempt` in source)
- trigger-webhook.sh uses `openssl dgst` for HMAC tokens — verified identical to Web Crypto output
- Stripe checkout trigger has seed-aligned `--override` flags; refund/dispute are synthetic (no DB match)
- Feedback memory saved: always use /r-end to commit, never /r-commit directly

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
