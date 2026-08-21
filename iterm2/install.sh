#!/usr/bin/env bash
# Install the tracked iTerm2 Dynamic Profile.
#
# Usage: iterm2/install.sh

set -euo pipefail

ITERM_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
SOURCE="$ITERM_DIR/dotfiles.json"
PROFILE_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
BACKUP_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles Backups"
TARGET="$PROFILE_DIR/dotfiles.json"
STAMP=$(date +%Y%m%d-%H%M%S)

if [[ ! -f $SOURCE ]]; then
  printf 'Missing profile: %s\n' "$SOURCE" >&2
  exit 1
fi

if ! jq empty "$SOURCE"; then
  printf 'Invalid profile JSON: %s\n' "$SOURCE" >&2
  exit 1
fi

if [[ -f $TARGET ]] && cmp -s "$SOURCE" "$TARGET"; then
  printf 'ok       %s\n' "$TARGET"
else
  if [[ -e $TARGET || -L $TARGET ]]; then
    BACKUP="$BACKUP_DIR/dotfiles.json.backup-$STAMP"
    mkdir -p "$BACKUP_DIR"
    mv "$TARGET" "$BACKUP"
    printf 'BACKED   %s -> %s\n' "$TARGET" "$BACKUP"
  fi

  mkdir -p "$PROFILE_DIR"
  cp "$SOURCE" "$TARGET"
  chmod 0644 "$TARGET"
  printf 'INSTALLED %s\n' "$TARGET"
fi

printf '\nSelect Profiles > Dotfiles > Other Actions > Set as Default in iTerm2 Settings.\n'
