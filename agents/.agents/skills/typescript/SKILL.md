---
name: typescript
description: Apply strict, opinionated TypeScript conventions when writing, modifying, refactoring, or reviewing TypeScript. Enforce type-safe boundaries, avoid `any` and unnecessary assertions, prefer narrowing and discriminated unions, preserve type information, and use TypeScript's type system to model valid states rather than bypassing the compiler.
---

# TypeScript

Write TypeScript that uses the type system to make invalid states difficult to represent. Treat the compiler as a design tool, not an obstacle to work around.

## Hard rules

### Never use `any`

Do not introduce explicit or implicit `any` to avoid dealing with a type.

Prefer:

```ts
const value: unknown = getValue();
```

Then narrow it before use.

Do not use `any` even temporarily in a fix unless the user explicitly asks for it.

When a third-party library has inadequate types, isolate the problem at the boundary and preserve strong types everywhere else.

### Avoid type assertions

Do not use `as` to tell TypeScript something is true merely because the code expects it to be true.

Avoid:

```ts
const user = response.data as User;
```

Prefer establishing the fact:

```ts
const user = parseUser(response.data);
```

or narrowing with a type guard:

```ts
if (isUser(response.data)) {
  // response.data is User here
}
```

A type assertion is acceptable only at a genuine boundary where the runtime fact is established elsewhere and TypeScript cannot represent that relationship. Keep such assertions narrow, local, and explain why they are sound when the reason is not obvious.

Never use a broad assertion to silence an error and then continue propagating the assumed type.

### Prefer `satisfies` for shape validation

When the goal is to verify that a value conforms to a type while retaining its inferred literal types, prefer `satisfies` over `as`.

```ts
const routes = {
  home: "/",
  settings: "/settings",
} satisfies Record<string, string>;
```

Do not use `satisfies` as a substitute for runtime validation. It only checks types at compile time.

### Avoid non-null assertions

Do not use `!` to suppress nullability errors.

Prefer explicit control flow, early returns, helper functions, or APIs whose types encode the invariant.

If a value truly cannot be null at a particular boundary, establish that fact in code rather than suppressing the compiler.

### Prefer narrowing over weakening

When a value is uncertain, keep it uncertain until its type can be established.

Prefer:

```ts
function isError(value: unknown): value is Error {
  return value instanceof Error;
}
```

over:

```ts
const error = value as Error;
```

Put runtime validation and narrowing at system boundaries: HTTP responses, parsed JSON, environment variables, user input, database results, message queues, and third-party APIs.

## Model the domain with types

### Prefer discriminated unions

When behavior depends on a finite set of states, prefer a discriminated union over multiple booleans, nullable fields, or loosely-related optional properties.

Prefer:

```ts
type Result<T> =
  { status: "success"; value: T } | { status: "error"; error: Error };
```

over combinations such as:

```ts
type Result<T> = {
  loading: boolean;
  error?: Error;
  value?: T;
};
```

Make invalid states unrepresentable whenever practical.

Use exhaustive checks for discriminated unions when it matters that every case is handled.

### Prefer precise types

Avoid broad types such as:

```ts
object;
Function;
Record<string, unknown>;
string;
```

when the domain has a more precise representation.

Use interfaces, type aliases, unions, generics, branded types, or constrained object types when they communicate meaningful invariants.

Do not add type complexity for its own sake. Prefer the simplest type that accurately describes the domain.

### Preserve inference

Do not annotate every local variable merely to restate what TypeScript already knows.

Prefer inference for straightforward internal values:

```ts
const users = getUsers();
const count = users.length;
```

Add explicit types when they improve an API boundary, document an important contract, constrain inference intentionally, or prevent an invalid widening.

### Exported APIs should be deliberate

For exported functions, classes, public methods, library APIs, and important module boundaries, use explicit return types when doing so makes the contract clearer or prevents accidental API changes.

Do not force explicit annotations onto trivial private implementation details just for consistency.

## Functions and control flow

Prefer small functions with inputs and outputs that are obvious from their types.

Prefer early returns over deeply nested conditionals when they make control flow easier to follow.

Prefer exhaustive branching over a default branch that silently swallows newly-added union members.

When a function cannot meaningfully handle a state, make that impossible through the type system or fail explicitly. Do not quietly coerce the state into something convenient.

Avoid boolean parameters when they obscure meaning or create multiple modes of behavior. Prefer a named options object or a discriminated input when appropriate.

## Nullability and optional values

Treat `null` and `undefined` as meaningful states when the domain uses them. Do not erase them merely to simplify code.

Distinguish between:

- a property that is absent;
- a property that is explicitly `undefined`;
- a value that is `null`; and
- a value that is present and valid.

Use optional properties only when absence is semantically meaningful.

Prefer APIs that return explicit success/failure or optional states over sentinel values when the distinction matters.

## Error handling

Use `unknown` for caught errors unless the runtime guarantees a narrower type.

```ts
try {
  await work();
} catch (error: unknown) {
  if (error instanceof Error) {
    logger.error(error.message);
  }
}
```

Do not assert caught values to `Error` without establishing that they are errors.

Preserve the original error and useful context when wrapping errors.

Do not use `throw new Error(...)` merely to normalize everything if the original error contains important information that should be retained.

## Generics

Use generics when they preserve a real relationship between types.

Avoid generic parameters that exist only to make an API appear flexible or that are immediately widened to another type.

Prefer constraints that express requirements:

```ts
function getId<T extends { id: string }>(value: T): string {
  return value.id;
}
```

Do not reach for advanced conditional, mapped, or recursive types when a straightforward type is easier to understand and maintain.

## Collections and iteration

Prefer APIs that preserve element types throughout a transformation.

Avoid introducing untyped intermediate arrays, objects, or callbacks.

Use `Map` and `Set` when their semantics are clearer than object-based lookup or arrays.

Avoid mutating shared objects or arrays when mutation creates unclear ownership or makes reasoning about state difficult. Do not impose immutability mechanically where local mutation is clearly simpler and safe.

## Async code

Preserve types across async boundaries.

Make rejected operations explicit and handle failure states where they matter.

Avoid fire-and-forget promises unless the lifetime and error behavior are intentional.

Do not use non-null assertions or assertions to paper over values that are not guaranteed to exist after an asynchronous operation.

When concurrency matters, model the state and ownership explicitly rather than relying on timing assumptions.

## Runtime boundaries

Separate compile-time types from runtime validation.

TypeScript types disappear at runtime. A type annotation does not validate external data.

For untrusted or external data, validate once at the boundary and convert it into a trusted internal type. Do not repeatedly cast the same untrusted value throughout the codebase.

Good boundary candidates include:

- HTTP/API responses
- request payloads
- JSON parsing
- environment variables
- database results when the driver cannot guarantee the shape
- message/event payloads
- browser storage
- filesystem/configuration input
- third-party SDKs with incomplete types

## Common escape-hatch patterns to reject

Do not solve type errors with:

```ts
as any
```

```ts
as unknown as SomeType
```

```ts
value!;
```

```ts
// @ts-ignore
```

```ts
// @ts-expect-error
```

The last form may be appropriate when deliberately testing or documenting a known compiler error, but it must not be used to make production code compile when the underlying type problem can be fixed properly.

Do not weaken compiler settings or suppress diagnostics to accommodate a local implementation problem.

When a type error exposes a real mismatch, fix the mismatch rather than hiding it.

## Naming and readability

Choose names that encode the semantic role of a value rather than its implementation type.

Prefer:

```ts
const timeoutMs = 5_000;
```

over:

```ts
const timeout = 5_000;
```

when units or meaning could otherwise be ambiguous.

Use type aliases and helper types when they give a domain concept a useful name.

Do not create aliases solely to rename primitive types without adding meaning.

## Enums and literal types

Do not use enums by default.

Prefer string or numeric literal unions when they provide the desired semantics:

```ts
type Environment = "development" | "staging" | "production";
```

Use an enum when its runtime representation or project conventions provide a concrete benefit.

Prefer `as const` objects when you need a runtime value and a derived literal type:

```ts
const ENVIRONMENTS = ["development", "staging", "production"] as const;
type Environment = (typeof ENVIRONMENTS)[number];
```

`as const` is appropriate when it intentionally creates readonly literal values; it is not a general replacement for sound typing.

## Comments and documentation

Prefer code whose types and structure explain themselves.

Use comments to explain non-obvious invariants, external constraints, or why a seemingly unusual implementation is required.

Do not add comments that merely restate the TypeScript syntax.

When an assertion or other escape hatch is genuinely necessary, a concise comment should explain the runtime invariant that makes it safe when that reasoning would otherwise be lost.

## Project conventions take precedence

Before introducing a convention that may conflict with the repository, inspect the project's existing configuration, lint rules, TypeScript version, and local instructions.

Follow explicit project requirements where they conflict with these defaults.

Do not introduce a new library, validation framework, or type-level abstraction merely to satisfy this skill. Prefer the repository's existing tools and patterns.

## Final check

Before considering TypeScript work complete, verify:

- No new `any` was introduced.
- No assertion is being used where narrowing or better modeling can establish the type.
- No non-null assertion is being used to suppress a real uncertainty.
- External data is validated before being treated as trusted.
- Important states are represented explicitly.
- New APIs have deliberate contracts.
- Types remain precise through transformations and async boundaries.
- Type errors were solved rather than suppressed.
