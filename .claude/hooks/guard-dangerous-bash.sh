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
# the Conv 212 false positive). Strip `-m "..."` / `-m '...'` / `--message=...`
# ONLY when the command contains `git commit`; everything OUTSIDE the quotes
# (e.g. a chained `&& wrangler --remote`) is still scanned, so real dangers
# survive. The strip is MULTI-LINE-aware (Conv 459): the v2 commit format is
# always a multi-line `-m "..."`, and a message documenting a guarded command
# (e.g. `git push --force`) used to trip the guard because the old line-oriented
# `sed` couldn't strip across newlines. Conv 213 [SETTINGS-GUARD]; Conv 459.
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
#
# The force-push rule (below) scopes the force flag to the push invocation with
# `[^;|&]*` — it must appear AFTER `push` and BEFORE the next command separator.
# The prior form ran two independent `has` checks over the whole string ("is
# there a git push?" AND "is there a force flag?"), so any compound command
# pairing a plain `git push` with an unrelated `-f` (e.g. `rm -f .conv-branch`,
# on essentially every /r-end and /r-commit push batch) false-fired the guard.
# grep is line-oriented, so `[^;|&]` also can't cross a newline. Conv 458.
GITOPTS='([[:space:]]+(-C|-c)[[:space:]]+[^[:space:]]+|[[:space:]]+--[A-Za-z][A-Za-z-]*(=[^[:space:]]+)?|[[:space:]]+-[A-Za-z])*'

# Scan copy. For `git commit`, exclude the inert message body from the danger
# scan (`-m "..."` / `-m '...'` / `--message=...`). `perl -0777` slurps the whole
# command so the strip spans newlines (multi-line v2 messages); the double-quoted
# pattern `"([^"\\]|\\.)*"` tolerates escaped `\"` and stops at the first UNESCAPED
# closing quote, so a chained `&& wrangler --remote` after the message is still
# scanned. Single-quoted shell strings can't contain escapes, so `'[^']*'` (via
# \x27) suffices there. Conv 459 (was line-oriented sed, Conv 213).
scan=$cmd
if printf '%s' "$cmd" | grep -Eiq "\\bgit\\b${GITOPTS}[[:space:]]+commit\\b"; then
  scan=$(printf '%s' "$cmd" | perl -0777 -pe \
    's/(-m|--message)[\s=]+"([^"\\]|\\.)*"//gs; s/(-m|--message)[\s=]+\x27([^\x27\\]|\\.)*\x27//gs')
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
elif has "\\bgit\\b${GITOPTS}[[:space:]]+push\\b[^;|&]*(--force\\b|--force-with-lease\\b|[[:space:]]-f([[:space:]]|\$))"; then
  reason="Force push rewrites remote history (also denied for the bare form; this catches the git -C … form deny prefixes miss)."
elif has '\blsof\b' && has '\b(kill|pkill|killall)\b'; then
  reason="Port-based process kill (lsof + kill). lsof -ti:PORT returns EVERY process on that port — including the user's Chrome (verified Conv 429: pid was Chrome's NetworkService, not the server) and any pre-existing dev server this session did not start (Conv 393). Use \`npx astro dev stop\` (reads .astro/dev.json, kills only this project's pid)."
fi

if [ -n "$reason" ]; then
  jq -nc --arg r "Dangerous-command guard: ${reason}" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}'
fi
exit 0
