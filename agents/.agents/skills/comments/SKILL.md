---
name: comments
description: Apply the user's code comment preferences when writing or reviewing source comments. Prefer no comments, use short single-line comments only when they preserve important information the code cannot express, and treat comments that become lengthy or explanatory as a signal to improve the underlying code.
---

# Comments

Default to no comments.

A well-named identifier, function, type, or component should explain what the code does. Comments should preserve information that the code itself cannot reasonably express.

## When a comment earns its place

Use a comment only for information such as:

- A non-obvious constraint imposed by an external system.
- A subtle invariant that must remain true.
- A surprising reason for an otherwise unusual implementation.
- A workaround for a specific platform, library, compiler, browser, or runtime behavior.
- A security or correctness constraint that is not apparent from the code.
- A deliberate performance tradeoff whose reason would otherwise be lost.
- A limitation or behavior of a dependency that materially affects the implementation.

Prefer explaining **why** over explaining **what**.

Good:

```ts
// Keep this retry below 3 to avoid duplicating non-idempotent writes.
```

Bad:

```ts
// Retry the request up to 3 times.
```

## Keep comments short

Comments should normally be a single line.

If a comment wants to become a paragraph, first question the code.

- A name doesn't match what it does -> rename it.
- A block needs a paragraph to justify itself -> extract it into a well-named function.
- Several comments narrate a sequence of steps -> extract those steps into named helper calls.
- A comment explains a complex algorithm -> simplify or isolate the algorithm when practical.

Do not use comments to compensate for confusing structure.

A longer comment is acceptable only when the information genuinely cannot be expressed more clearly in code and the additional context is valuable enough to justify it.

## Comments should age well

Do not write comments that describe facts likely to become stale as code moves.

Never write comments that:

- State what the code plainly does.
- Narrate the current implementation step-by-step.
- Describe an obvious control-flow branch.
- Refer to a specific caller unless that relationship is a durable invariant.
- Refer to the current ticket, PR, task, or debugging session.
- Explain who requested the code.
- Preserve historical context better suited to version control.

Avoid:

```ts
// Used by the checkout page.
```

```ts
// Added for the new billing flow.
```

```ts
// Fix for issue #123.
```

```ts
// This calls the API.
```

Put historical context, rationale for a particular change, and work-item references in the commit message, PR description, issue tracker, or other durable project documentation.

## Prefer code over comments

When the implementation can make its intent obvious, change the code instead of adding prose.

Prefer:

```ts
const activeUsers = users.filter(isActive);
```

over:

```ts
// Filter out inactive users.
const result = users.filter(isActive);
```

Prefer:

```ts
const MAX_RETRY_ATTEMPTS = 3;
```

over:

```ts
// We only retry three times.
const maxRetries = 3;
```

Prefer named helpers when a comment is narrating a conceptual operation:

```ts
const normalizedEmail = normalizeEmail(input);
```

rather than:

```ts
// Lowercase and trim the email before comparing it.
const normalizedEmail = input.trim().toLowerCase();
```

## Preserve non-obvious constraints

Comments are valuable when removing them would make a future maintainer likely to "clean up" code in a way that breaks an invariant.

For example:

```ts
// Must stay sequential: the upstream API rejects concurrent writes.
```

```ts
// Do not remove: Safari requires this focus step before opening the picker.
```

```ts
// Keep this check before normalization; the signature is defined over the raw payload.
```

These comments explain a constraint that cannot be inferred reliably from the surrounding code.

## Assertions and escape hatches

When code contains an unusual TypeScript assertion, compiler suppression, or other escape hatch that cannot be removed, a concise comment may explain the invariant that makes it safe.

Prefer fixing the type problem first.

If the workaround is truly necessary:

```ts
// Runtime schema validation guarantees this shape, but the SDK types do not expose it.
const value = response.data as ValidatedResponse;
```

Do not use comments to legitimize an otherwise unjustified `any`, cast, non-null assertion, or compiler suppression.

## TODO, FIXME, and temporary comments

Do not add `TODO`, `FIXME`, `HACK`, or similar comments merely because something could be improved later.

If the work is required for the current task, do it now.

If the issue is intentionally deferred, use the project's established issue-tracking mechanism rather than creating a source comment unless the repository convention explicitly requires one.

A temporary workaround may be documented when the workaround itself is important and the reason or removal condition is not otherwise obvious.

## Reviewing comments

When reviewing code, prefer removing comments that merely narrate implementation.

Recommend a code change instead when the comment is compensating for:

- Poor naming.
- Excessive complexity.
- Long functions.
- Hidden control flow.
- Duplicated logic.
- Unclear abstractions.

Preserve comments that document genuine constraints, invariants, or non-obvious external behavior.

Do not request comments solely because code is unfamiliar.

## Final check

Before adding a comment, ask:

1. Is this information genuinely absent from the code?
2. Is it explaining **why**, rather than **what**?
3. Is it likely to remain true as the code evolves?
4. Would a future maintainer benefit from knowing it?
5. Can the code be improved instead?

If the answer to those questions is mostly no, do not add the comment.
