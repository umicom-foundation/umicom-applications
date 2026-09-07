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
clients select product identity and compose Framework services and views.
Framework owns the implementation, layouts and windowing, including the desktop
environment used by Umicom Desk. Desk is not a second framework or window manager
inside an application repository. Product engines also belong in Framework;
applications select and connect them through public contracts.
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
  eight-direction resizing, keyboard previews, an edit grid and numeric geometry controls in source.
  It does not consume dock-stack slots. Native verification is pending.
- Trader, Bank, TMS, Music and shared product previews use the suite path.
  Studio's main shell now has source integration with the same Framework host,
  retaining its original editor inside a model-owned panel. Desk still needs
  adoption. The new actual-Studio regression has not been compiled or run.
- Explicit native canvas checkpoints now connect to the existing Data Server
  chunk store and UI layout codec in source. Restart, corruption recovery and
  concurrent-save acceptance still need native execution.
- Studio, the shared suite launchers and Desk now install their official SVG
  identity in the actual topmost GTK titlebar. Suite and Desk transfer their
  existing identity controller, preserving catalogue selection and appearance.
  The shared renderer has named edge tabs and temporary tool panels,
  with separate dock, collapse and protected-panel behaviour. Source regression
  coverage exists; native appearance and interaction acceptance are pending.

### Current workspace navigation and application launch update

Every registered application declares its graphical and console executable
explicitly. The build and discovery paths use those declarations and compare
known graphical names with the existing Framework portfolio. They no longer
guess a native name by removing a console suffix. A declaration is not proof
that an executable is installed or its product services are ready.

Suite clients can search current panel instances and named layouts. Normal
Open/Focus selects visible panels, reveals auto-hide tools and reopens ordinary
hidden dock tools without moving them. Adding or moving a panel still requires
Edit Layout. Studio uses its existing workspace owner for the same operations.
Desk's search opens its application chooser or selects a real desktop layout;
it does not claim to host other products' panels.

Eligible internal panels can temporarily fill the shared workspace. Restore
returns the same widget to its original frame and keeps the other tools alive.
This presentation uses the existing Framework maximise-mode contract, not a
second saved rectangle or layout transaction. Protected, fixed-size, detached
and auto-hide panels are excluded. Active geometry gestures must finish first.

The new C regressions cover manifest declarations, navigation, transient
maximisation and search-controller teardown. Existing Studio and Desk native
tests cover their new paths. These sources have not been compiled or executed
in this update; native acceptance remains a release gate.

### Current native window and canvas controls update

The shared titlebar binding now reaches Trader, Bank, TMS, Music and the eighteen
shared product previews, as well as Studio and Desk. The main window receives
its titlebar before it is presented. Products with deferred startup retain a
temporary startup surface while preparing that final window. Closing startup
must cancel pending work; a later unexpected application window is not valid.
Desk retains its dedicated desktop renderer; titlebar adoption is not canvas
host migration or a completed multi-application session service.

Canvas panels expose four edges and four corners during layout editing.
Resizing keeps the opposite edge in place. An untouched axis does not jump to
the grid, including imported off-grid rectangles. On a focused panel title,
arrow keys preview movement and Shift plus arrows preview bottom/right resizing.
Enter submits the preview; Escape or leaving the title cancels it. Existing
lock, protected-panel and non-resizable policies remain authoritative. No
provider text field intercepts these geometry keys.

Source regressions cover the geometry directions, native handles, keyboard
preview lifecycle, retained callbacks, titlebar transfer and Desk teardown.
They have not been compiled or executed during this update.

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
The UI layout schema number stays unchanged; stricter parsing and round-trip
geometry precision are implemented. Dedicated record namespaces separate these
payloads from semantic workbench documents in the existing chunk store.

This active-layout checkpoint is separate from the named library described
below. Explicit damaged-metadata repair, document/session recovery, layout
migrations, monitor recovery and native execution remain outstanding. The old shell-session
format must not overwrite the canvas during routine status synchronization.

### Current named-layout library update

Framework now has revision-checked operations to open, duplicate, rename and
remove a named layout. Studio and shared suite workstations expose the same
Layout Library view. The view lists and searches copied records; the existing
workspace model remains the only owner. Open layout edits must be applied or
cancelled first. Removal needs confirmation and cannot remove the last layout.
Renaming keeps panel content; selecting a different layout follows each host's
existing panel-lifecycle rules.

The library now has explicit **Save library** and confirmed **Restore library**
controls. Framework stores the complete ordered list, including names and the
active selection, through the existing Data Server. It uses a separate record
namespace, so **Save layout** continues to store only the active arrangement.
Restore replaces the named list exactly; layouts removed before a library save
do not reappear as an accidental merge with product defaults.

All layouts must be committed and locked before saving. Storage revisions
reject stale saves, and a previous valid archive can be recovered if the newest
payload is damaged. Restore validates every layout against the current product,
tool and context definitions before the native host accepts the new state.
It does not install missing tools or archive documents, appearance settings or
context-group definitions. The archive is bounded to 450 KiB; oversized input
fails without dropping layouts or replacing the stored copy.

Library restoration is explicit, including after restart. It does not silently
replace the session on startup. The controls distinguish disk storage from a
memory-only connection. Desk's dedicated desktop renderer does not yet use
this library view. Compilation and native acceptance remain pending. See the
[layout library validation guide](../validation/LAYOUT_LIBRARY_VALIDATION.md).

The focused native workbench test target builds regression executables without
depending on application executables. A running product must still be closed
before rebuilding that product. A missing test executable is not a test result.

## Priority order and finish lines

Every row includes normal, invalid-input, unavailable-provider and recovery
tests. Memory ownership, accessibility, security, useful comments and strict
warnings are requirements throughout, not a final cleanup task.

| Priority | Major feature area | Work remaining | Required finish evidence |
|---|---|---|---|
| 1 | Universal native canvas | Validate shared titlebars, normal tool navigation, transient internal maximisation, eight-direction resizing and keyboard previews; migrate Desk's content host; complete docking previews, menu/toolbar placement and draft/focus recovery. | Create a blank layout, add a real panel, focus/maximise/restore/move/resize/dock it, apply and cancel later edits without state drift in Studio and Trader; assess the same mechanism in every client. |
| 2 | Durable workspaces and recovery | Validate explicit active-layout and full-library checkpoints across restart and concurrent saves; complete damaged-metadata repair, appearance/document/context-definition/monitor records and migrations through existing Data Server stores. | Close and reopen a saved workspace; survive corrupt records, interrupted writes and a missing monitor without losing the usable layout. |
| 3 | Native developer operations and GUI acceptance tools | Connect existing C change discovery, incremental build, scheduling, quality and UI automation services; add recursive repository publication and one-command graphical delivery through the same native plans. | One reviewed request discovers affected targets, verifies, builds, tests and stages approved graphical products; recursive publication checks every child before its parent; failures and cancellation remain visible. |
| 4 | Studio daily development loop | Project navigation, multi-document editing, completion, diagnostics, build/test/run/debug, diff and repository operations, searchable C/GTK4 lessons and documentation. | Open a C project, edit/save, inspect completion and diagnostics, build/test/debug, review changes and resume the project after restart. |
| 5 | Trader paper-trading workstation | Linked watchlist/chart/depth/order views, indicators, guarded amend/cancel, cash/fees/P&L, reconciliation, replay and connection health. | Deterministic paper orders reconcile through fills and balances; stale data, limits, disconnects and emergency stops are tested before live routing is considered. |
| 6 | Reusable product UI and service infrastructure | Virtual grids, trees, validated forms, provider setup, jobs, progress, cancellation, notifications, approvals and protected secret references. | Two different product journeys use the same Framework components; disconnected and denied actions explain their state before invocation. |
| 7 | Bank and TMS operational journeys | Accounts, beneficiaries, payments, approval and ledger evidence; trade capture, pricing, risk, settlement and reconciliation. | Simulated payment and trade lifecycles reach reconciled records with approval, audit and recovery; real-money adapters remain separately gated. |
| 8 | Framework desktop environment and cross-application work | Live installed-application registry, taskbar/session state, multiple application tabs, independent hosts, acknowledged transfer, unsaved-work protection, typed clipboard and multi-monitor restoration; Desk remains a thin client. | Install or remove a product and refresh open launchers without restarting Desk; open two product sessions, transfer one safely and restore both; no foreign-process widget reparenting. |
| 9 | Visual design and extensions | Code/design/split/preview modes, properties, undo, source round-trip, extension discovery, permissions, compatibility and rollback. | Edit a form, preview it, regenerate/reopen its source, then install and reject incompatible test extensions without damaging the workspace. |
| 10 | Local intelligence and retrieval | Model installation/supervision, streaming, cancellation, ingestion, citations, deletion, approvals and generated-artifact provenance. | A local or remote model answers from authorised sources with usable citations; cancellation, source deletion and recovery leave consistent state. |
| 11 | Creative, engineering and business engines | Shared scene/geometry, game/input, timelines, audio/image/animation, chart/graph, document/export and domain workflow services. | Each adopting product completes its first persisted task with deterministic engine tests and a usable GUI; no generic preview is presented as completion. |
| 12 | Specialist studio and operations workflows | Web/mobile preview and delivery, database connections/querying, integration flows, service monitoring and security findings. | Each specialist GUI completes one real project, connection or incident journey with permissions, diagnostics and a recoverable result. |
| 13 | Suite delivery and OS preparation | Selectable product installer, shared dependency bundling, customer package updates, tiered safe activation, repair/rollback, launch health, uninstall and authorised user-space system adapters. | Install selected products on a clean machine without a compiler; update, defer or restart safely, roll back a failed activation and uninstall without losing user data; privileged operations need approval and recovery evidence. |

The requested design is a user-composed canvas, including a black or other chosen
background, readable Umicom identity, movable menus and panels, colour-presented
typed groups and independent windows across monitors. These are target
requirements. Source integration of a launcher or layout model does not establish
that the complete visual design has been delivered.

## Agreed desktop and delivery requirements

These requirements extend priorities 3, 8 and 13; they are not a second delivery
order. Approval records the intended behaviour, not a completed implementation.
The current source foundations include application manifests and launch models,
installer selection, change planning and a configurable native build controller.
The complete journeys below still require integration and acceptance evidence.

### Live desktop and installed-application registry

Framework supplies the desktop environment, shared layouts, window management,
taskbar, application catalogue and session services. Desk selects those services
as a product; other applications can use the same catalogue and windowing.
One Framework registry must distinguish a registered product from an installed,
compatible, permitted and healthy application. Folder presence alone is not
permission to launch it.

Installation, removal and update events should refresh open launchers without
restarting their hosts. Keep selections, running sessions and failure reasons
stable during refresh. A periodic or explicit rescan must repair missed events.
The current source update adds a Framework-owned Desktop Home with searchable
tiles, shared application selection and governed launch requests. An explicitly
configured monitor checks the canonical GUI names of already-registered built-in
products in Desk's executable directory. It updates installation evidence without
restarting Desk or starting an application. Unchanged refreshes retain controls;
removing an executable does not erase its still-running process record.
The topmost Desk application picker delegates launch requests to that same
runtime instead of starting a separate process through its default lookup.

This is source integration, not completed package installation or a new external
application registry. It does not establish signature, ABI or startup readiness.
Native regressions have been added but not run. The current Desk process adapter
reports cross-process window activation as unsupported instead of claiming it
brought a window forward. Full package discovery, acknowledged window activation,
embedded product sessions and native acceptance remain outstanding. Follow
[Desktop Home validation](../validation/DESKTOP_HOME_VALIDATION.md) to check the
implemented path after building it.

### Developer builds and customer updates are separate

In a developer workspace, Framework discovers changed files and dependencies,
then requests only affected build and test targets from the configured native
build tools. Header, resource and configuration changes must include dependent
targets; this is not simply a list of changed C files. Existing configurable
quiet-time verification and build scheduling remain the starting point. A manual
trigger skips the wait, not the quality or test gates.

Customers receive verified prebuilt packages. They must not need source code,
Git or a compiler to update an installed product. An available update, a staged
package and an active running version are separate states. Acceptance includes
repeated no-change builds, a shared-header dependency change, a failed check and
a package update on a machine without a development toolchain.

### Safe activation with restart fallbacks

Use the least disruptive supported activation method, not unconditional live
replacement. Validated declarative resources can refresh through their owner.
An isolated service can restart after work is paused and its state is saved.
Native code reload requires an explicit compatibility and lifetime contract;
modules without that contract use an application restart. A shared runtime or
system change may need a coordinated session or system restart.

Unsaved work, active orders, payments and other critical operations can defer
activation. Never overwrite a loaded binary or unload code while callbacks or
workers still use it. Keep the previous usable package and test failed health
checks, interrupted activation and rollback. Ordinary incremental compilation
does not prove that live code replacement is safe.

### Recursive repository publication

One C Framework operation should discover the root and all configured nested
repositories, review the complete eligible change set, and publish children
before recording their revisions in parents. It uses `git add -A` semantics
inside each repository, honours exclusions, checks for private material and
generates a message from staged changes when requested. Ignoring a file does not
protect it if it is already tracked; that case must stop publication for review.

Existing single-repository publication is a foundation, not proof of recursive
success. Failed commits, rejected pushes, detached branches, conflicts and
unpublished child commits need a per-repository result and a safe retry. A parent
must not be reported synchronized while a required child publication failed.

### One-command graphical delivery

A native Umicom request should discover the configured graphical products and
their dependencies, prepare a reviewable plan, configure when necessary, build,
test, stage and verify a runnable installation. Developers should not have to
list every module. Installation, application launch and repository publication
remain separate explicit permissions; an ordinary build does not imply them.

Studio and the other GUI clients display the same Framework plan, progress,
cancellation and diagnostic results. A graphical delivery cannot silently fall
back to a console executable. Clean-machine startup, resources and runtime
library availability must be tested before the delivery is called ready. No new
command spelling or all-in-one success is claimed until that path is implemented.

### Selectable installer

The installer should offer one, several or all eligible products and explain
required shared dependencies and disk use before making changes. Reuse the
Framework selection model and package services. Support repair, update,
uninstall and rollback without deleting user projects or saved preferences.
Validate package identity, integrity, origin and compatibility before staging.

Acceptance covers partial selections, dependency sharing, interrupted installs,
insufficient space and removal of one product while another still needs the
same runtime. Installation success must not bypass each product's startup and
domain-readiness checks.

### Umicom OS reuse boundary

Portable Framework user-space services can support future OS desktop sessions,
application discovery, packages, settings, process supervision and recovery
interfaces through authorised platform adapters. This follows the accepted
[kernel boundary](ADR-0002-linux-kernel-boundary.md) and
[Control Centre boundary](ADR-0008-os-control-centre-boundary.md).

A kernel-safe subset, if needed, must be explicitly selected, dependency-audited
and built separately with bounded C interfaces. It must not pull GTK, hosted C
library requirements, user-space allocation, files, threads or service startup
into a kernel. Boot and minimal recovery remain independently usable when
Framework user space fails. This records a reuse boundary, not a new kernel
choice or a claim that Umicom OS is implemented.

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

The ordered library archive reuses the existing layout codec inside a bounded,
versioned envelope. Its primary and previous-valid records are written in one
owned Data Server transaction. Failed reads keep the current session unchanged;
failed saves do not adopt another writer's revision. A confirmed Restore reads
fresh evidence, so a missing archive or recoverable error can be retried without
restarting the host. This is layout recovery, not complete session recovery.

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
