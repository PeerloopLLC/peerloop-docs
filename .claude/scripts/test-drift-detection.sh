#!/bin/bash
# test-drift-detection.sh — Phase 2 integration test for DOC-SYNC-STRATEGY
#
# Verifies that the three drift tools all read from docsRegistry correctly and
# surface a known change as expected. Not a CI check yet (that's Phase 3) —
# just a one-shot harness for Phase 2 exit criterion.
#
# Tests:
#   1. docs-registry.mjs loads and emits expected fields.
#   2. tech-doc-sweep.sh matches rules using the FULL codePattern alternation
#      (regression test for the pre-Phase-2 truncation bug).
#   3. sync-gaps.sh shared-basenames are loaded from the registry (verifies
#      the `$SHARED_BASENAMES_PATTERN` integration works).
#
# Exit 0 if all pass, 1 if any fail.

set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
REGISTRY="$HERE/docs-registry.mjs"
TECH_SWEEP="$HERE/tech-doc-sweep.sh"
SYNC_GAPS="$HERE/sync-gaps.sh"

fail=0
pass() { echo "  ✅ $1"; }
fail() { echo "  ❌ $1"; fail=1; }

echo "## Phase 2 drift-detection integration test"
echo ""

# ── Test 1: registry sanity ──────────────────────────────────────────
echo "### 1. docs-registry.mjs"
rule_count=$(node "$REGISTRY" vendor-rules | wc -l | tr -d ' ')
if [[ "$rule_count" -ge 10 ]]; then
  pass "vendor-rules emits $rule_count rules"
else
  fail "expected ≥10 vendor rules, got $rule_count"
fi

basename_count=$(node "$REGISTRY" test-shared-basenames | wc -l | tr -d ' ')
if [[ "$basename_count" -ge 5 ]]; then
  pass "test-shared-basenames emits $basename_count basenames"
else
  fail "expected ≥5 shared basenames, got $basename_count"
fi

group_count=$(node "$REGISTRY" list-groups | wc -l | tr -d ' ')
if [[ "$group_count" -ge 15 ]]; then
  pass "list-groups emits $group_count groups"
else
  fail "expected ≥15 groups, got $group_count"
fi

# ── Test 2: tech-doc-sweep full-alternation matching ──────────────────
echo ""
echo "### 2. tech-doc-sweep.sh (regression: codePattern alternation)"

# Inject a code change that matches the THIRD alternation in the booking rule
# (rule: "booking|availability|calendar"). Pre-Phase-2 bug truncated to "booking"
# only, so a file named "src/lib/calendar-util.ts" would NOT have flagged anything.
# Post-migration, it should flag docs matching the calendar keyword.
out=$(CODE_CHANGES_OVERRIDE="src/lib/calendar-util.ts" "$TECH_SWEEP" 2>&1)
if echo "$out" | grep -q "react-big-calendar.md\|availability-calendar.md"; then
  pass "calendar-util.ts change flags a calendar/availability doc (full alternation works)"
else
  fail "expected calendar-util.ts change to flag calendar/availability docs — got:"
  echo "$out" | sed 's/^/      /'
fi

# Inject the LAST alternation in the video/bbb rule (pre-Phase-2: silently ignored).
out=$(CODE_CHANGES_OVERRIDE="src/lib/plugnmeet-client.ts" "$TECH_SWEEP" 2>&1)
if echo "$out" | grep -q "plugnmeet.md\|bigbluebutton.md"; then
  pass "plugnmeet-client.ts change flags a video/bbb doc (full alternation works)"
else
  fail "expected plugnmeet-client.ts change to flag video/bbb docs — got:"
  echo "$out" | sed 's/^/      /'
fi

# Negative control: a non-matching file should produce no flags.
out=$(CODE_CHANGES_OVERRIDE="src/pages/api/totally/unrelated.ts" "$TECH_SWEEP" 2>&1)
if echo "$out" | grep -q "No reference/as-designed docs flagged"; then
  pass "unrelated change produces no flags (negative control)"
else
  fail "unrelated change should not flag anything — got:"
  echo "$out" | sed 's/^/      /'
fi

# ── Test 3: sync-gaps.sh shared-basenames integration ─────────────────
echo ""
echo "### 3. sync-gaps.sh (registry-driven shared-basenames)"

# The script loads SHARED_BASENAMES_PATTERN from the registry at startup.
# We can verify the integration by checking that the script runs cleanly
# and produces its normal "all synced" report — any JSON parse / registry
# load failure would break the script output.
out=$("$SYNC_GAPS" 2>&1)
if echo "$out" | grep -q "## Documentation Sync Gaps"; then
  pass "sync-gaps.sh produces its normal header"
else
  fail "sync-gaps.sh header missing — likely registry integration broken:"
  echo "$out" | tail -5 | sed 's/^/      /'
fi

if ! echo "$out" | grep -qi "error\|unbound variable\|command not found"; then
  pass "sync-gaps.sh produced no error/unbound-var/not-found messages"
else
  fail "sync-gaps.sh emitted error output:"
  echo "$out" | grep -i "error\|unbound\|not found" | sed 's/^/      /'
fi

# ── Summary ───────────────────────────────────────────────────────────
echo ""
if [[ $fail -eq 0 ]]; then
  echo "✅ All drift-detection integration tests passed."
  exit 0
else
  echo "❌ One or more tests failed."
  exit 1
fi
