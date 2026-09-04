# Umicom Product Design and Application Architecture Governance

**Status:** Canonical living standard  
**Owner:** Umicom Foundation  
**Project lead:** Sammy Hegab  
**Last reviewed:** 4 September 2026  
**Revision control:** Git history; do not create numbered copies of this file.

> **Governing rule:** Umicom Framework is the single source of truth and the controlling implementation for every reusable product, application, domain, service, presentation and operational capability. Applications select and apply Framework capabilities; they do not recreate them.

## Purpose

This document prevents product-design and application-architecture decisions from being lost in conversation history. It defines which records are authoritative, how decisions are maintained, what every implementation must preserve, and how the complete application family proves adoption.

Chat discussion is useful for exploration, but it is not the durable project record. A decision becomes binding only when the relevant source-controlled specification and Product Decision Register are updated.

## Authority and conflict resolution

The authority order is:

1. Approved records in `PRODUCT_DECISION_REGISTER.md`.
2. This governance standard.
3. Canonical product, UX, application and domain specifications.
4. `APPLICATION_FEATURE_COVERAGE.md` and `WORKBENCH_FEATURE_ROADMAP.md`.
5. Public Framework contracts, conformance tests and accepted repository structure.
6. Issues, implementation notes and task descriptions.
7. Chat history and exploratory research.

Source and tests are authoritative for what is currently implemented. Approved documentation is authoritative for what the product is required to become. A contradiction is a defect or an explicitly proposed decision change; it is not a silent change of direction.

## Mandatory documentation protocol

Every design-affecting delivery must:

1. Read the current governance standard and decision register.
2. Identify the approved decisions that govern the work.
3. Update the relevant architecture or product specification with the source.
4. Add or update a decision when direction changes.
5. Update coverage for every registered application.
6. Update the feature roadmap and known limitations.
7. Record validation evidence.
8. Include only genuinely changed documentation in the project-structured archive.
9. Use durable feature-oriented filenames.
10. Never rely on assistant memory or chat history as the only record.

A design-affecting implementation is incomplete until the documentation is current.

## Decision lifecycle

| Status | Meaning |
|---|---|
| Proposed | A concrete option is documented for review but is not binding. |
| Approved | The decision is binding for design and implementation. |
| Deferred | The decision remains relevant but selection or implementation is postponed. |
| Rejected | The option must not be implemented without reopening the decision. |
| Superseded | A later approved record replaces it; the original remains for history. |

Every decision records a stable identifier, title, status, statement, rationale, constraints, affected capabilities, compatibility impact and acceptance evidence.

## Canonical architecture

```text
Umicom Framework Master Controller
│
├── lifecycle, policy and capability composition
├── universal application host and workbench services
├── commands, queries, events and typed context channels
├── Data Server and durable state
├── security, approvals, diagnostics and observability
├── frontend-neutral models and view contracts
└── bounded Slave Controllers, services, engines and workers
    │
    ├── development capabilities
    ├── trading and financial capabilities
    ├── banking, treasury and accounting capabilities
    ├── AI and knowledge capabilities
    ├── creative and engineering capabilities
    └── operational and security capabilities

Thin Umicom applications
│
├── stable application identity
├── selected Framework application experience
├── product configuration and operating mode
├── approved adapters and permissions
└── genuinely product-specific composition or behaviour
```

The Master Controller is the root authority and composition point. It delegates bounded work and must not become an unbounded container for domain logic or native widgets.

## Framework ownership

Umicom Framework owns the reusable implementation of:

- startup surfaces, lifecycle progress and failure recovery;
- application identity and headers;
- host windows and application-surface sessions;
- application, document, tool and layout tabs;
- application and panel catalogues;
- panel definitions, instances, chrome and state;
- docking, floating, reattachment, movement, resizing, maximise and auto-hide;
- multi-monitor topology and restoration;
- named layouts, editing, transactions, persistence and migration;
- typed context-linked panel groups;
- truthful command availability and disabled reasons;
- empty, loading, ready, degraded, failed and recovery states;
- appearance, design tokens, accessibility and responsive behaviour;
- reusable grids, trees, inspectors, charts, editors and domain panels;
- controllers, services, commands, queries, events and view contracts;
- shared domain capabilities;
- persistence, security, audit, observability, testing, packaging and deployment;
- frontend adapters and frontend-conformance tests.

No application repository may contain a second generic implementation of these mechanisms.

## Application ownership

An application may provide:

- application identifier, name, icon and descriptive text;
- selected Framework experience and default profile;
- required and optional capabilities;
- operating modes;
- approved adapter choices;
- permissions and policy configuration;
- product-specific navigation labels;
- genuinely product-specific workflows that are not reusable elsewhere.

Applications never call another application's private API. Cross-application communication passes through Framework contracts.

## Universal product-design standard

Every graphical application applies this hierarchy:

```text
Startup surface
→ Workbench Host window
→ Application-surface tab
→ Application header
→ Product workspace
→ Document/tool tabs and optional layout tabs
→ Docked, floating or detached panels
→ Activity, notification and status areas
```

### Startup and identity

Startup presents truthful work, progress, operating mode, failure and recovery. The header presents the Umicom icon, complete product name, active context, operating mode, health state, search, notifications and native window controls.

### Tabs

Application tabs, document or tool tabs and layout tabs are separate concepts. Each has independent identity, close policy, persistence and restoration. A plus action opens the appropriate Framework catalogue.

### Panels and windows

Every eligible panel declares close, hide, restore, move, resize, dock, split, tab, maximise, auto-hide, detach, reattach and multi-monitor capabilities. Mutations update the toolkit-neutral model before native widgets are rebuilt.

### Layouts

Normal mode remains task-focused. Edit Layout mode exposes arrangement controls. Changes are transactional, validated and reversible. Default layouts are Framework experience data. User layouts are user-owned state persisted through Framework services.

### Context linking

Linked groups are typed and accessible. Colour is a visual cue only. Group identity, name, role and context type are explicit.

### Commands

Every visible command is Available, Unavailable with reason, Busy, Awaiting approval, Requires setup, Requires connection, or Failed with recovery. Frontends display command state; product controllers determine eligibility.

### Product content

Ordinary panels show user tasks and authoritative state. Internal identifiers, raw keys and binding evidence remain available through a permission-aware Framework Developer Inspector.

## Application-family obligation

Every registered application must adopt the same Framework lifecycle, host, tabs, panels, layouts, command-state, accessibility and persistence concepts. Shared updates occur once in Framework. Application repositories change only when identity, profile, composition or genuinely product-specific behaviour requires it.

## Source-preservation constraints

- Do not remove an existing feature to simplify redesign or migration.
- Do not rename existing variables, public functions, structures, constants, files or directories without an approved compatibility requirement.
- Do not rewrite existing comments unless related implementation is enhanced or the comment becomes inaccurate.
- Preserve banners, authorship, licences, tooltips, commands, layouts, tests and accessibility behaviour.
- Do not add numbered replacement identifiers as a shortcut for compatible evolution.
- Do not place reusable logic in application repositories.
- Do not include another application's private headers.
- Do not store native widget pointers in domain models.
- Do not bypass Data Server, Risk Server, Execution Server, Security, Approval or Audit authorities.
- Use C23 and stable C ABI boundaries for Framework public contracts.
- Keep toolkit and provider types inside private adapters.
- Include every declaration directly.
- Define ownership, lifetime, thread, capacity, error, cancellation and rollback behaviour.
- Use bounded text operations and preserve termination.
- Keep frontend work on the designated frontend thread.
- Implement Umicom-controlled automation as native Framework capabilities where practical.
- Add tests with behaviour, not after a feature is declared complete.

## Documentation constraints

- Use feature-oriented filenames.
- Do not use delivery numbers, phase labels or numbered version copies in canonical filenames.
- Use Git history for revision.
- Use Umicom terminology in product and architecture documentation.
- Translate research observations into original Umicom requirements and mock-ups.
- Update an existing canonical document instead of creating overlapping replacements.
- Include purpose, decisions, ownership, workflows, coverage, validation, limitations and roadmap.

## Delivery rejection conditions

Reject a delivery when:

- a shared mechanism is implemented in an application instead of Framework;
- a registered application is omitted from coverage without an explicit reason;
- a feature, tooltip, command, layout or test is removed without approval;
- source names or comments are rewritten without necessity;
- visible commands misrepresent availability;
- layout changes cannot be cancelled or restored;
- internal identifiers dominate normal product views;
- accessibility or responsive behaviour regresses;
- documentation and decision records are not updated;
- the all-application build and relevant tests are not run;
- unchanged files are included merely to increase delivery size.

## Required validation

Every shared product-design or architecture delivery records evidence for:

- complete all-application configuration and build;
- strict warning checks;
- Framework unit and contract tests;
- frontend adapter tests;
- application composition and startup tests;
- application coverage;
- layout save, restore, reset and recovery;
- panel lifecycle and multi-window behaviour;
- keyboard navigation and accessible names;
- supported window sizes and display scaling;
- architecture-conformance checks;
- absence of duplicated Framework mechanisms in applications.

## Canonical governance set

```text
docs/
├── governance/
│   ├── PRODUCT_DESIGN_AND_ARCHITECTURE_GOVERNANCE.md
│   ├── PRODUCT_DECISION_REGISTER.md
│   ├── APPLICATION_FEATURE_COVERAGE.md
│   ├── DECISION_RECORD_TEMPLATE.md
│   └── REPOSITORY_ARCHITECTURE_AUDIT.md
└── architecture/
    ├── UNIVERSAL_APPLICATION_WORKBENCH.md
    ├── FRAMEWORK_APPLICATION_ADOPTION.md
    └── WORKBENCH_FEATURE_ROADMAP.md
```

Every future design discussion ends with an update to the relevant canonical document. Every future source delivery includes the changed documentation.
