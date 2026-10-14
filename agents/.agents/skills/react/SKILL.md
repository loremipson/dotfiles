---
name: react
description: React conventions for writing, changing, or reviewing components and hooks. Covers when an Effect is allowed, derived state, memoization, state ownership with TanStack Query and Zustand, composable component APIs, and accessibility.
---

# React

Follow React's rendering model. Project patterns, the framework's data loading, and local AGENTS.md win over this file.

## Effects are for external systems only

An Effect synchronizes React with something outside React: the DOM, a browser API, a timer, a subscription, a socket, an imperative widget. Before writing one, name that system. If you can't, the code belongs somewhere else:

| The Effect would... | Put it here instead |
|---|---|
| compute a value from props or state | a `const` during render |
| react to a click, submit, or other user action | the event handler |
| set state that sets more state | one event handler that updates everything together |
| fetch server data | the route loader or TanStack Query |
| run once on app start | module scope or the app entry |
| reset state when a prop changes | a `key` on the component |

Every Effect returns a cleanup that undoes its setup, survives Strict Mode's double run, and lists every dependency. When the dependency list is inconvenient, restructure: move the object inside the Effect, hoist stable logic out of the component, or split the Effect. The Hooks lint rule stays on.

## State

- Store the smallest state that captures intent and derive the rest. Two pieces of state that can disagree are one piece of state.
- Keep state local until two distant parts of the tree need it, then use the project's store (Zustand) over threading props through components that don't use them.
- Server data lives in TanStack Query or the route loader, never in `useState` plus `useEffect`.
- Context carries slow-changing shared dependencies (theme, session, a compound component's internals), not fast-changing values.
- Refs hold values that must persist without causing a render. Anything that affects output is state.

## Memoization needs a reason

Add `useMemo`, `useCallback`, or `memo` only for a measured expensive computation or an identity that a memoized consumer depends on. Check the dependencies are themselves stable, or the memo recomputes every render. Everything else renders plainly. If the project runs the React Compiler, add no manual memoization at all.

## Component APIs

- Type props with a named `Props` type on the parameter. Use plain functions, not `React.FC`. Type `children` only on components that render it.
- Build compound components (`<Card>`, `<Card.Header>`, `<Card.Body>`) over one component with a pile of boolean flags. Export the composable parts plus a preassembled default for the common case.
- Follow the project's primitive layer (Base UI and shadcn) for interactive widgets. Those primitives already own focus, keyboard handling, and ARIA.
- Use stable, data-derived keys. An index is a key only for a list that never reorders.

## Accessibility

Accessibility is correctness. Use the semantic element: `<button>` for actions, `<a>` for navigation, `<label>` bound to every input. Every icon-only control gets an accessible name. Every interaction works from the keyboard, overlays close on Escape and return focus, and errors are tied to their field with `aria-describedby`. Reach for ARIA only where no native element expresses the behavior.
