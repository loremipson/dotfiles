---
name: dependencies
description: Apply disciplined dependency-management practices when adding, changing, or reviewing project dependencies. Prefer existing project dependencies and platform capabilities, avoid unnecessary packages and overlapping libraries, and evaluate the maintenance, configuration, build, and security costs of new dependencies before introducing them.
---

# Dependencies

Treat every dependency as a long-term maintenance cost.

Add a dependency when it materially improves the solution, reduces meaningful complexity or risk, or provides substantial functionality that would be unreasonable to implement locally.

Do not add dependencies merely because they save a few lines of code.

## Check what already exists

Before adding a dependency, inspect:

1. Existing project dependencies.
2. Existing project utilities and abstractions.
3. The language runtime and platform APIs.
4. Framework-provided functionality.
5. Standard-library functionality.
6. Whether a small local implementation is clearer and safer.

Prefer an existing solution when it is adequate.

Do not introduce another library for a capability the project already has.

## Prefer existing project dependencies

When the repository already uses a library for a given concern, prefer using it rather than introducing a competing library.

For example, if the project already has:

- A date/time library, use it rather than adding another.
- A validation library, use it rather than adding another.
- A query/cache library, use it rather than creating a parallel data-fetching mechanism.
- A utility library, check whether it already provides the required helper.

Avoid overlapping dependencies that solve the same problem.

## Do not add a package for trivial code

A dependency is usually not justified for functionality that is:

- Small.
- Stable.
- Straightforward to implement.
- Rarely used.
- Better expressed directly in the existing codebase.

Prefer:

```ts
const normalized = value.trim().toLowerCase();
```

over adding a dependency for a transformation this simple.

The same principle applies to small helpers, formatting, simple collections, basic parsing, and ordinary control flow.

Do not optimize for fewer lines of code at the expense of adding a new long-term dependency.

## Prefer platform capabilities

Before adding a package, check whether the runtime or platform already provides the capability.

Consider:

- The JavaScript/TypeScript runtime.
- Browser APIs.
- Node.js APIs.
- Framework features.
- Build tooling.
- Existing internal services.

Prefer built-in capabilities when they are sufficiently robust for the requirement.

## Evaluate the real tradeoff

When a dependency is justified, consider:

- What substantial functionality it provides.
- Whether it materially simplifies the implementation.
- Maintenance and ownership.
- Release activity and ecosystem maturity.
- Dependency size when bundle size matters.
- Runtime and build implications.
- Security and supply-chain implications.
- API stability.
- Compatibility with the project's runtime and tooling.
- Whether the dependency introduces its own configuration or concepts.

Do not choose a dependency solely because it is popular.

## Prefer focused dependencies

When adding a dependency, prefer a focused library that solves the actual problem over a large framework or utility suite when the smaller solution is sufficient.

Avoid bringing in a large dependency for one small feature unless the project already relies on it or the additional functionality is genuinely valuable.

## Respect project conventions

Follow the repository's:

- Package manager.
- Workspace/monorepo structure.
- Dependency grouping.
- Versioning conventions.
- Lockfile.
- Runtime compatibility requirements.
- Existing package organization.

Do not switch package managers.

Do not introduce a dependency in an unusual location without understanding the workspace structure.

## Do not silently upgrade unrelated dependencies

When adding a dependency:

- Make the smallest necessary package changes.
- Do not opportunistically upgrade unrelated packages.
- Do not regenerate large sets of lockfile entries unless required.
- Do not change package versions merely because newer versions exist.

Keep the dependency diff easy to review.

## Prefer one dependency over dependency chains

Be cautious of adding a package that itself requires a large dependency tree for a small amount of functionality.

When two solutions are otherwise comparable, prefer the one that introduces less unnecessary dependency complexity.

Do not optimize package count blindly. A well-chosen dependency with meaningful functionality is often preferable to maintaining a fragile local implementation.

## Avoid replacing dependencies unnecessarily

Do not replace an established dependency merely because:

- You personally prefer another library.
- A different library has a nicer API.
- The dependency could theoretically be implemented locally.
- A newer alternative exists.

A replacement should have a concrete reason, such as correctness, security, compatibility, substantial maintenance improvement, or a clear architectural decision.

## Security and supply chain

Treat dependencies as code entering the trusted build.

When introducing a dependency that handles security-sensitive or externally supplied data, pay particular attention to:

- Maintenance status.
- Known vulnerabilities.
- Package provenance.
- Transitive dependency risk.
- Permissions or runtime capabilities.
- Whether the dependency executes code during installation.

Do not perform a security audit of every dependency unless the task requires it, but do not ignore obvious supply-chain concerns when selecting a new package.

## When a dependency is justified

A new dependency is usually reasonable when it provides substantial, non-trivial functionality such as:

- Complex parsing.
- Cryptography implemented by a trusted library.
- Specialized protocol support.
- Mature data structures.
- Significant validation functionality.
- Complex date/time or localization behavior.
- Established integrations.
- A well-supported framework capability the project intentionally adopts.

Even then, prefer consistency with the project's existing stack.

## Decision rule

Before adding a dependency, be able to explain:

> Why does this package provide enough value to justify owning it as part of the project's dependency graph?

If the answer is merely:

> It saves me a few lines,

do not add it.

## Final check

Before considering dependency work complete, verify:

- The capability was not already available in the project.
- An existing dependency could not reasonably solve it.
- The platform/runtime could not reasonably solve it.
- A small local implementation would not be clearer.
- The new dependency materially justifies its maintenance cost.
- It does not unnecessarily overlap with another dependency.
- The project's package-manager and versioning conventions were followed.
- No unrelated dependencies were upgraded or changed.
- Lockfile changes are limited to what is necessary.
