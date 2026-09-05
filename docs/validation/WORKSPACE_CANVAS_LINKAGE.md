# Workspace Canvas Test Linkage

**Date:** 5 September 2026
**Scope:** Isolated Framework canvas tests only
**Source baseline:** `umicom-foundation/umicom-framework` at `a831a6e0f7a990a66384171b722bcbb235a72746`
**Status:** Dependency repair implemented; native Windows verification remains pending.

## Reported failure

The standalone target compiled its C translation units but failed while linking
`umicom-workspace-canvas-test.exe`. Its source list included only the transaction
test, workspace customisation, workspace layout and window groups. It omitted
implementations referenced by workspace customisation. CTest subsequently
reported Not Run because the executable had not been produced.

This is a test-build dependency error. The pasted application-build excerpt does
not report a compiler or linker failure. Studio returning to the PowerShell
prompt without a visible window is a separate, undiagnosed runtime symptom.

## Correction

The existing standalone CMake target now additionally compiles these existing
Framework sources:

| Source under `framework/src/ui/` | Dependency supplied |
|---|---|
| `window_catalogue.c` | Catalogue initialisation, lookup and recent-open recording |
| `theme_profile.c` | Theme initialisation and validation |
| `brand_palette.c` | Canonical palette lookup and validation used by theme initialisation |
| `types.c` | Placement parsing and text conversion |
| `workspace_geometry.c` | Region support and default region rectangles |

No replacement production function, stub, duplicate model or application-local
implementation is introduced. The sources above are already in the repository
and are not copied into this delivery as changed files.

The target no longer requests function/data section splitting or section garbage
collection. It links all eight selected production translation units and resolves
their dependencies explicitly.

This supersedes the earlier canvas-test design that relied on discarding unused
functions. It does not change the production UI library or remove any canvas
feature.

## Engineering decision: dependency-complete isolated targets

An isolated executable must include or link the real dependencies of every
production translation unit it compiles. Unused-code removal is an optimisation,
not a substitute for a correct dependency graph.

For this standalone target, the source list is explicit to avoid configuring the
entire application estate. A future suite integration should reuse existing
Framework library targets and register these tests in the normal CTest tree.
Such integration is not included in this repair.

## Regression test

`testProductionDependencyClosure()` is added to the existing transaction test.

It calls the real workspace initialiser, validates the initial theme, registers
a panel descriptor, creates a blank layout, opens that descriptor through the
catalogue, verifies recent-open metadata and semantic geometry, docks the panel
in another region, checks default panel settings, changes the theme, clears the
canvas and verifies that the catalogue definition survives.

All earlier test functions remain unchanged. `main` invokes the additional test
and its printed group count is updated.

Default build: 13 groups in one CTest executable.
Allocation-failure build: 14 groups in the same executable.

## Validation actually executed

All dependency files used for validation were retrieved from the pinned
Framework revision. Their complete reconstructed bytes were checked against
Git blob hashes. The previously delivered canvas header, implementation, test and
CMake file also match that revision.

| Check | Result |
|---|---|
| Original incomplete source list, Linux GCC link without dead stripping | Reproduced the user's missing Framework symbols |
| Corrected GCC 14.2.0 Debug configure, build, CTest | Passed, 13 groups |
| Corrected GCC 14.2.0 Release with allocation failure injection | Passed, 14 groups |
| Corrected Clang 17.0.0 Debug configure, build, CTest | Passed, 13 groups |
| Corrected Clang 17.0.0 with address/undefined-behaviour sanitizers, leak detection and allocation failure injection | Passed, 14 groups when launched from the container shell |
| Symbol inspection of the GCC executable | All previously missing symbols and the palette dependency are defined |
| Native Windows UCRT64 execution | Not executed here |
| Full application build or Studio graphical startup | Not executed here |

The first sanitizer run launched as a Python child aborted before `main` because
AddressSanitizer could not reserve its shadow-memory address space in that
execution environment. The same built binary passed when launched from the
container shell. Both logs are retained in the evidence archive.

Strict build options remain `-std=c2x -Wall -Wextra -Wpedantic -Wconversion
-Wshadow -Werror`. No warning or unresolved-symbol diagnostic is suppressed.

## Windows verification

The existing standalone build directory already has its compiler and generator
configured. After merging these files, reconfigure, build and then run CTest:

```powershell
Set-Location "C:\umicom\umicom-applications"
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"

& "C:\msys64\ucrt64\bin\cmake.exe" `
    -S ".\framework\tests\workspace_canvas" `
    -B ".\build\workspace-canvas-tests"

& "C:\msys64\ucrt64\bin\cmake.exe" `
    --build ".\build\workspace-canvas-tests" `
    --parallel 2

& "C:\msys64\ucrt64\bin\ctest.exe" `
    --test-dir ".\build\workspace-canvas-tests" `
    --output-on-failure
```

Stop after a failed configure or build; CTest cannot execute a missing binary.
No main-build directory, saved layout or user configuration needs to be deleted.

## Studio startup boundary

This repair does not alter Studio. In the submitted command sequence, the two
Studio launch attempts precede the explicit UCRT64 PATH setup. That makes runtime
DLL discovery worth checking, but it does not establish the cause.

Retry from a session with the runtime environment configured and capture the
started process, its exit code if it exits, and standard output/error. A running
process without a visible window is not a successful startup acceptance test.
A loader failure may occur before the application can write any log.

## Application-family impact and roadmap

All applications retain the same Framework-owned canvas contracts and current
behaviour. This repair changes only the shared isolated test build and its test
coverage. It does not add graphical client integration, change branding, modify
layouts, or prove that any application starts successfully.

Remaining work is unchanged: integrate canvas commands into the shared
workbench, implement the in-canvas window renderer and input handling, connect
native detachment and host transfer, then validate visible journeys across the
application family. Those features are not described as delivered here.
