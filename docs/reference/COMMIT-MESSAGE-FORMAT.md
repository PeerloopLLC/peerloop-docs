# Commit Message Format

Canonical spec for commit messages in both `peerloop-docs` and `Peerloop` repos. This doc is the source of truth — skill SKILL.md files (`r-commit`, `r-commit2`, `r-end`, `r-end2`) carry short author-time digests that point here for edge cases.

Two formats coexist:

- **v1** — the legacy format used by `/r-commit` and `/r-end`. Body has `Changes:` / `Fixes:` / `Tests:` bullet sections + loose `API:` / `Doc:` / `DB:` etc. metadata-tag lines. Parsed by `/r-timecard-day2` through the predicate engine's text heuristics.
- **v2** — the new format used by `/r-commit2` and `/r-end2`. Body has `### SECTION` H3 headers matching the timecard H4 section titles. Identified by a `Format: v2` trailer. Parsed by reading bullets directly from each `### SECTION` and letting the timecard's per-H4 predicate engine replicate them into every matching H4.

v1 remains valid indefinitely. History is not retrofitted. All forward-authored commits should use v2.

---

## v2 template

```
Conv NNN: Concise imperative title, under 72 chars

### Work Effort
- [TAG] bullet describing an effort thread

### User-facing
- visible change for regular users

### Admin-facing
- admin-only change

### API Changes
- METHOD /path — description

### Page Changes
- /route — description

### Role Changes
- RoleName — description

### Infra Changes
- tool/skill/script — description

### Doc Changes
- docfile.md — description

### DB Changes
- migrations/N_schema.sql — description

### Testing
- tests/path.test.ts — description

### Code Changes
- src/path.ts — description

Stats: X files changed
Block: BLOCKNAME
Conv: NNN
Machine: MACHINE
Type: end-of-conv
Format: v2
Block-summary: One sentence describing what this commit achieved toward its Block.

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Field order is fixed.** Blank lines separate subject from body, body-H3s from trailers, and trailers from the `Co-Authored-By` footer. No blank lines **within** an H3's bullet list; no blank lines **within** the trailer block.

---

## Subject

- Prefix: `Conv NNN:` (three-digit padded, from `.conv-current`).
- Imperative mood. Under 72 chars total including the prefix.
- If `.conv-current` is missing, warn that `/r-start` was not run, drop the `Conv NNN:` prefix, and omit the `Conv:` trailer line.

---

## H3 section rules

**All H3 sections are optional.** Emit only sections that have content. Never emit an empty `### Section` header.

### Authoring rule: write each bullet ONCE, in the section that best matches what the bullet fundamentally *is*.

The `/r-timecard-day2` parser evaluates per-H4 inclusion predicates independently over every bullet and **replicates** each bullet into every H4 whose predicate matches. A bullet written under `### Work Effort` that mentions `/api/enrollments` and `API-REFERENCE.md` will render in the timecard's Work Effort, API Changes, *and* Doc Changes sections. The author does not need to duplicate the bullet in the commit body — the parser does the replication.

Authors **may** explicitly duplicate a bullet under multiple H3s if they want to force a bullet into an H4 whose predicate wouldn't otherwise match. Parser dedups per-H4 by exact text, so a duplicated bullet appearing twice in the same H4 renders once.

### When to use each H3

| H3 | When to place a bullet here |
|----|-----------------------------|
| `### Work Effort` | Default home for narrative bullets, especially multi-faceted work that touches several concerns. Bullets here are often prefixed `[TAG]` where `TAG` is the effort's short code (e.g. `[RA-CLI]`, `[MPT]`). |
| `### User-facing` | Changes visible to end users (any role). Format: `Component/Area — description`. |
| `### Admin-facing` | Changes visible to admins specifically. Same format as User-facing. |
| `### API Changes` | Endpoint added, removed, or contract changed. Format: `METHOD /path — description`. Do NOT put test-only API work here; use `### Testing`. |
| `### Page Changes` | Route added/removed, or page received visible UI changes. Format: `/route — description`. Not for CSS-only tweaks or internal component refactors. |
| `### Role Changes` | Role gained/lost capability, or role-specific behavior changed. Format: `RoleName — description`. |
| `### Infra Changes` | Skills, hooks, scripts, CLI tools, build config, migrations tooling, dev workflow changes. Includes `.claude/skills/`, `.claude/scripts/`, `scripts/`, `npm run …`, `npx …`, `db:*` commands. |
| `### Doc Changes` | Reference docs under `docs/reference/`, `docs/guides/`, `docs/as-designed/`, `docs/as-built/`, or CLAUDE.md-level files. See **Doc exclusion list** below. |
| `### DB Changes` | Schema, migration, or seed work. Format: `migrations/NNNN_name.sql — description` or `Schema:` / `Seed:` / `Migration:` prefixed prose. |
| `### Testing` | Test files added, removed, or significantly changed (including `tests/api/*` — don't put those in `### API Changes`). |
| `### Code Changes` | Source-code edits not visible through any of the higher-signal sections above — internal refactors under `src/`, etc. Most bullets will NOT use this section; prefer `### Work Effort` or a more specific section. |

### Doc exclusion list

`### Doc Changes` does NOT apply to session-tracking / bookkeeping files:

- `docs/sessions/**` (Extract / Learnings / Decisions)
- `PLAN.md`, `COMPLETED_PLAN.md`, `TIMELINE.md`
- `DECISIONS.md`, `DOC-DECISIONS.md`
- `RESUME-STATE.md`, `CONV-INDEX.md`, `SESSION-INDEX.md`

Mentions of these files in any bullet are filtered out by the timecard parser's `routineStrip` filter. Authors don't need to avoid mentioning them — just don't create a `### Doc Changes` bullet whose only content is one of these files.

### H5/H6 are dynamic

The `/r-timecard-day2` parser derives H5 and H6 sub-groupings algorithmically from bullet content — authors don't emit `##### ` or `###### ` headers in commits. Only `### H3` section headers belong in commit bodies. See `.claude/config.json → rTimecardDay.h4Sections[].h5Strategy` for the per-H4 grouping rules.

---

## Trailer block

```
Stats: X files changed
Block: BLOCKNAME
Conv: NNN
Machine: MACHINE
Type: end-of-conv     ← /r-end2 only; /r-commit2 omits this line
Format: v2
Block-summary: One sentence.
```

### `Stats:`

`X files changed` — the count from `git diff --stat`. Optional additions `(+ N new)` or `(+N, -M lines)` allowed but not required.

### `Block:`

- **One block advanced:** `Block: BLOCKNAME`
- **Multiple blocks advanced:** `Block: BLOCK1, BLOCK2`
- **No block advanced** (tooling, infra, misc config, docs-only housekeeping): `Block: (misc)`

"Advanced" means the commit's diff directly relates to one of the block's `PLAN.md` items or subtasks. **Do NOT default to the Focus block.** The Focus block shows what the user is *currently working on*, but if this commit doesn't advance it, don't claim it.

For multi-block commits, the same commit appears under every named block in the timecard's Block Progress section — that's the whole reason multi-block `Block:` is supported.

### `Conv:`

The three-digit padded Conv number from `.conv-current`. Omit the line entirely if `.conv-current` is missing.

### `Machine:`

Read from `~/.claude/.machine-name`. One of `MacMiniM4-Pro` or `MacMiniM4`.

### `Type:`

- Present on `/r-end2` commits: `Type: end-of-conv`.
- Omitted on `/r-commit2` commits.

The timecard parser does not classify by `Type:` — it's metadata used by other tooling (e.g. `/r-start`'s stale-context detection reads the most recent commit for `Conv NNN start —` matching).

### `Format: v2`

The parser's detection marker for v2 format. Mandatory on all v2 commits. Legacy commits (no `Format:` line) are treated as v1 and go through the predicate engine's text heuristics.

### `Block-summary:`

- **Required** when `Block:` is NOT `(misc)`. If `Block:` is `(misc)`, may be omitted.
- **Single line**, 80–150 chars preferred.
- One per commit — the same sentence applies under every Block in multi-Block commits.
- Written from the Block's perspective ("Landed X"; "Replaced Y with Z"; "Unblocked ABC").
- Synthesis, not a bullet re-list. Don't enumerate what's already in the H3 sections — summarize the progress.

The timecard's deterministic Block Progress mode uses `Block-summary:` lines as per-commit bullets. Missing summaries trigger the LLM fallback path (see `/r-timecard-day2` SKILL.md).

---

## Multi-H4 parsing semantics

A single bullet in the commit body can render in multiple H4 sections in the timecard. The timecard's `/r-timecard-day2` script reads the H3 section header each bullet is placed under to set the bullet's `src` metadata, then evaluates every H4 section's `include` predicate in `.claude/config.json → rTimecardDay.h4Sections` independently against every bullet.

Example. Commit body:

```
### Work Effort
- [RA-API] Deleted GET /api/me/enrollments + removed reference from API-REFERENCE.md

### Testing
- Removed enrollments-endpoint tests under tests/api/me-enrollments.test.ts
```

Renders in the timecard's Day Rollup as:

- **Work Effort** → `[RA-API] Deleted GET /api/me/enrollments …` (via `src: workEffort`)
- **API Changes** → same bullet (via `apiPathRe` match on `/api/me/enrollments`)
- **Doc Changes** → same bullet under H5 `API-REFERENCE.md` (via `API-REFERENCE.md` doc-mention)
- **Testing** → `Removed enrollments-endpoint tests …` (via `src: test`)

One bullet, three appearances under Work Effort + API Changes + Doc Changes — each a legitimate dimension view of the same work.

### Dedup

The parser dedups **per H4**, by exact bullet text. If the author explicitly places the same bullet under both `### API Changes` and `### Doc Changes` in the commit body, and the per-H4 predicate ALSO matches that bullet in API Changes, it renders once in API Changes, not twice. No cross-H4 dedup — that's the whole point.

### Fallthrough

If a bullet matches no H4 predicate explicitly, it lands in Work Effort (the `fallthrough: true` H4). This ensures every non-skipped bullet is visible somewhere.

### Skip filter

Bullets matching `rTimecardDay.skipFilter` (routine logging, multi-doc spam, etc.) render in zero H4s. The commit row still appears in the Per-Commit Audit (P1) — skipping applies to bullet-level rollups, not the commit itself.

---

## v1 format (legacy, still supported)

Kept for reference; retained indefinitely for historical commits.

```
Conv NNN: Concise imperative title

Changes:
- bullet
Fixes:
- bullet
Tests:
- bullet

API: METHOD /path — description
Page: /route — description
Role: RoleName — description
Infra: tool/skill/script — description
Doc: file/topic — description
Test: subject — description
User-facing: visible change
Admin-facing: visible change

Stats: X files changed
Block-summary: One sentence.

Block: BLOCKNAME
Conv: NNN
Machine: MACHINE
Type: end-of-conv     ← /r-end only

Co-Authored-By: Claude <noreply@anthropic.com>
```

v1 commits lack the `Format:` trailer. The timecard parser falls back to text-heuristic predicates (the `matchesRegex`, `startsWithAny`, etc. predicate families in `h4Sections[].include`) to classify bullets. Multi-H4 semantics apply equally to v1 commits — a v1 bullet mentioning an API path and a doc file will still render under both API Changes and Doc Changes.

---

## Examples

### v2 commit — minimal (single concern)

```
Conv 127: Fix date-picker timezone drift on session booking

### Work Effort
- [BKF] Replaced new Date() with DateTime.fromISO in SessionBooking.tsx

### User-facing
- Session booking — times now show correctly after midnight UTC

Stats: 2 files changed
Block: CALENDAR
Conv: 127
Machine: MacMiniM4-Pro
Format: v2
Block-summary: Eliminated last TZ-unsafe new Date() call in the booking flow.

Co-Authored-By: Claude <noreply@anthropic.com>
```

### v2 commit — multi-concern end-of-conv

```
Conv 127: Parameterize /r-timecard-day2 + fork r-end/r-commit into v2

### Work Effort
- [TC2-SPEC] Wrote docs/reference/COMMIT-MESSAGE-FORMAT.md canonical spec
- [TC2-CFG] Extended config.json rTimecardDay with h4Sections + skipFilter + dayWindow
- [TC2-SCRIPT] Refactored timecard-day.js — loadConfig, evaluateInclusion, per-H4 render loop
- [TC2-SKILLS] Forked r-commit → r-commit2 and r-end → r-end2 with v2 template

### Infra Changes
- /r-commit2 — new skill emitting v2 commit format
- /r-end2 — new skill with v2 commit format + Format: v2 trailer
- timecard-day.js — replaced classifyItem() tier cascade with per-H4 predicate engine

### Doc Changes
- COMMIT-MESSAGE-FORMAT.md — new canonical doc

Stats: 7 files changed (+ 3 new)
Block: (misc)
Conv: 127
Machine: MacMiniM4-Pro
Type: end-of-conv
Format: v2
Block-summary: Reshaped timecard tooling so a bullet can render under every H4 whose predicate matches, replacing single-destination tier routing.

Co-Authored-By: Claude <noreply@anthropic.com>
```

The `[TC2-SCRIPT]` bullet in Work Effort, which mentions `classifyItem()` and the `per-H4 predicate engine`, will **also** render under Code Changes (matches `codePrefixRe` via the `src/` hints) — if it had mentioned a `src/…` path. Since it doesn't, it renders only in Work Effort and (via `.claude/scripts/` in the `Infra Changes` bullet below it) potentially in Infra Changes depending on the predicate — but since the `Infra Changes` bullet is separate, the parser keeps them independent.
