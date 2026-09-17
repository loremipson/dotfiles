---
name: git-workflow
description: Apply the user's Git safety and commit-preparation preferences when working in repositories. Never commit, push, merge, rebase, cherry-pick, or discard user changes unless explicitly instructed. Inspect and modify the working tree as needed, then identify the files or specific hunks that should be committed and propose Conventional Commit messages.
---

# Git workflow

Treat Git history and the user's existing changes as human-owned.

The agent may inspect the repository and modify the working tree, but must never create or publish Git history on its own.

## Never commit or publish

Never run or perform:

- `git commit`
- `git push`
- `git merge`
- `git rebase`
- `git cherry-pick`

Do not use aliases, scripts, IDE integrations, or other mechanisms that perform these operations indirectly.

Do not create commits merely because the requested implementation is complete.

The user decides when and how changes become history.

## Never discard user work

Do not discard, overwrite, or reset changes that the user has made unless explicitly instructed.

Never use destructive operations such as:

- `git reset --hard`
- `git restore` on user-modified files
- `git checkout` to overwrite changes
- deleting untracked files
- force-updating branches

Before modifying files, inspect the working tree when necessary to distinguish existing user changes from work introduced during the current task.

Preserve unrelated changes.

## Do not silently alter history or branch state

Do not:

- Rewrite commit history.
- Force-push.
- Delete branches.
- Change remotes.
- Change Git configuration globally.
- Rebase or reorder commits.
- Amend existing commits.

Branch creation or switching is also a state-changing Git operation. Do not do it unless explicitly requested or clearly necessary for the task.

When a task can be completed without changing branches, leave the current branch alone.

## Staging

Do not stage changes merely because they are ready to commit.

Leave the index alone unless the user explicitly asks for staging or a Git operation that requires it.

When the work is complete, tell the user exactly what should be staged.

Be precise about hunks when a file contains unrelated changes.

For example:

```text
Stage:
- src/client.ts — lines 42-67, the timeout handling change
- src/client.test.ts — the new timeout test

Do not stage:
- src/client.ts — the unrelated formatting changes already present
```

Use `git diff`, `git diff --cached`, and related inspection commands to understand the working tree and identify the appropriate changes.

## Preserve unrelated work

A repository may already contain changes unrelated to the current task.

Do not:

- Reformat unrelated files.
- Clean up unrelated code.
- Rename unrelated identifiers.
- Modify unrelated tests.
- Include unrelated changes in the proposed commit.

If an existing change makes the requested work ambiguous, inspect the diff and work around it rather than reverting it.

## Commit preparation

When implementation is complete, provide a concise commit-ready summary.

Identify:

1. The files that belong in the commit.
2. Specific hunks when only part of a file should be included.
3. Any files that should explicitly remain unstaged.
4. One or more suggested commit messages.

Do not stage or commit them yourself.

## Conventional Commits

Suggest commit messages following Conventional Commits:

```text
<type>(<scope>): <description>
```

Use a type that accurately describes the change, such as:

- `feat`
- `fix`
- `refactor`
- `perf`
- `test`
- `docs`
- `build`
- `ci`
- `chore`

Use a scope when the repository has a natural component, package, feature, or domain for it.

Keep the subject concise and imperative.

Prefer:

```text
fix(environmental): handle EDR timeout responses
```

over:

```text
fix: fixed some issues with EDR API calls
```

Do not invent a scope if the repository does not use meaningful scopes.

Do not force a `BREAKING CHANGE` unless the change actually breaks the public contract.

## Split logical changes

When the working tree contains multiple logically independent changes, recommend separate commits rather than one large commit.

For example:

```text
Suggested commits:

1. fix(environmental): handle EDR timeout responses
   - src/edr/client.ts
   - src/edr/errors.ts

2. test(environmental): cover EDR timeout handling
   - src/edr/client.test.ts
```

Keep the suggested history meaningful and reviewable.

Do not split changes artificially just to create more commits.

## Commit message should describe the result

Describe what changed, not the process used to get there.

Prefer:

```text
feat(auth): support SSO session refresh
```

over:

```text
feat(auth): refactor authentication code and fix tests
```

unless the refactor itself is the meaningful result.

Avoid vague subjects such as:

```text
fix bugs
updates
misc changes
cleanup
work on API
```

## Git inspection is encouraged

Read-only Git operations are encouraged when they help understand the task:

- `git status`
- `git diff`
- `git diff --check`
- `git log`
- `git show`
- `git blame`
- inspecting branches and remotes
- inspecting tracked and untracked files

Use repository history when it provides useful context for understanding an implementation or preserving established conventions.

Do not inspect excessive history without a reason.

## Final response

When the work is complete, report the implementation result and then provide the Git preparation section.

Use a format like:

```text
### Commit preparation

Stage:
- src/foo.ts — hunks implementing X
- src/foo.test.ts — tests covering Y

Leave unstaged:
- src/foo.ts — pre-existing changes unrelated to this task

Suggested commit:
fix(foo): handle invalid response payloads
```

When there are multiple logical commits:

```text
### Commit preparation

1. Stage:
   - src/foo.ts — ...
   - src/foo.test.ts — ...

   Suggested commit:
   fix(foo): handle invalid response payloads

2. Stage:
   - src/bar.ts — ...

   Suggested commit:
   refactor(bar): simplify response handling
```

Do not provide a fake commit hash.

Do not imply that anything was committed or pushed.

## Final safety check

Before finishing, verify:

- No commit was created.
- Nothing was pushed.
- No existing commit was rewritten.
- No user changes were discarded.
- Unrelated changes remain untouched.
- The recommended files and hunks are clearly identified.
- Suggested commit messages follow Conventional Commits.
