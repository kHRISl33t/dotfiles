#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
HOOK="$SCRIPT_DIR/../hooks/tmux-goto.sh"
TEST_DIR=$(mktemp -d)

cleanup() {
  rm -rf "$TEST_DIR"
}

trap cleanup EXIT

mkdir -p "$TEST_DIR/bin"

cat >"$TEST_DIR/bin/tmux" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$CODEX_TEST_TMUX_CALLS"

case "$1" in
  display-message) printf 'work\n' ;;
  list-clients) printf '/dev/ttys001\n' ;;
esac
EOF

cat >"$TEST_DIR/bin/open" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$@" >"$CODEX_TEST_OPEN_ARGS"
EOF

chmod +x "$TEST_DIR/bin/tmux" "$TEST_DIR/bin/open"

env \
  PATH="$TEST_DIR/bin:$PATH" \
  CODEX_TERMINAL_BUNDLE_ID=com.example.Terminal \
  CODEX_TEST_TMUX_CALLS="$TEST_DIR/tmux-calls" \
  CODEX_TEST_OPEN_ARGS="$TEST_DIR/open-args" \
  "$HOOK" %3

expected_tmux=$(cat <<'EOF'
display-message -p -t %3 #{session_name}
list-clients -t work -F #{client_tty}
select-window -t %3
select-pane -t %3
EOF
)

if [[ $(cat "$TEST_DIR/tmux-calls") != "$expected_tmux" ]]; then
  printf 'FAIL: tmux navigation calls did not match\n' >&2
  diff -u <(printf '%s\n' "$expected_tmux") "$TEST_DIR/tmux-calls" >&2 || true
  exit 1
fi

expected_open=$(cat <<'EOF'
-b
com.example.Terminal
EOF
)

if [[ $(cat "$TEST_DIR/open-args") != "$expected_open" ]]; then
  printf 'FAIL: terminal activation arguments did not match\n' >&2
  diff -u <(printf '%s\n' "$expected_open") "$TEST_DIR/open-args" >&2 || true
  exit 1
fi

printf 'PASS: notification clicks select the pane and raise the terminal\n'
