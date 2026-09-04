# Umicom Application Header and Launcher Validation

**Status:** Source validation complete; Windows integration validation required
**Owner:** Umicom Framework
**Review date:** 4 September 2026

## Remote baselines

This implementation was created only from the committed remote repository state:

| Repository | Remote `main` commit |
|---|---|
| `umicom-foundation/umicom-applications` | `65d3d165ec081af6e6fc4f50ae191d8493541c81` |
| `umicom-foundation/umicom-framework` | `36ffc5c1bc18f31510b38c460f5353d06121f356` |
| `umicom-foundation/umicom-studio-ide-module` | `a0dab0172047a4d2d92f72186b6e8d12dd54406b` |

No uncommitted local Windows file was assumed. Every modified tracked file was first verified against its Git object in the remote commit.

## Scope validated

The implementation adds the first executable universal application-header slice:

- one active application identity tab;
- searchable plus catalogue sourced from the canonical Framework portfolio;
- standard-open and new-window launch modes;
- an additive host callback for future in-host application surfaces;
- executable resolution beside the current installation and on the operating-system search path;
- readable launch failure presentation;
- close through the owning window's normal close-request path;
- centre-dominant semantic workspace geometry;
- portfolio and geometry contract checks.

It does not claim completion of several simultaneous application surfaces inside one native host, drag transfer between host windows, transfer tokens, Data Server rehydration or complete product workflow redesign.

## Source validation performed

The changed C sources and tests were checked with both GCC and Clang using C23 and the project warning policy:

```text
-std=c2x
-Wall
-Wextra
-Wpedantic
-Wconversion
-Wshadow
-Werror
```

Results:

| Check | Result |
|---|---|
| Shell-header implementation, GCC strict compilation | PASS |
| Shell-header implementation, Clang strict compilation | PASS |
| Public shell-header API, isolated C compilation | PASS |
| Public shell-header API, isolated C++ compilation | PASS |
| Workspace-geometry implementation, GCC strict compilation | PASS |
| Workspace-geometry implementation, Clang strict compilation | PASS |
| Workspace-layout test, strict syntax compilation | PASS |
| Portfolio-alignment test, strict syntax compilation | PASS |
| Managed header create, configure and destroy smoke | PASS |
| Host callback receives stable application ID and new-window mode | PASS |
| Default process fallback resolves and invokes an executable | PASS |
| Case-insensitive catalogue search behaviour | PASS |
| Centre, side, bottom and floating geometry assertions | PASS |
| Conflict-marker scan | PASS |
| New trailing-whitespace and blank-line error scan | PASS |
| Canonical Umicom terminology scan | PASS |
| Whitespace-only source-file rejection | PASS |

The GTK and Framework API stubs used for source validation contain no product implementation and are not part of the delivery archive.

## Validation not performed in this environment

The complete Windows UCRT64/GTK4 repository build and graphical runtime were not executed in this environment. The Windows checkout remains authoritative for:

- MSYS2 UCRT64 link closure;
- GTK4 runtime DLL loading;
- application executable-name staging;
- visible placement in Studio, Desk, Bank, Trader and other graphical products;
- Windows multi-monitor and scaling behaviour.

These limits are explicit so source validation is not represented as a complete product acceptance result.

## Required Windows build

From `C:\umicom\umicom-applications`:

```powershell
$env:Path = "C:\msys64\ucrt64\bin;$env:Path"

& "C:\msys64\ucrt64\bin\cmake.exe" `
    --preset windows-ucrt64-all-debug

& "C:\msys64\ucrt64\bin\cmake.exe" `
    --build `
    --preset windows-ucrt64-all-debug `
    --parallel 2

& "C:\msys64\ucrt64\bin\ctest.exe" `
    --preset windows-ucrt64-all-debug `
    --parallel 2 `
    --output-on-failure
```

A clean build directory is not required. CMake and Ninja should rebuild only affected objects.

## Visible acceptance checks

Open Studio, Desk, Bank and Trader after a successful build and verify:

1. the Umicom mark or `<>` fallback and full application name remain visible;
2. the application identity reads as one active application tab;
3. the plus action opens the same searchable application catalogue in each product;
4. catalogue search matches application name, purpose and stable identifier;
5. selecting an available application starts it;
6. a missing executable produces a readable failure message instead of a silent no-op;
7. New Window requests another instance of the current product;
8. Close follows the product's existing close guard;
9. newly generated/default layouts give the centre more width than either side;
10. existing user-saved layouts remain unchanged until an explicit layout migration or reset.

## Acceptance conclusion

The source slice is suitable for Windows integration testing. It must not be marked fully verified until the complete all-application build, tests and visible journeys have been recorded from the Windows environment.
