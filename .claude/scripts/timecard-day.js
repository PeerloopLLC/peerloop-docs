#!/usr/bin/env node
// Deterministic daily timecard data extractor.
// Reads commits from both repos for a target date, computes per-commit time slots
// (anchored to Conv heartbeats), aggregates per-Block reporting + day-level rollups,
// emits a single JSON blob to stdout. The skill renders this into .timecard.md.
//
// Usage: node timecard-day.js <date> [--exclude-branches "br1 br2"]
// Date formats: Mar-30-2026 | 2026-03-30 | March 30, 2026 | today | yesterday

'use strict';

const { execFileSync } = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');

// ────────────────────────────────────────────────────────────────────────────
// Config loader — module-scoped lazy singleton
// ────────────────────────────────────────────────────────────────────────────
// All project-specific literals live in .claude/config.json → rTimecardDay.
// See docs/reference/COMMIT-MESSAGE-FORMAT.md for the commit format this
// parses. See plan file (/r-timecard-day2 SKILL.md) for H5/H6 strategy refs.

let CFG = null;

function loadCfg() {
  if (CFG) return CFG;
  const docsRoot = process.env.CLAUDE_PROJECT_DIR || process.cwd();
  const configPath = path.join(docsRoot, '.claude', 'config.json');
  const full = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  const rt = full.rTimecardDay || {};
  const dw = rt.dayWindow || {};
  const cm = rt.convMeta || {};
  const rd = rt.render || {};
  CFG = {
    full,                                                              // whole config (for billing)
    rt,                                                                // rTimecardDay block
    codeRepo: full.codeRepo || '../Peerloop',
    overflowCapHHMM: dw.overflowCapHHMM || '22:00',
    roundToMinutes: dw.roundToMinutes || 5,
    heartbeatRe: new RegExp(cm.heartbeatPattern || '^Conv (\\d{3}) start —'),
    convPrefixRe: new RegExp(cm.convPrefixPattern || '^Conv (\\d{3})[:\\s]'),
    commitTagPrefixes: rt.commitTagPrefixes || {
      userFacing: 'User-facing:', adminFacing: 'Admin-facing:',
      api: 'API:', page: 'Page:', role: 'Role:', infra: 'Infra:',
      doc: 'Doc:', db: 'DB:', test: 'Test:',
    },
    legacyBulletSectionHeaders: (rt.legacy && rt.legacy.bulletSectionHeaders) || ['Changes:', 'Fixes:', 'Tests:'],
    render: {
      tagRe: new RegExp(rd.tagPattern || '^\\[([^\\]]+)\\]'),
      countRe: new RegExp(rd.countPattern || '\\b\\d+[-\\s]\\w+'),
      verbTagRe: new RegExp(rd.verbTagPattern || '^(?:Fixed|New|Added|Removed|Updated|Delete|Deleted|Remove)\\s+\\[([A-Z][\\w-]*)\\]'),
    },
    h4Sections: rt.h4Sections || [],
    skipFilter: rt.skipFilter || null,
  };
  return CFG;
}

// ────────────────────────────────────────────────────────────────────────────
// CLI args
// ────────────────────────────────────────────────────────────────────────────

function parseArgs(argv) {
  const args = { date: null, excludeBranches: [] };
  const rest = argv.slice(2);
  for (let i = 0; i < rest.length; i++) {
    const a = rest[i];
    if (a === '--exclude-branches') {
      const val = rest[++i] || '';
      args.excludeBranches = val.split(/\s+/).filter(Boolean);
    } else if (!args.date) {
      args.date = a;
    }
  }
  return args;
}

// ────────────────────────────────────────────────────────────────────────────
// Date parsing
// ────────────────────────────────────────────────────────────────────────────

function parseDate(input) {
  if (!input) throw new Error('Date argument required.');

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const lower = input.toLowerCase();
  if (lower === 'today') return today;
  if (lower === 'yesterday') {
    const y = new Date(today);
    y.setDate(y.getDate() - 1);
    return y;
  }

  // ISO: 2026-04-14
  let m = input.match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (m) return new Date(Number(m[1]), Number(m[2]) - 1, Number(m[3]));

  // Mon-DD-YYYY: Mar-30-2026 or Mar-30-2026
  m = input.match(/^([A-Za-z]+)-(\d{1,2})-(\d{4})$/);
  if (m) {
    const month = monthIndex(m[1]);
    if (month !== -1) return new Date(Number(m[3]), month, Number(m[2]));
  }

  // Natural language: "March 30, 2026" or "Mar 30, 2026"
  const natural = new Date(input);
  if (!isNaN(natural.getTime())) {
    natural.setHours(0, 0, 0, 0);
    return natural;
  }

  throw new Error(`Could not parse date: ${input}`);
}

function monthIndex(s) {
  const months = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
  return months.indexOf(s.slice(0, 3).toLowerCase());
}

function fmtYMD(d) {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

function fmtSinceUntil(d) {
  const next = new Date(d);
  next.setDate(next.getDate() + 1);
  return { since: `${fmtYMD(d)} 00:00:00`, until: `${fmtYMD(next)} 00:00:00`, untilDate: next };
}

function fmtNextDayUntil(d) {
  const nn = new Date(d);
  nn.setDate(nn.getDate() + 2);
  return `${fmtYMD(nn)} 00:00:00`;
}

function fmtHHMM(date) {
  const h = String(date.getHours()).padStart(2, '0');
  const m = String(date.getMinutes()).padStart(2, '0');
  return `${h}:${m}`;
}

function roundToNearest5(min) {
  const step = loadCfg().roundToMinutes;
  return Math.round(min / step) * step;
}

function fmtHoursMin(min) {
  if (min < 0) min = 0;
  const h = Math.floor(min / 60);
  const m = min % 60;
  return `${h}h${String(m).padStart(2, '0')}`;
}

// ────────────────────────────────────────────────────────────────────────────
// Repo discovery — read codeRepo from config.json
// ────────────────────────────────────────────────────────────────────────────

function getRepos() {
  const docsRoot = process.env.CLAUDE_PROJECT_DIR || process.cwd();
  const codeRoot = path.resolve(docsRoot, loadCfg().codeRepo);
  return [
    { name: 'docs', root: docsRoot },
    { name: 'code', root: codeRoot },
  ];
}

// ────────────────────────────────────────────────────────────────────────────
// Git helpers
// ────────────────────────────────────────────────────────────────────────────

function gitOut(repoRoot, args) {
  try {
    return execFileSync('git', ['-C', repoRoot, ...args], { encoding: 'utf8' });
  } catch (e) {
    return '';
  }
}

function repoExists(repoRoot) {
  try {
    fs.statSync(path.join(repoRoot, '.git'));
    return true;
  } catch {
    return false;
  }
}

function listLocalBranches(repoRoot) {
  const out = gitOut(repoRoot, ['for-each-ref', '--format=%(refname:short)', 'refs/heads/']);
  return out.split('\n').map((s) => s.trim()).filter(Boolean);
}

function getHeadBranch(repoRoot) {
  const out = gitOut(repoRoot, ['symbolic-ref', '--short', 'HEAD']);
  return out.trim();
}

function countCommitsInWindow(repoRoot, branch, since, until) {
  const out = gitOut(repoRoot, ['log', branch, '--oneline', `--since=${since}`, `--until=${until}`]);
  return out.split('\n').filter((l) => l.trim()).length;
}

// ────────────────────────────────────────────────────────────────────────────
// Branch discovery (Step 2)
// ────────────────────────────────────────────────────────────────────────────

function discoverCandidateBranches(repos, since, until) {
  const out = [];
  for (const repo of repos) {
    if (!repoExists(repo.root)) continue;
    const headBranch = getHeadBranch(repo.root);
    const branches = listLocalBranches(repo.root);
    for (const br of branches) {
      const count = countCommitsInWindow(repo.root, br, since, until);
      if (count > 0) {
        out.push({
          repo: repo.name,
          branch: br,
          isHead: br === headBranch,
          inWindowCommitCount: count,
        });
      }
    }
  }
  return out;
}

// ────────────────────────────────────────────────────────────────────────────
// Commit extraction (Step 2c)
// ────────────────────────────────────────────────────────────────────────────

const COMMIT_DELIM = '---COMMIT---';
const END_DELIM = '---END---';

function extractCommitsFromBranch(repoRoot, repoName, branch, since, until) {
  const fmt = `${COMMIT_DELIM}%n%H%n%h%n%ci%n%s%n%b%n${END_DELIM}`;
  // `--name-only` appends the list of changed files after each commit's
  // formatted portion. The parser splits on COMMIT_DELIM (commit boundary)
  // and END_DELIM (formatted-content vs file-list boundary).
  const out = gitOut(repoRoot, ['log', branch, `--format=${fmt}`, `--since=${since}`, `--until=${until}`, '--reverse', '--name-only']);
  return parseCommitStream(out, repoName, branch);
}

function parseCommitStream(text, repoName, branch) {
  const commits = [];
  const blocks = text.split(COMMIT_DELIM).slice(1);
  for (const blk of blocks) {
    const endIdx = blk.lastIndexOf(END_DELIM);
    const body = endIdx >= 0 ? blk.slice(0, endIdx) : blk;
    const tail = endIdx >= 0 ? blk.slice(endIdx + END_DELIM.length) : '';
    const lines = body.split('\n');
    // First non-empty line removed by split — the first real line is the full hash
    // Format laid out: %H\n%h\n%ci\n%s\n%b
    // After leading '\n' from %n in format, lines[0] is empty. Skip it.
    let i = 0;
    while (i < lines.length && lines[i] === '') i++;
    if (i + 4 > lines.length) continue;
    const fullHash = lines[i++];
    const hash = lines[i++];
    const timestamp = lines[i++];
    const subject = lines[i++];
    const bodyText = lines.slice(i).join('\n').replace(/\n+$/, '');
    // filesChanged from the --name-only tail: lines after END_DELIM, trimmed,
    // skipping blanks. Stops naturally at next COMMIT_DELIM (already split on).
    const filesChanged = tail
      .split('\n')
      .map((s) => s.trim())
      .filter(Boolean);
    commits.push({
      repo: repoName,
      branch,
      fullHash,
      hash,
      timestampISO: toIso(timestamp),
      timestampMs: new Date(timestamp).getTime(),
      subject,
      body: bodyText,
      filesChanged,
    });
  }
  return commits;
}

function toIso(gitTimestamp) {
  // git %ci format: "2026-04-14 12:50:38 -0400" — convert to ISO8601
  const d = new Date(gitTimestamp);
  if (isNaN(d.getTime())) return gitTimestamp;
  return d.toISOString();
}

// ────────────────────────────────────────────────────────────────────────────
// De-dup by hash (prefer non-HEAD/non-main branch)
// ────────────────────────────────────────────────────────────────────────────

function dedupCommits(allCommits, headBranchByRepo) {
  const byHash = new Map();
  for (const c of allCommits) {
    const existing = byHash.get(c.fullHash);
    if (!existing) {
      byHash.set(c.fullHash, c);
      continue;
    }
    // Both exist — prefer non-HEAD/non-main branch
    const existingPriority = branchPriority(existing.branch, headBranchByRepo[existing.repo]);
    const newPriority = branchPriority(c.branch, headBranchByRepo[c.repo]);
    if (newPriority > existingPriority) byHash.set(c.fullHash, c);
  }
  return Array.from(byHash.values());
}

function branchPriority(branch, headBranch) {
  // Higher = preferred. Non-HEAD AND non-main wins.
  if (branch !== headBranch && branch !== 'main' && branch !== 'master') return 2;
  if (branch !== headBranch) return 1;
  return 0;
}

// ────────────────────────────────────────────────────────────────────────────
// Commit metadata parsing
// ────────────────────────────────────────────────────────────────────────────

function parseMetadata(c) {
  const cfg = loadCfg();

  // Heartbeat detection
  const hbMatch = c.subject.match(cfg.heartbeatRe);
  c.isHeartbeat = !!hbMatch;
  c.conv = hbMatch ? hbMatch[1] : null;

  if (!c.isHeartbeat) {
    const cp = c.subject.match(cfg.convPrefixRe);
    c.conv = cp ? cp[1] : null;
  }
  c.isAdHoc = c.conv === null;

  // Phase: line(s) — also fall back to legacy Block: form
  const phaseLines = extractFieldLines(c.body, ['Phase:', 'Block:']);
  const blocksRaw = [];
  for (const line of phaseLines) {
    for (const piece of line.split(',')) {
      const trimmed = piece.trim();
      if (trimmed) blocksRaw.push(trimmed);
    }
  }
  c.blocksRaw = blocksRaw;
  c.blocksNormalized = blocksRaw.length > 0
    ? Array.from(new Set(blocksRaw.map(normalizeBlock)))
    : ['(no-block)'];

  // Machine
  const machineLines = extractFieldLines(c.body, ['Machine:']);
  c.machine = machineLines[0] || null;

  // Type — currently only 'end-of-conv' defined. Metadata-only (pairs with
  // the corresponding `Conv NNN start —` heartbeat). Does NOT change timecard
  // treatment — the commit rolls up identically to any other /r-commit.
  const typeLines = extractFieldLines(c.body, ['Type:']);
  c.type = typeLines[0] || null;

  // Block-summary — one-sentence narrative written at commit time. When every
  // commit in a Block has one, /r-timecard-day can render Block Progress
  // bullets deterministically (no LLM step). Required post-Conv 069 when
  // Phase is not `(misc)`; legacy commits return null and hit LLM fallback.
  const blockSummaryLines = extractFieldLines(c.body, ['Block-summary:']);
  c.blockSummary = blockSummaryLines[0] || null;

  // Tags (from legacy "API:" / "Doc:" / ... field lines)
  const tags = {};
  for (const [key, prefix] of Object.entries(cfg.commitTagPrefixes)) {
    tags[key] = extractFieldLines(c.body, [prefix]);
  }
  c.tags = tags;

  // Work-effort bullets (lines starting with "- " under Changes/Fixes/Tests headers)
  c.workEffortBullets = extractWorkEffortBullets(c.body);

  // Format: v2 detection and H3-section bullet extraction.
  // v2 commits set bullets' `src` from the `### SECTION` they appear under.
  // When absent, legacy path supplies items from tags + workEffortBullets.
  const formatLines = extractFieldLines(c.body, ['Format:']);
  c.format = formatLines[0] || null;
  c.isV2 = c.format === 'v2';
  c.v2Bullets = c.isV2 ? extractV2Bullets(c.body, cfg.h4Sections) : null;

  // Short HH:MM time
  const d = new Date(c.timestampMs);
  c.timeShort = fmtHHMM(d);

  return c;
}

// Parse a v2 commit body: collect bullets under each `### Section Title` H3
// and tag each bullet with the `src` id of the matching h4Section (title lookup).
// Returns an array of { src, text } in order. Multiple bullets under the same H3
// preserve order; duplicate placements (same bullet under multiple H3s) are
// preserved — the caller dedups per-H4.
function extractV2Bullets(body, h4Sections) {
  const titleToId = {};
  for (const h of h4Sections) titleToId[h.title] = h.id;
  const bullets = [];
  let currentSrc = null;
  for (const line of body.split('\n')) {
    const h3 = line.match(/^###\s+(.+?)\s*$/);
    if (h3) {
      currentSrc = titleToId[h3[1]] || null;
      continue;
    }
    // Stop collecting at the first non-H3, non-bullet, non-blank trailer line
    // (e.g., `Stats:`, `Block:`, `Conv:` — the metadata block).
    if (/^[A-Z][A-Za-z-]+:/.test(line)) {
      currentSrc = null;
      continue;
    }
    if (currentSrc && line.startsWith('- ')) {
      bullets.push({ src: currentSrc, text: line.slice(2).trim() });
    }
  }
  return bullets;
}

function extractFieldLines(body, prefixes) {
  // Each prefix form: "Prefix: value" — extract the value, strip the prefix and surrounding ws.
  // Body may contain multiple lines with the same prefix; collect all.
  const out = [];
  for (const line of body.split('\n')) {
    for (const prefix of prefixes) {
      if (line.startsWith(prefix)) {
        out.push(line.slice(prefix.length).trim());
        break;
      }
    }
  }
  return out;
}

function extractWorkEffortBullets(body) {
  const headers = loadCfg().legacyBulletSectionHeaders;
  const bullets = [];
  let inSection = false;
  for (const line of body.split('\n')) {
    const trimmed = line.trim();
    if (headers.includes(trimmed)) {
      inSection = true;
      continue;
    }
    if (inSection) {
      if (line.startsWith('- ')) {
        bullets.push(line.slice(2).trim());
      } else if (trimmed === '' || line.startsWith('- ')) {
        continue;
      } else if (/^[A-Z][A-Za-z-]+:/.test(line)) {
        inSection = false;
      }
    }
  }
  return bullets;
}

function normalizeBlock(raw) {
  // Strip from first " — " (space-em-dash-space) or ". " (period-space) onward.
  const sepRe = /(\s—\s|\.\s)/;
  const idx = raw.search(sepRe);
  return idx === -1 ? raw.trim() : raw.slice(0, idx).trim();
}

// ────────────────────────────────────────────────────────────────────────────
// Conv timeline + slot allocation
// ────────────────────────────────────────────────────────────────────────────

function buildConvTimeline(commits) {
  // Group by Conv (null = ad-hoc, separate bucket)
  const byConv = new Map();
  for (const c of commits) {
    const key = c.conv || '__adhoc__';
    if (!byConv.has(key)) byConv.set(key, []);
    byConv.get(key).push(c);
  }

  const skippedConvs = [];
  const warnings = [];
  const validConvs = [];

  for (const [conv, list] of byConv.entries()) {
    if (conv === '__adhoc__') continue;
    list.sort((a, b) => a.timestampMs - b.timestampMs);

    const heartbeats = list.filter((c) => c.isHeartbeat);
    const work = list.filter((c) => !c.isHeartbeat);

    if (heartbeats.length === 0) {
      skippedConvs.push({ conv, reason: 'no-heartbeat-on-date' });
      continue;
    }
    if (work.length === 0) {
      skippedConvs.push({ conv, reason: 'heartbeat-only-no-work' });
      continue;
    }
    if (heartbeats.length > 1) {
      warnings.push(`Conv ${conv}: multiple heartbeats found (${heartbeats.length}); using earliest.`);
    }

    validConvs.push({
      conv,
      heartbeat: heartbeats[0],
      workCommits: work,
    });
  }

  // Ad-hoc commits (no Conv) — pulled out as their own bucket
  const adhocCommits = byConv.get('__adhoc__') || [];

  return { validConvs, skippedConvs, adhocCommits, warnings };
}

function allocateSlots(validConvs, adhocCommits, overflow) {
  // Sets slotMin and slotStartISO on each work commit and on heartbeats/ad-hoc.
  const overflowConvNum = overflow ? overflow.conv : null;
  const capMs = overflow ? overflow.capMs : null;

  for (const conv of validConvs) {
    // Events: heartbeat + work commits, chronological
    conv.heartbeat.slotMin = 0;
    conv.heartbeat.slotStartISO = null;
    let prev = conv.heartbeat;
    for (const c of conv.workCommits) {
      const prevMs = prev.timestampMs;
      let endMs = c.timestampMs;
      // Overflow cap: if this Conv is the overflow Conv and end is past 22:00, cap it.
      if (overflowConvNum === conv.conv && capMs !== null && endMs > capMs) {
        endMs = capMs;
      }
      const slotMin = Math.round((endMs - prevMs) / 60000);
      c.slotMin = Math.max(0, slotMin);
      c.slotStartISO = new Date(prevMs).toISOString();
      prev = c;
    }
  }

  for (const c of adhocCommits) {
    c.slotMin = 0;
    c.slotStartISO = null;
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Overflow detection
// ────────────────────────────────────────────────────────────────────────────

function detectOverflow(validConvs, repos, untilDate) {
  if (validConvs.length === 0) return null;
  // Sort Convs by heartbeat time; last one is the overflow candidate
  const sorted = [...validConvs].sort((a, b) => a.heartbeat.timestampMs - b.heartbeat.timestampMs);
  const last = sorted[sorted.length - 1];

  // Look for next-day commits matching this Conv
  const since = `${fmtYMD(untilDate)} 00:00:00`;
  const until = fmtNextDayUntil(untilDate);
  const grep = `Conv ${last.conv}`;
  let nextDayEarliestISO = null;

  for (const repo of repos) {
    if (!repoExists(repo.root)) continue;
    const out = gitOut(repo.root, [
      'log',
      '--all',
      `--grep=${grep}`,
      '--format=%ci%n%s%n---END---',
      `--since=${since}`,
      `--until=${until}`,
      '--reverse',
    ]);
    const blocks = out.split('---END---').map((s) => s.trim()).filter(Boolean);
    for (const blk of blocks) {
      const lines = blk.split('\n');
      const ts = lines[0];
      const subj = lines[1] || '';
      // Skip heartbeats — overflow means a WORK commit happened next day
      if (loadCfg().heartbeatRe.test(subj)) continue;
      const tsMs = new Date(ts).getTime();
      if (nextDayEarliestISO === null || tsMs < new Date(nextDayEarliestISO).getTime()) {
        nextDayEarliestISO = new Date(ts).toISOString();
      }
    }
  }

  if (!nextDayEarliestISO) return null;

  // Cap = today at configured overflow HH:MM (in local time)
  const capHHMM = loadCfg().overflowCapHHMM;
  const cap = new Date(untilDate);
  cap.setDate(cap.getDate() - 1); // untilDate is the next day; subtract one to get target day
  const [capH, capM] = capHHMM.split(':').map(Number);
  cap.setHours(capH, capM, 0, 0);

  return {
    conv: last.conv,
    nextDayEndISO: nextDayEarliestISO,
    capAt: capHHMM,
    capMs: cap.getTime(),
  };
}

// ────────────────────────────────────────────────────────────────────────────
// Aggregations
// ────────────────────────────────────────────────────────────────────────────

function buildBlockProgress(allWorkAndAdhoc) {
  // allWorkAndAdhoc = work commits + ad-hoc commits, chronological
  // Each commit may have multiple blocksNormalized; bullets duplicate per Block.
  const map = new Map();
  for (const c of allWorkAndAdhoc) {
    for (const block of c.blocksNormalized) {
      if (!map.has(block)) {
        map.set(block, {
          blockName: block,
          rawVariants: new Set(),
          billableMin: 0,
          commitHashes: [],
          bullets: [],
          blockSummaries: [],
        });
      }
      const entry = map.get(block);
      for (const raw of c.blocksRaw) {
        if (normalizeBlock(raw) === block) entry.rawVariants.add(raw);
      }
      // billableMin: each commit's slot counts toward each Block it lists (informational)
      entry.billableMin += c.slotMin;
      entry.commitHashes.push(c.hash);
      for (const b of c.workEffortBullets) entry.bullets.push(b);
      // Block-summary: record whatever was present (or null). Rendering logic
      // checks `blockSummaries.length === commitHashes.length` to decide
      // between deterministic bullets vs LLM placeholder.
      entry.blockSummaries.push({ hash: c.hash, summary: c.blockSummary || null });
    }
  }
  // Convert sets to arrays
  const out = {};
  for (const [k, v] of map.entries()) {
    out[k] = {
      blockName: v.blockName,
      rawVariants: Array.from(v.rawVariants),
      billableMin: v.billableMin,
      commitHashes: v.commitHashes,
      bullets: v.bullets,
      blockSummaries: v.blockSummaries,
    };
  }
  return out;
}

function blocksFirstTouchOrder(allWorkAndAdhoc) {
  const seen = new Set();
  const order = [];
  for (const c of allWorkAndAdhoc) {
    for (const block of c.blocksNormalized) {
      if (!seen.has(block)) {
        seen.add(block);
        order.push(block);
      }
    }
  }
  return order;
}

function buildDayTags(allCommits) {
  const tags = {
    userFacing: new Set(),
    adminFacing: new Set(),
    api: new Set(),
    page: new Set(),
    role: new Set(),
    infra: new Set(),
    doc: new Set(),
    db: new Set(),
    test: new Set(),
  };
  for (const c of allCommits) {
    for (const key of Object.keys(tags)) {
      for (const v of c.tags[key] || []) tags[key].add(v);
    }
  }
  // Sort
  const HTTP_METHODS = ['GET', 'HEAD', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'];
  return {
    userFacing: Array.from(tags.userFacing).sort(),
    adminFacing: Array.from(tags.adminFacing).sort(),
    api: Array.from(tags.api).sort((a, b) => {
      const am = (a.match(/^([A-Z]+)/) || [])[1] || '';
      const bm = (b.match(/^([A-Z]+)/) || [])[1] || '';
      const ai = HTTP_METHODS.indexOf(am);
      const bi = HTTP_METHODS.indexOf(bm);
      if (ai !== bi) return (ai === -1 ? 99 : ai) - (bi === -1 ? 99 : bi);
      return a.localeCompare(b);
    }),
    page: Array.from(tags.page).sort((a, b) => {
      const ap = (a.match(/^(\/\S+)/) || [])[1] || '';
      const bp = (b.match(/^(\/\S+)/) || [])[1] || '';
      if (ap !== bp) return ap.localeCompare(bp);
      return a.localeCompare(b);
    }),
    role: Array.from(tags.role).sort(),
    infra: Array.from(tags.infra).sort(),
    doc: Array.from(tags.doc).sort(),
    db: Array.from(tags.db).sort(),
    test: Array.from(tags.test).sort(),
  };
}

function buildDayWorkEffort(allCommits) {
  // Chronological dump of all bullets across all commits.
  // Each item carries `filesChanged` from its commit so the classifier can
  // match bare-filename bullet text against a known file path (T3 signal).
  const sorted = [...allCommits].sort((a, b) => a.timestampMs - b.timestampMs);
  const out = [];
  for (const c of sorted) {
    for (const b of c.workEffortBullets) {
      out.push({ hash: c.hash, bullet: b, filesChanged: c.filesChanged || [] });
    }
  }
  return out;
}

// ────────────────────────────────────────────────────────────────────────────
// Stable sort (ts then repo then hash)
// ────────────────────────────────────────────────────────────────────────────

// ────────────────────────────────────────────────────────────────────────────
// r-timecard-day filters + markdown rendering
// ────────────────────────────────────────────────────────────────────────────
// All filter / reroute / group / render logic lives here so the skill is a
// thin wrapper: invoke script, fill <!--BLOCK_PARAGRAPH:...--> placeholders,
// write the file. Re-runs on the same date produce byte-identical markdown
// except for Block paragraphs.

const MONTHS_ABBR = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

// Extract a `[TAG]` for grouping. Prefers leading tag; falls back to verb-prefixed tag.
// Returns { tag, stripPrefix } or null.
function extractWorkTag(text) {
  const r = loadCfg().render;
  const leading = text.match(r.tagRe);
  if (leading) return { tag: leading[1], stripPrefix: true };
  const afterVerb = text.match(r.verbTagRe);
  if (afterVerb) return { tag: afterVerb[1], stripPrefix: false };
  return null;
}

// Clean a sub-phase's display name by stripping the parent-prefix match and any
// leading/trailing separators (spaces, dashes, parens, colons, em-dashes).
function cleanSubPhaseName(fullName, prefixLen) {
  let rest = fullName.slice(prefixLen);
  rest = rest.replace(/^[\s\-:—,]*\(?\s*/, '');
  rest = rest.replace(/\s*\)\s*$/, '');
  return rest.trim() || '(main)';
}

// If `mergeBlockPattern` is configured, group blocks by their prefix-match.
// Matched blocks become sub-phases of a single parent entry with aggregated
// billable minutes + bullet+hash pools; unmatched blocks pass through as-is.
//
// After dot-pattern merging, a second pass detects "space-variant" blocks:
// any standalone block X where another standalone block starts with "X " is
// treated as a parent, with both itself and the variant(s) becoming sub-phases.
// Example: ROLE-AUDIT + "ROLE-AUDIT (drain" → H5 ROLE-AUDIT with two H6s.
// Child-before-parent ordering is handled (each parent collects all children
// in one pass when the parent is first encountered).
function applyBlockMerge(blocks, blockProgress, mergePatternSrc) {
  // ── Pass 1: dot-pattern merge (unchanged logic) ──────────────────────────
  const re = mergePatternSrc ? new RegExp(mergePatternSrc) : null;
  const pass1BP = {};
  const pass1Order = [];
  for (const name of blocks) {
    const bp = blockProgress[name];
    const m = re ? name.match(re) : null;
    if (!m) {
      pass1BP[name] = { ...bp, subPhases: [] };
      pass1Order.push(name);
      continue;
    }
    const parent = m[1];
    if (!pass1BP[parent]) {
      pass1BP[parent] = {
        blockName: parent, rawVariants: [], billableMin: 0,
        commitHashes: [], bullets: [], blockSummaries: [], subPhases: [],
      };
      pass1Order.push(parent);
    }
    const entry = pass1BP[parent];
    entry.billableMin += bp.billableMin || 0;
    entry.commitHashes.push(...(bp.commitHashes || []));
    entry.bullets.push(...(bp.bullets || []));
    entry.blockSummaries.push(...(bp.blockSummaries || []));
    entry.rawVariants.push(...(bp.rawVariants || [name]));
    entry.subPhases.push({
      name,
      displayName: cleanSubPhaseName(name, m[0].length),
      billableMin: bp.billableMin || 0,
      commitHashes: bp.commitHashes || [],
      bullets: bp.bullets || [],
      blockSummaries: bp.blockSummaries || [],
    });
  }

  // ── Pass 2: space-variant merge among pass-1 standalones ─────────────────
  // A standalone block X is a "space parent" when another standalone starts
  // with "X " (space, not dot). Both become sub-phases under a merged H5.
  const standalones = pass1Order.filter(n => pass1BP[n].subPhases.length === 0);
  const spaceChildOf = {};   // childName → parentName
  const spaceParentSet = new Set();
  for (const name of standalones) {
    for (const candidate of standalones) {
      if (name !== candidate && name.startsWith(candidate + ' ')) {
        spaceChildOf[name] = candidate;
        spaceParentSet.add(candidate);
      }
    }
  }
  if (spaceParentSet.size === 0) return { blocks: pass1Order, blockProgress: pass1BP };

  const mergedBP = {};
  const parentOrder = [];
  const skip = new Set();

  for (const name of pass1Order) {
    if (skip.has(name)) continue;
    const bp = pass1BP[name];

    if (spaceParentSet.has(name)) {
      // This block is a space-parent: collect itself + all children as sub-phases.
      const entry = {
        blockName: name, rawVariants: [name],
        billableMin: bp.billableMin || 0,
        commitHashes: [...(bp.commitHashes || [])],
        bullets: [...(bp.bullets || [])],
        blockSummaries: [...(bp.blockSummaries || [])],
        subPhases: [
          { name, displayName: name, billableMin: bp.billableMin || 0,
            commitHashes: bp.commitHashes || [], bullets: bp.bullets || [],
            blockSummaries: bp.blockSummaries || [] },
        ],
      };
      // Collect children in pass1Order sequence (handles child-before-parent).
      for (const childName of pass1Order) {
        if (spaceChildOf[childName] === name) {
          const childBP = pass1BP[childName];
          entry.billableMin += childBP.billableMin || 0;
          entry.commitHashes.push(...(childBP.commitHashes || []));
          entry.bullets.push(...(childBP.bullets || []));
          entry.blockSummaries.push(...(childBP.blockSummaries || []));
          entry.rawVariants.push(childName);
          const displayName = childName.slice(name.length + 1).trim();
          entry.subPhases.push({
            name: childName, displayName,
            billableMin: childBP.billableMin || 0,
            commitHashes: childBP.commitHashes || [],
            bullets: childBP.bullets || [],
            blockSummaries: childBP.blockSummaries || [],
          });
          skip.add(childName);
        }
      }
      mergedBP[name] = entry;
      parentOrder.push(name);
      skip.add(name);
    } else if (spaceChildOf[name]) {
      // Child will be (or already was) collected by its parent — skip.
      skip.add(name);
    } else {
      // Truly standalone — pass through.
      mergedBP[name] = bp;
      parentOrder.push(name);
    }
  }
  return { blocks: parentOrder, blockProgress: mergedBP };
}

function loadRenderConfig() {
  const docsRoot = process.env.CLAUDE_PROJECT_DIR || process.cwd();
  const configPath = path.join(docsRoot, '.claude', 'config.json');
  try {
    const cfg = JSON.parse(fs.readFileSync(configPath, 'utf8'));
    return { rt: cfg.rTimecardDay || {}, billing: cfg.billing || {} };
  } catch { return { rt: {}, billing: {} }; }
}

function collectValidDocs(config) {
  const docsRoot = process.env.CLAUDE_PROJECT_DIR || process.cwd();
  const valid = new Set();
  const rootExclude = new Set(config.docRootExclude || []);
  try {
    for (const entry of fs.readdirSync(docsRoot, { withFileTypes: true })) {
      if (entry.isFile() && entry.name.endsWith('.md') && !rootExclude.has(entry.name)) {
        valid.add(entry.name);
      }
    }
  } catch {}
  const excludes = (config.docPathsExclude || []).map(p => path.resolve(docsRoot, p));
  function walk(dir) {
    try {
      for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
        const full = path.join(dir, entry.name);
        if (entry.isDirectory()) {
          if (excludes.some(ex => full === ex || full.startsWith(ex + path.sep))) continue;
          walk(full);
        } else if (entry.isFile() && entry.name.endsWith('.md')) {
          valid.add(entry.name);
        }
      }
    } catch {}
  }
  for (const p of (config.docPaths || ['docs/'])) walk(path.resolve(docsRoot, p));
  return valid;
}

function skipMatches(text, term) {
  return new RegExp(`(?<![\\w-])${term}s?(?![\\w-])`, 'i').test(text);
}

function isRoutine(text, config) {
  const rs = config.routineStrip || {};
  const lower = text.toLowerCase();
  const trimmed = text.trim().replace(/^[\s\-]+/, '').toLowerCase();
  for (const tok of rs.stripIfTextEquals || []) {
    if (trimmed === tok.toLowerCase()) return true;
  }
  for (const p of rs.phrases || []) { if (lower.includes(p.toLowerCase())) return true; }
  for (const p of rs.pathPatterns || []) { if (lower.includes(p.toLowerCase())) return true; }
  const countFile = (rs.countFiles || []).find(f => text.includes(f));
  if (countFile) {
    const hasCount = loadCfg().render.countRe.test(text);
    const hasSkip = (rs.countSkipIfContains || []).some(s => skipMatches(text, s));
    if (hasCount && !hasSkip) return true;
  }
  return false;
}

function extractDocs(text, validDocs, config) {
  const docs = [];
  const excludes = config.docPathsExclude || ['docs/sessions/'];
  for (const m of text.match(/docs\/[A-Za-z0-9._\-/]+?\.md/g) || []) {
    if (excludes.some(ex => m.startsWith(ex))) continue;
    const base = path.basename(m);
    if (!docs.includes(base)) docs.push(base);
  }
  const bareRe = /(?:^|[^\w/])([A-Za-z0-9._-]+\.md)\b/g;
  let match;
  while ((match = bareRe.exec(text)) !== null) {
    const candidate = match[1];
    if (!candidate.includes('/') && validDocs.has(candidate) && !docs.includes(candidate)) {
      docs.push(candidate);
    }
  }
  // Whitelist: ALL-CAPS stems recognized even without .md extension.
  // Guard with validDocs so phantom entries are silently ignored.
  const whitelist = config.docNameWhitelist || [];
  if (whitelist.length > 0) {
    const escaped = whitelist.map(s => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
    const wlRe = new RegExp(`(?:^|[^\\w-])(${escaped.join('|')})(?:\\.md)?(?=[^\\w-]|$)`, 'g');
    let wm;
    while ((wm = wlRe.exec(text)) !== null) {
      const filename = wm[1].toUpperCase() + '.md';
      if (validDocs.has(filename) && !docs.includes(filename)) docs.push(filename);
    }
  }
  return docs;
}

function isTestRelated(item, config) {
  const text = item.text || '';
  const lower = text.toLowerCase();
  const t = config.testing || {};
  for (const pre of t.pathPrefixes || []) { if (lower.startsWith(pre)) return true; }
  const m = text.match(loadCfg().render.tagRe);
  if (m) {
    for (const tc of t.tagContains || []) {
      if (m[1].toLowerCase().includes(tc.toLowerCase())) return true;
    }
  }
  for (const w of t.wordMatches || []) {
    if (new RegExp(`(?<![\\w-])${w}(?![\\w-])`, 'i').test(text)) return true;
  }
  return false;
}

function fixAngleBrackets(text) {
  if (!text) return text;
  return text.replace(/<([^>]+)>/g, (match, inner) => {
    if (/^https?:/i.test(inner)) return match;
    return `<{${inner}}>`;
  });
}

function groupByKey(arr, keyFn) {
  const groups = {};
  for (const item of arr) {
    const k = keyFn(item) || '(misc)';
    if (!groups[k]) groups[k] = [];
    groups[k].push(item);
  }
  return groups;
}

// ────────────────────────────────────────────────────────────────────────────
// Predicate engine — per-H4 inclusion
// ────────────────────────────────────────────────────────────────────────────
// A bullet can appear in multiple H4 sections. Each h4Section in config has
// its own `include` predicate, evaluated independently over every non-skipped
// bullet. No first-match-wins, no ordering dependency — if a bullet's text
// mentions an API path AND a doc file, it renders under both API Changes and
// Doc Changes. The Work Effort H4 uses `{ fallthrough: true }` to pick up
// bullets that matched nothing else.
//
// Predicate keys (AND across keys; use `anyOf`/`allOf` for OR/AND groups):
//   src                 — bullet's source bucket id (userFacing, api, …)
//   matchesRegex        — bullet text matches (name refers to reroute.*)
//   textContainsAny     — text includes any string from reroute.*
//   startsWithAny       — text starts with any string from reroute.*
//   docsMentionGt       — extractDocs count > N
//   docsMentionEq       — extractDocs count == N
//   docsMentionGte      — extractDocs count >= N (or named field)
//   testRelated         — isTestRelated
//   notTestRelated      — !isTestRelated
//   isRoutine           — isRoutine(text, routineStrip)
//   commitFileMatchesPrefix — bullet names one of commit.filesChanged whose
//                             full path starts-contains a listed prefix
//   allCommitFilesUnder — every commit.filesChanged under one of the prefixes
//   flag                — boolean field on config (e.g. routineStrip.stripDocTagWithoutDocMention)
//   fallthrough         — true iff bullet matched no other H4's include
//   anyOf / allOf       — combinators (arrays of sub-predicates)

function resolveConfigRef(ref, rt) {
  // "reroute.dbSqlRe" → rt.reroute.dbSqlRe;  "routineStrip.multiDocMinCount" → rt.routineStrip.multiDocMinCount
  if (typeof ref !== 'string' || !ref.includes('.')) return ref;
  const parts = ref.split('.');
  let cur = rt;
  for (const p of parts) {
    if (cur && typeof cur === 'object' && p in cur) cur = cur[p];
    else return null;
  }
  return cur;
}

function _compileRegex(val, flags) {
  if (!val) return null;
  if (val instanceof RegExp) return val;
  return new RegExp(val, flags || '');
}

// Evaluate one predicate against one bullet. Returns boolean.
function evalPredicate(pred, item, ctx) {
  if (!pred || typeof pred !== 'object') return false;

  if (Array.isArray(pred.anyOf)) {
    for (const sub of pred.anyOf) if (evalPredicate(sub, item, ctx)) return true;
    return false;
  }
  if (Array.isArray(pred.allOf)) {
    for (const sub of pred.allOf) if (!evalPredicate(sub, item, ctx)) return false;
    return true;
  }

  const { rt, validDocs } = ctx;
  const text = item.text || '';
  const lower = text.toLowerCase();

  // Handle `fallthrough` upstream in the caller — here it evaluates false so
  // it never claims a bullet directly; the caller checks it separately.
  if (pred.fallthrough) return false;

  for (const key of Object.keys(pred)) {
    const val = pred[key];
    switch (key) {
      case 'src':
        if (item.src !== val) return false;
        break;
      case 'matchesRegex': {
        const re = _compileRegex(resolveConfigRef(val, rt), 'i');
        if (!re || !re.test(text)) return false;
        break;
      }
      case 'textContainsAny': {
        const arr = resolveConfigRef(val, rt) || [];
        let hit = false;
        for (const s of arr) if (lower.includes(String(s).toLowerCase())) { hit = true; break; }
        if (!hit) return false;
        break;
      }
      case 'startsWithAny': {
        const arr = resolveConfigRef(val, rt) || [];
        let hit = false;
        for (const s of arr) if (text.startsWith(s)) { hit = true; break; }
        if (!hit) return false;
        break;
      }
      case 'docsMentionGt': {
        const docs = extractDocs(text, validDocs, rt);
        if (!(docs.length > val)) return false;
        break;
      }
      case 'docsMentionEq': {
        const docs = extractDocs(text, validDocs, rt);
        if (docs.length !== val) return false;
        break;
      }
      case 'docsMentionGte': {
        const n = typeof val === 'string' ? resolveConfigRef(val, rt) : val;
        if (typeof n !== 'number') return false;
        const docs = extractDocs(text, validDocs, rt);
        if (!(docs.length >= n)) return false;
        break;
      }
      case 'testRelated':
        if (!isTestRelated({ text }, rt)) return false;
        break;
      case 'notTestRelated':
        if (isTestRelated({ text }, rt)) return false;
        break;
      case 'isRoutine':
        if (!isRoutine(text, rt)) return false;
        break;
      case 'commitFileMatchesPrefix': {
        const prefixes = resolveConfigRef(val, rt) || [];
        const files = item.filesChanged || [];
        if (files.length === 0) return false;
        let matched = false;
        for (const fullPath of files) {
          const basename = fullPath.split('/').pop();
          if (!basename || basename.length < 3) continue;
          const re = new RegExp(`(?:^|[\\s\`])${basename.replace(/[.+?^${}()|[\]\\]/g, '\\$&')}(?![\\w-])`);
          if (!re.test(text)) continue;
          const pathLower = fullPath.toLowerCase();
          for (const p of prefixes) {
            if (pathLower.includes(p)) { matched = true; item._matchedInfraPrefix = p; break; }
          }
          if (matched) break;
        }
        if (!matched) return false;
        break;
      }
      case 'allCommitFilesUnder': {
        const prefixes = resolveConfigRef(val, rt) || [];
        const files = item.filesChanged || [];
        if (files.length === 0) return false;
        const matchedPrefixes = [];
        let allMatched = true;
        for (const fullPath of files) {
          const pathLower = fullPath.toLowerCase();
          let found = null;
          for (const p of prefixes) {
            if (pathLower.includes(p)) { found = p; break; }
          }
          if (!found) { allMatched = false; break; }
          matchedPrefixes.push(found);
        }
        if (!allMatched) return false;
        // Record dominant prefix for later H5 strategy use
        const counts = {};
        for (const p of matchedPrefixes) counts[p] = (counts[p] || 0) + 1;
        let dom = matchedPrefixes[0], c = counts[dom];
        for (const p of matchedPrefixes) if (counts[p] > c) { dom = p; c = counts[p]; }
        item._matchedInfraPrefix = dom;
        break;
      }
      case 'flag': {
        const v = resolveConfigRef(val, rt);
        if (!v) return false;
        break;
      }
      default:
        // Unknown key — fail closed
        return false;
    }
  }
  return true;
}

// Does a predicate (possibly nested in anyOf/allOf) contain `fallthrough: true`?
function predicateHasFallthrough(pred) {
  if (!pred || typeof pred !== 'object') return false;
  if (pred.fallthrough === true) return true;
  if (Array.isArray(pred.anyOf)) return pred.anyOf.some(predicateHasFallthrough);
  if (Array.isArray(pred.allOf)) return pred.allOf.some(predicateHasFallthrough);
  return false;
}

// Drive the per-H4 inclusion across all bullets. Returns a Map of
// h4Id → array of item objects (same shape as input items, possibly annotated
// with `_matchedInfraPrefix` and/or `_docFilename` for H5 strategies).
//
// Two-pass semantics:
//   1. First pass — evaluate each H4's include predicate against every bullet.
//      The `fallthrough` combinator returns false here (it's not a content
//      predicate). A bullet can match multiple H4s and is emitted to each.
//   2. Fallthrough pass — for bullets that matched NO H4 in pass 1, emit them
//      to the first H4 whose include predicate contains `fallthrough: true`
//      (possibly nested in anyOf/allOf). This catches bullets that have no
//      structural signals and nowhere else to go (typically → Work Effort).
function computeH4Buckets(items, ctx) {
  const { rt, h4Sections, skipFilter, validDocs } = ctx;
  const buckets = {};
  for (const h of h4Sections) buckets[h.id] = [];

  const fallthroughSection = h4Sections.find((h) => predicateHasFallthrough(h.include));

  for (const item of items) {
    // Skip filter
    if (skipFilter && evalPredicate(skipFilter, item, ctx)) continue;

    let matchedAny = false;
    for (const h of h4Sections) {
      // Clone per-bullet per-section so predicate side-effects (e.g.
      // _matchedInfraPrefix) don't leak across sections.
      const sideItem = Object.assign({}, item);
      const hit = evalPredicate(h.include, sideItem, ctx);
      if (!hit) continue;
      matchedAny = true;

      // For doc H4: attach list of mentioned docs so h5Strategy="docFilename"
      // can produce one entry per doc. This preserves the v1 behavior of
      // multiple H5s for a single bullet.
      if (h.h5Strategy === 'docFilename') {
        const docs = extractDocs(item.text || '', validDocs, rt);
        if (docs.length === 0) continue;
        for (const fn of docs) {
          const copy = Object.assign({}, sideItem);
          copy._docFilename = fn;
          buckets[h.id].push(copy);
        }
      } else {
        buckets[h.id].push(sideItem);
      }
    }

    // Fallthrough: item matched nothing → dump into the fallthrough H4.
    if (!matchedAny && fallthroughSection) {
      buckets[fallthroughSection.id].push(Object.assign({}, item));
    }
  }

  // Per-H4 dedup by exact bullet text (+ per-doc filename for docFilename)
  for (const h of h4Sections) {
    const seen = new Set();
    buckets[h.id] = buckets[h.id].filter((it) => {
      const key = h.h5Strategy === 'docFilename'
        ? `${it._docFilename}::${it.text}`
        : it.text;
      if (seen.has(key)) return false;
      seen.add(key);
      return true;
    });
  }

  return buckets;
}

// ────────────────────────────────────────────────────────────────────────────
// H5 / H6 strategies — named functions looked up by config.
// Each strategy takes an item and ctx, returns the H5 (string) key.
// ────────────────────────────────────────────────────────────────────────────

const H5_STRATEGIES = {
  emDashOrFirstWord(item) {
    const text = item.text || '';
    const idx = text.indexOf(' — ');
    if (idx > 0) return text.slice(0, idx).replace(/[,:;]$/, '');
    return (text.split(/\s+/)[0] || '(misc)').replace(/[,:;—]$/, '');
  },
  firstWord(item) {
    const text = item.text || '';
    return (text.split(/\s+/)[0] || '(misc)').replace(/[,:;—]$/, '');
  },
  infraGroupLabels(item, ctx) {
    const labels = (ctx.rt.reroute && ctx.rt.reroute.infraGroupLabels) || {};
    const prefixes = (ctx.rt.reroute && ctx.rt.reroute.infraPrefixes) || [];
    const wordPrefixes = (ctx.rt.reroute && ctx.rt.reroute.infraPrefixWords) || [];
    const text = item.text || '';
    const lower = text.toLowerCase();

    if (item._matchedInfraPrefix) return labels[item._matchedInfraPrefix] || item._matchedInfraPrefix;

    // startsWithAny from infraPrefixWords
    for (const w of wordPrefixes) {
      if (text.startsWith(w)) return labels[w] || w;
    }
    // Text scan for infraPrefixes
    for (const p of prefixes) {
      if (lower.includes(p)) return labels[p] || p;
    }
    // Slash-skill synthetic routing
    const slashRe = (ctx.rt.reroute && ctx.rt.reroute.slashSkillRe)
      ? new RegExp(ctx.rt.reroute.slashSkillRe) : null;
    if (slashRe && slashRe.test(text)) {
      return labels['.claude/skills/'] || 'Skills';
    }
    // First path token fallback
    const dm = text.match(/^([a-zA-Z0-9_-]+\/)(?:[^\s]*)/);
    return dm ? dm[1] : '(other)';
  },
  docFilename(item) {
    return item._docFilename || '(other)';
  },
  codePrefix(item, ctx) {
    const rr = ctx.rt.reroute || {};
    const re = rr.codePrefixRe ? new RegExp(rr.codePrefixRe) : null;
    if (re) {
      const m = (item.text || '').match(re);
      if (m) return m[1];
    }
    return '(other)';
  },
  dbBulletPrefix(item, ctx) {
    const rr = ctx.rt.reroute || {};
    const text = item.text || '';
    for (const w of (rr.dbBulletPrefixWords || [])) {
      if (text.startsWith(w)) return w.replace(/:$/, '');
    }
    for (const p of (rr.dbPathPrefixes || [])) {
      if (text.toLowerCase().includes(p)) return p.replace(/\/$/, '');
    }
    return '(other)';
  },
  testingPath(item) {
    const text = item.text || '';
    const e = extractWorkTag(text);
    if (e) return e.tag;
    const dm = text.match(/^([a-zA-Z0-9_-]+\/)(?:[^\s]*)/);
    if (dm) return dm[1];
    return 'Untagged';
  },
  tagOrUntagged(item) {
    const e = extractWorkTag(item.text || '');
    return e ? e.tag : 'Untagged';
  },
};

const H6_STRATEGIES = {
  testingSubdir(item) {
    const m = (item.text || '').match(/^tests\/([a-zA-Z0-9_-]+)/);
    return m ? `tests/${m[1]}/` : 'tests/';
  },
};

// Emit Block Progress body for a single block (or sub-phase). When every
// commit contributed a `Block-summary:`, render deterministic bullets in
// commit order. Otherwise emit a `<!--BLOCK_PARAGRAPH:NAME-->` placeholder
// for the skill to fill via LLM synthesis over the work-effort bullets.
function emitBlockBody(lines, bp, placeholderName) {
  const hashes = bp.commitHashes || [];
  const summaries = bp.blockSummaries || [];
  const allPresent = hashes.length > 0
    && summaries.length === hashes.length
    && summaries.every(s => s && s.summary);
  if (allPresent) {
    for (const s of summaries) {
      lines.push(`- ${s.summary}`);
    }
  } else {
    lines.push(`<!--BLOCK_PARAGRAPH:${placeholderName}-->`);
  }
}

function renderTimecardMarkdown(data, renderConfig) {
  const rt = renderConfig.rt || {};
  const billingCode = (renderConfig.billing && renderConfig.billing.currentCode) || 'SOW-01';
  const validDocs = collectValidDocs(rt);

  const lines = [];

  if (data.skippedConvs && data.skippedConvs.length) {
    lines.push('### Skipped Convs');
    for (const s of data.skippedConvs) lines.push(`- Conv ${s.conv} — ${s.reason}`);
    lines.push('');
  }
  if (data.warnings && data.warnings.length) {
    lines.push('### Warnings');
    for (const w of data.warnings) lines.push(`- ${w}`);
    lines.push('');
  }

  const dt = data.window.startISO ? new Date(data.window.startISO) : new Date(data.date + 'T12:00:00Z');
  const dayTitle = `${MONTHS_ABBR[dt.getMonth()]} ${dt.getDate()}, ${dt.getFullYear()}`;
  const machines = [...new Set(data.commits.map(c => c.machine).filter(Boolean))].join(', ');
  let adjust = `-${data.billing.adjustMinRounded}`;
  if (data.overflow) {
    const ovDt = new Date(data.overflow.nextDayEndISO);
    adjust += ` +? (next day overflow — end commit at ${fmtHHMM(ovDt)} next day)`;
  }
  if (data.adHocCount > 0) adjust += ` (${data.adHocCount} ad hoc commit(s) detected)`;

  lines.push(`### 🕒 Timecard • ⚽️ Coding • ${dayTitle} • ${data.window.startShort} to ${data.window.endShort}`);
  lines.push('- `Tools  `:: [[Claude Code]]');
  lines.push(`- \`Machine\`:: ${machines}`);
  lines.push(`- \`Start  \`:: ${data.window.startShort}`);
  lines.push(`- \`End    \`:: ${data.window.endShort}`);
  lines.push(`- \`Adjust \`:: ${adjust}`);
  lines.push(`- \`Billable\`:: ${data.billing.billableHHMM}`);
  lines.push(`- \`Bill?  \`:: ${billingCode}`);
  lines.push(`- \`Convs  \`:: ${data.convs.join(', ')}`);
  lines.push(`- \`Blocks \`:: ${data.blocks.join(', ')}`);

  // Build a unified bullet pool. For each v2 commit, prefer its parsed v2Bullets
  // (H3-section-tagged with src). For v1 commits, flatten tags + workEffort.
  // Commits are made available on `data.commits`; filesChanged is indexed
  // separately since JSON commit rows omit it to keep the blob small.
  const filesByHash = {};
  for (const c of data.commits) filesByHash[c.hash] = c._filesChanged || [];

  const input = [];
  for (const c of data.commits) {
    if (c.isHeartbeat) continue;
    const files = filesByHash[c.hash] || [];
    if (c._v2Bullets && c._v2Bullets.length > 0) {
      for (const b of c._v2Bullets) {
        input.push({ src: b.src, text: b.text, hash: c.hash, filesChanged: files });
      }
    } else {
      // v1 path — pull from commit tags + work-effort bullets.
      const tags = c.tags || {};
      for (const [srcId, lines] of Object.entries(tags)) {
        for (const t of lines) input.push({ src: srcId, text: t, hash: c.hash, filesChanged: files });
      }
      for (const b of (c.workEffortBullets || [])) {
        input.push({ src: 'workEffort', text: b, hash: c.hash, filesChanged: files });
      }
    }
  }

  // Run the per-H4 predicate engine
  const h4Sections = loadCfg().h4Sections;
  const skipFilter = loadCfg().skipFilter;
  const ctx = { rt, validDocs, h4Sections, skipFilter };
  const buckets = computeH4Buckets(input, ctx);

  function renderBullet(item, outerKey, isWorkEffort) {
    let text = item.text;
    if (isWorkEffort && outerKey !== 'Untagged') {
      const e = extractWorkTag(text);
      if (e && e.stripPrefix) text = text.replace(loadCfg().render.tagRe, '').trim();
    }
    const hashSuffix = isWorkEffort && item.hash ? `  (${item.hash})` : '';
    lines.push(`- ${fixAngleBrackets(text)}${hashSuffix}`);
  }

  for (const h of h4Sections) {
    const items = buckets[h.id] || [];
    if (items.length === 0) continue;

    const isWorkEffort = h.id === 'workEffort' || h.id === 'code' || h.id === 'db' || h.id === 'testing';
    // (hashSuffix only applies to items with a hash — work-effort-flavored H4s)

    const h5Fn = H5_STRATEGIES[h.h5Strategy] || H5_STRATEGIES.firstWord;
    const h6Spec = h.h6 || null;
    const h6Fn = h6Spec ? H6_STRATEGIES[h6Spec.strategy] : null;

    const grouped = groupByKey(items, (it) => h5Fn(it, ctx));
    const keys = Object.keys(grouped).sort();
    if (keys.length === 0) continue;

    lines.push(`#### ${h.title}`);
    for (const k of keys) {
      lines.push(`##### ${k}`);
      if (h6Fn && h6Spec && k === h6Spec.onH5) {
        const sub = groupByKey(grouped[k], (it) => h6Fn(it, ctx));
        for (const sk of Object.keys(sub).sort()) {
          lines.push(`###### ${sk}`);
          for (const item of sub[sk]) renderBullet(item, k, isWorkEffort);
        }
      } else {
        for (const item of grouped[k]) renderBullet(item, k, isWorkEffort);
      }
    }
  }

  // Block Progress — narrative from the Block dimension. Two render modes:
  //   (a) Deterministic: every commit in the block has a `Block-summary:`.
  //       Emit those sentences as bullets in commit order — no LLM step.
  //   (b) Fallback: any commit lacks a `Block-summary:` (legacy, or `(misc)`/
  //       `(no-block)` where summaries are optional). Emit a
  //       `<!--BLOCK_PARAGRAPH:NAME-->` placeholder; the skill synthesizes
  //       from bullets + commit subjects.
  //
  // `mergeBlockPattern` collapses sibling blocks (e.g. all "Phase 0.5 ..."
  // variants) into one H5 parent with H6 sub-phases; determinism is evaluated
  // per sub-phase, not per parent.
  if (data.blocks && data.blocks.length) {
    const { blocks: renderBlocks, blockProgress: renderBP } =
      applyBlockMerge(data.blocks, data.blockProgress, rt.mergeBlockPattern);
    lines.push('#### Block Progress');
    for (const blockName of renderBlocks) {
      const bp = renderBP[blockName];
      lines.push(`##### ${blockName}  ·  ${bp.billableMin}m allocated`);
      if (bp.subPhases && bp.subPhases.length > 0) {
        for (const sp of bp.subPhases) {
          lines.push(`###### ${sp.displayName}  ·  ${sp.billableMin}m`);
          emitBlockBody(lines, sp, sp.name);
        }
      } else {
        emitBlockBody(lines, bp, blockName);
      }
    }
  }

  // Per-Commit Audit (P1)
  lines.push('');
  lines.push('---');
  lines.push('');
  lines.push('#### Per-Commit Audit (P1)');
  lines.push('');
  lines.push('| # | Time | Conv | Repo | Hash | Slot | Block(s) | Subject |');
  lines.push('|---|------|------|------|------|------|----------|---------|');
  let auditI = 1;
  for (const c of data.commits) {
    let slot;
    if (c.isHeartbeat) slot = '(heartbeat)';
    else if (c.isAdHoc) slot = '(ad-hoc)';
    else slot = `${c.slotMin}m`;
    if (c.isOverflow) slot += ' (next day)';
    const blocks = c.blocksRaw && c.blocksRaw.length ? c.blocksRaw.join(', ') : '—';
    const conv = c.conv || '—';
    const subject = fixAngleBrackets((c.subject || '')).replace(/\|/g, '\\|');
    lines.push(`| ${auditI} | ${c.timeShort} | ${conv} | ${c.repo} | ${c.hash} | ${slot} | ${blocks} | ${subject} |`);
    auditI++;
  }
  lines.push('');
  const unallocated = data.window.totalMin - data.billing.billableMinRaw;
  lines.push(`#### **Slot totals:** ${data.billing.billableMinRaw}m allocated to commits + ${unallocated}m unallocated (inter-Conv gaps + ad-hoc) = ${data.window.totalMin}m day window.`);

  return lines.join('\n') + '\n';
}

function sortCommitsStable(commits) {
  return [...commits].sort((a, b) => {
    if (a.timestampMs !== b.timestampMs) return a.timestampMs - b.timestampMs;
    if (a.repo !== b.repo) return a.repo.localeCompare(b.repo); // 'code' before 'docs'
    return a.hash.localeCompare(b.hash);
  });
}

// ────────────────────────────────────────────────────────────────────────────
// Main
// ────────────────────────────────────────────────────────────────────────────

function main() {
  const args = parseArgs(process.argv);
  if (!args.date) {
    process.stderr.write('Usage: node timecard-day.js <date> [--exclude-branches "br1 br2"]\n');
    process.exit(1);
  }

  let targetDate;
  try {
    targetDate = parseDate(args.date);
  } catch (e) {
    process.stderr.write(e.message + '\n');
    process.exit(1);
  }

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  if (targetDate.getTime() > today.getTime()) {
    process.stderr.write(`Could not parse date or date in future: ${args.date}\n`);
    process.exit(1);
  }

  const { since, until, untilDate } = fmtSinceUntil(targetDate);
  const repos = getRepos();
  const headBranchByRepo = {};
  for (const r of repos) {
    if (repoExists(r.root)) headBranchByRepo[r.name] = getHeadBranch(r.root);
  }

  const candidateBranches = discoverCandidateBranches(repos, since, until);
  const selectedBranches = candidateBranches.filter((b) => !args.excludeBranches.includes(b.branch));

  // Extract commits
  let allCommits = [];
  for (const sel of selectedBranches) {
    const repo = repos.find((r) => r.name === sel.repo);
    const cs = extractCommitsFromBranch(repo.root, repo.name, sel.branch, since, until);
    allCommits = allCommits.concat(cs);
  }

  // De-dup + parse metadata
  allCommits = dedupCommits(allCommits, headBranchByRepo);
  allCommits = sortCommitsStable(allCommits);
  for (const c of allCommits) parseMetadata(c);

  // Build Conv timeline
  const { validConvs, skippedConvs, adhocCommits, warnings } = buildConvTimeline(allCommits);

  // Detect overflow (looks for next-day work commits matching last Conv)
  const overflow = detectOverflow(validConvs, repos, untilDate);

  // If overflow has next-day commits, fetch them and inject into appropriate Conv
  let overflowExtras = [];
  if (overflow) {
    const grep = `Conv ${overflow.conv}`;
    const sinceNext = `${fmtYMD(untilDate)} 00:00:00`;
    const untilNext = fmtNextDayUntil(untilDate);
    for (const repo of repos) {
      if (!repoExists(repo.root)) continue;
      const out = gitOut(repo.root, [
        'log',
        '--all',
        `--grep=${grep}`,
        `--format=${COMMIT_DELIM}%n%H%n%h%n%ci%n%s%n%b%n${END_DELIM}`,
        `--since=${sinceNext}`,
        `--until=${untilNext}`,
        '--reverse',
      ]);
      const cs = parseCommitStream(out, repo.name, headBranchByRepo[repo.name] || 'main');
      // Filter to non-heartbeat, matching this Conv
      for (const c of cs) {
        parseMetadata(c);
        if (!c.isHeartbeat && c.conv === overflow.conv) overflowExtras.push(c);
      }
    }
    // Add overflow commits to the matching Conv
    const lastConv = validConvs.find((v) => v.conv === overflow.conv);
    if (lastConv) {
      for (const oc of overflowExtras) {
        oc.isOverflow = true;
        lastConv.workCommits.push(oc);
      }
      lastConv.workCommits.sort((a, b) => a.timestampMs - b.timestampMs);
    }
  }

  // Allocate slots
  allocateSlots(validConvs, adhocCommits, overflow);

  // Build aggregations from work + ad-hoc commits (heartbeats excluded from bullets)
  const workCommits = validConvs.flatMap((v) => v.workCommits);
  const allWorkAndAdhoc = sortCommitsStable([...workCommits, ...adhocCommits]);
  const allCommitsIncludingHeartbeats = sortCommitsStable([
    ...validConvs.map((v) => v.heartbeat),
    ...workCommits,
    ...adhocCommits,
  ]);

  const blockProgress = buildBlockProgress(allWorkAndAdhoc);
  const blocks = blocksFirstTouchOrder(allWorkAndAdhoc);
  const dayTags = buildDayTags(allWorkAndAdhoc);
  const dayWorkEffort = buildDayWorkEffort(allWorkAndAdhoc);

  // Day window
  let windowStartMs = null;
  let windowEndMs = null;
  if (allCommitsIncludingHeartbeats.length > 0) {
    windowStartMs = allCommitsIncludingHeartbeats[0].timestampMs;
    windowEndMs = allCommitsIncludingHeartbeats[allCommitsIncludingHeartbeats.length - 1].timestampMs;
  }
  // Apply 22:00 cap to window end if overflow extends past it
  if (overflow && overflow.capMs !== null && windowEndMs !== null && windowEndMs > overflow.capMs) {
    windowEndMs = overflow.capMs;
  }

  const windowTotalMin = windowStartMs !== null && windowEndMs !== null
    ? Math.round((windowEndMs - windowStartMs) / 60000)
    : 0;

  // Day billable = sum of all slots (per-Block billableMin double-counts multi-Block — use commit list instead)
  const billableMinRaw = workCommits.reduce((sum, c) => sum + c.slotMin, 0);

  const windowTotalMinRounded = roundToNearest5(windowTotalMin);
  const billableMinRounded = roundToNearest5(billableMinRaw);
  const adjustMinRounded = Math.max(0, windowTotalMinRounded - billableMinRounded);

  // Convs in chronological order
  const convsList = [...validConvs]
    .sort((a, b) => a.heartbeat.timestampMs - b.heartbeat.timestampMs)
    .map((v) => v.conv);

  // Build commit list for JSON output.
  // `_filesChanged` and `_v2Bullets` are underscored because they're consumed
  // internally by renderTimecardMarkdown; downstream tooling should not rely
  // on their presence.
  const jsonCommits = allCommitsIncludingHeartbeats.map((c) => ({
    timestampISO: c.timestampISO,
    timeShort: c.timeShort,
    repo: c.repo,
    branch: c.branch,
    hash: c.hash,
    fullHash: c.fullHash,
    conv: c.conv,
    isHeartbeat: !!c.isHeartbeat,
    isAdHoc: !!c.isAdHoc,
    isOverflow: !!c.isOverflow,
    blocksRaw: c.blocksRaw || [],
    blocksNormalized: c.blocksNormalized || [],
    slotStartISO: c.slotStartISO || null,
    slotMin: c.slotMin || 0,
    machine: c.machine,
    type: c.type || null,
    format: c.format || null,
    blockSummary: c.blockSummary || null,
    subject: c.subject,
    tags: c.tags,
    workEffortBullets: c.workEffortBullets || [],
    _filesChanged: c.filesChanged || [],
    _v2Bullets: c.v2Bullets || null,
  }));

  const out = {
    date: fmtYMD(targetDate),
    candidateBranches,
    window: {
      startISO: windowStartMs !== null ? new Date(windowStartMs).toISOString() : null,
      endISO: windowEndMs !== null ? new Date(windowEndMs).toISOString() : null,
      startShort: windowStartMs !== null ? fmtHHMM(new Date(windowStartMs)) : null,
      endShort: windowEndMs !== null ? fmtHHMM(new Date(windowEndMs)) : null,
      totalMin: windowTotalMin,
      totalMinRounded: windowTotalMinRounded,
    },
    billing: {
      billableMinRaw,
      billableMinRounded,
      adjustMinRounded,
      billableHHMM: fmtHoursMin(billableMinRounded),
      adjustHHMM: fmtHoursMin(adjustMinRounded),
    },
    convs: convsList,
    blocks,
    adHocCount: adhocCommits.length,
    skippedConvs,
    overflow: overflow ? {
      conv: overflow.conv,
      nextDayEndISO: overflow.nextDayEndISO,
      capAt: overflow.capAt,
    } : null,
    warnings,
    commits: jsonCommits,
    blockProgress,
    dayTags,
    dayWorkEffort,
  };

  out.renderedMarkdown = renderTimecardMarkdown(out, loadRenderConfig());

  process.stdout.write(JSON.stringify(out, null, 2) + '\n');
}

main();
