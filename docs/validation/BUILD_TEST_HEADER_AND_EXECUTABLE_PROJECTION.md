# Test Header Dependency and Executable-Name Projection Repair

Owner: Umicom Foundation  
Date: 8 September 2026  
Scope: one application-suite test target and the existing Framework desktop projection

## Inspected source baseline

- Applications: `2ce7e0a88661fc5f4fe8baad95f22003cd951b74`.
- Pinned Framework: `bb496d15541e7263fbfd3f0b59a293e90b370744`.
- Both original complete changed files were reconstructed from the connected repository reader and checked against Git's exact blob hashes before editing.
- Direct Git cloning failed in the execution environment because the GitHub hostname could not be resolved. No complete checkout or integrated build is claimed.

## Build-stopping defect

`tests/test_validation_target_closure.c` includes the real Framework header `umicom/test_runtime/check.h`. The header exists at the pinned revision. The target in `tests/CMakeLists.txt` had neither a Framework link dependency nor its include usage requirements. The failing compiler invocation in the user's log has no Framework `-I` option.

Add a private dependency on the existing `Umicom::base` target. That target exports the Framework public include root. The diagnostic check itself is header-only, so there is no need to link the full Framework runtime or invent a local replacement header. Existing test registration, labels and validation-target registration remain intact.

## Desktop warning

`umi_desktop_shell_model_project_application()` already verifies source termination and rejects executable names that cannot fit in the taskbar item. It then used `snprintf()` with a potentially much larger source array; the user's compiler emitted a format-truncation warning for that call.

The repair measures the terminated source once into `size_t executable_name_length`, retains the existing capacity rejection and uses `memcpy()` for exactly the length plus its terminating NUL byte. Empty executable names remain accepted, as before. Rejected inputs leave the live item and model unchanged because the candidate is not committed. There is no buffer enlargement, ABI change, basename conversion, identifier truncation or disabled compiler warning.

All original production comments and unrelated code are retained. The only edited production function is the existing desktop projection function. Application modules and Umicom OS are not modified.

## Validation actually performed

- Exact original Git blob checks passed for both modified files.
- The unchanged header-dependent test and `check.h` were also verified against their Git blob hashes.
- Missing-header compilation was reproduced with GCC and Clang by omitting the public include directory.
- The unchanged test source compiled and linked with strict warnings under both compilers when the real public include directory was supplied. The resulting test executable was NOT run: its source-tree assertions need the full parent, Framework and Studio checkout.
- An isolated copy-block probe extracted the changed block directly from the delivered source. It tested all 2,048 terminated input lengths for a 2,048-byte source and 128-byte destination, plus unterminated and null inputs. It checked exact copying, retained empty-string support and unchanged output on rejection.
- That probe passed with GCC and Clang at -O0 and -O2, and with Clang address/undefined-behaviour sanitizers. It is a buffer-copy test, not a full desktop-model or graphical test.
- Complete source-comment preservation and changes outside the selected production function were checked.
- ZIP integrity, UTF-8, per-file hashes and absence of whitespace-only changed files were checked.

Not performed here: full `umicom_desktop` compilation/link, actual suite CMake configuration, execution of `applications.validation_target_closure`, any all-application CTest run, native Windows UCRT64 compilation, application startup, visual checks or deployment. The local commands below provide those integration checks. Do not equate the isolated probes with them.

## Apply

Compare the archive's `umicom-applications/` folder with `C:\umicom\Umicom-Applications`. Merge only the two source/build edits and this validation record. Preserve any unrelated local edits. Do not reset submodules or delete build directories.

## Windows verification

In PowerShell, from `C:\umicom\Umicom-Applications`:

```powershell
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"
Test-Path -LiteralPath ".\framework\include\umicom\test_runtime\check.h"
```

The header check should be True. If it is False, stop and inspect the local Framework checkout; do not fabricate or duplicate the header.

```powershell
& "C:\msys64\ucrt64\bin\cmake.exe" --preset windows-ucrt64-all-debug
if ($LASTEXITCODE -ne 0) { throw "Configuration failed. Stop here." }

& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --target umicom-applications-validation-target-closure-test umicom_desktop --parallel 2
if ($LASTEXITCODE -ne 0) { throw "Focused build failed. Stop here." }

& "C:\msys64\ucrt64\bin\ctest.exe" --preset windows-ucrt64-all-debug -R '^applications\.validation_target_closure$' --output-on-failure
if ($LASTEXITCODE -ne 0) { throw "Focused test failed. Stop here." }

& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --parallel 2
if ($LASTEXITCODE -ne 0) { throw "Full build failed. Do not install or package." }

& "C:\msys64\ucrt64\bin\ctest.exe" --preset windows-ucrt64-all-debug --parallel 2 --output-on-failure
if ($LASTEXITCODE -ne 0) { throw "Tests failed. Do not install or package." }
```

CMake reconfiguration updates the existing Ninja build graph. There is no need for `--fresh` or deletion of compiled output. The final PowerShell exception in the reported log was the requested safety guard reacting to Ninja's error; it was not a third build defect.

## Ownership and prevention

Reusable behaviour stays in Framework. Suite-only target composition stays in the parent repository. Commit and push Framework before recording its changed gitlink in the parent. No Studio, Bank or Trader source commit is needed for this repair.

Keep target-scoped dependencies explicit; avoid global include-path workarounds, duplicate test macros and warning suppression. Tests consuming Framework headers must receive the SDK usage requirements. Executable identifiers must fit completely or be rejected rather than silently shortened.

## Source references

- [Parent test definitions](https://github.com/umicom-foundation/umicom-applications/blob/2ce7e0a88661fc5f4fe8baad95f22003cd951b74/tests/CMakeLists.txt)
- [Existing test](https://github.com/umicom-foundation/umicom-applications/blob/2ce7e0a88661fc5f4fe8baad95f22003cd951b74/tests/test_validation_target_closure.c)
- [Existing diagnostic header](https://github.com/umicom-foundation/umicom-framework/blob/bb496d15541e7263fbfd3f0b59a293e90b370744/include/umicom/test_runtime/check.h)
- [Desktop projection](https://github.com/umicom-foundation/umicom-framework/blob/bb496d15541e7263fbfd3f0b59a293e90b370744/src/desktop/shell_model.c)
- [Framework base target](https://github.com/umicom-foundation/umicom-framework/blob/bb496d15541e7263fbfd3f0b59a293e90b370744/CMakeLists.txt)
- [CMake target usage requirements](https://cmake.org/cmake/help/latest/command/target_link_libraries.html)
