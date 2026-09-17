---
name: simplicity
description: Prefer simple, direct, maintainable solutions when writing, modifying, refactoring, or reviewing code. Avoid unnecessary abstraction, indirection, configurability, premature generalization, and opportunistic refactoring. Use existing project patterns when they solve the problem well, and optimize for clarity without sacrificing correctness or extensibility that is actually required.
---

# Simplicity

Prefer the simplest implementation that fully satisfies the requirement.

"Simple" means easy to understand, reason about, test, and maintain. It does not necessarily mean shortest.

## Prefer existing solutions

Before inventing something new, inspect the codebase.

Prefer:

- Existing project patterns.
- Existing abstractions that already fit the problem.
- Existing utilities and helpers.
- Existing dependencies and infrastructure.
- The repository's established architectural boundaries.

Do not replace an established solution merely because another approach seems cleaner in isolation.

Global preferences should guide new decisions. Existing project architecture takes precedence unless there is a concrete problem with it.

## Avoid premature abstraction

Do not introduce an abstraction unless it solves a concrete problem.

Before creating a helper, wrapper, factory, framework, generic utility, service layer, or configuration system, identify the actual complexity it removes.

Do not generalize solely because something might be reused later.

Prefer:

```ts
function formatUserName(user: User) {
  return `${user.firstName} ${user.lastName}`;
}
```

over creating a generalized formatting framework because another caller might eventually need one.

When a second or third real use case appears, generalize based on the actual similarities.

## Avoid hypothetical flexibility

Do not add:

- Configuration options nobody currently needs.
- Extension points nobody currently uses.
- Generic type parameters without a real relationship to multiple use cases.
- Plugin systems for one implementation.
- Feature flags for behavior that does not need independent rollout.
- Multiple strategies where there is only one meaningful strategy.

Solve today's problem well.

Do not build infrastructure for imagined future requirements.

## Prefer direct code

Prefer straightforward code over layers of indirection.

When a function call, property access, or expression already communicates intent, do not wrap it in another abstraction solely to rename it or hide one line.

Avoid abstractions whose main effect is moving code somewhere else without creating a meaningful boundary.

Prefer explicit control flow when it is clearer than clever functional or metaprogramming techniques.

## Small changes

Keep changes narrowly scoped.

When implementing a feature or fixing a bug:

- Change what is necessary.
- Avoid unrelated refactors.
- Avoid opportunistic cleanup.
- Avoid renaming unrelated code.
- Avoid reformatting unrelated files.
- Avoid changing architecture unless the task actually requires it.

A cleaner-looking diff is not automatically a better diff.

When a nearby issue materially blocks the requested change, address it. Otherwise leave it alone.

## Complexity budget

Every abstraction, dependency, configuration layer, state layer, and indirection adds maintenance cost.

Before adding complexity, identify what it buys.

Prefer complexity that pays for itself through:

- Correctness.
- Reuse that already exists.
- Clear architectural boundaries.
- Significant performance improvements.
- Better testability.
- Required extensibility.

Do not add complexity merely because it is technically elegant.

## Avoid cleverness

Prefer code that another engineer can understand quickly.

Avoid:

- Dense one-liners that hide important behavior.
- Clever type-level machinery when a simpler type works.
- Metaprogramming for ordinary application logic.
- Implicit behavior that depends on subtle language features.
- Abstractions that require reading several files to understand a simple operation.

Use sophisticated techniques when they materially simplify the problem or are required by the domain.

## Simple does not mean crude

Do not simplify by removing information or correctness.

Do not:

- Collapse meaningful domain concepts into primitives.
- Remove validation merely to reduce code.
- Ignore error cases.
- Flatten legitimate architectural boundaries.
- Duplicate complex logic to avoid an appropriate abstraction.
- Trade maintainability for fewer lines.

A 30-line explicit implementation can be simpler than a 10-line abstraction that requires understanding five layers to follow.

## Refactoring threshold

Do not refactor merely because code could theoretically be improved.

Refactor when:

- The current structure creates a concrete bug or maintenance problem.
- The requested change would otherwise make the design materially worse.
- The same duplication or complexity is now appearing in multiple real places.
- A clearer boundary directly improves correctness or testability.

Otherwise, make the smallest safe change.

## Ask before adding abstraction

Before introducing a new abstraction, ask:

1. What concrete problem exists today?
2. Why can't the existing code solve it?
3. Does the abstraction make the current use case clearer?
4. Is the complexity it adds smaller than the complexity it removes?
5. Am I solving a present problem or a hypothetical future one?

If the answers do not justify it, keep the implementation simpler.

## Final check

Before considering code complete, ask:

- Can this be simpler without making it less clear or correct?
- Did I introduce an abstraction that does not have a concrete need?
- Did I build for hypothetical reuse?
- Did I add configurability that nobody needs?
- Did I touch unrelated code?
- Am I following an existing project pattern that already solves this?
- Would another engineer understand this without needing to trace unnecessary layers?

Prefer the smallest clear design that solves the real problem.

````

### `dependencies`

```markdown
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
const normalized = value.trim().toLowerCase()
````

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
