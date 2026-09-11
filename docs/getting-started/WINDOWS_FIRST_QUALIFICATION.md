# Windows-first qualification and Linux synchronisation

## Read first

The source archive is rooted at `umicom-applications/`. Align that folder with
`C:\umicom\umicom-applications`; do not create another nested copy. Merge the complete
changed files with a comparison tool. Do not copy build directories, replace entire
submodules, reset local work, or apply this update to `umicomOS`.

Run Windows commands in PowerShell and Linux commands inside Ubuntu. Run each section
in order and stop on any error. Do not install, commit or publish a candidate whose
required build or tests still fail. Existing binaries are not evidence for new source.

The known baseline revisions and remaining validation limitations are in
`docs/architecture/WORKSPACE_CONTRACT_REPAIRS.md`.

## 1. Prepare Windows branches before merging

Only Framework, Studio, Desktop and the Applications parent change in this delivery.
Inspect their status and preserve any unrelated edits or unpublished commits first.
Do not use forced switching, resets, cleaning or automatic stashing.

```powershell
Set-Location "C:\umicom\umicom-applications"
git status
git submodule foreach --recursive 'echo ===== $displaypath =====; git status --short'

git -c submodule.recurse=false switch main
if ($LASTEXITCODE -ne 0) { throw "Could not select Applications main." }

Set-Location "C:\umicom\umicom-applications\framework"
git switch main
if ($LASTEXITCODE -ne 0) { throw "Could not select Framework main." }

Set-Location "C:\umicom\umicom-applications\applications\studio"
git switch main
if ($LASTEXITCODE -ne 0) { throw "Could not select Studio main." }

Set-Location "C:\umicom\umicom-applications\applications\desktop"
git switch main
if ($LASTEXITCODE -ne 0) { throw "Could not select Desktop main." }
```

A switch can select an older local branch. Compare `git rev-parse HEAD` in each
repository with the documented baseline before merging. Stop if histories differ;
do not force a branch to another commit. If the files were already merged while a
submodule was detached, inspect its status and switch safely before committing.

## 2. Configure and build all Windows modules

After merging and reviewing the changed files:

```powershell
Set-Location "C:\umicom\umicom-applications"
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"

git diff --check
if ($LASTEXITCODE -ne 0) { throw "Parent whitespace check failed." }
git -C framework diff --check
if ($LASTEXITCODE -ne 0) { throw "Framework whitespace check failed." }
git -C applications/studio diff --check
if ($LASTEXITCODE -ne 0) { throw "Studio whitespace check failed." }
git -C applications/desktop diff --check
if ($LASTEXITCODE -ne 0) { throw "Desktop whitespace check failed." }

& "C:\msys64\ucrt64\bin\cmake.exe" `
    --preset windows-ucrt64-all-debug `
    -DUMICOM_BUILD_NATIVE_TOOL=ON
if ($LASTEXITCODE -ne 0) { throw "Configuration failed. Do not build." }

& "C:\msys64\ucrt64\bin\cmake.exe" `
    --build `
    --preset windows-ucrt64-all-debug `
    --parallel 2 `
    -- `
    -k 0
if ($LASTEXITCODE -ne 0) { throw "Build failed. Do not install or publish." }
```

`-k 0` lets Ninja continue independent work after a failure. It does not make a failed
build successful. There is no need to delete the existing build directory.

## 3. Focused Windows tests, then the complete suite

```powershell
& "C:\msys64\ucrt64\bin\ctest.exe" `
    --preset windows-ucrt64-all-debug `
    --parallel 1 `
    --no-tests=error `
    --output-on-failure `
    -R '^(applications\.(sdk\.public_headers|source\.comments|native_window_responsiveness\.source)|framework\.application_resource_broker|studio\.(command_inventory_partition|designer_workspace_model))$'
if ($LASTEXITCODE -ne 0) { throw "Focused tests failed. Stop before publishing." }

& "C:\msys64\ucrt64\bin\ctest.exe" `
    --preset windows-ucrt64-all-debug `
    --parallel 2 `
    --no-tests=error `
    --output-on-failure
if ($LASTEXITCODE -ne 0) { throw "Full Windows tests failed. Do not install or publish." }
```

A source-text check is not an interactive GUI test. Inspect skipped tests as well as
failures; an unexecuted GTK test is not evidence that a window works.

## 4. Optional Windows development staging install

Only after required tests pass, install the build's declared install rules into an
isolated development directory. Do not overwrite a production installation.

```powershell
& "C:\msys64\ucrt64\bin\cmake.exe" `
    --install ".\build\windows-ucrt64-all-debug" `
    --prefix "C:\umicom\install\applications-debug"
if ($LASTEXITCODE -ne 0) { throw "Development staging install failed." }
```

This is not an end-user installer or a claim of complete DLL/resource packaging.
Runtime deployment, signing, packaging and clean-machine launch still need separate
qualification. If CMake reports missing install products, stop rather than copying
old binaries into the staging directory.

## 5. Commit and push the changed child repositories

These commands stage all changes in each repository. Review the status before the
commit and exclude secrets, generated files or unrelated edits. Confirm the current
branch is `main`. Do not repeat a commit if Git says the working tree is already clean.
A rejected push needs reconciliation; do not force it.

### Framework first

```powershell
Set-Location "C:\umicom\umicom-applications\framework"
git branch --show-current
git add -A
git status
git diff --cached --check
if ($LASTEXITCODE -ne 0) { throw "Framework staged check failed." }
git commit -m "fix(framework): restore required workspace and discovery source metadata"
if ($LASTEXITCODE -ne 0) { throw "Framework commit failed. Inspect Git output." }
git push origin main
if ($LASTEXITCODE -ne 0) { throw "Framework push failed. Do not publish the parent." }
```

### Studio second

```powershell
Set-Location "C:\umicom\umicom-applications\applications\studio"
git branch --show-current
git add -A
git status
git diff --cached --check
if ($LASTEXITCODE -ne 0) { throw "Studio staged check failed." }
git commit -m "fix(studio): complete command inventory and validate designer properties by identity"
if ($LASTEXITCODE -ne 0) { throw "Studio commit failed. Inspect Git output." }
git push origin main
if ($LASTEXITCODE -ne 0) { throw "Studio push failed. Do not publish the parent." }
```

### Desktop third

```powershell
Set-Location "C:\umicom\umicom-applications\applications\desktop"
git branch --show-current
git add -A
git status
git diff --cached --check
if ($LASTEXITCODE -ne 0) { throw "Desktop staged check failed." }
git commit -m "fix(desktop): align native titlebar test file metadata"
if ($LASTEXITCODE -ne 0) { throw "Desktop commit failed. Inspect Git output." }
git push origin main
if ($LASTEXITCODE -ne 0) { throw "Desktop push failed. Do not publish the parent." }
```

No unrelated application module needs a source commit for this update.

## 6. Update the parent lock and publish the integration

The lock command records checked-out submodule commits; it does not commit source
inside them or push those commits. Run it only after the child commits above are
published, without updating submodules back to the old parent pin in between.

```powershell
Set-Location "C:\umicom\umicom-applications"
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"

& ".\build\windows-ucrt64-all-debug\bin\umicom.exe" `
    repo `
    lock `
    .
if ($LASTEXITCODE -ne 0) { throw "Repository lock failed." }

git status
git add -A
git diff --cached --check
if ($LASTEXITCODE -ne 0) { throw "Parent staged check failed." }
git diff --cached --submodule=log
```

Check that the staged Framework, Studio and Desktop gitlinks equal their checked-out
HEADs. Check each child's `git ls-remote origin refs/heads/main` output against its
local `git rev-parse HEAD` output. Review other staged gitlinks: the lock command visits
all registered modules, not just the three changed here.

```powershell
git rev-parse :framework
git -C framework rev-parse HEAD
git rev-parse :applications/studio
git -C applications/studio rev-parse HEAD
git rev-parse :applications/desktop
git -C applications/desktop rev-parse HEAD
```

After reviewing matching pairs and intended staged changes:

```powershell
git commit -m "fix(applications): align workspace source regressions and pin qualified module revisions"
if ($LASTEXITCODE -ne 0) { throw "Parent commit failed." }
git push --recurse-submodules=check origin main
if ($LASTEXITCODE -ne 0) { throw "Parent push failed." }

git submodule foreach --recursive 'echo ===== $displaypath =====; git status --short'
git status
```

## 7. Update the existing Linux checkout

Run inside Ubuntu. Do not create another checkout, move Windows build files into Linux,
or create duplicate Linux commits. Inspect local source edits and unpublished work
before running the update; the commands below do not discard that work.

```bash
cd "$HOME/umicom/Umicom-Applications"
git status --short
git submodule foreach --recursive 'echo "===== $displaypath ====="; git status --short'
```

For a clean checkout with no unpublished work:

```bash
cd "$HOME/umicom/Umicom-Applications" &&
git -c submodule.recurse=false switch main &&
git -c submodule.recurse=false pull --ff-only origin main &&
git submodule sync --recursive &&
git submodule update --init --recursive --checkout
```

Do not add `--remote`. Use the exact published combination recorded by the parent,
not independent latest submodule branches. A detached HEAD in a pinned build submodule
is normal.

```bash
git submodule status --recursive
git rev-parse HEAD:framework
git -C framework rev-parse HEAD
git rev-parse HEAD:applications/studio
git -C applications/studio rev-parse HEAD
```

The corresponding hashes must match. The repaired Framework revision will be newer
than the archive's original `9c4a09e...` baseline after the Windows commits.

## 8. Configure, build and test Linux

```bash
cd "$HOME/umicom/Umicom-Applications" &&
cmake --preset headless-debug \
    -DCMAKE_C_COMPILER=/usr/bin/clang \
    -DUMICOM_APPLICATIONS_BUILD_ALL_MODULES=ON &&
cmake --build \
    --preset headless-debug \
    --parallel 2 \
    -- \
    -k 0 &&
ctest --preset headless-debug \
    --parallel 1 \
    --no-tests=error \
    --output-on-failure \
    -R '^(applications\.(sdk\.public_headers|source\.comments|native_window_responsiveness\.source)|framework\.application_resource_broker|studio\.(command_inventory_partition|designer_workspace_model))$' &&
ctest --preset headless-debug \
    --parallel 2 \
    --no-tests=error \
    --output-on-failure
```

This keeps the existing headless build directory and enables the complete registered
module set. It does not enable graphical frontends. Stop on errors before installation.

## 9. The remaining resource-broker diagnostic

The current summary does not identify its failed assertion. Check the exact local
Framework file and run that one test verbosely, through CTest in its configured working
directory rather than by launching random test executables from the source root.

```bash
git -C framework log -1 --oneline
grep -n 'default_layout_id' framework/tests/application/test_application_resource_broker.c
ctest --preset headless-debug \
    --parallel 1 \
    --no-tests=error \
    --verbose \
    -R '^framework\.application_resource_broker$' \
    --output-log "$HOME/umicom/resource-broker-latest.log"
```

The expected layout string in the inspected current source is `development`. If the
focused test still fails after source/revision verification and rebuilding, retain
`resource-broker-latest.log`. Do not weaken resource permissions or change lease
semantics without the actual failed assertion and an implementation trace.

## 10. Optional Linux development staging install

Only after the required Linux tests pass:

```bash
cmake --install build/headless-debug \
    --prefix "$HOME/umicom/install/applications-headless-debug"
```

This executes the current build's install rules into a user-owned directory; do not use
`sudo` or overwrite `/usr`. It is not a complete desktop image or distribution package.
Linux does not need a new commit, push or repository-lock operation for synchronising
this Windows-published update. Leave the separate Umicom OS checkout unchanged.
