#!/usr/bin/env bash
# Check that every agent config link resolves to this repository.
#
# Exits non-zero if anything is missing, dangling, or points somewhere else.
# A dangling link is the failure this script exists to catch: Claude and Codex
# both fall back to loading nothing, silently, with no warning at startup.
#
# Usage: agent-setup/verify.sh

set -uo pipefail

SETUP_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
FAILED=0

fail() {
  printf 'FAIL  %s\n      %s\n' "$1" "$2"
  FAILED=1
}

check_link() {
  local expected=$1 linkname=$2

  if [[ ! -L $linkname ]]; then
    if [[ -e $linkname ]]; then
      fail "$linkname" "is a real file, not a link into this repo. Run install.sh."
    else
      fail "$linkname" "does not exist. Run install.sh."
    fi

    return
  fi

  local actual
  actual=$(readlink "$linkname")

  if [[ $actual != "$expected" ]]; then
    fail "$linkname" "points at $actual, expected $expected"
    return
  fi

  if [[ ! -e $linkname ]]; then
    fail "$linkname" "is dangling. Target missing: $actual"
    return
  fi

  printf 'ok    %s\n' "$linkname"
}

printf 'Verifying against %s\n\n' "$SETUP_DIR"

check_link "$SETUP_DIR/claude/settings.json" "$HOME/.claude/settings.json"
check_link "$SETUP_DIR/claude/hooks" "$HOME/.claude/hooks"
check_link "$SETUP_DIR/claude/agents" "$HOME/.claude/agents"
check_link "$SETUP_DIR/claude/commands" "$HOME/.claude/commands"
check_link "$SETUP_DIR/AGENTS.md" "$HOME/.codex/AGENTS.md"
check_link "$SETUP_DIR/codex/hooks.json" "$HOME/.codex/hooks.json"
check_link "$SETUP_DIR/codex/hooks" "$HOME/.codex/hooks"

# The generated CLAUDE.md is a real file, so check its imports resolve instead.
CLAUDE_MD="$HOME/.claude/CLAUDE.md"

if [[ ! -f $CLAUDE_MD ]]; then
  fail "$CLAUDE_MD" "does not exist. Run install.sh."
else
  while read -r import; do
    if [[ -e $import ]]; then
      printf 'ok    %s imports %s\n' "$CLAUDE_MD" "$import"
    else
      fail "$CLAUDE_MD" "imports a missing file: $import. Run install.sh."
    fi
  done < <(grep -o '^@.*' "$CLAUDE_MD" | sed 's/^@//')
fi

if [[ ! -x $SETUP_DIR/claude/hooks/tmux-notify.sh ]]; then
  fail "$SETUP_DIR/claude/hooks/tmux-notify.sh" "is not executable. Run chmod +x on the hooks."
fi

if [[ ! -x $SETUP_DIR/claude/hooks/tmux-goto.sh ]]; then
  fail "$SETUP_DIR/claude/hooks/tmux-goto.sh" "is not executable. Run chmod +x on the hooks."
fi

if [[ ! -x $SETUP_DIR/codex/hooks/tmux-notify.sh ]]; then
  fail "$SETUP_DIR/codex/hooks/tmux-notify.sh" "is not executable. Run chmod +x on the hooks."
fi

if [[ ! -x $SETUP_DIR/codex/hooks/tmux-goto.sh ]]; then
  fail "$SETUP_DIR/codex/hooks/tmux-goto.sh" "is not executable. Run chmod +x on the hooks."
fi

printf '\n'

if [[ $FAILED == 1 ]]; then
  printf 'Something is wrong. Run %s/install.sh to repair.\n' "$SETUP_DIR"
  exit 1
fi

printf 'All links resolve.\n'
