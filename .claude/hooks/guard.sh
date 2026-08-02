#!/usr/bin/env bash
# guard.sh — PreToolUse hook for Bash commands.
#
# Blocks a short list of destructive or forbidden commands: exit 2 with the
# reason on stderr (fed back to the agent). Everything else exits 0.
#
# Defensive by design: if stdin is empty, unparsable, or jq is missing, the
# hook exits 0 — it must NEVER break the session.
set -uo pipefail

input=$(cat 2>/dev/null || true)
[ -n "$input" ] || exit 0

if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null) || cmd=""
else
  # Fallback: no jq available — inspect the raw stdin instead.
  cmd="$input"
fi
[ -n "$cmd" ] || exit 0

# For .env checks only: mentions of .env.example are legitimate (onboarding
# appends keys to it), so strip them before matching.
cmd_no_example=$(printf '%s' "$cmd" | sed 's/\.env\.example//g' 2>/dev/null || printf '%s' "$cmd")

deny() {
  printf 'BLOCKED by .claude/hooks/guard.sh: %s\n' "$1" >&2
  exit 2
}

matches() { printf '%s' "$cmd" | grep -Eq "$1"; }
matches_no_example() { printf '%s' "$cmd_no_example" | grep -Eq "$1"; }

# 1. rm -rf targeting filesystem root or home
if matches '(^|[;&|[:space:]"])rm[[:space:]]+(-{1,2}[A-Za-z-]+[[:space:]]+)+(/|~|\$HOME)/?\*?[[:space:]]*($|[;&|"])' \
  && matches '(^|[;&|[:space:]"])rm[[:space:]]+[^;&|]*-[A-Za-z-]*[rR]' \
  && matches '(^|[;&|[:space:]"])rm[[:space:]]+[^;&|]*-[A-Za-z-]*[fF]'; then
  deny "rm -rf on / or ~ is never allowed."
fi

# 2. Force-push to main/master (either flag order, or the +branch refspec)
if matches 'git[[:space:]]+push'; then
  if matches 'git[[:space:]]+push[^;&|]*[[:space:]](--force(-with-lease[^[:space:]]*)?|-f)([[:space:]]|$|")[^;&|]*[[:space:]](main|master)([[:space:]]|$|:|")' \
    || matches 'git[[:space:]]+push[^;&|]*[[:space:]](main|master)([[:space:]]|:|")([^;&|]*[[:space:]])?(--force(-with-lease[^[:space:]]*)?|-f)([[:space:]]|$|")' \
    || matches 'git[[:space:]]+push[^;&|]*[[:space:]]\+(main|master)([[:space:]]|$|")'; then
    deny "Force-pushing to main/master is not allowed. Push a branch instead, or ask the user."
  fi
fi

# 3. git reset --hard requires an explicit user-approval marker
if matches 'git[[:space:]]+reset[^;&|]*--hard' && ! matches '#[[:space:]]*user-approved'; then
  deny "git reset --hard destroys uncommitted work. Ask the user first; if they approve, re-run with a trailing marker: git reset --hard <ref> # user-approved"
fi

# 4. sudo
if matches '(^|[;&|[:space:]"])sudo([[:space:]]|$|")'; then
  deny "sudo is not allowed. Nothing in this project requires elevated privileges."
fi

# 5. Piping curl/wget into a shell
if matches '(curl|wget)[^;&|]*\|[[:space:]]*(sudo[[:space:]]+)?(/[^[:space:]]*/)?(bash|sh|zsh|dash|ksh|fish)([[:space:]]|$|")'; then
  deny "Piping curl/wget into a shell executes untrusted remote code. Download, inspect, then run."
fi

# 6. Writing to .env (redirection)
if matches_no_example '>>?[[:space:]]*(\./)?\.env(\.[A-Za-z0-9_-]+)?([[:space:]]|$|[;&|"])'; then
  deny ".env files must never be written by the agent. Tell the user which key to add and let them edit .env themselves (.env.example is the documented exception)."
fi

# 7. Reading .env through common readers.
# The char right before `.env` must be a path boundary (space, quote or slash),
# so a search PATTERN that merely mentions .env — grep "Read(.env" settings.json
# — is not mistaken for an actual read of the file.
if matches_no_example '(^|[;&|[:space:]"])(cat|grep|egrep|fgrep|head|tail|less|more)([[:space:]][^;&|]*)?[[:space:]"/]\.env(\.[A-Za-z0-9_-]+)?([[:space:]]|$|[;&|)"])'; then
  deny ".env files contain secrets and must never be read. Use .env.example to know which keys exist."
fi

# 8. Skipping commit hooks
if matches 'git[[:space:]]+commit[^;&|]*--no-verify'; then
  deny "git commit --no-verify skips the project's checks. Fix the failure instead of bypassing it."
fi

# 9. World-writable permissions
if matches 'chmod[[:space:]]+(-[A-Za-z]+[[:space:]]+)*0?777'; then
  deny "chmod 777 is never acceptable. Use the minimal permission needed (e.g. chmod +x for scripts)."
fi

# 10. Killing all processes (kill with PID -1)
if matches '(^|[;&|[:space:]"])kill[[:space:]]+(-[A-Za-z0-9]+[[:space:]]+)*-1[[:space:]]*($|[;&|"])'; then
  deny "kill -1 signals every process you own. Target a specific PID instead."
fi

exit 0
