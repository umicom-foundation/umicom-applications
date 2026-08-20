# Umicom Repository and Runtime Topology

## Runnable Umicom Applications composition

```text
umicom-applications
├── framework
│   └── submodule -> umicom-framework
└── applications
    ├── studio
    │   └── submodule -> umicom-studio-ide-module
    ├── trader
    │   └── submodule -> umicom-trader-module
    ├── tms
    │   └── submodule -> umicom-tms-module
    ├── llm
    │   └── submodule -> umicom-llm-module
    ├── bank
    │   └── submodule -> umicom-bank-module
    ├── exchange
    │   └── submodule -> umicom-exchange-module
    ├── desktop
    │   └── future submodule -> umicom-desktop-module
    └── os
        └── future submodule -> umicom-os-module
```

This superproject builds Framework once and composes selected thin application modules. It is the source checkout for the multi-application Umicom Desk product.

## Full Umicom OS distribution repository

```text
umicom-os
├── framework
│   └── submodule -> umicom-framework
├── applications
│   ├── desktop
│   │   └── submodule -> umicom-desktop-module
│   └── os
│       └── submodule -> umicom-os-module
├── kernel
│   ├── configs
│   ├── patches
│   ├── device-trees
│   └── provenance
├── boot
├── rootfs
├── packages
├── profiles
├── images
├── security
├── recovery
└── tests
```

The OS repository may package Studio, Trader and other application artefacts into particular image profiles. It does not own those products' source code and does not move the Linux kernel into Framework.

## Standalone product superproject pattern

A complete independently runnable product can retain the historic two-folder structure without duplicating source ownership:

```text
umicom-studio-ide
├── framework
│   └── submodule -> umicom-framework
└── applications
    └── studio
        └── submodule -> umicom-studio-ide-module
```

The same pattern applies to a future full Trader, TMS or other standalone product repository. The `*-module` repository is the product-specific source of truth; the full product repository supplies build, integration, packaging and release composition.

## Dependency direction

```text
Application modules
        ↓ consume public contracts
Umicom Framework
        ↓ calls supported adapters
Operating system and external providers
```

```text
umicom-applications
        ↓ pins compatible commits
Framework + application modules
```

```text
umicom-os
        ↓ packages compatible runtime artefacts
Framework runtime + Desk + OS module + selected applications
```

Framework never depends on an application module or the full OS distribution. Application modules never include another module's private headers. The Linux kernel never becomes an application dependency.

## Commit order

For a Framework change:

```text
umicom-framework
    commit -> push
        ↓
umicom-applications
    update Framework pointer -> test -> commit -> push
        ↓
other affected product/OS superprojects
    update pointer -> test -> commit -> push
```

For a module change:

```text
*-module
    commit -> push
        ↓
all consuming superprojects
    update module pointer -> test -> commit -> push
```

A superproject commit represents a reproducible compatibility snapshot. `branch = main` in `.gitmodules` helps explicit update commands, but normal checkout still restores the exact pinned commit.
