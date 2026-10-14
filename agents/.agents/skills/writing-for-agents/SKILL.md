---
name: writing-for-agents
description: How to write documents agents read. Use when creating or editing a skill, an AGENTS.md or CLAUDE.md, or any doc an agent reaches through a pointer, like docs/agents/.
---

# Writing for agents

A skill, an AGENTS.md, and a doc in `docs/agents/` are the same kind of thing: instructions an agent follows. The goal is that the agent takes the same process every run.

## Pointers decide when material loads

A skill's description and a line in AGENTS.md naming a doc are both **pointers**. The pointer's wording, not the target's content, decides whether the agent ever reads the target. When a skill doesn't fire, fix the pointer before touching the body.

- Lead with the word that triggers it. "Diagnosis loop for hard bugs" fires on bugs. "A structured methodology for..." fires on nothing.
- One trigger phrase per distinct case. Synonyms for one case are one case.
- Leave out anything the body already says.
- Every always-loaded line costs on every turn. AGENTS.md stays under about 50 lines, mostly pointers.

## Model-invoked or user-invoked

A skill with a model-facing description can fire on its own, and costs its description in every context. A skill with `disable-model-invocation: true` costs nothing until you type its name, but you have to remember it exists. Make it model-invoked only if the agent needs to reach it unprompted, or another skill points at it. Not every harness honors the flag, so give a user-invoked skill a short plain description that won't match ordinary requests.

Two skills whose descriptions match the same request make it a coin flip which one runs. Check new descriptions against existing ones, including plugin skills like ponytail's.

## Steps and reference

A document holds **steps** (what to do, in order) and **reference** (rules consulted as needed). Keep what every run needs in the main file. Move what only some runs need into a sibling file behind a pointer. Keep each concept's rule, example, and caveat together under one heading.

Every step ends on a **completion criterion** the agent can check: "every requirement and every hunk accounted for", not "review thoroughly". A vague criterion invites stopping early.

## Pruning

- **No-ops.** Delete any sentence the model already follows by default: "write clean code", "be careful", "follow best practices". The test is whether removing it changes behavior.
- **Caches.** Don't restate what one command or file shows: `package.json` scripts, directory layout, `--help`. Write down what looking won't reveal: unwritten conventions, the reason behind a choice, the gotcha.
- **Duplication.** Each rule lives in one place. Point to it from elsewhere.
- **Enforcement.** A rule that a lint, type, or test enforces needs at most one line naming what enforces it. Prefer building the check over writing the rule (see `correct`).
- **Staleness.** Point at one canonical example file instead of pasting large code blocks.

## Phrasing

- State the behavior you want. "Write one-line comments" works better than "don't write long comments", because a prohibition puts the unwanted behavior in front of the agent. Keep a prohibition only for a hard guardrail, and pair it with the positive version.
- Reuse a word the model already knows instead of defining a concept: *red* loop, *tracer bullet*, *seam*, *frontier*. A coined word costs its definition every time.
- Write it through `unslop`.
