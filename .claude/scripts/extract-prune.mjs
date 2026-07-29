#!/usr/bin/env node
// extract-prune.mjs — deterministic Step-4b prune for the /r-end Extract.
//
// Spec: .claude/skills/r-end/SKILL.md Step 4b. Task: [PRUNESAFE] (Conv 430).
//
// WHY THIS IS A SCRIPT AND NOT AN INSTRUCTION
//
// Step 4b used to be prose: "remove each line the manifest lists". The manifest is
// appended by the learn-decide subagent under the instruction "only record lines
// whose content you actually copied — not lines you merely read for context." That
// safeguard is an agent's self-report about its own copying, which is exactly the
// kind of judgment that drifts. In Conv 429 it recorded 140 lines, many merely
// referenced, and the prune faithfully honoured all of them: §Prompts & Actions
// lost narrative, §Completed went from 8 items to 1, §Open Questions and
// §New Patterns were emptied. The Extract is the primary conv record ("No Dev.md —
// the Extract replaces it"), so that is content loss, not deduplication.
//
// The fix is structural, not another instruction: only lines inside the §Learnings
// and §Decisions bodies are eligible, computed HERE from the Extract's own heading
// positions. A manifest line outside those spans is ignored by construction, no
// matter what the agent reports. The agent can still be wrong about WHICH learnings
// it copied; it can no longer reach any other section.
//
// Usage:
//   extract-prune.mjs <extract-path> <manifest-path> [--dry-run]
//
// Exit codes: 0 ok (or nothing to do), 1 bad invocation, 2 unreadable/unparseable
// input, 3 refused (safety belt tripped — Extract left untouched).

import { readFileSync, writeFileSync, existsSync } from 'node:fs';
import { basename } from 'node:path';

// Sections whose bodies may be pruned, and the pointer left behind when a body is
// emptied. Everything not listed here is unreachable by the prune.
const PRUNABLE = [
  { heading: '## Learnings', sibling: 'Learnings.md' },
  { heading: '## Decisions', sibling: 'Decisions.md' },
];

// Second belt. The span restriction already bounds the damage, but a manifest that
// would erase an entire section's body AND leave nothing to point at is more likely
// a runaway than a real full-consumption. Tunable; deliberately generous.
const MAX_PRUNE_FRACTION = 0.5;

function fail(code, msg) {
  console.error(`extract-prune: ${msg}`);
  process.exit(code);
}

const args = process.argv.slice(2);
const dryRun = args.includes('--dry-run');
const [extractPath, manifestPath] = args.filter((a) => !a.startsWith('--'));

if (!extractPath || !manifestPath) {
  fail(1, 'usage: extract-prune.mjs <extract-path> <manifest-path> [--dry-run]');
}
if (!existsSync(extractPath)) fail(2, `Extract not found: ${extractPath}`);

// A missing or empty manifest is normal — the agent consumed nothing.
if (!existsSync(manifestPath)) {
  console.log('extract-prune: no manifest — nothing to prune.');
  process.exit(0);
}

const lines = readFileSync(extractPath, 'utf8').split('\n'); // 0-indexed here, 1-indexed in the manifest
const manifest = [
  ...new Set(
    readFileSync(manifestPath, 'utf8')
      .split('\n')
      .map((l) => l.trim())
      .filter((l) => /^\d+$/.test(l))
      .map(Number)
  ),
];

if (manifest.length === 0) {
  console.log('extract-prune: manifest empty — nothing to prune.');
  process.exit(0);
}

// ── Compute the prunable spans from the Extract's own structure ──────────────
// A section body runs from just after its heading to just before the next H2.
// `###` subsections belong to the body; only `## ` closes it. The heading line
// itself is never eligible — the pointer needs somewhere to live.
const isH2 = (l) => /^## /.test(l);

const spans = [];
for (const { heading, sibling } of PRUNABLE) {
  const idx = lines.findIndex((l) => l.trimEnd() === heading);
  if (idx === -1) continue; // section absent from this Extract — fine, skip it
  let end = lines.length; // exclusive, 0-indexed
  for (let i = idx + 1; i < lines.length; i++) {
    if (isH2(lines[i])) { end = i; break; }
  }
  spans.push({ heading, sibling, headingIdx: idx, bodyStart: idx + 1, bodyEnd: end });
}

if (spans.length === 0) {
  fail(2, `no prunable sections found (looked for: ${PRUNABLE.map((p) => p.heading).join(', ')})`);
}

const inSpan = (lineNo1) => {
  const i = lineNo1 - 1;
  return spans.some((s) => i >= s.bodyStart && i < s.bodyEnd);
};

const eligible = manifest.filter(inSpan).sort((a, b) => a - b);
const ignored = manifest.filter((n) => !inSpan(n)).sort((a, b) => a - b);

// ── Safety belt ──────────────────────────────────────────────────────────────
const fraction = eligible.length / Math.max(lines.length, 1);
if (fraction > MAX_PRUNE_FRACTION) {
  console.error(
    `extract-prune: REFUSED — manifest would delete ${eligible.length}/${lines.length} lines ` +
    `(${(fraction * 100).toFixed(0)}% > ${MAX_PRUNE_FRACTION * 100}%). Extract left untouched.`
  );
  process.exit(3);
}

// ── Report before acting ─────────────────────────────────────────────────────
console.log(`extract-prune: ${basename(extractPath)}`);
console.log(`  manifest lines      : ${manifest.length}`);
console.log(`  eligible (in-span)  : ${eligible.length}`);
console.log(`  IGNORED (out-of-span): ${ignored.length}${ignored.length ? ` → ${ignored.join(', ')}` : ''}`);
for (const s of spans) {
  console.log(`  span ${s.heading.padEnd(14)}: lines ${s.bodyStart + 1}–${s.bodyEnd}`);
}
if (ignored.length > 0) {
  // Loud, not silent: a large ignored count is the Conv-429 signature and is worth
  // seeing even though it is now harmless.
  console.log(
    `  ⚠️  ${ignored.length} manifest line(s) fell outside §Learnings/§Decisions and were ignored ` +
    `— the agent recorded lines it read rather than copied. Harmless; see [PRUNESAFE].`
  );
}

if (dryRun) {
  console.log('  (dry run — no changes written)');
  process.exit(0);
}

// ── Prune, descending so earlier indices stay valid ──────────────────────────
const doomed = new Set(eligible.map((n) => n - 1));
let out = lines.filter((_, i) => !doomed.has(i));

// ── Leave a pointer where a body was emptied ─────────────────────────────────
// Recompute positions against the pruned output; spans have shifted.
const extractBase = basename(extractPath).replace(/Extract\.md$/, '');
let pointered = 0;
for (const { heading, sibling } of PRUNABLE) {
  const idx = out.findIndex((l) => l.trimEnd() === heading);
  if (idx === -1) continue;
  let end = out.length;
  for (let i = idx + 1; i < out.length; i++) {
    if (isH2(out[i])) { end = i; break; }
  }
  const body = out.slice(idx + 1, end);
  if (body.every((l) => l.trim() === '')) {
    out = [...out.slice(0, idx + 1), '', `→ See \`${extractBase}${sibling}\``, '', ...out.slice(end)];
    pointered++;
  }
}

writeFileSync(extractPath, out.join('\n'));
console.log(`  deleted             : ${eligible.length} line(s)`);
console.log(`  pointers inserted   : ${pointered}`);
console.log(`  ${lines.length} → ${out.length} lines`);
