# tmux setup

My tmux config, the plugins it uses, and how to get it running on a fresh
machine.

The coding-agent notification hooks used to live in this folder. They are agent
config, not tmux config, so the Claude Code and Codex CLI versions now sit under
[`agent-setup/`](../agent-setup/) and are installed by `agent-setup/install.sh`.
Claude's detailed notification troubleshooting lives in
[`agent-setup/claude/notifications.md`](../agent-setup/claude/notifications.md),
and the Codex setup lives in
[`agent-setup/codex/README.md`](../agent-setup/codex/README.md).

## Files

| File | Goes to | Purpose |
|---|---|---|
| `tmux.conf` | `~/.tmux.conf` | The config itself |

Verified against tmux 3.6b.

## Fresh machine setup

### 1. Install tmux

```bash
brew install tmux
```

### 2. Install the config

```bash
cp tmux.conf ~/.tmux.conf
```

### 3. Install tpm, the plugin manager

The last line of the config runs tpm, so this has to exist before plugins work:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 4. Start tmux and install the plugins

```bash
tmux
```

Then press `C-b` followed by `I` (capital i). That fetches every plugin listed
in the config and sources it. It takes a few seconds and prints a summary when
it finishes.

### 5. Confirm

```bash
ls ~/.tmux/plugins
```

You want four directories: `tpm`, `tmux-resurrect`, `tmux-yank`,
`tmux-continuum`.

## Plugin management

The prefix is `C-b`, the tmux default. This config does not remap it.

| Keys | Action |
|---|---|
| `C-b` `I` | Install plugins listed in the config |
| `C-b` `U` | Update installed plugins |
| `C-b` `alt-u` | Remove plugins no longer listed in the config |

### Adding a plugin

1. Add a line near the top of `~/.tmux.conf`, next to the other `@plugin` lines:
   ```tmux
   set -g @plugin 'owner/repo-name'
   ```
2. Reload the config: `tmux source-file ~/.tmux.conf`
3. Press `C-b` `I` to fetch it.

The `run '~/.tmux/plugins/tpm/tpm'` line must stay at the very bottom of the
file. Plugins declared after it are ignored.

### Removing a plugin

1. Delete its `@plugin` line from `~/.tmux.conf`
2. Reload: `tmux source-file ~/.tmux.conf`
3. Press `C-b` `alt-u` to clean up the files on disk.

## Plugins in use

**[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)** saves and
restores sessions across restarts, including window layouts and working
directories.

| Keys | Action |
|---|---|
| `C-b` `C-s` | Save the current session |
| `C-b` `C-r` | Restore the last saved session |

**[tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)** removes the
manual step. It calls resurrect's save every 15 minutes, and `@continuum-restore
'on'` brings your sessions back when the tmux server next starts. No key
bindings, it just runs.

Saves land in `~/.local/share/tmux/resurrect/`, not `~/.tmux/resurrect/`. The
plugin only uses the `~/.tmux` path if that directory already exists, otherwise
it falls back to the XDG location. Worth knowing before you conclude nothing is
being saved.

Each save is roughly 3.5 KB and resurrect prunes anything older than 30 days, so
disk use settles around 10 MB. Tune with `@resurrect-delete-backup-after`.

**[tmux-yank](https://github.com/tmux-plugins/tmux-yank)** copies to the macOS
system clipboard. Since `mode-keys` is `vi`, the flow is:

1. `C-b` `[` to enter copy mode
2. `Space` to start the selection, then move with vi keys. `v` toggles block
   selection rather than starting one, which trips up people expecting visual
   mode from vim.
3. `y` to copy and exit

Confirm what `y` is actually bound to with
`tmux list-keys -T copy-mode-vi | grep ' y '`. With tmux-yank loaded it should
be `copy-pipe-and-cancel pbcopy`.

## Key bindings this config adds

| Keys | Action |
|---|---|
| `C-b` `\|` | Split the pane side by side, in the current directory |
| `C-b` `-` | Split the pane top and bottom, in the current directory |
| `C-b` `c` | New window, in the current directory |
| `C-b` `r` | Reload `~/.tmux.conf` and confirm with a status message |
| `C-b` `H` `J` `K` `L` | Resize the pane left, down, up, right by 5 |

The split keys replace the defaults `%` and `"`, which are unbound so the muscle
memory does not survive. The characters match what the split looks like, which
is the whole point.

All three of `|`, `-` and `c` pass `-c "#{pane_current_path}"`. Without that,
tmux opens new panes and windows in whatever directory the session started in,
not where you actually are, which means retyping `cd` all day.

`C-b` `r` cannot load itself. After adding it to a fresh config you still need
one manual `tmux source-file ~/.tmux.conf`. It works for every edit after that.
Note that sourcing is additive: it applies new bindings but does not remove ones
you deleted from the file. Getting rid of a binding needs an explicit `unbind`
or a `tmux kill-server`.

Alt-arrow pane switching is present but commented out at lines 56 to 60. Enable
it by removing the `#` characters if you want to move between panes without the
prefix.

## Useful commands

Everything here is `C-b` first, pressed and released, then the key. Verified
against this config on tmux 3.6b, so it accounts for the custom bindings above.

### When you forget everything else

| Keys | Action |
|---|---|
| `C-b` `?` | List every binding. Searchable, `q` to quit |
| `C-b` `:` | Command prompt, for anything with no binding |

`C-b ?` is the real answer to "how do I do X again". The tables below are just
the ones worth memorising.

### Panes

| Keys | Action |
|---|---|
| `C-b` `\|` | Split side by side |
| `C-b` `-` | Split top and bottom |
| `C-b` arrow | Move to the pane in that direction |
| `C-b` `o` | Cycle to the next pane |
| `C-b` `;` | Jump back to the last pane you were in |
| `C-b` `q` | Show pane numbers, then press a number to jump there |
| `C-b` `z` | Zoom the pane to fill the window, press again to unzoom |
| `C-b` `x` | Kill the pane, asks first |
| `C-b` `!` | Break the pane out into its own window |
| `C-b` `{` / `}` | Swap the pane with the previous or next one |
| `C-b` `C-o` | Rotate all panes in the window |

### Resizing panes

| Keys | Action |
|---|---|
| `C-b` `H` | Grow the pane left by 5, hold `H` to keep going |
| `C-b` `J` | Grow down by 5 |
| `C-b` `K` | Grow up by 5 |
| `C-b` `L` | Grow right by 5 |
| `C-b` `z` | Zoom instead of resizing, usually what you actually want |
| `C-b` `Space` | Cycle through the built-in layouts |
| `C-b` `M-1` … `M-7` | Jump straight to a layout: even-horizontal, even-vertical, main-horizontal, main-vertical, then the tiled and mirrored variants |
| `C-b` `E` | Spread panes out evenly |

`H` `J` `K` `L` are capitals, so shift is held. They are `-r` bindings, meaning
you press `C-b` once and can then tap or hold the letter to keep resizing.

Two reasons this config defines them rather than using the tmux defaults, both
of which cost real debugging time:

1. The defaults are `C-b` `C-`arrow for 1 cell and `C-b` `M-`arrow for 5. On
   macOS, Mission Control claims `Ctrl+Left` and `Ctrl+Right` system-wide for
   switching spaces, so those keys never reach tmux at all. Check with
   `defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys` and look at
   entries 79 to 82, or System Settings > Keyboard > Keyboard Shortcuts >
   Mission Control.
2. `repeat-time` used to be `100` here, which is shorter than the gap between two
   deliberate keypresses, so repeatable bindings stopped repeating. It is now
   `500`, the tmux default.

The defaults are still bound, so `C-b` `M-`arrow works if you prefer alt.

Overriding `L` costs you the stock `C-b L`, which was `switch-client -l` for
jumping to the last client. Irrelevant with a single terminal window attached.

For a precise size rather than nudging, use the prompt:

```
C-b :  resize-pane -x 100
C-b :  resize-pane -y 30
```

### Windows

| Keys | Action |
|---|---|
| `C-b` `c` | New window in the current directory |
| `C-b` `1` … `9` | Go to that window number |
| `C-b` `n` / `p` | Next or previous window |
| `C-b` `l` | Jump back to the last window |
| `C-b` `w` | Interactive window picker across all sessions |
| `C-b` `f` | Find a window by name or content |
| `C-b` `,` | Rename the window |
| `C-b` `.` | Renumber the window, prompts for the new index |
| `C-b` `&` | Kill the window, asks first |

### Sessions

| Keys | Action |
|---|---|
| `C-b` `d` | Detach. Everything keeps running |
| `C-b` `s` | Interactive session picker |
| `C-b` `$` | Rename the session |

From the shell:

```bash
tmux ls                      # list sessions
tmux new -s name             # new named session
tmux attach -t name          # attach to one
tmux new -As name            # attach if it exists, otherwise create
tmux kill-session -t name    # kill one session
tmux kill-server             # kill everything
```

### Copy and paste

`mode-keys` is `vi`, so movement inside copy mode is vi keys.

| Keys | Action |
|---|---|
| `C-b` `[` | Enter copy mode |
| `Space` | Start the selection |
| `v` | Toggle block selection. It does not start one |
| `y` | Copy to the macOS clipboard and exit |
| `g` / `G` | Jump to the top and bottom of the scrollback |
| `q` | Leave copy mode |
| `C-b` `]` | Paste the last tmux buffer |
| `C-b` `=` | Pick from all tmux buffers |
| `C-b` `#` | List buffers |

### Searching the scrollback

For finding an error or a command you ran a while ago without scrolling for it.
Searching happens inside copy mode, so it is always two steps.

1. `C-b` `[` to enter copy mode
2. `/` to search down, or `?` to search up
3. Type the pattern and press `Enter`
4. `n` for the next hit, `N` for the previous one
5. `q` to leave copy mode

| Keys | Action |
|---|---|
| `/` | Search down, prompt reads `(search down)` |
| `?` | Search up |
| `n` | Repeat the search in the same direction |
| `N` | Repeat it in the opposite direction |
| `*` | Search down for the word under the cursor, no typing |
| `#` | Search up for the word under the cursor |

`*` and `#` are the fastest way to chase a repeated string. Put the cursor on it
and press the key.

`/` runs `search-forward`, which treats your input as a pattern, so `^`, `$`, `.`
and `*` are meaningful. When you need a literal string instead, because it
contains those characters, use the plain-text variant from the command prompt:

```
C-b :  send-keys -X search-forward-text "some.literal[string]"
```

`n` and `N` still work afterwards.

### Reload and inspect

| Command | Purpose |
|---|---|
| `C-b` `r` | Reload `~/.tmux.conf` |
| `tmux show-options -g` | Every global option and its current value |
| `tmux show-options -g mouse` | One option, to check what it really is |
| `tmux list-keys -T prefix` | Every prefix binding |
| `tmux display-message -p '#{session_name}:#{window_index}.#{pane_index}'` | Where am I |

That last one is the same format string the notification hook uses.

## What the rest of the config does

**Terminal capabilities, lines 14 to 20.** `tmux-256color` as the terminal type,
which unlike `screen-256color` carries italics. `terminal-features` then declares
`RGB` for true colour and `usstyle` for undercurl, so LSP errors show as squiggly
underlines. Line 19 keeps the cursor shape escape codes working, and `COLORTERM`
tells programs that check it directly.

**Scrollback, line 22.** `history-limit 20000` instead of the default 2000.

**Window sizing, line 27.** `aggressive-resize on` sizes a window to the
largest client viewing *that window*, not the largest client on the whole
session. Without it, one small attached client shrinks everything.

**Mouse, line 30.** Scrolling, pane selection and pane resizing all work with
the mouse.

**Numbering, lines 34 to 36.** Windows and panes count from 1 instead of 0, so
`C-b 1` reaches the first window rather than erroring. `renumber-windows on`
closes the gap when a window is killed, instead of leaving you pressing `C-b 7`
for your fourth window.

**Titles, lines 63 to 64.** Sets the terminal window title to `tmux: <name>`.

**Copy mode, line 71.** `mode-keys vi` gives vi navigation and selection inside
copy mode.

**Alerts, lines 73 to 79.** Activity monitoring is off, so busy panes do not
constantly flag themselves. `visual-bell on` shows a status line message rather
than making noise.

`bell-action other` on line 79 is load-bearing for the coding-agent
notifications. It flags a window in the status bar when a bell fires in a window
you are not looking at, which is how the notify hooks mark the window they came
from. Setting it back to `none` silently breaks that. Claude's troubleshooting
guide is in
[agent-setup/claude/notifications.md](../agent-setup/claude/notifications.md),
and Codex setup is in
[agent-setup/codex/README.md](../agent-setup/codex/README.md).

## Reloading after edits

```bash
tmux source-file ~/.tmux.conf
```

This applies to the running server. Some options only take effect on new
windows or panes, so if something looks unchanged, open a new one before
digging further.

Check what a single option is actually set to:

```bash
tmux show-options -g bell-action
tmux show-options -g mouse
```
