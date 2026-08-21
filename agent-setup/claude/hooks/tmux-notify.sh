#!/usr/bin/env bash
# macOS notification when a Claude Code turn ends or needs input.
# Names the tmux session:window.pane so you know which one to go back to,
# and rings the pane's bell so tmux flags that window in the status bar.
#
# Usage (from a settings.json hook): tmux-notify.sh done|input
# Set CLAUDE_NOTIFY_ALWAYS=1 to notify even when you are already looking at the pane.

set -uo pipefail

kind=${1:-done}
payload=$(cat 2>/dev/null || true)

cwd=$(jq -r '.cwd // empty' <<<"$payload" 2>/dev/null)
msg=$(jq -r '.message // empty' <<<"$payload" 2>/dev/null)
project=$(basename "${cwd:-$PWD}")

loc=""
win_active=0
pane_active=0
attached=0
pane_tty=""

if [[ -n ${TMUX:-} && -n ${TMUX_PANE:-} ]]; then
  fmt='#{session_name}:#{window_index}.#{pane_index} #{window_active} #{pane_active} #{session_attached} #{pane_tty}'
  read -r loc win_active pane_active attached pane_tty < <(tmux display-message -p -t "$TMUX_PANE" "$fmt" 2>/dev/null)
fi

# Suppress when the pane is already on screen and the terminal is frontmost.
if [[ ${CLAUDE_NOTIFY_ALWAYS:-0} != 1 ]]; then
  frontmost=""
  asn=$(/usr/bin/lsappinfo front 2>/dev/null)

  if [[ -n $asn ]]; then
    frontmost=$(/usr/bin/lsappinfo info -only name "$asn" 2>/dev/null | sed -n 's/.*"LSDisplayName"="\(.*\)".*/\1/p')
  fi

  case "$frontmost" in
    iTerm2 | Terminal | Ghostty | Alacritty | WezTerm | kitty | Warp | Hyper | Tabby) terminal_front=1 ;;
    *) terminal_front=0 ;;
  esac

  if [[ $terminal_front == 1 && $win_active == 1 && $pane_active == 1 && $attached != 0 ]]; then
    exit 0
  fi
fi

if [[ $kind == input ]]; then
  title="Claude Code needs you"
  body=${msg:-"Waiting for input"}
else
  title="Claude Code finished"
  body=${msg:-"Turn complete"}
fi

subtitle="${loc:-not in tmux} · $project"

# Bell in the pane so tmux marks the window in the status bar until you visit it.
if [[ -n $pane_tty && -w $pane_tty ]]; then
  printf '\a' >"$pane_tty" 2>/dev/null || true
fi

notifier=$(command -v terminal-notifier 2>/dev/null)

if [[ -n $notifier && -n ${TMUX_PANE:-} ]]; then
  # -group collapses repeat alerts for the same pane instead of stacking them.
  # -execute jumps you to the pane when you click the banner.
  "$notifier" \
    -title "$title" \
    -subtitle "$subtitle" \
    -message "$body" \
    -sound Ping \
    -group "claude-code-$TMUX_PANE" \
    -execute "$HOME/.claude/hooks/tmux-goto.sh $TMUX_PANE" \
    >/dev/null 2>&1
else
  esc() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'; }

  osascript -e "display notification \"$(esc "$body")\" with title \"$(esc "$title")\" subtitle \"$(esc "$subtitle")\" sound name \"Ping\"" >/dev/null 2>&1
fi

exit 0
