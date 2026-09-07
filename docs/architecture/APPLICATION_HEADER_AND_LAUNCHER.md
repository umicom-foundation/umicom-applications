# Umicom Application Header and Launcher

**Status:** Source-integrated; native build and visual acceptance pending
**Owner:** Umicom Framework
**Applies to:** Every graphical Umicom application

## Purpose

This document defines the Framework-owned application identity, native titlebar, application catalogue, new-window action and close action. It records the boundary between the current independently runnable product model and the future universal application-surface host.

## Governing rule

Application identity and launch discovery are reusable platform behaviour. They are implemented once in Umicom Framework. Applications provide only their stable identity and product composition through the canonical application portfolio.

```text
UmiApplicationDefinition
        ↓
Framework application portfolio
        ↓
Framework GTK4 identity and application controller
        ├── Native product titlebar
        │       ├── product identity and document context
        │       ├── searchable plus catalogue and new-window request
        │       └── GTK window actions
        └── managed application header for explicitly embedded hosts
                ├── active application tab
                ├── searchable plus catalogue and new-window request
                └── close request
```

No application repository maintains a second application array, launcher menu, identity renderer or executable-name map.

## Topmost application titlebar

Studio installs the shared `umi_gtk4_ws_window_titlebar_create()` composition in
the actual `GtkWindow` titlebar slot before the window is presented. It is not a
second identity strip inside the editor or workspace content.

Trader, Bank, TMS, Music and the shared product-preview launchers bind their
existing suite identity with `umi_application_suite_gtk4_workstation_bind_window()`.
Desk uses `umi_gtk4_ws_window_titlebar_create_from_header()` with its existing
identity. Both paths transfer ownership only after validation succeeds. The
same catalogue, selections, mode badge, appearance and callback owner survive
the move; no replacement catalogue is created. Standalone suite widgets keep
their embedded-header behaviour until a native owner explicitly binds them.

The single topmost row contains:

- the unchanged Umicom SVG and fixed product name at the far left;
- active document/project text in Studio, or the suite layout name, in the centre;
- the existing application catalogue and New Window actions at the right;
- GTK-managed minimise, maximise and close controls after those application actions.

GTK supplies the titlebar handle and window actions. Dragging, double-clicking
and the ordinary close-request guard stay with the native window. The exact
window-control appearance depends on the operating system and GTK backend.

The centred label follows the existing window title. It removes only the exact
leading product name and separator; it does not change the operating-system
title, document names, project names or dirty marker. Long context text
ellipsizes and remains available in its tooltip. The product name stays fixed.

The mark uses the existing 18-logical-pixel SVG paintable. Compact spacing aims
for a normal titlebar height without setting a smaller font. Large user fonts
and accessibility settings can make the titlebar taller. Appearance changes
reuse Studio's existing Framework appearance model.

Menus, command search, panel-opening and layout actions occupy the compact row
below the titlebar. They do not repeat the Umicom mark or product name. Studio's
titlebar reuses the same multi-application picker and New Window buttons from
the existing managed identity controller, moved to its right-hand action area.
It does not create another catalogue, launcher registry or inner identity strip.
The separate managed close button is hidden because GTK already supplies Close.

The main window must not be realized before binding. Products with delayed
startup show their existing splash content in a temporary window, then close
that window and present the completed main window. Closing startup cancels its
queued callback. Startup failure preserves a readable error surface. Desk
builds its titlebar before its first present call and removes its polling source
before releasing native widgets and services.

Desk's dedicated content renderer is unchanged apart from hiding its duplicate
product label after successful binding. This is not a migration to the suite
canvas or a completed cross-application session host. Build, visual acceptance,
startup cancellation and failure-path execution are still pending.

## Managed application tab

The reusable managed application tab can contain:

- the Framework-owned packaged Umicom SVG mark;
- full product name;
- active workspace or document subtitle;
- operating-mode badge;
- application-level lifecycle controls.

It represents one complete application surface. It is not a document tab and is not a named layout tab.

The default compact presentation uses one line: the approved SVG mark, readable
product name and a small operating-mode label. The workspace subtitle remains in
the model, tooltip and accessible description instead of doubling the header's
height. The layout selector continues to show the selected workspace. A
noncompact presentation may show the subtitle beneath the title.

The header gives GTK an icon-sized paintable backed by the original SVG: 18
logical pixels in compact mode or 24 otherwise. A minimum size request alone
does not constrain an SVG's natural dimensions. Display-scale changes refresh
the paintable; they do not rewrite artwork or override the user's font settings.

The native operating-system icon complements the visible SVG identity.
Framework assigns the executable's existing canonical ICO resource to Windows
after its native surface is created, without removing a custom titlebar. Studio
shows the SVG in its topmost titlebar, not a duplicate in-content brand strip.
The SVG remains the UI master. No textual angle brackets or stock toolkit icon
should be drawn as substitute branding.

These bindings have native C regression coverage in source. Compilation and
visual acceptance are required before a release is considered verified.

## Searchable application catalogue

The plus action opens a searchable list generated by:

```c
umi_application_portfolio_count();
umi_application_portfolio_at(index);
umi_application_portfolio_find(application_id);
```

Search covers product name, purpose and stable identifier. A row carries only the stable identifier; selection is resolved again through the portfolio so a stale widget cannot become an alternative source of application metadata.

## Opening policy

The public callback receives:

```text
application identifier
open mode: standard host policy or new window
borrowed host context
```

A Framework host can use this callback to create an application-surface session in the active host or another host window. Without a callback, the GTK4 adapter starts an independently runnable executable.

The native resolver asks `umi_application_portfolio_gui_executable()` for the
canonical graphical executable. It checks that name beside the running program
and on the operating-system executable search path. It never substitutes a
console program when a graphical program is missing. Console tools remain
available through their explicit native command-line entry points.

Finding a file means a launch can be attempted. It does not prove that its
dependencies are present, that its window will appear, or that its product
services are ready. The child application's startup checks remain authoritative.

Failure remains visible in the catalogue. The current application continues to run and no application session is falsely recorded.

## Select and open several applications

Each row has a selection checkbox and a separate Open action. The footer shows
the selected count and provides Open selected, Clear and Refresh controls. Search
only changes which rows are visible; it does not silently clear hidden selections.
The current application is excluded from the multi-selection model because its
existing New Window action is the explicit way to request another window.

The existing C `UmiApplicationLaunchSelection` model owns selection policy.
`umi_application_launch_selection_dispatch()` sends each selected identifier to
the host callback and returns a separate result for each request. An accepted
request is removed from the selection. Failed requests remain selected, so Retry
does not open the successful applications again. One failed request does not
prevent the other selected requests from being attempted.

The dispatch report deliberately counts **accepted requests**, not ready or
running applications. A host accepting a request or the operating system creating
a process is not evidence that startup succeeded. This path does not invent a
process token or modify the runtime catalogue to claim that a product is running.

The model is used from one owning thread. Callbacks are synchronous and borrow
their arguments only for the call. Reentrant selection changes are rejected while
dispatch is active. The GTK adapter performs its widget work on the GTK thread
and releases callbacks and models together when the header is destroyed.

A custom host callback can resolve a product without a local executable. That
callback still decides whether opening is allowed; the picker does not bypass
product permissions, setup requirements or operating-mode checks.

## Native acceptance evidence

Core tests cover partial failure, retry, empty selection, invalid identity and
reentrant requests. A GTK C test connects the shared header to an injected host
callback; it must never launch a real product during the test. The test checks
the same selection and dispatch entry points used by the visible controls.

The additional native titlebar regression is registered as build target
`umicom-gtk4-window-titlebar-test` and test
`framework.ui_workstation.window.titlebar.gtk4`. It constructs unpresented
windows, checks titlebar ancestry, original file-backed SVG identity, exact
context-prefix updates, GTK handle/control widgets, right-side application
actions and both teardown orders. It verifies that a retained New Window
button loses its borrowed callback after teardown; it never emits a launch
signal or starts a product. It does not prove on-screen control behaviour.

These tests are source-integrated. Compilation and native execution have not
been performed for this delivery. Full visual acceptance still includes keyboard
navigation, readable results, display scaling and launch failure recovery.

After building Studio, check the visible titlebar:

1. Confirm the only application brand is at the far left of the topmost row.
2. Open a document and change projects. Confirm centred context updates while
   **Umicom Studio IDE** stays left; edit a document and check its dirty marker.
3. Narrow the window. Context should ellipsize instead of pushing the native
   controls or editor off-screen.
4. Try dragging, double-clicking, minimise, maximise and close. Closing with
   unsaved work must still use Studio's normal confirmation.
5. Change appearance and display scale. The original SVG must remain sharp and
   correctly sized; no substitute text mark or duplicate inner brand appears.
6. Open the titlebar's plus catalogue and check its search and multi-selection
   controls. New Window remains beside it, before the native window controls.
7. Increase the interface font. Text remains readable even if the titlebar
   needs more height.

## New window and close

New Window requests another instance of the current application. A future host may instead create another surface session in an independent host window.

Close asks the owning native window to close. The normal close-request signal remains authoritative, so Studio unsaved-work checks and other application close guards are not bypassed.

## Ownership and lifetime

- Header text and resource paths are copied into Framework-owned state.
- Studio owns its titlebar controller independently of the workspace layout.
- The titlebar retains its widget and weakly observes the window. Title, SVG
  and reparented application-control callbacks are disconnected before the
  controller is released, including externally retained buttons. GTK window
  controls keep their ordinary parent-owned lifetime.
- The application-open callback and context are borrowed until replaced or the header is destroyed.
- GTK signal callbacks are disconnected before the controller is released.
- The legacy label-only creation API hides application controls and disconnects their callbacks before returning the parent-owned widget.
- Application business state is never stored in the header.

## Current coverage

Studio, Desk, Bank, Trader, TMS, Music and the shared product-preview launchers
adopt the topmost native titlebar in source. Suite and Desk transfer their
existing managed identity controller, keeping its appearance and catalogue
selection. Embedded workstation constructors remain unchanged until their
host explicitly binds a native window. Native execution and appearance still
require acceptance; the shared previews do not imply completed domain services.

Both compositions reuse Framework branding and resource resolution. Product
repositories do not maintain a second logo renderer or executable-name map.

All registered manifests now declare native_executable and console_executable.
The legacy executable remains unchanged for existing consumers. The additive
Framework launch-spec parser validates explicit basenames; known GUI names must
match the existing portfolio. The shared build uses the declared native name,
and a headless aggregate selects an available console target. Missing optional
native declarations in external/legacy modules do not trigger name guessing.

## Current limitation

This implementation opens a separate process unless a host callback is installed.
It does not yet provide several application-surface sessions inside one host,
drag transfer between host windows or Data Server session rehydration. Portable
transfer-token contracts exist, but their native end-to-end journey is not yet
complete. The ordered remaining work is recorded in
`WORKBENCH_FEATURE_ROADMAP.md`.

## Acceptance requirements

- Studio's Framework-owned packaged Umicom SVG mark is visible in its topmost
  titlebar, with no second inner brand strip;
- every dedicated and shared-preview launcher uses its documented native titlebar;
- the product name is always visible;
- Studio retains the plus catalogue and New Window at the titlebar's right;
- the plus action lists the canonical portfolio;
- catalogue search filters without mutating portfolio data;
- a missing executable has a readable error;
- new-window requests are distinct from standard host-policy requests;
- close follows the product close guard;
- every control has an accessible name and tooltip;
- no application-local catalogue or launcher is introduced;
- the complete application estate builds against the additive public API.
