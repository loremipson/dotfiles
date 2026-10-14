---
name: prototype
description: Build throwaway code that answers one design question. Use when asked to prototype, mock up, try a few layouts, or check whether a state model or flow feels right before building it for real.
---

# Prototype

A prototype is throwaway code that answers a question. Write the question down first, in one line, at the top of the prototype. The question decides the shape.

## Pick the branch

- **"What should this look like?"** Build UI variants.
- **"Does this logic or state model hold up?"** Build a logic demo.

If the user isn't around to ask, pick the branch that matches where the code lives (a page or component means UI, a module means logic) and state the assumption at the top.

## UI variants

- Default to 3 variants, never more than 5. They must differ in structure: layout, information hierarchy, the primary action. Three card grids in different colors isn't a prototype.
- Mount them on the real page that would host the feature, with real data, layout, and density. Switch between them with a `?variant=a|b|c` search param, validated in the route's search schema, and a small floating bar to flip between them. Make a throwaway route only when nothing existing could host it, and put `prototype` in its path.
- Use the project's real components and theme tokens, so the comparison is honest.

## Logic demo

One self-contained HTML file the user can open directly. Free-play buttons fire each event, plus a few guided walkthroughs of the cases that are hard to reason about on paper. After every action, render the full current state, so the user sees exactly what changed.

## Rules for both

- Clearly throwaway. Keep it near the code it's for, named so nobody mistakes it for production.
- One command or one file to run.
- State in memory. If persistence is the question, use a scratch database named as a prototype.
- No tests, no polish, no abstractions. Error handling only where it keeps the thing running.

## When it's answered

Write down the verdict and the question it settled, in the spec or the conversation. Fold the winning decision into real code separately. Delete the prototype, or leave it on a local branch the user can find, and say which you did.
