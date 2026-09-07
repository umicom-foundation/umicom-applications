<!--
  Umicom Applications
  File: docs/validation/NATIVE_CANVAS_VALIDATION.md
  Purpose: Explain native canvas behaviour, consumer coverage and acceptance.
  Author: Sammy Hegab, Umicom Foundation
  Licence: MIT
-->

# Native canvas validation

## Delivery state

Recorded 7 September 2026. This update contains C implementation, C tests,
build registration and documentation. It has not been compiled, linked or run
in a native application during this review. Test code is not a passing result.
No logo artwork, user project, stored layout, repository history or secret is
removed by this update.

## What changes

The shared Framework workstation now distinguishes four arrangements:

| Arrangement | Meaning |
|---|---|
| Docked panel | A tab or group in a named dock region. |
| Canvas panel | An independent rectangle inside the host window. |
| Detached window | A separate operating-system window. |
| Auto-hide tool | A named edge tab that opens a temporary tool panel over the workspace. |

Studio, Trader, Bank, TMS, Music, Desk and the shared product-preview launchers
place the official SVG and fixed application name in the topmost window title
bar. Studio uses document/project context in the centre; the suite uses its
active layout name. Menus and workspace actions remain separate below it.
The application identity is not repeated in the inner command strip. Suite and
Desk transfer their existing identity controller, preserving its appearance,
application catalogue and launch selection rather than creating a second one.

The main window is bound before first presentation. Products with delayed
startup use a temporary startup surface while preparing the final window.
Closing that surface cancels pending startup. Failure keeps a readable error
surface and does not claim that a working product opened. These startup paths
still require native acceptance.

The current Studio default has Explorer, Structure and Object Inspector on the
left edge. Click a named tab to open its panel. Click another to switch tools.
X, Escape or a click elsewhere inside the workspace collapses it. The tab and panel contents
remain available. The dock control makes the tool a normal docked panel. Its
auto-hide control returns it to the edge. Closing an ordinary docked tool hides
it until it is opened again from the Window catalogue. These view operations
do not require unlocking panel movement. A protected panel still rejects changes.

Existing saved arrangements are preserved. Use **New default layout** in
Studio's layout bar to create a separately named copy of the current product
default. This does not replace an older default, remove a layout or save over a
checkpoint. Use **Save** only when the new arrangement is ready.

Canvas panels no longer become centre tabs. Their rectangles use fractions of
the available canvas, so resizing the host keeps them inside it. The render
plan supports up to 64 canvas records independently of its 16 dock-stack slots.
An empty layout is valid. A malformed rectangle is rejected before GTK uses it.

New Layout creates a named empty arrangement without changing existing presets.
Edit Layout starts a reversible edit. Canvas position and size can be changed
using the title handle, any edge or corner, or percentage fields in Panel
Settings. Resizing keeps the opposite edge in place; an untouched axis does
not jump to the grid. Corner hit targets use a narrow L-shaped border so their
visual area does not cover the panel's Close button. The edit grid uses a
2.5 percent step. Configurable grid size remains future work.

During Edit Layout, Tab can focus a panel title. Arrow keys preview movement;
Shift plus arrows preview bottom/right resizing. Enter queues the preview for
the model owner. Escape or leaving the title cancels without changing the
layout. Switching to a pointer gesture also cancels an unfinished keyboard
preview. Locked, protected and fixed-size panel policies still apply. Input in
an editor or another provider field is not treated as a geometry shortcut.

Dragging previews a rectangle only. A completed request carries the source
revision and is queued until the pointer callback finishes. The model accepts
or rejects it; a queued request is not proof of acceptance. Lock, pin and resize
rules still apply. A cancelled gesture, rebuilt layout or destroyed host must
not dispatch an old request later.

Geometry-only updates retain the provider widget, including its current field
text and selection. Studio also enables optional body retention for structural
changes: the outer frames are rebuilt, but the real provider widgets remain.
The cache is limited to 64 unique panel instances and rejects overflow rather
than silently discarding hidden drafts. Explicit provider refresh can discard a
body, so it must follow a deliberate save or discard decision. Other suite
clients retain their existing refresh behaviour unless they opt in.

Group colours now resolve through the existing context-group store. Group IDs
are not treated as colour names or arbitrary CSS selectors. Eligible internal
panels now have a temporary maximise/restore presentation. The same header and
body fill the workspace; other provider widgets remain alive in the hidden
normal arrangement. Saved rectangles and layout revisions do not change.
Restore returns the body to its original frame. Detached native windows keep
their existing operating-system maximise behaviour.

Normal Windows navigation stays available while movement is locked. Search
finds current instances and named layouts. Open/Focus does not add or move a
panel: it focuses a visible instance, reveals an auto-hide tool or reopens an
ordinary hidden dock tool at its existing position. Missing or protected
instances remain unavailable with an explanation. Destination controls are
enabled only during Edit Layout.

Clear Panels removes unpinned, closable view instances inside the edit. It does
not remove their product data or catalogue definitions. Protected panels remain
and the result explains this. Cancel restores the edit baseline. Apply and Lock
keeps the arrangement in memory. The new explicit Save/Restore path uses a
Framework Data Server when one is connected. A file-backed SQLite connection
can retain the checkpoint after restart; a memory connection cannot. Same-product
named layouts can be imported into a fresh workstation. Foreign-product IDs
are rejected before live model publication.

Only the last explicitly saved active layout is checkpointed. This does not
save every named layout, editor draft, open process, appearance setting or
monitor assignment. Application and workspace IDs scope the stored records;
the host's current catalogue still controls which tools can be restored.
Save and Restore refuse an active layout edit. Apply or Cancel it first.

Saving compares the last observed storage revision before replacing a record.
A competing save causes a conflict, not an automatic overwrite. A validated
last-good copy can recover from an unusable primary. Recovery does not erase
the damaged evidence. If neither copy can be used, the current arrangement
stays intact. A checksum detects damaged bytes; it is not proof of a record's
author or permission to access a database.

## Application coverage

| Consumer | Source connection | Remaining evidence |
|---|---|---|
| Trader | Trading suite creates the shared suite workstation with trading providers. | Actual paper-workstation interaction, field retention and recovery. |
| Bank, TMS, Music | Product workstation creates the shared suite workstation. | Each product's native canvas and domain guards. |
| Other shared product previews | Shared product application entry creates the product workstation. | Launch each preview; unconnected commands remain unavailable. |
| Studio IDE | Main shell creates the shared host from its professional-workspace model; real tool bodies and the original editor are retained. Explicit canvas checkpoints use the Framework Data Server. Legacy placement arrays remain display-only projections. | Compile and run the actual-Studio native regression; verify live typing, Apply/Cancel, checkpoint recovery and teardown. |
| Desk | Uses the shared topmost titlebar and retains its dedicated desktop renderer. Polling and retained widget callbacks are cleaned up before borrowed services. | Native titlebar/teardown acceptance, suite canvas host adoption and session ownership. |

The original shared-host test uses Bank, Trader and Studio experience
definitions with controlled provider widgets. That fixture is not the Studio
executable. A separate new regression uses the actual Studio GTK constructor,
runtime catalogue, text editor and deferred geometry requests. Its explicit
offline options disable repository discovery, session storage and automatic
timers. A unique temporary directory holds its service data and remains local
for analysis. The persistence portion explicitly binds a separate SQLite
database beneath that directory. It closes the workbench, service graph and
connection, then recreates them and checks the saved canvas. It also exercises
the actual Save/Restore buttons, last-good recovery, damaged-copy rejection,
edit refusal and retained editor drafts. This is not a forced-process-crash or
power-loss test. Neither fixture proves a completed financial workflow.

## Registered regression targets

| Build target | CTest name |
|---|---|
| `umicom-application-suite-layout-canvas-projection-test` | `framework.application_suite.layouts.canvas.projection` |
| `umicom-application-suite-layout-render-plan-test` | `framework.application_suite.layouts.render.plan` |
| `umicom-gtk4-workspace-canvas-test` | `framework.ui_workstation.workspace.canvas.gtk4` |
| `umicom-gtk4-workspace-content-test` | `framework.ui_workstation.workspace.content.gtk4` |
| `umicom-studio-runtime-workspace-canvas-test` | `framework.studio_runtime.workspace-canvas` |
| `umicom-studio-workspace-canvas-test` | `studio.workspace.canvas.gtk4` |
| `umicom-studio-source-control-offline-test` | `studio.source_control_offline` |
| `umicom-workbench-layout-data-workspace-namespace-test` | `framework.workbench_layout_data.workspace_namespace` |
| `umicom-ui-workspace-checkpoint-test` | `framework.ui.workspace-checkpoint` |
| `umicom-gtk4-workspace-checkpoint-test` | `framework.ui_workstation.workspace.checkpoint.gtk4` |
| `umicom-gtk4-window-titlebar-test` | `framework.ui_workstation.window.titlebar.gtk4` |
| `umicom-gtk4-suite-titlebar-test` | `framework.ui_workstation.suite.titlebar.gtk4` |
| `umicom-gtk4-product-startup-lifetime-test` | `framework.ui_workstation.product.startup.lifetime.gtk4` |
| `umicom-gtk4-tool-rail-test` | `framework.ui_workstation.tool.rail.gtk4` |
| `umicom-gtk4-workspace-tool-windows-test` | `framework.ui_workstation.workspace.tool.windows.gtk4` |
| `umicom-desktop-window-titlebar-test` | `desktop.window.titlebar.gtk4` |
| `umicom-application-manifest-tests` | `framework.application_manifest` |
| `umicom-applications-native-manifest-test` | `applications.native_manifest` |
| `umicom-ui-workstation-maximize-mode-test` | `framework.ui_workstation.maximize.mode` |
| `umicom-gtk4-workspace-maximise-test` | `framework.ui_workstation.workspace.maximise.gtk4` |
| `umicom-gtk4-suite-navigation-test` | `framework.ui_workstation.suite.navigation.gtk4` |
| `umicom-gtk4-command-bar-lifetime-test` | `framework.ui_workstation.command.bar.lifetime.gtk4` |

The portable target covers blank, mixed and full-capacity plans, invalid input,
movement, resizing, boundaries, atomic context/geometry settings and rollback.
Duplicate panel identities are rejected even when one record is hidden. The
content-retention test also checks that unknown colour tokens cannot introduce
arbitrary style classes.
The native target constructs unpresented widgets, checks actual allocations,
gesture callbacks, rejected/stale requests, teardown and named-layout controls.
It skips with code 77 when no display connection is available. The actual
Studio case also skips if SQLite support is unavailable. A skip is not a pass.
The namespace test checks layout-only backup/restore of raw workspace chunks,
separation from semantic document records, integrity checks and safe orphan
repair. An incomplete or corrupt manifest inventory must not cause chunks to
be deleted. The checks remain active in Release builds.

The titlebar test checks real GTK titlebar placement and the existing SVG
resolver. Tool-window tests check named tabs, switching, collapse, draft
retention, rejected contradictory layout data and callbacks after teardown.
The actual Studio test also checks that its identity is in the titlebar, not
the content tree, and clicks the real Structure and Object Inspector tabs.
These are registered tests; they have not been run during this update.

The launch tests parse the actual 24 application manifests and compare their
declared native names with the Framework portfolio catalogue. Parser checks
cover the existing nested and generated flat formats, unsafe or duplicate
names, oversized input, embedded NUL bytes and unchanged legacy structure.
They verify declarations, not installed executables or successful startup.

The navigation fixture uses every registered experience with controlled entry
widgets. It checks locked Open/Focus, hidden dock tools, named-layout search,
draft retention and catalogue refresh. It does not construct every real client.
The command-bar test checks replaced result rows and callbacks that destroy
their owner. The maximise test checks real widget identity and parentage,
selection, restore, permission rules, conflicting geometry work and teardown.
Studio and Desk have separate actual-client navigation checks in their existing
native fixtures. These checks generate local widget signals, not desktop input.

The portable canvas test also covers all eight resize directions, untouched
axes, grid/minimum boundaries and permission rejection. The native canvas test
exercises every real grip, positive border picking, non-interception of Close,
keyboard preview/Enter/Escape/focus departure, stale retained controls and
cancelled queued work. No desktop input is generated by its synthetic signals.
The Desk test builds its actual product composition without presenting a window
or starting a child application. It checks titlebar ancestry, unchanged launcher
controls, retained selection, timer removal and safe window-first teardown.

The Suite titlebar fixture checks transferred controls through the original
automation driver. Its separate titlebar scope must not resolve a matching
control in an unrelated window, even before the product window is presented.
The startup lifetime fixture checks the shared preview's production cancellation
callbacks with unpresented windows and inert pending work. Destroying a retained
startup window must cancel that work immediately, not wait for finalization.
This fixture does not run the product startup or prove the full launch sequence.

The portable checkpoint test checks product/workspace scope, revision conflicts,
caller-owned transactions, validated last-good recovery, invalid input and
memory-versus-SQLite storage behaviour. It does not create a GTK window.

The Suite checkpoint fixture checks application scoping for Trader, Bank, TMS
and Music, borrowed connection ownership, named-canvas geometry after storage
reopening, the actual Save button and competing saves. It uses controlled panel
contents, so it does not replace each application's operational acceptance.

## Build after merging the source

Run from the complete application checkout. Keep the existing build tree; there
is no cleanup or deletion step. Configuration creates any new test targets.
Merge source changes only; do not copy a build directory from another checkout.
Known manifest files are registered as configuration dependencies, so later
edits to their launch declarations request regeneration during the next normal
incremental build. This is not a background build watcher.

```powershell
Set-Location "C:\umicom\umicom-applications"
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"
& "C:\msys64\ucrt64\bin\cmake.exe" --preset windows-ucrt64-all-debug
if ($LASTEXITCODE -ne 0) { throw "Configuration failed" }
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --target umicom-desktop-products umicom-application-suite-layout-canvas-projection-test umicom-gtk4-workspace-canvas-test umicom-gtk4-workspace-content-test umicom-studio-runtime-workspace-canvas-test umicom-studio-workspace-canvas-test umicom-studio-source-control-offline-test umicom-workbench-layout-data-workspace-namespace-test umicom-ui-workspace-checkpoint-test umicom-gtk4-workspace-checkpoint-test umicom-gtk4-window-titlebar-test umicom-gtk4-tool-rail-test umicom-gtk4-workspace-tool-windows-test umicom-application-suite-layout-render-plan-test umicom-gtk4-suite-titlebar-test umicom-desktop-window-titlebar-test umicom-gtk4-product-startup-lifetime-test umicom umicom-application-manifest-tests umicom-applications-native-manifest-test umicom-ui-workstation-maximize-mode-test umicom-gtk4-workspace-maximise-test umicom-gtk4-suite-navigation-test umicom-gtk4-command-bar-lifetime-test --parallel 2
if ($LASTEXITCODE -ne 0) { throw "Build failed" }
& "C:\msys64\ucrt64\bin\ctest.exe" --test-dir "C:\umicom\umicom-applications\build\windows-ucrt64-all-debug" -R "framework.application_suite.layouts.(canvas.projection|render.plan)|framework.ui_workstation.workspace.(canvas|content|checkpoint|tool.windows).gtk4|framework.ui_workstation.(window|suite).titlebar.gtk4|framework.ui_workstation.product.startup.lifetime.gtk4|desktop.window.titlebar.gtk4|framework.ui_workstation.tool.rail.gtk4|framework.studio_runtime.workspace-canvas|studio.workspace.canvas.gtk4|studio.source_control_offline|framework.workbench_layout_data.workspace_namespace|framework.ui.workspace-checkpoint|framework.application_manifest|applications.native_manifest|framework.ui_workstation.maximize.mode|framework.ui_workstation.workspace.maximise.gtk4|framework.ui_workstation.suite.navigation.gtk4|framework.ui_workstation.command.bar.lifetime.gtk4" --no-tests=error --output-on-failure
if ($LASTEXITCODE -ne 0) { throw "Canvas validation failed" }
```

## Native acceptance journey

Close older running instances before opening the new binary. Use the executable
from the same build directory, not a shortcut to another build.

1. Open Trader or Bank and confirm its default panels and official identity.
2. Choose New Layout, enter a name and create the empty layout.
3. Choose Edit Layout, then Windows, Canvas, and a real product panel.
4. Move its title handle, resize each edge and corner, and check the percentage
   fields in Panel Settings. Confirm that the panel stays inside the canvas and
   its Close button remains clickable. Focus the title with Tab, preview with
   arrows or Shift plus arrows, then try Enter, Escape and Tab separately.
5. Apply and Lock. Re-enter Edit Layout, change the rectangle, then Cancel.
   Confirm that the earlier rectangle returns.
6. Pin the panel and confirm that moving, resizing and Clear Panels cannot
   remove or reposition it. Unpin it, clear it and cancel to restore it.
7. Return to the product default, then select the named custom layout again.
8. Repeat at a narrow window size and the supported display scales. Check theme
   colours, keyboard focus and normal product controls.
   Maximise an eligible internal panel and restore it. Check its draft, selection
   and saved rectangle, then select a different tool from search. Confirm that
   normal navigation restores the workspace and does not unlock movement.
9. In a client with connected storage, Apply and Lock, then choose Save Layout.
   Check whether the status says disk or memory. Close and reopen the same
   application with the same user configuration. For disk storage, confirm
   that the explicitly saved layout returns. Do not treat Apply alone as Save.

For Studio, follow the product's Custom IDE Workspaces guide. Type an unsaved
draft, switch through a blank canvas and reopen Editor. Check the text, cursor,
selection and buffer identity after layout and ordinary status refreshes.
Include non-ASCII text: the document model counts UTF-8 bytes, whereas GTK
counts characters. The adapter translates between them. The current editor
snapshot is limited to 16,383 UTF-8 bytes; oversized insertion must report the
limit without silently saving shortened text. Full-size document-store editing
is a separate unfinished part of the Studio development loop.

Record the binary path, toolchain, exit codes and screenshots. Restart recovery
has source-level acceptance coverage, but no passing native evidence yet.
Multi-monitor recovery, forced-crash recovery, the complete named-layout
library, docking gestures, movable menus/toolbars and
complete product readiness are not certified by this update. No new test has
been compiled or executed during this source review.
