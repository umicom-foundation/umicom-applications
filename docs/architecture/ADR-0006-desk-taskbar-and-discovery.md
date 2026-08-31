# ADR-0006: Umicom Desk Taskbar and Validated Application Discovery

- **Status:** Accepted
- **Date:** 20 August 2026
- **Owner:** Sammy Hegab, Umicom Foundation

## Context

Umicom Applications should present available products through a familiar bottom
taskbar while retaining task-oriented bottom layout tabs. Simply executing
every directory below `applications/` would be unsafe, non-reproducible and
unable to enforce compatibility or permissions.

## Decision

Umicom Desk has two distinct bottom-strip models:

```text
Application taskbar
    installed, compatible, enabled and permitted products

Layout strip
    active, pinned, dirty and user-created semantic layouts
```

Applications are projected from validated Framework definitions and application-presentation metadata. Runtime discovery later adds installation state, ABI compatibility, permissions, executable availability and health. Folder presence alone never authorises execution.

R2 implements taskbar state, pinning, visibility, running/attention states, active application selection and GTK4 rendering. Process launch and supervision remain a later Framework launcher capability.

## Consequences

- The taskbar grows as valid applications become available.
- Empty placeholder submodules are not presented as runnable products.
- The same model can be rendered by GTK4, Qt, Wt, native web and Umicom OS.
- Application icons and layout tabs may share one visual strip while remaining separate Framework concepts.
