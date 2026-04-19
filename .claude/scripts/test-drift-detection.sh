#!/bin/bash
# test-drift-detection.sh — Phase 2 integration test for DOC-SYNC-STRATEGY
#
# Verifies that the three drift tools all read from docsRegistry correctly and
# surface a known change as expected. Not a CI check yet (that's Phase 3) —
# just a one-shot harness for Phase 2 exit criterion.
#
# Tests:
#   1. docs-registry.mjs loads and emits expected fields.
#   2. tech-doc-sweep.sh full-alternation regression + Phase 4 [DT] precision checks.
#   3. stream.md positive/negative controls (only triggered by Stream SDK code).
#   4. ratings-feedback.md not triggered by community/feed SSR code.
#   5. astrojs.md not triggered by routine .astro page edits.
#   6. react-big-calendar.md only triggered by BigCalendar adopter, not booking logic.
#   7. sync-gaps.sh shared-basenames registry integration.
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

echo "## Drift-detection integration test (Phase 2 + Phase 4 [DT])"
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

# ── Test 2: tech-doc-sweep precision (Phase 4 — [DT] rule refinements) ───
echo ""
echo "### 2. tech-doc-sweep.sh (precision regressions — Phase 4 [DT] rule refinements)"

# 2a: BBB/plugnmeet full-alternation (original Phase 2 regression)
out=$(CODE_CHANGES_OVERRIDE="src/lib/plugnmeet-client.ts" "$TECH_SWEEP" 2>&1)
if echo "$out" | grep -q "plugnmeet.md\|bigbluebutton.md"; then
  pass "plugnmeet-client.ts flags video/bbb doc (full alternation works)"
else
  fail "expected plugnmeet-client.ts to flag video/bbb docs — got:"
  echo "$out" | sed 's/^/      /'
fi

# 2b: Booking "calendar" alternation still flags availability-calendar.md via "availability" keyword
out=$(CODE_CHANGES_OVERRIDE="src/lib/calendar-util.ts" "$TECH_SWEEP" 2>&1)
if echo "$out" | grep -q "availability-calendar.md"; then
  pass "calendar-util.ts change flags availability-calendar.md (booking rule availability keyword)"
else
  fail "expected calendar-util.ts to flag availability-calendar.md — got:"
  echo "$out" | sed 's/^/      /'
fi

# 2c: Negative control — unrelated file produces no flags
out=$(CODE_CHANGES_OVERRIDE="src/pages/api/totally/unrelated.ts" "$TECH_SWEEP" 2>&1)
if echo "$out" | grep -q "No reference/as-designed docs flagged"; then
  pass "unrelated change produces no flags (negative control)"
else
  fail "unrelated change should not flag anything — got:"
  echo "$out" | sed 's/^/      /'
fi

# ── Test 3 (new): stream.md — only triggered by Stream SDK code ────────
echo ""
echo "### 3. stream.md precision"

# Positive: actual Stream lib change → flags stream.md
out=$(CODE_CHANGES_OVERRIDE="src/lib/stream.ts" "$TECH_SWEEP" 2>&1)
if echo "$out" | grep -q "reference/stream.md"; then
  pass "src/lib/stream.ts flags stream.md (positive)"
else
  fail "src/lib/stream.ts should flag stream.md — got:"
  echo "$out" | sed 's/^/      /'
fi

# Negative: SSR community loader change → does NOT flag stream.md
out=$(CODE_CHANGES_OVERRIDE="src/lib/ssr/loaders/communities.ts" "$TECH_SWEEP" 2>&1)
if ! echo "$out" | grep -q "reference/stream.md"; then
  pass "SSR community loader change does NOT flag stream.md (negative)"
else
  fail "SSR community loader change should not flag stream.md — got:"
  echo "$out" | sed 's/^/      /'
fi

# ── Test 4 (new): ratings-feedback.md — not triggered by community/feed code ─
echo ""
echo "### 4. ratings-feedback.md precision"

# Negative: SSR community loader change → does NOT flag ratings-feedback.md
out=$(CODE_CHANGES_OVERRIDE="src/lib/ssr/loaders/communities.ts" "$TECH_SWEEP" 2>&1)
if ! echo "$out" | grep -q "ratings-feedback.md"; then
  pass "SSR community loader change does NOT flag ratings-feedback.md (negative)"
else
  fail "SSR community loader change should not flag ratings-feedback.md — got:"
  echo "$out" | sed 's/^/      /'
fi

# Positive: actual review API change → flags ratings-feedback.md
out=$(CODE_CHANGES_OVERRIDE="src/pages/api/enrollments/1/review.ts" "$TECH_SWEEP" 2>&1)
if echo "$out" | grep -q "ratings-feedback.md"; then
  pass "enrollments review API change flags ratings-feedback.md (positive)"
else
  fail "enrollments review API change should flag ratings-feedback.md — got:"
  echo "$out" | sed 's/^/      /'
fi

# ── Test 5 (new): astrojs.md — not triggered by routine page edits ─────
echo ""
echo "### 5. astrojs.md precision"

# Negative: routine .astro layout edit → does NOT flag astrojs.md
out=$(CODE_CHANGES_OVERRIDE="src/layouts/AppLayout.astro" "$TECH_SWEEP" 2>&1)
if ! echo "$out" | grep -q "astrojs.md"; then
  pass "routine AppLayout.astro edit does NOT flag astrojs.md (negative)"
else
  fail "AppLayout.astro edit should not flag astrojs.md — got:"
  echo "$out" | sed 's/^/      /'
fi

# Negative: course page edit → does NOT flag astrojs.md
out=$(CODE_CHANGES_OVERRIDE="src/pages/course/slug/feed.astro" "$TECH_SWEEP" 2>&1)
if ! echo "$out" | grep -q "astrojs.md"; then
  pass "routine course page edit does NOT flag astrojs.md (negative)"
else
  fail "course page edit should not flag astrojs.md — got:"
  echo "$out" | sed 's/^/      /'
fi

# ── Test 6 (new): react-big-calendar.md — only triggered by BigCalendar code ─
echo ""
echo "### 6. react-big-calendar.md precision"

# Negative: SessionBooking.tsx change → does NOT flag react-big-calendar.md
out=$(CODE_CHANGES_OVERRIDE="src/components/booking/SessionBooking.tsx" "$TECH_SWEEP" 2>&1)
if ! echo "$out" | grep -q "react-big-calendar.md"; then
  pass "SessionBooking.tsx booking-logic change does NOT flag react-big-calendar.md (negative)"
else
  fail "SessionBooking.tsx should not flag react-big-calendar.md — got:"
  echo "$out" | sed 's/^/      /'
fi

# Positive: BigCalendar adopter file → flags react-big-calendar.md
out=$(CODE_CHANGES_OVERRIDE="src/components/calendar/BigCalendar.tsx" "$TECH_SWEEP" 2>&1)
if echo "$out" | grep -q "react-big-calendar.md"; then
  pass "BigCalendar component change flags react-big-calendar.md (positive)"
else
  fail "BigCalendar.tsx change should flag react-big-calendar.md — got:"
  echo "$out" | sed 's/^/      /'
fi

# ── Test 7: sync-gaps.sh shared-basenames integration ─────────────────
echo ""
echo "### 7. sync-gaps.sh (registry-driven shared-basenames)"

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
