# Umicom Workbench Feature Roadmap

**Status:** Canonical priority roadmap; native acceptance remains pending  
**Owner:** Umicom Foundation  
**Revision control:** Git history.

## Roadmap policy

This document is the single priority order for major feature work. The product
completion guide and specialist roadmaps explain the scope in more detail; they
do not maintain a competing delivery order. Priority numbers describe importance,
not file versions or delivery names. Framework ownership, application coverage
and acceptance requirements remain fixed.

Reusable behaviour is implemented in C in Umicom Framework first. Thin graphical
clients select product identity, compose services and present their results.
Native command-line tools use those same contracts. New Python or PowerShell
scripts must not become a second implementation of product or developer tooling.
Platform-specific assembly is reserved for a justified low-level requirement
behind a documented C boundary.

## Evidence and current baseline

Keep four kinds of evidence separate: a public contract, its core implementation,
native integration, and a verified user journey. A menu, model or passing source
check does not prove the final journey works. This review covers the governing
documents and selected source paths; it is not an exhaustive source audit.

- Six products have dedicated native frontends: Studio IDE, Trader, Bank, TMS,
  Music Studio and Desk.
- Eighteen further products have shared native layout-preview entry points.
  Their unconnected domain commands report unavailable; they are not completed
  products. The full inventory is in the product table below.
- The shared header, catalogue, native detached windows, appearance contracts,
  typed context groups and transactional layout model have source implementations.
  Native rendering, keyboard use and monitor restoration still need acceptance.
- Free canvas placement now has separate native rectangles, title dragging,
  lower-right resizing, an edit grid and numeric geometry controls in source.
  It does not consume dock-stack slots. Native verification is pending.
- Trader, Bank, TMS, Music and shared product previews use the suite path.
  Studio's main shell now has source integration with the same Framework host,
  retaining its original editor inside a model-owned panel. Desk still needs
  adoption. The new actual-Studio regression has not been compiled or run.
- Explicit native canvas checkpoints now connect to the existing Data Server
  chunk store and UI layout codec in source. Restart, corruption recovery and
  concurrent-save acceptance still need native execution.

### Current native launcher update

The C Framework launch-selection model now provides a dispatch callback and a
copied result report. A request accepted by the launch adapter is removed from
the selection. A failed request remains selected so it can be retried without
reopening applications whose requests were already accepted. Request acceptance
does not prove that the new application reached a ready state.

The shared GUI catalogue exposes checkboxes, Open selected, per-application
results and Refresh. Graphical discovery resolves canonical GUI executables;
it does not silently substitute a console program. Missing executables remain
visible with a reason. This work is source-integrated; compilation, native
interaction and launched-application readiness have not been verified here.

### Current native canvas update

The shared suite can create named empty layouts, add registered panels directly
to the canvas, edit their geometry, apply/lock, or cancel back to the baseline.
Clear Panels removes only unpinned, closable instances during the edit; it does
not delete product data or the catalogue. Canonical presets remain available.

Geometry requests carry the source layout revision and run after the GTK
gesture callback finishes. Geometry-only updates keep the existing provider
widgets. Hosts that do not enable body retention still rebuild provider views
for full model changes and need separate draft/focus recovery validation.
Hosts invalidate shared frame and tab actions
before replacing or removing a view. This also cancels queued requests when
another part of the program still holds a reference to an old button.

Studio's source integration now uses its existing professional-workspace facade
as the sole outer-panel layout authority. GTK placement arrays are display
projections, not a second edit baseline. Named blank canvases, reopening the
actual Editor, model-owned panel edits and explicit Apply/Cancel are connected.
The host can retain provider bodies across structural changes, while the editor
adapter reconciles document views without replacing unchanged text buffers.
These changes need native acceptance; source code and test registration are
not evidence that the application journey has passed.

Editor reconciliation now preserves the native document widget and translates
UTF-8 cursor positions. A bounded insertion guard prevents silent truncation at
the existing 16,383-byte snapshot limit. Large-file editing needs a direct
document-store integration; the guard does not complete that requirement.

The new checkpoint bridge saves the last explicitly applied active layout,
retains a previous valid copy and validates a restore before native publication.
Storage revisions prevent stale windows from silently overwriting newer saves.
SQLite-backed disk storage and memory-only test backends are reported separately.
The UI layout codec stays unchanged; dedicated record namespaces separate these
payloads from semantic workbench documents in the existing chunk store.

This is not a complete named-layout library or a document/session checkpoint.
Full-library storage, explicit damaged-metadata repair, layout migrations,
monitor recovery and native execution remain outstanding. The old shell-session
format must not overwrite the canvas during routine status synchronization.

## Priority order and finish lines

Every row includes normal, invalid-input, unavailable-provider and recovery
tests. Memory ownership, accessibility, security, useful comments and strict
warnings are requirements throughout, not a final cleanup task.

| Priority | Major feature area | Work remaining | Required finish evidence |
|---|---|---|---|
| 1 | Universal native canvas | Validate Studio's new source integration and shared free canvas; migrate Desk; complete eight-direction resizing, internal maximisation, docking previews, menu/toolbar placement, keyboard dragging and draft/focus recovery. | Create a blank layout, add a real panel, move/resize/dock it, apply and cancel later edits without state drift in Studio and Trader; assess the same mechanism in every client. |
| 2 | Durable workspaces and recovery | Validate the new explicit canvas checkpoint across restart and concurrent saves; complete the named-layout library, damaged-metadata repair, appearance/document/monitor records and migrations through existing Data Server stores. | Close and reopen a saved workspace; survive corrupt records, interrupted writes and a missing monitor without losing the usable layout. |
| 3 | Native developer operations and GUI acceptance tools | Expose existing C build, repository, change discovery, scheduling and UI automation services through native tools and Framework panels. | One reviewed request plans changed targets, reports failures and supports cancellation; GUI tests record button/menu actions and observable results without script-owned business logic. |
| 4 | Studio daily development loop | Project navigation, multi-document editing, completion, diagnostics, build/test/run/debug, diff and repository operations, searchable C/GTK4 lessons and documentation. | Open a C project, edit/save, inspect completion and diagnostics, build/test/debug, review changes and resume the project after restart. |
| 5 | Trader paper-trading workstation | Linked watchlist/chart/depth/order views, indicators, guarded amend/cancel, cash/fees/P&L, reconciliation, replay and connection health. | Deterministic paper orders reconcile through fills and balances; stale data, limits, disconnects and emergency stops are tested before live routing is considered. |
| 6 | Reusable product UI and service infrastructure | Virtual grids, trees, validated forms, provider setup, jobs, progress, cancellation, notifications, approvals and protected secret references. | Two different product journeys use the same Framework components; disconnected and denied actions explain their state before invocation. |
| 7 | Bank and TMS operational journeys | Accounts, beneficiaries, payments, approval and ledger evidence; trade capture, pricing, risk, settlement and reconciliation. | Simulated payment and trade lifecycles reach reconciled records with approval, audit and recovery; real-money adapters remain separately gated. |
| 8 | Desk host and cross-application work | Multiple application tabs, independent hosts, acknowledged transfer, unsaved-work protection, typed clipboard and multi-monitor restoration. | Open two product sessions, transfer one safely, reject incompatible transfers and restore both after restart; no foreign-process widget reparenting. |
| 9 | Visual design and extensions | Code/design/split/preview modes, properties, undo, source round-trip, extension discovery, permissions, compatibility and rollback. | Edit a form, preview it, regenerate/reopen its source, then install and reject incompatible test extensions without damaging the workspace. |
| 10 | Local intelligence and retrieval | Model installation/supervision, streaming, cancellation, ingestion, citations, deletion, approvals and generated-artifact provenance. | A local or remote model answers from authorised sources with usable citations; cancellation, source deletion and recovery leave consistent state. |
| 11 | Creative, engineering and business engines | Shared scene/geometry, game/input, timelines, audio/image/animation, chart/graph, document/export and domain workflow services. | Each adopting product completes its first persisted task with deterministic engine tests and a usable GUI; no generic preview is presented as completion. |
| 12 | Specialist studio and operations workflows | Web/mobile preview and delivery, database connections/querying, integration flows, service monitoring and security findings. | Each specialist GUI completes one real project, connection or incident journey with permissions, diagnostics and a recoverable result. |
| 13 | Suite delivery and OS preparation | Component installer, dependency bundling, repair/update/rollback, launch health, uninstall, desktop sessions and read-only system adapters. | Clean-machine install, multi-application launch, repair and uninstall preserve user data; privileged operations require separate approval and recovery evidence. |

The requested design is a user-composed canvas, including a black or other chosen
background, readable Umicom identity, movable menus and panels, colour-presented
typed groups and independent windows across monitors. These are target
requirements. Source integration of a launcher or layout model does not establish
that the complete visual design has been delivered.

## Product coverage and next useful journey

All products inherit priorities 1-3 and 6. Dedicated means a specialised frontend
exists in source, not that every business feature is complete. Preview means the
shared native host can present layouts but its unconnected domain actions do not
execute. Runtime validation is pending for this update in both groups.

| Product | Current GUI source | First product journey to complete |
|---|---|---|
| Umicom Studio IDE | Dedicated | Edit, build, test, debug and restore a C workspace. |
| Umicom Trader | Dedicated | Place and reconcile guarded paper orders through linked market panels. |
| Umicom Bank | Dedicated | Prepare, approve and reconcile a simulated payment. |
| Umicom TMS | Dedicated | Capture, price, approve and settle a simulated trade. |
| Umicom Music Studio | Dedicated | Save a music project, play/edit a clip and export a mix. |
| Umicom Desk | Dedicated | Discover and launch selected products, then restore their sessions. |
| Umicom Accountant | Layout preview | Enter, validate and reconcile a ledger transaction, then generate a report. |
| Umicom CAD | Layout preview | Create a constrained model, save it and export a verified drawing. |
| Umicom AI Creator | Layout preview | Run an approved generation job, review variants and export with provenance. |
| Umicom Database Studio | Layout preview | Connect securely, inspect a schema, execute a query and review results. |
| Umicom Education Studio | Layout preview | Open a lesson, complete an assessment and retain learner progress. |
| Umicom Commodity Exchange | Layout preview | Match simulated orders and reconcile clearing/settlement evidence. |
| Umicom Games | Layout preview | Compose a scene, test input/simulation and package a small playable project. |
| Umicom Integration Studio | Layout preview | Design a flow, validate mappings, execute against test adapters and inspect failures. |
| Umicom Kitchen Designer | Layout preview | Build a constrained floor plan, calculate an estimate and export documents. |
| Umicom LLM | Layout preview | Verify a model, stream a response, cancel work and restore conversation state. |
| Umicom Marketplace | Layout preview | Discover a signed component and install, update or roll it back safely. |
| Umicom Media Studio | Layout preview | Edit a timeline, preview media and export a cancellable render job. |
| Umicom Mobile Studio | Layout preview | Design a responsive screen, preview a target and package a test application. |
| Umicom Operations | Layout preview | Inspect service health, investigate a failed job and run an approved recovery. |
| Umicom OS Control Centre | Layout preview | Discover system state through read-only adapters and explain unsupported actions. |
| Umicom RAG | Layout preview | Ingest authorised sources, inspect retrieval citations and delete source/index data consistently. |
| Umicom Security Centre | Layout preview | Record scan findings, track remediation and export evidence without automatic destructive actions. |
| Umicom Web Studio | Layout preview | Edit source/design, preview a page, inspect diagnostics and deploy to an approved target. |

The OS Control Centre remains a user-space client. Kernel, boot and recovery
engineering stay outside the full Framework dependency graph, as recorded in
the accepted OS architecture decision.

## Governance enforcement

- maintain the canonical decision register;
- reconcile `.gitmodules` with application coverage automatically;
- reject non-canonical documentation naming and terminology;
- add stale-decision and missing-evidence checks;
- generate a readable governance index from source-controlled records.

## Universal startup and identity

- complete one startup state machine;
- use one Framework startup renderer;
- resolve application identity and icon from the portfolio;
- support degraded and recovery modes;
- migrate remaining application-local startup implementations;
- validate every graphical application.

## Universal application host

Implemented foundation:

- Framework-owned searchable application catalogue sourced from the canonical portfolio;
- active application-surface tab in the shared header;
- plus action available to Studio, Desk and shared product workstations;
- independent new-window process fallback;
- shared multi-select launch requests, copied results and retry selection;
- public host callback for later in-process application-surface sessions;
- close action routed through the normal native close-request path.

Remaining work:

- multiple application-surface sessions in one host;
- closeable and reorderable application tabs for several simultaneous sessions;
- transfer between host windows;
- connect existing acknowledged transfer tokens to destination rehydration;
- multi-monitor host restoration;
- session checkpoint and recovery;
- complete security and unsaved-work transfer policy.

## Tabs and document surfaces

- managed application tabs;
- document and tool tab identity;
- close, restore and recently closed;
- split groups;
- drag transfer between tab stacks;
- per-product session restoration;
- correct separation from layout tabs.

## Docking and window management

- visual docking targets;
- drag movement;
- split and tab placement;
- native detached-window state preservation and acceptance;
- resize and monitor persistence;
- maximise and restore;
- pin and auto-hide strips;
- reattachment;
- close protection;
- keyboard equivalents.

## Layout library and persistence

- product defaults;
- user layouts;
- create, duplicate and rename;
- save and save as;
- apply, cancel and lock;
- reset to product default;
- import and export;
- versioned schema migration;
- crash-safe recovery;
- Data Server persistence.

Reuse the existing Data Server-backed document and chunk stores. The shared
GTK suite now supports explicit storage binding; native launchers request a
file-backed checkpoint. Unbound constructors and memory-only connections still
cannot provide restart recovery. Source integration must be followed by native
acceptance before durability is reported as verified.

## Typed context linking

- named and numbered groups;
- source, destination and bidirectional roles;
- project, document, instrument, account, entity, model and connection contexts;
- compatibility validation;
- history and diagnostics;
- accessible non-colour identity.

## Product-focused presentation

- shared navigation patterns;
- meaningful empty, loading, ready, degraded and failed states;
- truthful command states;
- setup and connection assistants;
- Developer Inspector for technical metadata;
- reusable grids, trees, charts, forms and status cards;
- product-specific default experiences for every registered application.

## Functional vertical journeys

Each product feature follows:

```text
request
→ validation
→ controller
→ authoritative service
→ state transition
→ event
→ refreshed view
→ audit evidence
```

Early depth priorities are Studio, Trader, TMS and Bank, while shared mechanics and coverage apply to the entire application family.

## Accessibility and responsive design

Implemented foundation:

- centre-dominant default semantic geometry shared by all workstations;
- accessible names for application catalogue, search, new-window and close controls;
- packaged Framework-owned SVG Umicom mark with a diagnostics-visible missing
  resource state; no textual branding fallback.

Remaining work:

- keyboard-only operation;
- focus order and restoration;
- accessible labels and descriptions;
- high contrast and reduced motion;
- supported desktop scaling;
- compact and wide layouts;
- multi-monitor and remote-session recovery.

## Architecture and quality conformance

- public Framework contract and adapter alignment;
- compatible constructor and callback preservation;
- opaque-model access through public functions only;
- phantom-header and parallel-symbol rejection;
- public headers compile in isolation;
- direct declaration ownership;
- strict warnings;
- duplicate Framework-mechanism detection;
- private-header boundary enforcement;
- Data Server authority checks;
- frontend semantic conformance;
- all-application build and test;
- application startup journeys;
- product coverage report.

## Completion definition

A roadmap area is complete only when:

- Framework implementation exists;
- application profiles adopt it;
- existing behaviour is preserved;
- tests cover normal and failure paths;
- accessibility and responsive behaviour are validated;
- documentation and decisions are updated;
- all registered applications are assessed;
- the complete suite builds and relevant tests pass.
