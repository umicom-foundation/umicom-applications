# Workbench Canvas application layouts

The Framework owns the Workbench Host, canvas, layout editing and panel
lifecycle.  An application supplies an experience catalogue: its identity,
panels, named layout recipes and product-specific capabilities.  This keeps
Studio, Trader, Bank, TMS and the other applications consistent while still
allowing each product to start with a useful arrangement.

## One entry point for every application

`umi_ui_workbench_canvas_add_application_host()` is the shared bootstrap
operation.  It performs these steps in order:

1. Check the host identity and the bounded host capacity.
2. Load the application experience from the Framework catalogue.
3. Register every panel as a reusable New Window item.
4. Create every named layout and activate the declared default layout.
5. Attach the resulting customisation model to a native Workbench Host.

Because the loader publishes only a complete candidate model, an invalid panel,
layout or context-group relationship cannot replace an existing usable model.
The host then exposes the same move, resize, dock, tab, snap, detach, attach,
lock and clear operations for every application.

## Product boundary

Application modules should register product metadata in their Framework
experience definition.  They should not create another GTK layout store, copy
the docking rules, or keep a second list of panel instances.  Frontend adapters
render the host and forward user actions to the shared canvas contract.

The active layout is a starting recipe, not a permanent screen.  Users may
create a blank layout, add panels from the catalogue, arrange panels across
hosts and monitors, save the arrangement, and lock it.  Essential host controls
remain available when the working canvas is cleared.

## Coverage check

`test_workbench_canvas.c` walks the complete Framework experience catalogue and
loads each application definition through the same customisation loader.  This
ensures every published application has at least one valid layout and that the
number of projected layouts matches its declared catalogue.
