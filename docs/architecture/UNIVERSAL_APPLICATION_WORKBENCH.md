# Umicom Universal Application Workbench

**Status:** Canonical product and interaction specification  
**Owner:** Umicom Foundation  
**Revision control:** Git history.

## Purpose

The Universal Application Workbench gives every Umicom product consistent startup, identity, application hosting, tabs, panels, layouts, context linking, multi-window operation, persistence and accessibility while preserving specialised product workflows.

## Governing architecture

```text
Workbench Host
└── Native host windows
    └── Application-surface tabs
        └── Product workspaces
            ├── Document and tool tab stacks
            ├── Named layout tabs
            ├── Docked panel regions
            ├── Floating or detached panels
            └── Activity and status areas

Framework Master Controller
└── Bounded Slave Controllers
    └── Services, engines, workers and adapters
```

The host, tabs, panel lifecycle and layout mechanisms are Framework-owned. Applications contribute identity, selected experience, configuration and genuine product behaviour.

## Visible hierarchy

```text
┌──────────────────────────────────────────────────────────────────────┐
│ <>  Application name │ Active context │ Mode │ Health │ Search      │
├──────────────────────────────────────────────────────────────────────┤
│ Application tabs                                              +     │
├──────────────────────────────────────────────────────────────────────┤
│ Product navigation │ Main workspace             │ Contextual tools │
│                    │ ┌─────────────────────────┐ │                  │
│                    │ │ Document/tool tab stack │ │                  │
│                    │ └─────────────────────────┘ │                  │
├──────────────────────────────────────────────────────────────────────┤
│ Activity drawer: output, problems, orders, tasks, events             │
├──────────────────────────────────────────────────────────────────────┤
│ Layout tabs and status                                               │
└──────────────────────────────────────────────────────────────────────┘
```

## Three tab levels

### Application-surface tabs

A host window may contain several authorised application sessions. Tabs may be opened, reordered, closed and transferred between Framework host windows according to session and policy rules.

The current GTK4 implementation presents the active product identity, workspace subtitle and operating-mode badge as one stable active application tab. Adjacent plus, new-window and close actions use the same Framework controller. This is the visible and behavioural foundation for several simultaneous application tabs; the multi-session container and transfer protocol remain roadmap work.

### Document and tool tabs

These tabs belong to a product workspace. They can represent source documents, charts, designs, queries, reports, terminals or other tool surfaces.

### Layout tabs

Layout tabs switch named panel arrangements without changing business execution authority or application identity.

## Startup lifecycle

```text
Created
→ Validating installation
→ Starting Framework services
→ Resolving application profile
→ Starting required Slave Controllers
→ Restoring session and layout
→ Checking adapters and permissions
→ Ready, Degraded or Failed with recovery
```

The startup surface shows real work and preserves a readable failure state.

## Panel contract

A panel definition describes what a tool is. A panel instance describes placement. Panel session state contains transient view data. Saved layouts use stable identifiers and never contain native widget pointers.

Eligible panel capabilities include:

- close or hide;
- restore;
- move and resize;
- dock, split and tab;
- float and reattach;
- maximise and restore;
- pin and auto-hide;
- context linking;
- independent monitor placement.

## Normal mode

Normal mode uses compact panel chrome and prioritises product tasks. Advanced arrangement commands remain available from a concise menu.

## Edit Layout mode

Edit Layout mode reveals docking targets, drag handles, resize affordances, panel catalogue access, context grouping, save, apply, cancel, reset and lock.

All changes form one transaction. Cancel restores geometry, visibility, tab membership, floating state and context membership.

## Layout ownership

Framework owns:

- layout schema;
- default experience layouts;
- validation;
- editing;
- migration;
- persistence;
- recovery;
- rendering.

Users own:

- named personal arrangements;
- placement choices;
- selected monitors;
- personal panel visibility;
- personal layout preferences.

## Application catalogue

The Framework GTK4 header now implements the first executable application-catalogue slice. Its plus action enumerates the canonical application portfolio and searches stable application identity, product name and purpose. The default adapter resolves an independently runnable executable beside the current installation or on the operating-system search path. A missing executable produces a visible failure reason.

The public application-open callback allows Umicom Desk or another Framework host to replace process launch with application-surface-session placement while preserving the same catalogue, application identifiers and controls. Several simultaneous in-host application sessions, drag transfer and monitor-aware rehydration remain future host work.

The complete catalogue will also open panels, tools, documents and templates. Each entry exposes required capabilities and a truthful unavailable reason. An entry can ultimately open in the current region, a new tab, a new host window or a selected monitor.

## Context-linked panels

A typed context group can transport project, document, instrument, account, legal entity, customer, model, connection or another declared selection type. Group number, name, role and state remain accessible; colour is only a visual cue.

## Command state

A command presentation contains identity, label, tooltip, enabled state, unavailable reason, progress, cancellation, approval and recovery information. Native adapters do not infer business eligibility.

## Persistence and recovery

The Data Server stores named layouts, application sessions, tab identity, monitor topology and panel-state references. A recovery journal protects startup before durable services are fully available. Saving is atomic and the last known good layout remains recoverable.

## Accessibility and responsive behaviour

The Workbench must support keyboard operation, focus traversal, accessible names and descriptions, high contrast, reduced motion and supported display scaling. Optional panels collapse before central work content becomes unusable.

Framework default geometry now reserves approximately 18% for each side region, 64% for the centre and 24% for the bottom activity area. These are semantic starting proportions rather than fixed pixels. Saved user layouts remain authoritative, and every frontend may adapt the same regions to available size and monitor topology.

## Acceptance journeys

- start every application through the shared lifecycle;
- open, close and restore application tabs;
- open, close and restore document or tool tabs;
- create and switch named layouts;
- enter Edit Layout mode and cancel without state drift;
- dock, detach, resize and reattach eligible panels;
- move a detached panel to another monitor and restore it after restart;
- link compatible panels and reject incompatible context types;
- preserve unsaved-work and active-operation policies;
- save, restore and reset layouts through Framework persistence;
- verify every visible command state.
