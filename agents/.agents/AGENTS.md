# Global agent rules

These apply in every repo. A repo's own AGENTS.md wins where it's more specific.

## Git

Git history belongs to Tyler. Inspect freely, change the working tree as the task needs, and leave committing, pushing, and branch changes to him. Finish with the commit-preparation summary from the `git-workflow` skill.

## Done means proven

Before reporting a task complete, run the checks the repo defines (tests, typecheck, lint) and show the result. For anything with behavior, prove it against the real artifact, using `verify`. Label every claim as checked, inferred, or guessed.

## Code

Ponytail is on for code size and reuse. Beyond it:

- When adding a dependency, change only that package, keep lockfile changes to what it needs, and check its maintenance and install scripts.
- Leave unrelated dependencies at their current versions.

## Prose

Anything Tyler will read goes through `unslop`. Anything sent or published under his name goes through `my-voice`. No em dashes in either.

## Asking

Look up facts yourself. Ask only for decisions that are his to make: product calls, scope, anything irreversible or customer-facing.
