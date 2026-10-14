---
name: spec
description: Turn the current conversation into a spec file and an implementation brief another agent can build from. Use when asked to write a spec, write up the plan, or write a prompt or brief for a coding agent.
argument-hint: "[feature name]"
---

# Spec

Synthesize what's already been decided. Don't interview. If a decision the build needs is still open, list it under Open questions rather than picking for the user.

## 1. Ground it in the code

Read the parts of the repo the feature touches, plus its AGENTS.md, `docs/agents/`, and any design in `docs/architecture/` or `docs/decisions/`. Use the repo's own names for things. Find the existing pattern each new piece should copy, and name that file.

## 2. Pick the seams

Name where the feature will be tested, preferring seams that already exist and the highest one that's still fast. Confirm them with the user.

## 3. Write the file

Save to `docs/specs/<feature>.md`, or wherever the repo already keeps specs. Use this shape:

```markdown
# <Feature>

## Problem
What the user faces today, from their side.

## Behavior
Numbered, observable statements of what's true when this ships.
"A member who deletes their account can't sign back in."

## Decisions
Schema changes, module boundaries, interfaces, and anything settled in conversation.
Name the pattern file to copy. Inline a snippet only when it's the decision itself:
a type shape, a state machine, a schema.

## Tests
The agreed seams and what each one proves.

## Out of scope
What this deliberately leaves for later, so the builder doesn't add it.

## Open questions
Anything undecided. Empty is the goal.
```

Behavior lines are what `spec-review` checks against later, so each one must be checkable.

## 4. Write the brief

Below the spec, in the reply, write the prompt you'd paste into a fresh agent session. It points at the spec file instead of repeating it. It says what to build first, which skills to load (`tdd`, `verify`), the commands that must pass before it reports back, and that it ends with the commit-preparation summary from `git-workflow`.
