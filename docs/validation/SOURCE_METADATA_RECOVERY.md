# Source metadata recovery

## Observed Windows result

The supplied Windows log, `Pasted text(20260911-081249).txt`, is a selected run of six CTest entries, not a complete application-suite run. The resource broker, Studio command inventory and Studio designer model pass. The public-header audit, source-comment audit and native-window source check fail.

The source-comment audit reports 38 missing labels across 16 C/include-fragment files. The public-header audit reports three missing attribution labels across three headers. A label finding is not a separate compilation error.

## What this delivery contains

Nineteen complete source/header files and this document. The nineteen files are verified copies of the metadata corrections in `Umicom-Workspace-Contract-Repairs.zip`; they are isolated here to make the outstanding comment-only edits visible during a merge. This is not a new runtime or UI feature update.

All bytes after each file's leading comment match the original baseline reconstructed and checked against the prior delivery's recorded Git blob and SHA-256 hashes. No identifier, include guard, declaration, executable statement, later comment, test assertion, CMake test registration or audit rule is changed by this recovery.

The files contain the canonical labels:

```text
File:
PURPOSE:
AUTHOR AND ORGANISATION:
LICENCE:
```

The attribution remains Sammy Hegab, Umicom Foundation, and the existing MIT licence remains unchanged. The original auditors look for exact text. `Purpose:` is not `PURPOSE:`; `Author:` or `AUTHOR:` is not `AUTHOR AND ORGANISATION:`; `Licence:` is not `LICENCE:`.

The previous archive contains these corrected labels. The Windows log shows that the source files read during that test run still lack them. The log alone cannot distinguish an incomplete merge, a comparison setting that ignores comments, a subsequent overwrite, or use of a different extraction folder. It is not evidence that the user caused the problem.

## Merge on Windows

Align the archive's `umicom-applications` directory with:

```text
C:\umicom\umicom-applications
```

Do not create `C:\umicom\umicom-applications\umicom-applications`.

Use a comparison that displays comment changes. Merge the leading banner corrections. Preserve newer local implementation changes below the banner; complete replacement files do not imply that unreviewed local work should be overwritten. Do not use forced checkout, reset, clean or submodule update to apply this recovery.

An immediate read-only spot-check is:

```powershell
Set-Location "C:\umicom\umicom-applications"

Get-Content `
    ".\framework\include\umicom\application\native_discovery.h" `
    -TotalCount 12
```

Its first comment must contain `AUTHOR AND ORGANISATION:`. Repeat the comparison for all files in the delivery manifest, not only this example.

## Verify the metadata before another build

The two audit tests read source files directly. They can verify the merge without recompilation:

```powershell
Set-Location "C:\umicom\umicom-applications"

& "C:\msys64\ucrt64\bin\ctest.exe" `
    --preset windows-ucrt64-all-debug `
    --parallel 1 `
    --no-tests=error `
    --output-on-failure `
    -R '^applications\.(sdk\.public_headers|source\.comments)$'

if ($LASTEXITCODE -ne 0) {
    throw "Source metadata validation failed. Stop and inspect the listed files."
}
```

A pass here is only the metadata gate. It does not establish application correctness or resolve the separate native-source check.

## Normal Windows qualification

Reuse the configured build directory:

```powershell
Set-Location "C:\umicom\umicom-applications"

$env:Path = "C:\msys64\ucrt64\bin;$env:Path"

& "C:\msys64\ucrt64\bin\cmake.exe" `
    --build `
    --preset windows-ucrt64-all-debug `
    --parallel 2 `
    -- `
    -k 0

if ($LASTEXITCODE -ne 0) {
    throw "Windows build failed. Do not install or publish."
}

& "C:\msys64\ucrt64\bin\ctest.exe" `
    --preset windows-ucrt64-all-debug `
    --parallel 2 `
    --no-tests=error `
    --output-on-failure

if ($LASTEXITCODE -ne 0) {
    throw "Windows validation failed. Do not install or publish."
}
```

Do not delete build directories, copy old executables between presets or relax the audit to make this pass.

## Separate native-window source-check defect

The checked Framework Desk source contains:

```c
(void)umi_gtk4_ws_apply_window_identity(GTK_WINDOW(desk->window));
```

The previously delivered Python source check uses `([^()]+)` to extract that call's argument. It excludes parentheses and therefore misses the nested `GTK_WINDOW(...)` expression. The supplied Windows run shows all the other methods in that script passing, with this one failed method remaining.

This is a defect in the source checker, not proof that Desk lacks an identity call. Do not delete the GTK cast, insert a dummy call, change a window variable solely to satisfy the text matcher, or disable the test.

This metadata delivery does not change that Python file and does not implement the native replacement. C23 is the required implementation language for new Umicom validation tooling; Assembly is available when technically justified. Existing coverage must be preserved while a native replacement is implemented, tested and connected to CTest. Supporting other programming languages inside Studio remains a separate product capability.

## Publication boundary

Do not publish this state as a qualified update while the native-source test or any other required Windows test fails. After the remaining defect is repaired and Windows qualification passes, commit and push each changed child repository on its existing `main`, run the matching native lock tool at `build\windows-ucrt64-all-debug\bin\umicom.exe repo lock .`, review the parent gitlinks, and commit/push the parent. Do not use the older `windows-ucrt64-debug` executable path for this build.

Linux should then pull the parent and update submodules to the recorded revisions, not independent remote tips. No duplicate Linux development commit is required. Preserve local work before any pull or submodule update.

## Executed validation and limits

The unchanged original header auditor passed on the three delivered headers. The unchanged original source-comment auditor passed on the sixteen delivered C/include-fragment files. Deliberately altered test copies with exactly the labels absent in the Windows log produced the three header findings and 38 source findings; the unaltered recovery files passed.

These were affected-file subset checks in the preparation environment, not access to the user's Windows filesystem, not a full repository audit, and not native Windows or Linux application builds. The separate evidence archive includes commands, return codes and the unchanged audit files used. No full-suite pass is claimed.
