# Claude Code notifications for tmux on macOS

When a Claude Code session finishes a turn or needs your input, you get a macOS
notification that tells you which tmux pane it came from. Clicking the
notification brings iTerm2 to the front and jumps you to that exact window and
pane.

It stays quiet while you are actually looking at the pane, so you are not
pinged on every single turn while you work.

## What you get

A banner like this:

```
Claude Code finished
web-api:1.2 · my-project
Turn complete
```

The subtitle is `session:window.pane · project`. In the example above the
session is `web-api`, window `1`, pane `2`, and the project directory is
`my-project`. That is enough to know where to go back to, and clicking the
banner takes you there without you having to read it.

The tmux window also gets flagged in the status bar and stays flagged until you
visit it, so you can find the right window even after the banner is gone.

## Files in this folder

| File | Goes to | Purpose |
|---|---|---|
| `tmux.conf` | `~/.tmux.conf` | tmux config, including the bell setting this needs |
| `hooks/tmux-notify.sh` | `~/.claude/hooks/tmux-notify.sh` | Builds and sends the notification |
| `hooks/tmux-goto.sh` | `~/.claude/hooks/tmux-goto.sh` | Jumps to the pane when you click |
| `claude-settings-hooks.json` | merge into `~/.claude/settings.json` | Tells Claude Code when to run the notify script |

## Requirements

- macOS
- tmux
- `jq`, used to read the hook payload
- `terminal-notifier`, for clickable notifications

Install the two tools:

```bash
brew install jq terminal-notifier
```

`terminal-notifier` is optional. Without it the scripts fall back to
`osascript`, which still shows a banner but cannot be clicked to jump. If you
skip it, you get the notification text but not the jump.

## Setup from scratch

### 1. Install the scripts

```bash
mkdir -p ~/.claude/hooks
cp hooks/tmux-notify.sh ~/.claude/hooks/tmux-notify.sh
cp hooks/tmux-goto.sh ~/.claude/hooks/tmux-goto.sh
chmod +x ~/.claude/hooks/tmux-notify.sh ~/.claude/hooks/tmux-goto.sh
```

### 2. Register the hooks with Claude Code

Open `~/.claude/settings.json` and merge in the `hooks` block from
`claude-settings-hooks.json`. Merge, do not replace the file. If a `hooks` key
is already there, add the `Notification` and `Stop` entries to it rather than
overwriting.

Two events are wired up:

- `Notification` fires when Claude wants permission or is waiting on you.
- `Stop` fires when Claude finishes a turn.

Both are marked `async: true` so they never hold up the session.

Verify the JSON parsed correctly and the commands are where you expect:

```bash
jq -e '.hooks.Stop[].hooks[].command' ~/.claude/settings.json
jq -e '.hooks.Notification[].hooks[].command' ~/.claude/settings.json
```

Each should print the command string. A broken `settings.json` silently
disables every setting in the file, so do not skip this check.

### 3. Fix the tmux bell setting

The scripts ring the pane's bell so tmux flags the window in the status bar.
tmux only acts on that bell if `bell-action` is not `none`.

In `~/.tmux.conf`:

```tmux
set-option -g bell-action other
```

`other` means only flag windows you are not currently viewing, which is what
you want. The copy of `tmux.conf` in this folder already has this on line 79.

Reload and confirm:

```bash
tmux source-file ~/.tmux.conf
tmux show-options -g bell-action
```

You want `bell-action other`.

### 4. Restart Claude Code

Hooks are read at startup. Open `/hooks` once inside a session to force a
config reload, or just restart.

### 5. Test it

Send yourself a notification without waiting for a real turn to end:

```bash
echo '{"cwd":"'"$PWD"'"}' | CLAUDE_NOTIFY_ALWAYS=1 ~/.claude/hooks/tmux-notify.sh done
```

`CLAUDE_NOTIFY_ALWAYS=1` skips the "are you already looking at this pane"
check, which otherwise suppresses the notification while you are watching.

To test the click, switch to another app or another tmux window first, then
click the banner. You should land back in the right pane with iTerm2 in front.

### 6. Pick the banner behaviour

An app only appears in notification settings after it has sent its first
notification, so do this after step 5, not before.

1. Open the pane directly:
   ```bash
   open "x-apple.systempreferences:com.apple.Notifications-Settings.extension"
   ```
2. Find **terminal-notifier** in the Application Notifications list and click it.
3. Set **Alert Style** to **Temporary**.
4. Leave the **Notification Center** checkbox ticked.

**Temporary** fades the banner on its own after a few seconds. **Persistent**
leaves it on screen until you click or dismiss it. On macOS before 26 these were
labelled **Banners** and **Alerts**.

The Notification Center checkbox is the important half. With it ticked, a faded
banner is still waiting in Notification Center and clicking it there performs the
same jump, so missing the banner costs you nothing.

The on-screen duration itself is not configurable. `terminal-notifier` 2.0.0 has
no timeout flag, and the old
`defaults write com.apple.notificationcenterui bannerTime` trick does nothing on
modern macOS, where that domain lives in a sandboxed container. You get
Temporary or Persistent and nothing in between.

Notification settings live in `com.apple.ncprefs`, which is sandboxed and not
readable or writable from a script, so this step cannot be automated.

## How the suppression works

`tmux-notify.sh` stays quiet when all of these are true:

- the pane is the active pane in its window
- that window is the active window in its session
- the session has a client attached
- the frontmost macOS app is a terminal

In other words, it only notifies when you cannot already see the output. The
frontmost app is read with `lsappinfo`, which needs no special permissions,
unlike the usual System Events approach.

Set `CLAUDE_NOTIFY_ALWAYS=1` to notify regardless.

## Customising

**Different terminal.** The terminal check lives in a `case` statement in
`tmux-notify.sh` and already covers iTerm2, Terminal, Ghostty, Alacritty,
WezTerm, kitty, Warp, Hyper and Tabby. For the click-to-raise behaviour, set
the bundle id:

```bash
export CLAUDE_TERMINAL_BUNDLE_ID=com.mitchellh.ghostty
```

Find any app's bundle id with `osascript -e 'id of app "AppName"'`.

**Different sound.** Change `-sound Ping` in `tmux-notify.sh`. Sound names come
from `/System/Library/Sounds`. Drop the flag entirely for a silent notification.

**Stop notifying on every turn.** Remove the `Stop` entry from
`~/.claude/settings.json` and keep only `Notification`. You will then only be
alerted when Claude actually needs you, not when it finishes.

## Troubleshooting

**No banner at all.** Check that notifications are allowed. With
`terminal-notifier` installed, look for it in System Settings > Notifications.
On the `osascript` fallback the banners are attributed to Script Editor, so
check that entry instead. Note that `osascript` exits `0` even when the banner
is suppressed, so a clean exit code does not prove it displayed.

**Banner vanishes before I can click it.** Working as intended on the
**Temporary** alert style. The entry is still in Notification Center and clicking
it there does the same jump. Confirm what is being held with:

```bash
terminal-notifier -list ALL
```

Only the newest notification per pane appears, because `-group` replaces older
ones with the same ID. Both would jump to the same pane, so nothing is lost. Drop
`-group` from `tmux-notify.sh` if you would rather they stack up.

**Banner never goes away on its own.** Alert Style is set to **Persistent**. See
step 6.

**Banner appears but clicking does nothing.** This is almost always `PATH`. A
notification click launches the script from the GUI, which supplies only
`/usr/bin:/bin:/usr/sbin:/sbin`. Homebrew's `tmux` at `/opt/homebrew/bin/tmux`
is invisible in that environment, the session lookup returns empty, and the
script exits early before it can do anything. That is why `tmux-goto.sh`
exports `PATH` near the top. If you edit that script, leave the export in
place, it is load-bearing rather than defensive.

Reproduce the GUI environment locally to check:

```bash
env -i PATH=/usr/bin:/bin:/usr/sbin:/sbin HOME="$HOME" \
  bash -x ~/.claude/hooks/tmux-goto.sh "$TMUX_PANE"
```

The trace should reach `open -b` at the end. If it exits right after the
`tmux display-message` line, `PATH` is still wrong.

**Notification is missing the tmux location.** The subtitle falls back to
`not in tmux` when `$TMUX` or `$TMUX_PANE` is unset. Claude Code has to be
started from inside tmux for those to be present.

**Window is not flagged in the status bar.** Check `bell-action`, see step 3.
`monitor-bell` also has to be `on`, which is the tmux default.

**Nothing fires at all.** Confirm hooks are not globally disabled by looking
for `disableAllHooks` in `~/.claude/settings.json`, then run `claude --debug`
and watch for hook execution lines.

## Notes

These files live in `~/.claude/` and `~/.tmux.conf`, so they are per machine.
Copying this folder onto a new machine and following the setup steps is the
whole migration.

If this is ever shared with the team, the scripts belong in the
`ai-developer-tools` repo rather than being copied around by hand.
