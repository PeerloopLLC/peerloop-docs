#!/bin/bash
# sync-gaps.sh — Find documentation gaps by comparing source-of-truth against docs
#
# Checks:
#   1. npm scripts in package.json vs CLI-QUICKREF.md
#   2. API route files vs API-*.md docs
#   3. Script files vs SCRIPTS.md
#   4. Test files vs TEST-COVERAGE.md
#
# Output: structured gap report for Claude to act on

DOCS_REPO="$(cd "$(dirname "$0")/../../../.." && pwd)"
CODE_REPO="$DOCS_REPO/../Peerloop"
REF_DOCS="$DOCS_REPO/docs/reference"

echo "## Documentation Sync Gaps"
echo ""
echo "Generated: $(date '+%Y-%m-%d %H:%M')"
echo ""

# ── 1. npm scripts vs CLI-QUICKREF.md ────────────────────────────────
echo "### 1. npm Scripts vs CLI-QUICKREF.md"
echo ""

if [[ -f "$CODE_REPO/package.json" ]] && [[ -f "$REF_DOCS/CLI-QUICKREF.md" ]]; then
  # Extract script names from package.json
  pkg_scripts=$(cd "$CODE_REPO" && node -e "
    const pkg = require('./package.json');
    Object.keys(pkg.scripts || {}).sort().forEach(s => console.log(s));
  " 2>/dev/null)

  if [[ -n "$pkg_scripts" ]]; then
    undocumented=""
    while IFS= read -r script; do
      # Check if script name appears in CLI-QUICKREF.md
      if ! grep -qF "$script" "$REF_DOCS/CLI-QUICKREF.md" 2>/dev/null; then
        undocumented+="- \`npm run $script\`"$'\n'
      fi
    done <<< "$pkg_scripts"

    total=$(echo "$pkg_scripts" | wc -l | tr -d ' ')
    if [[ -n "$undocumented" ]]; then
      missing=$(echo "$undocumented" | grep -c '.' || true)
      echo "**$missing of $total scripts undocumented:**"
      echo "$undocumented"
    else
      echo "All $total scripts documented. No gaps."
    fi
  fi
else
  echo "(package.json or CLI-QUICKREF.md not found)"
fi
echo ""

# ── 2. API route files vs API docs ───────────────────────────────────
echo "### 2. API Route Files vs API-*.md"
echo ""

if [[ -d "$CODE_REPO/src/pages/api" ]]; then
  # List all API route files
  api_files=$(cd "$CODE_REPO" && find src/pages/api -name "*.ts" 2>/dev/null | sort)

  if [[ -n "$api_files" ]]; then
    total=$(echo "$api_files" | wc -l | tr -d ' ')
    echo "Found $total API route files."
    echo ""

    # Check which route prefixes have corresponding docs
    undoc_routes=""
    while IFS= read -r route; do
      # Extract the route prefix (first path segment after api/)
      prefix=$(echo "$route" | sed 's|src/pages/api/||' | cut -d'/' -f1)

      # Map prefix to expected doc file (from shared route-mapping.txt)
      MAPPING_FILE="$(dirname "$0")/route-mapping.txt"
      doc=$(grep "^${prefix}|" "$MAPPING_FILE" 2>/dev/null | head -1 | cut -d'|' -f2)
      [[ -z "$doc" ]] && doc="API-REFERENCE.md"

      # Check if the route's endpoint name appears in the target doc
      endpoint_name=$(basename "$route" .ts)
      if [[ -f "$REF_DOCS/$doc" ]]; then
        if ! grep -qi "$endpoint_name" "$REF_DOCS/$doc" 2>/dev/null; then
          undoc_routes+="- \`$route\` → should be in \`$doc\` (endpoint '$endpoint_name' not found)"$'\n'
        fi
      else
        undoc_routes+="- \`$route\` → \`$doc\` does not exist"$'\n'
      fi
    done <<< "$api_files"

    if [[ -n "$undoc_routes" ]]; then
      echo "**Potentially undocumented routes:**"
      echo "$undoc_routes"
    else
      echo "All routes appear documented. No gaps."
    fi
  fi
else
  echo "(No API directory found at $CODE_REPO/src/pages/api)"
fi
echo ""

# ── 3. Script files vs SCRIPTS.md ────────────────────────────────────
echo "### 3. Script Files vs SCRIPTS.md"
echo ""

if [[ -f "$REF_DOCS/SCRIPTS.md" ]]; then
  script_files=$(cd "$CODE_REPO" && ls scripts/*.{js,ts,sh,mjs} 2>/dev/null | sort)
  if [[ -n "$script_files" ]]; then
    undoc_scripts=""
    while IFS= read -r sf; do
      basename_sf=$(basename "$sf")
      if ! grep -qF "$basename_sf" "$REF_DOCS/SCRIPTS.md" 2>/dev/null; then
        undoc_scripts+="- \`$sf\`"$'\n'
      fi
    done <<< "$script_files"

    total=$(echo "$script_files" | wc -l | tr -d ' ')
    if [[ -n "$undoc_scripts" ]]; then
      echo "**Undocumented script files:**"
      echo "$undoc_scripts"
    else
      echo "All $total script files documented. No gaps."
    fi
  else
    echo "(No script files found)"
  fi
else
  echo "(SCRIPTS.md not found — skipping)"
fi
echo ""

# ── 4. Test files vs TEST-COVERAGE.md ────────────────────────────────
echo "### 4. Test Files vs TEST-COVERAGE.md"
echo ""

if [[ -f "$REF_DOCS/TEST-COVERAGE.md" ]]; then
  test_files=$(cd "$CODE_REPO" && find tests -name "*.test.*" 2>/dev/null | sort)
  if [[ -n "$test_files" ]]; then
    undoc_tests=""
    while IFS= read -r tf; do
      basename_tf=$(basename "$tf")
      if ! grep -qF "$basename_tf" "$REF_DOCS/TEST-COVERAGE.md" 2>/dev/null; then
        undoc_tests+="- \`$tf\`"$'\n'
      fi
    done <<< "$test_files"

    total=$(echo "$test_files" | wc -l | tr -d ' ')
    if [[ -n "$undoc_tests" ]]; then
      missing=$(echo "$undoc_tests" | grep -c '.' || true)
      echo "**$missing of $total test files undocumented:**"
      echo "$undoc_tests"
    else
      echo "All $total test files documented. No gaps."
    fi
  else
    echo "(No test files found)"
  fi
else
  echo "(TEST-COVERAGE.md not found — skipping)"
fi
