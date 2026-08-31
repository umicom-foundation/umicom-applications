<!--
Umicom Applications
File: docs/getting-started/WINDOWS_INSTALLER_AND_APPLICATION_LAUNCHER.md
Author: Sammy Hegab, Umicom Foundation
Licence: MIT
-->

# Windows Installer and Application Launcher

Umicom Applications can be packaged as one Windows installer. The installer
shows a list of applications with checkboxes, so each person can choose the
products they need.

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

When Umicom Applications opens, it displays the installed products as another
simple checkbox list. Choose one or several products and select **Launch
selected**. Each product runs as its own process. For example, Umicom Studio IDE
and Umicom Trader can remain open at the same time.

Choosing an application that is already running brings that application
forward instead of opening a duplicate process. A failure in one product does
not prevent the other selected products from being attempted, and the launcher
reports how many products started, were activated, or failed.

## Why the design is reusable

The application checkbox state, launch results, process supervision and
installer selection rules live in Umicom Framework. Product repositories only
declare their identity, executable and installer component. This keeps every
application thin and prevents each product from inventing its own launcher.

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

## Safety rules

- Required installer components cannot be unticked.
- Unavailable applications cannot be selected.
- Fixed-capacity records prevent unbounded checkbox or launch-result arrays.
- Executable paths are constructed by the governed launcher, not shell text.
- Each child process is tracked by the Framework process supervisor.
- The installer includes an uninstaller for a normal Windows installation.

