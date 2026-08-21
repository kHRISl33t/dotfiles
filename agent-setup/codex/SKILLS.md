# Active Codex skills

This is a snapshot of the skills active on 2026-08-17. Codex and plugin updates can change the active set. Use the discovery commands in `README.md` for the live catalog.

## Bundled system skills

These ship with Codex and do not need manual installation.

- `imagegen`
- `openai-docs`
- `plugin-creator`
- `skill-creator`
- `skill-installer`

## Standalone user-installed skills

These are installed under `~/.codex/skills/`.

- `cli-creator`
- `codebase-design`
- `domain-modeling`
- `frontend-design`
- `figma`
- `gh-address-comments`
- `gh-fix-ci`
- `linear`
- `notion-knowledge-capture`
- `notion-meeting-intelligence`
- `notion-research-documentation`
- `notion-spec-to-implementation`
- `playwright`
- `playwright-interactive`
- `security-best-practices`
- `security-ownership-map`
- `security-threat-model`
- `writing-for-agents`

## Third-party source pins

### mattpocock/skills

- Source: [`mattpocock/skills`](https://github.com/mattpocock/skills)
- Revision: [`9c9f36ccd3995266cd675468af71639c8dde1ec5`](https://github.com/mattpocock/skills/commit/9c9f36ccd3995266cd675468af71639c8dde1ec5), committed 2026-08-17
- Installed unchanged: `codebase-design`, `domain-modeling`
- Installed with a local Codex adaptation: `writing-for-agents`
- Adaptation: require explicit `$writing-for-agents` invocation and replace Claude-only `disable-model-invocation` guidance with Codex description-based routing guidance
- Update warning: reinstalling `writing-for-agents` overwrites the local adaptation. Reapply it and rerun implicit and explicit routing checks after updating.

## Plugin-provided skills

These are supplied and updated by their plugins.

- Browser
  - `browser:control-in-app-browser`
- Documents
  - `documents:documents`
- PDF
  - `pdf:pdf`
- Plugin Management
  - `plugin-management:plugin-management`
- Presentations
  - `presentations:Presentations`
- Sites
  - `sites:sites-building`
  - `sites:sites-hosting`
- Spreadsheets
  - `spreadsheets:Spreadsheets`
  - `spreadsheets:excel-live-control`
- Template Creator
  - `template-creator:template-creator`
- Visualize
  - `visualize:visualize`

## Superpowers plugin

Superpowers version `6.2.0` provides these workflow skills:

- `superpowers:brainstorming`
- `superpowers:dispatching-parallel-agents`
- `superpowers:executing-plans`
- `superpowers:finishing-a-development-branch`
- `superpowers:receiving-code-review`
- `superpowers:requesting-code-review`
- `superpowers:subagent-driven-development`
- `superpowers:systematic-debugging`
- `superpowers:test-driven-development`
- `superpowers:using-git-worktrees`
- `superpowers:using-superpowers`
- `superpowers:verification-before-completion`
- `superpowers:writing-plans`
- `superpowers:writing-skills`

## Refresh this inventory

1. Check the Skills and Plugins sections in the Codex desktop app, or use `/skills` and `/plugins` in Codex CLI.
2. Check standalone skill folders under `~/.codex/skills/`.
3. Update this file when skills or plugins are added, removed, or upgraded.
