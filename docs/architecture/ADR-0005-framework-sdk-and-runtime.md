# ADR-0005: Modular Framework SDK and Runtime Packaging

- **Status:** Accepted
- **Date:** 20 August 2026
- **Owner:** Sammy Hegab, Umicom Foundation

## Context

Every future Umicom product depends on Framework, but one giant shared library would increase coupling, startup cost, ABI risk and deployment complexity. Copying Framework source into each application would create drift and duplicated ownership.

## Decision

Umicom Framework is distributed as a modular SDK/runtime catalogue, not one giant DLL.

Supported consumption modes are:

```text
Source superbuild
    one pinned Framework submodule + selected application modules

Installed SDK
    headers + exported CMake targets + libraries + tools + resources

Runtime package
    selected shared/static libraries + resources + adapters + plug-ins
```

Applications link only the bounded Framework targets they require, or `Umicom::Framework` for first-party complete compositions. Stable binary boundaries use the C ABI. Optional providers may be shared libraries or supervised workers.

## Consequences

- Independent products can use `find_package(UmicomFramework CONFIG REQUIRED)`.
- First-party integration builds compile Framework once.
- Applications do not carry private copies of reusable Framework source.
- Shared-library expansion proceeds only with ABI tests, versioning and package compatibility controls.
