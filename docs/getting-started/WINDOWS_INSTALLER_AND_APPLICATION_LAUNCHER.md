<!--
Umicom Applications
File: docs/getting-started/WINDOWS_INSTALLER_AND_APPLICATION_LAUNCHER.md
Author: Sammy Hegab, Umicom Foundation
Licence: MIT
-->

# Windows Installer and Application Launcher

The source includes packaging rules for one Windows installer with selectable
applications. These rules still need clean-machine installation, repair, update
and removal testing before the installer can be called ready for distribution.

The shared Framework and the Umicom Applications launcher are required. They
are installed once and reused by every selected application. Umicom Studio IDE,
Umicom Trader, Umicom Bank, Umicom TMS and other enabled products are optional
installer components.

## What the user sees

During installation:

1. Start the Umicom Applications installer.
2. Read and accept the licence.
3. Choose the installation folder.
4. Tick the applications you want to install.
5. Select **Install**.
6. Start **Umicom Applications** from the Start menu or desktop shortcut.

The current Umicom Desk source opens on **Desktop Home**, a searchable tile view
of registered applications. Use **Launch** for an available product, or select
several products and open **Applications** to review and launch the selection.
Each product runs as its own process; its window is not embedded inside Desk.

Choosing an application that is already running requests activation instead of
starting a duplicate. The current Desk process adapter cannot yet bring another
window forward, so it reports that operation as unsupported. The launcher keeps
the process record and reports failed requests. A failure in one selected product
does not prevent the other selected products from being attempted.

Before **Launch selected** is confirmed, the launcher can show a plain-language
preview. The preview explains:

- which selected applications will start as new processes;
- which running applications will receive an activation request;
- the recommended starting layout for each application;
- whether product acceptance evidence still needs attention;
- why an unavailable application cannot be selected; and
- whether an installed application is missing workspace guidance.

This preview is descriptive. Displaying it never starts an application. The
existing Framework launcher performs execution only after the user confirms.

## Why the design is reusable

The Home layout, application selection, installation monitoring, launch plans
and installer selection rules are supplied by Umicom Framework. The native Desk
entry point supplies its actual executable directory and poll clock, then uses
those public contracts. It does not keep a second installation catalogue.

The generated Windows installer uses these components:

- **Umicom Framework** — required shared runtime and resources.
- **Umicom Applications Launcher** — required product chooser.
- **Umicom Studio IDE** — optional development environment.
- **Umicom Trader** — optional trading workspace.
- **Umicom Bank** — optional banking workspace.
- **Umicom TMS** — optional treasury workspace.
- Other enabled suite modules appear as their own optional components.

## Create the Windows installer

Run these commands in PowerShell after the project has built successfully:

```powershell
Set-Location "C:\umicom\umicom-applications"

& "C:\msys64\ucrt64\bin\cpack.exe" `
    --config ".\build\windows-ucrt64-debug\CPackConfig.cmake" `
    -C Debug `
    -G NSIS
```

The installer is written to the build folder. A portable ZIP package can still
be created by replacing `NSIS` with `ZIP`.

## Add another application later

A new application must provide:

1. A stable application ID, such as `org.umicom.example`.
2. A friendly display name.
3. The executable name produced by CMake.
4. An application manifest in `application.umicom.yaml`.
5. An install component assigned by the suite composition.
6. A runtime registration that points to the real installed executable.

Do not put process-starting code in the new application. Register the product
with Umicom Desk and let Framework create and execute the launch plan.

For already-registered built-in products, the new Desk monitor checks their
canonical graphical executable names in the same directory as Desk. An added or
removed executable updates Home on a later poll. This does not admit an unknown
download, install a package or replace running code. Compatibility admission is
an explicit native composition policy; file presence alone does not prove that
a binary is trusted or healthy. See [Desktop Home validation](../validation/DESKTOP_HOME_VALIDATION.md)
for the current limits and test steps.

## Safety rules

- Required installer components cannot be unticked.
- Unavailable applications cannot be selected.
- A launch preview is rebuilt when selection or runtime state changes.
- Fixed-capacity records prevent unbounded checkbox or launch-result arrays.
- Executable paths are constructed by the governed launcher, not shell text.
- Each child process is tracked by the Framework process supervisor.
- The installer includes an uninstaller for a normal Windows installation.
