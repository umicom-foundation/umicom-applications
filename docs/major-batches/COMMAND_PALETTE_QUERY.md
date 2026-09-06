<!--
  Umicom Framework
  File: docs/major-batches/COMMAND_PALETTE_QUERY.md

  PURPOSE:
    Explain the shared command-palette query contract for application shells.

  AUTHOR AND ORGANISATION:
    Sammy Hegab
    Umicom Foundation

  LICENCE:
    MIT
-->

# Shared command-palette queries

The Framework command surface now supports one search contract for Desk,
Studio, Trader and future application shells. A frontend can search command
titles or stable IDs without knowing how the catalogue is stored.

## How it works

1. Build an `UmiApplicationCommandSurface` from the canonical experience.
2. Fill an `UmiApplicationCommandQuery` with its structure size and search
   text. An empty text value returns every command.
3. Optionally provide a capability probe. The probe can mark a command
   unavailable when its provider or permission is not ready.
4. Call `umi_application_command_surface_query`.
5. Use each returned index with the existing command surface array and display
   unavailable entries as disabled explanations when requested.

Search is case-insensitive for predictable keyboard use and keeps catalogue
ordering, so repeated queries do not make menus jump around. The result is
bounded by the Framework command capacity and contains separate available and
unavailable counts.

When no capability probe is supplied, availability follows the command's
catalogue maturity. When a probe is supplied, a command's required capability
must also be available before it is marked usable.

The query service only discovers commands. It does not execute them. Execution
still passes through the existing command-binding, permission, confirmation,
background-job and audit services.

For the production path from a selected result to a product-owned callback,
see [governed command-palette invocation](COMMAND_PALETTE_INVOCATION.md).
