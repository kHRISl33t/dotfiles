# zsh setup

A portable zsh config: oh-my-zsh with the agnoster theme, a custom prompt showing
the time and node version, and a set of tmux, git and docker aliases.

Nothing in the shared files is specific to one machine or one job. Credentials,
cloud settings and per-machine paths go in `~/.zshrc.local`, which is sourced
last and never committed.

## Files

| File | Goes to | Purpose |
|---|---|---|
| `zshrc` | `~/.zshrc` | The shared config. Safe to copy anywhere |
| `zprofile` | `~/.zprofile` | Homebrew init, runs once per login shell |
| `zshrc.local.example` | copy to `~/.zshrc.local` | Template for secrets and machine-specific values |

Verified on macOS 26.5.2, against both the system zsh 5.9 at `/bin/zsh` (the
login shell) and Homebrew's zsh 5.9.1.

## Requirements

Required:

- zsh (the macOS default since Catalina)
- [oh-my-zsh](https://ohmyz.sh)
- A Powerline or Nerd Font. The agnoster theme draws its arrow separators with
  glyphs a normal font does not have, so without one the prompt is boxes and
  question marks.

Optional, each guarded so a missing tool never breaks startup:

| Tool | What you lose without it |
|---|---|
| `nvm` | Auto node switching on `cd`, and the node version prompt segment |
| VS Code | `EDITOR` falls back to vim, and the `c` alias is not defined |
| Docker | The `d` and `dc` aliases do nothing useful |
| pnpm | `PNPM_HOME` is set but not added to `PATH` |
| tmuxinator | The `tmxr` alias does nothing useful |

## Setup from scratch

### 1. Install oh-my-zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

The installer replaces `~/.zshrc` with its own. That is fine, step 4 overwrites
it again.

### 2. Install the two custom plugins

`zsh-autosuggestions` and `zsh-syntax-highlighting` are not bundled with
oh-my-zsh. Listing them in `plugins=()` without installing them first prints an
error on every shell start.

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
```

The rest (`git`, `colored-man-pages`, `node`, `kubectl`, `nodenv`) ship with
oh-my-zsh and need nothing.

### 3. Install a font and select it

```bash
brew install --cask font-hack-nerd-font
```

Then set it in your terminal. iTerm2: Settings > Profiles > Text > Font, and pick
**Hack Nerd Font Mono**. Any Nerd Font or Powerline font works, Hack is what the
backed-up iTerm2 profile in `../iterm2/` already expects.

If you install that iTerm2 profile, the font is already selected for you and you
only need the cask installed. This step is easy to skip and is the single most
common reason the prompt looks broken.

### 4. Install the config

```bash
cp zshrc ~/.zshrc
cp zprofile ~/.zprofile
```

### 5. Create your local overrides

```bash
cp zshrc.local.example ~/.zshrc.local
```

Edit it and fill in what this machine needs. Everything in it is commented out,
so an untouched copy is harmless.

### 6. Restart and verify

```bash
exec zsh
```

Then check the pieces:

```bash
echo $EDITOR                      # code -w, or vim without VS Code
typeset -f build_prompt >/dev/null && echo "prompt ok"
alias gits                        # gits='git status'
```

## What belongs in ~/.zshrc.local

This is the whole reason the config is portable. The rule: if a line would be
wrong on another machine, or would leak something, it goes in the local file.

| Belongs in `.zshrc.local` | Belongs in `.zshrc` |
|---|---|
| API keys, tokens, access keys | Aliases |
| `AWS_PROFILE`, role ARNs, account IDs | Prompt config |
| Paths to a checkout that only exists here | Plugin list |
| `source` of a work helper script | Functions that work anywhere |
| Command wrappers tied to one employer | `PATH` entries under `$HOME` |

`.zshrc.local` is sourced last, so it can also override anything above it. To
change the editor on one machine only, re-export `EDITOR` there.

### Secrets

Do not put credentials directly in any of these files. A plain `export` leaves
the value readable in the file and visible in `env` to every process you start.

The macOS keychain avoids both:

```bash
security add-generic-password -a "$USER" -s SERVICE_TOKEN -w
```

Then in `~/.zshrc.local`:

```bash
export SERVICE_TOKEN=$(security find-generic-password -a "$USER" -s SERVICE_TOKEN -w 2>/dev/null)
```

If a credential has ever sat in plaintext in a dotfile, treat it as exposed and
rotate it. Dotfiles get synced, backed up and pasted into chats far more often
than anyone intends.

## Aliases

### tmux

| Alias | Command |
|---|---|
| `tmx` | `tmux` |
| `tmxa` | `tmux a`, attach to the last session |
| `tmxas` | `tmux a -t`, attach to a named session |
| `tmxns` | `tmux new -s`, new named session |
| `tmxls` | `tmux ls` |
| `stmx` | `tmux source-file ~/.tmux.conf` |
| `tmxr` | `tmuxinator` |

### git

| Alias | Command |
|---|---|
| `gits` | `git status` |
| `gita` | `git add` |
| `gitaa` | `git add .` |
| `gitc` | `git commit` |
| `gitcm` | `git checkout master` |
| `gitf` | `git fetch` |
| `gitpro` | `git pull --rebase origin` |
| `gitprom` | `git pull --rebase origin master` |
| `gitrm` | `git rebase master` |
| `gitcb` | `git branch -b` |

### Other

| Alias | Command |
|---|---|
| `c` | `code`, only when VS Code is installed |
| `d` | `docker` |
| `dc` | `docker-compose` |
| `sourcezsh` | `source ~/.zshrc` |

## Functions

**`killallon <port>`** kills whatever is listening on a port. Handy when a dev
server survives a crashed terminal.

```bash
killallon 3000
```

It sends `SIGINT`, not `SIGKILL`, so the process gets a chance to clean up.

## The prompt

agnoster, with two extra segments added by overriding its `build_prompt`:

- **Time** in cyan, `HH:MM:SS`. Change the format in `prompt_time`, `%H:%M`
  drops seconds and `%r` gives 12-hour with AM/PM.
- **Node version** in green, only when `node` is on `PATH`.

To remove one, delete its line from `build_prompt`. To reorder, move the line.
The whole block is skipped when agnoster is not loaded, since the segments call
`prompt_segment`, which the theme defines.

`DEFAULT_USER="$USER"` hides the `user@host` segment on your own machine. It
still appears over SSH, which is the point.

## What was changed to make this portable

The original config assumed one machine. The differences, in case you wonder why
something looks roundabout:

**Hardcoded home paths.** `/Users/<name>/...` appeared in the oh-my-zsh path,
`NVM_DIR`, `PNPM_HOME` and the Docker completions `fpath`. All now use `$HOME`.

**Homebrew location.** `.zprofile` hardcoded `/opt/homebrew`, which is Apple
Silicon only. It now tries `/opt/homebrew`, `/usr/local` and Linuxbrew, taking
the first that exists.

**Everything optional is guarded.** oh-my-zsh, nvm, VS Code, the Docker
completions directory and each `PATH` entry are all checked before use. A fresh
machine gets a working shell with a warning instead of a wall of errors.

**`PATH` no longer duplicates.** The original `export PATH="$HOME/.local/bin:$PATH"`
re-added the entry on every shell, so nested shells accumulated copies. On the
machine this was written from, `.local/bin` appeared 12 times. A `_prepend_path`
helper now skips entries that are already present.

**`compinit` runs once.** The Docker completions `fpath` was appended after
oh-my-zsh had already run `compinit`, so a second `compinit` was needed to pick
it up. The `fpath` line now comes first, and `compinit` only runs directly when
oh-my-zsh is absent.

**Dead config dropped.** `complete -F __start_kubectl kc rkc pkc` registered
completions for three aliases that do not exist. Add them to `.zshrc` if you
want them, along with the `complete` line.

**Work-specific content removed.** Cloud environment variables, a helper script
`source`, a repo path, and a `docker build` wrapper keyed to one employer's repos
all moved to `zshrc.local.example` as commented placeholders.

## Troubleshooting

**Prompt shows boxes, question marks or `?`.** The font has no Powerline glyphs.
See step 3, and check the terminal is actually using the font you installed.

**`warning: oh-my-zsh is not installed`.** Exactly what it says. Aliases and
functions still work, the prompt and plugins do not. Run step 1.

**`plugin not found` on startup.** `zsh-autosuggestions` or
`zsh-syntax-highlighting` is listed but not cloned. Run step 2.

**Slow shell startup.** Usually nvm. It sources a large script and the config
then runs `load-nvmrc` once at startup. Confirm with:

```bash
time zsh -i -c exit
```

If nvm is the cause, look at a lazy-loading wrapper or switch to `fnm`.

**`PATH` has duplicate entries.** Check nothing in `~/.zshrc.local` is doing an
unguarded `export PATH="...:$PATH"`. Count them with:

```bash
print -r -- $PATH | tr ':' '\n' | sort | uniq -c | sort -rn | head
```

**A change to `.zshrc` does nothing.** `.zprofile` only runs for login shells.
If you moved something there, open a new terminal window rather than running
`exec zsh`.

## Notes

`ZSH_DISABLE_COMPFIX="true"` on line 9 silences oh-my-zsh's warning about
group-writable completion directories. Homebrew triggers it constantly. It is
suppressing a real check, so if you ever run on a shared machine, remove it and
fix the directory permissions instead.

`~/.claude/aliases.zsh` is sourced when present. It is written by the Claude Code
setup and is absent on machines without it.

The `nodenv` plugin is in the plugin list but `nodenv` is not installed on the
source machine, and node is managed by nvm instead. The plugin loads silently and
does nothing, so it is harmless, but it is a candidate for removal. Two node
version managers on one machine is worth avoiding.

Homebrew's `zsh` is installed on the source machine but is not the login shell,
which is `/bin/zsh`. To actually use the newer Homebrew build:

```bash
echo /opt/homebrew/bin/zsh | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/zsh
```

Otherwise the formula is just taking up space and can be dropped from the
`Brewfile`.
