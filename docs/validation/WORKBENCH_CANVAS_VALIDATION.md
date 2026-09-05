# Workbench Canvas Core Validation

**Recorded:** 5 September 2026  
**Result:** Historical portable model tests passed; graphical, Windows and suite-wide validation not performed. The Workbench Canvas coordinator has since received host-bootstrap, dependency-boundary and in-canvas move/resize fixes in the copied worktree and requires fresh local validation there.

## Exact source baselines

| Repository | Remote commit used |
|---|---|
| `umicom-foundation/umicom-applications` | `885018f02b92f1595277955f3d86723df5ab1b6e` |
| `umicom-foundation/umicom-framework` | `caaa56fd3c2aa5f881a4b963ed73682b7b144c3c` |

The connected repository reader resolved these main-branch commits during this work. Required individual source files were retrieved at the pinned Framework commit. Their complete bytes were checked against the Git blob SHA supplied by the reader. Twelve original files were materialised for the isolated compilation. The copied worktree now contains the coordinator, suite-layout bridge, build registration and regression-test updates; unchanged dependencies are excluded.

**This was not a complete repository clone.** The attempted container clone failed with `Could not resolve host: github.com`. The connected reader remained available. No local Windows working-tree state, previous delivery archive or fabricated source snapshot was used as the implementation baseline. No remote commits or pushes were performed.

## Build environment

- Linux x86_64.
- GCC 14.2.0 (Debian 14.2.0-19).
- Clang 17.0.0.
- CMake 3.31.6 and Ninja.
- GTK4 development files were not found by pkg-config.

## Executed checks

| Configuration | Result |
|---|---|
| GCC Debug, strict warnings, candidate allocation-failure injection | Passed |
| Clang Release, strict warnings, candidate allocation-failure injection | Passed |
| Clang Debug, AddressSanitizer and UndefinedBehaviorSanitizer, leak detection, allocation-failure injection | Passed |

Each configuration executed **one CTest test**, `framework.workspace_canvas.transactions`, containing **13 named test groups** when allocation-failure injection was enabled. This is not 13 CTest entries and is not an all-application test run. Without the optional injection, the executable runs 12 groups.

Compiler options: `-std=c2x -Wall -Wextra -Wpedantic -Wconversion -Wshadow -Werror`.

The target also uses `-ffunction-sections -fdata-sections` and `-Wl,--gc-sections`. This intentionally isolates the portable paths under test and excludes unused customisation functions that require other libraries. All functions exercised are real Framework implementations; no substitute production models or function stubs were introduced. **Full UI-library linking is unverified.**

## Test groups

1. Blank creation, prior-layout/catalogue/theme preservation and aliased readable name.
2. Blank creation failure atomicity, busy state, duplicate ID, invalid and overlong inputs.
3. Full named-layout capacity.
4. Clear, cancellation, commit and context restoration.
5. Protected and detached instance handling, repeated clear no-op.
6. Legacy instance IDs referenced by another stored layout retain context membership.
7. Free canvas placement, native-floating distinction and cancellation.
8. Rejected non-finite, non-positive and out-of-bounds geometry.
9. Pinned, non-resizable and edit-state policy.
10. Malformed bounded records, duplicate IDs and unterminated identifiers.
11. Revision-overflow rejection without mutation.
12. Full 64-window active layout with mixed protection.
13. Injected candidate allocation failure leaves original state unchanged.

The checks remain active in Release builds. Failures are not hidden by disabling assertions. Test fixtures are layout records only, not complete application sessions. There is no graphical catalogue or event-loop test in this suite.

## Commands executed in the available environment

```sh
cmake -S /mnt/data/workbench-build/updated/framework/tests/workspace_canvas \
  -B /mnt/data/workbench-build/build-gcc -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug -DUMICOM_CANVAS_TEST_ALLOCATION_FAILURES=ON
cmake --build /mnt/data/workbench-build/build-gcc
ctest --test-dir /mnt/data/workbench-build/build-gcc -V

cmake -S /mnt/data/workbench-build/updated/framework/tests/workspace_canvas \
  -B /mnt/data/workbench-build/build-clang -G Ninja \
  -DCMAKE_C_COMPILER=clang -DCMAKE_BUILD_TYPE=Release \
  -DUMICOM_CANVAS_TEST_ALLOCATION_FAILURES=ON
cmake --build /mnt/data/workbench-build/build-clang
ctest --test-dir /mnt/data/workbench-build/build-clang -V

cmake -S /mnt/data/workbench-build/updated/framework/tests/workspace_canvas \
  -B /mnt/data/workbench-build/build-sanitizers -G Ninja \
  -DCMAKE_C_COMPILER=clang -DCMAKE_BUILD_TYPE=Debug \
  -DUMICOM_CANVAS_TEST_SANITIZERS=ON \
  -DUMICOM_CANVAS_TEST_ALLOCATION_FAILURES=ON
cmake --build /mnt/data/workbench-build/build-sanitizers
ASAN_OPTIONS=detect_leaks=1 ctest \
  --test-dir /mnt/data/workbench-build/build-sanitizers -V
```

Configure, build and verbose test outputs are provided separately in the delivery evidence archive. The final test output is `PASS: 13 canvas transaction test groups, including allocation failure` and `100% tests passed, 0 tests failed out of 1` for each tested configuration.

## Source preservation and package checks

Original production function bodies and comments were compared byte-for-byte against the verified originals after accounting for the single added standard include. They are unchanged. The existing header prefix, all existing structures and existing declarations are preserved. New declarations precede its final include-guard terminator.

The sidecar manifest records original/new SHA-256 hashes and whitespace-insensitive line counts. Those counts are computed with Git's whitespace-insensitive textual diff; they are not a claim of formal semantic equivalence analysis. No unchanged or whitespace-only source file is included. The approved specification is new at its target repository path and is copied verbatim from the user's supplied document; it is requirements documentation, not newly implemented code.

## Complete application inventory versus actual adoption

The 24 paths below were read from the pinned parent `.gitmodules`. The core is shared Framework code, but no client was started or wired to the new operations. Registry membership alone is not application acceptance. No per-client implementation was duplicated.

| Client path | Inventory evidence | Graphical integration and runtime evidence |
|---|---|---|
| `applications/accountant` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/bank` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/cad` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/creator` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/database-studio` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/desktop` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/education` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/exchange` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/games` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/integration-studio` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/kitchen` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/llm` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/marketplace` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/media` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/mobile-studio` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/music` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/operations` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/os` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/rag` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/security-centre` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/studio` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/tms` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/trader` | Present in pinned `.gitmodules` | Not integrated or started here |
| `applications/web-studio` | Present in pinned `.gitmodules` | Not integrated or started here |

A later integration change must show the default-to-blank-to-panel-to-move/resize-to-cancel journey for every supported graphical client, either through the shared runtime or a verified thin binding. The shared GTK4 suite workstation now registers each product's portable canvas host, but that registration alone is not graphical acceptance evidence. Do not mark clients complete because they link Framework or are listed here.

## Checks not performed

- Complete parent checkout, suite configuration, full build or full CTest run.
- Windows UCRT64 compile, link or execution.
- GTK4 adapter compile/link, window presentation or screenshot acceptance.
- Fresh validation of the coordinator test after the host-bootstrap and in-canvas placement changes.
- Official icon loading or placement repair.
- Widget dragging, resize handles, snapping, docking or z-order interaction.
- Canvas placement serialization, migration or Data Server persistence.
- Cross-host transfer, multiple monitors or typed clipboard interoperability.
- Resolution of historical build failures in other translation units supplied earlier.

No such result is asserted by this package.

## Local isolated verification after merge

The source files in the ZIP must be merged into a full checkout matching the recorded Framework baseline. This standalone test project supports GCC or GNU-driver Clang with a GNU-compatible linker. The commands below are provided for local verification; they were not executed on Windows here.

```powershell
Set-Location "C:\umicom\umicom-applications"
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"

& "C:\msys64\ucrt64\bin\cmake.exe" `
    -S ".\framework\tests\workspace_canvas" `
    -B ".\build\workspace-canvas-tests" `
    -G Ninja `
    "-DCMAKE_C_COMPILER=C:/msys64/ucrt64/bin/gcc.exe" `
    "-DCMAKE_MAKE_PROGRAM=C:/msys64/ucrt64/bin/ninja.exe" `
    -DCMAKE_BUILD_TYPE=Debug

& "C:\msys64\ucrt64\bin\cmake.exe" `
    --build ".\build\workspace-canvas-tests"

& "C:\msys64\ucrt64\bin\ctest.exe" `
    --test-dir ".\build\workspace-canvas-tests" `
    --output-on-failure
```

The default local configuration runs 12 test groups. It does not enable optional allocation-failure injection or sanitizers. Existing build directories and saved user layouts do not need to be deleted. Rebuilding Studio with this package alone will not visibly change the interface.
