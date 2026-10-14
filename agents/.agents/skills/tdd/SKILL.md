---
name: tdd
description: Test-first development with red-green cycles. Use when asked to build or fix something test-first, write tests before code, do red-green-refactor, or add integration tests.
---

# TDD

Red, then green, one vertical slice at a time. Tests verify behavior through the public interface. Code inside can change completely and the tests shouldn't notice.

When this skill is active, it decides where tests go. That overrides ponytail's "one small test" default.

## Agree on the seams first

A **seam** is the public boundary you observe behavior through: a server function, a route, a module's exported API, a database query helper. Before writing any test, list the seams you plan to test, each with one line on what it catches and what it misses. Confirm them with the user. Prefer the highest seam that's still fast. One good seam beats five shallow ones.

Follow the repo's existing split between unit and integration tests. Read its testing doc first if it has one, like `docs/agents/testing.md`. Anything touching the database runs against a real test database, not a mocked client.

## The loop

1. Write one failing test for the next behavior at an agreed seam. Run it and watch it fail for the right reason.
2. Write only enough code to pass it.
3. Run the suite. Green.
4. Repeat with the next behavior. Each test is a tracer bullet that responds to what the last cycle taught you.

Writing all the tests first, then all the code, tests the shape you imagined rather than the behavior you built. Refactoring happens after the loop, during review.

## What makes a test worth keeping

- It calls the code the way a user or caller does and asserts the exact result they'd see, against a literal expected value.
- It survives a refactor that doesn't change behavior.
- Its name states a capability: "member can delete own comment", not "calls deleteComment".
- Mocks stand in only for what you can't run locally: third-party APIs, email, payment. The database, the router, and your own modules run for real.

Rewrite or delete a test that:

- would still pass if every imported function returned `undefined`
- recomputes the expected value the same way the code does, like `expect(add(a, b)).toBe(a + b)`
- verifies through a side channel, like querying the table directly instead of reading back through the interface
- breaks when you rename a private function
