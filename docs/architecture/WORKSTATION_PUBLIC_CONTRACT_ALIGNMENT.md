# Umicom Workstation Public Contract Alignment

**Status:** Canonical implementation and conformance record  
**Owner:** Umicom Foundation  
**Last reviewed:** 4 September 2026  
**Scope:** Framework workstation models, GTK4 adapters and every application that consumes the universal workbench.

## Purpose

This document records the repair and governing rule for extending the Framework-owned workbench. The public Framework contracts are the authoritative boundary between toolkit-neutral workstation models and frontend adapters. Adapter implementation must extend those contracts deliberately; it must not invent parallel type names, constructors, model fields, automation functions or headers.

The rule protects the single-source-of-truth architecture:

```text
Framework public model and adapter contracts
→ Framework frontend implementation
→ Framework application profiles
→ thin application consumers
```

## Incident summary

A workstation presentation enhancement introduced useful product features but its GTK4 source was not aligned with the public headers already exported by Framework. The affected source attempted to use:

- parallel callback type names that were not declared by the public contracts;
- an extended argument list on the original two-argument panel-frame constructor;
- constants and structure fields that do not exist in the authoritative models;
- an automation helper that is not part of the public automation API;
- table and chart headers that do not exist in the Framework include tree;
- direct assumptions about opaque view-model storage.

The result was a compile-time failure before applications could receive the workbench enhancements.

## Governing decision

The following rules are mandatory for every adapter extension:

1. Existing public types, constants, structures and function signatures are the source of truth.
2. A simple existing API remains source-compatible. Enhanced behaviour is exposed through an explicit companion API only when the existing public contract already defines or genuinely requires it.
3. Public headers and implementations change atomically.
4. Opaque models are accessed only through their public query, snapshot and enumeration functions.
5. An adapter does not invent a second model or private copy of a public contract.
6. Generic product rendering uses existing Framework chart, property, command and workspace contracts.
7. An absent reusable contract is designed in Framework first; an application or adapter must not create an unofficial local substitute.
8. Every shared adapter change is validated against the complete application family.

## Corrected contract map

| Concern | Authoritative Framework contract | Adapter rule |
|---|---|---|
| Panel action callback | `UmiGtk4WsPanelActionHandler` | Copy semantic panel chrome before deferred dispatch and preserve the original simple constructor. |
| Interactive panel frame | `umi_gtk4_ws_panel_frame_create_interactive` | Use the interactive companion only when a controller callback is present. |
| Workspace action callback | `UmiGtk4WorkspaceLayoutActionHandler` | Keep panel-factory data and action-handler data distinct. |
| Workspace construction | `umi_gtk4_workspace_layout_host_create` and `umi_gtk4_workspace_layout_host_create_interactive` | Preserve both constructors and build the initial layout during creation. |
| Workspace capacity | `UMI_UI_WORKSPACE_LAYOUT_MAX_WINDOWS` | Use the capacity owned by `UmiUiWorkspaceLayout`. |
| Tab identity | `UMI_UI_ID_CAPACITY` | Use the shared UI identifier capacity. |
| Tab stack count | `UmiWsTabStack.count` | Do not assume another field name. |
| Automation identity | `umi_gtk4_automation_tag_widget` | Tag controls through the existing automation contract. |
| View-model values | `UmiUiValue.kind` and its public value fields | Read values through `umi_ui_view_model_get_property`. |
| View-model enumeration | `umi_ui_view_model_properties`, `umi_ui_property_bag_count` and `umi_ui_property_bag_at` | Never read opaque model storage directly. |
| Command actions | `umi_ui_command_view_action_at` | Preserve action identity, tooltip, enablement and callback routing. |
| Charts | `UmiWsChartSurface`, `UmiChartRenderScene` and the chart plot API | Build portable scenes and use the existing GTK4 chart surface. |
| Tables | Portable `umicom.table.*` properties rendered by the shared view-model adapter | Do not depend on an undeclared table type or header. |

## Features preserved and completed

The correction preserves the intended workbench improvements rather than reverting them:

- compact panel chrome in normal mode;
- complete direct controls in Edit Layout mode;
- overflow panel actions;
- panel close, move, pin, detach, maximise and settings routing;
- linked-context colour presentation through an allow-listed semantic class;
- managed tab close buttons;
- detached native panel windows;
- model-routed detached-window close requests;
- empty-region suppression and meaningful workspace empty states;
- status cards, progress and command actions;
- collapsed technical details;
- product metrics and compact trading rows;
- existing market-candle rendering;
- portable generic line and bar chart rendering;
- portable table rendering without a second table model;
- workspace snapshots, placeholder counts and revision evidence.

## Ownership and lifetime rules

### Panel actions

Button-owned state contains a value copy of the semantic panel chrome. Dispatch occurs after the current GTK signal returns, allowing a layout controller to rebuild the widget tree safely. The callback receives no pointer to temporary stack storage.

### Tab close actions

A managed close button copies the stable tab identifier into button-owned state. The callback routes to the model owner; the GTK notebook does not remove a page independently.

### Detached windows

The workspace host strongly owns detached-window entries. A title-bar close becomes a model action. Locked, pinned or non-closable panels reject unmanaged removal. Rebuild and destruction disconnect handlers and release windows in reverse ownership order.

### View-model presentation

The view model remains toolkit-neutral and opaque. The GTK4 adapter copies public values into widgets. GTK objects never become authoritative product state.

## Application-family impact

No application-local implementation is required. Every application that consumes the Framework workstation receives the corrected adapter through the single Framework target.

Application repositories may still need thin product-profile or launcher work for a separate feature, but they must not reproduce this repair. The application coverage document records the shared inherited effect across every registered application.

## Validation requirements

The conformance gate checks that workstation adapter source no longer contains the invalid parallel symbols or phantom headers and that it uses the authoritative public contracts.

Completion evidence requires:

```text
strict C23 adapter compilation
→ Framework UI target build
→ normal all-application build
→ all-application strict build
→ Framework tests
→ application startup journeys
→ panel, tab, docking and layout journeys
```

The source reconstruction and strict syntax validation used the public structure, function and value shapes. The complete Windows UCRT64 and GTK4 build remains the authoritative integration result.

## Future extension rule

Before adding another workbench capability:

```text
inspect current public contract
→ inspect every current implementation and caller
→ decide whether the contract already expresses the feature
→ enhance the public contract only when necessary
→ preserve compatible entry points
→ implement once in Framework
→ validate every application consumer
→ update decisions, coverage and roadmap
```

This sequence is mandatory for application tabs, docking, layout persistence, panel catalogues, context groups, specialised product surfaces and future frontend adapters.
