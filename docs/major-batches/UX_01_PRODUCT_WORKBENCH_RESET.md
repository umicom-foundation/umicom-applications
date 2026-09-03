# Major Batch UX-01 — Umicom Product Workbench Reset

## Status

Executable foundation slice ready for integration testing.

This batch begins the approved Umicom product-workbench redesign without
removing existing layout, docking, floating, context-linking, appearance,
command, controller or persistence capabilities. Reusable behaviour remains in
Umicom Framework. Product repositories supply only their identity, startup
wording and application composition.

## Objectives delivered in this slice

1. Provide one Framework-owned startup surface for native Umicom applications.
2. Keep the application identity visible through an Umicom mark and readable
   product name.
3. simplify panel chrome during normal work while preserving every advanced
   action in a compact panel menu.
4. Show direct move, float, maximise, pin and settings controls while Edit
   Layout mode is active.
5. Add model-routed close controls to editable panel tabs and detached panels.
6. Stop empty workspace regions from consuming permanent screen space.
7. Replace unexplained blank panels with deliberate empty-state guidance.
8. Move internal component, capability and runtime evidence into a collapsed
   Technical details disclosure.
9. Preserve user-facing state, message, badge, progress and command actions in
   the normal panel body.
10. Start Umicom Bank and Umicom Trader through the shared startup surface.
11. Report truthful startup modes: Offline for Bank and Simulation for Trader.

## Framework ownership

Umicom Framework owns:

- startup-surface presentation and progress;
- application header identity and resource resolution;
- panel frames and action routing;
- tab labels and close requests;
- docked and detached panel rendering;
- normal-mode and edit-mode panel chrome;
- empty, ready, progress and technical-detail presentation;
- layout model synchronisation and window ownership.

Application modules own only:

- application identifier and display name;
- startup subtitle and user-facing phase text;
- initial operating-mode badge;
- product-specific workstation construction;
- product-specific controllers and policies already defined by each module.

No product module contains copied docking, tab, panel or splash implementation.

## Startup experience

```text
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│                         <>  Umicom Bank                       │
│             Accounts, payments and financial operations      │
│                                                              │
│                  ─────────────────────────                   │
│                  Preparing application services              │
│                  [██████████░░░░░░░░░░]                     │
│                            Offline                           │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

The surface appears before the heavier product workstation is constructed.
Status and progress update in place. When startup succeeds, the application
window replaces the startup surface with the completed workstation. When
startup fails, the same surface remains visible and presents the actual status
instead of opening an empty window.

The startup controller does not own authentication, connectivity or business
state. Those remain with their existing Framework services and application
policies.

## Normal product mode

```text
┌──────────────────────────────────────────────────────────────┐
│ <> Umicom Application     Workspace     Search        Mode   │
├──────────────────────────────────────────────────────────────┤
│ Panel A                         Panel B                     ⋮ │
│ ┌──────────────────────┐       ┌──────────────────────────┐ │
│ │ user-facing status   │       │ useful product content   │ │
│ │ message and actions  │       │ tables, charts, forms    │ │
│ │                      │       │                          │ │
│ │ Technical details ▸  │       │ Technical details ▸      │ │
│ └──────────────────────┘       └──────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

Normal mode emphasises product content. The panel title, linked-context control,
overflow menu and permitted close control remain discoverable. Placement labels
and repeated internal identifiers no longer dominate the workspace.

The overflow menu preserves:

- pin or unpin;
- move;
- dock or detach;
- maximise or restore;
- panel settings.

Geometry-changing commands remain disabled while the layout is locked. Panel
settings remain available because they can present information without silently
moving the panel.

## Edit Layout mode

```text
┌──────────────────────────────────────────────────────────────┐
│ Edit Layout     Add Window     Save     Restore     Apply     │
├──────────────────────────────────────────────────────────────┤
│ Panel A   [link] [pin] [move] [detach] [maximise] [settings] │
│          [x when removable]                                  │
│                                                              │
│   drag, resize, dock, detach, group and arrange panels       │
│                                                              │
├──────────────────────────────────────────────────────────────┤
│ Panel tabs:  Accounts [x]   Payments [x]   Risk [x]          │
└──────────────────────────────────────────────────────────────┘
```

Edit Layout mode exposes direct geometry controls and model-routed close
buttons. A close request changes the portable layout model first; GTK content is
rebuilt from that model afterwards. This prevents the native widget tree from
drifting away from the saved layout state.

## Docked and detached panels

A panel can be represented in a docked tab stack or as an independent native
window. The same stable window identifier and semantic action callback are used
in both forms.

```text
Main workstation                     Independent panel window
┌───────────────────────────────┐     ┌────────────────────────┐
│ Chart │ Orders [x] │ Risk [x] │     │ Market Depth       [x] │
│                               │     │                        │
│ active docked content         │     │ detached content       │
└───────────────────────────────┘     └────────────────────────┘
```

Empty regions are omitted. A left, right, top or bottom area therefore does not
remain as a blank strip merely because its last visible panel was moved or
closed. When every docked panel is absent, the host shows one full-canvas
message explaining how to restore or dock panels.

## Product panel presentation

Previously, normal product panels exposed component identifiers, capability
identifiers, connection flags, focus state and dirty state beside their primary
message. This batch retains all of that evidence but stores it under the
reserved `umicom.technical.*` namespace and renders it in a collapsed
**Technical details** section.

The normal body now prioritises:

- readable state;
- guidance or result message;
- operating badge;
- progress;
- product metrics;
- Framework-rendered table or chart content;
- available product commands.

A truly empty model receives a centred explanation rather than an unexplained
blank canvas.

## Application integration

### Umicom Bank

- opens a shared startup surface immediately;
- reports `Offline` until an approved provider and authenticated session exist;
- prepares accounts, payments and workspace services before presenting the
  existing Framework-owned Bank workstation;
- leaves startup failure visible with an actionable state.

### Umicom Trader

- opens a shared startup surface immediately;
- reports `Simulation` for the existing safe startup path;
- prepares market data, risk and workspace services before presenting the
  existing Framework-owned trading workstation;
- preserves monitor-aware window sizing and the existing simulation boundary.

### Umicom Studio IDE

Studio receives the shared panel, tab, empty-state and technical-detail changes
through Framework. Its established startup path remains unchanged in this
slice so the first integration can be validated without replacing its separate
workspace bootstrap at the same time.

## Files changed

### Umicom Framework

- `include/umicom/ui/gtk4/workstation/shell_header.h`
- `include/umicom/ui/gtk4/workstation/tab_host.h`
- `adapters/gtk4/workstation/shell_header_gtk4.c`
- `adapters/gtk4/workstation/tab_host_gtk4.c`
- `adapters/gtk4/workstation/panel_frame_gtk4.c`
- `adapters/gtk4/workstation/workspace_layout_host_gtk4.c`
- `adapters/gtk4/workstation/view_model_panel_gtk4.c`
- `adapters/gtk4/application_product_workstation_gtk4.c`

### Umicom Bank

- `src/gtk/main.c`
- `src/gtk/workstation.c`

### Umicom Trader

- `src/gtk/main.c`

## Compatibility and preservation

- Existing public shell-header creation remains available.
- Existing simple tab creation and append functions remain available.
- Existing application product-workstation APIs remain unchanged.
- Existing docking, floating, maximising, pinning, settings, context groups,
  layout transactions, appearance profiles and persistence remain available.
- Product controllers still decide whether a command executes, stages approval,
  or is unavailable.
- No business logic has moved into GTK code.
- No reusable implementation has moved into an application module.

## Integration acceptance checks

The slice is accepted only when all of the following hold:

1. Framework, Bank, Trader and Studio compile with strict warnings enabled.
2. Bank presents a visible startup surface before its workstation.
3. Trader presents a visible startup surface before its workstation.
4. Startup failure remains visible and reports the returned status.
5. Normal locked layouts show compact panel chrome.
6. Edit Layout mode shows direct geometry controls.
7. A removable editable tab closes through the layout model.
8. A removable detached panel closes through the layout model.
9. A pinned or locked detached panel rejects accidental native-window closure.
10. Empty regions consume no permanent split-pane space.
11. Internal component and capability identifiers are hidden initially but
    remain available under Technical details.
12. Existing layout save, restore, cancel and apply behaviour continues to work.
13. The three product windows remain usable at 1280×720, 1440×900 and
    1920×1080.
14. Keyboard focus and accessible labels remain available for startup, tabs,
    panel controls, status and actions.

## Follow-on slices

The next slices build on this foundation in this order:

1. Umicom Workbench Host with application tabs, `+` application catalogue,
   tab transfer between host windows and independent multi-monitor hosts.
2. Named layout tabs, layout library and user-created workspace profiles.
3. Studio daily-use workflow: workspace, Explorer, editor, build, Problems,
   Output, Terminal and documentation recovery.
4. Trader simulation workflow: instruments, chart, depth, order entry, risk,
   fills, positions, profit and loss, and blotter.
5. Bank demonstration workflow: accounts, transactions, beneficiaries,
   payment preparation, approval, reconciliation and liquidity overview.
6. Connection and authentication orchestration through approved external
   adapters without storing third-party credentials in Umicom presentation
   code.

These follow-on slices must continue to use Framework contracts and keep each
application repository thin.
