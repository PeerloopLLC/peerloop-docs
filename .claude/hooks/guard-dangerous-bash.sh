#!/usr/bin/env bash
# guard-dangerous-bash.sh — PreToolUse(Bash) safety guard.
#
# Escalates irreversible / external command syntaxes to an interactive "ask"
# (with a custom warning) so they cannot run autonomously without confirmation.
# This catches mid-command flags that prefix-based permission rules in
# settings.json CANNOT see — most importantly `wrangler --remote`, which writes
# remote Cloudflare D1/R2 data with no local undo.
#
# Prefix-anchored dangers (npm run deploy:*, db:reset:staging, gh repo delete,
# rm -rf, …) are handled declaratively by the permission `ask`/`deny` lists in
# settings.json; this hook covers the patterns those lists structurally cannot.
#
# Output: on a match, emits a PreToolUse "ask" decision (prompt + reason).
# On no match, emits nothing and exits 0 (command proceeds under normal rules).
# Conv 212 [SETTINGS-GUARD].

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)
[ -z "$cmd" ] && exit 0

# has PATTERN — true if the command matches (extended regex, case-insensitive).
has() { printf '%s' "$cmd" | grep -Eiq -- "$1"; }

reason=""
if has '\bwrangler\b' && has '(^|[[:space:]])--remote([[:space:]]|$)'; then
  reason="Remote Cloudflare D1/R2 write (wrangler --remote) — irreversible on remote data."
elif has '\bwrangler\b' && has '--env[[:space:]=]+(prod|production)\b'; then
  reason="Production Cloudflare target (wrangler --env production)."
elif has '\bcurl\b' && has '((^|[[:space:]])-X[[:space:]]*(POST|PUT|DELETE|PATCH)|--request[[:space:]=]+(POST|PUT|DELETE|PATCH)|(^|[[:space:]])(-d|--data))'; then
  reason="Outbound write via curl (POST/PUT/DELETE/PATCH or --data) to an external service."
elif has '(DROP[[:space:]]+(TABLE|INDEX|VIEW|TRIGGER)|TRUNCATE[[:space:]]+TABLE|DELETE[[:space:]]+FROM)'; then
  reason="Destructive SQL (DROP/TRUNCATE/DELETE FROM) — confirm the target database first."
elif has '\bgit[[:space:]]+push\b' && has '(--force\b|--force-with-lease\b|(^|[[:space:]])-f([[:space:]]|$))'; then
  reason="Force push rewrites remote history (also denied; defense-in-depth)."
fi

if [ -n "$reason" ]; then
  jq -nc --arg r "Dangerous-command guard: ${reason}" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}'
fi
exit 0
