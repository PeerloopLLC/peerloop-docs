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

# Scan copy. For `git commit`, exclude the message body from the danger scan:
# a commit message is inert prose and may legitimately quote dangerous-looking
# phrases (e.g. a message documenting the `wrangler --remote` pattern itself —
# the Conv 212 false positive). Strip single-arg `-m "..."` / `-m '...'` /
# `--message=...` ONLY when the command contains `git commit`; everything
# OUTSIDE the quotes (e.g. a chained `&& wrangler --remote`) is still scanned,
# so real dangers survive. Single-quoted-arg case only — multi-line/heredoc
# messages are intentionally out of scope. Conv 213 [SETTINGS-GUARD].
#
# Git-subcommand detection must tolerate git's GLOBAL options between `git` and
# the subcommand — most importantly `git -C <path> <sub>`, this project's
# MANDATED dual-repo form (CLAUDE.md; feedback_git_dash_c_enforcement.md). The
# original `\bgit[[:space:]]+<sub>\b` only matched the bare adjacent form, so
# every real `git -C … commit/push …` slipped past: the commit-message strip
# never ran (could self-escalate on a danger-quoting message), AND the force-push
# rule never fired (and the settings.json `deny` prefix `git push --force:*`
# can't see it either — the command starts with `git -C …`). GITOPTS absorbs
# `-C <path>` / `-c k=v` (value-taking) / `--opt[=val]` / single `-x` flags,
# repeated, then the subcommand — stopping at any non-option word so it can't
# span a `;`/`&&` boundary. Conv 213 (commit strip) + Conv 214 [GUARD-VERIFY]
# (git -C tolerance; push rule).
GITOPTS='([[:space:]]+(-C|-c)[[:space:]]+[^[:space:]]+|[[:space:]]+--[A-Za-z][A-Za-z-]*(=[^[:space:]]+)?|[[:space:]]+-[A-Za-z])*'

# Scan copy. For `git commit`, exclude the inert message body from the danger
# scan (single-quoted-arg `-m "..."` / `-m '...'` / `--message=...` only;
# multi-line/heredoc messages are intentionally out of scope). Everything OUTSIDE
# the quotes (e.g. a chained `&& wrangler --remote`) is still scanned.
scan=$cmd
if printf '%s' "$cmd" | grep -Eiq "\\bgit\\b${GITOPTS}[[:space:]]+commit\\b"; then
  scan=$(printf '%s' "$cmd" | sed -E \
    -e 's/(-m|--message)[[:space:]=]+"[^"]*"//g' \
    -e "s/(-m|--message)[[:space:]=]+'[^']*'//g")
fi

# has PATTERN — true if the (scan copy of the) command matches (extended regex, case-insensitive).
has() { printf '%s' "$scan" | grep -Eiq -- "$1"; }

reason=""
if has '\bwrangler\b' && has '(^|[[:space:]])--remote([[:space:]]|$)'; then
  reason="Remote Cloudflare D1/R2 write (wrangler --remote) — irreversible on remote data."
elif has '\bwrangler\b' && has '--env[[:space:]=]+(prod|production)\b'; then
  reason="Production Cloudflare target (wrangler --env production)."
elif has '\bcurl\b' && has '((^|[[:space:]])-X[[:space:]]*(POST|PUT|DELETE|PATCH)|--request[[:space:]=]+(POST|PUT|DELETE|PATCH)|(^|[[:space:]])(-d|--data))'; then
  reason="Outbound write via curl (POST/PUT/DELETE/PATCH or --data) to an external service."
elif has '(DROP[[:space:]]+(TABLE|INDEX|VIEW|TRIGGER)|TRUNCATE[[:space:]]+TABLE|DELETE[[:space:]]+FROM)'; then
  reason="Destructive SQL (DROP/TRUNCATE/DELETE FROM) — confirm the target database first."
elif has "\\bgit\\b${GITOPTS}[[:space:]]+push\\b" && has '(--force\b|--force-with-lease\b|(^|[[:space:]])-f([[:space:]]|$))'; then
  reason="Force push rewrites remote history (also denied for the bare form; this catches the git -C … form deny prefixes miss)."
elif has '\blsof\b' && has '\b(kill|pkill|killall)\b'; then
  reason="Port-based process kill (lsof + kill). lsof -ti:PORT returns EVERY process on that port — including the user's Chrome (verified Conv 429: pid was Chrome's NetworkService, not the server) and any pre-existing dev server this session did not start (Conv 393). Use \`npx astro dev stop\` (reads .astro/dev.json, kills only this project's pid)."
fi

if [ -n "$reason" ]; then
  jq -nc --arg r "Dangerous-command guard: ${reason}" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}'
fi
exit 0
