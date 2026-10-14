---
name: client-estimate
description: Scope and price client work. Use when estimating a client project, pricing a modernization or rewrite of a legacy codebase, sizing a phased engagement, or drafting a proposal or quote.
---

# Client estimate

Produce an estimate a client can trust and that you can deliver without eating the overrun. An honest wide range beats an optimistic narrow one. Every number traces back to something found in the code or stated by the client.

## 1. Pin the ask

Write down what the client actually needs, in their words, and what decision the estimate feeds: approve a budget, choose between paths, compare vendors. Note who approves the spend and any budget signal they've given.

Done when you can state the ask in two sentences the client would agree with.

## 2. Find out what's really there

If you have the code, run `/ponytail-audit` for the ranked findings, then add the inventory an estimate needs, with counts:

- Stacks and versions, including anything end-of-life.
- Size by surface: pages, routes, components, endpoints, stored procedures, jobs, integrations.
- Data: databases, schemas, who else reads them.
- Tenancy and customization: per-client branches, flags, hardcoded carve-outs.
- Deploy, CI, and source control.
- Security findings, flagged as must-fix regardless of what the client buys.

If you don't have access yet, say so up front, price as an "in the dark" range, and say what access would narrow it. Never present an in-the-dark number as firm.

## 3. Split into phases that each deliver something

Break the work into phases the client could stop after and still have something useful. Put security fixes and quick wins first, since those are often the only piece that gets approved. Keep independent pieces as separate line items so the client can approve one now.

For each architectural fork, like wrap versus decompose, or rewrite versus incremental, present both paths with their own ranges and let the client choose. Don't silently price one.

## 4. Price each phase

Price from the inventory. Use a per-unit rate where units are countable, like days per component by complexity tier. Show the unit, the count, and the rate so the client can follow the math. Then add what typing-time estimates miss:

- rediscovering business logic that lives only in code or stored procedures
- parallel running or cutover for live systems
- verification across every tenant or integration
- client-side delays: access, approvals, environments

Ask the hard question about each phase: is familiarity with the stack being counted as lower cost? Comfort isn't speed. Then reconcile the phases against any number already sent. If they don't fit, say so plainly, with the gap.

## 5. Deliver

- **Internal breakdown.** Inventory, per-phase math, assumptions, risks, and where the range could move. For the user, not the client.
- **Client version.** Problem in their terms, phases with what each delivers, ranges, assumptions, what's excluded, and what would narrow the range. Written through `my-voice`.

Name the riskiest assumption in the estimate in one line at the end.
