# Umicom Native Workbench Qualification

Windows-first build, test, development installation and publication; Linux update, headless and graphical qualification.

**Source update prepared: 11 September 2026. Status: development candidate, not a fully qualified product release.**

## What this update delivers

Framework now owns a C23 source-contract library, the `umicom-source-contracts` command and seven native regression groups. The two existing metadata audits use one native parser. Attribution can be a nonempty Author OR Organisation, in separate or combined multiline fields, without hard-coded personal names. The native workbench checker replaces the registered Python path, handles nested GTK casts, and retains a mapping for all 21 prior source-check groups. The seven preset-inheritance regression methods are covered by the native preset tests.

A new `linux-all-gtk4-debug` preset enables the whole graphical application portfolio in its own build directory. The existing headless presets stay headless. All reusable validation code is in Framework; the parent only wires tests and selects build profiles. No application module needs an artificial source edit.

**This is an implementation slice of the Working workbench baseline, not completion of that major milestone.** It addresses validation and Linux GUI build selection. It does not redraw the applications, implement live financial services, deliver cross-process tab transfer or create a bootable UmicomOS image.

## Evidence and baseline

| Item | Recorded source or result |
|---|---|
| Applications baseline | `7def604ef471befed07e75d0680197931309e593` |
| Recorded Framework baseline | `a278f963f8d956f230f84ddc2f1ef6bbb9bdff8c` |
| Changed repositories | Framework and Applications parent only |
| Latest supplied Windows focused run | Resource broker, command inventory and designer model passed; two metadata audits and the source matcher failed |
| Preparation: GCC | Seven native CTests passed with strict warnings and `-Werror` |
| Preparation: Clang | Seven native CTests passed with strict warnings and `-Werror` |
| Preparation: sanitizers | Seven native CTests passed under AddressSanitizer and UndefinedBehaviorSanitizer |
| CMake integration fixture | Ten tests passed: seven native groups and three real registration/dispatch cases |
| Installed native command | Installed, displayed help and audited mixed-style source comments successfully |
| Complete product builds, graphical starts and product installation | Not executed here; required on the Windows and Linux machines below |

The preparation tree contains the actual hash-verified Framework JSON reader and required public headers, not substitute implementations. Only three workbench groups were executed against a complete retrieved production startup file; the remaining groups have native unit/fixture coverage and still require the full source-tree run. Four deliberately broken startup variants were rejected. These distinctions matter: source checks cannot prove rendered geometry or usable product workflows.

## Directory map and executable selection

```text
Windows development source
C:\umicom\umicom-applications\
  framework\
  applications\studio\, trader\, bank\, desktop\, ...
  build\windows-ucrt64-all-debug\bin\

Windows development installation (separate from source)
C:\umicom\installed\workbench-validation\bin\

Linux existing source
/home/umicom/umicom/Umicom-Applications/
  build/headless-debug/bin/               headless tools and tests
  build/linux-all-gtk4-debug/bin/          native graphical products

Linux development installation
/home/umicom/umicom/installed/workbench-validation/bin/
```

The installation paths are deliberately disposable development prefixes. If a prefix already exists, choose a new empty location and use that value consistently; do not delete the previous installation or its user data.

The standalone `umicomOS` project is separate and unchanged. The OS Control Centre inside `applications/os` is a user-space application; it is not the operating-system distribution.

## Windows — check branches and local work

Use Windows PowerShell, not the Ubuntu terminal. Start with the existing checkout. Do not pull or update submodules over uncommitted or unpublished work.

```powershell
Set-Location "C:\umicom\umicom-applications"

git status --short
git branch --show-current
git -C framework status --short
git -C framework branch --show-current
git submodule foreach --recursive 'echo ===== $displaypath =====; git status --short'
```

The parent and Framework must be on their existing `main` branches before creating new commits. If either is detached with unpublished commits, preserve that history and attach it to main before continuing; do not switch away and assume it was saved. If they are simply clean build checkouts with no unpublished commits, switch without recursive checkout:

```powershell
git -c submodule.recurse=false switch main
if ($LASTEXITCODE -ne 0) { throw "Could not switch Applications to main." }

git -C framework switch main
if ($LASTEXITCODE -ne 0) { throw "Could not switch Framework to main." }

git rev-parse HEAD
git -C framework rev-parse HEAD
```

Compare against the baseline in the delivery manifest. A newer checkout needs a merge review, not blind replacement with older whole files. Do not run a submodule update after applying changes and before committing/locking them.

## Windows — merge the complete changed files

Extract the ZIP to a comparison directory. Align its `umicom-applications` folder with `C:\umicom\umicom-applications`; do not create a nested copy. The archive contains only new or modified files. Use your comparison tool to preserve newer unrelated changes. No Python file, PowerShell repair script, patch, compiled binary or replacement logo is included.

The old Python regression file remains unchanged as historical reference. Its normal CTest registration is replaced by the native C command. This does not remove every Python use elsewhere in the repository.

## Windows — configure and build

Keep the compiler tools and GTK runtime on this PowerShell session's PATH. These commands do not permanently alter the machine environment.

```powershell
Set-Location "C:\umicom\umicom-applications"

$env:Path = "C:\msys64\ucrt64\bin;$env:Path"

& "C:\msys64\ucrt64\bin\cmake.exe" `
    --preset windows-ucrt64-all-debug `
    -DUMICOM_BUILD_NATIVE_TOOL=ON

if ($LASTEXITCODE -ne 0) {
    throw "Configuration failed. Stop before building."
}

& "C:\msys64\ucrt64\bin\cmake.exe" `
    --build `
    --preset windows-ucrt64-all-debug `
    --parallel 2 `
    -- `
    -k 0

if ($LASTEXITCODE -ne 0) {
    throw "Windows build failed. Do not install or publish."
}
```

`-k 0` lets Ninja continue independent work after errors; it does not turn a failing build into success. Preserve the final exit code and diagnostic output. No clean rebuild is required merely to introduce these sources.

## Windows — focused tests and complete suite

The focused selection runs the three existing passed executable tests, the three repaired validation entries and the seven new native groups. Test numbers can move; names are authoritative.

```powershell
& "C:\msys64\ucrt64\bin\ctest.exe" `
    --preset windows-ucrt64-all-debug `
    --parallel 1 `
    --no-tests=error `
    --output-on-failure `
    -R '^(applications\.(sdk\.public_headers|source\.comments|native_window_responsiveness\.source)|framework\.(application_resource_broker|source_contracts\..*)|studio\.(command_inventory_partition|designer_workspace_model))$'

if ($LASTEXITCODE -ne 0) {
    throw "Focused tests failed. Stop before installing or publishing."
}

& "C:\msys64\ucrt64\bin\ctest.exe" `
    --preset windows-ucrt64-all-debug `
    --parallel 2 `
    --no-tests=error `
    --output-on-failure

if ($LASTEXITCODE -ne 0) {
    throw "Windows suite failed. Do not install or publish."
}
```

Record skipped tests separately. A headless skip or a test that only reads source is not a successful native interaction test. The normal suite will not silently skip the source guard because an interpreter is missing.

## Windows — start applications from the build

Close old copies before testing the new executable. Open **one application at a time**, inspect it, then close its window before moving to the next command. Do not run every command as one pasted multi-application launch.

```powershell
Set-Location "C:\umicom\umicom-applications"
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"

& ".\build\windows-ucrt64-all-debug\bin\umicom-desk.exe"
```

```powershell
& ".\build\windows-ucrt64-all-debug\bin\umicom-studio-ide.exe"
```

```powershell
& ".\build\windows-ucrt64-all-debug\bin\umicom-trader.exe"
```

```powershell
& ".\build\windows-ucrt64-all-debug\bin\umicom-bank.exe"
```

Other dedicated products have `umicom-tms.exe` and `umicom-music-studio.exe`. Use the Desk catalogue for other enabled products, or inspect their explicit manifest declarations. Do not infer a native executable from a console executable's name.

```powershell
Select-String `
    -Path ".\applications\*\application.umicom.yaml" `
    -Pattern 'native_executable:'
```

A returned PowerShell prompt does not prove that a GUI started correctly. Verify the actual visible window, correct executable path, usable controls and orderly close. Financial tests must use simulation, paper or explicitly isolated test data; do not send real payments or orders as a smoke test.

## Windows — install into a fresh development prefix

Proceed after automated tests pass and the intended build-tree windows have been checked. Close the applications. CMake installation applies the repository's install rules; it does not itself prove that all dependencies are bundled.

```powershell
Set-Location "C:\umicom\umicom-applications"

$Stage = "C:\umicom\installed\workbench-validation"
if (Test-Path -LiteralPath $Stage) {
    throw "This installation directory exists. Choose a new empty prefix; keep the old installation."
}

& "C:\msys64\ucrt64\bin\cmake.exe" `
    --install ".\build\windows-ucrt64-all-debug" `
    --config Debug `
    --prefix $Stage

if ($LASTEXITCODE -ne 0) { throw "Development installation failed." }

Get-ChildItem -LiteralPath "$Stage\bin" -Filter "umicom*.exe"

& "$Stage\bin\umicom-source-contracts.exe" --help
if ($LASTEXITCODE -ne 0) { throw "Installed native command failed." }
```

Start the installed application using its installed path, from a working directory outside the source tree. The development runtime PATH deliberately still uses your existing MSYS2 dependencies:

```powershell
$env:Path = "$Stage\bin;C:\msys64\ucrt64\bin;$env:Path"
Set-Location $env:TEMP

& "$Stage\bin\umicom-desk.exe"
```

Close it, then check the installed Studio and other representative products:

```powershell
& "$Stage\bin\umicom-studio-ide.exe"
```

```powershell
& "$Stage\bin\umicom-bank.exe"
```

Missing DLLs, icons, templates or other resources are installation failures to investigate. Do not copy random DLLs from another build. A pass on this development machine is not evidence of a self-contained package: it may still use the installed toolchain, or fall back to a compiled source-resource path. A clean test machine without the source checkout is a separate release gate.

## Windows — optional deployment archive

The existing parent uses CPack and declares a ZIP generator. This command packages the configured install rules into a development archive, without requiring a graphical installer generator. It does not publish a GitHub release or provide signing.

```powershell
Set-Location "C:\umicom\umicom-applications"

if (-not (Test-Path ".\build\windows-ucrt64-all-debug\CPackConfig.cmake")) {
    throw "CPack configuration is missing. Check the completed configuration."
}

& "C:\msys64\ucrt64\bin\cpack.exe" `
    --config ".\build\windows-ucrt64-all-debug\CPackConfig.cmake" `
    -G ZIP `
    -C Debug `
    -B "C:\umicom\packages\workbench-validation"

if ($LASTEXITCODE -ne 0) { throw "Windows archive packaging failed." }
```

Use a new output location for each qualification attempt rather than overwriting an earlier accepted archive. Deploy by extracting into a new test location with the required matching runtimes, then repeat the installed-application checks. Do not describe this archive as a signed standalone installer or deploy it over production.

## Windows — commit and push Framework

Only Framework and the parent have changes from this delivery. Do not manufacture Studio, Desktop or OS commits. `git add -A` stages all local changes, so review for unrelated files, secrets and build products before committing.

```powershell
Set-Location "C:\umicom\umicom-applications\framework"

$Branch = git branch --show-current
if ($LASTEXITCODE -ne 0 -or $Branch -ne "main") {
    throw "Framework must be on main, not a detached HEAD."
}

git add -A
if ($LASTEXITCODE -ne 0) { throw "Framework staging failed." }
git status
git diff --cached --check
if ($LASTEXITCODE -ne 0) { throw "Review staged Framework whitespace diagnostics." }
```

Review the staged changes, then publish:

```powershell
git commit -m "feat(framework): add native source and workbench qualification contracts"
if ($LASTEXITCODE -ne 0) { throw "Framework commit did not complete." }

git push origin main
if ($LASTEXITCODE -ne 0) { throw "Framework push failed. Do not publish the parent." }

$FrameworkCommit = (git rev-parse HEAD).Trim()
$RemoteMain = git ls-remote --exit-code origin refs/heads/main
if ($LASTEXITCODE -ne 0) { throw "Could not verify Framework remote main." }
$RemoteFrameworkCommit = ($RemoteMain -split '\s+')[0]
if ($FrameworkCommit -ne $RemoteFrameworkCommit) {
    throw "Framework remote main is not the commit just built and pushed."
}
```

If a push is rejected, stop. Do not force it. Do not repeat a successful commit simply because a later push failed.

## Windows — parent lock, commit and push

Use the native repository command from the **same all-debug build**, after publishing Framework. The lock stages the current child commits; it does not create or push child commits itself.

```powershell
Set-Location "C:\umicom\umicom-applications"

$Branch = git branch --show-current
if ($LASTEXITCODE -ne 0 -or $Branch -ne "main") {
    throw "Applications must be on main."
}

& ".\build\windows-ucrt64-all-debug\bin\umicom.exe" `
    repo `
    lock `
    .

if ($LASTEXITCODE -ne 0) { throw "Repository lock failed." }

git status
git add -A
if ($LASTEXITCODE -ne 0) { throw "Parent staging failed." }
git diff --cached --submodule=log

$StagedFrameworkCommit = (git rev-parse ":framework").Trim()
$CheckedFrameworkCommit = (git -C framework rev-parse HEAD).Trim()
if ($StagedFrameworkCommit -ne $CheckedFrameworkCommit) {
    throw "The parent is not staging the Framework revision just qualified."
}
```

Review every staged gitlink; unrelated application revisions should not be included accidentally. Then:

```powershell
git commit -m "feat(applications): integrate native qualification and Linux GTK builds"
if ($LASTEXITCODE -ne 0) { throw "Parent commit did not complete." }

git push --recurse-submodules=check origin main
if ($LASTEXITCODE -ne 0) { throw "Parent push failed." }

git submodule foreach --recursive 'echo ===== $displaypath =====; git status --short'
git status
```

A clean source status is not a test result; retain the separate test logs. The submodule push check establishes remote availability, not compatibility or a correct Framework version by itself.

## Linux — update the existing checkout

Run inside Ubuntu. Windows changes are already committed and pushed. Inspect this Linux checkout before pulling:

```bash
cd "$HOME/umicom/Umicom-Applications"

git status --short
git branch --show-current
git submodule foreach --recursive \
    'echo "===== $displaypath ====="; git status --short'
```

Stop if there are local modifications or unpublished commits. A clean working tree alone does not prove that a detached commit is published. Do not discard an earlier Linux repair just to make these commands succeed.

For the clean, non-authoring Linux checkout:

```bash
cd "$HOME/umicom/Umicom-Applications" &&

git -c submodule.recurse=false switch main &&
git -c submodule.recurse=false pull --ff-only origin main &&
git submodule sync --recursive &&
git submodule update --init --recursive --checkout
```

Verify the exact dependency revision:

```bash
git rev-parse HEAD:framework
git -C framework rev-parse HEAD
git submodule status --recursive
```

The first two hashes must match. No leading `+`, `-` or `U` should remain on a normal fully initialised submodule status line. A detached Framework HEAD is normal for a build checkout at the parent's recorded revision. **Do not use `--remote` and do not pull every child branch independently.** No duplicate Linux commit or parent-lock operation is needed.

## Linux — keep the existing headless build

This verifies services and contracts, without a graphical application build. It reuses your existing Clang build directory and explicitly retains all modules:

```bash
cd "$HOME/umicom/Umicom-Applications" &&

cmake --preset headless-debug \
    -DCMAKE_C_COMPILER=/usr/bin/clang \
    -DUMICOM_APPLICATIONS_BUILD_ALL_MODULES=ON \
    -DUMICOM_BUILD_NATIVE_TOOL=ON &&

cmake --build \
    --preset headless-debug \
    --parallel 2 \
    -- \
    -k 0 &&

ctest --preset headless-debug \
    --parallel 2 \
    --no-tests=error \
    --output-on-failure
```

The `&&` chain stops at a failure. Do not install or package after a failed build or suite. This headless pass does not qualify the desktop layout or produce the GTK workstations used in the next section.

## Linux — check graphical dependencies and display

Ubuntu development dependencies are supplied by its package manager. Inspect available versions on the actual machine, then install the development packages needed for this GTK build. Framework requires GTK 4.10 or later; do not lower the API floor to use an older library.

```bash
sudo apt update &&
sudo apt install libgtk-4-dev libgtksourceview-5-dev libsqlite3-dev pkg-config
```

Verify rather than assuming the package installation succeeded:

```bash
pkg-config --atleast-version=4.10 gtk4 &&
pkg-config --modversion gtk4 &&
pkg-config --modversion gtksourceview-5

printf 'DISPLAY=%s\nWAYLAND_DISPLAY=%s\n' "$DISPLAY" "$WAYLAND_DISPLAY"
```

Use an actual Linux desktop session or WSLg-enabled WSL 2. If there is no usable display, do not overwrite `DISPLAY` with a guessed address. Check WSLg/driver support from Windows or open a graphical Linux session. A compiled GUI can exist without being able to display in a headless shell. Do not treat GTK tests returning a skip code as rendered-UI acceptance.

## Linux — build all graphical applications

This preset is introduced by this update, so it appears only after the repaired parent and Framework have been pulled. It uses a separate build tree and cannot reuse the Windows binaries.

```bash
cd "$HOME/umicom/Umicom-Applications" &&

cmake --preset linux-all-gtk4-debug \
    -DCMAKE_C_COMPILER=/usr/bin/clang &&

cmake --build \
    --preset linux-all-gtk4-debug \
    --parallel 2 \
    -- \
    -k 0 &&

ctest --preset linux-all-gtk4-debug \
    --parallel 2 \
    --no-tests=error \
    --output-on-failure
```

Do not switch compilers inside a populated build tree. A separate GCC comparison build should use its own preset/directory. Existing Linux headless Clang and GCC presets remain available and unchanged.

## Linux — start the graphical build for testing

Run one command in a terminal, inspect the window, then close it before testing another product:

```bash
cd "$HOME/umicom/Umicom-Applications"
./build/linux-all-gtk4-debug/bin/umicom-desk
```

```bash
./build/linux-all-gtk4-debug/bin/umicom-studio-ide
```

```bash
./build/linux-all-gtk4-debug/bin/umicom-trader
```

```bash
./build/linux-all-gtk4-debug/bin/umicom-bank
```

Additional dedicated names are `umicom-tms` and `umicom-music-studio`. Other product executable basenames come from their manifests:

```bash
grep -H 'native_executable:' applications/*/application.umicom.yaml
```

Check missing shared libraries with `ldd` on the specific trusted executable when needed. A launch that closes immediately or shows an offline placeholder is not proof of working domain functionality.

## Linux — development install and installed starts

After the GUI build, tests and representative interactive checks succeed, close the windows and use a new user-owned prefix. `sudo` is not needed for this installation.

```bash
cd "$HOME/umicom/Umicom-Applications"
Stage="$HOME/umicom/installed/workbench-validation"

if [ -e "$Stage" ]; then
    printf '%s\n' 'Choose a new empty installation prefix; preserve the previous one.' >&2
else
    cmake --install build/linux-all-gtk4-debug \
        --config Debug \
        --prefix "$Stage" &&
    "$Stage/bin/umicom-source-contracts" --help
fi
```

Do not continue if installation failed or the directory-exists warning was printed. Start the installed paths rather than falling back to the build tree:

```bash
cd /tmp
"$Stage/bin/umicom-desk"
```

```bash
"$Stage/bin/umicom-studio-ide"
```

```bash
"$Stage/bin/umicom-bank"
```

The package still depends on the matching Linux runtime libraries. Test on a separate clean runtime environment before declaring distribution readiness. Keep settings and application data separate from installation files; do not reuse real banking or trading credentials for smoke tests.

## Linux — optional deployment archive

The existing parent declares the TGZ CPack generator. Package the GUI installation rules, not the headless tree:

```bash
cd "$HOME/umicom/Umicom-Applications" &&

test -f build/linux-all-gtk4-debug/CPackConfig.cmake &&
cpack \
    --config build/linux-all-gtk4-debug/CPackConfig.cmake \
    -G TGZ \
    -C Debug \
    -B "$HOME/umicom/packages/workbench-validation"
```

Extract the resulting archive into a new test directory on a compatible Linux environment, inspect its actual top-level folder, then repeat the installed executable/resource tests. Windows ZIPs cannot be used as native Linux deployments. No package is automatically signed, uploaded or activated by these commands.

## Interactive acceptance checklist

Use disposable workspaces and test identities. Record the exact executable and source revisions with each observation.

| Journey | Expected evidence | Status to record |
|---|---|---|
| Start and close | Correct original icon/full product name; usable surface; close releases process | Pending Windows and Linux |
| Startup cancellation | Closing startup prevents a delayed hidden/final window appearing | Pending native execution |
| Panel lifecycle | Add, focus, close and reopen a panel without stale callbacks or lost drafts | Pending |
| Canvas | Default/blank are distinct; add three panels; drag/resize; locked geometry remains fixed | Pending; no new canvas engine in this update |
| Layout persistence | Save and restart; keep drafts and diagnose failed restoration | Pending |
| Studio work | Open a disposable project, edit/save, build, navigate an error, repair and test | Pending |
| Installed resources | Launch outside source root; icons, templates and component resources resolve | Pending |
| Clean deployment | Start without the source checkout or developer PATH; dependencies accounted for | Pending release gate |
| Financial safety | Simulated/paper records only; unavailable services do not claim success | Required |

These journeys define review work, not claims of newly implemented features. Keep any unsupported product actions marked unavailable; do not mark a test passed because a label or catalogue row exists.

## Useful diagnostics and rollback

For native audit problems, use the new command directly without any script:

```powershell
Set-Location "C:\umicom\umicom-applications"
& ".\build\windows-ucrt64-all-debug\bin\umicom-source-contracts.exe" `
    comments --root ".\framework" --root ".\applications"
```

```bash
cd "$HOME/umicom/Umicom-Applications"
./build/headless-debug/bin/umicom-source-contracts workbench \
    --source-dir . \
    --check every_native_main_window_requests_shared_icon_identity
```

Focused `--check` is for diagnosis only; the canonical CTest entry still runs every group. Unknown groups, missing roots and malformed source return errors rather than skipping. Keep the full failure messages; do not edit a production GTK cast to satisfy a source matcher.

Retain the previous installed prefix as the rollback copy. Close the new applications and start the old qualified installation explicitly if needed. Do not hard-reset repositories, discard edits, delete a build directory or overwrite a user database as a rollback shortcut. Schema/data migration safety is a separate product requirement, not something this source-validation update implements.

## Source and documentation register

This procedure uses the inspected parent at `7def604ef471befed07e75d0680197931309e593`, its Framework pin and the supplied Windows focused test log. The new Linux GUI preset and native tool are changes in this delivery. The preparation report is not a substitute for the user-machine runs above.

- [Parent source baseline](https://github.com/umicom-foundation/umicom-applications/tree/7def604ef471befed07e75d0680197931309e593)
- [Framework source baseline](https://github.com/umicom-foundation/umicom-framework/tree/a278f963f8d956f230f84ddc2f1ef6bbb9bdff8c)
- [Native application target and install composition](https://github.com/umicom-foundation/umicom-applications/blob/7def604ef471befed07e75d0680197931309e593/cmake/UmicomSharedNativeApplications.cmake)
- [CMake build and install command reference](https://cmake.org/cmake/help/latest/manual/cmake.1.html)
- [CTest test execution reference](https://cmake.org/cmake/help/latest/manual/ctest.1.html)
- [CPack packaging reference](https://cmake.org/cmake/help/latest/manual/cpack.1.html)
- [Git submodule recorded-revision update reference](https://git-scm.com/docs/git-submodule)
- [Linux graphical applications under WSL](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps)
- [GTK installation on Linux](https://www.gtk.org/docs/installations/linux/)
