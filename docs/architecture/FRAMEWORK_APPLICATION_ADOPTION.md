# Framework Application Adoption

**Status:** Canonical application composition standard  
**Owner:** Umicom Foundation  
**Revision control:** Git history.

## Purpose

This document defines how every application adopts Umicom Framework without recreating reusable implementation.

## Required composition

```text
Application launcher
→ Framework application portfolio lookup
→ Framework experience lookup
→ capability and policy resolution
→ Framework Master Controller composition
→ bounded Slave Controller startup
→ Framework startup and workbench presentation
→ product-specific commands and state
```

## Application profile input

A thin application provides only the information needed to select and configure Framework capabilities:

```text
application identifier
display name and icon
experience identifier
operating mode
required and optional capabilities
approved adapters
permissions and policy
genuinely product-specific command handlers
```

## Prohibited application-local mechanisms

Application repositories must not create another:

- generic startup engine;
- generic application header;
- generic application or tool tab host;
- generic panel frame;
- docking or floating engine;
- layout schema or persistence store;
- context-group engine;
- appearance engine;
- command-state renderer;
- generic workspace recovery system;
- shared business or domain service already owned by Framework.

A temporary compatibility layer may forward an existing application API to Framework during migration. It must not become a permanent second implementation.

## Controlled migration

```text
Inventory current application behaviour
→ preserve its complete feature set
→ identify the owning Framework contract
→ enhance Framework where required
→ add Framework tests
→ adapt the application through a thin compatibility layer
→ validate feature parity
→ remove duplicate implementation only after all callers have migrated
```

Existing features, source names and comments are preserved unless an approved compatibility change requires otherwise.

## Build and dependency rules

- Applications consume public Framework targets.
- Applications do not include Framework internal headers.
- Applications do not include another application's private headers.
- Framework is configured once by the suite.
- Shared warning and sanitizer policy is applied from the composition root.
- The all-application configuration validates the complete registered estate.
- Child repositories commit before the parent records their revisions.

## Product behaviour

A product may own genuinely specific use cases, but it still uses Framework command, event, view-model, persistence, security, approval and audit contracts.

Example:

```text
Product panel
→ typed Framework command
→ product or domain Slave Controller
→ Framework service authority
→ authoritative state change
→ event and view-model refresh
→ Framework adapter rendering
```

The panel cannot bypass the owning service or mutate another module's state directly.

## Adoption evidence

For every application, acceptance requires:

- portfolio registration;
- experience registration;
- declared capabilities;
- default layout resolution;
- startup lifecycle adoption;
- workbench and panel adoption;
- no duplicated Framework mechanism;
- application composition tests;
- startup smoke test;
- all-application build evidence;
- entry in `APPLICATION_FEATURE_COVERAGE.md`.
