---
name: r-prune-memory
description: Keep MEMORY.md under the SessionStart auto-load cap by re-flattening bloated index pointer-lines and extracting inline-only entries into subsidiary memory files
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Prune MEMORY.md

Keep the auto-memory **index** (`MEMORY.md`) under its SessionStart auto-load cap. Per `code.claude.com/docs/en/memory.md`, only the **first 200 lines / 25 KB** of MEMORY.md load at the start of every conversation — past that, the *tail* (the most recent memories) silently stops loading. This skill brings MEMORY.md back under the cap **without losing any memory content**.

**This is NOT `/r-prune-claude`.** That skill prunes `CLAUDE.md` (project instructions, repo root) into `docs/reference/CLAUDE-OFFLOAD.md`. This skill prunes `MEMORY.md` (the auto-memory index in `~/.claude/projects/<slug>/memory/`) into its sibling `memory/*.md` sub-files. Different file, different cap mechanics (CLAUDE.md = always-in-context performance cost, no hard limit; MEMORY.md = hard SessionStart truncation).

**Display-label convention (Conv 213).** A pointer is `- [link](real_filename.md) — distinctive hook`. The display label is the **constant string `link`** — NOT the filename. Echoing the filename as the label (`[real_filename.md](real_filename.md)`) duplicates it for zero benefit: tooling (`/r-coherence-check`, this skill's integrity check) keys only on the `](file.md)` target, and the filename is still visible in that target. Across ~70 pointers the filename-echo wasted ~2.3 KB (~9% of the cap). The scannable meaning lives in the `## ` section header + the hook after `—`, not the label. (The global memory-writing instruction shows `[Title](file.md)`; auto-saved entries may re-introduce a filename or title label — Step 3 normalizes any `[anything](file.md)` back to `[link](file.md)` whenever it touches a line, and the standalone title-sweep below does it in bulk.)

**Three prune operations** (try them cheapest-first: c → b → a):

- **(c) Normalize display labels → `[link]`.** The cheapest, zero-risk, highest-ROI lever. Bulk-rewrite every `[<anything>.md](<file>.md)` (filename-echo titles) → `[link](<file>.md)`, targets untouched. No file changes, no detail moves, tooling-safe. One sed pass: `sed -E 's/\[[a-z0-9_-]+\.md\]\(([a-z0-9_-]+\.md)\)/[link](\1)/g'`. Do this FIRST — it often frees enough alone.
- **(b) Re-flatten a bloated pointer line.** A healthy entry is `- [link](name.md) — short distinctive hook`. Over many convs these hooks grow into multi-sentence paragraphs. The sub-file already exists; move any unique detail *into the sub-file* and trim the index line back to a true one-liner (keeping its distinctive markers). A single bloated pointer can be 500–1000 bytes.
- **(a) Extract an inline-only entry.** Some entries carry their whole content inline with no sub-file at all (e.g. the Icon System block). Create a new sub-file with proper frontmatter, move the content, leave a short `[link](new_file.md)` pointer.

---

## Pre-computed Context

**Paths (live memory dir; home expands per-machine so this is portable):**
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); echo "slug=$SLUG"; echo "live=~/.claude/projects/$SLUG/memory"`

**MEMORY.md utilization vs cap (200 lines / 25600 bytes):**
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); MEM=~/.claude/projects/$SLUG/memory/MEMORY.md; if [ -f "$MEM" ]; then L=$(wc -l < "$MEM" | tr -d ' '); B=$(wc -c < "$MEM" | tr -d ' '); awk -v l=$L -v b=$B 'BEGIN{ lp=l/200*100; bp=b/25600*100; printf "lines: %d/200 (%.0f%%)\nbytes: %d/25600 (%.0f%%)\nbinding dimension: %s\n", l, lp, b, bp, (bp>=lp?"BYTES":"LINES") }'; else echo "(MEMORY.md not found)"; fi`

**Top 15 fattest lines (bytes — line#).** NOTE: awk uses bare `length` / implicit `/regex/` match — NEVER `$0`/`$N`, because the skill bang-backtick executor expands `$`-tokens even inside single quotes (`$0`→empty breaks awk). Line previews come from reading MEMORY.md in Step 1a, not here.
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); MEM=~/.claude/projects/$SLUG/memory/MEMORY.md; [ -f "$MEM" ] && LC_ALL=C awk '{ print length"\t"NR }' "$MEM" | LC_ALL=C sort -rn | head -15`

**Bloated pointer lines (have a `](file.md)` sub-file, line >250 bytes → candidates for re-flatten (b)) — bytes — line#:**
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); MEM=~/.claude/projects/$SLUG/memory/MEMORY.md; [ -f "$MEM" ] && LC_ALL=C awk 'length>250 && /\]\([a-z0-9_-]+\.md\)/ { print length"\t"NR }' "$MEM" | LC_ALL=C sort -rn`

**Inline-only entries (no sub-file pointer, line >200 bytes → candidates for extract (a)) — bytes — line#:**
!`SLUG=$(echo ~/projects/peerloop-docs | tr / -); MEM=~/.claude/projects/$SLUG/memory/MEMORY.md; [ -f "$MEM" ] && LC_ALL=C awk 'length>200 && !/\]\([a-z0-9_-]+\.md\)/ { print length"\t"NR }' "$MEM" | LC_ALL=C sort -rn`

**Distinctive markers that MUST survive a trim (from config coherenceCheck.markers):**
!`cat ~/projects/peerloop-docs/.claude/config.json 2>/dev/null | python3 -c "import json,sys; print(', '.join(json.load(sys.stdin).get('coherenceCheck',{}).get('markers',[])))" 2>/dev/null || echo "(none)"`

---

## Thresholds & Paths

Use values from config.json `thresholds.memoryMd`. If missing, defaults: `warnPct=80`, `targetPct=70`, `capLines=200`, `capBytes=25600`.

- **warnPct** — the utilization (% of either cap dimension) at which `/r-start`'s cap-check alerts. This skill is the remedy for that alert.
- **targetPct** — prune until BOTH dimensions are at or below this (headroom so the alert doesn't re-fire next conv).
- **caps** — the platform constants (`200 lines / 25 KB`); not project preferences. Do not raise them.

**MEMORY.md path:** `~/.claude/projects/<slug>/memory/MEMORY.md` where `<slug>` is the pre-computed value above. Sub-files are siblings in the same dir.

**Operates on the LIVE memory dir.** Edits here are carried into the repo mirror (`.claude/memory-sync/memories/`) by the live→mirror sync at the next `/r-end`/`/r-commit`. Do NOT hand-edit the mirror — that would invert the sync direction. (See `memory/feedback_msi_sync_user_checkpoint.md`.)

---

## Step 0: Quick Check

Use the pre-computed utilization:

- **Both dimensions below `warnPct`** → Report "MEMORY.md is healthy ([L] lines [lp]%, [B] bytes [bp]%). Below warn threshold [warnPct]%. No prune needed." and stop.
- **Otherwise** → Proceed to Step 1. Note the **binding dimension** (usually BYTES — long lines bloat bytes faster than they add lines).

---

## Step 1: Dry Run (ALWAYS DO THIS FIRST)

### 1a. Classify each fat line

Read MEMORY.md fully. Walk the pre-computed fat-line lists and classify each:

- **(c) Normalize label** — line's display label is anything other than `[link]` (most commonly a filename-echo `[file.md](file.md)`). Always applicable, zero-risk; run the bulk sed first (see operation (c) above) before assessing (b)/(a). Targets are preserved, so this never needs per-line confirmation beyond the batch gate.
- **(b) Re-flatten** — line has a `](file.md)` pointer AND the summary has grown past a one-liner. Plan: (i) confirm the sub-file exists; (ii) identify any detail in the index line that is NOT already in the sub-file body; (iii) the trimmed one-liner must retain the entry's **distinctive hook** — searchable markers/triggers/anti-patterns (`👉👉👉`, `A) B) C)`, `tee /tmp/...`, command snippets), NOT just a topic label (per `memory/feedback_memory_index_load_bearing.md`).
- **(a) Extract** — line/block is inline-only (no pointer). Plan: new sub-file name (kebab-case, matching the existing `feedback_*` / `project_*` / `reference_*` naming convention by content type), frontmatter `type` (`user`/`feedback`/`project`/`reference`), the content to move, and the short replacement pointer line.
- **Keep** — section headers (`## `), already-short pointer lines, and any entry whose full value is its inline brevity.

**When in doubt, prefer (b) re-flatten over (a) extract** — re-flattening is non-destructive (detail already has a home) and is where the bytes are.

### 1b. Target check

Sum projected byte/line savings. Project post-prune utilization. If it does not bring BOTH dimensions ≤ `targetPct`, add more lines to the prune list (next-fattest) until it does. If the list is exhausted before reaching target, note it and proceed with what's available.

**Estimate honestly — mind the pointer floor.** With the `[link]` label convention, a re-flattened line keeps a fixed prefix `- [link](filename.md) — ` ≈ `50 + len(filename)` bytes PLUS the retained hook (~80–180B). So a realistic trimmed line is **~150–230B**, and net savings ≈ `original − ~190`, NOT `original − hook`. A 380B line saves only ~190B. Re-flattening has diminishing returns below ~350B originals; the big wins are the 500B+ lines. Operation (c) label-normalization is the exception — it has no per-line hook floor and reliably frees ~`(len(filename)−4)` bytes per line across ALL pointers at once, which is usually the single biggest lever. Order: do (c) first, re-measure, then add (b)/(a) only if still above target. Clearing `warnPct` with margin is the actual goal; `targetPct` is headroom, not a hard requirement.

### 1c. Present dry-run results

```
MEMORY.md Prune Proposal
──────────────────────────────────
Current: [L] lines ([lp]%) | [B] bytes ([bp]%)  ·  binding: [BYTES/LINES]
Caps: 200 lines / 25600 bytes  ·  warn [warnPct]%  target [targetPct]%

(b) Re-flatten bloated pointers → sub-file already holds detail:
   line 110  [SETTINGS-GUARD]  1021B → ~120B  (saves ~900B)
       detail to move into project_settings_tier_local_control.md: [what, or "already present — pure trim"]
       trimmed hook keeps: [distinctive markers retained]
   ...

(a) Extract inline-only entries → NEW sub-file:
   line 11-12  Icon System  ~1035B → ~140B  (saves ~895B)
       → new file: reference_icon_system.md (type: reference)
   ...

Keep (unchanged): [count] short pointers + [n] section headers

Projected: [L'] lines ([lp']%) | [B'] bytes ([bp']%)
Target check: [OK — both ≤ targetPct  /  partial — best achievable is X%]
──────────────────────────────────
```

---

## Step 2: Assess & Confirm (REQUIRED before any write)

This skill is investigative-then-mutating: the user cannot anticipate which lines are fattest until the dry run surfaces them (per CLAUDE.md §Investigative Framings). Present the proposal, then a single batch gate:

```
👉👉👉 **OK to apply these N changes? (yes / no)**
```

Do NOT proceed to Step 3 without explicit confirmation. The user may pare the list (e.g. "keep the Icon System inline, do the rest").

---

## Step 3: Execute Changes

After confirmation:

0. **(c) Normalize labels (do first):** one sed pass over MEMORY.md — `sed -E 's/\[[a-z0-9_-]+\.md\]\(([a-z0-9_-]+\.md)\)/[link](\1)/g'` — rewrites every filename-echo display label to `[link]`, targets preserved. Re-measure before doing (b)/(a).

Then per planned line:

1. **(b) Re-flatten:**
   - If the index line carried unique detail not in the sub-file: append it to the sub-file body (preserve frontmatter; add under an appropriate heading or as a new `**Conv N:**` note) BEFORE trimming the index line. **Detail must land in the sub-file before it leaves MEMORY.md** — never trim first.
   - Replace the MEMORY.md line with the short hook (`- [link](name.md) — <distinctive one-liner>`, label = constant `link`), retaining the markers/triggers identified in 1a.

2. **(a) Extract:**
   - `Write` the new sub-file with frontmatter (`name`, `description`, `metadata.type`) and the moved content. Link related memories with `[[name]]` where natural.
   - Replace the inline block in MEMORY.md with a single `- [link](new_file.md) — hook` pointer under its existing `## ` section.

3. Leave all `## ` section headers intact (scannability).

---

## Step 4: Post-Execute Integrity (runs after every prune)

1. **Recompute utilization** — re-`wc` MEMORY.md; confirm both dimensions ≤ `targetPct` (or report the best achieved).
2. **Distinctive-hook check** (per `memory/feedback_memory_index_load_bearing.md`) — for each trimmed line, verify the retained hook still exposes a distinctive marker/trigger/anti-pattern, not a bare topic label. 🔴 alert any that flattened to a label-only line.
3. **Pointer integrity** — every `](file.md)` in MEMORY.md must resolve to an existing sibling file; every newly-created sub-file must be linked from exactly one MEMORY.md line. 🔴 alert dangling pointers or orphaned files:
   ```
   🔴 Pointer rot: MEMORY.md line N → {file}.md does not exist.
   🔴 Orphan: {file}.md created but no MEMORY.md line points to it.
   ```
4. **Detail-preservation spot check** — for each (b) re-flatten, confirm the detail removed from the index line is present in the sub-file (grep a distinctive phrase). 🔴 alert any lost detail.

After validation, always emit:
```
ℹ️  For the broader cross-file sweep (overlap, stub-pointer integrity, orphan rules
   across ALL memories), run /r-coherence-check.
```

---

## Step 5: Report

```
MEMORY.md Pruned

Re-flattened (b): [n] pointer lines  ([list with byte deltas])
Extracted (a):    [n] new sub-files  ([list])

Before: [L] lines ([lp]%) / [B] bytes ([bp]%)
After:  [L'] lines ([lp']%) / [B'] bytes ([bp']%)   ·  binding now [bp'/lp']%
Integrity: distinctive hooks OK · pointers OK · detail preserved
[🔴 alerts if any from Step 4]

Edits are in the LIVE memory dir; the next /r-end syncs them to the repo mirror.

ℹ️  For broader coherence (overlap, stub-pointer integrity, orphan rules),
   run /r-coherence-check.
```

---

## Rules

- **ALWAYS dry-run + surface dispositions before any write** (Step 1 → Step 2 gate). The user can't anticipate which lines are fattest.
- **Never lose memory content.** For (b), the detail must exist in the sub-file BEFORE the index line is trimmed. For (a), the new sub-file must be written BEFORE the inline block is replaced.
- **Preserve distinctive index hooks** — a trimmed line keeps its searchable markers/triggers/anti-patterns, never collapses to a topic label (`memory/feedback_memory_index_load_bearing.md`).
- **Caps are platform constants** (200 lines / 25 KB) — prune to get under them; never "raise the cap."
- **Operate on the LIVE memory dir only** — the /r-end live→mirror sync carries changes to the repo. Never hand-edit the mirror.
- **Keep `## ` section headers** for scannability.
- **Display label is the constant `[link]`** (Conv 213) — never echo the filename as the label. The filename lives in the `](file.md)` target; tooling keys on the target, not the label. Normalize any non-`[link]` label whenever a line is touched (operation (c)). Do NOT rename the sub-files themselves — file renames risk dangling references across CLAUDE.md / docs / `[[wikilinks]]`; only the in-`MEMORY.md` display label changes.
- **Step 4 integrity validation runs after every prune** — broader cross-memory coherence is `/r-coherence-check`'s job.
