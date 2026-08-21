#!/usr/bin/env bash
# Focus a tmux pane by pane id, and raise the terminal app.
# Called by terminal-notifier when you click a Claude Code notification.
#
# Usage: tmux-goto.sh <pane-id>          e.g. tmux-goto.sh %21
# Override the terminal with CLAUDE_TERMINAL_BUNDLE_ID.

set -uo pipefail

# A notification click launches this from the GUI, which supplies only
# /usr/bin:/bin:/usr/sbin:/sbin. Homebrew's tmux would not be found.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

pane=${1:-}
[[ -z $pane ]] && exit 0

session=$(tmux display-message -p -t "$pane" '#{session_name}' 2>/dev/null) || exit 0
[[ -z $session ]] && exit 0

# Prefer a client already on that session; otherwise repoint any client at it.
client=$(tmux list-clients -t "$session" -F '#{client_tty}' 2>/dev/null | head -1)

if [[ -z $client ]]; then
  client=$(tmux list-clients -F '#{client_tty}' 2>/dev/null | head -1)

  if [[ -n $client ]]; then
    tmux switch-client -c "$client" -t "$session" 2>/dev/null || true
  fi
fi

tmux select-window -t "$pane" 2>/dev/null || true
tmux select-pane -t "$pane" 2>/dev/null || true

open -b "${CLAUDE_TERMINAL_BUNDLE_ID:-com.googlecode.iterm2}" 2>/dev/null || true

exit 0
