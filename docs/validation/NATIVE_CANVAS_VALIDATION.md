<!--
  Umicom Applications
  File: docs/validation/NATIVE_CANVAS_VALIDATION.md
  Purpose: Explain native canvas behaviour, consumer coverage and acceptance.
  Author: Sammy Hegab, Umicom Foundation
  Licence: MIT
-->

# Native canvas validation

## Delivery state

Recorded 6 September 2026. This update contains C implementation, C tests,
build registration and documentation. It has not been compiled, linked or run
in a native application during this review. Test code is not a passing result.
No logo artwork, user project, stored layout, repository history or secret is
removed by this update.

## What changes

The shared Framework workstation now distinguishes three arrangements:

| Arrangement | Meaning |
|---|---|
| Docked panel | A tab or group in a named dock region. |
| Canvas panel | An independent rectangle inside the host window. |
| Detached window | A separate operating-system window. |

Canvas panels no longer become centre tabs. Their rectangles use fractions of
the available canvas, so resizing the host keeps them inside it. The render
plan supports up to 64 canvas records independently of its 16 dock-stack slots.
An empty layout is valid. A malformed rectangle is rejected before GTK uses it.

New Layout creates a named empty arrangement without changing existing presets.
Edit Layout starts a reversible edit. Canvas position and size can be changed
using the title handle, lower-right resize handle, or percentage fields in
Panel Settings. The edit grid uses a 2.5 percent step. Configurable grid size,
the other resize directions and keyboard dragging remain future work.

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
are not treated as colour names or arbitrary CSS selectors. Internal maximise
is not offered until its presentation is implemented; detached native windows
retain their existing maximise behaviour.

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
| Desk | Shares header components, but its dedicated host is not the suite canvas renderer. | Explicit host adoption and session ownership. |

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
| `umicom-gtk4-workspace-canvas-test` | `framework.ui_workstation.workspace.canvas.gtk4` |
| `umicom-gtk4-workspace-content-test` | `framework.ui_workstation.workspace.content.gtk4` |
| `umicom-studio-runtime-workspace-canvas-test` | `framework.studio_runtime.workspace-canvas` |
| `umicom-studio-workspace-canvas-test` | `studio.workspace.canvas.gtk4` |
| `umicom-studio-source-control-offline-test` | `studio.source_control_offline` |
| `umicom-workbench-layout-data-workspace-namespace-test` | `framework.workbench_layout_data.workspace_namespace` |
| `umicom-ui-workspace-checkpoint-test` | `framework.ui.workspace-checkpoint` |
| `umicom-gtk4-workspace-checkpoint-test` | `framework.ui_workstation.workspace.checkpoint.gtk4` |

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

```powershell
Set-Location "C:\umicom\umicom-applications"
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"
& "C:\msys64\ucrt64\bin\cmake.exe" --preset windows-ucrt64-all-debug
if ($LASTEXITCODE -ne 0) { throw "Configuration failed" }
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --target umicom-desktop-products umicom-application-suite-layout-canvas-projection-test umicom-gtk4-workspace-canvas-test umicom-gtk4-workspace-content-test umicom-studio-runtime-workspace-canvas-test umicom-studio-workspace-canvas-test umicom-studio-source-control-offline-test umicom-workbench-layout-data-workspace-namespace-test umicom-ui-workspace-checkpoint-test umicom-gtk4-workspace-checkpoint-test --parallel 2
if ($LASTEXITCODE -ne 0) { throw "Build failed" }
& "C:\msys64\ucrt64\bin\ctest.exe" --test-dir "C:\umicom\umicom-applications\build\windows-ucrt64-all-debug" -R "framework.application_suite.layouts.canvas.projection|framework.ui_workstation.workspace.(canvas|content|checkpoint).gtk4|framework.studio_runtime.workspace-canvas|studio.workspace.canvas.gtk4|studio.source_control_offline|framework.workbench_layout_data.workspace_namespace|framework.ui.workspace-checkpoint" --no-tests=error --output-on-failure
if ($LASTEXITCODE -ne 0) { throw "Canvas validation failed" }
```

## Native acceptance journey

Close older running instances before opening the new binary. Use the executable
from the same build directory, not a shortcut to another build.

1. Open Trader or Bank and confirm its default panels and official identity.
2. Choose New Layout, enter a name and create the empty layout.
3. Choose Edit Layout, then New Window, Canvas, and a real product panel.
4. Move its title handle, resize its lower-right handle, and check the percentage
   fields in Panel Settings. Confirm that the panel stays inside the canvas.
5. Apply and Lock. Re-enter Edit Layout, change the rectangle, then Cancel.
   Confirm that the earlier rectangle returns.
6. Pin the panel and confirm that moving, resizing and Clear Panels cannot
   remove or reposition it. Unpin it, clear it and cancel to restore it.
7. Return to the product default, then select the named custom layout again.
8. Repeat at a narrow window size and the supported display scales. Check theme
   colours, keyboard focus and normal product controls.
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
library, all-direction resizing, docking gestures, movable menus/toolbars and
complete product readiness are not certified by this update. No new test has
been compiled or executed during this source review.
