# ADR-0003: Thin Umicom Desktop and OS Module Repositories

- **Status:** Accepted
- **Date:** 20 August 2026
- **Owner:** Sammy Hegab, Umicom Foundation

## Context

The ecosystem needs a user-facing Umicom Desk composition and a user-space operating-system Control Centre without turning Framework or the full OS distribution into application monoliths.

## Decision

Create two thin application-module repositories:

```text
umicom-desktop-module
umicom-os-module
```

Their future composition paths are:

```text
applications/desktop
applications/os
```

`umicom-desktop-module` contributes the Umicom Desk product profile, branding, default layouts and product-specific command placement. `umicom-os-module` contributes Control Centre panels, system settings views and OS-specific user-space composition.

The reusable application registry, taskbar state, desktop layout engine, panel registry, context links, session services and frontend adapters remain in Framework. The full `umicom-os` repository remains responsible for creating a bootable distribution.

## Consequences

- Umicom Desk can run on Windows, ordinary Linux and Umicom OS.
- The OS Control Centre can be tested as an ordinary Framework application.
- Neither module owns the Linux kernel or duplicates Framework services.
- The repositories are added as submodules only after they exist and contain valid commits.
