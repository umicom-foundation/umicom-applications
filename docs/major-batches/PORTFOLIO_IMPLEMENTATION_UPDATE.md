<!--
  Umicom Framework
  File: docs/major-batches/PORTFOLIO_IMPLEMENTATION_UPDATE.md

  PURPOSE:
    Record the public implementation work for the Framework and its
    applications. This is a delivery map, not a claim that every listed
    product is already complete.

  AUTHOR AND ORGANISATION:
    Sammy Hegab
    Umicom Foundation

  LICENCE:
    MIT
-->

# Product completion update

**Status:** Active implementation plan
**Reviewed:** 6 September 2026

The suite root composes the application modules, the Framework owns reusable
behaviour, and each product module supplies its identity, domain rules and
provider integration. A catalogue entry or a visible panel is not proof that a
feature works. A user journey must be executable, saved, recoverable,
accessible and covered by tests.

## Decisions carried forward

- The Workbench Host is a Framework-owned canvas. It can contain docked,
  tabbed, split, floating and detached surfaces and can restore a named layout
  across monitors.
- Product defaults are useful starting layouts, not restrictions. Users may
  create a blank layout, add windows from the catalogue, move/resize/group
  them, lock the result and save it in the Layout Library.
- Framework contracts are toolkit-neutral. GTK4, Qt6, web and future mobile
  frontends project the same state; they do not create competing layout or
  business authorities.
- UI code can request work, but execution, risk, permissions, persistence and
  audit remain with Framework services and product controllers.
- Simulation, offline and disconnected modes are honest states. Live trading,
  real payments, destructive OS actions and agent file changes require explicit
  policy and approval.
- SVG is the single source for the Umicom mark. See ADR-0013; no textual logo
  fallback is permitted.

## Implementation included in this update

- The shared product-surface projection now joins friendly layout windows to
  reusable panel presentations, including state, message, progress, badges and
  guarded actions.
- The GTK4 suite workstation renders the same lifecycle for Bank, TMS, Music
  and Trader, while existing Studio composition remains a separate integration
  boundary until its public UI contract is ready.
- Layout editing, docking, floating, context linking, host registration,
  persistence checkpoints and detached-surface transfer contracts are retained
  and have focused regression coverage.
- The Workbench Canvas now accepts a bounded batch of panel placement requests
  as one rollback-safe edit, so a multi-panel gesture cannot publish a partial
  arrangement.
- Build discovery, process supervision, approval queues, document state,
  declaration parsing, plugin manifests, toolchain discovery and workbench
  archive storage received bounds, ownership and overflow hardening.
- The GTK4 header and startup surface now use only the resolved Framework SVG
  asset. Missing artwork leaves the product title visible and is observable in
  the snapshot for packaging diagnostics.
- The Framework launch selection now applies a shared launch-readiness gate.
  A product is offered as launchable only when its canonical experience has
  valid panels, layouts and a resolvable default layout. The picker keeps a
  bounded reason and readiness percentage so Desk and thin applications can
  explain blocked launches without duplicating validation rules.
- The Framework now exposes a portfolio launch-readiness summary. Desk,
  Studio and Trader can report one consistent ready/blocked total and the
  first actionable blocking reason without scanning catalogue internals.
- Launch selections can now be captured and restored as a bounded checkpoint.
  Restore validates every saved product before changing the live selection, so
  a missing or no-longer-launchable application cannot create a partial session.
- The Framework command surface now supports bounded, case-insensitive palette
  queries with optional capability checks. Clients can show disabled reasons
  without duplicating command discovery or execution policy.
- Command-palette results can now be passed through the production binding
  layer for one governed invocation. The Framework resolves stable IDs,
  checks capability and maturity, supports optional approval, and reports a
  dry-run when no product executor is attached. Product controllers still own
  the action itself; see [governed command-palette invocation](COMMAND_PALETTE_INVOCATION.md).
- Production runtimes now retain a bounded command invocation journal. Each
  entry records availability, approval, execution and status, while the
  runtime owns the journal lifecycle and revision updates. See [command
  invocation journal](COMMAND_INVOCATION_JOURNAL.md).
- The portfolio now has a surface audit that joins application identity,
  presentation, panels, layouts and executable metadata. It reports every
  product row instead of stopping at the first missing item; see [portfolio
  surface audit](PORTFOLIO_SURFACE_AUDIT.md).

## Completion contract for the next updates

Each product feature is marked **verified** only when all of these exist:

1. a Framework or product contract with ownership and failure states;
2. a real controller/service path rather than a placeholder callback;
3. persisted state with migration, backup and interrupted-session recovery;
4. a headless regression test for success, invalid input and unavailable
   provider states;
5. a native or web presentation that is keyboard accessible and scalable;
6. a user-journey test proving the feature can be opened, used and closed;
7. release evidence covering packaging, resources, permissions and audit.

## Framework work queue

### P0 — universal runtime

- Finish the Canvas surface renderer: drag, resize, snap, split, tab, float,
  detach, monitor transfer and lock/unlock, all driven by the portable model.
- Add durable profile/session storage for layouts, appearance, recent work,
  cursor positions, terminals and unfinished safe tasks.
- Consolidate foreground/background task execution, cancellation, retry,
  progress, scheduling, notification and restart recovery.
- Finish provider discovery, health, permissions, rate limits, offline mode and
  deterministic test doubles.
- Complete encrypted secret storage, database migrations, backup/restore,
  repair and evidence export.

### P1 — developer and intelligence services

- Complete compiler, debugger, source-control and documentation providers.
- Add language-service contracts for C/C++, assembly, XML, JSON, TOON, MCP,
  Vala, Python, Java, PHP, QML and Qt projects; providers may be optional, but
  the UI must show why one is unavailable.
- Add IntelliSense-style completion, hover documentation, symbol navigation,
  references, rename, formatting and diagnostics through one provider-neutral
  model.
- Finish permission-aware agent planning, patch review, approved execution,
  workspace indexing, RAG citations and local/remote model routing.
- Add signed extension discovery, permissions, isolation, compatibility and
  rollback.

### P1 — visual and media engines

- Keep the chart and graph engine backend-neutral, with deterministic output
  for headless tests and more than one possible renderer.
- Define scene/asset/geometry contracts for 3D, CAD, Kitchen and Games.
- Define animation, image, audio/video timeline, document/PDF/DOC/TXT/
  PowerPoint and storyboard generators as reusable engines.
- Add database and message-provider contracts for SQL/NoSQL, MCP and future
  publisher/subscriber transports.

## Product verticals

### Umicom Studio IDE

Finish the edit → search → IntelliSense → build → test → run → debug → review →
package journey. Add visual-designer source round-trip, dockable code/design/
preview panels, lessons and GTK4/Qt documentation, extension management,
workspace recovery, project templates and provider-aware errors. Studio remains
the reference consumer of the Canvas and language-service contracts.

### Umicom Trader

Finish safe paper trading first: market-data session, watchlist, chart and
indicator panels, depth/tape, order entry, positions/P&L, risk and reconciliation.
Implement New Window, blank canvas, linked panels, lock/layout library,
multi-monitor recovery and chart drawing through the Framework chart engine.
Live broker execution stays behind provider, permission,
risk, kill-switch, audit and acceptance gates.

### Umicom Bank and Umicom TMS

Bank needs profile/authentication, account/provider reconciliation, beneficiaries,
fees, payments, statements, cards, fraud and audit journeys. TMS needs governed
trade capture, pricing inputs, positions/P&L, sensitivities, limits, approvals,
collateral, settlement and accounting. Both use the shared task, workflow,
document, notification and persistence services.

### Umicom LLM, RAG and Author

Provide model/provider lifecycle, streaming/cancellation, encrypted settings,
conversation and prompt history, ingestion/chunking/embeddings, citations,
evaluation and deletion. Author adds book/document/media plans, provenance,
rights/consent, editable chapters, export and reproducible generation jobs.

### Desk, OS and operational products

Desk needs discovery, health, updates, notifications and multi-monitor session
recovery. OS Control Centre needs read-only adapters first, then separately
authorised mutation with rollback and audit. Operations and Security Centre
need inventory, logs, metrics, findings, severity, suppression and remediation
evidence.

### Web, Mobile, Database and Integration Studio

Add project models, live preview/run targets, inspectors, source generation,
schema/message discovery, encrypted connection profiles, validation,
deployment and rollback while reusing the same Canvas and provider contracts.

### Music, Media, Creator, CAD, Kitchen and Games

Use shared project graphs, asset provenance, device/provider routing, timelines,
render/export jobs, scene/geometry/animation/input contracts and deterministic
headless tests. Product modules add domain tools; they must not fork engines.

### Accountant, Exchange, Marketplace, Education and other thin modules

Add their real ledgers or workflows behind persisted controllers, permissions,
reports, accessible panels, provider adapters and acceptance journeys. Their
initial recipes remain useful, but a panel is not promoted to verified until it
passes the completion contract above.

## Implementation gaps to track

The current inventory shows a large catalogue-to-behaviour gap: many panels
and features are described but only a small number have executable evidence.
The quality dashboard must therefore track, per application and per surface:

- contract owner and provider;
- implementation and action availability;
- persistence and recovery state;
- headless, UI and accessibility test evidence;
- packaging/resource evidence;
- open defects, security findings and remediation history.

No claim of full product completion is made until the dashboard reports these
fields for the relevant journey. Verification results belong to the configured
build and test environment and should be recorded with the corresponding
release evidence.
