#!/bin/bash
# Check if RESUME-STATE.md exists and show its state header.
# RESUME-STATE.md is NARRATIVE-only since the [CURTASKS] cutover (Conv 351) —
# Summary / Key Context / Branch, no task data (the backlog lives in CURRENT-TASKS.md).
# This probe only surfaces the header line; it never inspected task sections, so it
# needs no change for the narrative-only model.
# Always exits 0 — this is an informational probe, not a validation. A non-zero
# exit would fail the SKILL.md `!` backtick and block /r-end from loading.
DOCS_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
if [ -f "$DOCS_ROOT/RESUME-STATE.md" ]; then
  echo "EXISTS — header:"
  # Match common header shapes: "# State — Conv NNN (...)" or legacy "Saved: ..."
  head -5 "$DOCS_ROOT/RESUME-STATE.md" | grep -E '^(# State|Saved:|\*\*Conv)' || head -1 "$DOCS_ROOT/RESUME-STATE.md"
else
  echo "No existing RESUME-STATE.md"
fi
exit 0
