#!/usr/bin/env bash

set -euo pipefail

ITERM_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)
TEST_ROOT=$(mktemp -d "$ITERM_DIR/tests/.tmp.XXXXXX")

cleanup() {
  rm -r "$TEST_ROOT"
}

trap cleanup EXIT

TEST_HOME="$TEST_ROOT/home"
TARGET="$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json"
BACKUP_DIR="$TEST_HOME/Library/Application Support/iTerm2/DynamicProfiles Backups"

HOME="$TEST_HOME" "$ITERM_DIR/install.sh"

cmp "$ITERM_DIR/dotfiles.json" "$TARGET"
jq empty "$TARGET"

[[ $(jq -r '.Profiles[0].Name' "$TARGET") == Dotfiles ]]
[[ $(jq -r '.Profiles[0].Guid' "$TARGET") == 3E1098BA-3059-4A89-B340-092A2110B708 ]]
[[ $(jq -r '.Profiles[0]["Normal Font"]' "$TARGET") == 'HackNFM-Bold 12' ]]
[[ $(jq -r '.Profiles[0].Transparency' "$TARGET") == 0.08 ]]

if jq -e '.Profiles[0] | has("Working Directory")' "$TARGET" >/dev/null; then
  printf 'Working Directory must not be present in the portable profile.\n' >&2
  exit 1
fi

printf 'locally edited\n' >"$TARGET"
HOME="$TEST_HOME" "$ITERM_DIR/install.sh"

cmp "$ITERM_DIR/dotfiles.json" "$TARGET"
[[ $(find "$BACKUP_DIR" -type f -name 'dotfiles.json.backup-*' | wc -l | tr -d ' ') == 1 ]]
grep -q '^locally edited$' "$BACKUP_DIR"/dotfiles.json.backup-*

printf 'iTerm2 installer tests passed.\n'
