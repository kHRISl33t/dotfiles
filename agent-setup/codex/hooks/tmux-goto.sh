#!/usr/bin/env bash
# Focus the tmux pane associated with a clicked Codex notification.

set -uo pipefail

export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

pane=${1:-}
[[ -z $pane ]] && exit 0

session=$(tmux display-message -p -t "$pane" '#{session_name}' 2>/dev/null) || exit 0
[[ -z $session ]] && exit 0

client=$(tmux list-clients -t "$session" -F '#{client_tty}' 2>/dev/null | head -1)

if [[ -z $client ]]; then
  client=$(tmux list-clients -F '#{client_tty}' 2>/dev/null | head -1)

  if [[ -n $client ]]; then
    tmux switch-client -c "$client" -t "$session" 2>/dev/null || true
  fi
fi

tmux select-window -t "$pane" 2>/dev/null || true
tmux select-pane -t "$pane" 2>/dev/null || true

open -b "${CODEX_TERMINAL_BUNDLE_ID:-com.googlecode.iterm2}" 2>/dev/null || true

exit 0
