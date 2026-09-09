# Build and Publish the Cross-platform Build Qualification Update

This guide assumes the existing Umicom checkouts, toolchains and source files.
It does not create branches, erase build output, replace Framework with a copy,
or update the unrelated Umicom OS checkout.

## 1. Merge into the Applications checkout

The archive root is `umicom-applications/`. Align it with ONE authoring checkout:

- Linux: `/home/umicom/umicom/Umicom-Applications`.
- Windows: `C:\umicom\Umicom-Applications`.

Use your comparison tool and merge all listed files. The Framework helper and
its fixture files must accompany the root CMake change. Do not merge only the
new root CMake file while leaving the Framework helper absent.

Existing uncommitted repairs and local edits must be retained. If your parent
baseline or files differ from the manifest, compare the changes; do not replace
newer files blindly. A previously applied four-line header repair is incorporated
in this delivery; do not add a duplicate dependency block.

## 2. Resume the current Linux build without starting over

Run INSIDE UBUNTU, not PowerShell:

```bash
cd "$HOME/umicom/Umicom-Applications"
git status --short
git -C framework status --short
git diff --check
git -C framework diff --check
```

Regenerate your existing Clang build directory, then build the small closure:

```bash
cmake --preset headless-debug \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DUMICOM_APPLICATIONS_BUILD_ALL_MODULES=ON \
&& cmake --build --preset headless-debug \
  --target umicom-build-contract-tests --parallel 2
```

Only after that succeeds:

```bash
ctest --preset headless-debug --no-tests=error --output-on-failure \
  -R '^framework\.build_contract\.|^applications\.(validation_target_closure|cmake_graph_closure|build_presets)$'
```

Only after the focused selection passes:

```bash
cmake --build --preset headless-debug --parallel 2 \
&& ctest --preset headless-debug --parallel 2 --no-tests=error --output-on-failure
```

The new `linux-all-headless-debug` and `linux-gcc-all-headless-debug` presets
are for repeatable separate qualification builds. Do not switch a half-built
checkout to a new preset merely to fix this error: a new preset uses a new build
directory and recompiles its selected configuration.

## 3. Windows verification using the existing GTK4 build

Run in POWERSHELL:

```powershell
Set-Location "C:\umicom\Umicom-Applications"
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"

& "C:\msys64\ucrt64\bin\cmake.exe" --preset windows-ucrt64-all-debug
if ($LASTEXITCODE -ne 0) { throw "Configuration failed." }

& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --target umicom-build-contract-tests --parallel 2
if ($LASTEXITCODE -ne 0) { throw "Focused build failed." }

& "C:\msys64\ucrt64\bin\ctest.exe" --preset windows-ucrt64-all-debug --no-tests=error --output-on-failure -R '^framework\.build_contract\.|^applications\.(validation_target_closure|cmake_graph_closure|build_presets)$'
if ($LASTEXITCODE -ne 0) { throw "Focused tests failed." }

& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --parallel 2
if ($LASTEXITCODE -ne 0) { throw "Full build failed. Do not install or package." }

& "C:\msys64\ucrt64\bin\ctest.exe" --preset windows-ucrt64-all-debug --parallel 2 --no-tests=error --output-on-failure
if ($LASTEXITCODE -ne 0) { throw "Full tests failed. Do not install or package." }
```

No native Windows execution was performed during creation of this delivery.
The source fix is platform-neutral; this sequence verifies your actual Windows
compiler and configured application tree.

## 4. Publish from ONE checkout, Framework first

The following is the Linux publishing route. Do not commit the same change
independently in Windows afterwards. Stop after any failed command. A build
failure outside this repair must be reported; do not describe a focused pass as
a full-suite pass in the commit/release evidence.

Check that the Framework working tree contains only intended changes:

```bash
cd "$HOME/umicom/Umicom-Applications"
git -C framework status
```

A submodule clone may be detached at the parent pin. Before committing these new
Framework files, select its existing `main` branch:

```bash
git -C framework switch main
```

This does not create a feature branch. Stop if Git refuses, the switch would
overwrite work, or it changes the Framework revision away from the tested
baseline. Never use --force or reset to get past that warning. Validate again
if the source revision changes. Then stage, inspect, commit and push:

```bash
git -C framework add -A
git -C framework diff --cached --check
git -C framework diff --cached --stat
git -C framework commit -m "feat(build): add reusable test dependency contract regressions"
git -C framework push origin main
```

Review the staged summary before committing. It must not contain secrets, build
artifacts or unrelated edits. If Git asks for identity, configure your own name
and email, not somebody else's. A rejected push is a reason to stop and reconcile
with the current remote; it is never permission to force-push.

After Framework is pushed, update the existing native suite lock from the full
successful build:

```bash
./build/headless-debug/bin/umicom repo lock .
```

If the executable is absent, do not invent a replacement script or claim the
lock was updated. Complete the configured native CLI build or review the lock
workflow first. If the lock operation fails, stop before publishing the parent.

Now publish the parent:

```bash
git branch --show-current
git status
git add -A
git diff --cached --check
git diff --cached --stat
git commit -m "fix(build): enforce cross-platform test dependencies and qualification"
git push --recurse-submodules=check origin main
```

The parent branch should be `main`. The parent records the new Framework
commit; it does not contain the Framework source files themselves. No Studio,
Bank, Trader or OS module commit is required by this update.

## 5. Update the other checkout after publication

Before updating Windows, review the parent and all submodules. If any contain
local edits, pending commits or intentionally advanced submodule pins, reconcile
those first. Do not discard earlier repairs.

```powershell
Set-Location "C:\umicom\Umicom-Applications"
git status --short
git submodule foreach --recursive "git status --short --branch"
```

For a clean checkout with no unpublished changes or dependency advances:

```powershell
git pull --ff-only origin main
if ($LASTEXITCODE -ne 0) { throw "Parent update failed. Stop." }
git submodule sync --recursive
if ($LASTEXITCODE -ne 0) { throw "Submodule URL synchronisation failed. Stop." }
git submodule update --init --recursive
if ($LASTEXITCODE -ne 0) { throw "Pinned submodule update failed. Stop." }
```

Do not add --remote: the goal is the Framework commit recorded by the updated
Applications parent. Reconfigure and run the Windows checks above afterwards.

## 6. Remote continuous-integration evidence

After the parent push, open the repository's Actions page and select
**Build contracts**. It has Linux/Clang, Linux/GCC and Windows/UCRT64 jobs.
The workflow configures all headless modules but builds and runs only focused
contract regressions. It is not a full release or graphical acceptance job.
A workflow file existing in Git is not evidence that it ran; inspect the actual
run and its retained logs. Repository Actions settings may require permission.

## 7. Troubleshooting

| Diagnostic | Meaning and action |
|---|---|
| Cannot include UmicomTestBuildContract.cmake | The Framework addition was not merged, committed or fetched with the parent update. Check the submodule pin. |
| Target must link Umicom::base directly | The dependency block is missing from the opted-in target. Restore the normal target_link_libraries call. |
| Missing Framework header | The local SDK differs or the submodule is incomplete. Do not copy a header from the older OS checkout. |
| CTest cannot find executable | Build the focused target first. A test registration does not create its executable. |
| Different hidden compiler error appears | This fix does not certify unrelated files. Keep the first full diagnostic and the active source revisions. |
| Nothing to commit | No new staged content exists in that repository; do not create an empty commit. |
| Push rejected | Stop, fetch/review and reconcile. Do not force-push main. |

The `umicomOS` repository and its working 295-test user-space baseline are left
unchanged. Framework version convergence with OS is a later, separately tested
integration task.
