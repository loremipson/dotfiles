---
name: comments
description: Code comment rules for writing or reviewing source comments. Default to none, keep the rare one to a single line about a why the code can't show, and treat a long comment as a sign the code needs reshaping.
---

# Comments

Default to no comments. Names, types, and structure carry the meaning.

## A comment earns its place when deleting it invites a breaking "cleanup"

Write one line that names a constraint the code can't show:

- an external system's behavior: `// Must stay sequential: the upstream API rejects concurrent writes.`
- a browser or library quirk: `// Safari needs this focus call before the picker opens.`
- an ordering invariant: `// Check the signature before normalizing; it covers the raw payload.`
- the proven fact behind an unavoidable cast or suppression: `// Zod parsed this above; the SDK types don't expose the shape.`
- a deliberate shortcut, in ponytail's format, so `/ponytail-debt` can list it: `// shortcut: in-memory cache, move to Redis when we run more than one process.`

Public API doc comments and license headers stay too.

## When a comment wants to grow

Reshape the code instead:

- the name doesn't say what it does: rename it
- a block needs a paragraph to justify itself: extract a named function
- comments narrate steps: make each step a named call
- a magic value needs explaining: give it a named constant

## What goes elsewhere

History, ticket numbers, who asked for it, and "added for the billing flow" belong in the commit message. A TODO for work this task needs means doing the work now. Deferred work goes in a `shortcut:` comment or the issue list.

## Reviewing

Delete comments that narrate what the code plainly does. When a comment is propping up a confusing name or structure, recommend the code change. Keep comments that state a real constraint.
