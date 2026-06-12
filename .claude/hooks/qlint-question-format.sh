#!/usr/bin/env bash
# qlint-question-format.sh — Stop hook. Deterministic enforcement of the
# CLAUDE.md §User-Facing Questions / §Recurring-Failures #1 rule.
#
# Underlying intent (Conv 272 [QLINT], refined with the user): the rule exists
# because the user answers by TYPING. A question is bad when answering it
# requires typing anything other than a single labeled letter or a plain
# yes/no — i.e. ambiguity / typo risk. So the gate is a *typeability* check,
# not a surface "or" check.
#
# Blocks the stop (feeding a correction back so Claude reformats) when ALL hold
# for the final assistant message:
#   1. SOLICITING — the message asks the user for a response: it contains a 👉
#      pointer, OR its last non-empty line ends with "?".
#   2. UNLABELED CHOICE — it offers a choice that is NOT typeable as labels:
#        a. a space-bounded " or " anywhere (excluding the blessed binary
#           shorthand "yes or no"), OR
#        b. an inline option list of 3+ alternatives — a parenthetical holding
#           ≥2 slashes, e.g. "(yes/no/something else)".  ("(yes/no)" = 1 slash
#           = blessed binary → does NOT count.)
#   3. NOT ALREADY LABELED — no A)/B)/C) (or A1)/B1)) label line anywhere.
#      Labels are the ONLY exemption; a bare 👉 does NOT exempt.
#
# A turn is silent unless it is BOTH soliciting AND offers an unlabeled
# multi-option choice. Plain yes/no questions, label-formatted choices, and
# pure work/status turns never fire.
#
# Code fences (``` … ```) and inline `code` are stripped before all checks;
# double-quoted "spans" are additionally stripped for the choice scan so that
# quoting the rule in prose (e.g. discussing "X, or Y?") does not trip it.
#
# stop_hook_active guard prevents block loops. Conv 272 [QLINT].
#
# Kill-switch (Conv 273 [QLINT-TRIAL]): if the gitignored sentinel
# <project-root>/.scratch/qlint-off exists, the hook short-circuits and never
# blocks. Editing this script is live (executed fresh each Stop event), so the
# sentinel toggles enforcement without a settings.json change or restart.
# Remove the sentinel to re-enable.

# --- Kill-switch: gitignored sentinel disables the hook. Project root is two
# levels up from this script (.claude/hooks/ -> root). Resolved from the
# script's own location so it doesn't depend on CWD or env.
_qlroot=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
[ -f "$_qlroot/.scratch/qlint-off" ] && exit 0

input=$(cat)

# --- Loop guard: if a prior Stop block already fired this turn, never block again.
active=$(printf '%s' "$input" | jq -r '.stop_hook_active // false' 2>/dev/null)
[ "$active" = "true" ] && exit 0

# --- Final assistant message: prefer the pre-extracted convenience field; fall
# back to the transcript's last top-level (non-sidechain) assistant text block.
msg=$(printf '%s' "$input" | jq -r '.last_assistant_message // empty' 2>/dev/null)
if [ -z "$msg" ]; then
  tpath=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
  if [ -n "$tpath" ] && [ -f "$tpath" ]; then
    msg=$(jq -rs '
      [ .[]
        | select(.type=="assistant")
        | select((.isSidechain // false) | not)
        | (.message.content // [])
        | map(select(.type=="text") | .text)
        | join("\n")
      ] | map(select(. != "")) | last // empty
    ' "$tpath" 2>/dev/null)
  fi
fi
[ -z "$msg" ] && exit 0

# --- Strip fenced code blocks and inline `code`.
stripped=$(printf '%s\n' "$msg" \
  | awk 'BEGIN{f=0} /^[[:space:]]*```/{f=!f; next} !f{print}' \
  | sed -E 's/`[^`]*`//g')

# --- (1) SOLICITING?  👉 present, or last non-empty line ends with "?"
solicit=0
printf '%s' "$stripped" | grep -q '👉' && solicit=1
if [ "$solicit" -eq 0 ]; then
  lastne=$(printf '%s\n' "$stripped" | grep -v '^[[:space:]]*$' | tail -1)
  # trim trailing markdown emphasis / quotes / whitespace, then test for "?"
  trimmed=$(printf '%s' "$lastne" | sed -E 's/[*_"`'"'"' 	]+$//')
  case "$trimmed" in *\?) solicit=1;; esac
fi
[ "$solicit" -eq 0 ] && exit 0

# --- (3) ALREADY LABELED?  A)/B)/C) (or A1) …) label line anywhere → exempt.
printf '%s\n' "$stripped" | grep -Eq '^[[:space:]]*[A-D][0-9]?\)[[:space:]]' && exit 0

# --- (2) UNLABELED CHOICE?
#   2a: " or " anywhere, after removing double-quoted spans and the blessed
#       "yes or no" binary shorthand.
orscan=$(printf '%s' "$stripped" \
  | sed -E 's/"[^"]*"//g' \
  | sed -E 's/[Yy]es[[:space:]]+or[[:space:]]+[Nn]o//g')
choice=0
printf '%s' "$orscan" | grep -Eiq '[[:space:]]or[[:space:]]' && choice=1
#   2b: parenthetical inline list with ≥2 slashes, e.g. "(yes/no/maybe)".
if [ "$choice" -eq 0 ]; then
  printf '%s\n' "$stripped" | grep -Eq '\([^)]*/[^)]*/[^)]*\)' && choice=1
fi
[ "$choice" -eq 0 ] && exit 0

# --- All three hold → block with a corrective reason.
reason='QLINT (CLAUDE.md §User-Facing Questions): your final message asks me to respond AND offers a choice that is not typeable as a single label — either a compound "…, or …?" or an inline list like "(a/b/c)". These are hard to answer without ambiguity/typos (I answer by typing). Reformat the options as A) … / B) … / C) … each on its own line above a short bold 👉👉👉 pointing question that references the letters, then stop. (A plain yes/no is fine and needs no labels; only multi-option choices do.)'
jq -nc --arg r "$reason" '{decision:"block", reason:$r}'
exit 0
