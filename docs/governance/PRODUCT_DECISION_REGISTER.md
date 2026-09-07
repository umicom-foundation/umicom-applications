# Umicom Product Decision Register

**Status:** Canonical living register  
**Owner:** Umicom Foundation  
**Last reviewed:** 7 September 2026  
**Revision control:** Git history; do not create numbered copies.

> A chat statement is not a durable project decision until it appears here or in an approved linked decision record.

## Register summary

| Decision | Status | Title |
|---|---|---|
| GOV-001 | Approved | Durable documentation is mandatory |
| LAYOUT-003 | Approved requirement; source integrated | Canvas geometry extends the existing workspace owner |
| ARCH-001 | Approved | Umicom Framework is the single source of truth |
| ARCH-002 | Approved | The Master Controller delegates bounded work |
| ARCH-003 | Approved | Applications are thin independently runnable clients |
| ARCH-004 | Approved | The Data Server is the sole persistence authority |
| UX-001 | Approved | Framework owns the universal application workbench |
| UX-002 | Approved | Every graphical application follows one visible hierarchy |
| UX-003 | Approved | Every application has a truthful startup lifecycle |
| UX-004 | Approved | Application, document and layout tabs are distinct |
| UX-005 | Approved | Every eligible panel has a complete lifecycle |
| UX-006 | Approved | Normal mode and Edit Layout mode are separate |
| UX-007 | Approved | Layout state is user-owned and the mechanism is Framework-owned |
| UX-008 | Approved | Context-linked panels use typed channels |
| UX-009 | Approved | Every visible command is truthful |
| APP-001 | Approved | Every registered application is in scope |
| CODE-001 | Approved | Existing features, names and comments are preserved |
| CODE-002 | Approved | C23 and stable C ABI govern shared boundaries |
| CODE-003 | Approved | Public Framework contracts govern adapter extensions |
| DOC-001 | Approved | Documentation is feature-oriented and uses Umicom terminology |
| DELIVERY-001 | Approved | Every delivery includes documentation and evidence |
| UX-017 | Approved | The application header exposes one Framework-owned application catalogue |
| UX-018 | Approved | The active application is presented as a stable application-surface tab |
| HOST-001 | Approved | Application opening delegates to host policy with a process fallback |
| UX-019 | Approved | Framework-owned SVG is the only native application identity mark |
| UX-020 | Approved requirement; graphical launchers source integrated | Product identity belongs in the topmost window titlebar |
| UX-021 | Approved requirement; source integrated | Named tool tabs use recoverable temporary flyouts |

## Approved decisions

### Navigation and transient presentation clarification

Normal Open/Focus must not require unlocking panel movement. It selects an
existing visible panel, reveals a saved auto-hide tool or reopens an ordinary
hidden dock tool through the existing workspace owner. It does not create an
instance or move it. Creating and repositioning panels remain Edit Layout
operations. Unavailable entries explain the missing instance or protection.

Internal maximisation is a temporary presentation of the same panel body,
using the existing Framework maximise-mode contract. It never overwrites saved
geometry or starts another edit. Restore, focus on a different tool and accepted
structural changes return the body to its original frame. Native detached-window
maximisation remains distinct. This clarifies UX-005, UX-006 and UX-009; it does
not claim docking, session recovery or product workflows are complete.

### Explicit graphical and console launch declarations

Application manifests declare native and console basenames separately while
retaining the legacy executable field. An additive Framework launch-spec API
keeps the original manifest structure unchanged. Known native names are checked
against the canonical portfolio. Builds use configured targets, so a headless
configuration is not forced to build a graphical target.

Legacy/external manifests without a native declaration do not acquire a guessed
graphical target. Malformed explicit declarations are rejected. GUI availability,
installed executable discovery and domain readiness remain separate evidence.
All registered applications must carry declarations checked by the C contract
regression. New implementation and substantive regression coverage remain C.

### UX-020 — Product identity belongs in the topmost window titlebar

The official SVG and fixed application name belong at the left of the actual
topmost window titlebar. Document and project context occupy the middle; window
controls stay at the right. Menus, toolbars and the workspace are separate rows
below. Do not repeat the same application identity in an inner command strip.

This clarifies the placement described by UX-018; it does not remove application
sessions or lifecycle guards. Studio, shared suite launchers and Desk adopt the
shared GTK titlebar in source. Existing suite and Desk identities transfer into
the titlebar without constructing another catalogue or losing its selections.
All native hosts still need visual acceptance. The artwork and
user font choices remain unchanged. New unpresented-widget tests check the
titlebar slot and ancestry, but native visual acceptance remains pending.

The final main window must receive its titlebar before realization. Deferred
product startup uses a temporary splash surface rather than realizing that
main window too early. Startup cancellation removes pending callbacks; it must
not cause a later main window to appear. Desk disconnects its view callbacks and
cancels its poll source before releasing the state they borrow.

### UX-021 — Named tool tabs use recoverable temporary flyouts

Framework renders explicit auto-hide members as named edge tabs. Selecting a
tab opens that tool over the workspace; another tab switches it. X collapses
the flyout while keeping its tab and contents. This temporary state does not
change a saved layout revision. Docking and ordinary tool hiding go through the
existing model owner. Protected-panel pinning is a separate permission.

Only capable action owners opt into normal-mode Dock, Auto Hide and recoverable
Close. Read-only hosts must not display enabled actions they cannot perform.
Old saved layouts are kept. A new named product-default copy resets presentation
without replacing older arrangements, shared context routing or checkpoints.
Native switching, draft retention and teardown have source tests; execution is
still required before release.

### Canvas input extension to LAYOUT-003

The existing Framework geometry projector supports all four edges and four
corners. Old move and southeast-resize enum values remain unchanged. Resizing
anchors the opposite edge; an untouched axis and zero motion remain exact
no-ops. Grid snapping and minimum dimensions apply only to an axis being changed.

Keyboard movement is a temporary view preview on a focused panel title. Arrows
move, Shift plus arrows resize the bottom/right edges, Enter queues acceptance,
and Escape or focus departure cancels. Mouse and keyboard use the same deferred
revision-checked request and existing workspace edit owner. Lock, protection and
resize permissions are not bypassed. No second layout transaction is introduced.

### GOV-001 — Durable documentation is mandatory

**Status:** Approved  
**Decision:** Every approved product-design, UX, application-architecture, coding, delivery, security, data-ownership or roadmap decision must be recorded in source-controlled project documentation. Chat discussion is provisional until the relevant canonical document and decision register are updated.

**Rationale:** The product family is too large and long-lived to depend on conversational memory. Durable documentation makes decisions reviewable, teachable, auditable and recoverable.

**Constraints**

- Every design-affecting delivery updates the relevant canonical documents.
- Earlier decisions are never silently deleted; a replacement marks them as superseded.
- Git history records revisions; numbered copies of canonical filenames are not created.

**Acceptance evidence**

- A reviewer can understand the intended behaviour without reading the originating chat.
- The decision register records status, rationale, constraints and acceptance evidence.

### ARCH-001 — Umicom Framework is the single source of truth

**Status:** Approved  
**Decision:** Umicom Framework owns, controls and implements every reusable capability. All applications consume Framework contracts and must not recreate, fork or duplicate a reusable mechanism.

**Rationale:** One implementation prevents incompatible shells, services, controllers, layouts, persistence models and operational rules across the application family.

**Constraints**

- Reusable implementation belongs in Framework libraries, controllers, models, services, commands, events, view contracts, adapters and tests.
- Application repositories contain identity, configuration, product composition and genuinely product-specific behaviour only.
- A capability used, or reasonably reusable, by more than one application belongs in Framework.

**Acceptance evidence**

- Repository audits find no second generic implementation in application repositories.
- Shared defects are fixed once in Framework and validated through every consumer.

### ARCH-002 — The Master Controller delegates bounded work

**Status:** Approved  
**Decision:** The Framework Master Controller is the root composition and policy authority. It coordinates lifecycle, capability registration, startup, shutdown and high-level routing while delegating bounded domain work to Slave Controllers, services, engines and workers.

**Rationale:** Central authority is required for consistency, while bounded ownership is required for testability and maintainability.

**Constraints**

- The Master Controller does not contain product-specific business logic.
- Slave Controllers communicate through public commands, queries and events.
- No controller reads another module's private state.

**Acceptance evidence**

- Lifecycle and dependency tests run without starting a complete application.
- Domain controllers can be tested with injected ports and simulated adapters.

### ARCH-003 — Applications are thin independently runnable clients

**Status:** Approved  
**Decision:** Every application remains independently runnable, buildable, testable and packageable, but reusable runtime, shell, presentation, domain services and operational infrastructure are supplied by Umicom Framework.

**Rationale:** Focused products remain understandable while sharing one governed foundation.

**Constraints**

- Applications never call another application's private API.
- Cross-application communication uses Framework commands, queries, events, streams or application-surface sessions.
- A product selects capabilities without owning a parallel framework.

**Acceptance evidence**

- Each registered application resolves a Framework portfolio definition and experience profile.
- Each application can run independently and can participate in a shared host where supported.

### ARCH-004 — The Data Server is the sole persistence authority

**Status:** Approved  
**Decision:** Layouts, sessions, product state, audit evidence, user preferences and other Umicom-owned durable state are persisted through Framework Data Server contracts rather than direct application database access.

**Rationale:** A single persistence authority protects transactions, schema evolution, audit, recovery and adapter neutrality.

**Constraints**

- Applications and frontend adapters do not issue raw SQL for Umicom-owned state.
- Persistence is exposed through typed repositories, commands or services.

**Acceptance evidence**

- Static checks reject direct persistence access from application and presentation layers.
- Crash-safe save, restore and migration journeys are tested.

### UX-001 — Framework owns the universal application workbench

**Status:** Approved  
**Decision:** Startup presentation, host windows, application-surface sessions, application tabs, document and tool tabs, layout tabs, panel chrome, docking, floating, layout editing, layout persistence, context linking and multi-monitor restoration are Framework capabilities.

**Rationale:** Every graphical application requires the same structural mechanics even though its product content differs.

**Constraints**

- No application repository contains a second generic splash engine, tab host, docking engine, panel frame, layout store or workspace engine.
- Application profiles configure the shared implementation.
- Frontend adapters implement the same toolkit-neutral semantics.

**Acceptance evidence**

- The complete application family displays consistent lifecycle, panel and layout behaviour.
- Framework tests validate shared mechanics; application tests validate composition and product journeys.

### UX-002 — Every graphical application follows one visible hierarchy

**Status:** Approved  
**Decision:** Every graphical application follows the sequence: startup surface, host window, application-surface tab, application header, product workspace, document or tool tabs, optional layout tabs, panels, activity and status areas.

**Rationale:** A predictable hierarchy reduces learning cost and makes skills transferable between applications.

**Constraints**

- Product differences are expressed by profiles, panels, commands and data, not incompatible shell mechanics.
- Normal mode does not permanently expose layout-editing controls.

**Acceptance evidence**

- A user familiar with one Umicom application can operate the common mechanics of another.
- Responsive tests preserve the hierarchy at supported sizes and scaling levels.

### UX-003 — Every application has a truthful startup lifecycle

**Status:** Approved  
**Decision:** Each graphical application presents an original Umicom startup surface with icon, application name, build identity, operating mode, current task, measurable progress, failure information and recovery actions when startup is not effectively instantaneous.

**Rationale:** Users need honest progress and recoverable failures while modules, services, adapters and layouts are prepared.

**Constraints**

- Applications provide startup tasks and identity; Framework owns rendering and lifecycle.
- Sensitive credentials never enter generic presentation state or logs.

**Acceptance evidence**

- Cold-start progress corresponds to real work.
- Failure leaves a readable state, diagnostic identifier and recovery path.

### UX-004 — Application, document and layout tabs are distinct

**Status:** Approved  
**Decision:** Application tabs switch complete product sessions; document or tool tabs switch content within one product; layout tabs switch named panel arrangements. Each level has independent identity, close policy, persistence and restoration.

**Rationale:** Conflating tab levels creates ambiguous close behaviour and lost state.

**Constraints**

- The plus action at each level opens the appropriate Framework catalogue.
- Closing an application tab cannot bypass unsaved-work or active-operation policy.

**Acceptance evidence**

- Automated tests verify all three tab levels independently.
- Restoration recreates the correct application, document and layout identities.

### UX-005 — Every eligible panel has a complete lifecycle

**Status:** Approved  
**Decision:** Every eligible panel, section and tool window supports close or hide, restore, move, resize, dock, split, tab, maximise, auto-hide, detach, reattach and multi-monitor placement according to declared capabilities.

**Rationale:** Panel behaviour must be consistent and complete across the application family.

**Constraints**

- Panel identity is separate from placement and transient session state.
- Closing an instance never removes its catalogue definition.
- Mutations update the authoritative layout model before native widgets are rebuilt.

**Acceptance evidence**

- Every declared panel action has a working journey or a truthful unavailable reason.
- Cancel restores the complete pre-edit layout and context-link state.

### UX-006 — Normal mode and Edit Layout mode are separate

**Status:** Approved  
**Decision:** Normal mode prioritises product work and compact chrome. Edit Layout mode reveals movement, docking, resizing, catalogue, grouping, save, apply, cancel, reset and lock controls.

**Rationale:** Permanent layout controls create clutter and compete with product commands.

**Constraints**

- Layout mutation is transactional and reversible.
- Locked layouts cannot be changed silently.
- Existing layout features remain available through the appropriate mode.

**Acceptance evidence**

- Entering Edit Layout mode is visually and accessibly unambiguous.
- Cancel restores the prior snapshot; Apply and Lock accept a validated result
  in memory. An explicit Save action writes its durable checkpoint.

### UX-007 — Layout state is user-owned and the mechanism is Framework-owned

**Status:** Approved  
**Decision:** Users own named arrangements and workspace preferences. Framework owns the schema, validation, editing, migration, persistence, recovery and rendering.

**Rationale:** Users require customisation without fragmenting the implementation.

**Constraints**

- Default layouts are registered in Framework application experiences.
- User layouts are stored through the Data Server.
- Applications do not define another layout format.

**Acceptance evidence**

- Create, duplicate, rename, save, restore, reset, export and import are tested.
- Missing panels or monitors degrade safely without corrupting the last good layout.

### UX-008 — Context-linked panels use typed channels

**Status:** Approved  
**Decision:** Panels may join named and colour-presented groups as source, destination or bidirectional participants. The underlying Framework channel transports typed selections such as project, document, instrument, account, legal entity, model or connection.

**Rationale:** One interaction concept must work across development, finance, creative, engineering and operational products.

**Constraints**

- Colour is presentation metadata, never the only identifier.
- Incompatible context types are rejected clearly.
- Group membership participates in layout transactions and restoration.

**Acceptance evidence**

- Linked panels update only for compatible context contracts.
- Accessibility exposes group identity, name, role and state.

### UX-009 — Every visible command is truthful

**Status:** Approved  
**Decision:** A visible command is Available, Unavailable with reason, Busy, Awaiting approval, Requires setup, Requires connection, or Failed with recovery. It must not appear usable and then fail generically.

**Rationale:** Trust depends on accurate presentation of capability, policy and operational state.

**Constraints**

- Command state is part of the Framework presentation contract.
- Product controllers remain the business authority.
- Frontend adapters render state but do not invent it.

**Acceptance evidence**

- Acceptance tests enumerate visible commands in each default workspace.
- Unavailable commands expose an accessible explanation.

### APP-001 — Every registered application is in scope

**Status:** Approved  
**Decision:** Every shared product-design, workbench, lifecycle, panel, layout, accessibility and command-state enhancement is assessed against every registered application. New applications automatically enter the same coverage obligation.

**Rationale:** The product family must not split into first-class and forgotten applications.

**Constraints**

- Shared changes are implemented once in Framework.
- Application repositories change only when identity, composition or genuinely product-specific behaviour requires it.
- Coverage never justifies copied code or meaningless edits.

**Acceptance evidence**

- Each delivery contains an application coverage record.
- The all-application build and test configuration is used before completion.

### CODE-001 — Existing features, names and comments are preserved

**Status:** Approved  
**Decision:** Existing features are not removed for convenience. Existing variables, public functions, structures, constants and files are not renamed unnecessarily. Existing comments are not rewritten unless related implementation is enhanced or the comment becomes inaccurate.

**Rationale:** Large cosmetic churn hides defects, damages history and risks regressions.

**Constraints**

- Enhancements are additive or backward compatible unless an approved breaking decision exists.
- Tooltips, commands, panels, layouts, tests and accessibility behaviour are retained.
- Version suffixes are not added to identifiers as a shortcut for evolution.

**Acceptance evidence**

- Reviews show focused changes with preserved history.
- Compatibility tests cover existing public contracts.

### CODE-002 — C23 and stable C ABI govern shared boundaries

**Status:** Approved  
**Decision:** Framework core and public module boundaries use C23 and a stable C ABI. Ownership, lifetime, threading, errors, cancellation, capacity and failure rollback are explicit.

This also governs reusable developer tools, repository publication, automated
builds, test orchestration and application launching. New functionality is
implemented as C Framework APIs first, then exposed through native command-line
and graphical clients. Every application requires a GUI entry point; a console
program may supplement it but must not silently replace it.

**Rationale:** Predictable boundaries are necessary for reusable modules, adapters, plugins and multiple frontends.

**Constraints**

- Exceptions, private toolkit objects and language-specific containers do not cross the public C ABI.
- Every source file directly includes the declarations it uses.
- Text operations are bounded and GUI objects remain inside frontend adapters.
- New Python or PowerShell scripts do not implement product or developer-tool
  behaviour. Documented shell commands may invoke the native tools; build-system
  configuration remains configuration rather than a second runtime.
- Reuse existing Framework services before introducing another engine. Existing
  scripts are retained until a tested native replacement preserves their useful
  behaviour; this decision does not authorise deleting them without review.
- Assembly is used only for a justified platform-specific operation behind a
  documented C boundary, with a portable path where practical.
- All clients present Framework state through a GUI with truthful unavailable
  reasons. Native entry-point source is not evidence that product journeys pass.

**Acceptance evidence**

- Strict-warning builds contain no implicit declarations or unsafe conversions.
- Public headers compile in isolation and partial-failure tests prove cleanup.
- Native CLI and GUI paths exercise the same Framework implementation, with
  failure, cancellation and recovery coverage where those operations apply.
- Every registered application has a graphical build target and an independently
  recorded startup and user-journey result.

### CODE-003 — Public Framework contracts govern adapter extensions

**Status:** Approved  
**Decision:** Frontend adapters, shared renderers and application hosts must implement the current public Framework contracts. They must not introduce parallel callback types, substitute structure fields, private public-API copies, unofficial automation helpers or phantom headers. Existing compatible APIs remain available while enhanced behaviour uses an explicit Framework companion contract.

**Rationale:** The workbench is shared by every application. Contract drift in one adapter blocks the complete application estate and can silently create a second source of truth.

**Constraints**

- Inspect the current public header, implementation and callers before changing an adapter.
- Update a public header and its implementation atomically when a genuinely new contract is required.
- Access opaque models only through their public functions.
- Preserve existing function, variable and type names unless an approved migration makes a change unavoidable.
- A missing reusable contract is added to Framework; it is not invented privately inside an adapter or application.

**Acceptance evidence**

- Strict C23 compilation succeeds without implicit declarations, incompatible callbacks or undeclared fields.
- The workstation contract audit rejects known parallel symbols and undeclared headers.
- Every registered application builds against the same corrected Framework implementation.

### DOC-001 — Documentation is feature-oriented and uses Umicom terminology

**Status:** Approved  
**Decision:** Canonical documentation filenames and headings describe durable features and architecture. They do not use delivery numbers, phase labels or version-numbered copies. Product-design documentation uses Umicom terminology.

**Rationale:** Feature-oriented documentation remains useful after sequencing and research inputs change.

**Constraints**

- Git history records document revisions.
- Research observations are translated into original Umicom requirements and designs.
- Canonical product documentation does not name external reference products.

**Acceptance evidence**

- Automated governance checks validate filenames, required sections and prohibited terminology.

### DELIVERY-001 — Every delivery includes documentation and evidence

**Status:** Approved  
**Decision:** A source delivery is incomplete without updated design or architecture documentation, the decision register, application coverage, roadmap status and validation evidence relevant to the change.

**Rationale:** Implementation and project memory must evolve together.

**Constraints**

- Only genuinely changed source and documentation files are included.
- Archives match the repository root and preserve paths.
- No patch files or helper scripts are supplied unless explicitly requested.

**Acceptance evidence**

- The documentation explains features, ownership, application adoption, constraints, validation, limitations and roadmap.

## UX-014 — Application identity always remains visible

**Status:** Approved

The shared Framework header shows the Framework-owned packaged Umicom SVG mark.
The readable product name is always present. A missing packaged asset is a
release-quality defect: the UI does not draw a textual substitute, and the
packaging/conformance checks must report the missing resource.

## UX-019 — Framework-owned SVG is the only native application identity mark

**Status:** Approved  
**Decision:** Native headers and startup surfaces consume the contrast-aware SVG
mark from the Framework resource catalogue. The Windows `.ico` is retained for
shell integration, and optional PNG files are compatibility outputs only. No
application may copy the mark or render a textual `<>` substitute when the
packaged asset is missing.

**Rationale:** A single vector source stays sharp across platforms and display
scales, avoids raster colour/white-hole defects and lets one accessibility or
brand correction reach every application.

**Acceptance evidence:** ADR-0013, the shared GTK4 shell implementation,
configure-time resource checks and application-header validation all enforce
the same rule.

## UX-015 — Normal mode uses compact panel controls

**Status:** Approved

Normal mode prioritises product work while retaining close and the complete
panel command set through compact Framework-owned controls. Structural editing
controls become prominent only during Edit Layout mode.

## UX-016 — Duplicate navigation surfaces are consolidated

**Status:** Approved

A command, layout or window catalogue must have one primary presentation in a
workspace. Existing commands remain searchable and accessible when redundant
permanent strips are removed.

## LAYOUT-001 — Semantic regions use shared responsive bounds

**Status:** Approved

Left, centre, right, top, bottom and floating regions are materialised through
Framework geometry. The centre remains dominant and empty regions consume no
permanent split.

## LAYOUT-002 — Generic product panels avoid horizontal scrolling

**Status:** Approved

Generic panels scroll vertically and start at their logical left edge. A
specialised surface explicitly owns horizontal navigation when required.

## MIGRATION-001 — Build output and saved-layout migration are separate

**Status:** Approved

Deleting a build directory is not a layout migration mechanism. Framework
changes compile independently from versioned user-layout migration and an
explicit reset-to-product-default journey.

## UX-017 — The application header exposes one Framework-owned application catalogue

**Status:** Approved

**Decision:** The shared application header owns the searchable application
catalogue and its plus action. Catalogue rows are generated from the canonical
Framework application portfolio. An application repository must not maintain a
second list, menu or launcher implementation.

**Rationale:** One catalogue lets every graphical application discover the same
product family while keeping application identity, executable naming,
authorisation and maturity in Framework-owned data.

**Constraints**

- The catalogue uses stable application identifiers.
- The default launcher resolves packaged executables beside the running
  application and then uses the operating-system search path.
- Launch failure remains visible in the catalogue and does not pretend that a
  session opened.
- A host may replace process launch through the public callback without
  replacing the catalogue UI.
- Applications do not copy the portfolio into local arrays or menus.

**Acceptance evidence**

- Studio, Desk and product workstations obtain the same plus action through the
  shared GTK4 header.
- Search matches product name, purpose and stable identifier.
- Every visible catalogue row originates from the Framework portfolio.
- Unavailable executables produce a readable failure message.

## UX-018 — The active application is presented as a stable application-surface tab

**Status:** Approved

**Decision:** The Framework application header groups the Umicom mark, product
name, active workspace subtitle and operating-mode badge as one active
application-surface tab. New-window and close controls belong to the same
application lifecycle region.

**Rationale:** A recognisable active application surface creates the foundation
for several application sessions in one host without confusing application,
document and layout tabs.

**Constraints**

- The Framework-owned packaged Umicom SVG mark remains visible and is checked
  by packaging conformance before release.
- Application close routes through the native window close request, preserving
  product close guards and unsaved-work policy.
- The active application tab is not a document tab or a named layout tab.
- Existing titles, modes and appearance updates continue through the current
  public functions.

**Acceptance evidence**

- The existing title and snapshot APIs remain source-compatible.
- The active tab updates when the application title or workspace subtitle
  changes.
- Close invokes the owning window's normal close-request path.

## HOST-001 — Application opening delegates to host policy with a process fallback

**Status:** Approved

**Decision:** The shared header publishes one application-open callback using a
stable application identifier and an explicit standard or new-window mode. In
the absence of a host callback, the GTK4 adapter starts the executable resolved
from the canonical portfolio.

**Rationale:** The same UI must support the current independently runnable
applications and the future application-surface-session host without a second
launcher or a breaking API replacement.

**Constraints**

- The callback is borrowed and has an explicit controller lifetime.
- Default process launch never serialises application business state.
- In-host session attachment, transfer tokens and cross-window rehydration
  remain separate roadmap work.
- A failed host callback or missing executable leaves the current application
  fully usable.

**Acceptance evidence**

- A caller can install and later remove a host callback.
- The default implementation resolves canonical, repository-based and packaged
  executable naming conventions.
- New-window requests are distinguishable from standard host-policy requests.

## LAYOUT-003 — Canvas geometry extends the existing workspace owner

**Status:** Approved requirement; shared native source integrated, runtime
acceptance pending. Recorded 6 September 2026.

**Decision:** Use `UmiUiWorkspaceCustomisation` and its existing edit baseline
for independent in-canvas windows. A canvas item is not a centre tab and is not
a detached operating-system window. Do not create another layout registry,
session store or application-local geometry authority.

**Rationale:** A user-created layout must support independent rectangles while
preserving the same panel identity, product policy, context links and Cancel
behaviour. Sharing the implementation should not require duplicating it in
every client repository.

**Constraints**

- A valid empty layout is renderable. Canvas items do not consume dock-stack
  capacity. Coordinates are finite, bounded fractions of the viewport.
- Gesture previews do not mutate saved state. Completed requests carry a source
  revision and use the current edit; they do not start nested transactions.
- Geometry-only accepted changes retain provider widgets. Structural rebuilds
  need their own draft, focus and service-state preservation evidence.
- User-layout IDs retain the application prefix so canonical panel permissions
  are not lost. Import validates on a candidate before publishing live state.
- Releasing or replacing a host invalidates pending actions, including actions
  attached to retained old controls. No callback may retain a released owner.
- Studio must migrate its existing professional-workspace model into the shared
  native host. Its old GTK arrays must not be mirrored into a second owner.
- Native checkpoint adapters use the existing Data Server and UI layout codec.
  Memory-only backends must not claim restart durability. Studio's existing
  document/session persistence remains separate from canvas checkpoints.

**Acceptance evidence required**

Run the portable canvas projection test and the native workspace canvas test,
then record the default-to-blank-to-panel-to-move/resize-to-apply/cancel journey
in each adopting client. The Studio experience test does not certify Studio's
main GUI. No compiler, native launch or restart result is claimed here.

### Studio source integration record

The live Studio shell now constructs one shared native host and uses its
professional-workspace customisation model for outer-panel placement. Native
surface arrays are derived display information only; the separate GTK rollback
arrays are no longer an edit authority. The retained Editor body contains the
existing Framework document adapter. Provider body retention is opt-in so other
clients keep their established refresh behaviour.

Repository discovery, native presentation and personal session storage have
explicit off switches for the actual-Studio regression fixture. Existing
production entry points preserve their defaults. The offline VCS provider
reports unavailable; it must never imply a clean or successfully published
repository. No test execution or desktop acceptance is claimed by this record.

The UI distinguishes an in-memory Apply operation from explicit checkpoint
Save, and the old semantic session must not overwrite a custom canvas during
routine status synchronization. Editor
refreshes reconcile existing document views; unchanged buffers must survive
ordinary status ticks. These ownership changes require native acceptance.

### Native canvas checkpoint decision

The checkpoint bridge stores the last explicitly saved active layout, scoped
by application and workspace, using the existing Data Server chunk store and
UI layout codec. Separate record kinds prevent native canvas records from
being interpreted as semantic workbench-node documents. They do not introduce
a second geometry schema or a direct application database implementation.

A save compares the storage revision observed by the caller. It rotates only
a validated primary into the previous-checkpoint slot, inside one transaction.
A stale caller must restore explicitly before replacing a newer save. Restore
validates scope, registered tools, singleton identity, context membership and
geometry before publishing the model and native view. Failed recovery keeps
the current layout and preserves the damaged records for diagnosis.

If the primary metadata cannot provide a trustworthy revision, Save remains
blocked until an explicit repair can be performed. A content hash detects
corruption but does not authenticate the author. Reconciliation must not delete
apparently orphaned chunks after an incomplete or invalid manifest scan.

This source update does not claim a complete named-layout library, document
recovery, monitor migration, authenticated backups or native test success.
Offline constructors open no personal canvas database; tests can explicitly
borrow an isolated Data Server. The normal GTK storage helper opens SQLite in
the operating-system user's application configuration area, without a silent
memory fallback.

The OS work remains user-space preparation: session recovery, panel rendering,
resource discovery and authorised platform adapters can be reused. Kernel and
privileged-service development do not acquire the full Framework GUI dependency
graph. The OS research plan does not itself select a new kernel implementation.
