<!--
  Umicom Framework
  File: docs/major-batches/WORKBENCH_PANEL_BATCH_OPERATIONS.md

  PURPOSE:
    Explain the public multi-panel canvas operation added for this update.
    The document describes the contract without relying on a particular
    graphical toolkit or application.

  AUTHOR AND ORGANISATION:
    Sammy Hegab
    Umicom Foundation

  LICENCE:
    MIT
-->

# Workbench panel batch operations

## What changed

The Framework now has one operation for applying several panel placement
requests together:

`umi_ui_workbench_canvas_apply_panel_batch(...)`

It also has a safe read operation,
`umi_ui_workbench_canvas_surface_snapshot(...)`, which copies the current
surface records for a renderer, menu or accessibility view.

This is useful when a user moves, resizes or groups several panels while
editing a layout. The operation opens one edit session, checks each request,
and publishes the result only when every request succeeds.

## Why one transaction matters

Without a batch operation, the first panel could move successfully while a
later panel fails. The canvas would then be left half changed. The batch
operation keeps the old layout as a safety copy. If any request is invalid,
the Framework restores the old panel positions, visibility, placement and
context links together.

The operation also advances the host and canvas revision only after the full
list has been accepted. Frontends can therefore redraw once and observers can
associate one revision with one user action.

## Contract rules

- The canvas, host ID and request array are required.
- The request list must contain at least one item.
- At most `UMI_UI_WORKBENCH_CANVAS_MAX_PANEL_BATCH` items are accepted.
- The host must already be registered and must have a customisation model.
- Every request uses the existing `UmiUiWorkspacePanelSettings` rules.
- A floating request must contain a finite, positive rectangle inside the
  normalised canvas.
- A docked request must name a supported placement and tab stack.
- A context group must already exist when a request links a panel to one.
- The caller keeps ownership of the request array and its strings. They are
  read only while the function is running.

## How applications use it

1. Start Edit Layout through the Framework canvas controller.
2. Fill one `UmiUiWorkspacePanelSettings` value for each panel.
3. Call `umi_ui_workbench_canvas_apply_panel_batch(...)` with the host ID.
4. If the result is `UMI_STATUS_OK`, refresh the canvas from the Framework
   model.
5. If another status is returned, show the reason and keep the previous layout.

Applications do not need to copy layout records, update reverse context
membership or manage rollback themselves. Those details remain in the
Framework, so every frontend follows the same behaviour.

The application-suite and product wrappers use the same rule. A shared suite
workstation can call `umi_application_suite_gtk4_workstation_apply_panel_batch`
and Studio or Trader can call its thin product wrapper. These entry points keep
product code small while preserving the Framework capability checks. The
lower-level `umi_ui_workspace_customisation_apply_panel_batch(...)` operation
is available when a controller already owns an edit session and needs to stage
several requests before its own Apply or Cancel command.

When a frontend needs the current detached and monitor state, it supplies a
fixed output array to `umi_ui_workbench_canvas_surface_snapshot(...)`. The
Framework reports the required count and rejects an array that is too small;
it never silently drops a panel.

## Verification

The Workbench Canvas regression test covers:

- a valid two-panel edit;
- rollback when the second panel ID is unknown;
- preservation of the old layout after rollback;
- floating and docked results in one successful operation; and
- rejection of an empty request list;
- rejection of a short surface-snapshot array; and
- successful copying of all surface records.

The graphical adapter still decides how drag handles, snap guides and docking
previews look. It should call this operation when one gesture changes more
than one panel.
