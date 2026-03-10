#!/bin/bash
# tech-doc-sweep.sh — Match code changes to vendor/architecture docs
#
# Replaces the 60-line "Tech Doc Sweep" algorithm in SKILL.md
# with a deterministic script that outputs which docs need review.
#
# Compatible with bash 3.x (macOS default) — no associative arrays.
#
# Usage: tech-doc-sweep.sh

DOCS_REPO="$(cd "$(dirname "$0")/../../../.." && pwd)"
CODE_REPO="$DOCS_REPO/../Peerloop"

echo "## Tech Doc Sweep"
echo ""

# ── Get changed code files ───────────────────────────────────────────
CODE_CHANGES=$(cd "$CODE_REPO" 2>/dev/null && git diff --name-only HEAD~5 2>/dev/null || echo "")

if [[ -z "$CODE_CHANGES" ]]; then
  echo "No recent code changes detected. Skipping sweep."
  exit 0
fi

# ── Pattern rules: code_pattern|topic_keywords ───────────────────────
# Each line: grep_pattern|space-separated keywords to match against doc filenames
RULES=(
  "webhook.*bbb\|video\|bigblue\|plugnmeet|bigbluebutton bbb video plugnmeet"
  "stripe\|checkout\|payment|stripe payment"
  "feed\|communit\|stream|stream feed community"
  "email\|resend|resend email"
  "auth|auth"
  "booking\|availability\|calendar|booking availability calendar"
  "\.astro\|layouts/|astro"
  "migration|migration"
  "wrangler\|lib/db|cloudflare d1"
  "rating\|feedback\|review|rating feedback"
  "session.*join\|session.*room|session video bigbluebutton"
)

# ── Collect all doc files and their basenames ────────────────────────
DOC_FILES=()
DOC_NAMES=()
for doc in "$DOCS_REPO"/docs/vendors/*.md "$DOCS_REPO"/docs/architecture/*.md; do
  [[ -f "$doc" ]] || continue
  DOC_FILES+=("$doc")
  DOC_NAMES+=("$(basename "$doc" .md | tr '[:upper:]' '[:lower:]')")
done

# ── Match changes against docs ───────────────────────────────────────
flagged=()
reasons=()

for rule in "${RULES[@]}"; do
  code_pattern="${rule%%|*}"
  topic_keywords="${rule##*|}"

  # Check if any changed files match this code pattern
  matching_files=$(echo "$CODE_CHANGES" | grep -iE "$code_pattern" 2>/dev/null || true)
  [[ -z "$matching_files" ]] && continue

  # Find docs whose filename matches any topic keyword
  for keyword in $topic_keywords; do
    for idx in "${!DOC_NAMES[@]}"; do
      name="${DOC_NAMES[$idx]}"
      file="${DOC_FILES[$idx]}"

      if echo "$name" | grep -qi "$keyword" 2>/dev/null; then
        rel_doc=$(echo "$file" | sed "s|$DOCS_REPO/||")

        # Deduplicate
        already=false
        for existing in "${flagged[@]}"; do
          [[ "$existing" == "$rel_doc" ]] && already=true && break
        done

        if ! $already; then
          flagged+=("$rel_doc")
          short_files=$(echo "$matching_files" | head -3 | tr '\n' ', ' | sed 's/, $//')
          reasons+=("code: $short_files → topic: $keyword")
        fi
      fi
    done
  done
done

# ── Output ───────────────────────────────────────────────────────────
if [[ ${#flagged[@]} -eq 0 ]]; then
  echo "No vendor/architecture docs flagged for review."
else
  echo "**${#flagged[@]} docs flagged for review:**"
  echo ""
  for i in "${!flagged[@]}"; do
    echo "- \`${flagged[$i]}\`"
    echo "  Reason: ${reasons[$i]}"
  done
  echo ""
  echo "For each flagged doc, check:"
  echo "- Does it reflect new/changed endpoints or functions?"
  echo "- Should a new section be added (caveat, pattern, architecture note)?"
  echo "- Is the File Map still accurate?"
fi
