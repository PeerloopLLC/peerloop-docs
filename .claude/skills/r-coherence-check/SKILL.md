---
name: r-coherence-check
description: Coherence audit of CLAUDE.md ↔ MEMORY.md ↔ memory/*.md — STRUCTURAL lint (broken refs, stub drift, overlap, orphan rules) by default; pass --deep / --semantic / --all to add SEMANTIC review (contradictions, ambiguity, friction, gaps, scope-creep, stale content). Surfaces findings ranked by severity; applies approved fixes on confirmation with diff preview for semantic changes; suppresses entries listed in .claude/coherence-ack.md.
argument-hint: "[--deep | --semantic | --all]"
model: claude-opus-4-7
effort: max
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

# Coherence Check — CLAUDE.md ↔ MEMORY.md ↔ memory/*.md

Lint + audit of the always-loaded `CLAUDE.md`, the memory index (`MEMORY.md`), and the memory sub-files for cross-file drift. **Surface findings first; apply only on confirmation; never auto-fix.**

This is the **broad sweep**. For the **edit-coupled scoped flavor** (post-prune reference check), see `/r-prune-claude`'s Step 4 — same Check 1 (reference validation) logic, scoped to the prune's own deltas.

## Modes

- **Structural** (default, no args) — Checks 1-4. Deterministic, cheap, sub-second. Run as a routine post-edit reflex.
- **Deep / Semantic / All** (`--deep`, `--semantic`, or `--all`) — adds Checks 5-10 (CONTRADICTION, AMBIGUITY, FRICTION, STALE, REDUNDANCY, GAP, SCOPE-CREEP). Loads full CLAUDE.md + all memory files; opus-max judgment-based review.

History: this skill subsumes `/r-optimize` (retired Conv 206). The r-optimize semantic categories and apply-fixes protocol are folded in; path bugs fixed; tiered invocation added so the structural lint is cheap enough to run routinely.

---

## Pre-computed Context

### Mode detection

**Mode is determined in Step 0 from the skill arguments** (which the harness appends as `ARGUMENTS: <args>` at the end of this prompt, NOT as a bash env var — Conv 206 [DEEP-INVOKE-BUG] confirmed `$ARGUMENTS` is not populated inside `!`-backticks). Full content blocks below always load; the skill body uses them only when Mode = DEEP.

### Structural extracts (always loaded)

**CLAUDE.md section headers (anchor targets for memory pointers):**
!`grep -n '^## ' ~/projects/peerloop-docs/CLAUDE.md`

**CLAUDE.md stats:**
!`echo "$(wc -l < ~/projects/peerloop-docs/CLAUDE.md) lines, $(grep -c '^## ' ~/projects/peerloop-docs/CLAUDE.md) sections, $(wc -c < ~/projects/peerloop-docs/CLAUDE.md) bytes"`

**Memory files present:**
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); ls ~/.claude/projects/$SLUG/memory/*.md 2>/dev/null | xargs -n1 basename | sort`

**MEMORY.md index lines (file links to verify):**
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); grep -nE '\[[^]]+\]\([a-z_0-9-]+\.md\)' ~/.claude/projects/$SLUG/memory/MEMORY.md`

**CLAUDE.md → memory/ references:**
!`grep -nE 'memory/[a-z_0-9-]+\.md' ~/projects/peerloop-docs/CLAUDE.md || echo "(none)"`

**Memory files containing CLAUDE.md § references:**
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); grep -lE 'CLAUDE\.md §|§[A-Z]' ~/.claude/projects/$SLUG/memory/*.md 2>/dev/null | xargs -n1 basename | sort`

**MEMORY.md stub-pointer lines:**
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); grep -niE 'stub pointer|rule lives in CLAUDE\.md|lives in CLAUDE\.md' ~/.claude/projects/$SLUG/memory/MEMORY.md || echo "(none)"`

**Distinctive-marker counts** — markers from `config.json` `coherenceCheck.markers` (falls back to defaults if config missing):
!`MARKERS=$(python3 -c "
import json, sys
try:
    c = json.load(open('/Users/livingroom/projects/peerloop-docs/.claude/config.json'))
    for m in c.get('coherenceCheck', {}).get('markers', []):
        print(m)
except Exception:
    sys.exit(1)
" 2>/dev/null) || MARKERS=$'👉👉👉\n🔴🔴🔴\n🟠🟠🟠\ntee /tmp/lastFullTestRun\ngit -C ~/projects/peerloop-docs\ngit -C ~/projects/Peerloop'
SLUG=$(echo ~/projects/peerloop-docs | tr / -)
while IFS= read -r m; do
  [ -z "$m" ] && continue
  cmd_count=$(grep -cF "$m" ~/projects/peerloop-docs/CLAUDE.md 2>/dev/null || echo 0)
  mem_files=$(grep -lF "$m" ~/.claude/projects/$SLUG/memory/*.md 2>/dev/null | xargs -n1 basename 2>/dev/null | tr '\n' ',' | sed 's/,$//')
  echo "  '$m': CLAUDE.md=$cmd_count | memory files: [${mem_files:-none}]"
done <<< "$MARKERS"`

**Memory files with `type: feedback` (orphan-rule candidates):**
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); grep -lE '^type: feedback' ~/.claude/projects/$SLUG/memory/feedback_*.md 2>/dev/null | xargs -n1 basename | sort`

**Acknowledgments file (suppressed findings):**
!`cat ~/projects/peerloop-docs/.claude/coherence-ack.md 2>/dev/null || echo "(no ack file — all findings will surface)"`

### Full content (always loaded — consulted only in DEEP mode)

**CLAUDE.md (full text):**
!`cat ~/projects/peerloop-docs/CLAUDE.md`

**All memory files (full text):**
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); for f in ~/.claude/projects/$SLUG/memory/*.md; do echo "=== $(basename $f) ==="; cat "$f"; echo; done`

---

## Categories

### STRUCTURAL (deterministic — Mode: STRUCTURAL and DEEP both run these)

- **[BROKEN-REF]** — Reference doesn't resolve. File missing, `## X` header doesn't exist for a `CLAUDE.md §X` reference, `[label](file.md)` link target absent.
- **[STUB-DRIFT]** — MEMORY.md index claims "stub pointer" but the memory file body fully restates the rule instead of deferring to CLAUDE.md.
- **[OVERLAP]** — Distinctive markers (from `config.json` `coherenceCheck.markers`) appear in BOTH CLAUDE.md and a memory file → rule-body duplication risk.
- **[ORPHAN]** — A memory file with `type: feedback` has a rule body but no CLAUDE.md §-counterpart → rule lives only in memory body (not always-loaded except via the MEMORY.md index line).

### SEMANTIC (judgment-based — Mode: DEEP only)

- **[CONTRADICTION]** — Two rules directly conflict. **EXEMPT:** intentional, documented overrides (e.g., §Investigative Framings explicitly overriding §Solution Quality).
- **[AMBIGUITY]** — Scope or trigger condition unclear. Undefined "when in doubt", unquantified thresholds like "significant change".
- **[FRICTION]** — Rule generates unnecessary check-ins or halts for actions the user clearly wants automated.
- **[STALE]** — Content refers to old states, completed work, or superseded patterns ("Session" instead of "Conv", retired blocks, dead branch names).
- **[REDUNDANCY]** — Full-rule duplication across CLAUDE.md + memory (broader content-level form of [OVERLAP] which is marker-only).
- **[GAP]** — Missing rule causing wrong default behavior. Pattern established in memory but never codified in CLAUDE.md is a common form.
- **[SCOPE-CREEP]** — Rule's wording too broad → triggers in unintended contexts.

---

## Step 0: Mode and Acknowledgments

1. **Detect Mode from skill arguments.** The harness appends `ARGUMENTS: <args>` at the end of this prompt. If `<args>` contains `--deep`, `--semantic`, or `--all`, set **Mode = DEEP** (run Checks 1-10, consult the full-content pre-computed blocks). Otherwise **Mode = STRUCTURAL** (run Checks 1-4 only — skip Step 2; ignore the full-content blocks even though they're loaded). If no `ARGUMENTS:` line is present, default to STRUCTURAL.
2. Parse the **Acknowledgments file** from pre-computed context. Extract every uncommented `[CATEGORY] location-match` line into an in-memory suppression list.
3. Note the structural/semantic split in the report header.

---

## Step 1: Structural Checks (always run)

### 1a. [BROKEN-REF]

1. CLAUDE.md → memory/ files: every referenced `memory/<file>.md` in the pre-computed list must exist in "Memory files present." Flag missing.
2. MEMORY.md index → file existence: every `[label](file.md)` link's target must exist. Flag missing.
3. memory/ → CLAUDE.md § refs: for each file in "Memory files containing § references", `Read` it; grep its body for `CLAUDE.md §X` or `§X` patterns; verify §X matches an exact `## X` header. Flag unresolved.

### 1b. [STUB-DRIFT]

For each file mentioned in "MEMORY.md stub-pointer lines", `Read` and confirm the body actually DEFERS ("rule lives in CLAUDE.md §X", "see CLAUDE.md §X", or short retention-only note like "preserves Conv N archaeology") rather than fully restating the rule.

### 1c. [OVERLAP]

From the marker-count table, identify markers in BOTH CLAUDE.md and a memory file.

**Exempt cases (do NOT flag):**
- The entry IS about the marker (e.g., `feedback_pointing_emoji_prefix.md` contains 👉👉👉 because its topic IS that marker — index hook, not duplicated rule).
- The memory file is on the stub-pointer list (its body grep-anchors the marker but defers the rule to CLAUDE.md).

Surface non-exempt cases.

### 1d. [ORPHAN]

For each file in "Memory files with `type: feedback`": `Read` its leading rule statement; look for a CLAUDE.md `##` section with substantially overlapping body. If no match AND the file isn't on the stub-pointer list, flag.

---

## Step 2: Semantic Checks (DEEP mode only)

If Mode = STRUCTURAL, **skip this step entirely** and proceed to Step 3 (acknowledgment filtering + report).

If Mode = DEEP, use the "CLAUDE.md (full text)" and "All memory files (full text)" pre-computed blocks. Apply judgment for each category (CONTRADICTION, AMBIGUITY, FRICTION, STALE, REDUNDANCY, GAP, SCOPE-CREEP).

For each finding, use the format:

```
[CATEGORY] severity: HIGH | MEDIUM | LOW
Location: CLAUDE.md §Section / memory/<file>.md (+ line where known)
Issue: One-sentence description
Quote: "Exact verbatim text"
Impact: How this causes confusion / extra interactions / wrong behavior
Fix: Specific proposed change (rewrite | delete | move | clarify) — include proposed text where applicable
```

**Severity guidance:**
- **HIGH** — causes real collaboration failures. Broken refs, hard contradictions, missing rules that produce wrong behavior every time.
- **MEDIUM** — occasional drift or confusion. Ambiguity that bites sometimes, redundancy that's started to diverge.
- **LOW** — housekeeping. Stale phrasing, minor wording cleanup, harmless duplication.

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
  CLAUDE.md         [X] lines, [Y] sections
  MEMORY.md         [N] index lines
  memory/*.md       [M] sub-files

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

- **Read every line of CLAUDE.md and every memory file** (when Mode=DEEP). The full-content blocks are in pre-computed context for exactly this — partial reads produce incomplete findings.
- **Quote exactly.** Always include verbatim problematic text in findings, not paraphrase.
- **Cross-file analysis is required.** Findings span CLAUDE.md ↔ MEMORY.md ↔ memory/*.md.
- **Never auto-fix.** Surface findings first (Step 4); apply only on explicit user approval (Step 5).
- **Stub-pointer pattern is intentional**, not drift. [STUB-DRIFT] verifies body/index consistency, NOT that the body must restate the rule.
- **Intentional overrides exempt from [CONTRADICTION].** When CLAUDE.md documents the override (e.g., §Investigative Framings carves out from §Solution Quality / §Critical Rule), it's not a contradiction.
- **For [CONTRADICTION] findings: propose which source wins.** Don't just flag the conflict; recommend a resolution.
- **HIGH severity = real collaboration failures.** Reserve for genuine blockers, not style preferences.
- **Diff preview is mandatory for SEMANTIC fixes** — Step 5's preview-then-confirm flow is non-negotiable; semantic rewrites can drift from user intent without it.
- **Acknowledgment file controls suppression**, not deletion — suppressed findings are still detected, just not surfaced. To re-surface a finding, remove its line from `.claude/coherence-ack.md`.
- **Coordination with `/r-prune-claude`:** that skill runs scoped [BROKEN-REF] validation post-execute (its own deltas only). This skill runs the broad sweep + (in DEEP mode) all 10 categories.
- **Post-fix verification re-runs STRUCTURAL only** — re-running SEMANTIC checks would be expensive and rarely catches issues the fixes introduced.
