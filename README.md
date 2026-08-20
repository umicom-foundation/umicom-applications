# Umicom Applications

Umicom Applications is the master multi-application composition superproject for the Umicom ecosystem.

The repository contains one pinned Umicom Framework checkout and independently versioned thin application modules. A root build system and application launcher will be added so that this repository becomes the runnable integrated Umicom application suite.

## Canonical architecture

Umicom Framework is the reusable source of truth.

Reusable runtime services, libraries, components, widgets, adapters, data contracts, messaging, persistence, security, observability and shared domain functionality belong in Umicom Framework.

Application-module repositories contain only thin product-specific composition, branding, layouts, commands, views, profiles and genuinely product-specific behaviour.

## Repository structure

```text
umicom-applications
├── framework
│   └── submodule: umicom-framework
│
└── applications
    ├── studio
    │   └── submodule: umicom-studio-ide-module
    ├── trader
    │   └── submodule: umicom-trader-module
    ├── tms
    │   └── submodule: umicom-tms-module
    ├── llm
    │   └── submodule: umicom-llm-module
    ├── bank
    │   └── submodule: umicom-bank-module
    └── exchange
        └── submodule: umicom-exchange-module
```

## Repository catalogue

| Local path | Repository | Purpose |
|---|---|---|
| `framework` | `umicom-foundation/umicom-framework` | Shared C23 Framework and reusable source of truth |
| `applications/studio` | `umicom-foundation/umicom-studio-ide-module` | Thin Studio IDE application composition |
| `applications/trader` | `umicom-foundation/umicom-trader-module` | Thin Trader application composition |
| `applications/tms` | `umicom-foundation/umicom-tms-module` | Thin Open TMS application composition |
| `applications/llm` | `umicom-foundation/umicom-llm-module` | Thin LLM and local-AI application composition |
| `applications/bank` | `umicom-foundation/umicom-bank-module` | Thin Bank application composition |
| `applications/exchange` | `umicom-foundation/umicom-exchange-module` | Thin Exchange application composition |

## Clone the complete repository

```powershell
Set-Location "C:\umicom"

git clone `
    --recurse-submodules `
    "https://github.com/umicom-foundation/umicom-applications.git"
```

## Initialise submodules in an existing checkout

```powershell
Set-Location "C:\umicom\umicom-applications"

git submodule sync --recursive

git submodule update `
    --init `
    --recursive
```

## Restore the exact pinned state

```powershell
Set-Location "C:\umicom\umicom-applications"

git pull --ff-only

git submodule sync --recursive

git submodule update `
    --init `
    --recursive
```

## Inspect repository status

```powershell
git status

git submodule status

git submodule foreach --recursive `
    'echo ""; echo "===== $displaypath ====="; git status --short'
```

## Development workflow

Changes must be committed in the repository that owns the source.

For an application-module change:

```text
1. Change the application module.
2. Commit and push the module repository.
3. Return to umicom-applications.
4. Stage the updated submodule pointer.
5. Build and test the integrated repository.
6. Commit and push umicom-applications.
```

For a Framework change:

```text
1. Change Umicom Framework.
2. Commit and push umicom-framework.
3. Return to umicom-applications.
4. Stage the updated framework pointer.
5. Build and test every affected application.
6. Commit and push umicom-applications.
```

## Current status

The repository composition is established with:

- one authoritative Framework submodule;
- six thin application-module submodules;
- exact reproducible commit pins;
- Studio application source migrated into its module repository.

The next milestone is the root application-composition build, beginning with Framework and Studio.

## Project principles

- C23 is the primary implementation language.
- Cross-module public interfaces use a stable C ABI.
- C++ remains behind controlled adapters where justified.
- GTK4 is the first graphical frontend.
- Master Controller and Slave Controllers remain the canonical terminology.
- Application modules consume public Framework contracts only.
- Common functionality must not be duplicated between applications.
- The Data Server remains authoritative for Umicom-owned persistent state.
- Every integrated revision must be reproducible.

## Ownership

Project lead and author: Sammy Hegab  
Organisation: Umicom Foundation
