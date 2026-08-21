# dotenv

My macOS development environment: shell, terminal, tmux, and the package list to
rebuild all of it.

Follow the steps below **in order** on a new machine. The order matters, several
steps will silently do nothing or produce confusing errors if run early. Each
step says what it depends on.

## Contents

| Path | What it is |
|---|---|
| `Brewfile` | Everything installed via Homebrew, plus apps available as casks |
| `zsh/` | Portable `.zshrc`, `.zprofile`, and a template for private values |
| `tmux/` | `.tmux.conf` and a key binding reference |
| `iterm2/` | Portable iTerm2 Dynamic Profile and installer |
| `agent-setup/` | Claude Code and Codex config, shared rules, and the installer that links them |

Each folder has its own README with detail. This file is only the install order.

## What you end up with

- zsh with oh-my-zsh, the agnoster prompt, plus time and node version segments
- tmux with sane numbering, working pane resizing, and session autosave
- macOS notifications when Claude Code or Codex CLI finishes, naming the tmux
  pane and clickable to jump straight to it
- iTerm2 configured with the right font so the prompt renders correctly
- node via nvm, switching automatically per project `.nvmrc`

## Prerequisites

### 1. Xcode Command Line Tools

Needed by Homebrew and by `git`. Everything else depends on this.

```bash
xcode-select --install
```

Verify:

```bash
xcode-select -p     # /Library/Developer/CommandLineTools
```

### 2. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The installer prints two commands to add `brew` to your `PATH`. You can skip
them, step 5 installs a `.zprofile` that finds Homebrew on both Apple Silicon and
Intel.

For this session only, so the next steps can use `brew`:

```bash
eval "$(/opt/homebrew/bin/brew shellenv zsh)"     # Apple Silicon
eval "$(/usr/local/bin/brew shellenv zsh)"        # Intel
```

Verify:

```bash
brew --version
```

### 3. Get these files onto the machine

Clone if this is in git, otherwise copy the folder across. The steps below assume
you are inside it:

```bash
cd ~/code/dotenv
```

## Install

### 4. Install everything from the Brewfile

Depends on: Homebrew.

```bash
brew bundle install --file=Brewfile
```

This installs the CLI tools, the Hack Nerd Font, and the GUI apps including
iTerm2, VS Code, Docker Desktop and Slack. It takes a while on a fresh machine.

Verify:

```bash
brew bundle check --file=Brewfile --verbose
```

Note that `check` reports anything **outdated** as well as anything missing, so
already-installed-but-stale packages show up here. That is normal, not a failure.

### 5. Install the zsh config

Depends on: nothing, but do it before oh-my-zsh so the installer does not
clobber your `.zshrc`.

```bash
cp zsh/zshrc ~/.zshrc
cp zsh/zprofile ~/.zprofile
cp zsh/zshrc.local.example ~/.zshrc.local
```

`~/.zshrc.local` is where credentials, cloud settings and machine-specific paths
go. It is sourced last so it can override anything. Everything in the template is
commented out, so an untouched copy is safe. Fill it in now or later.

Never commit `~/.zshrc.local`. See `zsh/README.md` for the keychain pattern that
keeps secrets out of files entirely.

### 6. Install oh-my-zsh and its custom plugins

Depends on: step 5, because the installer replaces `~/.zshrc`.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**The installer overwrites `~/.zshrc`.** When it finishes, put yours back:

```bash
cp zsh/zshrc ~/.zshrc
```

Then the two plugins that oh-my-zsh does not bundle. Skipping this prints an
error on every shell start:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
```

Reload and check for a clean start:

```bash
exec zsh
```

### 7. Install nvm and node

Depends on: step 6, since the config wires the `cd` hook only when nvm is present.

Use nvm's own installer, not Homebrew. The formula does not match the layout the
config and most docs expect:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | bash
```

The installer appends its own lines to `~/.zshrc`. Delete them, the config
already handles nvm. Then:

```bash
exec zsh
nvm install --lts
nvm alias default lts/*
```

Verify:

```bash
node -v
```

From here, `cd` into any directory with an `.nvmrc` and the version switches
automatically.

### 8. Install the iTerm2 profile

Depends on: step 4, both for iTerm2 itself and for the Hack Nerd Font. Restoring
before the font is installed gives you a prompt full of boxes.

Install the portable Dynamic Profile:

```bash
./iterm2/install.sh
```

In iTerm2 Settings, select **Profiles > Dotfiles > Other Actions > Set as
Default** once. The tracked JSON contains only the intentional profile settings,
not the full application preferences or machine-specific data. See
`iterm2/README.md` for editing and backup behavior.

### 9. Install the tmux config

Depends on: step 4 for tmux.

```bash
cp tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Start tmux and press `C-b` then `I` (capital i) to fetch the plugins:

```bash
tmux
```

Verify, you want four directories:

```bash
ls ~/.tmux/plugins     # tpm, tmux-resurrect, tmux-yank, tmux-continuum
```

Details and a full key binding reference are in `tmux/README.md`.

### 10. Set up the coding agents

Depends on: step 4 for `terminal-notifier` and `jq`, step 9 for tmux, and Claude
Code or Codex being installed. Skip this step if you use neither.

```bash
./agent-setup/install.sh
./agent-setup/verify.sh
```

That links the shared working agreements, agent settings, subagents, slash
commands, and tmux notification hooks into `~/.claude` and `~/.codex`. It is
safe to re-run, backs up any existing real file, and resolves its own location, so
cloning this repo somewhere else and re-running it repoints everything. Preview
with `--dry-run`.

Install the Claude plugins listed in `agent-setup/claude/SKILLS.md` afterwards.
They are not files, so the installer cannot link them:

```bash
claude plugin marketplace add anthropics/claude-plugins-official
```

One manual macOS step makes notification banners fade on their own rather than
sitting on screen. It is documented in `agent-setup/claude/notifications.md`.
Codex also requires a one-time hook review through `/hooks`, documented in
`agent-setup/codex/README.md`.

Details for each tool are in `agent-setup/claude/README.md` and
`agent-setup/codex/README.md`.

## Verify everything

```bash
# shell
echo $EDITOR                                    # code -w
alias gits                                      # gits='git status'
typeset -f build_prompt >/dev/null && echo "prompt ok"

# node
node -v && nvm current

# tmux
tmux -V
ls ~/.tmux/plugins | wc -l                      # 4

# tools
jq --version && gh --version | head -1
terminal-notifier -help >/dev/null && echo "notifier ok"

# coding agents
./agent-setup/verify.sh
```

`verify.sh` is the one to re-run when an agent starts ignoring your rules. A link
into this repo that no longer resolves makes Claude and Codex fall back to loading
nothing, silently, with no startup warning. That has already happened once.

The prompt itself is the fastest visual check. If you see arrow separators, a
clock and a node version, the font, oh-my-zsh, the theme and the custom segments
are all working.

## Things that will bite you

**The oh-my-zsh installer overwrites `~/.zshrc`.** Copy yours back afterwards.
This is why step 5 comes before step 6, so you always have a copy to restore.

**Restoring iTerm2 settings before installing the font** leaves the prompt as
boxes and question marks. It looks like the shell config is broken when it is
just a missing font.

**The nvm installer appends to `~/.zshrc`.** Remove those lines, the config
already sets `NVM_DIR` and sources nvm with guards.

**Notification clicks need the `PATH` export in `tmux-goto.sh`.** A click launches
the script from the GUI with a minimal `PATH` where Homebrew's `tmux` does not
exist. That export is load-bearing, not defensive.

**`brew bundle check` flags outdated packages, not just missing ones.** Output
listing installed things as needing attention is expected.

## What is deliberately not here

- **Credentials.** Nothing in this repo contains a secret. Machine-specific and
  private values live in `~/.zshrc.local`, which is never committed.
- **Company software.** Security agents and self-service portals are pushed by
  the employer's device management and must not be installed by hand.
- **Company environment config.** Cloud account IDs, role ARNs, internal repo
  paths and work helper scripts belong in `~/.zshrc.local`. See
  `zsh/zshrc.local.example` for the shape.
- **Apple stock apps** and anything from the App Store.
