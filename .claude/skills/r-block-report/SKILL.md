---
name: r-block-report
description: Billing roll-up over the Peerloop vault coding-timecard notes, filtered by Bill?/Block code, emitted as a .scratch markdown report + a .scratch .tsv. Deterministic — the script owns all parsing, Hours math (from the authoritative Billable field), filter, sort, and render; nothing enters context. Ported from the SPT r-block-report, adjusted for Peerloop's coding-timecard schema.
argument-hint: "[BLOCK] (default: billing.currentCode, e.g. Block-09) | --all | --sort asc|desc"
---

# Block Report (/r-block-report)

Generates a client-billing roll-up over the coding-timecard notes that `/r-timecard-day` writes to the Obsidian vault (`_timecards/PEERLOOP/`), scoped by **Block / invoice code** (the `Bill?` field). It writes two files to `.scratch/`:

- a **markdown report** (table + total billable hours), for in-repo review, and
- a **.tsv** export, for manual merge in Google Sheets.

**Why this exists:** the Peerloop coding timecards are standalone vault notes, not Daily-Note entries, so the in-Obsidian time-report Dataview never sees them — they need their own headless export path. This skill is the report side; `/r-timecard-day` is the create side.

All parsing / filtering / Hours / sorting / rendering lives in the sidecar `.claude/scripts/block-report.js` (per the single-skill determinism pattern). This SKILL is a **thin front end**: it runs the script and relays the summary + file paths. There is no LLM synthesis step — every run is pure passthrough.

**Shared config:** `.claude/config.json → rBlockReport` (columns, projectLabel, scratchDir) + `rTimecardDay.vaultPath` (source folder) + `billing.currentCode` (default Block code).

**Peerloop adjustments vs the SPT original:**
- Source folder comes from `rTimecardDay.vaultPath` (Peerloop's key; SPT used `outputDir`).
- Peerloop coding cards carry `Focus / Start / End / Adjust / Billable / Bill? / Convs / Blocks` — no Channel/Who/Via/Slack. Default columns: `Date, Focus, Start, End, Adjust, Hours, Bill?, Convs, Blocks`.
- **`Hours` is derived from the `Billable` field** (the slot-rounded, overflow-capped billing time, e.g. `7h10`), not a naive End−Start+Adjust recompute — falling back to the computed value only when a card has no `Billable`.

---

## Arguments

- `[BLOCK]` — the `Bill?` value to filter on (e.g. `Block-09`). Exact, case-insensitive match. Defaults to `billing.currentCode` when omitted.
- `--sort asc|desc` — date order. Default `asc` (oldest first).
- `--all` — ignore the Block filter (every coding timecard, regardless of `Bill?`).
- `--source DIR` / `--out-dir DIR` — override the source vault folder / scratch output dir (rarely needed).

Examples: `/r-block-report` (→ Block-09, asc) · `/r-block-report Block-08 --sort desc` · `/r-block-report --all`.

---

## Workflow

### Step 1 — Run the report script

Pass the user's argument(s) straight through:

```bash
node ~/projects/peerloop-docs/.claude/scripts/block-report.js <args>
```

The script scans the vault timecard folder, filters by `Bill?`, computes `Hours` from each card's `Billable` field (fallback: `Start`/`End`/`Adjust`), sorts by date, drops empty columns, and writes `block-report-<BLOCK> • <MMM-DD-YYYY HH_mm>.{md,tsv}` to `.scratch/`. It reports a one-line summary on **stderr** (count · Block · total hours · surviving columns) and echoes the two absolute file paths on **stdout**.

Interpret the signals:
- Normal exit (`0`) → relay the summary line and the two paths.
- Exit `4` (`no timecards match …`) → tell the user nothing matched that `Bill?` value; suggest `--all` or a different Block code.
- Exit `1` (usage/config error, e.g. unreadable source dir) → surface the stderr verbatim and stop.

### Step 2 — Report

Tell the user the **total billable hours**, the **timecard count**, the **columns emitted** (so they know which columns survived the empty-drop), and the **two `.scratch/` paths** (markdown + tsv). Note that the TSV is ready to open / merge in Google Sheets.

---

## Rules

- **The script owns everything.** Don't reimplement parsing, Hours math, filtering, or rendering in the skill — pass args through and read its output.
- **Stay lean.** The deterministic render never needs to enter context; relay the stderr summary + stdout paths, don't read the generated files unless the user asks to inspect them.
- **`Billable` is the source of truth for Hours.** The Peerloop timecard-day script already slot-rounds and overflow-caps that field; don't second-guess it. Changes to columns or Hours sourcing belong in `block-report.js` + `config.json → rBlockReport`, not here.
- **Scratch output only.** Files land in `.scratch/` (gitignored). This skill never writes to the vault or commits anything.
