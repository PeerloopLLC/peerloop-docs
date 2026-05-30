---
name: w-prim-candidates
description: Surface primitive candidates in a component — runs the prim-treewalk sensor for deterministic, clickable raw signals, then collapses them into a narrowed table naming the likely target primitive for each cluster.
argument-hint: "<component-path> [--include-shell]"
allowed-tools: Read, Bash, Glob, Grep, Write
---

# Primitive Candidates

Given one component (`.tsx` or `.astro`), report which raw markup should probably
become a vetted Matt primitive — as the **narrowed table** (cluster · line · why ·
likely primitive), not the raw sensor dump.

This skill is a **two-layer** tool, and the layering is the whole point:

1. **Deterministic sensor** — `scripts/prim-treewalk.ts` statically walks the
   component's import graph and emits candidates with clickable `path:line` +
   which signal fired (`interactive+chrome` / `loop-repeated` / `legacy-tokens`),
   already split into STRONG vs WEAK. This half never drifts.
2. **Agent narrowing** (this skill body) — collapses multi-line clusters into one
   logical candidate and names the **likely primitive** by matching root element +
   role + chrome against the registries. This half is model reasoning **today** —
   non-deterministic until `[PRIM-MATCH-INDEX]` lands (see Upgrade path). That is
   exactly why it lives in a skill body and not in the script.

See `docs/as-designed/matt-provenance.md §12` for what counts as a primitive
(a *named wrapped element/cluster*; a bare HTML element is substrate, not a
primitive).

---

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `<component-path>` | Yes | Path (repo-relative, in `../Peerloop`) to a single `.tsx` or `.astro` component, e.g. `src/components/onboarding/TopicPicker.tsx` |
| `--include-shell` | No | Also walk `@layouts/*` shared chrome (excluded by default) |

Read the path from the `ARGUMENTS:` line appended to this prompt — `$ARGUMENTS`
does **not** expand inside `!`-backticks in this project (Conv 206), so the sensor
runs as Step 1 of the body, not as a precompute.

---

## Execution

### Step 1 — Run the deterministic sensor

```bash
cd ~/projects/Peerloop && npm run prim:treewalk -- <component-path> [--include-shell]
```

Show the sensor's output **verbatim first** — those `path:line` tokens are the
user's Cmd+click targets. Note that candidates may live in **child** components of
the entry (the walk follows imports), each under its own clickable file header.

If the entry doesn't exist or the run errors, surface that and stop.

### Step 2 — Narrow into the table (the baked-in agent layer)

For every **STRONG** candidate the sensor reported, `Read` the flagged source
lines, then emit a markdown table:

| Cluster | Line(s) | Why flagged | Likely primitive |
|---|---|---|---|

Rules for building it:

- **Collapse clusters.** Multi-line raws that form one logical control become one
  row — e.g. a `<label>` + `<div> ⊃ <select>` + looped `<option>` is a single
  **Select / FormField** row citing all three lines; a `<label> ⊃ <input> ⊃ <span>`
  checkbox is one **Checkbox** row.
- **Name the likely primitive** by matching root rendered element + role + enclosing
  chrome against the two registries, preferring **matt-sourced > matt-inspired**:
  - `../Peerloop/scripts/matt-sourced-registry.generated.ts`
  - `../Peerloop/scripts/matt-inspired-registry.ts`
  When genuinely ambiguous (e.g. Input vs FormField vs PasswordInput), name the
  closest + note the alternative — don't force false precision.
- **Rescue real candidates from WEAK.** A styled leaf the sensor demoted (e.g. a
  `rounded-full bg-primary-500` count pill → **Badge / AnalyticCount**) is a true
  candidate even though only `legacy-tokens` fired — pull it into the table and mark
  it `(weak, but real)`.
- **List the true noise on one line**, not in the table — plain text spans, bare
  labels, layout `<div>`s that only tripped `legacy-tokens`. Cite their lines so
  the user can confirm, but keep them out of the candidate set.
- Every cluster cites a clickable `<file>:<line>`.

### Step 3 — Caveat line

End with one line: naming is agent-reasoning until `[PRIM-MATCH-INDEX]` exists;
the clickable lines + signals (Step 1) are deterministic.

### Step 4 — Persist the full output to `.scratch`

Terminal output scrolls off; persist the whole report (verbatim sensor block from
Step 1 + the narrowed table + noise line + caveat) to a `.scratch` markdown file so
it can be opened in VS Code and survives scrollback.

- **Filename reflects the argument and OVERWRITES on re-run** (same component →
  same file, so re-running after edits replaces the prior report). Derive the slug
  from the component path: drop the extension, strip a leading `src/`, replace `/`
  and any non-`[A-Za-z0-9._-]` char with `-`. e.g.
  `src/components/settings/StripeConnectSettings.tsx` →
  `.scratch/prim-candidates-components-settings-StripeConnectSettings.md`;
  `src/pages/profile/[...tab].astro` →
  `.scratch/prim-candidates-pages-profile-----tab-.md`.
- Path is repo-root-relative in the **docs** repo:
  `~/projects/peerloop-docs/.scratch/prim-candidates-<slug>.md`.
- `Write` (overwrite) the full report there. Top the file with a header line:
  `# Primitive candidates — <component-path>` so the open tab self-identifies.
- After writing, print one line to the terminal: the scratch path + the one-line
  summary (`N candidate(s) · M weak`), so the user knows where the full report
  landed without re-dumping it.

---

## Upgrade path — `[PRIM-MATCH-INDEX]`

When the per-primitive match index is built (root element + replaceable role/shape +
chrome signature per registry primitive, generated for the structural half +
annotated for the semantic half, with a `prov:sweep` consistency gate), **Step 2's
naming swaps from model reasoning to an index lookup** — same invocation, now
deterministic, auditable, and gateable. The collapse-and-name instructions above
become the index's matching rules. Tracked as task `[PRIM-MATCH-INDEX]`.

---

## Rules

- **Single component in, narrowed table out.** Don't run it across a whole tree —
  the sensor + this skill are tuned for the per-component view.
- **Preserve sensor determinism.** Never replace the Step 1 script with ad-hoc
  Grep/Read sensing — the script is the author-controlled data source; the skill
  body only narrows what it returns (see CLAUDE.md §Skills: Preserve `!` Backtick
  Determinism).
- **Surface, don't auto-fix.** This skill nominates candidates for the user to
  confirm against the rendered screen; it does not edit components.
