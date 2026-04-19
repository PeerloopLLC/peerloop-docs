#!/bin/bash
# sync-gaps.sh — Find documentation gaps by comparing source-of-truth against docs
#
# Checks:
#   1. npm scripts in package.json vs CLI-QUICKREF.md
#   2. API route files vs API-*.md docs
#   3. Script files vs SCRIPTS.md
#   4. Test files vs all TEST-*.md docs (auto-discovered)
#
# Output: structured gap report for Claude to act on

DOCS_REPO="$(cd "$(dirname "$0")/../.." && pwd)"
CODE_REPO="$DOCS_REPO/../Peerloop"
REF_DOCS="$DOCS_REPO/docs/reference"
REGISTRY="$(dirname "$0")/docs-registry.mjs"

# Shared basenames from docsRegistry.groups[id=test-docs].sharedBasenames.
# Joined as an alternation so it plugs into the `case` below.
SHARED_BASENAMES_PATTERN=$(node "$REGISTRY" test-shared-basenames 2>/dev/null | tr '\n' '|' | sed 's/|$//')

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
  # List all API route files.
  # Exclude Astro-generated `.astro/` directories (content.d.ts shims live here and
  # produce false-positive "undocumented route" hits — fixed Conv 123 [SGA]).
  api_files=$(cd "$CODE_REPO" && find src/pages/api -name "*.ts" -not -path '*/.astro/*' 2>/dev/null | sort)

  if [[ -n "$api_files" ]]; then
    total=$(echo "$api_files" | wc -l | tr -d ' ')
    echo "Found $total API route files."
    echo ""

    # Check which route prefixes have corresponding docs
    MAPPING_FILE="$(dirname "$0")/route-mapping.txt"
    undoc_routes=""
    while IFS= read -r route; do
      # Convert file path to API route: src/pages/api/me/courses/[id]/index.ts → me/courses/:id
      api_route=$(echo "$route" | sed 's|src/pages/api/||; s|/index\.ts$||; s|\.ts$||')
      # Convert [param] → :param for doc-style matching
      api_route=$(echo "$api_route" | sed 's|\[\([^]]*\)\]|:\1|g')

      # Extract the route prefix (first path segment after api/)
      prefix=$(echo "$api_route" | cut -d'/' -f1)

      # For multi-level prefixes (me/*, webhooks/*), try two-level prefix first
      doc=""
      if [[ "$prefix" == "me" || "$prefix" == "webhooks" ]]; then
        sub_prefix=$(echo "$api_route" | cut -d'/' -f2)
        if [[ -n "$sub_prefix" ]]; then
          doc=$(grep "^${prefix}/${sub_prefix}|" "$MAPPING_FILE" 2>/dev/null | head -1 | cut -d'|' -f2)
        fi
      fi
      # Fall back to single-level prefix
      if [[ -z "$doc" ]]; then
        doc=$(grep "^${prefix}|" "$MAPPING_FILE" 2>/dev/null | head -1 | cut -d'|' -f2)
      fi
      [[ -z "$doc" ]] && doc="API-REFERENCE.md"

      # Build [param] variant for docs that use bracket notation instead of :param
      bracket_route=$(echo "$api_route" | sed 's|:\([a-zA-Z]*\)|[\1]|g')

      # Search for route in target doc — try multiple notations
      last_segment=$(basename "$api_route")
      found=false
      if [[ -f "$REF_DOCS/$doc" ]]; then
        # Try :param notation (e.g., "/api/admin/users/:id")
        if grep -qiF "$api_route" "$REF_DOCS/$doc" 2>/dev/null; then
          found=true
        # Try [param] notation (e.g., "/api/sessions/[id]")
        elif [[ "$bracket_route" != "$api_route" ]] && grep -qiF "$bracket_route" "$REF_DOCS/$doc" 2>/dev/null; then
          found=true
        # Try last segment (e.g., "discussion-feed", "reject") — skip generic param names
        elif [[ "$last_segment" != ":id" && "$last_segment" != ":slug" && "$last_segment" != ":token" && "$last_segment" != ":userId" && "$last_segment" != ":courseId" ]]; then
          if grep -qiF "$last_segment" "$REF_DOCS/$doc" 2>/dev/null; then
            found=true
          fi
        fi
      fi

      if [[ "$found" == "false" ]]; then
        if [[ ! -f "$REF_DOCS/$doc" ]]; then
          undoc_routes+="- \`$route\` → \`$doc\` does not exist"$'\n'
        else
          undoc_routes+="- \`$route\` → should be in \`$doc\` (route '/api/$api_route' not found)"$'\n'
        fi
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
  script_files=$(cd "$CODE_REPO" && find scripts -type f \( -name "*.js" -o -name "*.ts" -o -name "*.sh" -o -name "*.mjs" \) 2>/dev/null | sort)
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

# ── 4. Test files vs TEST-*.md docs ──────────────────────────────────
echo "### 4. Test Files vs TEST-COVERAGE.md"
echo ""

if [[ -f "$REF_DOCS/TEST-COVERAGE.md" ]]; then
  # Collect all TEST-*.md files so new sub-docs are picked up automatically
  test_docs=$(ls "$REF_DOCS"/TEST-*.md 2>/dev/null)

  test_files=$(cd "$CODE_REPO" && find tests -name "*.test.*" -not -path '*/.astro/*' 2>/dev/null | sort)
  if [[ -n "$test_files" ]]; then
    undoc_tests=""
    while IFS= read -r tf; do
      # Match on full path first (e.g., `tests/api/community-resources/[id]/download.test.ts`).
      # Falling back to basename was producing false negatives — multiple test files share
      # basenames like `download.test.ts` or `index.test.ts`, and a single mention in any
      # TEST-*.md was masking everything else.
      basename_tf=$(basename "$tf")
      found=false
      while IFS= read -r doc; do
        if grep -qF "$tf" "$doc" 2>/dev/null; then
          found=true
          break
        fi
      done <<< "$test_docs"
      # Fallback: basename match only for files whose basename is unambiguous platform-wide.
      # Skip the fallback for known shared basenames to avoid the false-negative this whole
      # check exists to fix.
      if [[ "$found" == "false" ]]; then
        case "$basename_tf" in
          # Shared basenames loaded from docsRegistry (see SHARED_BASENAMES_PATTERN above)
          $SHARED_BASENAMES_PATTERN)
            : # known shared basenames — require full-path match, do not fall back
            ;;
          *)
            while IFS= read -r doc; do
              if grep -qF "$basename_tf" "$doc" 2>/dev/null; then
                found=true
                break
              fi
            done <<< "$test_docs"
            ;;
        esac
      fi
      if [[ "$found" == "false" ]]; then
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
