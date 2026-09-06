<!--
  Umicom Framework
  File: docs/major-batches/PORTFOLIO_LAUNCH_READINESS.md

  PURPOSE:
    Explain the shared launch-readiness summary used by application launchers.

  AUTHOR AND ORGANISATION:
    Sammy Hegab
    Umicom Foundation

  LICENCE:
    MIT
-->

# Portfolio launch readiness

The Framework now provides one portfolio-wide readiness summary. A launcher
can use this result to show how many applications are ready, how many are
blocked, and the first reason that needs attention.

## Why this belongs in Framework

Every application uses the same rules for a safe starting surface:

1. its experience must be registered;
2. it must publish at least one panel;
3. it must publish at least one layout; and
4. its default layout and all nested references must validate.

Keeping these rules in one service prevents Desk, Studio, Trader and future
products from slowly producing different answers for the same application.

## Contract

Call `umi_application_launch_readiness_summary` with a pointer to an empty
`UmiApplicationLaunchReadinessSummary` value. The function fills bounded
counts for the canonical catalogue and calculates the average feature
readiness percentage.

The result contains:

- `application_count`: every canonical Framework experience inspected;
- `ready_count`: experiences that can open their default surface;
- `blocked_count`: experiences that need a contract or surface correction;
- grouped blocked counts for missing experiences, layouts, panels and invalid
  definitions; and
- the first blocked application ID and reason for a helpful status message.

The function returns `UMI_STATUS_INVALID_ARGUMENT` when the output pointer is
missing. It does not allocate memory, launch processes or change application
state, so it is safe for a startup screen, a headless check and a release
dashboard.

## Client use

Umicom Desk uses the summary beside its selectable application list. Studio
and Trader consoles print the same totals so their headless status output is
consistent with the launcher. A graphical client should display the totals as
status cards and show the first blocked reason as an actionable message.

The summary is deliberately separate from product feature maturity. An
application may open a valid default layout while individual features remain
planned. Product readiness still requires the journey, persistence, recovery,
accessibility and release evidence described in the portfolio update.

The related `UmiApplicationLaunchSelectionCheckpoint` contract preserves a
selected multi-application startup set for session storage. See
`MULTI_APPLICATION_SESSION_CHECKPOINT.md` for the capture and restore rules.
