# Umicom Workbench Canvas, Layout and Interoperability

**Status:** Approved and mandatory  
**Owner:** Umicom Foundation  
**Project lead:** Sammy Hegab  
**Scope:** Umicom Framework and every current or future Umicom application  
**Canonical rule:** This document is the durable source of truth. Chat discussion is secondary.

## 1. Governing product decision

Every graphical Umicom application runs inside a **Framework-owned Workbench Host**.

The Workbench Host contains a **user-owned canvas**. The canvas is not a fixed set of hard-coded left, centre, right and bottom boxes. A product default layout is shown on first use, but the user may create a blank layout, clear the current canvas, add the surfaces they need, move and resize them, dock or float them, detach them to another monitor, save the result and restore it later.

Umicom Framework is the only owner of:

- the Workbench Host;
- the canvas;
- surfaces, panels and tool windows;
- docking and snapping;
- floating and detached windows;
- application, document and layout tabs;
- menu and toolbar surfaces;
- layout editing and locking;
- multi-window and multi-monitor state;
- cross-application data exchange;
- persistence, migration and recovery;
- accessibility and frontend rendering.

Client applications remain thin. They select a Framework product profile and provide identity, product-specific commands, view models and genuinely product-specific workflows. They do not recreate the shared workbench.

## 2. Required visible hierarchy

```text
Native Workbench Host window
├── official Umicom product icon from the Framework resource catalogue
├── full application or host name
├── active workspace, document or session state
├── native minimise, maximise/restore and close controls
├── application-session tabs
├── Framework command, menu and toolbar surfaces
├── user-owned canvas
│   ├── docked surface groups
│   ├── tabbed surface groups
│   ├── split regions
│   ├── floating-in-canvas surface windows
│   └── product content
├── activity and status surfaces
└── named layout tabs and Layout Library action
```

The official Umicom icon must be loaded from the existing Framework asset/resource catalogue. A textual substitute such as `<>` is not approved branding.

## 3. Product default and blank canvas

Each application has at least one Framework-defined product default layout.

On first use:

1. the application opens its default layout;
2. the layout is initially locked;
3. all surfaces are backed by real Framework definitions and product view models;
4. the user may work immediately or enter Edit Layout mode.

The user can then choose:

- **Create Blank Layout** — creates a new named layout containing the mandatory host controls but no product surfaces;
- **Clear Current Canvas** — removes all removable surface instances from the current layout after confirmation;
- **Duplicate Layout** — creates a new user-owned copy;
- **Reset to Product Default** — preserves the user layout as a recovery checkpoint and restores the Framework template.

Clearing the canvas does **not** delete product data, commands, surface definitions, documents or services. It changes only layout instances.

The following host controls remain available even on a blank canvas:

- application identity;
- global command access;
- New Surface / New Window catalogue;
- layout lock state;
- named layout tabs;
- save and recovery access;
- native window controls.

## 4. Surface model

A **surface** is the universal Framework concept behind:

- panels;
- tool windows;
- document groups;
- editors;
- charts;
- grids;
- terminals;
- inspectors;
- designers;
- dashboards;
- menus;
- command bars;
- toolbars;
- status areas;
- application-session views.

The model separates three forms of state.

### Surface definition

Defines what a reusable surface is:

- stable surface type ID;
- display name and icon;
- owning Framework capability;
- required permissions;
- supported contexts;
- allowed placement modes;
- minimum and preferred size;
- close, pin, auto-hide, maximise and detach capabilities;
- factory for toolkit-neutral view state.

### Surface instance

Defines where one occurrence appears:

- stable instance ID;
- owning Workbench Host;
- owning application surface session;
- dock tree position;
- tab group;
- floating rectangle;
- z-order;
- visibility;
- pinned and auto-hide state;
- maximised state;
- context group membership.

### Surface session

Defines transient product state:

- active document, instrument, account, customer, model or connection;
- selection;
- scroll and zoom position;
- filters;
- unsaved work;
- running operation;
- product-specific view state.

GTK widgets are rendered projections. GTK pointers are never the authoritative layout, product or session state.

## 5. Placement modes

Every eligible surface supports the placement modes declared by its Framework definition.

### Docked

The surface is attached to an edge, split region or tab group in the canvas.

### Floating inside the canvas

The surface behaves as a movable internal window:

- drag by its title area;
- resize from edges and corners;
- preserve z-order;
- snap to the canvas grid, edges and other surfaces;
- maximise within the canvas;
- restore to the previous rectangle.

### Detached native window

The surface becomes an independent operating-system window:

- native minimise;
- native maximise/restore;
- native close;
- movement to any monitor;
- independent task-switching visibility;
- reattachment to the original or another compatible Workbench Host.

### Application surface session

A complete application session may appear as a top-level application tab or in another Workbench Host. The transfer uses stable session identity and a serialisable state checkpoint. Raw widget pointers are never reparented between unrelated processes.

## 6. Edit Layout mode

Normal mode is for product work. Edit Layout mode is for structural changes.

When Edit Layout begins, Framework captures a complete transaction baseline containing:

- host windows and monitor assignment;
- dock and split tree;
- tab groups and active tabs;
- floating rectangles and z-order;
- detached windows;
- surface visibility;
- pin and auto-hide state;
- menu and toolbar placement;
- linked-context membership;
- active layout identity.

Edit Layout exposes:

- alignment grid;
- drag handles;
- resize borders and corners;
- snap guides;
- docking previews;
- split targets;
- tab-group targets;
- New Surface / New Window catalogue;
- clear canvas;
- detach and attach commands;
- Apply;
- Cancel;
- Save;
- Save As;
- Lock.

### Apply

Validates and commits the complete candidate layout.

### Cancel

Restores the complete transaction baseline. No partial geometry, tab, context or detached-window change remains.

### Lock

Ends editing and protects the layout from accidental structural changes.

The edit state must be visually obvious through an original Umicom treatment. Research examples inform the behaviour but are not copied visually.

## 7. Drag, resize, snap and dock rules

While editing, the user can:

- drag a surface anywhere on the canvas;
- resize from any permitted edge or corner;
- snap to a logical grid;
- snap to host edges;
- snap to another surface;
- convert a floating surface into a docked surface;
- create a new horizontal or vertical split;
- merge surfaces into a tab group;
- reorder tabs;
- move a tab out into a floating surface;
- detach a surface into a native window;
- move a surface to another compatible host.

The preview must show the exact result before drop.

Minimum sizes, aspect requirements and product safety constraints are validated by Framework. An invalid drop leaves the original arrangement unchanged and explains why it was rejected.

## 8. Surface catalogue

The Framework-owned searchable catalogue is the single way to discover and add reusable surfaces.

The catalogue groups items by:

- current application;
- shared Framework tools;
- documents;
- development tools;
- financial tools;
- AI and knowledge tools;
- creative tools;
- engineering tools;
- operations and security;
- recent;
- favourites;
- recently closed.

For each item it shows:

- title and description;
- icon;
- owning capability;
- supported placement;
- required permission or connection;
- available, unavailable, busy or setup-required state;
- reason when unavailable.

The user can open an item:

- in the current canvas;
- in a selected dock region;
- as a floating canvas window;
- as a new tab;
- as a detached native window;
- in another Workbench Host;
- on a selected monitor.

## 9. Named layouts and Layout Library

Named layout tabs remain accessible at the bottom of the Workbench Host.

The plus action opens the Layout Library and offers:

- Create Blank Layout;
- Create from Product Default;
- Duplicate Current Layout;
- Browse Layout Library;
- Import Layout;
- Restore Previous Layout;
- Recover Last Known Good Layout.

The user can:

- rename;
- save;
- save as;
- duplicate;
- export;
- import;
- delete;
- reset;
- restore an earlier version.

A layout may be scoped to:

- a user;
- a machine;
- a workspace;
- an account;
- an application session;
- a team-shared template.

## 10. Multiple Workbench Host windows and monitors

One application or one signed-in user may own several Workbench Host windows.

Each host has independent:

- native geometry;
- monitor preference;
- layout identity;
- surface arrangement;
- active application sessions;
- focus;
- restore checkpoint.

A surface can move between hosts and monitors without losing its stable instance or product session state.

When a saved monitor is unavailable, Framework moves the host or detached surface into a visible work area while preserving its preferred monitor assignment for later restoration.

## 11. Application attachment and detachment

All Umicom applications share the same Framework parent architecture.

A Workbench Host may contain multiple application surface sessions, for example:

```text
[Umicom Studio IDE ×] [Umicom Trader ×] [Umicom Bank ×] [+]
```

The plus action opens the canonical application catalogue.

An application session can:

- open in the current host;
- open in a new host;
- be reordered;
- be duplicated where policy permits;
- detach into another host window;
- move to another monitor;
- close through its product-specific safety checks;
- restore from recently closed state.

Cross-host transfer uses an acknowledged token containing stable product and session identity, a state checkpoint, required capabilities and source-host identity. The source releases ownership only after the destination confirms successful rehydration.

## 12. Cross-application interoperability

Sharing one Framework parent means more than similar appearance.

Framework provides a common interoperability layer for:

- Copy;
- Cut;
- Paste;
- drag and drop;
- Open With;
- Send To;
- Share Selection;
- linked contexts;
- application-session hand-off.

### Semantic clipboard

The clipboard supports standard operating-system formats and versioned Umicom payloads.

Examples include:

- text;
- rich text;
- files and URIs;
- images;
- tables;
- source-code selections;
- diagnostics;
- project references;
- documents;
- instruments;
- orders;
- trades;
- accounts;
- payments;
- customers;
- models;
- reports;
- charts and chart configurations.

Each Umicom payload contains:

- stable schema ID and version;
- source application;
- source object identity;
- data classification;
- provenance;
- allowed operations;
- optional expiry;
- serialised value or secure reference;
- audit correlation ID.

The receiving application advertises compatible paste and drop capabilities. Unsupported or prohibited transfers are rejected with a precise reason.

### Shared data does not mean shared mutable pointers

Applications exchange immutable snapshots, stable references, commands and events through Framework services. They do not share raw process memory or GTK pointers.

### Permission and safety boundaries

Security, privacy, financial risk, execution, approval and data-classification policy remain authoritative. A cross-application paste cannot bypass validation or cause a live order, payment or destructive action without the required controller and approval path.

## 13. Linked context groups

Surfaces can join typed context groups as:

- Source;
- Destination;
- Source and Destination.

A context group has:

- stable group ID;
- number;
- name;
- icon;
- accessible label;
- visual token;
- accepted context types.

Context types include:

- project;
- document;
- source location;
- instrument;
- account;
- legal entity;
- customer;
- connection;
- model;
- report;
- business date.

Colour is an aid only and is never the sole identifier.

## 14. Product themes

All applications use the Framework design system.

Framework owns:

- typography;
- spacing;
- focus states;
- control dimensions;
- panel chrome;
- menu and toolbar presentation;
- accessibility;
- high-DPI behaviour;
- light, dark and high-contrast foundations.

Each application selects a product theme profile that may define:

- official product icon;
- display name;
- accent;
- density;
- approved product-specific imagery;
- product status tokens.

A product theme cannot change layout semantics, command behaviour, safety policy or accessibility requirements.

## 15. Framework and thin-client ownership

### Umicom Framework owns

- all canvas and layout models;
- all reusable surface definitions;
- host windows;
- docking, snapping and floating;
- detached windows;
- menu and toolbar surfaces;
- application, document and layout tab frameworks;
- surface catalogue;
- layout library;
- edit transactions;
- persistence and migration;
- semantic clipboard;
- cross-application drag and drop;
- linked contexts;
- multi-monitor restoration;
- frontend adapters;
- architecture and acceptance tests.

### Applications provide

- application identity;
- official icon selection;
- product profile;
- permitted Framework capabilities;
- product-specific surface registrations;
- product commands and view models;
- product-specific workflows;
- permissions and operating mode.

No application may implement a second generic canvas, docking engine, layout store, panel framework, menu framework, toolbar framework, clipboard engine or cross-application transfer system.

## 16. Data Server persistence

The Data Server is the sole authority for durable Umicom-owned layout state.

A layout document records:

- schema version;
- application and session IDs;
- host windows;
- logical monitor topology;
- surface instances;
- dock and split hierarchy;
- tab groups;
- floating and detached geometry;
- visibility, pin and auto-hide state;
- menu and toolbar placement;
- context groups;
- user and workspace scope;
- revision and checkpoint;
- last-known-good version.

Saves are transactional. A crash or failed migration cannot destroy the previous valid layout.

## 17. Application-wide adoption

These rules apply to every existing and future Umicom application.

Every application receives:

- a default product layout;
- blank-layout creation;
- clear-canvas support;
- the common surface catalogue;
- drag, resize, snap, dock, float and detach operations;
- multiple Workbench Host support;
- named layouts;
- layout persistence;
- official identity and product theme;
- semantic clipboard and cross-application exchange;
- typed context linking;
- the same acceptance test suite.

The product-specific surfaces differ, but the lifecycle and layout rules do not.

## 18. Acceptance journeys

The feature is not complete until automated and visible evidence proves all of the following.

1. A new application opens its Framework product default.
2. Create Blank Layout opens an empty canvas while preserving host controls.
3. Clear Current Canvas removes all removable surface instances without deleting product data.
4. New Surface opens the Framework catalogue.
5. A selected surface appears as a floating canvas window.
6. The user can drag and resize it.
7. It snaps to the grid, host edge and another surface.
8. It can dock, split or join a tab group.
9. It can maximise within the canvas and restore.
10. It can detach into a native window.
11. The detached window can move to another monitor.
12. It can attach to the original or another Workbench Host.
13. A second host can maintain an independent layout.
14. Apply commits an edit; Cancel restores the complete baseline.
15. Lock prevents accidental structural changes.
16. A layout saves and restores after restart.
17. Missing-monitor recovery keeps every surface visible.
18. A Studio selection can be copied or dragged to another authorised Umicom application through the semantic clipboard.
19. A cross-application transfer preserves provenance and obeys policy.
20. Every application consumes the same Framework implementation.
21. Architecture tests detect application-local duplicate workbench implementations.
22. The actual Umicom icon is loaded from the shared asset catalogue.
23. No `<>` logo substitute appears.
24. Visible controls are truthful and provide reasons when unavailable.

## 19. Implementation order

The implementation proceeds through complete Framework-owned vertical slices:

1. authoritative canvas and surface state model;
2. blank layout, clear canvas and recovery;
3. floating-in-canvas windows and resize handles;
4. grid, snap and docking previews;
5. dock, split and tab operations;
6. detached native windows and monitor movement;
7. additional Workbench Hosts and surface transfer;
8. named layouts and Data Server persistence;
9. semantic clipboard and cross-application drag/drop;
10. application-session tabs and cross-host transfer;
11. product theme profiles and complete family conformance;
12. complete visible and automated acceptance evidence.

No slice is described as complete until the executable visibly demonstrates the behaviour.

## 20. Locked project rules

- Umicom Framework is the single source of truth.
- Applications are thin clients.
- The default layout is only a starting template.
- The user owns the active arrangement.
- A blank canvas is a supported first-class layout.
- Surfaces can be docked, tabbed, split, floating or detached.
- Multiple host windows and monitors are first-class.
- Application sessions may share or move between Framework hosts.
- Cross-application Copy/Paste and drag/drop use typed Framework contracts.
- Product themes share one Framework design system.
- Existing features, names, comments and public contracts are preserved.
- Canonical documentation uses feature-oriented names.
- The official Umicom asset is used; `<>` is not an approved logo.
- Build configuration output is not proof of completed UX.
- Source, tests, runtime evidence and documentation must agree before delivery.
