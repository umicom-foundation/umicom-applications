# Umicom Applications Architecture Decisions

This directory records the high-impact decisions established while converting Umicom Applications into the runnable multi-product composition and Umicom Desk.

| ADR | Decision |
|---|---|
| ADR-0001 | Shared resources and branding belong in Umicom Framework |
| ADR-0002 | The Linux kernel remains outside Umicom Framework |
| ADR-0003 | Umicom Desk and OS user-space composition use thin module repositories |
| ADR-0004 | Layouts use Framework semantics, product defaults, Data Server state and portable files |
| ADR-0005 | Umicom Framework is a modular SDK/runtime rather than one giant DLL |
| ADR-0006 | Umicom Desk discovers validated applications and exposes a bottom taskbar |
| ADR-0007 | Framework owns application runtime state and governed launch planning |
| ADR-0008 | `umicom-os-module` is a user-space Control Centre, not the OS distribution |
| ADR-0009 | Framework owns live application surface state and frontend hosting contracts |
| ADR-0010 | Framework owns reusable panel behavior and workspace runtime policies |
| ADR-0011 | Public SDK headers require unique guards and human-readable contracts |
| ADR-0012 | Framework owns one shared product-surface lifecycle for every application |
| ADR-0013 | Framework-owned SVG is the only native application identity mark |

The companion `REPOSITORY-TOPOLOGY.md` records the approved superproject,
module and Umicom OS dependency directions.
`APPLICATION-PRODUCTION-GAP-MATRIX.md` records the executable catalogue audit,
Framework production contracts and remaining Studio, Trader and suite product
work.
`APPLICATION-PRODUCT-SURFACE-PORTFOLIO.md` explains which shared surface pieces
now apply to every recipe and which thin product work remains.
The [Framework-first application development roadmap](../roadmaps/FRAMEWORK-FIRST-APPLICATION-DEVELOPMENT-ROADMAP.md)
lists the reusable contracts, layouts, panels and thin product updates planned
for every application repository.
The [Workbench and build lifecycle update](../updates/WORKBENCH_BUILD_LIFECYCLE_UPDATE.md)
records the current Canvas host ownership and Studio build-discovery changes.
The [Workbench Canvas implementation note](WORKBENCH_CANVAS_IMPLEMENTATION.md)
describes the portable placement contract and the GTK4 projection boundary.
The [Universal Workbench specification mapping](UNIVERSAL_WORKBENCH_SPECIFICATION_MAPPING.md)
tracks the supplied UX decisions against current Framework contracts and the
remaining product acceptance boundaries.
The [portfolio implementation update](../major-batches/PORTFOLIO_IMPLEMENTATION_UPDATE.md)
records the next cross-portfolio implementation queue and completion contract.
The [Workbench panel batch operation note](../major-batches/WORKBENCH_PANEL_BATCH_OPERATIONS.md)
documents the atomic multi-panel edit contract used by layout editors.
The portfolio implementation update also documents the shared launch-readiness
gate that keeps incomplete Framework experiences out of the launch action.
The [portfolio launch-readiness note](../major-batches/PORTFOLIO_LAUNCH_READINESS.md)
documents the read-only summary used by launchers and product consoles.
The [multi-application session checkpoint note](../major-batches/MULTI_APPLICATION_SESSION_CHECKPOINT.md)
documents safe capture and restore of a selected startup set.
The [command-palette query note](../major-batches/COMMAND_PALETTE_QUERY.md)
documents shared command discovery and capability-aware filtering.
The [command-palette invocation note](../major-batches/COMMAND_PALETTE_INVOCATION.md)
documents the approval and product-executor path after a command is selected.
The [command invocation journal note](../major-batches/COMMAND_INVOCATION_JOURNAL.md)
documents bounded action history and runtime-owned evidence.
The [portfolio surface audit note](../major-batches/PORTFOLIO_SURFACE_AUDIT.md)
documents the one report that checks every application layout, UI surface and
headless start entry point.
The [next major updates roadmap](../roadmaps/NEXT_MAJOR_UPDATES_ROADMAP.md)
lists the remaining Framework and product work in dependency order.

Accepted ADRs govern implementation until explicitly superseded by a later accepted ADR. Historical documents and exploratory discussions remain useful evidence but do not silently override these decisions.
