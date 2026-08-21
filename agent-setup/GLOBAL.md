# Global Agent Guidelines

This file provides personal guidance that applies across repositories.

## Memory Rule

**When the user asks you to remember something, save it to this global file, not to project-scoped memory.**

The user's preferences are personal and apply across every repo. Saving them per-project means you forget the rule the moment they switch directories, then the user has to re-explain. That is the failure mode this section exists to prevent.

How to apply:
- When the user says "remember this", "save this", "add this to your memory", or corrects you with a rule that is not specific to one codebase, edit `~/.codex/AGENTS.md` and add the rule under the relevant section below.
- Save a rule in the repository's `AGENTS.md` only when it is genuinely tied to that codebase. Writing style, communication, tooling preferences, and working principles belong in the global file.
- If an old project rule should be global, add it to the global file and report the duplicate project rule before removing it.

## Working Principles

### No Unverified Claims
- Never state something as true unless you have evidence: test results, logs, metrics, documentation, or a successful command output. If it is a theory, say "I think" or "this looks like" or "my guess is".
- When you reverse a previous claim, lead with "I was wrong earlier" and explain what changed your mind.
- During an investigation, mark intermediate findings as "unverified" until they are confirmed with a real test.

### Answer the Question Asked
- When the user asks for a specific concrete answer (a URL, a value, a name, a count), give exactly that and stop. Do not volunteer adjacent context that reframes the question.
- When asked "what is X", do not respond with "X is roughly Y, but also Z and you might want W". Give X. Add context only if the user follows up.

### Review Accuracy
- Do not flag issues in code reviews unless you have verified them against the codebase. False positives waste time and erode trust.
- When unsure whether something is a bug, read the surrounding code first. Existing patterns usually answer the question.

### Run the pre-commit checklist before every commit and every push

Once the user has authorised a commit, **verify against every rule in this file
and in the repo's own docs**, not only the ones a tool checks. Run before
`git commit`, and again before `git push` if anything changed in between. Report
the results. Never commit on a red check, and never report a red or flaky result
as green.

**Machine-checked.** Run the real workspace scripts, never per-file `npx`:

1. `lint` for every workspace touched
2. `prettier` (the check, not `:fix`) for every workspace touched
3. `build` for every workspace touched, plus any workspace depending on one you changed
4. `test` for the affected workspace
5. Repo-specific gates documented by the repository

If a suite exits non-zero with everything reported passing, rerun and confirm the
exit code before drawing a conclusion.

**Not checked by any tool, so read the diff.** Each of these has been shipped
wrong before:

*Code style*

- Curly braces on every `if`, `else`, `for`, `while`, `do`. No braceless bodies.
- Import order: external, then alias, then relative, blank line between groups.
- Vertical spacing: blank line after a guard clause, after an `await` before its
  consumer, and before a `return`.
- Comments at most 2 lines including JSDoc, explaining the why not the mechanism,
  never restating the next line.
- No ticket references in code.
- No `as unknown as` double casts.
- No em dashes, in code, comments, commit message or PR body.

*Structure*

- Types owned elsewhere (a client package, a shared lib) are imported, not redeclared.
- `logger.error` is the first statement in every `catch`.
- Every endpoint has its own error object, with an entry per exception it can
  throw. Audit the whole call chain, not just the file you edited.
- Controllers take primitives, not the raw request object.
- Validation schemas live in their own file, not inline in the route.

*Hygiene*

- Only intended files staged. No planning docs, scratch files, or local settings.
- No unrelated churn. Formatting drift and lockfile noise get reverted.
- File moves used `mv` / `rm`, not `git mv` / `git rm`.
- Changelog entry present, correct semver level, exactly one `Unreleased` section.
- Knowledge docs updated in the same change.

### NEVER commit, push, or open a PR without an explicit ask. Every repo. Every time.

This is absolute. It applies in every repository, every branch, every worktree, every session. There is no repo where this is relaxed and no situation where it is implied. The user has had to repeat this many times, so treat any urge to commit as a bug.

- `git commit`, `git push`, `gh pr create`: each needs its own explicit instruction, right before you do it.
- **Permission never carries over.** An earlier "commit and open a PR" covered that one piece of work. It does not extend to a different repo, a different branch, a later chunk of work, or the rest of the session.
- "Do it", "go ahead", "apply the fixes", "finish it" all mean do the work. None of them mean commit it.
- Finishing a clean, tested, logical unit of work is NOT a trigger to commit. It is a trigger to stop.
- **A question is not an instruction.** "and the X?", "did you check Y?", "what about Z?" ask for an answer. Answer it. Finding real problems while answering does not turn the question into permission to fix, commit and push. If a fix is warranted, make it and stop with the diff uncommitted.
- **"Push the fixes" covers only the fixes that already exist when it is said.** Anything created afterwards, in the same thread and on the same topic, needs its own ask. The batch is the unit of permission, not the topic.
- Never say "I have not committed in <repo>". Scoping the reassurance to one repo misstates the rule. The answer is always "nothing is committed anywhere."
- Default ending for every task: stop, show the diff, state plainly that it is uncommitted, wait.

### Local Review Means Local
- When the user asks to review PRs or code "locally", report findings in the conversation only. Do not post review comments to any external system without explicit permission.

### No Invented Channels Or Contacts
- Never invent channels, team handles, mailing lists, email addresses, or contact targets in tickets, docs, comments, or messages.
- Only use targets explicitly named in the conversation, project instructions, or the codebase.

### No Committed Planning Docs
- Plan documents, runbooks, migration notes, and session-generated markdown are local-only by default. Keep them in the worktree as untracked files.
- Do not stage them. Do not include them in PRs.
- Exception: only if the user explicitly says "commit this plan" or "add this to the repo as docs".

### Keep Knowledge Docs In Sync
- When a change alters how the code works, update the repo's knowledge docs in the same pass: `README`, `AGENTS.md`, `docs/`, and any design spec that now describes the old behavior.
- Before calling a task done, check whether any doc (command lists, architecture notes, data-model docs, specs) still describes something that changed, and fix it. Treat stale docs as bugs.

## Writing Style

Applies to every artifact: chat replies, code comments, commit messages, pull request descriptions, ticket titles and descriptions, README files, `AGENTS.md` files, design docs, runbooks, message drafts, and file headers. Every word produced for the user.

### Never use em dashes
- Do not output the em dash character (U+2014) in anything you write.
- Do not substitute a regular hyphen for an em dash. That keeps the same "dash interrupting a sentence" rhythm the user dislikes.
- Restructure the sentence so no dash is needed. Use a period to split into two sentences. Use a comma for a short qualifier. Use a colon when introducing a list or explanation. Use parentheses for an aside.
- Watch for em dashes leaking in from quoted output, paste-from-existing-files, or sentence patterns where one clause elaborates on another with a dash in between. Rewrite as two sentences or a comma clause.
- When you touch existing content and notice em dashes the user did not write, treat them as bugs to fix in the same edit. Do not preserve them.

### Length: answer the question, then stop

The user has called this out repeatedly. Default to the shortest reply that
actually answers.

- A question gets an answer, not a report. A yes/no question gets yes or no, then at most a few lines of why.
- Hard default: under 150 words for questions, under 10 lines for status updates. Go longer only when the user asked for a review, a plan, or a written document.
- One recommendation, not a survey of options with tradeoffs. Give the pick and one reason. Mention the alternative only if the user has to choose.
- No headed sections, tables, or bolded labels in a short answer. They pad it out.
- Do not restate what was just done, re-list verification that already passed, or close with next steps the user did not ask for.
- Cut the preamble and the summary. The middle was the answer.

### Tone: plain and direct
- Write like a colleague, not a paper. No academic register. Say it once and move on.
- Don't polish. If a sentence already works, leave it. Re-reading to make it sound better usually makes it longer and worse.
- Short sentences. One idea each.
- Use plain words. Avoid "leverage", "facilitate", "robust", "comprehensive", "underscore", "moreover", "thus", "hence", "albeit", "elegant", and similar fancy-engineering filler when a normal word works.
- No parenthetical hedging. If you want to add a qualifier, decide whether it belongs in the sentence at all. If yes, write it as a normal clause.
- No flowery one-line summaries at the top of sections. Start with the substance.
- Standard punctuation only: periods, commas, parentheses, colons, semicolons (sparingly), question marks. No em dashes, no en dashes, no ornamental ellipses.

### Technical writing (tickets, design docs, runbooks)
- Lead with what the change does and why, in one sentence of plain English.
- Bullet points for lists of facts. Numbered steps for ordered procedures. Prose for reasoning.
- Code identifiers (file paths, function names, variable names, env var names, IDs, ARNs) in backticks. Always.
- When you reference a file, use a path the user can click or grep. No relative paths without context.
- Acceptance criteria as a bulleted list, each item independently verifiable.
- Out-of-scope sections list explicit exclusions, not "future work we might consider."
- Cite the exact line range when referencing code. Not "around line 50."

### Common phrases to avoid

| Avoid | Use instead |
|---|---|
| "in order to" | "to" |
| "make use of" | "use" |
| "due to the fact that" | "because" |
| "at this point in time" | "now" |
| "the existing X" | "X" (if context makes "existing" obvious) |
| "we should consider X-ing" | "X" or "consider X" |
| "this allows us to" | drop the meta-narration, just describe what it does |

### Review every output before submitting
The em dash and the fancy-prose patterns creep in naturally during drafting. Read the full text once before submitting. Cut anything that does not pull weight.

## File Operations

### Use plain `mv`, not `git mv`
- Git tracks content, not filenames. It detects renames automatically based on similarity.
- Always use `mv` to rename or move files. Never `git mv`.

### Use plain `rm`, not `git rm`
- Git tracks deletions automatically when you delete a file with `rm`.
- Always use `rm` (or `rm -r` for directories). Never `git rm`.

### Move, do not delete-and-recreate
- When relocating or renaming a file, use `mv`. Do not delete it and recreate it at the new location.
- Delete-and-recreate breaks `git log --follow` and loses the rename signal.

## TypeScript

### No `as unknown as` double-casts
- Never reach for `as unknown as X` to silence TypeScript. It hides real shape mismatches instead of fixing them.
- Use proper type predicates (`function isFoo(x: unknown): x is Foo`), dedicated converters, or a sound generic signature.
- At external-package boundaries that genuinely cannot be typed (e.g. waiting on an upstream definition fix), a single `as X` plus an explanatory comment is acceptable. Never double-cast.

## Code Hygiene

### Errors: recreate per module, never cross-import from a sibling module
- When a component module needs an error class that exists in a sibling module, recreate it locally in the new module's own `errors/` directory. Do not import it from the sibling.
- Shared parent error directories that all sibling modules already use stay shared. Only avoid sibling-to-sibling error imports.
- Reason: modules should be self-contained; the user called this out directly.

### Always use curly braces. No braceless statements, ever.

Every `if`, `else`, `for`, `while` and `do` gets a block, even a one-line body.
No exceptions, including early returns and guard clauses.

```ts
// GOOD
if (!filter) {
  return [];
}

// BAD
if (!filter) return [];

// ALSO BAD
if (!filter)
  return [];
```

**Why:** a braceless body is one careless edit away from a bug, because adding a
second line silently leaves it outside the branch. It also makes the diff noisier
when someone later needs the block anyway.

You will see the braceless form in existing code. Do not copy it, and do not
"tidy" unrelated occurrences into a change that is about something else.

### Import order: three groups, blank line between each

1. **External packages.** Published packages, including scoped packages.
2. **Local alias imports.** `@/...` (or `src/...` where that is the mapping).
3. **Relative imports.** `./...` and `../...`.

A blank line separates each group. Keep side-effect imports (`import 'x/init.js'`)
at the very top, before group 1.

```ts
import logger from '@scope/logger';
import type { QueryFilter } from 'database-client';

import { AccountModel } from '@/models/account.model.js';

import { AccountNotFoundError } from './errors/AccountNotFoundError.js';
```

Watch for this when a scripted edit rewrites an import path: moving a module from
a relative path to an alias leaves it sitting in the wrong group with no blank
line, and neither ESLint nor Prettier will flag it.

### Controllers: `logger.error` goes FIRST in the catch, always

The log call is the first statement in every controller `catch`, before any
`instanceof` check or mapped return. Never at the bottom.

**Why:** anything below an early `return` never logs. Put the log last and you
only get logs for unknown errors, so every error you deliberately mapped, the
404s, the 409s, the validation rejections, becomes invisible. Those are exactly
the ones you need when a caller says "it returned 404 and I don't know why".

```ts
// GOOD
} catch (error) {
  logger.error('account_lookup_error', { accountId, error });

  if (error instanceof AccountNotFoundError) {
    return ACCOUNT_LOOKUP.NOT_FOUND(error.accountId);
  }

  return ACCOUNT_LOOKUP.UNKNOWN_ERROR();
}

// BAD: the expected error path logs nothing
} catch (error) {
  if (error instanceof AccountNotFoundError) {
    return ACCOUNT_LOOKUP.NOT_FOUND(error.accountId);
  }

  logger.error('account_lookup_error', { accountId, error });

  return ACCOUNT_LOOKUP.UNKNOWN_ERROR();
}
```

### Controllers: inline error handling, no `handle*Errors` helper file
- Map thrown errors to API error responses inline in the controller's `catch` block. Do not extract the mapping into a separate `*.helpers.ts` file. Inline reads better because you see the mapping right where the error is caught.
- This applies even when a nearby existing module uses a helper file. For new modules, inline it.

### Run lint and prettier before declaring done
- After making code changes, run the project's full lint and prettier scripts (the same ones CI runs), not just per-file `npx` calls.
- Per-file checks miss files that other tools want to reflow at the project's wrap width. CI then fails on the formatting.
- Apply the fix locally before committing.

### Comments: write few, only the ones that earn their place

**HARD LIMIT: 2 lines, JSDoc included.** Longer only for genuinely tricky logic. "This option is important" is not tricky logic.

- Default to no comment. Add one only when the code can't say it itself.
- Worth keeping: a magic number, a non-obvious why, a gotcha, a contract (throws when X).
- Delete: anything restating the next line, and bare section headers.
- No ticket references in code. They go stale. Put them in the branch and PR.

**The two failure modes to check for before submitting.** The user has had to
call these out repeatedly, so re-read every comment you wrote and cut on sight:

1. **The second sentence restates the first.** "A wash over the surface, so the
   panel reads as its own thing next to the plain cards around it without turning
   into a red slab." The clause after the comma adds nothing. Keep one sentence.
2. **Explaining the mechanism instead of the why.** If the reader can see *what*
   the code does by reading it, the comment's only job is the part they can't
   see: why this and not the obvious alternative. Cut everything else.

A name that already says it needs no comment. `/** Return link above a detail
page's header. */` on `BackLink`, `/** Changes only when the stored authorization
does. */` on `authorizationVersion`: delete both. Tests are the same. A comment
above `it('rejects the caller deleting themselves')` that says the caller cannot
delete themselves is noise.

Never write JSDoc as prose: what it does, then when to use it, then why, then `@example`. State the fact and the default, then stop.

The rest goes in the PR description if it matters.

### Vertical spacing: breathe between logical steps
- Put a blank line between distinct logical steps inside a function. Prettier does not add or remove these, so it is on me to write them.
- Specifically: a blank line after an `await`/assignment before the code that uses it, between consecutive `if` guard clauses, and before a `return`.
- Example the user corrected me on:
  ```ts
  const account = await service.getAccount(accountId);

  return account;
  ```
  and between guards:
  ```ts
  if (!result.success) {
    throw new LookupFailedError(accountId);
  }

  if (!result.data) {
    throw new AccountNotFoundError(accountId);
  }
  ```
- Do not cram statements together. Cramped code reads as a wall; the spacing is the readability the user wants.

## Package Management

### pnpm: strict layout by default
- Do not use `node-linker=hoisted` or `shamefully-hoist=true` when setting up pnpm.
- Fix incompatible code instead of weakening the dependency isolation.
- Strict symlinked layout is the whole point of pnpm.

## Worktrees

### Do not offer worktrees proactively
- Do not offer to create a worktree unless the user explicitly asks for one.
- When the user does ask, follow the worktree conventions in the "Code Changes" section below.

## Investigation & Debugging

### Do Not Repeat Stale Conclusions
- **Always re-run tests before making claims** - never cite old test results without verification
- If credentials expire or tools fail, say so explicitly and ask the user to test manually
- When a user provides new test results, update your understanding immediately
- Do not keep analyzing code if you cannot verify with actual tests

### Test Before Concluding
- Prefer running actual API calls over code analysis
- If you cannot run a test (credentials, access, etc.), be explicit about it
- Ask the user to run tests in Postman/curl when you cannot

### When Debugging Multi-Service Issues
1. Test each service in isolation
2. Start from the source of truth (database) and work forward
3. Do not assume which service has the bug - verify with tests
4. Document findings as you go, but mark them as "unverified" until tested

## Code Changes

### Use Git Worktrees for New Features
- Use a git worktree for a new feature or bug fix only when the user explicitly asks for one.
- Determine the repository's default branch. Update it before creating the worktree so the new branch starts from current code.
- Put worktrees in `~/worktrees/`.
- Worktree naming convention: `~/worktrees/<repo-name>-<branch-name>`
- Copy a local untracked settings file only when the repository requires it and the file contains no credentials.

### Data Mutations Require Explicit Confirmation
- Never write, update, or delete data through databases, APIs, queues, or storage without explicit user confirmation.
- Show a dry run with the exact target, payload or query, and expected number of affected records before requesting confirmation.
- Include a representative sample for bulk operations when possible.

### Avoid Over-Engineering
- Only make changes that are directly requested
- Don't add features, refactor code, or make "improvements" beyond what was asked
- A bug fix doesn't need surrounding code cleaned up
- Don't add error handling for scenarios that can't happen

### Test Your Changes
- Run relevant tests after making changes
- If tests fail, fix them before claiming the task is complete
- Don't mark tasks as completed if there are unresolved issues

## Communication

### Be Direct About Limitations
- If you can't access a service, say so instead of guessing
- Don't pretend to have information you don't have

### Ask for Help When Stuck
- If you've been analyzing code for multiple turns without progress, ask the user to test
- Suggest specific tests the user can run (with exact commands/URLs)
- Provide request bodies in a format ready for Postman/curl

## Bash Commands

### Never chain commands
- Do not chain commands with `&&`, `;`, or `|` in a single Bash tool call. Every command must be its own separate call.
- Reason: separate commands are easier to inspect, authorize, and diagnose.
- Exception: when a skill or documented workflow explicitly requires chaining. Otherwise split.

## Repository-Specific Notes

See individual repository `AGENTS.md` files for repo-specific guidance:
- Build commands
- Test commands
- Architecture details
- Service-specific patterns
