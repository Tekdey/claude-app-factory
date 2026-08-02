#!/usr/bin/env bash
# session-context.sh — SessionStart hook.
#
# Prints project status to stdout; Claude Code injects it as additional
# context at the start of every session. Every section is optional and
# failure-proof: this hook must NEVER fail or break a session.
set -uo pipefail

cd "${CLAUDE_PROJECT_DIR:-$PWD}" 2>/dev/null || true

# Template mode: onboarding has not been run yet.
if [ ! -f docs/constitution.md ]; then
  cat <<'EOF'
⚠️ ONBOARDING NOT DONE — this repo is a freshly cloned template.
Suggest the user run /onboard. Do not build features before onboarding.
EOF
  exit 0
fi

echo "=== Session context (auto-injected by .claude/hooks/session-context.sh) ==="

if [ -f PROGRESS.md ]; then
  echo ""
  echo "--- PROGRESS.md (last 15 lines) ---"
  tail -n 15 PROGRESS.md 2>/dev/null || true
fi

if [ -f features.json ] && command -v jq >/dev/null 2>&1; then
  total=$(jq -r '.features | length' features.json 2>/dev/null || echo "")
  passing=$(jq -r '[.features[] | select(.passes == true)] | length' features.json 2>/dev/null || echo "")
  if [ -n "$total" ] && [ -n "$passing" ]; then
    echo ""
    echo "--- features.json ---"
    echo "$passing/$total passing"
    echo "Next candidates (passes:false):"
    jq -r '[.features[] | select(.passes == false)] | .[0:3][] | "  \(.id) [\(.priority)] \(.title)"' \
      features.json 2>/dev/null || true
  fi
fi

if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
  echo ""
  echo "--- git ---"
  echo "branch: $branch"
  status_lines=$(git status --short 2>/dev/null | head -n 10 || true)
  if [ -n "$status_lines" ]; then
    echo "$status_lines"
  else
    echo "working tree clean"
  fi
fi

exit 0
