#!/usr/bin/env node
// docs-registry.mjs — CLI reader for .claude/config.json docsRegistry
//
// Spec: docs/as-designed/doc-sync-strategy.md (DOC-SYNC-STRATEGY Phase 2)
// Consumers: .claude/scripts/{tech-doc-sweep,sync-gaps}.sh, .claude/skills/w-sync-docs
//
// Commands:
//   vendor-rules              — one TSV line per vendor-docs rule: <codePattern>\t<keywords>
//   test-shared-basenames     — one basename per line (test-docs.sharedBasenames)
//   get-group <id>            — JSON dump of a single group (for introspection)
//   list-groups               — newline-separated group ids
//
// Exit codes: 0 ok, 1 bad invocation, 2 missing group/field

import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const here = dirname(fileURLToPath(import.meta.url));
const configPath = join(here, '..', 'config.json');

function loadRegistry() {
  const raw = readFileSync(configPath, 'utf8');
  const cfg = JSON.parse(raw);
  if (!cfg.docsRegistry) {
    console.error('docsRegistry section missing from config.json');
    process.exit(2);
  }
  return cfg.docsRegistry;
}

function getGroup(registry, id) {
  const g = registry.groups.find((g) => g.id === id);
  if (!g) {
    console.error(`group not found: ${id}`);
    process.exit(2);
  }
  return g;
}

const [, , cmd, ...rest] = process.argv;
const registry = loadRegistry();

switch (cmd) {
  case 'vendor-rules': {
    const g = getGroup(registry, 'vendor-docs');
    for (const rule of g.rules || []) {
      const keywords = (rule.topicKeywords || []).join(' ');
      process.stdout.write(`${rule.codePattern}\t${keywords}\n`);
    }
    break;
  }
  case 'test-shared-basenames': {
    const g = getGroup(registry, 'test-docs');
    for (const name of g.sharedBasenames || []) {
      process.stdout.write(`${name}\n`);
    }
    break;
  }
  case 'get-group': {
    const id = rest[0];
    if (!id) {
      console.error('usage: get-group <id>');
      process.exit(1);
    }
    process.stdout.write(JSON.stringify(getGroup(registry, id), null, 2) + '\n');
    break;
  }
  case 'list-groups': {
    for (const g of registry.groups) process.stdout.write(`${g.id}\n`);
    break;
  }
  default: {
    console.error('commands: vendor-rules | test-shared-basenames | get-group <id> | list-groups');
    process.exit(1);
  }
}
