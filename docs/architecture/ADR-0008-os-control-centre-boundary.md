# ADR-0008 — Umicom OS Control Centre boundary

**Status:** Accepted
**Date:** 20 August 2026

## Context

Umicom Desk needs system-management panels, but Umicom Framework must remain a
portable user-space platform. Boot and recovery must not depend on a healthy
Framework installation.

## Decision

Create `umicom-os-module` as a thin user-space Control Centre application.

The module may contribute:

- system overview;
- settings;
- package and update views;
- device, network and storage views;
- process and service supervision views;
- security and diagnostics views;
- Umicom OS product identity and default layouts.

The module does not own:

- Linux kernel source;
- kernel drivers;
- UEFI, OpenSBI or U-Boot;
- initramfs and early boot;
- root-filesystem construction;
- minimal recovery;
- firmware;
- OS image generation.

Those remain in `umicom-os` or their upstream projects.

## Consequences

Normal Umicom OS user space can be Framework-powered while boot and recovery
remain independently repairable. Studio and other applications may also render
the same Framework system contracts on ordinary Windows or Linux.
