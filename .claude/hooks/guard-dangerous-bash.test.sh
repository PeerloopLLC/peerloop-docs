#!/usr/bin/env bash
# Calibration test for guard-dangerous-bash.sh.
#
# Run: bash .claude/hooks/guard-dangerous-bash.test.sh   (exits non-zero on any mismatch)
#
# The guard is a PreToolUse(Bash) hook that scans the RAW command string and can't
# tell an executed command from a quoted argument — so every danger phrase in this
# file lives inside the test payloads only. Running the file is inert: the outer
# command is just `bash <thisfile>`, which contains no danger phrase, so the test
# never trips the guard on its own invocation.
#
# Two false-positive classes are pinned here so they can't regress:
#   - Conv 458: a plain `git push` batched with an unrelated `-f` (e.g. `rm -f`).
#   - Conv 459: a MULTI-LINE `git commit -m` message documenting a guarded command
#     (the v2 commit format) — the message body must be stripped before scanning.
# Alongside them, the real dangers must still BLOCK (asserted by reason substring),
# including a genuine danger chained AFTER an inert commit message.
set -u
HOOK="$(cd "$(dirname "$0")" && pwd)/guard-dangerous-bash.sh"
pass=0; fail=0

if ! bash -n "$HOOK"; then echo "FAIL: bash -n $HOOK"; exit 1; fi

# verdict CMD -> the guard's reason string ("" if it stays silent)
verdict() {
  local out; out=$(printf '%s' "$1" | jq -Rs '{tool_input:{command:.}}' | bash "$HOOK")
  [ -z "$out" ] && return 0
  printf '%s' "$out" | jq -r '.hookSpecificOutput.permissionDecisionReason // ""' 2>/dev/null
}

silent() {  # DESC CMD — expect no prompt
  local r; r=$(verdict "$2")
  if [ -z "$r" ]; then pass=$((pass+1)); else
    fail=$((fail+1)); printf 'FAIL  %s\n      expected silent, got: %s\n' "$1" "$r"; fi
}

blocks() {  # DESC REASON_SUBSTR CMD — expect a prompt whose reason contains SUBSTR
  local r; r=$(verdict "$3")
  if printf '%s' "$r" | grep -qi -- "$2"; then pass=$((pass+1)); else
    fail=$((fail+1)); printf 'FAIL  %s\n      expected block matching "%s", got: %s\n' "$1" "$2" "${r:-<silent>}"; fi
}

D='git push --force'

# ── False positives that must stay SILENT ──────────────────────────────────
silent "plain bare git push"                        "git push"
silent "plain git -C push"                           "git -C ~/projects/Peerloop push"
silent "push ; unrelated rm -f (Conv458)"            "git push 2>&1; rm -f .conv-branch"
silent "git -C push && unrelated rm -f (Conv458)"    "git -C ~/projects/Peerloop push && rm -f x"
silent "rm -f alone"                                 "rm -f something"
silent "single-line commit documenting push"         "git commit -m \"fix the $D guard\""
silent "multi-line commit documenting push (Conv459)" "git commit -m \"Conv 459: fix guard
### Infra
- stops $D from tripping
Format: v2\""
silent "multi-line commit, escaped quotes + push"    "git commit -m \"has \\\"quoted\\\" and $D
second line\""
silent "single-quoted multi-line commit + push"      "git commit -m 'Conv 459
documents $D
end'"
silent "git -C multi-line commit documenting push"   "git -C ~/projects/Peerloop commit -m \"x
$D in body\""
silent "multi-line commit && unrelated rm -f"        "git commit -m \"line one
line two\" && rm -f .conv-branch"

# ── Real dangers that must BLOCK (assert the right rule fires) ──────────────
blocks "force push --force"            "Force push"          "git push --force"
blocks "force push -f"                 "Force push"          "git push -f"
blocks "force push --force-with-lease" "Force push"          "git push --force-with-lease"
blocks "git -C push -f"                "Force push"          "git -C ~/projects/Peerloop push -f"
blocks "push origin main -f (segment)" "Force push"          "git push origin main -f"
blocks "commit msg then chained force push" "Force push"     "git commit -m \"harmless
message\" && $D"
blocks "commit msg then chained --remote"   "Remote Cloudflare" "git commit -m \"multi
line msg\" && wrangler d1 execute --remote db"
blocks "wrangler --remote"             "Remote Cloudflare"   "wrangler d1 execute --remote --file x.sql db"
blocks "wrangler --env production"     "Production Cloudflare" "wrangler deploy --env production"
blocks "curl -X POST"                  "Outbound write"      "curl -X POST https://api.example.com"
blocks "curl --data"                   "Outbound write"      "curl --data foo=bar https://x"
blocks "DROP TABLE"                    "Destructive SQL"     "sqlite3 db 'DROP TABLE users'"
blocks "lsof + kill"                   "Port-based"          "lsof -ti:4321 | xargs kill"

echo "─────────────────────────────────────────────"
if [ "$fail" -eq 0 ]; then
  echo "✅ guard-dangerous-bash: ALL $pass ASSERTIONS PASSED"; exit 0
else
  echo "🔴 guard-dangerous-bash: $fail FAILED, $pass passed"; exit 1
fi
