<!--
Umicom Applications
File: docs/architecture/ADR-0009-application-surface-runtime.md

PURPOSE:
Record why live panel state and frontend hosting belong in Umicom Framework and
how product applications contribute behavior without duplicating the runtime.

AUTHOR AND ORGANISATION:
Sammy Hegab
Umicom Foundation

LICENCE:
MIT
-->

# ADR-0009: Framework owns the application surface runtime

Status: Accepted

## The problem

A workspace recipe can describe which panels an application needs, but a real
application must also remember which panels are visible, which one has focus,
whether a panel is empty or busy, and how a frontend should mount it.

If every application implements those rules itself, Studio, Trader and future
products will slowly behave differently. The same reusable chart or editor
would need several panel managers and several persistence formats.

## Decision

Umicom Framework owns the toolkit-neutral application surface runtime.

The runtime projects a Framework workspace recipe into a live session. It owns
portable panel state, lifecycle dispatch, frontend-host callbacks, checkpoints
and a diagnostic journal. A headless host is supplied for tests and command-line
inspection.

Applications remain thin:

- an application selects a Framework recipe;
- an application controller connects a component to product wording, data and
  commands;
- reusable data engines, safeguards and UI behavior stay in Framework;
- a frontend host renders the portable state in GTK4, web, mobile or another
  supported toolkit.

Studio and Trader adopt the runtime additively. Their established workbenches
and GTK4 paths remain available while native host integration progresses.

## Why this helps

The same component identity now travels through the whole construction path:

```text
Framework component
        ↓
workspace recipe
        ↓
presentation specification
        ↓
live surface session
        ↓
product controller + frontend host
```

This makes new applications more like building with Lego: select known blocks,
arrange them in a recipe, connect the few product-specific behaviors, and let
Framework handle the common mechanics.

## Safety boundaries

The presentation runtime must not own database connections, broker sessions,
native widgets or trading permission. It stores portable UI state only.

In Trader, preparing an order through the application surface is a simulation
command. Live order arming and submission remain behind Framework trading
safeguards and cannot be introduced through presentation metadata.

## Compatibility

This decision does not remove the older experience-based workspace runtime.
Both can operate while applications migrate from established panel identifiers
to canonical component identities. Compatibility adapters may remain until all
callers use the new identifiers.
