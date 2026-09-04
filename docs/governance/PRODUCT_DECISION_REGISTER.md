# Umicom Product Decision Register

**Status:** Canonical living register  
**Owner:** Umicom Foundation  
**Last reviewed:** 4 September 2026  
**Revision control:** Git history; do not create numbered copies.

> A chat statement is not a durable project decision until it appears here or in an approved linked decision record.

## Register summary

| Decision | Status | Title |
|---|---|---|
| GOV-001 | Approved | Durable documentation is mandatory |
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
| DOC-001 | Approved | Documentation is feature-oriented and uses Umicom terminology |
| DELIVERY-001 | Approved | Every delivery includes documentation and evidence |

## Approved decisions

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
- Cancel restores the prior snapshot; Apply and Lock persist a validated result.

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

**Rationale:** Predictable boundaries are necessary for reusable modules, adapters, plugins and multiple frontends.

**Constraints**

- Exceptions, private toolkit objects and language-specific containers do not cross the public C ABI.
- Every source file directly includes the declarations it uses.
- Text operations are bounded and GUI objects remain inside frontend adapters.

**Acceptance evidence**

- Strict-warning builds contain no implicit declarations or unsafe conversions.
- Public headers compile in isolation and partial-failure tests prove cleanup.

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
