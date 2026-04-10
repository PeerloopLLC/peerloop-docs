---
name: w-sync-skills
description: Scan another dual-repo project for skill changes and port improvements
argument-hint: "[source-name] [skill-name] (default: scan all sources, all skills)"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TaskCreate
---

# Sync Skills from Another Dual-Repo

**Purpose:** Compare this project's skills against another dual-repo project, identify functional differences worth porting, and port them with terminology adapted for this project.

---

## Pre-computed Context

**This project:**
!`basename $CLAUDE_PROJECT_DIR`

**This project's skills:**
!`ls -1 $CLAUDE_PROJECT_DIR/.claude/skills/`

**Config (skillSync section):**
!`cat .claude/config.json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(json.dumps(d.get('skillSync',{}), indent=2))" 2>/dev/null || echo "(no skillSync config)"`

---

## Known Source Projects

Hardcoded list of dual-repo projects that can be synced from:

| Name | Docs Repo Path | Code Repo |
|------|---------------|-----------|
| `spt-docs` | `~/projects/spt-docs` | `spt` |

To add a new source: add a row here AND a corresponding entry in `config.json` → `skillSync.sources[]` with its replacement mappings.

---

## Arguments

| Argument | Meaning | Example |
|----------|---------|---------|
| (empty) | Scan all known sources, all skills | `/w-sync-skills` |
| `spt-docs` | Scan only this source, all skills | `/w-sync-skills spt-docs` |
| `spt-docs r-end` | Scan only this source, only this skill | `/w-sync-skills spt-docs r-end` |
| `r-end` | Single skill (auto-resolves source if only one configured) | `/w-sync-skills r-end` |

**Single-skill mode:** When a skill name is provided, skip the full inventory (Step 2) and go directly to comparison (Step 3) for that one skill. The skill must exist in both projects (exact match). If it exists only in the source, jump to Step 4 for that skill. If it exists only locally, error: "Skill '{name}' not found in source."

---

## Workflow

### Step 1: Resolve Source and Skill Filter

**Parse arguments:** Split the argument string into tokens. Determine which (if any) is a source name and which (if any) is a skill name:

1. If a token matches a Known Source Projects name → it's the source.
2. If a token does NOT match any source name → it's a skill filter. Verify it exists in at least one project before proceeding.
3. If no source token and only one source exists, auto-resolve it.
4. If no source can be resolved, error.

**Resolve source:**
1. Verify the source path exists on disk. If not, error: "Source project not found at [path]"
2. Load the replacement mappings from `config.json` → `skillSync.sources[]` matching the source name.

**Store skill filter:** If a skill name was provided, store it. Steps 2–4 will scope to only that skill.

### Step 2: Inventory Skills

**If skill filter is set:** Skip the full inventory. Check that the skill exists in the source and/or local project, then proceed directly to Step 3 (if exact match) or Step 4 (if source-only). If the skill exists only locally, error: "Skill '{name}' not found in source."

**If no skill filter:** List skills in both projects:

```bash
ls -1 $CLAUDE_PROJECT_DIR/.claude/skills/
ls -1 {SOURCE_PATH}/.claude/skills/
```

Categorize into three groups:

| Category | Meaning |
|----------|---------|
| **Exact match** | Same skill name in both projects |
| **Source only** | Exists in source but not here |
| **Local only** | Exists here but not in source |

Present the inventory:

```
Skill Sync: {source_name} → {this_project}
══════════════════════════════════════════

Exact matches: {list}
Source only:   {list}
Local only:    {list}  (informational — not actionable)
```

### Step 3: Compare Exact Matches

> ⚠️ **DIRECTION — READ BEFORE COMPARING**
>
> This is a **one-way sync: SOURCE → LOCAL**.
>
> - **SOURCE** = the other project (e.g. `spt-docs`) — the thing we are reading *from*
> - **LOCAL** = this project (`$CLAUDE_PROJECT_DIR`) — the thing we are porting *to*
>
> The question you are answering is always: **"What does SOURCE have that LOCAL lacks?"** — never the reverse.
>
> If LOCAL has something SOURCE lacks, that is **not a finding** (it is a local customization and must be preserved, not removed).
>
> **Every finding must be phrased as:**
> ```
> Source has: {what source does}
> Local has:  {what local does (or "nothing" / "older version")}
> ```
> Do not write findings in any other form. If you catch yourself writing "Local has X but Source doesn't" as a porting candidate, stop — you have reversed direction.

For each exact-match skill (or the single filtered skill):

1. Read both SKILL.md files directly (do not summarize via an agent — see delegation rule below)
2. Apply the replacement mappings to the **source** SKILL.md (transform source terminology → local terminology) to produce a "normalized" version
3. Compare the normalized source against the local SKILL.md
4. If functionally identical after normalization → mark as "In sync"
5. If differences remain → these are **functional differences** (new features, bug fixes, structural changes)

Also compare supporting files (refs/, scripts/) using the same approach — list files in both, diff any with the same name after applying replacements.

**Delegation rule:** Prefer reading files directly with the `Read` tool. If a skill is large enough that delegating to an `Explore` agent is warranted, the delegation prompt MUST:

1. State the DIRECTION block above verbatim at the top of the prompt
2. Label the two file sets as `SOURCE` and `LOCAL` (never "project A/B", "file 1/2", or path-only references)
3. Require the agent's output to use the literal `Source has: … / Local has: …` format
4. Repeat the DIRECTION reminder immediately before the "output format" section of the delegation prompt — agents lose track of direction over long contexts, and the reminder must be the last thing they read before writing

After the agent returns, **manually re-filter** its findings: for each one, confirm it answers "what does SOURCE have that LOCAL lacks?" Drop any finding where the agent reversed the framing.

**Present findings for each skill with differences:**

```
### {skill-name}

Status: DIFFERS — {N} functional difference(s)

1. **{Description of difference}**
   Source has: {what the source version does}
   Local has: {what the local version does}
   Assessment: {whether this looks like an improvement worth porting}

2. ...

Port these changes? [y/n/selective]
```

For skills that are in sync, just list them:
```
In sync: {skill1}, {skill2}, ...
```

### Step 4: Review Source-Only Skills

For each source-only skill:

1. Read its SKILL.md
2. Present a brief summary (description, what it does, ~3 lines)
3. Assess portability:
   - **Portable now** — project-agnostic or easily adapted
   - **Portable later** — good concept but needs project infrastructure that doesn't exist yet
   - **Not portable** — too project-specific, or already subsumed by a local skill

```
### {skill-name} (source only)

Description: {from frontmatter}
Summary: {2-3 sentence overview}
Assessment: {Portable now / Portable later / Not portable}
Reason: {why}

Port? [y/n]
```

### Step 5: Port Approved Changes

For each approved port:

#### Porting an exact-match update:

1. Read the source SKILL.md (and any supporting files with differences)
2. Identify the specific sections/lines that differ functionally
3. Apply only the functional changes to the local SKILL.md, preserving local terminology
4. Do NOT blindly copy the source file — merge the improvements into the existing local version

#### Porting a source-only skill:

1. Create the skill directory: `.claude/skills/{skill-name}/`
2. Copy all files from the source skill
3. Apply ALL replacement mappings from config.json to every copied file
4. Review the result for any source-specific references that the replacements didn't catch (topic lists, doc paths, example data)
5. Adapt these manually based on this project's domain

#### For both types:

After porting, display what was changed:

```
Ported: {skill-name}
  Files modified: {list}
  Replacements applied: {count}
  Manual adaptations: {list of project-specific changes beyond simple replacement}
```

### Step 5b: Compare CLAUDE.md Directives

After skill porting, compare the **directive sections** of both projects' CLAUDE.md files:

1. Read the source project's CLAUDE.md
2. Read this project's CLAUDE.md
3. Identify directive sections in the source that don't exist locally (section headings, rules, behavioral instructions)
4. Apply replacement mappings to normalize terminology
5. Apply the same DIRECTION filter from Step 3 — a directive present only locally is a local customization, not a gap. Only port directives present in source but missing locally.
6. For each directive found only in source, or with functional differences:

```
### CLAUDE.md Directive: {section name}

Status: {MISSING locally / DIFFERS}
Source has: {summary of the directive}
Local has: {what exists locally, or "nothing"}
Assessment: {whether this is project-specific or broadly applicable}

Port? [y/n]
```

**Also compare `~/.claude/CLAUDE.md` (global)** — directives may live there instead. Flag if a directive exists in global but not in the project file (or vice versa) and recommend whether it should be in both.

**Skip sections that are inherently project-specific** (e.g., project overview, architecture, tech stack, file paths). Focus on behavioral directives: formatting rules, visual alert patterns, workflow rules, quality standards.

### Step 6: Report

```
Skill Sync Complete
═══════════════════

Source: {source_name}

  In sync:          {list}
  Updated:          {list of exact matches that were updated}
  Ported (new):     {list of source-only skills that were ported}
  Skipped:          {list with reasons}
  Local only:       {list} (not affected)
```

---

## Replacement Mapping

Replacements are applied in the **order listed** in config.json `skillSync.sources[].replacements`. Order matters — more specific patterns must come before general ones (e.g., `"spt-docs"` before `"spt"`, `"../spt"` before `"spt"`).

Each replacement is a `[from, to]` pair. They are applied as **case-sensitive** literal string replacements, not regex.

**What replacements DON'T cover:** Topic lists, doc path references, example data, domain-specific categories. These require manual review and are flagged during porting as "Manual adaptations."

---

## Rules

- **Direction is SOURCE → LOCAL, always** — findings answer "what does SOURCE have that LOCAL lacks?" Never the reverse. Local-only content is a customization to preserve, not a gap to fill.
- **Every finding uses `Source has: … / Local has: …` phrasing** — no exceptions. Any other phrasing is a directional-confusion bug and must be re-filtered.
- **If delegating comparison to an agent, enforce direction in the prompt** — restate the DIRECTION block at both the top and immediately before the output-format section, and re-filter the agent's output manually afterward.
- **Never overwrite local customizations blindly** — merge functional changes, don't replace files
- **Present all findings before porting** — user approves each change
- **Apply replacements to source before diffing** — so only functional differences surface
- **Replacement order matters** — longer/more-specific patterns first
- **Flag anything replacements don't catch** — topic lists, doc paths, examples need manual review
- **Do NOT modify the source project** — this is a one-way sync (source → local)
- **Do NOT commit** — leave changes for the user to review and commit via `/r-commit`
