---
name: typescript
description: TypeScript conventions for writing, changing, or reviewing any .ts or .tsx file. Covers type safety at boundaries, modeling state with unions and branded types, and escape hatches to refuse.
---

# TypeScript

Make the compiler reject impossible states. When a type error appears, fix the mismatch it exposes. Project config, lint rules, and local AGENTS.md win over this file.

## Model the domain

- Model variants as a discriminated union with a literal discriminant. `{ kind: "open" } | { kind: "done"; at: Date }` beats `{ completed: boolean; completedAt?: Date }`. If you could write a comment explaining which field combinations are valid, it wants to be a union.
- Brand IDs and other semantic primitives so they can't be swapped: `type UserId = string & { readonly __brand: "UserId" }`. Create them once, at the boundary.
- Build the shape so the illegal value can't exist: `[T, ...T[]]` for non-empty, start plus duration for a range.
- Strengthen a type only where the loose one forces a `!`, a cast, or a "should never happen" throw. Otherwise keep the plain type.
- Derive types from the source that owns the shape: Drizzle tables (`$inferSelect`), Zod schemas (`z.infer`), `Parameters`, `ReturnType`, `Awaited`. Declare a parallel interface only when nothing owns it.
- Literal unions or `as const` arrays over `enum`.
- End every switch on a union with `const _exhaustive: never = value` so a new variant fails the build.

## Boundaries

External data is `unknown` until parsed: request bodies, JSON, env vars, `localStorage`, SDK responses, raw SQL results. Parse it once with the repo's schema library into a named domain type, then trust that type everywhere inside. Validation lives at the edge, business logic stays pure.

## Escape hatches

Each of these hides a real uncertainty. Establish the fact in code instead.

| Instead of | Write |
|---|---|
| `any` | `unknown`, then narrow |
| `value as User` | a parse function or a type guard that checks the claim |
| `value!` | an early return or a type that encodes presence |
| `as unknown as T` | a fix at the boundary where the type went wrong |
| `@ts-ignore` / `@ts-expect-error` in shipped code | the real type fix |

`satisfies` is the right tool for checking a shape while keeping literal types. Narrowing order: discriminant switch, then `in`, then `typeof`/`instanceof`, then a guard named `isX`. A cast survives only at a genuine boundary where the runtime fact is proven elsewhere, with a one-line comment naming that fact.

## Errors and async

- Catch as `unknown` and narrow before reading `.message`. Keep the original error as `cause` when wrapping.
- Every promise is awaited, returned, or explicitly `void`-ed with its failure handled.

## Readability

- Let inference handle locals. Annotate exported functions and module boundaries where the return type is the contract.
- Name units into values: `timeoutMs`, `priceCents`.
- Pass an options object when two arguments share a type or a boolean would switch modes.
- Generics must relate two types. A generic used once is a parameter.
