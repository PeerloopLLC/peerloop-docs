# State — Conv 098 (2026-04-10 ~14:20)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 098 was entirely skill-sync/tooling work against `~/projects/spt-docs`. Full scan + per-skill deep dives on `r-timecard-day`, `r-end`, `r-commit`, `r-start`, `w-git-history`. Ported the `Doc:` structured commit tag across three skills (r-commit, r-end, r-timecard-day) and formalized a clean Doc/Infra separation (Option B). Also added "Doc reorganization" as an Important Decision Criterion in `refs/fmt-learn-decide.md` and saved a new feedback memory about checking docs on "how does X work" questions. No PLAN.md block advanced — PACKAGE-UPDATES remains WIP from Conv 096, untouched.

## Completed

- [x] Saved `feedback_check_docs_on_how_questions.md` and indexed in MEMORY.md
- [x] Full-scan skill sync against spt-docs (13 exact matches examined)
- [x] Ported `Doc Changes` extraction section to `r-timecard-day/SKILL.md`
- [x] Ported `Doc reorganization` criterion to `r-end/refs/fmt-learn-decide.md`
- [x] Ported `Doc:` structured tag to `r-commit/SKILL.md` (generation side) with Option B separation
- [x] Ported `Doc:` tag + rewrote "Structured tags" guidance in `r-end/SKILL.md`
- [x] Verified r-start and w-git-history are in sync (nothing to port)
- [x] Declined Vitest port to w-codecheck (documented reason)

## Remaining

### Skill-sync deep dives not yet done (spt-docs → peerloop-docs)
- [ ] `/w-sync-skills r-prune-claude`
- [ ] `/w-sync-skills r-timecard`
- [ ] `/w-sync-skills w-add-client-note`
- [ ] `/w-sync-skills w-post-fix`
- [ ] `/w-sync-skills w-sync-docs`
- [ ] `/w-sync-skills w-sync-skills`
- [ ] `/w-sync-skills w-test-env`
- [ ] (`w-codecheck` already scanned — user declined Vitest port)

### Skills tooling improvements discovered
- [ ] [SD] Harden w-sync-skills agent prompt to prevent directional confusion (see TodoWrite #2 and Learning 1 — Explore agent twice reversed sync direction in synthesis)
- [ ] [DC] Check auto-memory before re-answering "do you have this directive?" questions (see TodoWrite #1 — user asked same directive twice this conv, Claude didn't notice first save)

### Carried from prior convs (not touched this conv)
- [ ] PACKAGE-UPDATES block — still WIP from Conv 096 on dedicated branch; verify branch state and continue

## TodoWrite Items

- [ ] #1: [DC] Check memory before re-answering "do you have this directive?" questions — When asked "do you have this directive?", check auto-memory directory before offering to save. User asked same directive twice in Conv 098; Claude didn't notice the first save.
- [ ] #2: [SD] Harden w-sync-skills agent prompt to prevent directional confusion — Explore agent delegated by w-sync-skills reversed direction in synthesis twice this conv. Fix: require "Source has: … / Local has: …" phrasing; place DIRECTION reminder immediately before output-format section.

## Key Context

- **Doc/Infra tag boundary (Option B):** All doc-related commits use `Doc:` (content + structural reorganization). `Infra:` is tooling/workflow/build only. This is now consistent across r-commit, r-end, r-timecard-day. When grading future commits, don't use `Infra:` for any doc work.
- **Generation/extraction contract:** Structured tags require both sides. If a new tag is added to the timecard reader (r-timecard-day, r-timecard, w-git-history), it must also be added to the writer (r-commit, r-end) or the section stays empty.
- **Pattern for skill-sync user flow:** The full-scan (`/w-sync-skills` no args) missed things. Per-skill (`/w-sync-skills {skill-name}`) produced better results because each skill got direct file reads instead of delegated summary. Prefer per-skill mode for important skills.
- **w-sync-skills direction bug:** The Explore agent's synthesis may reverse direction. Always manually re-filter agent findings with "what does source have that local lacks?" before presenting to user.
- **File paths touched this conv:**
  - `.claude/skills/r-commit/SKILL.md`
  - `.claude/skills/r-end/SKILL.md`
  - `.claude/skills/r-end/refs/fmt-learn-decide.md`
  - `.claude/skills/r-timecard-day/SKILL.md`
  - `~/.claude/projects/-Users-jamesfraser-projects-peerloop-docs/memory/feedback_check_docs_on_how_questions.md` (new)
  - `~/.claude/projects/-Users-jamesfraser-projects-peerloop-docs/memory/MEMORY.md` (added Docs Awareness section)
- **Code repo branch:** `jfg-dev-9` — unchanged, no code work this conv.
- **DECISIONS.md / DOC-DECISIONS.md:** Conv 098 routed 2 decisions to DOC-DECISIONS.md (both docs-infra topic: Doc/Infra split and Doc reorganization criterion).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
