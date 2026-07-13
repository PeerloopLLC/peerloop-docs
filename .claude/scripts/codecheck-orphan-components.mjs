#!/usr/bin/env node
// Orphaned page-component detector for /w-codecheck.
//
// Why: Astro routes live in src/pages/**; a component in src/components/** is
// only ever rendered if it is transitively imported from some route. When a
// route migration deletes PAGES but leaves the COMPONENTS they rendered, those
// components become dead code that every other check still passes — tsc/lint/
// astro-check/build stay green (Vite tree-shakes unmounted code away) and unit
// tests keep passing (tests import components directly, bypassing routing).
// This exact gap orphaned the whole course-detail family when /old routing was
// retired (Conv 339); a Conv-391 grep-driven copy sweep then edited 4 of those
// dead components thinking the changes were user-visible. Caught + purged in
// Conv 392 ([ORPHAN-PURGE]); this script is the systemic guard ([ORPHAN-DETECT]).
// See memory/feedback_orphaned_components_survive_migration.md.
//
// Algorithm: build the import graph over src/**, BFS from every file under
// src/pages/** (the routes), then report any src/components/** .tsx/.astro file
// the BFS never reached. Type-only and re-export imports count as edges (a file
// referenced only as a type is still "wired in" — we want ZERO-reference dead
// code, the shape the incident took), so false positives stay low.
//
// Baseline allowlist: KNOWN_ORPHANS holds components intentionally kept unwired
// (documented, pending their own cleanup). New orphans outside the list fail.

import fs from 'node:fs';
import path from 'node:path';

const REPO = process.cwd();
const SRC = path.join(REPO, 'src');
if (!fs.existsSync(SRC)) {
  console.error('codecheck-orphan-components: cannot find ./src — run from the code repo root.');
  process.exit(2);
}

// tsconfig path aliases (code repo). Bare specifiers (node_modules) are ignored.
const ALIASES = {
  '@/': 'src/',
  '@components/': 'src/components/',
  '@layouts/': 'src/layouts/',
  '@lib/': 'src/lib/',
  '@services/': 'src/services/',
  '@data/': 'src/data/',
  '@emails/': 'src/emails/',
};

const EXTS = ['.ts', '.tsx', '.astro', '.js', '.jsx', '.mjs'];

// Components deliberately left unwired (each needs its own follow-up). Keep this
// list SHORT and documented — it is an escape hatch, not a dumping ground.
const KNOWN_ORPHANS = new Set([
  // [ORPHAN-PURGE] residual, Conv 392: AdminCourseTab was only mounted by the
  // deleted ExploreCourseTabs. Left in place (separate admin-intel subsystem);
  // remove or re-home when admin-intel course tabs are revisited.
  'src/components/admin-intel/AdminCourseTab.tsx',
]);

function walk(dir, acc = []) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p, acc);
    else if (EXTS.includes(path.extname(e.name))) acc.push(p);
  }
  return acc;
}
const allFiles = walk(SRC);

function resolveSpec(spec, fromFile) {
  let base = null;
  if (spec.startsWith('.')) {
    base = path.resolve(path.dirname(fromFile), spec);
  } else {
    for (const [ali, target] of Object.entries(ALIASES)) {
      if (spec.startsWith(ali)) { base = path.join(REPO, target, spec.slice(ali.length)); break; }
      if (spec === ali.slice(0, -1)) { base = path.join(REPO, target); break; }
    }
    if (!base) return null; // bare module — not our code
  }
  if (fs.existsSync(base) && fs.statSync(base).isFile()) return base;
  for (const ext of EXTS) if (fs.existsSync(base + ext)) return base + ext;
  for (const ext of EXTS) {
    const idx = path.join(base, 'index' + ext);
    if (fs.existsSync(idx)) return idx;
  }
  return null;
}

// import X from '...'; import '...'; import('...'); export ... from '...'
const IMPORT_RE = /(?:import|export)\b[^'"();]*?\bfrom\s*['"]([^'"]+)['"]|\bimport\s*['"]([^'"]+)['"]|\bimport\s*\(\s*['"]([^'"]+)['"]\s*\)/g;
const importCache = new Map();
function importsOf(file) {
  if (importCache.has(file)) return importCache.get(file);
  const src = fs.readFileSync(file, 'utf8');
  const out = [];
  let m;
  IMPORT_RE.lastIndex = 0;
  while ((m = IMPORT_RE.exec(src))) {
    const spec = m[1] || m[2] || m[3];
    const resolved = resolveSpec(spec, file);
    if (resolved) out.push(resolved);
  }
  importCache.set(file, out);
  return out;
}

const pagesDir = path.join(SRC, 'pages') + path.sep;
const roots = allFiles.filter((f) => f.startsWith(pagesDir));

const reachable = new Set();
const queue = [...roots];
while (queue.length) {
  const f = queue.pop();
  if (reachable.has(f)) continue;
  reachable.add(f);
  for (const dep of importsOf(f)) if (!reachable.has(dep)) queue.push(dep);
}

const componentsDir = path.join(SRC, 'components') + path.sep;
const isComponent = (f) => f.startsWith(componentsDir) && /\.(tsx|astro)$/.test(f);

const orphans = allFiles
  .filter((f) => isComponent(f) && !reachable.has(f))
  .map((f) => path.relative(REPO, f))
  .sort();

const unexpected = orphans.filter((f) => !KNOWN_ORPHANS.has(f));
const knownHit = orphans.filter((f) => KNOWN_ORPHANS.has(f));

if (unexpected.length === 0) {
  console.log(
    `PASS — every src/components/** component is route-reachable` +
      (knownHit.length ? ` (${knownHit.length} known/allowlisted orphan${knownHit.length > 1 ? 's' : ''} ignored).` : '.')
  );
  process.exit(0);
}

console.log(`${unexpected.length} orphaned component(s) — rendered by no route under src/pages/**:`);
for (const o of unexpected) console.log('  ' + o);
console.log(
  '\nEach is dead code (edits to it are invisible to users). Re-home it onto a live\n' +
    'route, delete it, or — if intentionally kept — add it to KNOWN_ORPHANS in\n' +
    '.claude/scripts/codecheck-orphan-components.mjs with a reason.'
);
process.exit(1);
