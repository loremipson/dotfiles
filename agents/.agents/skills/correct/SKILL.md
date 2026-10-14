---
name: correct
description: Retro on a session or a repeated correction. Turns mistakes agents keep making into checks that make them impossible.
disable-model-invocation: true
argument-hint: "[session or mistake to look at]"
---

# Correct

Assume the next contributor is an agent that sees only the files it opened, copies the nearest example, and takes the shortest path that compiles. Change the repo so that path is the right one.

## 1. Collect the mistakes

Read the session the user names (the current one by default), plus recent reverts, review comments, and the corrections the user gave. Group them into classes. A class counts once it has happened twice, or once if it was expensive.

Also look for:

- **Navigation.** The agent took a long time to find something. A pointer in AGENTS.md or `docs/agents/` would fix it.
- **Missing access.** It needed information it couldn't get: dev server logs, a dashboard, a schema.
- **Dead weight.** Instructions in AGENTS.md or skills that changed nothing, or that a tool already enforces.

## 2. Fix each class at the highest level that works

1. **Architecture.** Give each piece of state one owner and each task one supported way. Hide internals so the wrong import fails. Delete the old way the agent keeps copying.
2. **Types.** Make the bad state impossible to write.
3. **Lint.** A custom oxlint rule whose error message names the fix, like `ui/prefer-flex-component`. If the pattern is already common, fail only when a change adds more.
4. **Test.** One that fails on the real past mistake.
5. **Docs.** Last, and only for judgment calls nothing can check.

## 3. Prove it

For each new check, reproduce the past mistake and show the check fails on it. A check that has never been red hasn't been proven.

## 4. Report

For each class: the evidence, the level you chose, and why a higher level didn't work. Then the files changed and the commit-preparation summary from `git-workflow`. When a rule already existed in docs and the mistake still happened, nothing enforced it, so move it up a level.
