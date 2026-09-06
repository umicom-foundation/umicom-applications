<!--
  Umicom Applications
  File: docs/roadmaps/NEXT_MAJOR_UPDATES_ROADMAP.md

  PURPOSE:
    Keep the remaining cross-portfolio work in a clear order so Framework
    contracts are completed before product features depend on them.

  AUTHOR AND ORGANISATION:
    Sammy Hegab
    Umicom Foundation

  LICENCE:
    MIT
-->

# Next major updates roadmap

This roadmap is the working list for the next large delivery batches. It
separates shared Framework work from product work and gives every batch a
simple finish line. A feature is not considered complete because a menu item or
panel is visible. It is complete when the contract, behaviour, presentation,
state recovery and tests all exist.

## Current baseline

The current Framework baseline includes:

- application experiences, panels, layouts and launch-readiness checks;
- portable workbench canvas and bounded multi-panel edits;
- multi-application launch selection checkpoints;
- capability-aware command-palette search;
- governed command invocation with product-owned approval and execution;
- bounded command invocation history with runtime capture and restore APIs;
- portfolio surface audit covering every application layout, UI and start entry;
- shared production, presentation and workspace recovery contracts.

The remaining work below is still required before the products can be called
fully working applications.

## Delivery order

### Batch 1 — Universal workbench interaction

Goal: make the Framework canvas behave like a complete application shell.

Remaining features:

- drag, resize, snap, split, tab, float and detach interactions;
- moving a panel to another monitor and restoring it after reconnect;
- lock and unlock state with clear visual feedback;
- panel groups, linked context and keyboard navigation;
- responsive sizing, high-DPI scaling and screen-reader descriptions;
- empty, loading, stale, disconnected, denied, error and recovery states;
- layout migration when a panel or monitor no longer exists.

Finish evidence: headless state tests, keyboard tests, native interaction tests,
multi-monitor recovery and a saved layout reopened in a new session.

### Batch 2 — Durable session and activity state

Goal: make work survive a restart without losing the user's context.

Remaining features:

- durable layout, appearance, recent-file and panel-state storage;
- atomic checkpoints with backup, validation and migration;
- restoration of command history, unfinished jobs and notifications;
- crash recovery and an explanation when a saved item cannot be restored;
- export and import of a portable workspace profile;
- tamper-evident activity and decision evidence.

Finish evidence: interrupted-session tests, migration tests, corrupted-file
tests and a recovery report that a person can understand.

### Batch 3 — Studio editing and language intelligence

Goal: make Umicom Studio IDE useful for everyday software development.

Remaining features:

- multi-document editor with cursor, selection, markers, folding and undo;
- project, solution, target, configuration and launch-profile models;
- completion, hover help, signatures, symbols, references, rename and format;
- diagnostics, quick fixes, code actions and safe refactoring previews;
- support contracts for C, C++, assembly, XML, JSON, TOON, MCP, Vala,
  Python, Java, PHP, QML and Qt projects;
- build, test, run, debug, terminal, source-control and diff workflows;
- compile-database discovery and provider health messages;
- lessons and Framework documentation in a searchable built-in reader;
- visual designer, property inspector, source round-trip and live preview.

Finish evidence: a new user can open a project, edit a file, receive useful
completion, build, test, debug, review and save the workspace without leaving
Studio.

### Batch 4 — Trader simulation and charting

Goal: make Umicom Trader a complete and safe paper-trading workstation before
live routing is enabled.

Remaining features:

- instrument, venue, quote, trade, order-book and market-session models;
- watchlist, chart, indicators, drawing tools, depth, tape and news panels;
- order draft, validation, confirmation, order lifecycle and reconciliation;
- positions, cash, profit/loss, exposure, limits and risk explanations;
- replay clock, historical data, strategy, scanner and backtest evidence;
- chart rendering through the backend-neutral chart engine;
- connection health, stale-data handling and reconnect behaviour;
- emergency controls, audit trail and an unmistakable simulation/live banner.

Finish evidence: deterministic paper-trading journeys, rejected-order tests,
reconnect tests, risk-limit tests and a complete saved trading layout.

### Batch 5 — Provider, AI and retrieval services

Goal: let products use remote or local models without hiding permissions or
source evidence.

Remaining features:

- provider catalogue, model capability discovery and health state;
- streaming responses, cancellation, retry, rate limits and cost records;
- local-model process management and offline mode;
- conversation, prompt, tool and patch history;
- workspace indexing, document ingestion, chunking and citations;
- retrieval evidence, source freshness and deletion controls;
- agent plans, approval queue, patch review, rollback and execution journal;
- provider-neutral contracts for future model services.

Finish evidence: a task can be planned, approved, executed, cancelled and
recovered with a complete evidence trail and no secret stored in source files.

### Batch 6 — Visual, document and media engines

Goal: provide reusable engines for applications that create or display rich
content.

Remaining features:

- scene, geometry, camera, asset and material contracts for 3D and CAD;
- animation timelines, image rendering and media transport controls;
- chart, graph, plot and analytical primitives with multiple renderer adapters;
- document generation for text, PDF, office formats and structured exports;
- book, chapter, storyboard and video-script generation plans;
- provenance, rights, consent and reproducible export jobs;
- deterministic headless render tests and resource-budget limits.

Finish evidence: Studio can edit a source document, preview it, export it and
reopen the result while an application can substitute a different renderer.

### Batch 7 — Plugins, reflection and extensions

Goal: allow new panels, layouts, commands and providers to be discovered safely
without rebuilding every product.

Remaining features:

- signed extension manifests and compatibility negotiation;
- reflection metadata for modules, contracts, fields, commands and layouts;
- isolated extension lifecycle with permissions and resource limits;
- extension activation, disable, rollback and migration;
- community SDK templates and validation tools;
- extension-provided panels and commands projected into the shared palette;
- audit records for installation, activation and removal.

Finish evidence: a test extension can be installed, discovered, rejected when
incompatible, activated, disabled and removed without corrupting a workspace.

### Batch 8 — Suite installer and application launcher

Goal: deliver a clear Windows installation and multi-application start flow.

Remaining features:

- installer manifest and selectable application components;
- dependency detection, repair, upgrade and rollback;
- branded application identity and resource validation;
- suite start screen with multi-selection and default layouts;
- launch health, missing-provider explanations and safe retry;
- per-application update discovery and release evidence;
- uninstaller and preservation of user workspace data.

Finish evidence: install, repair, upgrade, launch two applications, restart and
uninstall journeys pass on a clean machine image.

### Batch 9 — Product completion

Goal: finish the application-specific workflows while reusing Framework APIs.

Remaining features:

- Bank: identity, accounts, payments, statements, reconciliation, fraud and
  audit journeys;
- TMS: trade capture, pricing, limits, approvals, collateral, settlement and
  accounting journeys;
- Desk and OS: discovery, health, updates, notifications and authorised system
  controls with rollback;
- Music and Media: libraries, timelines, effects, rendering and export;
- Web, Mobile, Database and Integration Studio: project, schema, preview,
  connection and deployment workflows;
- Games, 3D and creator applications: scene, input, asset, animation and
  multiplayer foundations;
- remaining thin applications: real domain workflows, persistence, providers,
  accessible panels and acceptance evidence.

Finish evidence: each product has at least one complete user journey, a
recovery path, provider health handling, accessibility evidence and packaging
evidence.

### Batch 10 — Quality, security and release automation

Goal: make every batch repeatable and safe to release.

Remaining features:

- automatic change discovery and incremental build planning;
- configurable quiet-period testing and overnight build schedules;
- compiler, static-analysis, memory, dependency and secret scans;
- vulnerability, defect and remediation database with trend reports;
- machine-readable test, quality and software-bill-of-materials reports;
- reproducible packages, signatures, hashes and release promotion gates;
- continuous integration across Framework, application modules and extensions.

Finish evidence: one command discovers changed modules, runs the required
checks, records failures, pauses unsafe promotion and produces a release report.

## Rules for every future batch

1. Define the Framework contract before adding a product-only implementation.
2. Keep product code responsible for domain decisions and external providers.
3. Add success, invalid-input, unavailable-provider and recovery tests.
4. Keep state bounded, owned and recoverable; never hide ownership in a UI
   callback.
5. Document public APIs in simple language and preserve useful existing comments.
6. Keep private research, temporary files, secrets and credentials outside the
   public repository.
7. Record what was implemented and what remains; do not mark a catalogue item
   complete without executable evidence.
