# ADR-0004: Semantic Layout Ownership and Persistence

- **Status:** Accepted
- **Date:** 20 August 2026
- **Owner:** Sammy Hegab, Umicom Foundation

## Context

Users require familiar professional-workstation features: custom layouts,
layout tabs, locking, history, cross-application panels, coloured context links
and restoration. A saved GTK widget tree would couple persistent state to one
frontend and one process implementation.

## Decision

Layouts use four complementary ownership layers:

1. **Umicom Framework** owns the toolkit-neutral semantic layout schema, validation, layout engine, history, Layout Browser contracts and frontend renderers.
2. **Framework resources** contain generic immutable templates such as Blank,
   Grid and Standard Workbench.
3. **Application modules** contain product-specific default templates and panel contributions.
4. **Framework Data Server** stores user layouts, revisions, ownership, permissions, active sessions, panel state and crash recovery.

Portable `.umilayout` files support import, export, sharing, source control, structural comparison and migration.

## Consequences

- Layouts can be rendered through GTK4, Qt, Wt, native web or headless adapters.
- User state is not committed into application source trees.
- Application modules do not create private layout databases.
- Missing application components can be represented by explanatory placeholders instead of making an entire layout unreadable.
- The colour shown on a context chain is presentation; the Framework stores a typed context-channel identity and value.
