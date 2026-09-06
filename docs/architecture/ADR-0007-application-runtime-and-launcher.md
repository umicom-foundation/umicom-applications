# ADR-0007 — Application runtime and launcher authority

**Status:** Accepted
**Date:** 20 August 2026

## Context

The shared presentation foundation introduced application metadata and a
taskbar projection. A visible icon must not itself become permission to execute
a path. Umicom Desk needs one authoritative model for installation,
compatibility, enablement, pinning, process state, failure evidence and the
active application.

## Decision

Umicom Framework owns:

- the application runtime catalogue;
- immutable launch plans;
- start, activate, restart and stop semantics;
- application taskbar ordering and state;
- process and exit evidence;
- the reusable GTK4 Desk adapter.

The Master Controller serialises mutation. Platform adapters execute validated
plans. Application modules and frontend widgets never construct shell commands
or scan arbitrary folders for executables.

Before a runtime record is marked eligible, the launcher asks the canonical
Framework experience catalogue for a launch-readiness report. The report checks
that the product has panels, layouts and a resolvable default layout. A blocked
record stays visible to diagnostics with a bounded reason, but it cannot be
selected for execution.

`umicom-desktop-module` remains a thin product composition and executable entry
point. It binds the Framework launcher to the Framework process supervisor and
supplies default product registrations.

## Consequences

The launcher can later move out of process without changing application
contracts. Windows, Linux and Umicom OS can provide different platform adapters.
A failed application produces typed state and remains visible for diagnosis.
Incomplete product recipes are rejected before process start, so every client
application receives the same safe launch rule and explanation.
