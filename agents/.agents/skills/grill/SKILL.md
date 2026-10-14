---
name: grill
description: Interview the user in rounds to stress-test a plan, design, or decision until nothing is left assumed. Use when asked to grill, poke holes in, pressure-test, or sanity-check a plan before building.
---

# Grill

Map the plan as a decision tree: each decision branches into the ones that depend on it. Work the tree in rounds until every branch is settled.

## Rounds

The **frontier** is every open decision whose prerequisites are already settled. Ask the whole frontier in one round. A question that depends on another question in the same round waits for a later one.

Format each question like this, and word it so "yes" accepts your recommendation:

```
**Q1. <short title>**
<the question, with the options if there are several>

Recommended: <your answer and the one-line reason>
```

After the user answers, recompute the frontier and ask the next round.

## Facts are your job, decisions are theirs

Never ask the user something you could look up: what the code does, what a library supports, what the schema allows. Look it up, or send a subagent while you ask the rest of the frontier. Only the questions downstream of that lookup wait. Put the product, scope, and preference calls to the user, and push back when an answer seems wrong for their own stated goals.

## Done

The session is done when the frontier is empty and nothing is silently assumed. Summarize the settled decisions as a short list. Then confirm the user agrees before acting on any of it. If they want it captured, hand off to `spec`.
