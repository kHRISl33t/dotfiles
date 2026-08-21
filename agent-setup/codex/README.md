# Personal Codex setup

This directory is the source of truth for the personal Codex configuration on this Mac.

## Files

| Path | What it is |
|---|---|
| `hooks.json` | Runs the notification script when a turn stops or Codex requests approval |
| `hooks/` | tmux-aware notification and click-navigation scripts |
| `tests/` | Isolated shell tests for notification payloads and click navigation |
| `SKILLS.md` | Snapshot of active skills and instructions for browsing the current catalog |

The working agreements themselves are not in this directory. They live one level up in `agent-setup/AGENTS.md`, shared with Claude Code, which imports the same file. One file, both tools, so a rule only has to be written once.

The live global path is a symbolic link:

```text
/Users/khris/.codex/AGENTS.md
  -> /Users/khris/code/dotenv/agent-setup/AGENTS.md
```

Edit `agent-setup/AGENTS.md`. Changes are immediately visible through the live path. A new Codex task or session may be needed before updated instructions are loaded. Remember that anything added there also reaches Claude Code, so keep it tool-neutral. Codex-only notes belong in this README, and Claude-only rules go in `agent-setup/claude/CLAUDE.md`.

## How Codex loads rules

Codex builds an instruction chain before it starts work:

1. It loads `~/.codex/AGENTS.override.md` when that file exists and is non-empty. Otherwise, it loads `~/.codex/AGENTS.md`.
2. It loads project instructions from the project root down to the current working directory.
3. Instructions nearer to the current working directory appear later and take precedence over broader instructions.

Use the global file for personal defaults that should apply everywhere. Use repository or nested `AGENTS.md` files for project-specific commands, architecture, naming, and exceptions. Use `AGENTS.override.md` only for a temporary global override.

Official reference: [Custom instructions with AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)

## Recreate the symbolic link

Run the installer from the repository root. It handles Codex and Claude together, backs up any existing real file, and is safe to re-run:

```bash
./agent-setup/install.sh
./agent-setup/verify.sh
```

It creates these Codex links without replacing the app-managed
`~/.codex/config.toml`:

```text
~/.codex/AGENTS.md  -> agent-setup/AGENTS.md
~/.codex/hooks.json -> agent-setup/codex/hooks.json
~/.codex/hooks      -> agent-setup/codex/hooks
```

The link this creates has broken once already, because an earlier version of this README hardcoded `/Users/khris/code/agent-setup/...` and the repository actually lives in `dotenv/`. A dangling link makes Codex load no global instructions at all, with no warning at startup. `verify.sh` is what catches that, so run it if Codex starts ignoring these rules.

The equivalent by hand, if you ever need it without the script:

```bash
mkdir -p /Users/khris/.codex
mv /Users/khris/.codex/AGENTS.md /Users/khris/.codex/AGENTS.md.backup
ln -s /Users/khris/code/dotenv/agent-setup/AGENTS.md /Users/khris/.codex/AGENTS.md
```

Verify by hand with:

```bash
readlink /Users/khris/.codex/AGENTS.md
cmp /Users/khris/.codex/AGENTS.md /Users/khris/code/dotenv/agent-setup/AGENTS.md
```

`cmp` should exit with status `0` and print nothing.

To ask a fresh Codex CLI session what it loaded:

```bash
codex --ask-for-approval never "Summarize the current instructions."
```

## Notifications

The `Stop` and `PermissionRequest` hooks in `hooks.json` run
`hooks/tmux-notify.sh`. It posts a macOS banner naming the tmux pane and rings
that pane's bell. Clicking the banner runs `hooks/tmux-goto.sh`, selects the
original pane, and raises iTerm2.

The script suppresses a notification when the originating pane is already
visible in the frontmost terminal. Set `CODEX_NOTIFY_ALWAYS=1` to bypass that
check. To raise another terminal when a banner is clicked, set
`CODEX_TERMINAL_BUNDLE_ID` to its macOS bundle identifier.

Sessions outside tmux stay quiet. This keeps the user-level hooks from
duplicating notifications when Codex runs in the desktop app.

Codex requires a one-time trust review for user hooks. Start a new Codex CLI
session, run `/hooks`, review both notification commands, and trust them. Codex
skips the hooks until that review is complete.

Test the scripts without waiting for a real turn:

```bash
./agent-setup/codex/tests/tmux-notify-test.sh
./agent-setup/codex/tests/tmux-goto-test.sh
```

Official reference: [Codex hooks](https://learn.chatgpt.com/docs/hooks)

## Browse and use skills

- In the Codex desktop app, open the Skills section to see active skills and the Plugins section to browse plugins.
- In Codex CLI, use `/skills` to browse active skills and `/plugins` to browse plugins.
- Type `$` in a prompt to select a skill, or name one directly, such as `$frontend-design`.
- Ask `$skill-installer` to list curated or experimental skills that can be installed.

Example prompts:

```text
$skill-installer List curated skills available to install.
$skill-installer List experimental skills available to install.
```

User-installed standalone skills live in `~/.codex/skills/`. Skills supplied by plugins are managed with their plugin. System skills are bundled with Codex and do not need manual installation.

Official reference: [Build skills](https://learn.chatgpt.com/docs/build-skills)

## Install another skill

For a curated skill, ask Codex:

```text
$skill-installer Install <skill-name> globally.
```

For a skill hosted in another repository, give `$skill-installer` its GitHub repository and path. Installed skills become available on the next turn. Record additions in `SKILLS.md` so this directory remains useful when setting up another Mac.
