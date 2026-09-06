# Workbench Canvas Core Implementation

**Status:** Portable model, native free canvas and Studio shell source integration are present; compilation and native acceptance remain pending. Durable canvas recovery and monitor transfer remain open.  
**Recorded:** 6 September 2026  
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

The shared GTK4 suite workstation now has New Layout, Canvas placement, Clear
Panels and numeric position/size controls in source. Its renderer uses separate
in-canvas rectangles, title-bar movement, a lower-right resize handle and an
edit grid. It no longer turns free panels into centre tabs. Valid empty layouts
also produce a native canvas rather than a render-plan error.

This is source integration, not a verified application result. Studio's main
GTK shell now constructs the same native host using its professional-workspace
customisation owner. Its old placement arrays are derived display information;
the separate GTK edit baseline is removed. The original editor is retained as
one real panel body. Named empty canvases, opening tools and Apply/Cancel use
the shared model. No second canvas is inserted beside the former shell.

Studio opts into bounded provider-body retention across layout rebuilds.
Disposable mounts separate each body from its old frame before frame actions
are invalidated. The editor adapter also reconciles document views so routine
status updates do not replace unchanged text buffers. Context colours resolve
through the existing group store rather than treating a group ID as a colour.
These changes have C regression coverage in source, not passing test evidence.
Native interaction and restart journeys have not been executed here.

The canvas coordinator and suite-layout bridge keep their existing entry
points. Studio migration changes runtime function bodies and private
presentation state; existing comments are preserved or replaced with relevant
explanations. The coordinator uses a direct `<math.h>` dependency
for safe normalised-grid calculations. A separate result structure and
placement token are additive. The current render plan and observable GTK
snapshots append canvas fields; all consumers must be rebuilt together. Existing
placement enum values are unchanged. This is not a binary-compatibility claim
for an old executable loading a newly built library.

The companion approved specification remains the product-design authority. Its requirements are not a statement that all described behaviour is implemented.

## Existing contracts reused

The operations work directly with `UmiUiWorkspaceCustomisation`, `UmiUiWorkspaceLayout`, `UmiUiWorkspaceWindow`, the existing window catalogue and context-group store. They reuse the established begin/commit/cancel transaction and layout/context operations. No application-specific implementation is introduced.

The caller must have exclusive synchronous ownership of the customisation while invoking these operations. The functions do not introduce locking, asynchronous jobs, policy engines or application-session ownership.

## Create a blank layout

`umi_ui_workspace_customisation_create_blank_layout(customisation, layout_id, name)` creates and activates an empty, locked layout while retaining all existing layouts and catalogue definitions. It uses the existing layout initialisation operation and publishes a complete candidate only after validation succeeds.

The operation rejects an active edit, an empty or overlong ID/name, an existing layout ID, exhausted capacity, malformed bounded records and revision overflow. Duplicate readable names are allowed; stable layout IDs remain unique. Allocation or validation failure leaves the original customisation unchanged. Input strings may refer to the original customisation because the candidate is separate.

Blank-layout creation is a separate committed operation. Call the existing begin-edit operation to start arranging its contents. Cancel then returns the contents to that blank layout; it does not undo creation of the named layout itself. The shared native New Layout control accepts a display name and creates an application-qualified stable ID. Undoing creation itself remains future work.

## Clear the active canvas

`umi_ui_workspace_customisation_clear_canvas(customisation, out_result)` runs inside the existing edit transaction. It removes closable, unpinned instances from the active layout and reports removed/retained counts. This includes detached instances owned by that active layout, but does not remove instances from other stored layouts.

Pinned or non-closable records remain. The shared Clear Panels control reports retained instances rather than claiming the entire canvas is empty. The result pointer is optional, must not overlap the customisation, and is written only on success.

The operation preserves catalogue definitions, product data, theme, named layouts and the transaction baseline. It removes reverse linked-context membership only when the removed instance ID no longer appears in any stored layout. This protects legacy saved layouts that reuse an instance ID. Context-group definitions remain available. Cancel restores the existing layout and group baselines; commit uses the established lock/validation path.

A heap-backed candidate avoids placing the large customisation object on the stack. Failed allocation or mutation publishes neither a partial layout nor a partial result. Unused active-layout slots are cleared after successful removal, preventing removed instance metadata from remaining in those slots. This is not deletion from product storage.

Clearing an already empty or fully protected layout is a no-op and does not increment its revisions. The core does not display a confirmation dialog or run product unsaved-document checks: a command/controller must perform those checks before invoking it.

## Record free placement inside the canvas

`umi_ui_workspace_customisation_place_canvas_window(customisation, window_id, x, y, width, height)` records the rectangle of an existing instance in normalised canvas coordinates. It supports a future move/resize gesture without making widget geometry authoritative.

It requires an active edit and an unlocked active layout. It rejects a pinned instance. A non-resizable instance may move but cannot change its stored size. Rectangles must be finite, positive-sized and inside the unit canvas; invalid input leaves the model unchanged. Identity, tool reference, context membership and z-order are retained. The instance becomes visible and not maximised.

The placement token is `UMI_UI_WORKSPACE_CANVAS_PLACEMENT`, whose value is `canvas`. The existing `floating` flag is set to false because its established meaning is a **detached native window**, not a movable window contained by a canvas. The instance receives its own stack identity rather than remaining accidentally grouped with a previous dock stack.

The render plan separates up to 64 canvas items from the existing 16 dock-stack
slots. Each canvas item keeps its source window index, rectangle and z-order.
GTK renders those items independently of dock tabs and native detached windows.
Invalid or non-finite rectangles are rejected before conversion to pixels.

Pointer movement changes only a temporary view rectangle. Drag completion
queues one copied request with the source layout revision. The existing
customisation operation accepts it inside the current edit; it does not begin
or commit a nested edit. Cancel therefore retains the original baseline.
Rebuilding, changing the callback or destroying the host cancels queued work.
Geometry-only updates retain existing panel widgets so movement does not erase
an unsent field or move focus into a recreated form.

The shared panel editor also submits Canvas position and size as percentages.
Geometry, placement and linked context are validated on one candidate. Canvas
auto-hide is rejected because it has no dock edge. Full docking gestures,
eight-direction resizing, monitor restoration and native acceptance remain open.

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
| Blank-layout model operation | Core and shared New Layout control implemented in source | Native creation, selection and capacity validation |
| Clear removable instances | Core and shared reversible Clear Panels control implemented in source | Product unsaved-work guards and native retained-panel validation |
| Free in-canvas rectangle | Separate render-plan items and native renderer implemented in source | Compile, native gesture acceptance and restart recovery |
| Multi-panel edit transaction | Implemented; coordinator test covers success and rollback | Bind multi-selection and docking gestures in each graphical adapter |
| Surface-state snapshot | Implemented; coordinator test covers complete and short outputs | Use the copied records in menus, accessibility and monitor views |
| Apply/Cancel model reuse | Tested for affected layout/group state | GTK scene restoration and detached-window lifecycle restoration |
| Official icon | Shared resource lookup, staging and native identity integrated in source; artwork unchanged | Verify the approved asset in headers, native windows and installed executables at supported scales |
| Grid and snapping | Portable geometry and native edit grid/preview implemented in source | Native pointer and keyboard acceptance; configurable grid |
| Drag and resize | Native title movement and lower-right resize implemented in source | Eight resize directions, Studio migration and boundary acceptance |
| Dock, split and tab integration | Not changed | Reuse/audit existing contracts; no competing dock model |
| Native detach/reattach | The shared GTK4 layout host creates detached native windows; runtime acceptance pending | Same-instance state preservation, reattachment and monitor/host journeys |
| Multiple canvas hosts and application sessions | Not implemented here | Session ownership and acknowledged cross-host transfer |
| Layout persistence | Explicit native canvas checkpoint bridge uses the existing Data Server chunk store and UI codec in source; memory and disk backends are distinguished | Run restart/conflict/corruption acceptance; complete library, migration and repair workflows |
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
