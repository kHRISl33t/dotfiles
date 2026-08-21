# Active Claude Code plugins and skills

Snapshot taken 2026-08-21 on Claude Code `2.1.238`. Plugin updates change this
set, so treat it as a record of what was installed, not a guarantee of what is
installed now.

The authoritative list is `enabledPlugins` in `settings.json`, which is tracked in
this repository. This file exists to name the marketplace and record the versions,
which `settings.json` does not carry.

## Marketplace

All 30 plugins come from one marketplace:

- `claude-plugins-official`, from [`anthropics/claude-plugins-official`](https://github.com/anthropics/claude-plugins-official)

Nothing is installed from a personal or third-party marketplace. On a new machine
`claude plugin marketplace add anthropics/claude-plugins-official` runs first,
then the plugins below install by name.

## Installed plugins

Versions are those recorded on the snapshot date. An entry without a version was
installed before the plugin cache started recording one.

*Workflow and review*

- `superpowers` `6.3.0`
- `code-review`
- `pr-review-toolkit`
- `code-simplifier`
- `feature-dev`
- `security-guidance` `2.0.7`
- `skill-creator`
- `claude-code-setup` `1.0.0`
- `mattpocock-skills` `1.2.3`

*Language servers*

- `typescript-lsp` `1.0.0`
- `pyright-lsp` `1.0.0`
- `gopls-lsp` `1.0.0`

*Design and frontend*

- `frontend-design`
- `figma` `2.2.96`
- `vercel` `0.45.1`

*Issue tracking and docs*

- `github`
- `linear`
- `notion` `0.1.0`

*Infrastructure*

- `cloudflare` `1.0.0`
- `terraform`
- `aws-core` `1.1.0`
- `aws-agents` `1.0.0`
- `aws-transform` `1.6.0`
- `auth0` `2.1.0`

*Databases*

- `mongodb` `1.2.0`
- `prisma` `815dbc4a045a`
- `redis-development` `1.4.0`
- `databases-on-aws` `1.7.0`
- `cloud-sql-postgresql` `0.4.0`
- `cloud-sql-mysql` `0.2.0`

## Standalone skills

None. Every skill available in a session comes from a plugin above or ships with
Claude Code itself. If you add a personal skill later it goes in
`~/.claude/skills/`, and it needs a link in `install.sh` to be tracked.

## Subagents and commands

Tracked in this directory, linked into place by `install.sh`:

- `agents/diff-auditor.md`, audits an uncommitted diff against the rules in
  `AGENTS.md` that no linter enforces
- `commands/pre-commit-check.md`, the `/pre-commit-check` command

## Refresh this inventory

1. Run `/plugin` in a session, or read
   `~/.claude/plugins/installed_plugins.json`.
2. Confirm `enabledPlugins` in `settings.json` matches. A plugin can be installed
   but disabled.
3. Update the versions and the snapshot date above.

Regenerate the version list with:

```bash
jq -r '.plugins | to_entries[] | "- `\(.key | split("@")[0])` `\(.value[0].version)`"' \
  ~/.claude/plugins/installed_plugins.json | sort
```
