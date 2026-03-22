#!/bin/bash
# detect-changes.sh — Deterministic change detection for /w-docs
#
# Outputs a structured report of what changed in both repos,
# categorized by documentation area. This replaces Claude's
# guesswork with hard data.
#
# WHY PAST COMMITS: /w-docs runs at session end, but most work was
# already committed mid-session (write endpoint → commit → write tests
# → commit → fix bug → commit → run /w-docs). We need to see ALL
# commits from this session, not just uncommitted changes.
#
# ANCHOR STRATEGY: After each run, we record the HEAD SHAs of both
# repos in a marker file. The next run diffs from that marker forward,
# so it only sees changes since the last /w-docs run — not the entire
# day. Falls back to --since if no marker exists (first run or reset).
#
# Usage: detect-changes.sh ["24 hours ago" | "2 days ago" | "--reset"]
#   Default fallback: 24 hours (when no marker exists).
#   --reset: Delete the marker file, forcing next run to use time fallback.

FALLBACK_SINCE="${1:-24 hours ago}"
DOCS_REPO="$(cd "$(dirname "$0")/../../../.." && pwd)"
CODE_REPO="$DOCS_REPO/../Peerloop"
MARKER_FILE="$DOCS_REPO/.claude/skills/w-docs/.last-qdocs-run"

# Handle --reset
if [[ "$1" == "--reset" ]]; then
  rm -f "$MARKER_FILE"
  echo "(marker reset — next run will use time-based fallback)"
  exit 0
fi

# ── Determine anchor point ───────────────────────────────────────────
# If a marker exists, diff from that SHA. Otherwise fall back to --since.
ANCHOR_MODE=""
MARKER_CODE_SHA=""
MARKER_DOCS_SHA=""

if [[ -f "$MARKER_FILE" ]]; then
  MARKER_CODE_SHA=$(sed -n '1p' "$MARKER_FILE")
  MARKER_DOCS_SHA=$(sed -n '2p' "$MARKER_FILE")

  # Validate SHAs still exist in their repos
  code_valid=false
  docs_valid=false
  if [[ -n "$MARKER_CODE_SHA" ]] && (cd "$CODE_REPO" 2>/dev/null && git cat-file -t "$MARKER_CODE_SHA" &>/dev/null); then
    code_valid=true
  fi
  if [[ -n "$MARKER_DOCS_SHA" ]] && (cd "$DOCS_REPO" && git cat-file -t "$MARKER_DOCS_SHA" &>/dev/null); then
    docs_valid=true
  fi

  if $code_valid || $docs_valid; then
    ANCHOR_MODE="marker"
  fi
fi

if [[ -z "$ANCHOR_MODE" ]]; then
  ANCHOR_MODE="since"
fi

# collect_changes <repo_dir> [marker_sha]
# If marker_sha given: diff from marker to HEAD + uncommitted.
# Otherwise: use time-based --since fallback + uncommitted.
# Deduplicates so a file appears once.
collect_changes() {
  local repo="$1"
  local marker_sha="$2"
  (
    cd "$repo" || return 1
    if [[ -n "$marker_sha" ]]; then
      # Diff from marker SHA to HEAD
      git diff --name-only "${marker_sha}..HEAD" 2>/dev/null
    else
      # Time-based fallback
      local since_sha
      since_sha=$(git log --since="$FALLBACK_SINCE" --format='%H' --reverse 2>/dev/null | head -1)
      if [[ -n "$since_sha" ]]; then
        git diff --name-only "${since_sha}^..HEAD" 2>/dev/null
      fi
    fi
    # Uncommitted changes (staged + unstaged)
    git diff --name-only HEAD 2>/dev/null
    git diff --name-only --cached 2>/dev/null
  ) | sort -u
}

# ── Collect changed files from both repos ────────────────────────────
echo "## Changed Files"
echo ""
if [[ "$ANCHOR_MODE" == "marker" ]]; then
  echo "*(since last /w-docs run)*"
else
  echo "*(since: $FALLBACK_SINCE — no previous /w-docs marker found)*"
fi
echo ""

if [[ -d "$CODE_REPO/.git" ]]; then
  code_marker=""
  if [[ "$ANCHOR_MODE" == "marker" ]] && [[ -n "$MARKER_CODE_SHA" ]]; then
    code_marker="$MARKER_CODE_SHA"
  fi
  CODE_CHANGES=$(collect_changes "$CODE_REPO" "$code_marker")
  if [[ -z "$CODE_CHANGES" ]]; then
    CODE_CHANGES="(no changes since last /w-docs run)"
  fi
  echo "### Code repo (Peerloop)"
  echo '```'
  echo "$CODE_CHANGES"
  echo '```'
else
  CODE_CHANGES=""
  echo "### Code repo: not found at $CODE_REPO"
fi

echo ""

if [[ -d "$DOCS_REPO/.git" ]]; then
  docs_marker=""
  if [[ "$ANCHOR_MODE" == "marker" ]] && [[ -n "$MARKER_DOCS_SHA" ]]; then
    docs_marker="$MARKER_DOCS_SHA"
  fi
  DOCS_CHANGES=$(collect_changes "$DOCS_REPO" "$docs_marker")
  if [[ -z "$DOCS_CHANGES" ]]; then
    DOCS_CHANGES="(no changes since last /w-docs run)"
  fi
  echo "### Docs repo (peerloop-docs)"
  echo '```'
  echo "$DOCS_CHANGES"
  echo '```'
else
  DOCS_CHANGES=""
  echo "### Docs repo: not found"
fi

echo ""

# ── Categorize code changes by doc area ──────────────────────────────
echo "## Affected Documentation Areas"
echo ""

has_changes=false

# API endpoints
api_changes=$(echo "$CODE_CHANGES" | grep -E '^src/pages/api/' || true)
if [[ -n "$api_changes" ]]; then
  has_changes=true
  count=$(echo "$api_changes" | wc -l | tr -d ' ')
  echo "- **API endpoints** ($count files) → API-*.md, CLI-QUICKREF.md"
  echo "$api_changes" | sed 's/^/    /'
fi

# Database / migrations
db_changes=$(echo "$CODE_CHANGES" | grep -E '^(migrations/|src/lib/db)' || true)
if [[ -n "$db_changes" ]]; then
  has_changes=true
  echo "- **Database** → API-DATABASE.md, DEVELOPMENT-GUIDE.md, DB-GUIDE.md"
  echo "$db_changes" | sed 's/^/    /'
fi

# Auth
auth_changes=$(echo "$CODE_CHANGES" | grep -E '^src/(lib/auth|pages/api/auth)' || true)
if [[ -n "$auth_changes" ]]; then
  has_changes=true
  echo "- **Auth** → DEVELOPMENT-GUIDE.md, API-AUTH.md"
  echo "$auth_changes" | sed 's/^/    /'
fi

# Tests
test_changes=$(echo "$CODE_CHANGES" | grep -E '^(tests/|e2e/)' || true)
if [[ -n "$test_changes" ]]; then
  has_changes=true
  count=$(echo "$test_changes" | wc -l | tr -d ' ')
  echo "- **Tests** ($count files) → TEST-COVERAGE.md"
  echo "$test_changes" | sed 's/^/    /'
fi

# Scripts
script_changes=$(echo "$CODE_CHANGES" | grep -E '^scripts/' || true)
if [[ -n "$script_changes" ]]; then
  has_changes=true
  echo "- **Scripts** → SCRIPTS.md"
  echo "$script_changes" | sed 's/^/    /'
fi

# Package.json
pkg_changes=$(echo "$CODE_CHANGES" | grep -E '^package\.json$' || true)
if [[ -n "$pkg_changes" ]]; then
  has_changes=true
  echo "- **package.json** → CLI-QUICKREF.md, SCRIPTS.md"
fi

# Pages / routes
page_changes=$(echo "$CODE_CHANGES" | grep -E '^src/pages/' | grep -v '/api/' || true)
if [[ -n "$page_changes" ]]; then
  has_changes=true
  echo "- **Pages/routes** → url-routing.md, page-connections.md"
  echo "$page_changes" | sed 's/^/    /'
fi

# Astro layouts/components
astro_changes=$(echo "$CODE_CHANGES" | grep -E '\.(astro|tsx?)$' | grep -E '^src/(layouts|components)/' || true)
if [[ -n "$astro_changes" ]]; then
  has_changes=true
  echo "- **UI components/layouts** → DEVELOPMENT-GUIDE.md"
fi

# Vendor-adjacent code
stripe_changes=$(echo "$CODE_CHANGES" | grep -iE '(stripe|checkout|enrollment|webhook)' || true)
if [[ -n "$stripe_changes" ]]; then
  has_changes=true
  echo "- **Stripe/payments** → docs/reference/stripe.md"
fi

stream_changes=$(echo "$CODE_CHANGES" | grep -iE '(feed|communit|stream)' || true)
if [[ -n "$stream_changes" ]]; then
  has_changes=true
  echo "- **Stream/community** → docs/reference/stream.md"
fi

video_changes=$(echo "$CODE_CHANGES" | grep -iE '(video|bbb|bigblue|session.*join)' || true)
if [[ -n "$video_changes" ]]; then
  has_changes=true
  echo "- **Video/BBB** → docs/reference/bigbluebutton.md"
fi

email_changes=$(echo "$CODE_CHANGES" | grep -iE '(email|resend)' || true)
if [[ -n "$email_changes" ]]; then
  has_changes=true
  echo "- **Email** → docs/reference/resend.md"
fi

# Docs-repo changes
policy_changes=$(echo "$DOCS_CHANGES" | grep -E '^docs/POLICIES' || true)
skill_changes=$(echo "$DOCS_CHANGES" | grep -E '^\.(claude)/' || true)
if [[ -n "$skill_changes" ]]; then
  has_changes=true
  echo "- **Skills/commands** → CLAUDE.md (if user-facing)"
fi

if ! $has_changes; then
  echo "(No changes detected that map to documentation areas)"
fi

echo ""

# ── Recent commits for context ───────────────────────────────────────
echo "## Recent Commits"
echo ""
echo "### Code repo"
echo '```'
(cd "$CODE_REPO" 2>/dev/null && git log --oneline -10) || echo "(unavailable)"
echo '```'
echo ""
echo "### Docs repo"
echo '```'
(cd "$DOCS_REPO" && git log --oneline -10) || echo "(unavailable)"
echo '```'

# ── Write marker for next run ────────────────────────────────────────
# Record current HEAD of both repos so the next /w-docs run starts here.
# Line 1: code repo SHA, Line 2: docs repo SHA.
code_head=$(cd "$CODE_REPO" 2>/dev/null && git rev-parse HEAD 2>/dev/null || echo "")
docs_head=$(cd "$DOCS_REPO" && git rev-parse HEAD 2>/dev/null || echo "")
printf '%s\n%s\n' "$code_head" "$docs_head" > "$MARKER_FILE"
