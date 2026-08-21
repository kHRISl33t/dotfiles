# Agent setup

Configuration for the coding agents on this Mac, tracked here and linked into
place so the live config and the tracked config are the same files.

## Layout

| Path | What it is |
|---|---|
| `AGENTS.md` | The working agreements. Shared, loaded by both Claude Code and Codex |
| `install.sh` | Creates every link. Idempotent, re-runnable, `--dry-run` to preview |
| `verify.sh` | Checks every link resolves. Exits non-zero when something is broken |
| `claude/` | Claude Code settings, subagents, commands, hooks, plugin inventory |
| `codex/` | Codex hooks, notification scripts, skill inventory, and notes |
| `GLOBAL.md` | Superseded by `AGENTS.md`, kept until its extra detail is folded in or dropped |

## Install

```bash
./agent-setup/install.sh
./agent-setup/verify.sh
```

Nothing hardcodes a path. `install.sh` resolves its own location, so moving or
cloning this repository and re-running it repoints every link.

## One rules file, two tools

`AGENTS.md` is the only place the working agreements are written. Both tools read
that same file:

```text
~/.codex/AGENTS.md  -> agent-setup/AGENTS.md          (symlink)
~/.claude/CLAUDE.md    imports agent-setup/AGENTS.md  (generated)
```

Codex has no import syntax, so it gets a plain symlink. Claude supports `@path`
imports, so `install.sh` generates a small `~/.claude/CLAUDE.md` that imports
`AGENTS.md` plus `claude/CLAUDE.md`, which holds the Claude-only rules.

A rule that applies everywhere goes in `AGENTS.md`. A rule that only makes sense
for one tool goes in that tool's own file. Anything project-specific belongs in
the repository it applies to, not here.

## Why links and not copies

A copy has to be remembered. This setup exists so a new machine can be rebuilt
without remembering anything, and a copy step defeats that the moment you edit the
live file instead of the tracked one.

The tradeoff is that a link can dangle. `~/.codex/AGENTS.md` pointed at
`/Users/khris/code/agent-setup/...` for a while, a path that never existed in this
repository, and Codex loaded no global instructions the entire time without
complaining once. Neither agent warns you about this. `verify.sh` is the only
thing that catches it, so run it whenever an agent seems to have forgotten the
rules.

## Adding a rule

1. Decide the scope. Everywhere goes in `AGENTS.md`, one tool goes in that tool's
   file, one project goes in that project's repository.
2. Edit the file here. The live path updates immediately through the link.
3. Start a new session. Neither agent reloads instructions mid-session.
4. Confirm with `/context` in Claude Code, under **Memory files**.
