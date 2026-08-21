---
description: Run the pre-commit checklist from AGENTS.md, machine checks then diff audit
---

Run the pre-commit checklist. Do not commit anything. This command verifies, it
does not publish.

## 1. Machine-checked

Run the repository's own scripts for every workspace touched. Never substitute a
per-file `npx` call, because that misses files other tools reflow.

1. `lint`
2. `prettier`, the check, not the fix
3. `build`, plus any workspace depending on one that changed
4. `test` for the affected workspace
5. Any repo-specific gate the repository documents

Find the real script names in `package.json` first rather than guessing them.

If a suite prints passing output but exits non-zero, rerun it and confirm the exit
code before drawing any conclusion. Report the exit code, not the impression.

## 2. Read the diff

Audit `git diff` and `git diff --staged` against the rules no tool enforces:
braces, import grouping, vertical spacing, comment length, ticket references in
code, `as unknown as`, em dashes, `logger.error` first in every `catch`, endpoint
error objects covering the whole call chain, controllers taking primitives,
validation schemas in their own file, only intended files staged, no unrelated
churn, changelog entry correct, knowledge docs updated.

Use the `diff-auditor` subagent for this step only if the user asks for it.
Otherwise do it inline.

## 3. Report

Give the result of each machine check with its exit code, then the diff findings
grouped by file with exact `path:line` references.

Never report a red or flaky result as green. If anything failed, say what failed
and stop there.

End by stating that nothing was committed.
