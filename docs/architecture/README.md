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

The companion `REPOSITORY-TOPOLOGY.md` records the approved superproject,
module and Umicom OS dependency directions.
`APPLICATION-PRODUCTION-GAP-MATRIX.md` records the executable catalogue audit,
Framework production contracts and remaining Studio, Trader and suite product
work.

Accepted ADRs govern implementation until explicitly superseded by a later accepted ADR. Historical documents and exploratory discussions remain useful evidence but do not silently override these decisions.
