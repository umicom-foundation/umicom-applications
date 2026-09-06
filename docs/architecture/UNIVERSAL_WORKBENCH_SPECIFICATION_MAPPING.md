# Universal Workbench specification mapping

This page records the public implementation status for the Universal
Workbench. The governing split is preserved: the Framework owns reusable
shell, panel and layout mechanisms; product controllers own authoritative
business behaviour; layout state belongs to the user.

## Decision register

| Decision | Current Framework position | Evidence or next boundary |
|---|---|---|
| D-001 Framework owns the universal Workbench | Implemented as the ownership direction for UI, application, presentation and session contracts. | Keep product repositories thin; reject parallel docking stores. |
| D-002 Branded splash lifecycle | Contract and product splash surfaces exist; truthful task progress and safe-mode recovery remain incomplete. | Finish startup task reporting and recovery choices in each native launcher. |
| D-003 Product icon and name in the header | Shared branding/resource contracts exist; native header adoption is incomplete. | Resolve the approved vector/icon resources through the Framework broker. |
| D-004 Closeable application tabs | Application/session catalogues exist; cross-host transfer is now represented by an acknowledgement token. | Add visible tab strip operations for open, reorder, duplicate, restore and close. |
| D-005 Umicom Desk owns native host windows | Launcher and host contracts keep product services separate from native windows. | Complete the Desk host controller and never reparent foreign-process widgets. |
| D-006 Complete panel lifecycle | Panel capabilities, workspace customisation and Canvas operations cover the model. | Bind close, hide, dock, split, auto-hide and detach commands in every adapter. |
| D-007 Normal mode versus Edit Layout mode | Begin/commit/cancel and lock operations provide the transactional model. | Expose unmistakable edit chrome, handles and Cancel/Apply controls. |
| D-008 Named layouts and Layout Library | Named layouts, product defaults and persistence contracts are present. | Complete library browse, import/export, delete and previous-version restore. |
| D-009 Searchable New Window catalogue | Shared application/window/panel catalogues provide the source data. | Add one searchable, capability-aware presentation for every product. |
| D-010 Typed colour-linked context groups | Context groups and source/destination roles are Framework-owned. | Add accessible group labels and compatibility errors to native panels. |
| D-011 Broker-connected Trader | Trader and trading workstation contracts expose connection and account state. | Complete broker-session discovery and connection-state UI. |
| D-012 Trader never collects broker passwords | No password field belongs in the Trader contract. | Keep authentication in the broker's secure sign-in flow and redact logs. |
| D-013 Paper/live separation | Trading and risk policies are separate from layout and theme state. | Demonstrate that UI changes cannot bypass Risk or Execution Server gates. |
| D-014 Definition, instance and session identity | Panel definitions, placement records and session state are separate contracts. | Preserve stable IDs during persistence migration and host transfer. |
| D-015 Truthful command availability | Command surfaces expose feature state, but reason/progress/cancellation projection is not complete. | Add a shared command-state projection before enabling placeholder controls. |
| D-016 Transactional layout persistence | Workspace persistence and checkpoint contracts exist. | Add crash-safe journal, migration diagnostics and previous-good restore. |
| D-017 Acknowledged application-tab transfer | Implemented in `UmiApplicationSurfaceTransferToken`: pending → accepted → committed, expiry, cancellation and idempotence. | Connect token acknowledgements to Umicom Desk host rehydration. |
| D-018 Monitor and DPI adaptation | Canvas stores monitor identity and normalised geometry. | Add monitor enumeration, scale-aware projection and absent-monitor recovery. |
| D-019 Coherent visual system and density profiles | Theme, appearance and palette contracts are shared by products. | Complete Comfortable, Balanced and Compact Trading density projections. |
| D-020 Close behaviour while locked | The specification records this as needing a decision. | Decide whether close hides, confirms or is restricted for essential panels. |

## Product vertical slices

The first useful acceptance journeys remain:

1. Studio: open workspace → populate Explorer → edit/save → build → inspect
   Problems → run tests → run/debug → restore session.
2. Trader: connect to an already-authenticated broker session → open
   paper layout → link watchlist/chart/order panels → pass orders through Risk
   and Execution policy.
3. Bank: authenticate → open Overview → prepare and validate a payment → maker
   checker approval → release → acknowledgement and reconciliation.

Each journey should use the same Framework host, panel, context, command and
checkpoint contracts. A passing catalogue or configure step alone is not
evidence that the visible journey works.

## Batch order retained from the specification

The implementation order is splash/recovery, universal host and application
tabs, panel docking and layout lock, persistence/recovery, typed context links,
Studio daily-use workspace, Trader safety shell, Trader tools, Bank operations,
cross-window and multi-monitor hardening, then accessibility and release
acceptance. This batch advances the cross-window handoff boundary and the
Canvas projection without claiming the later graphical work is finished.
