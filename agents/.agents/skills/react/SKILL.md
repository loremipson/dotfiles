---
name: react
description: Apply opinionated React conventions when writing, modifying, refactoring, or reviewing React code. Prefer pure rendering, composable components, accessible UI, derived values over redundant state, event handlers over Effects for event-driven logic, and Effects only for synchronizing with external systems. Use memoization deliberately, preserve stable dependencies, and prefer established client/server state-management patterns such as Zustand and TanStack Query when available.
---

# React

Write React that follows React's rendering model rather than fighting it.

Prefer simple data flow, pure rendering, composable components, explicit ownership of state, accessible HTML, and event-driven behavior. Treat Effects, memoization, context, and global state as tools for specific purposes rather than defaults.

## Core principles

- Keep components pure during render.
- Prefer small, composable components over large mode-heavy components.
- Derive values from props and state rather than storing redundant state.
- Put event-driven work in event handlers.
- Use Effects only to synchronize React with something outside of React.
- Keep state as local as practical.
- Avoid prop drilling through components that do not actually own or use the data.
- Prefer the project's established client-state and server-state solutions when available.
- Prefer accessible, semantic HTML over custom implementations.
- Optimize measured problems rather than memoizing everything.
- Keep dependencies stable when stability matters.
- Make component APIs simple and predictable.

## Component definitions and props

### Type component props directly

Define a named props type and annotate the function parameter directly.

Prefer:

```tsx
type ButtonProps = {
  variant: "primary" | "secondary";
  onClick: () => void;
};

function Button(props: ButtonProps) {
  // ...
}
```

or, when destructuring is clearer:

```tsx
type ButtonProps = {
  variant: "primary" | "secondary";
  onClick: () => void;
};

function Button({ variant, onClick }: ButtonProps) {
  // ...
}
```

Do not default to `React.FC` or `React.FunctionComponent`.

Prefer ordinary function declarations or function expressions with an explicit props type.

`React.FC` is unnecessary for normal components and can complicate generics and component APIs.

### Type `children` explicitly

Do not assume every component accepts children.

For components that genuinely accept children, type them explicitly:

```tsx
type PanelProps = {
  children: ReactNode;
  title: string;
};

function Panel({ children, title }: PanelProps) {
  // ...
}
```

Do not add `children` merely because a component happens to use a props type.

Prefer the narrowest component API that accurately describes what the component accepts.

## Composition

Prefer composable components and explicit composition over giant configurable components.

Prefer:

```tsx
<Card>
  <CardHeader />
  <CardBody />
  <CardFooter />
</Card>
```

over a single component accumulating a large number of boolean and mode props.

Use `children`, explicit slots, or component props when they make composition clearer.

Avoid APIs with many flags such as:

```tsx
<Component compact showHeader showFooter inline loading editable />
```

when separate composable components or variants would produce a clearer API.

Do not split components mechanically. Extract components when doing so creates a meaningful boundary, improves reuse, isolates state/behavior, or makes the parent easier to understand.

## `useEffect`

### Use Effects only for external synchronization

An Effect should exist because rendering needs to synchronize with something **outside of React**.

Valid examples include:

- DOM APIs.
- Browser APIs.
- Timers.
- Event subscriptions.
- WebSocket or other persistent connections.
- Third-party widgets or imperative libraries.
- External stores or systems.
- Other imperative APIs whose lifecycle is tied to React state or props.

If there is no external system involved, question whether the Effect should exist at all.

React describes Effects as an escape hatch for synchronizing with external systems.

### Never use an Effect to derive state

Do not use:

```tsx
const [fullName, setFullName] = useState("");

useEffect(() => {
  setFullName(`${firstName} ${lastName}`);
}, [firstName, lastName]);
```

Prefer:

```tsx
const fullName = `${firstName} ${lastName}`;
```

Do not create state solely because another value can be calculated from existing props or state.

Avoid:

- Derived state in Effects.
- Effects that only transform data.
- Effects that synchronize one piece of React state from another.
- Effects that immediately call setters to produce another render.

These patterns create unnecessary render passes and can introduce stale or inconsistent state.

### Never use an Effect for event-specific behavior

If something happens because the user performed an action, put it in the event handler or the function it calls.

Prefer:

```tsx
function handleBuy() {
  addToCart(product);
  showNotification(product);
}
```

over:

```tsx
useEffect(() => {
  if (productAdded) {
    showNotification(product);
  }
}, [productAdded]);
```

Ask:

> Is this happening because the component rendered, or because the user did something?

If the answer is the latter, prefer an event handler.

### Do not use Effects as application state orchestration

Avoid chains such as:

```text
state A
  -> Effect
  -> state B
  -> Effect
  -> state C
```

When multiple pieces of React state need to change because of one interaction, update them together in the event handler or move the shared state to the appropriate owner.

Effects should not be the primary mechanism for orchestrating React application state.

### Effects need symmetric cleanup

When an Effect establishes an external resource, clean it up appropriately.

```tsx
useEffect(() => {
  const unsubscribe = store.subscribe(handleChange);

  return unsubscribe;
}, [store]);
```

```tsx
useEffect(() => {
  const connection = createConnection(roomId);
  connection.connect();

  return () => connection.disconnect();
}, [roomId]);
```

Cleanup should undo what setup did.

Do not suppress Strict Mode behavior merely because an Effect is not resilient to setup/cleanup cycles.

### Be suspicious of empty-dependency Effects

An Effect with `[]` is not automatically "run once."

Ask why the logic belongs to the component lifecycle at all.

Avoid using `[]` for:

- Application initialization.
- Module initialization.
- Event-driven behavior.
- Derived computation.
- Other work that does not actually require component synchronization.

When an Effect genuinely represents synchronization with an external system for the lifetime of a component, `[]` may be appropriate.

### Keep dependencies correct

Do not intentionally omit dependencies to control when an Effect runs.

Do not disable Hooks lint rules merely to silence a dependency warning.

Instead:

- Restructure the Effect.
- Move object creation inside the Effect when appropriate.
- Move stable logic outside the component.
- Separate reactive from non-reactive logic.
- Split unrelated Effects.
- Use memoization only when it solves a real identity problem.

Fix dependency problems instead of hiding them.

## Derived data

Do not put derivable values in state.

Bad:

```tsx
const [filteredUsers, setFilteredUsers] = useState<User[]>([]);

useEffect(() => {
  setFilteredUsers(users.filter(matchesFilter));
}, [users, filter]);
```

Good:

```tsx
const filteredUsers = users.filter(matchesFilter);
```

If the calculation is expensive enough to matter, consider `useMemo` only when there is a concrete reason to cache it.

Prefer the simplest correct implementation first.

## `useMemo`

### `useMemo` must have a real purpose

Use `useMemo` for one of these reasons:

1. The calculation is meaningfully expensive and caching avoids repeating that work.
2. Stable referential identity is required for another optimization or API contract.

Do not add `useMemo` merely because a value is derived.

Bad:

```tsx
const fullName = useMemo(
  () => `${firstName} ${lastName}`,
  [firstName, lastName],
);
```

unless there is an unusual, demonstrated reason for doing so.

### Verify the calculation is worth memoizing

Before using `useMemo`, ask:

- Is the computation actually expensive?
- Does it run often enough for caching to matter?
- Is there a measured performance issue?
- Does referential stability matter to a memoized child or another dependency?

For cheap calculations, ordinary rendering is preferable.

### Ensure dependencies are stable

Do not defeat `useMemo` by depending on an object or array recreated every render.

Bad:

```tsx
const options = {
  sort,
  filter,
};

const visibleItems = useMemo(
  () => getVisibleItems(items, options),
  [items, options],
);
```

`options` is recreated on every render, so the memo invalidates every render.

Prefer:

```tsx
const visibleItems = useMemo(
  () => getVisibleItems(items, { sort, filter }),
  [items, sort, filter],
);
```

The same principle applies to functions:

```tsx
const getValue = () => computeValue(config);

const value = useMemo(() => expensiveOperation(getValue), [getValue]);
```

The memo is ineffective if `getValue` is recreated every render.

Do not create a chain of `useMemo` calls solely to make other `useMemo` calls work.

### Preserve dependency correctness

Do not omit dependencies from `useMemo` to force caching.

An incomplete dependency list is a correctness bug disguised as an optimization.

## `useCallback`

Treat `useCallback` similarly to `useMemo`.

Use it when function identity actually matters, such as:

- A memoized child depends on callback identity.
- A callback participates in another memoization strategy.
- A stable callback identity is required by an API or hook.

Do not wrap every callback in `useCallback` by default.

Bad:

```tsx
const handleClick = useCallback(() => {
  setCount(count + 1);
}, [count]);
```

when the callback is not passed somewhere that benefits from stable identity.

Fix unstable dependency relationships instead of building layers of memoization around them.

## `React.memo`

Do not wrap components in `memo` by default.

Memoization is useful when:

- The component re-renders frequently.
- Its props are often referentially equal.
- Rendering it is meaningfully expensive.
- Profiling or clear architecture indicates that avoiding the render is worthwhile.

`memo` is ineffective when props are always changing, including object and function props recreated each render.

Do not use `memo` to hide a correctness problem.

## State

### Prefer the simplest appropriate ownership

State should live at the narrowest reasonable scope.

Use local state when the state genuinely belongs to one component or a small local subtree.

Examples:

- Form inputs.
- Hover state.
- Open/closed UI state.
- Temporary selections.
- Local interaction state.

Do not lift state merely because React permits it.

### Avoid prop drilling through unrelated components

Passing data through one or two natural component boundaries is often fine.

When state needs to be shared across unrelated parts of a component tree, do not create long chains of props solely to transport it.

Prefer the project's established shared client-state solution.

When **Zustand or a comparable lightweight client-state library is already available and appropriate**, prefer it over prop drilling through unrelated components.

Do not introduce Zustand merely because this skill prefers it. Respect the project's existing state architecture.

### Prefer established server-state solutions

Treat server state differently from local UI state.

When **TanStack Query / React Query or a comparable server-state library is already available**, prefer it for:

- Fetching server data.
- Caching.
- Synchronizing stale data.
- Loading and error state.
- Mutations.
- Invalidating or refreshing remote data.

Do not manually reproduce server-state machinery with `useEffect`, `useState`, and ad hoc caches when an established project solution already exists.

Do not introduce a server-state library solely to satisfy this preference when the project already has another established solution.

### Do not duplicate state

If a value can be derived from existing state or props, do not store another copy.

Prefer storing the smallest piece of state that represents the user's actual intent.

Avoid multiple independent state variables that represent one underlying fact and can drift into contradictory combinations.

## Context

Do not put rapidly-changing or highly local state into broad context merely for convenience.

Remember that changing context values can cause consumers to re-render.

Prefer:

- Local state.
- Composition.
- Explicit props.
- The project's established shared state solution.

Use context when it expresses a meaningful shared dependency or application concern, not merely to avoid passing a prop one level.

## Rendering

### Keep render pure

Rendering should calculate what the UI should look like.

Do not:

- Mutate external state during render.
- Perform network requests during render.
- Register event listeners during render.
- Start timers during render.
- Mutate global objects as part of rendering.
- Depend on render executing exactly once.

Do not use Effects or memoization to mask impure rendering. Fix the underlying problem.

### Prefer declarative rendering

Prefer representing UI state through props and state rather than imperative DOM manipulation.

When imperative APIs are genuinely necessary, isolate them to the appropriate Effect/ref boundary.

## Event handlers

Put interaction-specific behavior in event handlers.

Examples:

- Submitting forms.
- Sending commands.
- Mutating application state.
- Showing notifications after an action.
- Navigating after a click.
- Triggering analytics for a user action.
- Uploading a file because the user selected it.

Share logic between handlers by extracting ordinary functions rather than converting it into an Effect.

## Data fetching

Do not automatically reach for `useEffect` for data fetching.

First inspect the application's existing data-fetching architecture.

Prefer, in order of relevance to the project:

- Framework-provided data loading.
- Existing query/cache libraries.
- Route loaders.
- Server-side loading/server components where applicable.
- Repository-standard data hooks.

When an Effect is genuinely appropriate for synchronization with an external resource, handle:

- Loading state.
- Errors.
- Cancellation or stale responses.
- Cleanup.
- Race conditions.

Do not create a second data-fetching architecture inside one component.

## Accessibility

Accessibility is a first-class correctness concern.

Prefer semantic HTML and native browser behavior.

Examples:

- Use `<button>` for actions.
- Use `<a>` for navigation.
- Use proper `<label>` elements for form controls.
- Use headings with meaningful hierarchy.
- Use lists for lists.
- Use native form controls when appropriate.

Do not use clickable `<div>` or `<span>` elements when a semantic interactive element exists.

### Keyboard accessibility

Interactive functionality must be usable with a keyboard.

Do not create mouse-only interactions.

When building custom interactive components, handle appropriate:

- Keyboard interaction.
- Focus behavior.
- Focus restoration.
- Disabled states.
- Escape behavior for dismissible overlays.
- Tab/focus management for dialogs and popovers.

Prefer accessible native elements and established component primitives over recreating interaction semantics manually.

### Accessible names and labels

Every interactive control should have an accessible name.

Forms should have associated labels.

Icon-only controls should have an accessible label or equivalent semantic name.

Do not rely on placeholder text as the sole label for a form field.

### ARIA

Use semantic HTML before ARIA.

Use ARIA to supplement semantics when native HTML cannot express the required behavior.

Do not add ARIA roles and attributes merely to make an implementation appear accessible.

If a native element provides the required semantics and behavior, prefer it.

### Images and media

Provide appropriate alternative text for meaningful images.

Use empty alternative text for purely decorative images when appropriate.

Do not replace visible text with inaccessible images when equivalent semantic text is available.

### Forms and errors

Make form fields and validation errors understandable to assistive technology.

Associate errors with the relevant controls.

Do not communicate important state solely through color.

## Component composition and APIs

Prefer explicit, composable APIs over large configuration surfaces.

Avoid components that accumulate many unrelated responsibilities.

Prefer variants when visual differences share the same semantic component.

Avoid boolean-prop explosions when different components or a better domain model would make states clearer.

Keep components focused without artificially splitting every piece of JSX into a separate file.

## Keys

Use stable, semantic keys for lists.

Prefer:

```tsx
users.map((user) => <UserRow key={user.id} user={user} />);
```

Avoid array indexes as keys when list ordering, insertion, deletion, or filtering can change.

Never generate a new key on every render merely to force remounting.

Use changing `key` intentionally when resetting a component's state/tree is the desired behavior.

## Refs

Use refs for values that need to persist across renders without causing a render when they change.

Do not use refs as an escape hatch for state that affects rendering.

Do not store derived values in refs merely to avoid dependency warnings.

When a ref is used to interact with an external imperative system, keep that interaction isolated and explicit.

## Custom Hooks

Create a custom Hook when it extracts a coherent reusable stateful behavior.

A custom Hook should have a clear contract and a meaningful abstraction boundary.

Keep external synchronization inside the Hook when the Hook owns that synchronization.

Do not create custom Hooks merely to hide problematic Effects.

## Suspense, transitions, and concurrent rendering

Do not assume rendering is synchronous or that a component renders exactly once.

Avoid code that depends on incidental render timing.

Do not use Effects as a substitute for understanding asynchronous UI state.

Use the repository's established patterns for:

- Suspense.
- Transitions.
- Optimistic updates.
- Deferred values.
- Streaming.

Prefer declarative state transitions over manually coordinating asynchronous rendering with Effects.

## Performance

Do not optimize by intuition alone.

First investigate structural causes:

- Unnecessary state updates.
- Effect chains.
- Broad context updates.
- Expensive calculations during frequent renders.
- Unstable object/function identity.
- Large subtrees re-rendering unnecessarily.
- Unbounded lists.
- Excessive network activity.

Use profiling or concrete evidence when available.

Do not add `memo`, `useMemo`, or `useCallback` everywhere.

## Project conventions take precedence

This is a global preference set, not a mandate to replace a project's architecture.

Before making architectural choices, inspect:

- Existing state-management libraries.
- Existing data-fetching libraries.
- Routing/framework conventions.
- Component libraries and accessibility primitives.
- Existing custom Hooks.
- Lint rules and repository instructions.
- Established component patterns.

Prefer the project's existing solution when it serves the same purpose well.

When introducing a new solution, prefer solutions already present in the project or an established equivalent rather than adding unnecessary dependencies.

## Anti-patterns to reject

Do not introduce:

```tsx
useEffect(() => {
  setDerivedValue(computeValue(...))
}, [...])
```

when the value can be derived during render.

Do not introduce:

```tsx
useEffect(() => {
  if (someEventState) {
    handleEvent();
  }
}, [someEventState]);
```

when the logic belongs in an event handler.

Do not introduce:

```tsx
const value = useMemo(() => cheapCalculation(), [...])
```

without a meaningful optimization or identity requirement.

Do not introduce:

```tsx
const dependency = {};

const value = useMemo(() => expensiveWork(dependency), [dependency]);
```

when `dependency` is recreated every render.

Do not introduce:

```tsx
const callback = useCallback(() => doSomething(), []);
```

merely because callbacks "should" be memoized.

Do not introduce:

```tsx
<Component key={Math.random()} />
```

to force a remount.

Do not introduce:

```tsx
<div onClick={handleClick}>...</div>
```

when a semantic interactive element such as `<button>` is appropriate.

Do not introduce long prop chains through unrelated components merely to avoid using the project's established shared state solution.

Do not manually reproduce server-state caching and synchronization with Effects and component state when the project already uses TanStack Query or an equivalent.

## Final check

Before considering React work complete, verify:

- Components are pure during render.
- Components are composable and have focused APIs.
- Props are typed directly with a named `Props` type.
- `React.FC` / `React.FunctionComponent` is not being used without a compelling project-specific reason.
- `children` is explicitly typed only when the component accepts it.
- Derived values are not stored as redundant state.
- Event-driven behavior is handled by event handlers.
- Every Effect synchronizes with a real external system.
- Effects have correct dependencies and appropriate cleanup.
- No Effect exists merely to derive or synchronize React state.
- `useMemo` has a concrete reason to exist.
- `useMemo` dependencies are stable enough for memoization to actually work.
- `useCallback` has a concrete identity-related reason to exist.
- `React.memo` is justified by component and prop behavior.
- State is local when appropriate and shared state follows the project's established architecture.
- Prefer Zustand or an equivalent client-state solution when available rather than prop drilling through unrelated layers.
- Prefer TanStack Query / React Query or an equivalent server-state solution when available.
- Rendering remains declarative and pure.
- Interactive elements are keyboard accessible.
- Semantic HTML is preferred over custom ARIA implementations.
- Controls have accessible names and forms have accessible labels/errors.
- List keys are stable and semantic.
- No memoization or Effect is being used to mask a correctness problem.
- Existing project/framework conventions are being followed.
