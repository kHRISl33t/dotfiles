#!/usr/bin/env bash
# Notify when a Codex CLI turn ends or needs approval.
# The banner names the tmux pane, and its click target jumps back to that pane.

set -uo pipefail

kind=${1:-done}
payload=$(cat 2>/dev/null || true)

cwd=$(jq -r '.cwd // empty' <<<"$payload" 2>/dev/null)
msg=$(jq -r '.last_assistant_message // .tool_input.description // .message // empty' <<<"$payload" 2>/dev/null)
project=$(basename "${cwd:-$PWD}")

loc=""
win_active=0
pane_active=0
attached=0
pane_tty=""

finish() {
  if [[ $kind == done ]]; then
    printf '{}\n'
  fi

  exit 0
}

if [[ -z ${TMUX:-} || -z ${TMUX_PANE:-} ]]; then
  finish
fi

fmt='#{session_name}:#{window_index}.#{pane_index} #{window_active} #{pane_active} #{session_attached} #{pane_tty}'
read -r loc win_active pane_active attached pane_tty < <(tmux display-message -p -t "$TMUX_PANE" "$fmt" 2>/dev/null)

if [[ ${CODEX_NOTIFY_ALWAYS:-0} != 1 ]]; then
  frontmost=""
  asn=$(lsappinfo front 2>/dev/null)

  if [[ -n $asn ]]; then
    frontmost=$(lsappinfo info -only name "$asn" 2>/dev/null | sed -n 's/.*"LSDisplayName"="\(.*\)".*/\1/p')
  fi

  case "$frontmost" in
    iTerm2 | Terminal | Ghostty | Alacritty | WezTerm | kitty | Warp | Hyper | Tabby) terminal_front=1 ;;
    *) terminal_front=0 ;;
  esac

  if [[ $terminal_front == 1 && $win_active == 1 && $pane_active == 1 && $attached != 0 ]]; then
    finish
  fi
fi

if [[ $kind == input ]]; then
  title="Codex needs approval"
  body=${msg:-"Waiting for approval"}
else
  title="Codex finished"
  body=${msg:-"Turn complete"}
fi
subtitle="${loc:-not in tmux} · $project"

if [[ -n $pane_tty && -w $pane_tty ]]; then
  printf '\a' >"$pane_tty" 2>/dev/null || true
fi

notifier=$(command -v terminal-notifier 2>/dev/null)

if [[ -n $notifier && -n ${TMUX_PANE:-} ]]; then
  "$notifier" \
    -title "$title" \
    -subtitle "$subtitle" \
    -message "$body" \
    -sound Ping \
    -group "codex-$TMUX_PANE" \
    -execute "$HOME/.codex/hooks/tmux-goto.sh $TMUX_PANE" \
    >/dev/null 2>&1
else
  esc() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'; }

  osascript -e "display notification \"$(esc "$body")\" with title \"$(esc "$title")\" subtitle \"$(esc "$subtitle")\" sound name \"Ping\"" >/dev/null 2>&1
fi

finish
