---
name: handoff
description: Compact this session into a handoff document a fresh agent can pick up from.
disable-model-invocation: true
argument-hint: "[what the next session is for]"
---

# Handoff

Write a handoff file to `$TMPDIR` (or `/tmp`), never the repo. If the user said what the next session is for, tailor it to that.

Include:

- **Goal.** What we're trying to get done, in one or two sentences.
- **State.** What's finished, what's in progress, and what's verified versus only claimed.
- **Decisions.** What was settled and the reason for each, so the next agent doesn't reopen them.
- **Next step.** The single next action, specific enough to start on.
- **Watch out for.** Dead ends already tried, gotchas, anything fragile.
- **Files.** Paths to the spec, the changed files, and any scripts or repro commands.
- **Skills.** Which skills the next agent should load.

Point at specs, diffs, and docs by path instead of copying them. Redact keys, passwords, and personal data. Reply with the file path and the line to paste into the new session.
