#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
HOOK="$SCRIPT_DIR/../hooks/tmux-notify.sh"
TEST_DIR=$(mktemp -d)

cleanup() {
  rm -rf "$TEST_DIR"
}

trap cleanup EXIT

mkdir -p "$TEST_DIR/bin"

cat >"$TEST_DIR/bin/tmux" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "${CODEX_TEST_TMUX_DISPLAY:-work:2.1 0 0 1 $CODEX_TEST_PANE_TTY}"
EOF

cat >"$TEST_DIR/bin/terminal-notifier" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@" >"$CODEX_TEST_CAPTURE"
EOF

cat >"$TEST_DIR/bin/osascript" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@" >"$CODEX_TEST_CAPTURE"
EOF

cat >"$TEST_DIR/bin/lsappinfo" <<'EOF'
#!/usr/bin/env bash

if [[ $1 == front ]]; then
  printf 'ASN:0x0-0x12345:\n'
else
  printf '"LSDisplayName"="iTerm2"\n'
fi
EOF

chmod +x "$TEST_DIR/bin/tmux" "$TEST_DIR/bin/terminal-notifier" "$TEST_DIR/bin/osascript" "$TEST_DIR/bin/lsappinfo"
: >"$TEST_DIR/pane-tty"

payload='{"hook_event_name":"Stop","cwd":"/Users/khris/code/dotenv","last_assistant_message":"Done and verified."}'
output=$(
  printf '%s' "$payload" | env \
    PATH="$TEST_DIR/bin:$PATH" \
    TMUX=test \
    TMUX_PANE=%3 \
    CODEX_NOTIFY_ALWAYS=1 \
    CODEX_TEST_CAPTURE="$TEST_DIR/notifier-args" \
    CODEX_TEST_PANE_TTY="$TEST_DIR/pane-tty" \
    "$HOOK" done
)

expected=$(cat <<EOF
-title
Codex finished
-subtitle
work:2.1 · dotenv
-message
Done and verified.
-sound
Ping
-group
codex-%3
-execute
$HOME/.codex/hooks/tmux-goto.sh %3
EOF
)

if [[ $output != '{}' ]]; then
  printf 'FAIL: expected Stop hook output {}, got %q\n' "$output" >&2
  exit 1
fi

if [[ $(cat "$TEST_DIR/notifier-args") != "$expected" ]]; then
  printf 'FAIL: terminal-notifier arguments did not match\n' >&2
  diff -u <(printf '%s\n' "$expected") "$TEST_DIR/notifier-args" >&2 || true
  exit 1
fi

if [[ $(od -An -t u1 "$TEST_DIR/pane-tty" | tr -d ' ') != 7 ]]; then
  printf 'FAIL: expected a BEL byte in the pane tty\n' >&2
  exit 1
fi

printf 'PASS: Stop sends the Codex completion notification\n'

: >"$TEST_DIR/pane-tty"
payload='{"hook_event_name":"PermissionRequest","cwd":"/Users/khris/code/dotenv","tool_name":"Bash","tool_input":{"description":"Run outside the sandbox"}}'
output=$(
  printf '%s' "$payload" | env \
    PATH="$TEST_DIR/bin:$PATH" \
    TMUX=test \
    TMUX_PANE=%3 \
    CODEX_NOTIFY_ALWAYS=1 \
    CODEX_TEST_CAPTURE="$TEST_DIR/notifier-args" \
    CODEX_TEST_PANE_TTY="$TEST_DIR/pane-tty" \
    "$HOOK" input
)

expected=$(cat <<EOF
-title
Codex needs approval
-subtitle
work:2.1 · dotenv
-message
Run outside the sandbox
-sound
Ping
-group
codex-%3
-execute
$HOME/.codex/hooks/tmux-goto.sh %3
EOF
)

if [[ -n $output ]]; then
  printf 'FAIL: expected no PermissionRequest hook output, got %q\n' "$output" >&2
  exit 1
fi

if [[ $(cat "$TEST_DIR/notifier-args") != "$expected" ]]; then
  printf 'FAIL: approval terminal-notifier arguments did not match\n' >&2
  diff -u <(printf '%s\n' "$expected") "$TEST_DIR/notifier-args" >&2 || true
  exit 1
fi

if [[ $(od -An -t u1 "$TEST_DIR/pane-tty" | tr -d ' ') != 7 ]]; then
  printf 'FAIL: expected a BEL byte in the pane tty for approval\n' >&2
  exit 1
fi

printf 'PASS: PermissionRequest sends the Codex approval notification\n'

rm -f "$TEST_DIR/notifier-args"
payload='{"hook_event_name":"Stop","cwd":"/Users/khris/code/dotenv","last_assistant_message":"Done and verified."}'
output=$(
  printf '%s' "$payload" | env \
    PATH="$TEST_DIR/bin:$PATH" \
    CODEX_NOTIFY_ALWAYS=1 \
    CODEX_TEST_CAPTURE="$TEST_DIR/notifier-args" \
    "$HOOK" done
)

if [[ $output != '{}' ]]; then
  printf 'FAIL: expected Stop hook output {} outside tmux, got %q\n' "$output" >&2
  exit 1
fi

if [[ -e $TEST_DIR/notifier-args ]]; then
  printf 'FAIL: desktop sessions should not receive the CLI tmux notification\n' >&2
  exit 1
fi

printf 'PASS: sessions outside tmux do not receive CLI notifications\n'

: >"$TEST_DIR/pane-tty"
rm -f "$TEST_DIR/notifier-args"
payload='{"hook_event_name":"Stop","cwd":"/Users/khris/code/dotenv","last_assistant_message":"Done and verified."}'
output=$(
  printf '%s' "$payload" | env \
    PATH="$TEST_DIR/bin:$PATH" \
    TMUX=test \
    TMUX_PANE=%3 \
    CODEX_TEST_CAPTURE="$TEST_DIR/notifier-args" \
    CODEX_TEST_PANE_TTY="$TEST_DIR/pane-tty" \
    CODEX_TEST_TMUX_DISPLAY="work:2.1 1 1 1 $TEST_DIR/pane-tty" \
    "$HOOK" done
)

if [[ $output != '{}' ]]; then
  printf 'FAIL: expected Stop hook output {} for the visible pane, got %q\n' "$output" >&2
  exit 1
fi

if [[ -e $TEST_DIR/notifier-args ]]; then
  printf 'FAIL: the visible frontmost pane should not receive a notification\n' >&2
  exit 1
fi

if [[ -s $TEST_DIR/pane-tty ]]; then
  printf 'FAIL: the visible frontmost pane should not receive a BEL byte\n' >&2
  exit 1
fi

printf 'PASS: the visible frontmost pane suppresses its notification\n'
