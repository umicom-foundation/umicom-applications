# ADR-0002: Linux Kernel Boundary

- **Status:** Accepted
- **Date:** 20 August 2026
- **Owner:** Sammy Hegab, Umicom Foundation

## Context

Umicom Framework will power the normal Umicom OS user-space experience, but it is also required on Windows and ordinary Linux distributions. Kernel, boot, firmware and recovery systems have different lifecycles, failure boundaries, licences and build requirements.

## Decision

The Linux kernel is not part of Umicom Framework.

```text
Umicom Desk and applications
            ↓
Umicom Framework user space
            ↓
Linux user-space services
            ↓
Linux kernel
            ↓
firmware and boot
```

The full `umicom-os` repository owns kernel configuration and patch series, boot, root filesystem construction, packages, images, security profiles, recovery and firmware boundaries. Framework may provide user-space contracts and Linux adapters for process, service, device, network, session, package and power operations.

## Consequences

- Framework remains cross-platform.
- Umicom OS can boot and recover when Framework is unavailable.
- Kernel provenance and security updates remain independently governed.
- Application modules never include kernel source or private kernel headers.
- A pinned upstream kernel checkout may later exist only within the full OS engineering repository when patch development requires it.
