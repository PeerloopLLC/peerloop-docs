# State — Conv 084 (2026-04-05 ~20:50)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 084 was a housekeeping conv migrating all editor references from Cursor to VS Code. Updated 9 files across skills, global config, templates, and docs. Fixed a VS Code workspace file case mismatch (`../peerloop` → `../Peerloop`) that was causing a Vitest extension crash. No code repo changes.

## Completed

- [x] Migrated all Cursor editor references to VS Code (`code`) across 9 files
- [x] Fixed workspace file case mismatch (`../peerloop` → `../Peerloop`)
- [x] Removed stale Material Theme and icon theme from workspace settings
- [x] Transferred 5 RESUME-STATE.md tasks to TodoWrite

## Remaining

### Carried Forward
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)

### Docs Gaps
- [ ] PLATO-GUIDE.md file tree stale — missing instance files added since guide was written
- [ ] migrations.md missing PLATO seed path cross-reference (two parallel seed paths undocumented)

### PLATO Seed Polish
- [ ] PLATO seed Stripe accounts show `pending` — testers may see "Connect Stripe" prompts on creator pages

## TodoWrite Items

- [ ] #1: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #2: Broken route: /course/[slug]/certificate — page doesn't exist
- [ ] #3: PLATO-GUIDE.md file tree stale — missing instance files
- [ ] #4: migrations.md missing PLATO seed path cross-reference
- [ ] #5: PLATO seed Stripe accounts show pending

## Key Context

- **Editor:** All references now use `code` (VS Code). `config.json` `"editor": "code"` is the source of truth.
- **Workspace:** `peerloop.code-workspace` has corrected case and placeholder `Default Dark Modern` theme — user will pick a replacement theme later.
- **Untracked files:** `peerloop.code-workspace` and `.claude/skills/w-sync-skills/` are untracked in docs repo.
- **VS Code diff preview:** Available via the Claude Code VS Code extension (panel mode), not via terminal mode.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
