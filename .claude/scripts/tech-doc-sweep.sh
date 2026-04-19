#!/bin/bash
# tech-doc-sweep.sh — Match code changes to reference/as-designed docs
#
# Replaces the 60-line "Tech Doc Sweep" algorithm in SKILL.md
# with a deterministic script that outputs which docs need review.
#
# Compatible with bash 3.x (macOS default) — no associative arrays.
#
# Usage: tech-doc-sweep.sh

DOCS_REPO="$(cd "$(dirname "$0")/../.." && pwd)"
CODE_REPO="$DOCS_REPO/../Peerloop"

echo "## Tech Doc Sweep"
echo ""

# ── Get changed code files ───────────────────────────────────────────
# Test hook: if CODE_CHANGES_OVERRIDE is set, use it instead of git (see test-drift-detection.sh)
if [[ -n "${CODE_CHANGES_OVERRIDE:-}" ]]; then
  CODE_CHANGES="$CODE_CHANGES_OVERRIDE"
else
  CODE_CHANGES=$(cd "$CODE_REPO" 2>/dev/null && git diff --name-only HEAD~5 2>/dev/null || echo "")
fi

if [[ -z "$CODE_CHANGES" ]]; then
  echo "No recent code changes detected. Skipping sweep."
  exit 0
fi

# ── Pattern rules: loaded from .claude/config.json via docs-registry.mjs ─
# Output is TSV: <codePattern>\t<space-joined topicKeywords> per line.
# Source of truth: docsRegistry.groups[id=vendor-docs].rules
REGISTRY="$(dirname "$0")/docs-registry.mjs"

# ── Collect all doc files and their basenames ────────────────────────
DOC_FILES=()
DOC_NAMES=()
for doc in "$DOCS_REPO"/docs/reference/*.md "$DOCS_REPO"/docs/as-designed/*.md; do
  [[ -f "$doc" ]] || continue
  DOC_FILES+=("$doc")
  DOC_NAMES+=("$(basename "$doc" .md | tr '[:upper:]' '[:lower:]')")
done

# ── Match changes against docs ───────────────────────────────────────
flagged=()
reasons=()

while IFS=$'\t' read -r code_pattern topic_keywords; do
  [[ -z "$code_pattern" ]] && continue

  # Check if any changed src/ files match this code pattern (excludes tests, scripts, config)
  matching_files=$(echo "$CODE_CHANGES" | grep '^src/' | grep -iE "$code_pattern" 2>/dev/null || true)
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
done < <(node "$REGISTRY" vendor-rules)

# ── Output ───────────────────────────────────────────────────────────
if [[ ${#flagged[@]} -eq 0 ]]; then
  echo "No reference/as-designed docs flagged for review."
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
