# Workbench Canvas Core Implementation

**Status:** Portable core implemented and tested; graphical integration pending.  
**Recorded:** 5 September 2026  
**Owner:** Umicom Framework  
**Approved requirements:** `UMICOM_WORKBENCH_CANVAS_AND_INTEROPERABILITY.md`

## Scope and visible effect

This change begins the approved user-composed canvas implementation. It extends the existing Framework workspace customisation contract. It does not create another layout store, application registry, GUI shell or docking engine.

**This is not a finished graphical workbench update. Rebuilding an application with these files alone will not add a blank-canvas button, draggable internal windows or resize handles. No application frontend calls the new operations yet.**

Two existing production files change: the public workspace customisation header and its C implementation. The existing public structures, declarations, function bodies, variable names and comments are preserved. The source adds a direct `<math.h>` dependency and new operations. A separate result structure and placement token are additive; existing structure layouts and enum values do not change.

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

**The current GTK layout host does not implement this new placement mode. Its previous unknown-placement fallback is not a valid canvas renderer. Do not expose this operation in a product UI until the layout projection and renderer explicitly recognise it.** Existing placement parsers, render plans, serialization/migration and frontend conformance still require review for this token. It is an additive core representation, not a claim of completed end-to-end support.

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

The approved asset, not a text substitute, must be bound into the native host identity. No icon files are copied, invented or modified by this core delivery. Icon-loading code, staging and visible placement remain unmodified and untested here.

## Framework and client ownership

All three operations are Framework-owned. No source is copied into Studio, Bank, Trader or any other client. Availability of these functions is **not** proof that a client has adopted them. The application inventory and unverified integration state are recorded in `../validation/WORKBENCH_CANVAS_VALIDATION.md`.

The Framework Master Controller and bounded Slave Controllers retain lifecycle and domain authority. Frontend adapters must dispatch typed requests and render accepted state rather than directly mutating private state or introducing an application-local canvas implementation.

## Implementation roadmap and acceptance gates

| Feature | Current state | Required next evidence |
|---|---|---|
| Blank-layout model operation | Implemented; portable tests pass | Framework command binding and visible layout selection |
| Clear removable instances | Implemented; portable tests pass | Unsaved-work/permission checks, confirmation and rendered removal |
| Free in-canvas rectangle | Implemented; portable tests pass | Compatible render plan, placement serialization and actual internal-window renderer |
| Apply/Cancel model reuse | Tested for affected layout/group state | GTK scene restoration and detached-window lifecycle restoration |
| Official icon | Catalogue located only | Actual resource resolution, staging and native header rendering |
| Grid and snapping | Not implemented | Portable snap policy, visual previews and pointer/keyboard tests |
| Drag and resize | Not implemented | Gesture-to-command binding, eight resize directions and boundary tests |
| Dock, split and tab integration | Not changed | Reuse/audit existing contracts; no competing dock model |
| Native detach/reattach | Existing mechanism not changed or retested | Same-instance state preservation and monitor/host journeys |
| Multiple canvas hosts and application sessions | Not implemented here | Session ownership and acknowledged cross-host transfer |
| Layout persistence | Not implemented here | Data Server integration and compatible schema/recovery tests |
| Semantic clipboard | Not implemented here | Typed payloads, capability policy and cross-application journeys |
| Complete client adoption | Pending for every client | Product startup and visible acceptance, not just catalogue presence |

The immediate graphical acceptance gate is: product default -> Create Blank Layout -> add a real panel -> move and resize it inside the canvas -> Apply and Lock -> re-enter edit -> change it -> Cancel restores the prior arrangement. Preserve the official icon and host controls throughout. This sequence has **not** been executed in a graphical application by this delivery.

## Testing and integration

The new standalone test project is `framework/tests/workspace_canvas`. It compiles the changed customisation source and the real existing layout and window-group sources. It uses linker section collection to include only the portable operations exercised by the tests; consequently it does not prove linkage of the complete Framework UI library.

The test project is not yet registered in the suite-wide CTest tree. Existing suite build files are not replaced. The changed production implementation remains in its existing source file, while the isolated test is configured separately. Exact commands, results and limitations are in the validation record.
