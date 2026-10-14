---
name: spec-review
description: Check a diff against the spec it was built from. Reports what's missing, what wasn't asked for, and what looks implemented but wrong. Code quality review is ponytail-review's job.
disable-model-invocation: true
argument-hint: "[spec path] [base ref]"
---

# Spec review

Answer one question: does this change do what the spec asked? Bugs, security, and style belong to `/ponytail-review`. Run both when you want a full review. Keep them separate so a clean pass on one axis can't hide a failure on the other.

## 1. Pin the diff

Use the base the user names. Otherwise use the merge-base with `main`, plus uncommitted and untracked changes, since the user doesn't commit until review is done. Confirm the ref resolves and the diff isn't empty before going further.

## 2. Find the spec

In order:

1. A path the user passed.
2. A file in `docs/specs/` or `docs/architecture/` matching the branch or feature name.
3. The implementation brief earlier in this conversation.
4. Ask. If there isn't one, say so and stop.

## 3. Check every requirement

Go through the spec line by line. For each requirement, find the code that satisfies it, or note it as missing. Then go through the diff hunk by hunk and find the requirement each hunk serves.

Done when every spec requirement and every hunk is accounted for.

## 4. Report

Quote the spec line for each finding, and give the `file:line` it points at.

- **Missing or partial.** Asked for and absent or incomplete.
- **Wrong.** Looks implemented but behaves differently than the spec says. Show the case that differs.
- **Not asked for.** Behavior in the diff with no requirement behind it. Some of it is fine scope a change naturally needs. Say which.
- **Spec gaps.** Decisions the code had to make that the spec never covered. These go back to the user, not to the code.

End with one line: the count per group and the worst finding. Change no code.
