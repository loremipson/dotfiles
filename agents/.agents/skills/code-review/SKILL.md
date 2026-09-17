---
name: code-review
description: Perform high-signal code reviews of diffs, pull requests, and proposed changes. Use when reviewing code for correctness, regressions, security, performance, testing gaps, maintainability, API/design issues, and project-convention violations. Inspect surrounding code and repository context as needed, and report only actionable findings with concrete evidence and severity.
---

# Code Review

Review the change as an engineer responsible for operating and maintaining the codebase.

The goal is to find **real, actionable problems introduced or exposed by the change**, not to produce commentary for its own sake.

## Review process

### 1. Understand the change

Start by inspecting:

- The complete diff, not just individual hunks.
- The files and surrounding code affected by the change.
- Relevant callers, consumers, interfaces, schemas, and tests.
- Repository instructions and established conventions.
- Existing implementations of related functionality when useful.

Determine:

- What behavior is changing?
- What assumptions does the change make?
- What inputs, states, and failure modes matter?
- What existing behavior must remain unchanged?
- What is the intended behavior, based on the code, tests, PR description, and surrounding context?

Do not review a change in isolation when repository context can answer an important question.

### 2. Perform independent review passes

Review the change independently from several perspectives before consolidating findings.

#### Correctness and regressions

Look for:

- Incorrect control flow or state transitions.
- Broken edge cases.
- Invalid assumptions about nullability, ordering, concurrency, or lifecycle.
- Incorrect error handling.
- Backwards-incompatible behavior.
- Changes that break existing callers or consumers.
- Race conditions, duplicate work, lost updates, or partial failures.
- Behavior that is correct for the happy path but wrong in realistic failure modes.

Pay particular attention to code that changes:

- Data transformations.
- Persistence.
- Authentication or authorization.
- External API calls.
- Async behavior.
- Caching.
- Retries.
- Transactions.
- Configuration.
- Shared state.

#### Specification and intended behavior

Compare the implementation with the intended behavior.

Use available evidence in this order:

1. Explicit requirements or acceptance criteria.
2. Tests.
3. API/schema/type contracts.
4. Existing implementation and repository conventions.
5. Reasonable inference from surrounding code.

Flag behavior that contradicts the apparent intent even when the code is internally consistent.

#### Security

Look for newly introduced or expanded attack surfaces, including:

- Authentication or authorization bypasses.
- Trusting client-controlled input.
- Injection vulnerabilities.
- Unsafe deserialization or parsing.
- Path traversal.
- SSRF.
- Sensitive data exposure.
- Secret leakage.
- Incorrect permission boundaries.
- Missing validation at security boundaries.
- Unsafe redirects.
- Insecure cryptographic usage.
- Logging of credentials, tokens, personal data, or other sensitive values.

Do not report generic security concerns. Tie each finding to a concrete data flow, permission boundary, or exploitable behavior.

#### Performance and scalability

Look for meaningful performance regressions such as:

- New N+1 queries.
- Unbounded work or memory growth.
- Repeated expensive computation.
- Accidental quadratic behavior.
- Excessive network calls.
- Blocking operations in latency-sensitive paths.
- Missing pagination or limits.
- Large payload amplification.
- Ineffective caching or cache invalidation.
- Work moved onto hot paths without justification.

Consider realistic input sizes and usage patterns. Do not flag micro-optimizations that are unlikely to matter.

#### Tests and observability

Ask:

- What behavior changed?
- Which new failure modes were introduced?
- What should be tested to prove the change works?
- Are existing tests sufficient?
- Is an important regression path untested?
- Does the change require new logging, metrics, tracing, or alerts?

Report missing tests when the untested behavior is important enough that a regression would matter.

Do not demand tests for trivial implementation details.

#### API and design

Look for:

- Confusing or misleading interfaces.
- Incorrect abstractions.
- Broken invariants.
- Poor separation of responsibilities.
- New coupling that will make future changes difficult.
- APIs that make invalid states easy to represent.
- Changes that violate an established architectural boundary.

Favor concrete maintenance or correctness consequences over stylistic preference.

#### Maintainability and code smells

Consider established engineering smells, especially those that increase defect risk:

- Long or overly complex methods.
- Deep nesting.
- Duplicated logic.
- Excessive branching.
- Primitive obsession where it creates real bugs.
- Hidden side effects.
- Excessive coupling.
- Misleading names.
- Comments that contradict the code.
- Abstractions that obscure rather than simplify behavior.

Only report a smell when it has a meaningful practical consequence in this change.

### 3. Validate findings

Before reporting a finding, verify it against the repository whenever possible.

A finding should answer:

> What specifically is wrong, where does it happen, and what concrete consequence does it have?

Avoid findings based only on:

- Personal style preferences.
- Hypothetical scenarios with no plausible path.
- Speculation about code that cannot be reached.
- Generic best practices that do not apply here.

When uncertain, inspect more code before reporting the issue.

### 4. Prioritize findings

Prioritize findings by impact.

Use these severity levels:

- **P0 — Critical:** Severe correctness, security, data-loss, or availability problem that requires immediate attention.
- **P1 — High:** Significant bug, regression, security issue, or production risk that should be fixed before merging.
- **P2 — Medium:** Real issue that should be addressed, but is unlikely to cause severe immediate impact.
- **P3 — Low:** Minor but actionable issue with a concrete benefit to fixing.

Use the lowest severity that accurately represents the problem.

Do not inflate severity to make a finding sound important.

### 5. Consolidate duplicate observations

Several review passes may identify the same underlying problem.

Report it once.

Combine related observations when they describe the same root cause rather than producing multiple comments on the same issue.

## Output format

Report **only actionable findings** by default.

Do not include:

- Generic praise.
- A summary of what the author did correctly.
- A restatement of the diff.
- Broad "consider..." suggestions without a concrete problem.
- A checklist showing every category you reviewed.
- Findings that are purely stylistic.

Order findings from highest severity to lowest.

For each finding, use:

```text
[P1] Short description

File/path/to/file.ts:123

Explain the concrete problem, why it occurs, and the consequence.
Reference the relevant code or behavior precisely.

Suggest a specific fix or direction when it is clear.
```

Keep findings concise, but include enough context that the author can act without reconstructing the entire review.

When useful, include a minimal example or failure scenario.

### No findings

When no actionable problems are found, say:

```text
No actionable findings.
```

Do not manufacture findings merely to provide feedback.

## Review principles

### Prefer evidence over intuition

Read the implementation and surrounding code before making a claim.

### Distinguish defects from preferences

A different implementation may be preferable without the current implementation being wrong. Report defects, meaningful risks, and concrete maintainability problems—not personal preferences.

### Review the whole change

A correct-looking diff can still break callers, contracts, persistence, error handling, or operational behavior elsewhere.

### Treat tests as evidence, not proof

Existing tests increase confidence, but do not assume behavior is correct merely because tests pass.

### Consider failure modes

For external dependencies, asynchronous work, persistence, and distributed systems, pay particular attention to partial failure, retries, timeouts, duplicate execution, and inconsistent state.

### Do not overfit to hypothetical edge cases

An edge case deserves a finding when it is plausible in the actual system and the consequence matters.

### Be decisive when evidence is strong

Do not bury a clear bug in hedging language.

### Avoid speculative accusations

Do not infer intent or blame. Describe the behavior and its concrete consequence.

## Scope discipline

Review code relevant to the change.

It is appropriate to inspect adjacent code, callers, tests, and configuration when needed to establish whether a finding is real.

Do not turn the review into a broad refactor proposal unless the current change introduces a concrete problem.

When a larger architectural issue is worth mentioning but is not actionable for this change, omit it from the default findings.
