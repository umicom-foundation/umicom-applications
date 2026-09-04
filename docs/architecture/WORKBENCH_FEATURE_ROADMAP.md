# Umicom Workbench Feature Roadmap

**Status:** Living feature roadmap  
**Owner:** Umicom Foundation  
**Revision control:** Git history.

## Roadmap policy

This roadmap describes durable capability areas rather than numbered deliveries. Priorities may change, but Framework ownership, application coverage and acceptance requirements remain fixed.

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

- application catalogue;
- multiple application-surface sessions;
- closeable and reorderable application tabs;
- transfer between host windows;
- new independent host windows;
- multi-monitor restoration;
- session checkpoint and recovery;
- security and unsaved-work close policy.

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
- native detached windows;
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
