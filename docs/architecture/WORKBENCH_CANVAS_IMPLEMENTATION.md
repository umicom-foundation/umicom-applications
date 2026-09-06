# Workbench Canvas Core Implementation

**Status:** Portable core and explicit GTK4 centre projection implemented; validation pending in the copied worktree; full gesture and monitor integration pending.  
**Recorded:** 5 September 2026  
**Owner:** Umicom Framework  
**Approved requirements:** `UMICOM_WORKBENCH_CANVAS_AND_INTEROPERABILITY.md`

## Scope and visible effect

This change begins the approved user-composed canvas implementation. It extends the existing Framework workspace customisation contract. It does not create another layout store, application registry, GUI shell or docking engine.

The portable coordinator also exposes one shared application-host bootstrap:
`umi_ui_workbench_canvas_add_application_host()` loads a validated Framework
experience, registers its panels and product layouts, and then attaches that
model to a Workbench Host. Moving, resizing and snapping use the semantic
in-canvas placement token; the existing `floating` flag remains reserved for a
detached native window. The application-aware bridge is compiled with the
suite-layout application target, while the lower-level canvas mechanics stay
in the UI target. `UmicomApplicationSuiteLayoutPlatform.cmake` declares the
application-to-UI link explicitly, keeping static-library dependency direction
one-way.

Host lifetime is explicit as well: `umi_ui_workbench_canvas_remove_host()`
unregisters a closing native window, leaves its caller-owned customisation
model untouched, repairs the active-host selection and publishes one revision.
This prevents a multi-application session from routing commands to a window
that no longer exists. The shared GTK4 suite workstation stores its generated
host key and invokes this operation before releasing the native layout host, so
failed startup and normal window shutdown follow the same ownership rule.

Cross-host application-tab movement uses the separate
`UmiApplicationSurfaceTransferToken` contract. A token carries only stable
session/checkpoint references and capability fingerprints. The destination
acknowledges rehydration before the source commits ownership release, so a
failed transfer leaves the source tab usable and a retried acknowledgement is
safe. Token creation, expiry and cancellation are implemented in the
Framework application runtime; checkpoint storage and secure token generation
remain service-owned.

Canvas command commits also synchronise surface metadata while the edit
baseline is still available. If validation or commit rejects an edit, the
coordinator cancels the transaction and refreshes its surface table instead of
leaving a half-open edit or a stale detached-window record behind.

**This is not a finished graphical workbench update. Rebuilding an application with these files alone will not add a blank-canvas button, draggable internal windows or resize handles. The shared GTK4 suite workstation now registers the portable canvas host, while gesture dispatch, internal-window rendering and monitor transfer remain separate integration work.**

The canvas coordinator and suite-layout bridge are additive production units.
The existing public structures, declarations, function bodies, variable names
and comments are preserved. The coordinator uses a direct `<math.h>` dependency
for safe normalised-grid calculations. A separate result structure and
placement token are additive; existing structure layouts and enum values do
not change.

The companion approved specification remains the product-design authority. Its requirements are not a statement that all described behaviour is implemented.

## Existing contracts reused

The operations work directly with `UmiUiWorkspaceCustomisation`, `UmiUiWorkspaceLayout`, `UmiUiWorkspaceWindow`, the existing window catalogue and context-group store. They reuse the established begin/commit/cancel transaction and layout/context operations. No application-specific implementation is introduced.

The caller must have exclusive synchronous ownership of the customisation while invoking these operations. The functions do not introduce locking, asynchronous jobs, policy engines or application-session ownership.

## Create a blank layout

`umi_ui_workspace_customisation_create_blank_layout(customisation, layout_id, name)` creates and activates an empty, locked layout while retaining all existing layouts and catalogue definitions. It uses the existing layout initialisation operation and publishes a complete candidate only after validation succeeds.

The operation rejects an active edit, an empty or overlong ID/name, an existing layout ID, exhausted capacity, malformed bounded records and revision overflow. Duplicate readable names are allowed; stable layout IDs remain unique. Allocation or validation failure leaves the original customisation unchanged. Input strings may refer to the original customisation because the candidate is separate.

Blank-layout creation is a separate committed operation. Call the existing begin-edit operation to start arranging its contents. Cancel then returns the contents to that blank layout; it does not undo creation of the named layout itself. Automatic name generation, UI confirmation and undoing creation are frontend/controller integration work.

## Clear the active canvas

`umi_ui_workspace_customisation_clear_canvas(customisation, out_result)` runs inside the existing edit transaction. It removes closable, unpinned instances from the active layout and reports removed/retained counts. This includes detached instances owned by that active layout, but does not remove instances from other stored layouts.

Pinned or non-closable records remain. The future UI must explain those retained records rather than claiming the entire canvas is empty. The result pointer is optional, must not overlap the customisation, and is written only on success.

The operation preserves catalogue definitions, product data, theme, named layouts and the transaction baseline. It removes reverse linked-context membership only when the removed instance ID no longer appears in any stored layout. This protects legacy saved layouts that reuse an instance ID. Context-group definitions remain available. Cancel restores the existing layout and group baselines; commit uses the established lock/validation path.

A heap-backed candidate avoids placing the large customisation object on the stack. Failed allocation or mutation publishes neither a partial layout nor a partial result. Unused active-layout slots are cleared after successful removal, preventing removed instance metadata from remaining in those slots. This is not deletion from product storage.

Clearing an already empty or fully protected layout is a no-op and does not increment its revisions. The core does not display a confirmation dialog or run product unsaved-document checks: a command/controller must perform those checks before invoking it.

## Record free placement inside the canvas

`umi_ui_workspace_customisation_place_canvas_window(customisation, window_id, x, y, width, height)` records the rectangle of an existing instance in normalised canvas coordinates. It supports a future move/resize gesture without making widget geometry authoritative.

It requires an active edit and an unlocked active layout. It rejects a pinned instance. A non-resizable instance may move but cannot change its stored size. Rectangles must be finite, positive-sized and inside the unit canvas; invalid input leaves the model unchanged. Identity, tool reference, context membership and z-order are retained. The instance becomes visible and not maximised.

The placement token is `UMI_UI_WORKSPACE_CANVAS_PLACEMENT`, whose value is `canvas`. The existing `floating` flag is set to false because its established meaning is a **detached native window**, not a movable window contained by a canvas. The instance receives its own stack identity rather than remaining accidentally grouped with a previous dock stack.

The GTK layout host now explicitly recognises this token and projects canvas-managed
panels into the centre workspace. Pointer gesture dispatch, internal-window chrome,
serialization/migration, and monitor transfer still require frontend conformance
work; the additive core and this projection are not a claim of completed
end-to-end desktop editing.

## Apply several panel changes together

`umi_ui_workbench_canvas_apply_panel_batch(canvas, host_id, settings,
setting_count)` is the shared entry point for one gesture that changes more than
one panel. It accepts the existing `UmiUiWorkspacePanelSettings` records and
applies them inside one edit transaction.

The request list is bounded and copied before the edit starts. Each panel is
checked by the same placement, size, lock and context rules used by a single
panel edit. If one item fails, the Framework cancels the transaction and
restores every panel and context link from the original baseline. A successful
list is committed once, which gives renderers one coherent revision to draw.

This keeps layout editors small: they describe the requested result and let
the Framework own validation, rollback and revision tracking. The request
array and its strings remain caller-owned and are not stored after the call.

`umi_ui_workbench_canvas_surface_snapshot(host, out_surfaces, capacity,
out_count)` provides the matching read path. It copies every surface record,
including its monitor, visibility, detached flag and revision. A destination
that is too small is rejected, so menus and renderers never display an
incomplete view of the canvas.

## What the portable sequence now supports

```text
create a named blank layout
    -> begin the established edit transaction
    -> add a registered instance through existing operations
    -> record its canvas rectangle through the new operation
    -> commit, or cancel to the captured baseline

existing active layout
    -> begin edit
    -> clear removable instances and orphaned context memberships
    -> commit, or cancel to restore the baseline
```

The added tests construct layout fixtures with the real lower-level layout operations. They do not test graphical catalogue selection, gesture dispatch, application startup or Data Server persistence.

## Official resource discovery

The pinned Framework resource catalogue identifies:

| Resource ID | Locator relative to Framework resources |
|---|---|
| `umicom.brand.icon.primary` | `brand/umicom-icon.svg` |
| `umicom.brand.icon.on-dark` | `brand/umicom-icon-on-dark.svg` |
| `umicom.brand.icon.windows` | `brand/umicom.ico` |

The approved asset, not a text substitute, is the native identity source. The
original portable-core change did not alter icon loading. Subsequent shared
GTK4 work has integrated executable-relative resource lookup, build staging,
header loading and native window identity in source. The canonical SVG and ICO
artwork is unchanged. Visible placement, display scaling and packaged runtime
behaviour still require native verification.

## Framework and client ownership

All canvas operations are Framework-owned. No source is copied into an
application client. Availability of these functions is **not** proof that a
client has adopted them. The application inventory and unverified integration
state are recorded in `../validation/WORKBENCH_CANVAS_VALIDATION.md`.

The Framework Master Controller and bounded Slave Controllers retain lifecycle and domain authority. Frontend adapters must dispatch typed requests and render accepted state rather than directly mutating private state or introducing an application-local canvas implementation.

## Implementation roadmap and acceptance gates

| Feature | Current state | Required next evidence |
|---|---|---|
| Blank-layout model operation | Implemented; portable tests pass | Framework command binding and visible layout selection |
| Clear removable instances | Implemented; portable tests pass | Unsaved-work/permission checks, confirmation and rendered removal |
| Free in-canvas rectangle | Implemented; portable tests pass | Compatible render plan, placement serialization and actual internal-window renderer |
| Multi-panel edit transaction | Implemented; coordinator test covers success and rollback | Bind multi-selection and docking gestures in each graphical adapter |
| Surface-state snapshot | Implemented; coordinator test covers complete and short outputs | Use the copied records in menus, accessibility and monitor views |
| Apply/Cancel model reuse | Tested for affected layout/group state | GTK scene restoration and detached-window lifecycle restoration |
| Official icon | Shared resource lookup, staging and native identity integrated in source; artwork unchanged | Verify the approved asset in headers, native windows and installed executables at supported scales |
| Grid and snapping | Portable coordinator operation implemented | Visual previews, pointer/keyboard tests and adapter binding |
| Drag and resize | Portable move/resize operations implemented | Gesture-to-command binding, eight resize directions and boundary tests |
| Dock, split and tab integration | Not changed | Reuse/audit existing contracts; no competing dock model |
| Native detach/reattach | The shared GTK4 layout host creates detached native windows; runtime acceptance pending | Same-instance state preservation, reattachment and monitor/host journeys |
| Multiple canvas hosts and application sessions | Not implemented here | Session ownership and acknowledged cross-host transfer |
| Layout persistence | Data Server-backed stores exist; shared suite Save/Restore currently retains an in-memory checkpoint | Connect durable storage and prove compatible schema/recovery across restart |
| Semantic clipboard | Not implemented here | Typed payloads, capability policy and cross-application journeys |
| Complete client adoption | Six dedicated frontends and eighteen shared native layout-preview entry points exist in source | Product startup, real service bindings and visible acceptance, not just catalogue presence |

The immediate graphical acceptance gate is: product default -> Create Blank Layout -> add a real panel -> move and resize it inside the canvas -> Apply and Lock -> re-enter edit -> change it -> Cancel restores the prior arrangement. Preserve the official icon and host controls throughout. This sequence has **not** been executed in a graphical application by this delivery.

Historical portable test results in this document do not certify later native
changes. The [Workbench Feature Roadmap](WORKBENCH_FEATURE_ROADMAP.md) records
the current priority order and separates source integration from runtime proof.

## Testing and integration

The transaction-focused standalone test project is `framework/tests/workspace_canvas`. It compiles the changed customisation source and the real existing layout and window-group sources. It uses linker section collection to include only the portable operations exercised by the tests; consequently it does not prove linkage of the complete Framework UI library.

The higher-level coordinator test is `framework/tests/test_workbench_canvas.c`
and is registered as `framework.ui.workbench_canvas` by the Framework CMake
file. It exercises the canonical application catalogue, host bootstrap and
canvas lifecycle. Neither test is a substitute for GTK event-loop, monitor,
resource-packaging or full application acceptance evidence. The coordinator
changes made after the historical validation record require a fresh local
validation run.
