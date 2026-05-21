#!/usr/bin/env node
// Schema-aware deleted_at lint for /w-codecheck (Check 8).
//
// Why: Only 4 Peerloop tables have a deleted_at column (users, progressions,
// courses, enrollments). Other tables use is_archived or have no soft-delete.
// A query filtering deleted_at against a table that lacks the column silently
// returns wrong results (NULL = NULL = always-true) or 500s at runtime
// (D1_ERROR: no such column). Discovered in Conv 117 (communities endpoint).
//
// Heuristic: for each SQL template literal containing deleted_at:
//   1. Parse FROM / JOIN / INTO / UPDATE → alias-to-table map.
//   2. For each qualified <token>.deleted_at: resolve token via the alias map
//      (or treat as a table name) and flag if the resolved table lacks
//      deleted_at.
//   3. For each unqualified deleted_at: flag only if NONE of the FROM/JOIN
//      tables in scope have the column. If at least one does, the SQL
//      resolves there (or would be a SQL-level ambiguity error) — silent.
//
// History: v1 (Conv 117–166) fired on "table name appears in same block as
// the literal string 'deleted_at'" — produced 90 false positives across 18
// tables on a clean codebase (Conv 167). v2 (Conv 168) replaces with the
// alias-aware algorithm above. Calibration logged in scratch file
// cck-da-v2-test.mjs (Conv 117 fixture + 5 counter-examples + live-codebase
// run all pass).

import fs from 'node:fs';
import path from 'node:path';
import { execSync } from 'node:child_process';

const REPO = process.cwd();
const SCHEMA = path.join(REPO, 'migrations/0001_schema.sql');

if (!fs.existsSync(SCHEMA)) {
  console.error(`codecheck-deleted-at: cannot find ${SCHEMA} — run from the code repo root.`);
  process.exit(2);
}

const schema = fs.readFileSync(SCHEMA, 'utf8');
const withDA = new Set();
const withoutDA = new Set();
for (const block of schema.split(/\nCREATE /)) {
  const m = block.match(/^TABLE IF NOT EXISTS (\w+)/);
  if (!m) continue;
  (block.includes('deleted_at') ? withDA : withoutDA).add(m[1]);
}
const allTables = new Set([...withDA, ...withoutDA]);

const SQL_KEYWORDS = new Set([
  'ON','WHERE','SET','VALUES','AS','LEFT','RIGHT','INNER','OUTER','CROSS','NATURAL',
  'USING','ORDER','GROUP','HAVING','LIMIT','OFFSET','RETURNING','SELECT',
  'INSERT','UPDATE','DELETE','FROM','JOIN','INTO','AND','OR','NOT','NULL','IS',
  'WITH','UNION','EXCEPT','INTERSECT'
]);

function analyzeBlock(block) {
  const aliasToTable = {};
  const referencedTables = new Set();
  const tableRE = /\b(?:FROM|JOIN|INTO|UPDATE)\s+(\w+)(?:\s+(?:AS\s+)?(\w+))?/gi;
  let m;
  while ((m = tableRE.exec(block)) !== null) {
    const [, table, alias] = m;
    if (!allTables.has(table)) continue;
    aliasToTable[table] = table;
    referencedTables.add(table);
    if (alias && !SQL_KEYWORDS.has(alias.toUpperCase())) {
      aliasToTable[alias] = table;
    }
  }

  const violations = [];

  const qualRE = /\b(\w+)\.deleted_at\b/gi;
  let r;
  while ((r = qualRE.exec(block)) !== null) {
    const qual = r[1];
    const resolved = aliasToTable[qual] || qual;
    if (withoutDA.has(resolved)) {
      violations.push(`deleted_at filter on "${resolved}" (as "${qual}.deleted_at") — no such column`);
    }
  }

  const unqualRE = /(?<![\w.])deleted_at\b/gi;
  let hasUnqual = false;
  while (unqualRE.exec(block) !== null) hasUnqual = true;
  if (hasUnqual && referencedTables.size > 0) {
    const resolvers = [...referencedTables].filter((t) => withDA.has(t));
    if (resolvers.length === 0) {
      violations.push(`unqualified deleted_at filter; none of {${[...referencedTables].join(', ')}} have that column`);
    }
  }

  return violations;
}

const files = execSync("find src -name '*.ts' -not -type d", { encoding: 'utf8' })
  .trim()
  .split('\n')
  .filter(Boolean);

const all = [];
for (const file of files) {
  const content = fs.readFileSync(file, 'utf8');
  const sqlBlocks = [
    ...content.matchAll(/`([^`]*(?:SELECT|INSERT|UPDATE|DELETE|WHERE|JOIN)[^`]*)`/gis),
  ];
  for (const [fullMatch, block] of sqlBlocks) {
    if (!/\bdeleted_at\b/i.test(block)) continue;
    const v = analyzeBlock(block);
    if (v.length === 0) continue;
    const lineNo = content.slice(0, content.indexOf(fullMatch)).split('\n').length;
    for (const msg of v) all.push(`${file}:${lineNo}: ${msg}`);
  }
}

if (all.length === 0) {
  process.stdout.write('PASS\n');
  process.exit(0);
}
all.forEach((line) => process.stdout.write(line + '\n'));
process.exit(1);
