# Personal Claude Code setup

Source of truth for the Claude Code configuration on this Mac. Everything here is
linked into `~/.claude` by `agent-setup/install.sh`, so the live config and the
tracked config are the same files.

## Files

| Path | What it is |
|---|---|
| `CLAUDE.md` | Claude-only instructions. The shared rules live in `agent-setup/AGENTS.md` |
| `settings.json` | Model, theme, notification channel, enabled plugins, and the tmux hooks |
| `SKILLS.md` | Snapshot of installed plugins and their versions |
| `agents/` | Subagent definitions, linked to `~/.claude/agents` |
| `commands/` | Slash commands, linked to `~/.claude/commands` |
| `hooks/` | The tmux notification scripts, linked to `~/.claude/hooks` |
| `notifications.md` | Setup and troubleshooting for the notification banners |

## Install

From the repository root:

```bash
./agent-setup/install.sh
./agent-setup/verify.sh
```

Both are safe to re-run. `install.sh` resolves its own location, so if you move or
clone this repository somewhere else, re-running it repoints every link. Nothing
hardcodes a path.

Preview without touching anything:

```bash
./agent-setup/install.sh --dry-run
```

Existing real files are moved aside as `<name>.backup-<timestamp>` rather than
overwritten, so a first run on a machine that already has config loses nothing.

## What gets linked

```text
~/.claude/settings.json  -> agent-setup/claude/settings.json
~/.claude/hooks          -> agent-setup/claude/hooks
~/.claude/agents         -> agent-setup/claude/agents
~/.claude/commands       -> agent-setup/claude/commands
~/.codex/AGENTS.md       -> agent-setup/AGENTS.md
```

`~/.claude/CLAUDE.md` is the one exception. It is generated, not linked, because
Claude resolves a relative `@import` against the file containing it and that is
ambiguous through a symlink. `install.sh` writes a two-line file of absolute
imports instead:

```text
@<repo>/agent-setup/AGENTS.md
@<repo>/agent-setup/claude/CLAUDE.md
```

Editing `~/.claude/CLAUDE.md` by hand is pointless. The next install run
overwrites it. Edit `AGENTS.md` or `claude/CLAUDE.md`.

## How Claude loads instructions

Claude concatenates every file it finds, broadest scope first, so a project rule
lands after a personal one and wins on conflict:

1. Managed policy, `/Library/Application Support/ClaudeCode/CLAUDE.md`
2. User, `~/.claude/CLAUDE.md`, which is what this directory installs
3. Project, `./CLAUDE.md` or `./.claude/CLAUDE.md`
4. Local, `./CLAUDE.local.md`, gitignored

Personal defaults go in `AGENTS.md`. Project commands, architecture, and naming go
in that repository's own `CLAUDE.md`.

Confirm what actually loaded with `/context` in a session and read the **Memory
files** list. `/memory` opens the files for editing.

Official reference: [How Claude remembers your project](https://code.claude.com/docs/en/memory)

## Why settings.json is a symlink

Claude Code writes to `~/.claude/settings.json` itself when you use `/config`,
`/model`, or toggle a plugin. Linking it means those edits land in the repository
and `git diff` shows what changed, with no copy step to forget.

The risk is that a future version writes the file by replacing it rather than
editing in place, which would turn the symlink into a regular file and silently
stop tracking. `verify.sh` catches exactly that and reports `is a real file, not a
link into this repo`. Run it if the repo has been suspiciously quiet.

Machine-specific values and anything secret do not belong here. Project-scoped
overrides go in a repo's `.claude/settings.local.json`, which stays untracked.

## Subagents and commands

- `/pre-commit-check` runs the checklist from `AGENTS.md`: the repo's own lint,
  prettier, build, and test scripts, then the diff review for the rules no tool
  enforces. It never commits.
- `diff-auditor` is a read-only subagent that audits an uncommitted diff against
  those same rules and reports `path:line` findings.

Add a subagent by dropping a markdown file with YAML frontmatter into `agents/`.
It is picked up through the existing directory link, so no install run is needed.
Same for `commands/`.

## Plugins

Enabled plugins are tracked in `settings.json` under `enabledPlugins`, so adding
or removing one is a visible change. On a new machine, add the marketplace first:

```bash
claude plugin marketplace add anthropics/claude-plugins-official
```

Then install the plugins named in `SKILLS.md`. Browse with `/plugin` in a session.

## Notifications

The `Stop` and `Notification` hooks in `settings.json` fire `hooks/tmux-notify.sh`,
which posts a macOS banner naming the tmux pane and rings the pane bell. Clicking
the banner runs `hooks/tmux-goto.sh` to jump straight there.

`notifications.md` has the manual macOS step that makes banners fade on their own,
plus the test command and troubleshooting.
