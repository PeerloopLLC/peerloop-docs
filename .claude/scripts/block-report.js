#!/usr/bin/env node
// ────────────────────────────────────────────────────────────────────────────
// block-report.js — billing roll-up over the Peerloop coding-timecard notes
// that /r-timecard-day writes to the Obsidian vault, emitted as a .scratch
// markdown report + a .scratch .tsv.
//
// Ported from the SPT `block-report.js` (spt-docs), adjusted to fit Peerloop:
//   - Source is the standalone coding notes under rTimecardDay.vaultPath
//     (Peerloop uses `vaultPath`; SPT used `outputDir`), filtered by the
//     `Bill?` field (a Block code, e.g. Block-09 — the default invoice).
//   - Peerloop coding timecards carry a DIFFERENT inline-field schema than
//     SPT's meeting/slack cards: Focus / Start / End / Adjust / Billable /
//     Bill? / Convs / Blocks — no Channel/Who/Via/Slack. The default column
//     set reflects that (see DEFAULT_COLUMNS).
//   - `Hours` is derived from the authoritative `Billable` field (the
//     slot-rounded, overflow-capped billing time the timecard-day script
//     computes, e.g. `7h10`), NOT a naive End−Start+Adjust recompute. When a
//     card has no Billable field we fall back to computing from Start/End/
//     Adjust (SPT's original math) so older cards still report.
//   - Filenames are `Peerloop Timecard • Coding • <Mon D, YYYY> • <HHMM>.md`
//     (natural date, no ISO prefix) — the date parser handles that shape plus
//     ISO and Mon-DD-YYYY fallbacks.
//   - Output goes to .scratch/ as files, not rendered in an Obsidian pane
//     (the scratch .md lives outside the vault, so Date is plain text).
//
// Usage:
//   node block-report.js [INVOICE] [--sort asc|desc] [--all] [--source DIR] [--out-dir DIR]
//   INVOICE   Bill? value to filter on (default: config billing.currentCode, e.g. Block-09)
//   --all     Ignore the invoice filter (match every timecard)
//   --sort    Date order (default: asc = oldest first)
//
// Exit codes: 0 ran · 1 usage/config error · 4 no matching timecards
// ────────────────────────────────────────────────────────────────────────────

'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');

const MONTHS_ABBR = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const MONTH_INDEX = Object.fromEntries(MONTHS_ABBR.map((m, i) => [m, i]));

// Canonical column order for the Peerloop coding report. usedColumns drops the
// ones with no data, preserving relative order. Date…Bill? is the billing
// spine; Convs/Blocks are the Peerloop-specific narrative columns appended
// after it.
const DEFAULT_COLUMNS = ['Date', 'Focus', 'Start', 'End', 'Adjust', 'Hours',
  'Bill?', 'Convs', 'Blocks'];

const DOCS_ROOT = path.resolve(__dirname, '..', '..');

function expandTilde(p) {
  if (!p) return p;
  if (p === '~') return os.homedir();
  if (p.startsWith('~/')) return path.join(os.homedir(), p.slice(2));
  return p;
}

function loadConfig() {
  const configPath = path.join(DOCS_ROOT, '.claude', 'config.json');
  let cfg = {};
  try { cfg = JSON.parse(fs.readFileSync(configPath, 'utf8')); } catch { cfg = {}; }
  const rt = cfg.rTimecardDay || {};
  const rb = cfg.rBlockReport || {};
  return {
    // Peerloop uses rTimecardDay.vaultPath; keep outputDir as a fallback so a
    // config that follows the SPT naming still resolves.
    sourceDir: expandTilde(rb.sourceDir || rt.vaultPath || rt.outputDir),
    columns: rb.columns || DEFAULT_COLUMNS,
    scratchDir: path.resolve(DOCS_ROOT, rb.scratchDir || '.scratch'),
    projectLabel: rb.projectLabel || 'Peerloop',
    defaultInvoice: (cfg.billing && cfg.billing.currentCode) || 'Block-09',
  };
}

// ── Field / value helpers ────────────────────────────────────────────────────

function escapeTsvValue(value) {
  if (!value) return '';
  return String(value).replace(/\t/g, ' ').replace(/[\r\n]+/g, ' ');
}

function formatExportDateTime(date) {
  const month = MONTHS_ABBR[date.getMonth()];
  const day = String(date.getDate()).padStart(2, '0');
  const year = date.getFullYear();
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  return `${month}-${day}-${year} ${hours}_${minutes}`;
}

function parseTimeToMinutes(timeStr) {
  if (!timeStr) return null;
  const m = String(timeStr).match(/^(\d{1,2}):(\d{2})$/);
  if (!m) return null;
  return parseInt(m[1], 10) * 60 + parseInt(m[2], 10);
}

// Peerloop's authoritative billed time: `Billable` is rendered as `<H>h<MM>`
// (e.g. `7h10`, `14h55`). Convert to decimal hours (2dp). Returns null if the
// field is absent or unparseable.
function billableToHours(billable) {
  if (!billable) return null;
  const m = String(billable).trim().match(/^(\d+)h(\d{1,2})$/);
  if (!m) return null;
  const mins = parseInt(m[1], 10) * 60 + parseInt(m[2], 10);
  return Math.round((mins / 60) * 100) / 100;
}

// Fallback for cards with no Billable field: naive End−Start+Adjust (SPT math).
function calculateHours(start, end, adjust) {
  const s = parseTimeToMinutes(start);
  const e = parseTimeToMinutes(end);
  if (s === null || e === null) return null;
  let dur = e - s;
  if (dur < 0) dur += 24 * 60;          // overnight wrap
  dur += parseInt(adjust, 10) || 0;     // parseInt stops at trailing annotations
  return Math.round((dur / 60) * 100) / 100;
}

function isRelevantTimecard(tc, invoiceString) {
  if (!invoiceString || invoiceString.trim() === '') return true;
  const bill = tc['Bill?'] || '';
  return bill.toUpperCase() === invoiceString.toUpperCase();
}

function stripLinks(v) {
  return v
    .replace(/\[\[([^\]|]+)\|([^\]]+)\]\]/g, '$2')
    .replace(/\[\[([^\]]+)\]\]/g, '$1');
}

// ── Scanning ─────────────────────────────────────────────────────────────────

// Extract the display Date + sortable ISO from a note filename. Peerloop notes
// are named "Peerloop Timecard • Coding • Mon D, YYYY • HHMM.md" (natural date,
// e.g. "Aug 10, 2026"). We also accept an ISO prefix or a bare Mon-DD-YYYY
// anywhere in the name as fallbacks.
function dateFromFilename(name) {
  // Primary: "Mon D, YYYY" (e.g. "Aug 10, 2026").
  const nat = name.match(/([A-Z][a-z]{2}) (\d{1,2}), (\d{4})/);
  if (nat) {
    const [, mon, d, y] = nat;
    const mi = MONTH_INDEX[mon];
    if (mi !== undefined) {
      const dd = String(parseInt(d, 10)).padStart(2, '0');
      return {
        iso: `${y}-${String(mi + 1).padStart(2, '0')}-${dd}`,
        display: `${mon} ${parseInt(d, 10)}, ${y}`,
      };
    }
  }
  // Fallback: ISO prefix.
  const iso = name.match(/^(\d{4})-(\d{2})-(\d{2})/);
  if (iso) {
    const [, y, mo, d] = iso;
    return { iso: `${y}-${mo}-${d}`, display: `${MONTHS_ABBR[parseInt(mo, 10) - 1]} ${parseInt(d, 10)}, ${y}` };
  }
  // Fallback: Mon-DD-YYYY anywhere in the name.
  const md = name.match(/([A-Z][a-z]{2})-(\d{1,2})-(\d{4})/);
  if (md) {
    const [, mon, d, y] = md;
    const dd = String(parseInt(d, 10)).padStart(2, '0');
    return { iso: `${y}-${String(MONTH_INDEX[mon] + 1).padStart(2, '0')}-${dd}`, display: `${mon} ${parseInt(d, 10)}, ${y}` };
  }
  return { iso: '0000-00-00', display: name.replace(/\.md$/, '') };
}

// Parse one note's content into timecard objects (normally exactly one for a
// Peerloop coding card).
function parseTimecards(content, fileBase, fileName) {
  const out = [];
  const lines = content.split('\n');
  const { iso, display } = dateFromFilename(fileName);

  let inTimecard = false;
  let cur = null;

  const flush = () => { if (cur && Object.keys(cur).length) out.push(cur); cur = null; inTimecard = false; };

  for (const line of lines) {
    // Peerloop coding heading: "### 🕒 Timecard • ⚽️ Coding • <date> • <times>".
    if (line.startsWith('### ') && line.includes('🕒 Timecard')) {
      flush();
      inTimecard = true;
      cur = { Date: display, _iso: iso, _fileBase: fileBase, _heading: line.substring(4).trim() };
      continue;
    }
    if (!inTimecard) continue;
    // Field lines end at the first sub-heading (#### User-facing etc.) or rule.
    if (/^#{1,6}\s/.test(line) || line.startsWith('---')) { flush(); continue; }
    const m = line.trim().startsWith('-') ? line.match(/`([^`]+)`\s*::\s*(.+)/) : null;
    if (m) cur[m[1].trim()] = stripLinks(m[2].trim());
  }
  flush();
  return out;
}

function scanTimecards(sourceDir) {
  let files;
  try {
    files = fs.readdirSync(sourceDir).filter(f => f.endsWith('.md'));
  } catch (e) {
    process.stderr.write(`[block-report] cannot read source dir: ${sourceDir}\n${e.message}\n`);
    process.exit(1);
  }
  const all = [];
  for (const f of files) {
    const content = fs.readFileSync(path.join(sourceDir, f), 'utf8');
    all.push(...parseTimecards(content, f.replace(/\.md$/, ''), f));
  }
  return all;
}

// ── Rendering ────────────────────────────────────────────────────────────────

function buildRows(timecards, invoice) {
  let rows = timecards.filter(tc => isRelevantTimecard(tc, invoice));
  for (const tc of rows) {
    // Prefer the authoritative Billable field; fall back to Start/End/Adjust.
    let h = billableToHours(tc['Billable']);
    if (h === null) h = calculateHours(tc['Start'], tc['End'], tc['Adjust']);
    tc['Hours'] = h !== null ? h : 0;
  }
  return rows;
}

function sortRows(rows, sortOrder) {
  return rows.sort((a, b) =>
    sortOrder === 'asc' ? a._iso.localeCompare(b._iso) : b._iso.localeCompare(a._iso));
}

function usedColumns(columns, rows) {
  return columns.filter(col => rows.some(tc => tc[col] !== undefined && tc[col] !== null && tc[col] !== ''));
}

function fmtCell(tc, col) {
  if (col === 'Hours') return (tc[col] !== null && tc[col] !== undefined) ? Number(tc[col]).toFixed(2) : '—';
  return (tc[col] === undefined || tc[col] === null || tc[col] === '') ? '—' : String(tc[col]);
}

function renderMarkdown(rows, cols, meta) {
  const L = [];
  L.push(`### Timecards: ${meta.project} • ${meta.invoice}`);
  L.push('');
  L.push(`Found ${rows.length} timecard(s)` +
    (meta.invoice ? ` • Filtered by: "${meta.invoice}"` : '') +
    ` • Sorted by date: ${meta.sortOrder === 'asc' ? 'oldest first' : 'newest first'}`);
  L.push('');
  L.push(`| ${cols.join(' | ')} |`);
  L.push(`|${cols.map(() => '---').join('|')}|`);
  for (const tc of rows) {
    L.push(`| ${cols.map(c => fmtCell(tc, c).replace(/\|/g, '\\|')).join(' | ')} |`);
  }
  L.push('');
  L.push(`**Total Billable Hours: ${meta.total.toFixed(2)}**`);
  L.push('');
  return L.join('\n');
}

function renderTsv(rows, cols) {
  const header = cols.join('\t');
  const body = rows.map(tc => cols.map(c => {
    if (c === 'Hours') return escapeTsvValue(fmtCell(tc, c));
    return escapeTsvValue(tc[c] || '');
  }).join('\t'));
  return [header, ...body].join('\n');
}

// ── Main ─────────────────────────────────────────────────────────────────────

function parseArgs(argv) {
  const a = { invoice: null, sort: 'asc', all: false, source: null, outDir: null };
  for (let i = 0; i < argv.length; i++) {
    const t = argv[i];
    if (t === '--sort') { a.sort = (argv[++i] || 'asc').toLowerCase() === 'desc' ? 'desc' : 'asc'; }
    else if (t === '--all') { a.all = true; }
    else if (t === '--source') { a.source = argv[++i]; }
    else if (t === '--out-dir') { a.outDir = argv[++i]; }
    else if (t.startsWith('--')) { process.stderr.write(`[block-report] unknown flag: ${t}\n`); process.exit(1); }
    else if (a.invoice === null) { a.invoice = t; }
  }
  return a;
}

function main() {
  const cfg = loadConfig();
  const args = parseArgs(process.argv.slice(2));
  const invoice = args.all ? '' : (args.invoice || cfg.defaultInvoice);
  const sourceDir = expandTilde(args.source) || cfg.sourceDir;
  const outDir = expandTilde(args.outDir) || cfg.scratchDir;

  if (!sourceDir) { process.stderr.write('[block-report] no source dir (set rTimecardDay.vaultPath or rBlockReport.sourceDir)\n'); process.exit(1); }

  const all = scanTimecards(sourceDir);
  let rows = buildRows(all, invoice);
  rows = sortRows(rows, args.sort);

  if (!rows.length) {
    process.stderr.write(`[block-report] no timecards match ${invoice ? `Bill? = "${invoice}"` : '(any)'} in ${sourceDir}\n`);
    process.exit(4);
  }

  const cols = usedColumns(cfg.columns, rows);
  const total = Math.round(rows.reduce((s, tc) => s + (tc['Hours'] || 0), 0) * 100) / 100;
  const meta = { project: cfg.projectLabel, invoice: invoice || '(all)', sortOrder: args.sort, total };

  const md = renderMarkdown(rows, cols, meta);
  const tsv = renderTsv(rows, cols);

  fs.mkdirSync(outDir, { recursive: true });
  const stamp = formatExportDateTime(new Date());
  const label = (invoice || 'ALL').replace(/[^\w.-]/g, '_');
  const mdPath = path.join(outDir, `block-report-${label} • ${stamp}.md`);
  const tsvPath = path.join(outDir, `block-report-${label} • ${stamp}.tsv`);
  fs.writeFileSync(mdPath, md + '\n');
  fs.writeFileSync(tsvPath, tsv + '\n');

  process.stderr.write(
    `[block-report] ${rows.length} timecard(s) • Bill? = ${invoice || '(all)'} • ${meta.total.toFixed(2)}h • columns: ${cols.join(', ')}\n`);
  process.stdout.write(mdPath + '\n');
  process.stdout.write(tsvPath + '\n');
}

main();
