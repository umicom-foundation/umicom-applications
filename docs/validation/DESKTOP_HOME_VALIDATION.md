<!--
Umicom Applications
File: docs/validation/DESKTOP_HOME_VALIDATION.md
Author: Sammy Hegab, Umicom Foundation
Licence: MIT
-->

# Desktop Home validation

Status: source implementation and regression tests added; compilation and native
execution have not been performed for this update.

## What this update provides

Framework owns the Home layout, searchable application tiles, selection model,
installation checks and governed launch requests. Desk supplies its identity,
actual executable directory and the clock for its existing poll callback.
The topmost application picker delegates to this same runtime. It cannot bypass
Desk's launch checks through a separate `PATH` search. Its new-window request is
reported as unsupported until independent same-product sessions are implemented.

The monitor checks only already-registered built-in GUI applications. Its default
interval is one second. Hosts can change `interval_ms` in
`UmiApplicationNativeDiscoveryConfig`, or disable monitoring by passing `NULL`
to `umi_desk_runtime_configure_native_discovery`. Root and suffix strings are
copied; an optional injected probe context must remain alive while used.

The directory is obtained from the operating system, not the command line,
current folder or `PATH`. Windows paths are converted from UTF-16 to UTF-8;
truncated paths are rejected. This lookup currently supports Windows and Linux.
Other platforms need an executable-path adapter before using this entry point.

An absent executable is different from a stopped process. If an application is
still running when its file disappears, Desk retains its process identity. A new
start or restart is checked again before the process adapter is called; a restart
must not stop the old process when the replacement is already unavailable.

These checks do not prove package signatures, ABI compatibility or application
health. They do not install unknown applications, hot-swap C code, embed product
windows, or start applications automatically. The current Desk process adapter
reports cross-process activation as unsupported. Use the operating system's
window switcher for an application that is already running.

## Build and run the focused checks

Merge the source changes into your working checkout first. Do not copy another
checkout's build folder. The first command configures the chosen build directory;
subsequent builds reuse it and compile affected dependencies.

Run this block in PowerShell:

```powershell
Set-Location "C:\umicom\umicom-applications"
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"
& "C:\msys64\ucrt64\bin\cmake.exe" --preset windows-ucrt64-all-debug
if ($LASTEXITCODE -ne 0) { throw "Configure failed" }
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --target umicom-desk umicom-platform-executable-path-test umicom-application-native-discovery-test umicom-gtk4-desk-home-test umicom-desktop-window-titlebar-test umicom-desktop-module-test umicom-application-runtime-catalogue-test umicom-application-launcher-test umicom-application-launch-selection-test umicom-desk-runtime-test --parallel 2
if ($LASTEXITCODE -ne 0) { throw "Build failed" }
& "C:\msys64\ucrt64\bin\ctest.exe" --test-dir "C:\umicom\umicom-applications\build\windows-ucrt64-all-debug" -R "^(framework\.platform\.executable_path|framework\.application\.(native_discovery|runtime_catalogue|launcher|launch_selection)|framework\.desktop\.desk_runtime|framework\.ui_workstation\.desk\.home\.gtk4|desktop\.module|desktop\.window\.titlebar\.gtk4)$" --no-tests=error --output-on-failure
if ($LASTEXITCODE -ne 0) { throw "Tests failed" }
```

The core discovery test injects file evidence, time and process adapters. The
path test reads its own process path. The native tests construct GTK widgets
without presenting product windows and return skip code 77 if no display is
available. A skipped test is not a passed native acceptance journey.

## Check the visible application

To build every enabled graphical product, use the same preset without a target
list. This is still an incremental build:

```powershell
Set-Location "C:\umicom\umicom-applications"
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --parallel 2
if ($LASTEXITCODE -ne 0) { throw "Build failed" }
& "C:\umicom\umicom-applications\build\windows-ucrt64-all-debug\bin\umicom-desk.exe"
```

1. Confirm the official SVG identity and application name remain in the topmost
   window titlebar. Home must not add a second brand header inside the canvas.
2. Confirm Home appears first. Resize the window and check that the tile columns
   change without clipping names, buttons or the search entry.
3. Search for Studio, Trader and Bank. Unknown search text should show a useful
   empty state. No search or selection change should start an application.
4. Keep a text selection in the search entry while polling continues. Its text,
   selection and widget should remain intact during unchanged refreshes.
5. Select two available products, open Applications and review the same selection.
   Confirm launches are explicit and each product opens its own window.
6. Request an already-running product. The current activation limitation must be
   reported without starting a duplicate or forgetting the running process.
7. Use the injected discovery tests for missing/reappearing files and failed
   probes. Do not rename, delete or overwrite a running production executable to
   simulate an update. Installed-package tests require a disposable staging copy.
8. Close Desk with a pending request and verify no delayed application opens.
   Check titlebar, search, keyboard navigation and tile readability in each theme.

Record the build preset, test results, screen scale and any visible defects. This
update does not claim completion of the wider desktop canvas, installer, update
service or Umicom OS. Those finish lines remain in the canonical roadmap.
