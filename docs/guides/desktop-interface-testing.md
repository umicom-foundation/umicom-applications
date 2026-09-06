# Desktop interface testing

Umicom applications share their layout, appearance and panel contracts through
Framework. A desktop window is not evidence that every product feature is
finished. Test the interface and its domain services separately.

## What is available

Studio, Trader, Bank, TMS, Music Studio and Desk retain their dedicated desktop
frontends. The other eighteen application modules now have native layout-preview
entry points in a suite GUI build. These use the product's existing Framework
experience and component recipe instead of a copied window design.

The preview host supplies application identity, startup feedback, layout
selection, shared panel controls, appearance settings and normal window resizing.
It uses the same Framework layout host as other product workstations. A panel
without an attached service displays an offline explanation. Its product commands
do not execute. This is intentional: layout testing must not imply that a banking,
editing, rendering, device or network operation has been implemented.

## Build a complete desktop suite

Run these commands from the repository root in a configured Windows UCRT64
development environment. They use a separate build directory and do not delete
any existing source or build files. The configure step must finish successfully
before building. Do not copy a CMake cache from another checkout.

```powershell
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"
cmake --preset windows-ucrt64-all-debug -B build/windows-ucrt64-layout-debug
if ($LASTEXITCODE -ne 0) { throw 'Configuration failed.' }
cmake --build build/windows-ucrt64-layout-debug --target umicom-desktop-products --parallel 2
if ($LASTEXITCODE -ne 0) { throw 'Desktop build failed.' }
```

The aggregate builds the configured main GUI programs. It does not build every
test or auxiliary program required by a full installation. The normal preset
without `all` enables only selected modules. Headless presets intentionally do
not create desktop frontends.

## Choose an application

Executables are in `build/windows-ucrt64-layout-debug/bin`. Open one at a time
for focused testing, or open different applications together. Close any old
instance first, and use the full path to the newly built executable rather than
an existing desktop shortcut.

| Application | Executable | Interface |
| --- | --- | --- |
| Studio IDE | `umicom-studio-ide.exe` | Dedicated |
| Trader | `umicom-trader.exe` | Dedicated |
| Bank | `umicom-bank.exe` | Dedicated |
| TMS | `umicom-tms.exe` | Dedicated |
| Music Studio | `umicom-music-studio.exe` | Dedicated |
| Desk | `umicom-desk.exe` | Dedicated |
| Accountant | `umicom-accountant.exe` | Layout preview |
| CAD | `umicom-cad.exe` | Layout preview |
| AI Creator | `umicom-ai-creator.exe` | Layout preview |
| Database Studio | `umicom-database-studio.exe` | Layout preview |
| Education Studio | `umicom-education.exe` | Layout preview |
| Commodity Exchange | `umicom-exchange.exe` | Layout preview |
| Games | `umicom-games.exe` | Layout preview |
| Integration Studio | `umicom-integration-studio.exe` | Layout preview |
| Kitchen Designer | `umicom-kitchen-designer.exe` | Layout preview |
| LLM | `umicom-llm.exe` | Layout preview |
| Marketplace | `umicom-marketplace.exe` | Layout preview |
| Media Studio | `umicom-media-studio.exe` | Layout preview |
| Mobile Studio | `umicom-mobile-studio.exe` | Layout preview |
| Operations | `umicom-operations.exe` | Layout preview |
| OS Control Centre | `umicom-os-control-centre-gtk.exe` | Layout preview |
| RAG | `umicom-rag.exe` | Layout preview |
| Security Centre | `umicom-security-centre.exe` | Layout preview |
| Web Studio | `umicom-web-studio.exe` | Layout preview |

The OS Control Centre is a user-space application, not an operating-system
kernel. Its existing console executable keeps its original name. Other console
programs remain available for non-GUI verification.

## Check the header and native window icon

Use the executable produced by the build you just completed. An older executable
in another build directory will still show its older interface even when source
files have changed.

- The operating-system title bar should show the application name and, where
  supported, the approved Umicom icon.
- The compact application header should have one text line, the small SVG mark
  and an inline mode label. It must not display a textual angle-bracket logo.
- The layout name remains in its selector. Hover over the product identity to
  read its subtitle without adding a second line to the compact header.
- Move between displays and change the font size. The icon should stay small
  and sharp; text must remain readable at the selected size.
- Missing branding is a packaging defect, not permission to draw another logo.
  Check the executable's adjacent `branding` folder and the build result.

## Check each interface

Record the executable path, application, chosen layout, display scale and result.
Do not remove saved preferences to make a test pass.

The shared application header's plus button opens the application catalogue.
Select two applications with their checkboxes, then choose Open selected. Read
each row's result: an accepted request is not a guarantee that the new window is
ready. Successful requests leave the selection; failed requests stay selected
for retry. Refresh checks availability again after another interface is built.
The picker does not open a console program in place of a missing GUI.

1. Confirm the application name and Umicom icon are visible and the startup
   surface changes to the product workspace. Record any visible startup error.
2. Resize the window, maximise it, and move it between available monitors. Check
   that menus and panel tabs remain reachable and the central area is usable.
3. Select another layout. Add and close panels through the window catalogue.
   Unlock the layout and try resizing, moving, detaching and reattaching a panel.
4. Cancel an edit and confirm the starting arrangement returns. Make another edit,
   save it, close the application, then reopen it and test restoration.
5. Change the appearance profile, colours and font size. Check labels, controls,
   selected tabs and icon contrast. Restore the preferred appearance afterwards.
6. Navigate by keyboard and inspect tooltips. Check each product action against
   its stated operating mode. Unconnected services must not report success.

These steps are acceptance checks, not a claim that every interaction has already
passed. Source-level tests cannot verify monitor scaling, drawing, native window
behaviour or all domain actions. Missing panel providers and remaining canvas
features should be recorded separately from layout regressions.

The generic suite's current Save operation keeps an in-session checkpoint.
Restoring that checkpoint during the same run is not restart persistence. The
close-and-reopen check above remains an outstanding acceptance requirement until
the shared GUI is connected to Framework Data Server layout storage. Likewise,
free-placement coordinates in the model do not yet produce draggable internal
canvas windows in the GTK adapter.

## Native C verification

New product behaviour and verification are implemented in C through Framework
contracts. Application clients select those capabilities and provide graphical
interfaces. Existing scripts remain compatibility tools; they are not the place
to add a second implementation of product or developer operations.

The launch-dispatch core tests use injected callbacks. The catalogue GTK test
creates widgets without presenting a window and uses a fake host instead of
starting sibling applications. On a machine without a GTK display it reports a
skipped test, not a pass. Neither test establishes that all product windows and
services work on the target machine.

After configuring the desktop build, build and run the focused native checks:

```powershell
cmake --build build/windows-ucrt64-layout-debug --target umicom-application-launch-dispatch-test umicom-application-portfolio-gui-executables-test umicom-gtk4-application-catalogue-test umicom-gtk4-window-identity-test --parallel 2
if ($LASTEXITCODE -ne 0) { throw 'Native test build failed.' }
ctest --test-dir build/windows-ucrt64-layout-debug -R '^framework\.(application\.(launch_dispatch|portfolio\.gui_executables)|ui_workstation\.(application\.catalogue|window\.identity)\.gtk4)$' --output-on-failure
if ($LASTEXITCODE -ne 0) { throw 'Native catalogue tests failed.' }
```

The test code is C. These shell commands only invoke the existing native build
and test tools; they do not implement the application workflow.

## Complete tests and a local installation

```powershell
cmake --build build/windows-ucrt64-layout-debug --parallel 2
if ($LASTEXITCODE -ne 0) { throw 'Build failed.' }
ctest --test-dir build/windows-ucrt64-layout-debug --output-on-failure
if ($LASTEXITCODE -ne 0) { throw 'Tests failed; review the report before installing.' }
cmake --install build/windows-ucrt64-layout-debug --prefix "$PWD/install/desktop"
if ($LASTEXITCODE -ne 0) { throw 'Installation failed.' }
```

Installation copies built files into the selected prefix; it may replace older
files there. A ZIP can be created with `cpack --config
build/windows-ucrt64-layout-debug/CPackConfig.cmake -G ZIP`. An NSIS installer is
also configured when its packaging tool is installed. Runtime dependency bundling
has not been verified for a clean machine; development-machine PATH dependencies
must not be mistaken for a self-contained distributable installer.

## Developer integration

`umi_application_product_gtk4_run` owns the shared GTK startup and shutdown path.
Pass a `UmiApplicationProductGtk4WorkstationConfig` containing the canonical
application identifier, title and an optional controller registrar. Configuration
strings and controller context must remain alive until the function returns.
When no registrar is supplied, the host explicitly selects layout-preview mode.
Attach product controllers through the presentation runtime before its start
operation when implementing real services.

The suite helper discovers enabled module targets and their checked-in manifests.
It does not replace dedicated frontends. Keep application identity and reusable
layout definitions in Framework, and keep product-specific service bindings in
the application module.

## Publish reviewed changes

Each submodule has its own repository. Commit and push children first, then commit
and push the parent pointers. The optional `scripts/publish-repositories.ps1`
defaults to a read-only preview; `-Execute` enables its `git add -A`, conditional
commit and push sequence. It stops on conflicts, missing upstreams and protected
tracked paths. It excludes known private paths independently in each repository.
Filename rules cannot detect secrets embedded in ordinary source files, so review
the diff and local ignore rules before publishing.

A successful parent push does not publish uncommitted submodule files. Git's
`diff --cached --quiet` exit code 1 means staged differences exist; it is not a
commit error. The Umicom repository workflow handles this result separately from
failed Git commands, timeouts and cancelled processes.
