---
name: r-coherence-check
description: Coherence audit of CLAUDE.md ↔ CLAUDE-OFFLOAD.md ↔ docs/reference/memory-archive/*.md — STRUCTURAL lint (broken refs, stub drift, overlap, orphan rules) by default; pass --deep / --semantic / --all to add SEMANTIC review (contradictions, ambiguity, friction, gaps, scope-creep, stale content). Surfaces findings ranked by severity; applies approved fixes on confirmation with diff preview for semantic changes; suppresses entries listed in .claude/coherence-ack.md.
argument-hint: "[--deep | --semantic | --all]"
model: claude-opus-4-7
effort: max
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

# Coherence Check — CLAUDE.md ↔ CLAUDE-OFFLOAD.md ↔ memory-archive

Lint + audit of the always-loaded `CLAUDE.md`, its extended-detail offload (`docs/reference/CLAUDE-OFFLOAD.md`, which also holds the retired-MEMORY.md "Situational Notes Archive" index), and the archived detail files (`docs/reference/memory-archive/*.md`) for cross-file drift. **Surface findings first; apply only on confirmation; never auto-fix.**

> **The `MEMORY.md` auto-memory system was retired Conv 456.** Its index moved into CLAUDE-OFFLOAD.md § "Situational Notes Archive" and its sub-files to `docs/reference/memory-archive/` (git-tracked, on-demand, **not** auto-loaded). There is no live memory dir or mirror. This skill now audits the offload + archive in place of the old index.

This is the **broad sweep**. For the **edit-coupled scoped flavor** (post-prune reference check), see `/r-prune-claude`'s Step 4 — same Check 1 (reference validation) logic, scoped to the prune's own deltas.

## Modes

- **Structural** (default, no args) — Checks 1-4. Deterministic, cheap, sub-second. Run as a routine post-edit reflex.
- **Deep / Semantic / All** (`--deep`, `--semantic`, or `--all`) — adds Checks 5-10 (CONTRADICTION, AMBIGUITY, FRICTION, STALE, REDUNDANCY, GAP, SCOPE-CREEP). Loads full CLAUDE.md + CLAUDE-OFFLOAD.md + all archive files; opus-max judgment-based review.

History: this skill subsumes `/r-optimize` (retired Conv 206). The r-optimize semantic categories and apply-fixes protocol are folded in; path bugs fixed; tiered invocation added so the structural lint is cheap enough to run routinely. Repointed off the retired MEMORY.md system Conv 456.

---

## Pre-computed Context

### Mode detection

**Mode is determined in Step 0 from the skill arguments** (which the harness appends as `ARGUMENTS: <args>` at the end of this prompt, NOT as a bash env var — Conv 206 [DEEP-INVOKE-BUG] confirmed `$ARGUMENTS` is not populated inside `!`-backticks). Full content blocks below always load; the skill body uses them only when Mode = DEEP.

### Structural extracts (always loaded)

**CLAUDE.md section headers (anchor targets for offload/archive pointers):**
!`grep -n '^## ' ~/projects/peerloop-docs/CLAUDE.md`

**CLAUDE.md stats:**
!`echo "$(wc -l < ~/projects/peerloop-docs/CLAUDE.md) lines, $(grep -c '^## ' ~/projects/peerloop-docs/CLAUDE.md) sections, $(wc -c < ~/projects/peerloop-docs/CLAUDE.md) bytes"`

**CLAUDE-OFFLOAD.md section headers:**
!`grep -n '^## ' ~/projects/peerloop-docs/docs/reference/CLAUDE-OFFLOAD.md`

**Archive files present:**
!`ls ~/projects/peerloop-docs/docs/reference/memory-archive/*.md 2>/dev/null | xargs -n1 basename | sort`

**CLAUDE-OFFLOAD.md archive-index links (file links to verify):**
!`grep -nE '\]\(memory-archive/[a-z_0-9-]+\.md\)' ~/projects/peerloop-docs/docs/reference/CLAUDE-OFFLOAD.md`

**CLAUDE.md → memory-archive references (should normally be none — rules cite CLAUDE-OFFLOAD, not the archive directly):**
!`grep -nE 'memory-archive/[a-z_0-9-]+\.md' ~/projects/peerloop-docs/CLAUDE.md || echo "(none)"`

**Archive files containing CLAUDE.md § references:**
!`grep -lE 'CLAUDE\.md §|§[A-Z]' ~/projects/peerloop-docs/docs/reference/memory-archive/*.md 2>/dev/null | xargs -n1 basename | sort`

**CLAUDE.md stub-pointer lines (→ See OFFLOAD):**
!`grep -niE '→ See OFFLOAD|See \[docs/reference/CLAUDE-OFFLOAD|lives in \[docs/reference/CLAUDE-OFFLOAD' ~/projects/peerloop-docs/CLAUDE.md || echo "(none)"`

**Distinctive-marker counts** — markers from `config.json` `coherenceCheck.markers` (falls back to defaults if config missing):
!`MARKERS=$(python3 -c "
import json, sys
try:
    c = json.load(open('$HOME/projects/peerloop-docs/.claude/config.json'))
    for m in c.get('coherenceCheck', {}).get('markers', []):
        print(m)
except Exception:
    sys.exit(1)
" 2>/dev/null) || MARKERS=$'👉👉👉\n🔴🔴🔴\n🟠🟠🟠\ntee /tmp/lastFullTestRun\ngit -C ~/projects/peerloop-docs\ngit -C ~/projects/Peerloop'
ARCHIVE=~/projects/peerloop-docs/docs/reference/memory-archive
while IFS= read -r m; do
  [ -z "$m" ] && continue
  cmd_count=$(grep -cF "$m" ~/projects/peerloop-docs/CLAUDE.md 2>/dev/null || echo 0)
  arch_files=$(grep -lF "$m" "$ARCHIVE"/*.md 2>/dev/null | xargs -n1 basename 2>/dev/null | tr '\n' ',' | sed 's/,$//')
  echo "  '$m': CLAUDE.md=$cmd_count | archive files: [${arch_files:-none}]"
done <<< "$MARKERS"`

**Archive files with `type: feedback` (orphan-rule candidates):**
!`grep -lE '^type: feedback' ~/projects/peerloop-docs/docs/reference/memory-archive/feedback_*.md 2>/dev/null | xargs -n1 basename | sort`

**Acknowledgments file (suppressed findings):**
!`cat ~/projects/peerloop-docs/.claude/coherence-ack.md 2>/dev/null || echo "(no ack file — all findings will surface)"`

### Full content (always loaded — consulted only in DEEP mode)

**CLAUDE.md (full text):**
!`cat ~/projects/peerloop-docs/CLAUDE.md`

**CLAUDE-OFFLOAD.md (full text):**
!`cat ~/projects/peerloop-docs/docs/reference/CLAUDE-OFFLOAD.md`

**All archive files (full text):**
!`for f in ~/projects/peerloop-docs/docs/reference/memory-archive/*.md; do echo "=== $(basename $f) ==="; cat "$f"; echo; done`

---

## Categories

### STRUCTURAL (deterministic — Mode: STRUCTURAL and DEEP both run these)

- **[BROKEN-REF]** — Reference doesn't resolve. File missing, `## X` header doesn't exist for a `CLAUDE.md §X` reference, `[label](memory-archive/file.md)` link target absent.
- **[STUB-DRIFT]** — A CLAUDE.md "→ See OFFLOAD" stub points at a CLAUDE-OFFLOAD.md `## X` section that doesn't exist (or vice versa: an offload section whose CLAUDE.md stub was deleted).
- **[OVERLAP]** — Distinctive markers (from `config.json` `coherenceCheck.markers`) appear in BOTH CLAUDE.md and an archive file → rule-body duplication risk (mostly benign now the archive is frozen; still flag genuine live-rule duplication).
- **[ORPHAN]** — An archive file with `type: feedback` states a rule with no CLAUDE.md §-counterpart → the rule survives only in the frozen archive, not in the always-loaded CLAUDE.md. Informational: candidate to promote into CLAUDE.md or accept as retired.

### SEMANTIC (judgment-based — Mode: DEEP only)

- **[CONTRADICTION]** — Two rules directly conflict. **EXEMPT:** intentional, documented overrides (e.g., §Investigative Framings explicitly overriding §Solution Quality).
- **[AMBIGUITY]** — Scope or trigger condition unclear. Undefined "when in doubt", unquantified thresholds like "significant change".
- **[FRICTION]** — Rule generates unnecessary check-ins or halts for actions the user clearly wants automated.
- **[STALE]** — Content refers to old states, completed work, or superseded patterns ("Session" instead of "Conv", retired blocks, dead branch names, references to the retired MEMORY.md system).
- **[REDUNDANCY]** — Full-rule duplication across CLAUDE.md + CLAUDE-OFFLOAD.md (broader content-level form of [OVERLAP] which is marker-only).
- **[GAP]** — Missing rule causing wrong default behavior. Pattern established in the archive but never codified in CLAUDE.md is a common form.
- **[SCOPE-CREEP]** — Rule's wording too broad → triggers in unintended contexts.

---

## Step 0: Mode and Acknowledgments

1. **Detect Mode from skill arguments.** The harness appends `ARGUMENTS: <args>` at the end of this prompt. If `<args>` contains `--deep`, `--semantic`, or `--all`, set **Mode = DEEP** (run Checks 1-10, consult the full-content pre-computed blocks). Otherwise **Mode = STRUCTURAL** (run Checks 1-4 only — skip Step 2; ignore the full-content blocks even though they're loaded). If no `ARGUMENTS:` line is present, default to STRUCTURAL.
2. Parse the **Acknowledgments file** from pre-computed context. Extract every uncommented `[CATEGORY] location-match` line into an in-memory suppression list.
3. Note the structural/semantic split in the report header.

---

## Step 1: Structural Checks (always run)

### 1a. [BROKEN-REF]

1. CLAUDE.md → CLAUDE-OFFLOAD.md: every `→ See OFFLOAD` / `docs/reference/CLAUDE-OFFLOAD.md#...` reference must resolve to an existing `## X` header in CLAUDE-OFFLOAD.md.
2. CLAUDE-OFFLOAD.md archive-index → file existence: every `[label](memory-archive/file.md)` link's target must exist in "Archive files present." Flag missing.
3. archive/CLAUDE-OFFLOAD → CLAUDE.md § refs: for each file in "Archive files containing § references" (and any `CLAUDE.md §X` in CLAUDE-OFFLOAD.md), `Read` it; grep for `CLAUDE.md §X` or `§X` patterns; verify §X matches an exact `## X` header in CLAUDE.md. Flag unresolved. (Frozen-archive § refs that no longer resolve are LOW severity — history, not a live break.)

### 1b. [STUB-DRIFT]

For each line in "CLAUDE.md stub-pointer lines" (→ See OFFLOAD), confirm the cited CLAUDE-OFFLOAD.md `## X` section exists and vice-versa (no orphaned offload section whose CLAUDE.md stub was removed).

### 1c. [OVERLAP]

From the marker-count table, identify markers in BOTH CLAUDE.md and an archive file.

**Exempt cases (do NOT flag):**
- The entry IS about the marker (e.g., `feedback_pointing_emoji_prefix.md` contains 👉👉👉 because its topic IS that marker — index hook, not duplicated rule).
- The archive is frozen history — a marker co-occurrence that merely preserves an incident is not live duplication.

Surface only genuine live-rule duplication.

### 1d. [ORPHAN]

For each file in "Archive files with `type: feedback`": `Read` its leading rule statement; look for a CLAUDE.md `##` section with substantially overlapping body. If no match, flag as informational — the rule lives only in the frozen archive (candidate to promote into CLAUDE.md, or accept as retired).

---

## Step 2: Semantic Checks (DEEP mode only)

If Mode = STRUCTURAL, **skip this step entirely** and proceed to Step 3 (acknowledgment filtering + report).

If Mode = DEEP, use the "CLAUDE.md (full text)", "CLAUDE-OFFLOAD.md (full text)", and "All archive files (full text)" pre-computed blocks. Apply judgment for each category (CONTRADICTION, AMBIGUITY, FRICTION, STALE, REDUNDANCY, GAP, SCOPE-CREEP).

For each finding, use the format:

```
[CATEGORY] severity: HIGH | MEDIUM | LOW
Location: CLAUDE.md §Section / docs/reference/CLAUDE-OFFLOAD.md §Section / docs/reference/memory-archive/<file>.md (+ line where known)
Issue: One-sentence description
Quote: "Exact verbatim text"
Impact: How this causes confusion / extra interactions / wrong behavior
Fix: Specific proposed change (rewrite | delete | move | clarify) — include proposed text where applicable
```

**Severity guidance:**
- **HIGH** — causes real collaboration failures. Broken refs, hard contradictions, missing rules that produce wrong behavior every time.
- **MEDIUM** — occasional drift or confusion. Ambiguity that bites sometimes, redundancy that's started to diverge.
- **LOW** — housekeeping. Stale phrasing, minor wording cleanup, harmless duplication, frozen-archive history.

---

## Step 3: Apply Acknowledgment Filter

For each finding from Steps 1-2, check the suppression list (from Step 0):

```
suppress = ANY ack-entry where
  ack-entry.category == finding.category
  AND ack-entry.location-match substring matches finding.location
```

Suppressed findings:
- Do NOT appear in the main report body.
- Are counted in a summary line: `[N findings acknowledged — see .claude/coherence-ack.md]`.

---

## Step 4: Present Findings

```
╔══════════════════════════════════════════════════╗
║  /r-coherence-check — Audit Report ([MODE])      ║
╚══════════════════════════════════════════════════╝

Files reviewed:
  CLAUDE.md              [X] lines, [Y] sections
  CLAUDE-OFFLOAD.md      [Z] sections
  memory-archive/*.md    [M] archive files

Mode: STRUCTURAL | DEEP
Findings: [total] active ([n] HIGH, [n] MEDIUM, [n] LOW)
[A acknowledged — suppressed per .claude/coherence-ack.md]

────────────────────────────────────────────────────
STRUCTURAL
────────────────────────────────────────────────────
🔴 #1  [BROKEN-REF] severity: HIGH
   Location: …
   …

🟠 #2  [STUB-DRIFT] severity: MEDIUM
   …

────────────────────────────────────────────────────
SEMANTIC                  [DEEP mode only — omit section if Mode=STRUCTURAL]
────────────────────────────────────────────────────
🔴 #N  [CONTRADICTION] severity: HIGH
   …

════════════════════════════════════════════════════
RECOMMENDED ACTIONS
════════════════════════════════════════════════════
1. [highest-leverage fix]
2. …
```

If no active findings:

```
✅ Coherence: clean ([MODE] mode).
   [Brief stats per check.]
   [A acknowledged findings suppressed — see .claude/coherence-ack.md]
```

---

## Step 5: Fix Protocol

After presenting findings, ask:

```
👉👉👉 **Which fixes would you like applied?**

- "all high"       — apply all HIGH severity fixes
- "all"            — apply all findings
- "structural"     — apply all STRUCTURAL fixes (deterministic, safest)
- "semantic"       — apply all SEMANTIC fixes (judgment-based — diff preview before write)
- "1, 3, 5"        — apply specific numbered items
- "none"           — report only, no changes
```

**Wait for user response. Do not apply any changes without explicit approval.**

### Application — by category type

**STRUCTURAL fixes** (BROKEN-REF, STUB-DRIFT, OVERLAP, ORPHAN):
1. `Read` the current file content
2. Apply the minimal change
3. Report: `✅ Fixed [#N] (structural): [brief description]`

**SEMANTIC fixes** (CONTRADICTION, AMBIGUITY, FRICTION, STALE, REDUNDANCY, GAP, SCOPE-CREEP):
1. `Read` the current file content
2. Compute the proposed diff:
   ```
   ──── Fix #N preview ────
   File: <path>
   - <old text>
   + <new text>
   ────
   ```
3. Ask: `👉 Apply this exact rewrite for #N? (yes / adjust / skip)`
   - **yes** → write the change, report `✅ Fixed [#N] (semantic): [brief description]`
   - **adjust** → user provides revised wording; re-preview
   - **skip** → leave finding, move to next approved fix
4. Wait for response before writing.

### Post-fix verification

After all approved fixes apply:
- **Re-run Step 1 (structural checks)** — cheap; verifies no new dangling references were introduced.
- Report any new structural findings from the post-fix sweep.

---

## Rules

- **Read every line of CLAUDE.md, CLAUDE-OFFLOAD.md, and every archive file** (when Mode=DEEP). The full-content blocks are in pre-computed context for exactly this — partial reads produce incomplete findings.
- **Quote exactly.** Always include verbatim problematic text in findings, not paraphrase.
- **Cross-file analysis is required.** Findings span CLAUDE.md ↔ CLAUDE-OFFLOAD.md ↔ memory-archive/*.md.
- **Never auto-fix.** Surface findings first (Step 4); apply only on explicit user approval (Step 5).
- **The archive is frozen history, not live rules.** A broken § ref or marker co-occurrence *inside* an archive file is LOW severity (history), not a live break. Reserve HIGH for CLAUDE.md ↔ CLAUDE-OFFLOAD.md breaks.
- **Intentional overrides exempt from [CONTRADICTION].** When CLAUDE.md documents the override (e.g., §Investigative Framings carves out from §Solution Quality / §Critical Rule), it's not a contradiction.
- **For [CONTRADICTION] findings: propose which source wins.** Don't just flag the conflict; recommend a resolution.
- **HIGH severity = real collaboration failures.** Reserve for genuine blockers, not style preferences.
- **Diff preview is mandatory for SEMANTIC fixes** — Step 5's preview-then-confirm flow is non-negotiable; semantic rewrites can drift from user intent without it.
- **Acknowledgment file controls suppression**, not deletion — suppressed findings are still detected, just not surfaced. To re-surface a finding, remove its line from `.claude/coherence-ack.md`.
- **Coordination with `/r-prune-claude`:** that skill runs scoped [BROKEN-REF] validation post-execute (its own deltas only). This skill runs the broad sweep + (in DEEP mode) all 10 categories.
- **Post-fix verification re-runs STRUCTURAL only** — re-running SEMANTIC checks would be expensive and rarely catches issues the fixes introduced.
