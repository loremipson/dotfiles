---
name: verify
description: Prove a change works before calling it done, and find what it could break outside the diff. Use before reporting a task complete, when checking another agent's build summary against what it claims, or when asked what a change could break.
---

# Verify

"It compiles" and an agent's own summary are claims, not proof. Check the real artifact.

## 1. Restate the claim

Write down what the change is supposed to do, in observable terms: "a member who deletes their account can't log back in, and their posts still show as [deleted]." Pull it from the spec, the brief, or the agent's summary. When checking a summary, list each claim it makes as its own line.

## 2. Find the one fact it's safe because of

Most risky-looking changes are safe because of one fact, like "this query only ever runs inside the authed route group." Find it. If it holds, most risks clear at once. Then look where grep stops: the library's actual source at its pinned version, what runs at teardown or on retry, a DB column or JSON shape another app reads, a feature flag, code a few hops downstream.

## 3. Get each fact as far down this ladder as is cheap

1. Asserted. Worthless alone.
2. Pointed at a real `file:line` or the library's source.
3. Walked the failure case step by step and showed it can't happen.
4. Ran a script or test that calls the real code and fails loudly if you're wrong.
5. Reproduced it in the running app.

Rung 4 is usually one small script. Keep it so the user can rerun it instead of trusting you. When a check fails, suspect your check before the system. Read the actual value, not a cached or derived copy.

Done when every claim from step 1 has a rung, and the safety fact reaches rung 4 or 5 or is marked unproven.

## 4. Report

- **What it does.** Including the part the diff doesn't spell out.
- **Proven.** Each claim, its rung, and the command or output.
- **Unproven.** What you couldn't check and why.
- **Risks.** How it breaks, `file:line`, how likely, how bad, and the cheapest check.
- **Cleared.** What you checked that turned out fine.

Write it through `unslop`. Never hand the user a check you could have run yourself.
