# Umicom Applications

Umicom Applications is the runnable multi-application superproject for the
Umicom ecosystem.

It contains one pinned Umicom Framework checkout and independently versioned
thin application modules. **Umicom Desk** is the outer desktop shell, launcher,
application taskbar and semantic layout host.

## Canonical architecture

Umicom Framework is the reusable source of truth.

Reusable runtime services, libraries, components, widgets, adapters, data
contracts, messaging, persistence, security, observability, application launch
policy, taskbar state and semantic layout behaviour belong in Framework.

Application-module repositories contain thin product composition, identity,
default layouts and genuinely product-specific behaviour.

## Repository structure

```text
umicom-applications
├── framework
│   ├── reusable C23 platform
│   └── resources
│       ├── brand
│       ├── icons
│       ├── themes
│       ├── schemas
│       ├── layouts
│       └── windows
├── applications
│   ├── desktop
│   │   └── submodule: umicom-desktop-module
│   ├── studio
│   │   └── submodule: umicom-studio-ide-module
│   ├── trader
│   │   └── submodule: umicom-trader-module
│   ├── tms
│   │   └── submodule: umicom-tms-module
│   ├── llm
│   │   └── submodule: umicom-llm-module
│   ├── bank
│   │   └── submodule: umicom-bank-module
│   ├── exchange
│   │   └── submodule: umicom-exchange-module
│   └── os
│       └── submodule: umicom-os-module
├── docs
│   └── architecture
├── manifests
├── tests
├── CMakeLists.txt
└── CMakePresets.json
```
## Runtime model

```text
Validated application manifests
              ↓
Framework application runtime catalogue
              ↓
Umicom Desk application taskbar
              ↓
Framework launch plan
              ↓
Framework process supervisor adapter
              ↓
Studio, OS Control Centre and future applications
```

Inside an application, Framework component recipes are projected into portable
presentation plans and live surface sessions. Studio and Trader contribute only
their product-specific controllers while Framework owns common panel state,
focus, checkpoints and frontend-host contracts. See
[`ADR-0009`](docs/architecture/ADR-0009-application-surface-runtime.md).

The application taskbar and layout strip remain separate:

- the taskbar launches, activates, pins, restarts and stops applications;
- the layout strip changes the current semantic arrangement of panels and
  windows;
- a future layout may contain panels from several applications;
- typed context-link groups connect selected panels in the TWS-inspired model.

## Repository catalogue

| Local path | Repository | Purpose |
|---|---|---|
| `framework` | `umicom-foundation/umicom-framework` | Shared C23 application platform |
| `applications/desktop` | `umicom-foundation/umicom-desktop-module` | Thin Umicom Desk composition |
| `applications/studio` | `umicom-foundation/umicom-studio-ide-module` | Thin Studio IDE workbench |
| `applications/trader` | `umicom-foundation/umicom-trader-module` | Thin Trader composition |
| `applications/tms` | `umicom-foundation/umicom-tms-module` | Thin Open TMS composition |
| `applications/llm` | `umicom-foundation/umicom-llm-module` | Thin local-AI application |
| `applications/bank` | `umicom-foundation/umicom-bank-module` | Thin Bank composition |
| `applications/exchange` | `umicom-foundation/umicom-exchange-module` | Thin Exchange composition |
| `applications/os` | `umicom-foundation/umicom-os-module` | Thin user-space OS Control Centre |

## Clone

```powershell
Set-Location "C:\umicom"

git clone `
    --recurse-submodules `
    "https://github.com/umicom-foundation/umicom-applications.git" `
    "C:\umicom\umicom-applications"
```

## Initialise or restore submodules

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

## Windows UCRT64 GTK4 build

After the four common brand files exist under `framework/resources/brand`:

```powershell
Set-Location "C:\umicom\umicom-applications"

$env:Path = "C:/msys64/ucrt64/bin;$env:Path"

cmake --preset windows-ucrt64-debug

cmake --build `
    --preset windows-ucrt64-debug `
    --parallel 2

ctest `
    --preset windows-ucrt64-debug
```

Launch Umicom Desk:

```powershell
& ".\build\windows-ucrt64-debug\bin\umicom-desk.exe"
```
```

Launch Studio:

```powershell
& ".\build\windows-ucrt64-debug\bin\umicom-studio-ide.exe" --console
```

## Install and create a portable package

```powershell
cmake --install ".\build\windows-ucrt64-debug" `
    --prefix "C:\umicom\install\umicom-applications"

cpack --config ".\build\windows-ucrt64-debug\CPackConfig.cmake" `
    -C Debug
```

Framework resources are installed once below:

```text
share/umicom/resources
```

## Application options

```text
UMICOM_APPLICATIONS_BUILD_DESKTOP  ON
UMICOM_APPLICATIONS_BUILD_STUDIO   ON
UMICOM_APPLICATIONS_BUILD_OS       ON
UMICOM_APPLICATIONS_BUILD_TRADER   OFF
UMICOM_APPLICATIONS_BUILD_TMS      OFF
UMICOM_APPLICATIONS_BUILD_LLM      OFF
UMICOM_APPLICATIONS_BUILD_BANK     OFF
UMICOM_APPLICATIONS_BUILD_EXCHANGE OFF
```

An application option must not be enabled until its module contains a valid `CMakeLists.txt`, application manifest and application source.

## Umicom OS boundary

`applications/os` is a user-space Control Centre. It does not contain the Linux
kernel, bootloader, initramfs, drivers, recovery environment or image builder.
Those remain in the full `umicom-os` repository. Normal Umicom OS user space can
use Framework extensively, while recovery remains independent.

## Commit order

```text
1. Commit and push umicom-framework.
2. Commit and push umicom-desktop-module.
3. Commit and push umicom-os-module.
4. Return to umicom-applications.
5. Stage the three updated submodule pointers and parent composition files.
6. Build and test the pinned integrated state.
7. Commit and push umicom-applications.
Changes must be committed in the repository that owns the source.

For a Framework change:

```text
1. Change framework.
2. Build and test the integrated checkout.
3. Commit and push umicom-framework.
4. Return to umicom-applications.
5. Stage the updated framework submodule pointer and root composition files.
6. Build and test the pinned integrated revision.
7. Commit and push umicom-applications.
```

For a Desktop or OS application-module change:

```text
1. Change the owning application module.
2. Commit and push umicom-desktop-module or umicom-os-module.
3. Return to umicom-applications.
4. Stage the updated submodule pointer.
5. Build and test the integrated repository.
6. Commit and push umicom-applications.
```
For a Studio application-module change:

```text
1. Change applications/studio.
2. Commit and push umicom-studio-ide-module.
3. Return to umicom-applications.
4. Stage the updated applications/studio submodule pointer.
5. Build and test the integrated repository.
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
- Master Controller and Slave Controllers remain canonical terminology.
- Application modules consume public Framework contracts only.
- Common functionality is not duplicated between applications.
- Data Server remains authoritative for Umicom-owned persistent state.
- Layouts are semantic models, not serialised GTK widget trees.
- Linux kernel, boot and recovery remain outside Framework.
- Every integrated revision is reproducible through pinned submodule commits.
- User workbenches, panels and layouts are rendered from Framework-owned semantic models rather than saved GTK widget trees.
- Linux kernel, boot and recovery ownership remain outside Framework.

## Ownership

Project lead and author: Sammy Hegab
Organisation: Umicom Foundation
Licence: MIT
