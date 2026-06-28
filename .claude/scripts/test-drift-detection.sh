#!/bin/bash
# test-drift-detection.sh — Phase 2 integration test for DOC-SYNC-STRATEGY
#
# Verifies that the three drift tools all read from docsRegistry correctly and
# surface a known change as expected. Not a CI check yet (that's Phase 3) —
# just a one-shot harness for Phase 2 exit criterion.
#
# Tests:
#   1. docs-registry.mjs loads, emits expected fields, resolves doc-category.
#   2. tech-doc-sweep.sh category gate (Conv 200) + alternation + precision checks.
#   3. stream.md (vendor → manual) is never flagged, even on direct Stream code.
#   4. ratings-feedback.md (architecture → driftCheck) precision controls.
#   5. astrojs.md (vendor → manual) not flagged by .astro page edits.
#   6. react-big-calendar.md (vendor → manual) is never flagged.
#   7. sync-gaps.sh shared-basenames registry integration.
#
# Conv 200 (DTUNE-V): vendor-docs downgraded driftCheck→manual. The sweep now
# gates flags on category, so vendor-doc code changes no longer surface drift.
# Architecture docs (docs/as-designed/*.md) stay driftCheck and still flag.
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

# doc-category resolution (Conv 200): vendor → manual, architecture → driftCheck,
# unmatched → manual (the default-unmaintained policy).
vendor_cat=$(node "$REGISTRY" doc-category "docs/reference/stream.md")
arch_cat=$(node "$REGISTRY" doc-category "docs/as-designed/migrations.md")
new_cat=$(node "$REGISTRY" doc-category "docs/reference/some-brand-new-doc.md")
if [[ "$vendor_cat" == "manual" ]]; then
  pass "doc-category: vendor doc (stream.md) → manual"
else
  fail "expected stream.md → manual, got '$vendor_cat'"
fi
if [[ "$arch_cat" == "driftCheck" ]]; then
  pass "doc-category: architecture doc (migrations.md) → driftCheck"
else
  fail "expected migrations.md → driftCheck, got '$arch_cat'"
fi
if [[ "$new_cat" == "manual" ]]; then
  pass "doc-category: unmatched doc → manual (default-unmaintained)"
else
  fail "expected unmatched doc → manual, got '$new_cat'"
fi

# ── Test 2: tech-doc-sweep precision (Phase 4 — [DT] rule refinements) ───
echo ""
echo "### 2. tech-doc-sweep.sh (precision regressions — Phase 4 [DT] rule refinements)"

# 2a: Category gate (Conv 200) — vendor code no longer flags vendor docs.
# (plugnmeet.md/bigbluebutton.md are vendor → manual; the rule still co-matches
# but the category gate suppresses the flag.)
out=$(CODE_CHANGES_OVERRIDE="src/lib/plugnmeet-client.ts" "$TECH_SWEEP" 2>&1)
if ! echo "$out" | grep -q "plugnmeet.md\|bigbluebutton.md"; then
  pass "plugnmeet-client.ts does NOT flag vendor video/bbb docs (category gate)"
else
  fail "expected vendor docs to be suppressed by category gate — got:"
  echo "$out" | sed 's/^/      /'
fi

# 2b: Booking alternation still flags availability-calendar.md (architecture,
# driftCheck) via the "availability" keyword — proves full alternation + that
# architecture docs survive the category gate.
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

# ── Test 3: stream.md (vendor → manual) is never flagged ───────────────
echo ""
echo "### 3. stream.md (vendor, manual) — category gate"

# Even a direct Stream SDK change must not flag stream.md now that vendor docs
# are manual (the strongest case for the category gate).
out=$(CODE_CHANGES_OVERRIDE="src/lib/stream.ts" "$TECH_SWEEP" 2>&1)
if ! echo "$out" | grep -q "reference/stream.md"; then
  pass "src/lib/stream.ts does NOT flag stream.md (vendor → manual)"
else
  fail "stream.md is manual and should not be flagged — got:"
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

# ── Test 6: react-big-calendar.md (vendor → manual) is never flagged ───
echo ""
echo "### 6. react-big-calendar.md (vendor, manual) — category gate"

# Neither booking logic nor a direct BigCalendar adopter flags the vendor doc.
out=$(CODE_CHANGES_OVERRIDE="src/components/booking/SessionBooking.tsx" "$TECH_SWEEP" 2>&1)
if ! echo "$out" | grep -q "react-big-calendar.md"; then
  pass "SessionBooking.tsx does NOT flag react-big-calendar.md (negative)"
else
  fail "SessionBooking.tsx should not flag react-big-calendar.md — got:"
  echo "$out" | sed 's/^/      /'
fi

out=$(CODE_CHANGES_OVERRIDE="src/components/calendar/BigCalendar.tsx" "$TECH_SWEEP" 2>&1)
if ! echo "$out" | grep -q "react-big-calendar.md"; then
  pass "BigCalendar.tsx does NOT flag react-big-calendar.md (vendor → manual)"
else
  fail "react-big-calendar.md is manual and should not be flagged — got:"
  echo "$out" | sed 's/^/      /'
fi

# ── Test 7: sync-gaps.sh shared-basenames integration ─────────────────
echo ""
echo "### 7. sync-gaps.sh (registry-driven shared-basenames)"

# The script loads the shared basenames from the registry at startup into the
# SHARED_BASENAMES array. Verify integration by checking the script runs cleanly
# and produces its normal report — any JSON parse / registry load failure would
# break the script output.
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

# Behavioral regression guard for the Conv-347 [SYNCGAP-FIX] bug. The section-4
# shared-basename guard was silently disabled because a `case "$x" in $VAR)`
# whose $VAR expands to "a|b|c" does NOT alternate — bash parses case-pattern
# `|` at parse time, before expansion, so the pipes became literal glob chars
# that never matched. The fix replaced it with the SHARED_BASENAMES array +
# is_shared_basename(). Source just the production helper (no report run) and
# assert it actually classifies basenames, so this can't silently regress.
(
  SYNC_GAPS_LIB_ONLY=1 source "$SYNC_GAPS"
  if [[ "${#SHARED_BASENAMES[@]}" -ge 5 ]]; then
    pass "is_shared_basename loaded ${#SHARED_BASENAMES[@]} basenames into the array"
  else
    fail "expected ≥5 shared basenames in the array, got ${#SHARED_BASENAMES[@]}"
  fi
  # Positive: download.test.ts is the canonical Conv-345 shared basename.
  if is_shared_basename "download.test.ts"; then
    pass "is_shared_basename matches the canonical shared basename (download.test.ts)"
  else
    fail "is_shared_basename should match download.test.ts (guard regressed — basename fallback re-enabled)"
  fi
  # Negative: a unique basename must NOT be treated as shared (so the fallback
  # still runs for genuinely-unique files).
  if ! is_shared_basename "a-very-unique-name.test.ts"; then
    pass "is_shared_basename rejects a non-shared basename (fallback preserved)"
  else
    fail "is_shared_basename wrongly matched a unique basename"
  fi
  exit $fail
) || fail=1

# ── Summary ───────────────────────────────────────────────────────────
echo ""
if [[ $fail -eq 0 ]]; then
  echo "✅ All drift-detection integration tests passed."
  exit 0
else
  echo "❌ One or more tests failed."
  exit 1
fi
