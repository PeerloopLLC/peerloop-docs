---
name: w-sync-skills
description: Scan another dual-repo project for skill changes and port improvements
argument-hint: "[source-name] (default: scan all sources)"
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
| (empty) | Scan all known sources | `/w-sync-skills` |
| `spt-docs` | Scan only this source | `/w-sync-skills spt-docs` |

---

## Workflow

### Step 1: Resolve Source

1. If argument provided, match against Known Source Projects table. Error if not found.
2. If no argument and only one source exists, use it. If multiple, scan all.
3. Verify the source path exists on disk. If not, error: "Source project not found at [path]"
4. Load the replacement mappings from `config.json` → `skillSync.sources[]` matching the source name.

### Step 2: Inventory Skills

List skills in both projects:

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

For each exact-match skill:

1. Read both SKILL.md files
2. Apply the replacement mappings to the **source** SKILL.md (transform source terminology → local terminology) to produce a "normalized" version
3. Compare the normalized source against the local SKILL.md
4. If functionally identical after normalization → mark as "In sync"
5. If differences remain → these are **functional differences** (new features, bug fixes, structural changes)

Also compare supporting files (refs/, scripts/) using the same approach — list files in both, diff any with the same name after applying replacements.

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

- **Never overwrite local customizations blindly** — merge functional changes, don't replace files
- **Present all findings before porting** — user approves each change
- **Apply replacements to source before diffing** — so only functional differences surface
- **Replacement order matters** — longer/more-specific patterns first
- **Flag anything replacements don't catch** — topic lists, doc paths, examples need manual review
- **Do NOT modify the source project** — this is a one-way sync (source → local)
- **Do NOT commit** — leave changes for the user to review and commit via `/r-commit`
