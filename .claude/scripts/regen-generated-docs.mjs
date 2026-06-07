#!/usr/bin/env node
// regen-generated-docs.mjs — deterministic r-end gate for `generated` docs.
//
// Conv 246 [DOCGEN]. Generated docs (route maps) are pure projections of code;
// they must never linger as "regenerate me" tasks. This gate re-runs each
// `generated` registry group's `regen.commands` whenever this conv's code
// changes touched any of its `regen.inputs` globs, then stages the output in
// both repos. Idempotent: when no input changed, it does nothing (so day-stamped
// generated docs like page-connections.md don't churn on doc-only convs).
//
// Source of truth for bindings: .claude/config.json docsRegistry.groups[*]
//   where category === 'generated' AND a `regen` object is present:
//     regen: { cwd: 'code'|'docs', commands: [...], inputs: [glob...], alsoWrites: [...] }
//
// Change set = code repo working-tree + committed changes since the drift
// baseline (.claude/.drift-baseline-sha; fallback HEAD~5), plus untracked files
// (new route pages not yet `git add`ed). Mirrors tech-doc-sweep.sh's baseline.
//
// Usage: node .claude/scripts/regen-generated-docs.mjs [--dry-run]
// Exit:  0 always (a regen failure is reported but non-fatal to r-end).

import { readFileSync, existsSync } from 'node:fs';
import { execSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const here = dirname(fileURLToPath(import.meta.url));
const DOCS_REPO = join(here, '..', '..');
const CODE_REPO = join(DOCS_REPO, '..', 'Peerloop');
const BASELINE_FILE = join(DOCS_REPO, '.claude', '.drift-baseline-sha');
const DRY_RUN = process.argv.includes('--dry-run');

const repoPath = (which) => (which === 'docs' ? DOCS_REPO : CODE_REPO);

// glob → RegExp (supports ** , * , and {a,b}); same semantics as docs-registry.mjs
function globToRegex(glob) {
  let s = glob.replace(/[.+^$()|[\]\\]/g, '\\$&');
  s = s.replace(/\{/g, '(').replace(/\}/g, ')').replace(/,/g, '|');
  s = s.replace(/\*\*/g, '@@GS@@').replace(/\*/g, '[^/]*').replace(/@@GS@@/g, '.*');
  return new RegExp('^' + s + '$');
}

function sh(cmd, cwd) {
  return execSync(cmd, { cwd, encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
}

// ── Code change set (committed-since-baseline + working tree + untracked) ──────
function codeChangeSet() {
  let baseline = '';
  if (existsSync(BASELINE_FILE)) baseline = readFileSync(BASELINE_FILE, 'utf8').trim();
  const files = new Set();
  const add = (out) => out.split('\n').map((l) => l.trim()).filter(Boolean).forEach((f) => files.add(f));
  try {
    const ref = baseline || 'HEAD~5';
    // `git diff --name-only <ref>` = working tree vs ref (committed-since + uncommitted edits)
    add(sh(`git diff --name-only ${ref}`, CODE_REPO));
    // untracked (new files not yet staged — e.g. a freshly created route page)
    add(sh('git ls-files --others --exclude-standard', CODE_REPO));
  } catch (e) {
    // If the baseline SHA is unreachable (e.g. shallow clone), fall back wide.
    try { add(sh('git diff --name-only HEAD~5', CODE_REPO)); } catch { /* give up quietly */ }
  }
  return [...files];
}

// ── Load generated groups with a regen binding ────────────────────────────────
function generatedRegenGroups() {
  const cfg = JSON.parse(readFileSync(join(DOCS_REPO, '.claude', 'config.json'), 'utf8'));
  const groups = cfg.docsRegistry?.groups ?? [];
  return groups.filter((g) => g.category === 'generated' && g.regen && Array.isArray(g.regen.commands));
}

function main() {
  const groups = generatedRegenGroups();
  if (groups.length === 0) {
    console.log('regen-generated-docs: no generated groups with a regen binding — nothing to do.');
    return;
  }

  const changed = codeChangeSet();
  const ran = [];
  const skipped = [];

  for (const g of groups) {
    const inputRes = (g.regen.inputs ?? []).map(globToRegex);
    const hits = changed.filter((f) => inputRes.some((re) => re.test(f)));
    if (hits.length === 0) {
      skipped.push(g.id);
      continue;
    }
    const cwd = repoPath(g.regen.cwd);
    console.log(`regen-generated-docs: [${g.id}] ${hits.length} input file(s) changed → regenerating`);
    if (DRY_RUN) { ran.push({ id: g.id, dryRun: true }); continue; }

    let ok = true;
    for (const cmd of g.regen.commands) {
      try {
        sh(cmd, cwd);
        console.log(`  ✅ ${cmd}`);
      } catch (e) {
        ok = false;
        console.log(`  🔴 FAILED: ${cmd}\n${(e.stdout || '') + (e.stderr || e.message || '')}`);
      }
    }

    // Stage the group's own output in BOTH repos so r-end's commit includes it
    // regardless of how r-end stages. (Route gen writes both repos.)
    if (ok) {
      const docsTargets = (g.docs ?? []).join(' ');
      if (docsTargets) try { sh(`git add ${docsTargets}`, DOCS_REPO); } catch { /* unstaged is fine */ }
      for (const codeFile of g.regen.alsoWrites ?? []) {
        try { sh(`git add ${codeFile}`, CODE_REPO); } catch { /* unstaged is fine */ }
      }
    }
    ran.push({ id: g.id, ok });
  }

  console.log('');
  if (ran.length === 0) {
    console.log(`✅ regen-generated-docs: no generated-doc inputs changed this conv (skipped: ${skipped.join(', ') || 'none'}). Nothing to regenerate.`);
  } else {
    const okIds = ran.filter((r) => r.ok !== false).map((r) => r.id);
    const failIds = ran.filter((r) => r.ok === false).map((r) => r.id);
    console.log(`✅ regen-generated-docs: regenerated [${okIds.join(', ')}]${failIds.length ? `  🔴 FAILED [${failIds.join(', ')}]` : ''}.`);
    console.log('   Output staged in both repos; r-end commit will include it.');
  }
}

main();
