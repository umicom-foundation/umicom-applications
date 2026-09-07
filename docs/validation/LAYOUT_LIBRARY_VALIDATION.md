<!--
Umicom Applications
File: docs/validation/LAYOUT_LIBRARY_VALIDATION.md
Author: Sammy Hegab, Umicom Foundation
Licence: MIT
-->

# Layout Library validation

Status: source implementation and regression coverage added. Compilation and
native execution have not been performed for this update.

## What is available

Open **Layout Library** in Studio's layout bar, or beside the layout selector
in a shared suite workstation. Trader, Bank, TMS, Music and the shared product
previews use that Framework workstation. Desk still has a separate renderer;
this update does not claim that its named-layout manager has been replaced.

The library can search, select, open, duplicate, rename and remove layouts.
The selected name and full layout ID appear above the input fields. Duplicate
requires a unique full ID in the same application namespace. For example, use
`umicom.studio.layout.review-copy` for a Studio copy. For another product, keep
the prefix shown by its selected layout and change the final name.

Duplicate opens the new copy. Rename keeps the active selection. Removing an
inactive layout leaves the active layout unchanged. Removing the active layout
opens the first remaining layout. The final layout cannot be removed. Confirm
removal using the checkbox; the confirmation resets when the records change.

Finish or cancel Edit Layout before changing the library. A request from an
older revision is rejected. Use Refresh, check the selected record, and submit
again. Search and input drafts are retained during refresh. Changing a library
name must not discard a panel's unsaved text.

Naming, opening and removing layouts change the current session. They do not
write to storage until you select **Save library**. That command stores every
named layout, its order and the active selection as one complete checkpoint.
All layouts must be committed and locked first. **Save layout** remains a
separate command that stores only the active arrangement.

**Restore library** requires its own confirmation checkbox. It replaces the
session's entire named list, including unsaved names and arrangements. It does
not delete source files. The restored list is an exact saved snapshot, not a
merge that brings back previously removed defaults. Restoration is explicit,
including after application restart; the library is not automatically loaded
over the current session.

Both commands use the already connected Data Server. The status distinguishes
disk storage from memory-only storage, which cannot survive process exit. If
another window changes the saved revision, a stale Save is refused. Restore and
review the saved library before saving again. If a read fails or finds no saved
library, current layouts remain in memory. A confirmed Restore can retry the
read. A recoverable damaged payload uses the previous valid copy and reports
that recovery; damaged metadata may still require separate repair.

Framework validates every saved layout against the current product, available
tools and permitted context groups. Missing tools or groups reject the complete
candidate. This archive does not install providers or store context definitions,
source documents, appearance settings or full application sessions. Its payload
limit is 450 KiB. Exceeding it fails without dropping layouts or overwriting a
previous save. Document/session recovery and schema migration remain on the
roadmap. Deleting a session layout does not modify the independent active-layout
checkpoint.

## Build the regression executables first

Merge into `C:\umicom\umicom-applications` first. Do not copy the working area's
build directory. Run the whole block below in PowerShell. Its guards stop the
block before CTest when configuration or compilation fails.

```powershell
& {
    Set-Location "C:\umicom\umicom-applications"
    $env:Path = "C:\msys64\ucrt64\bin;$env:Path"
    & "C:\msys64\ucrt64\bin\cmake.exe" --preset windows-ucrt64-all-debug
    if ($LASTEXITCODE -ne 0) { throw "Configuration failed" }
    & "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --target umicom-native-workbench-regression-tests --parallel 2
    if ($LASTEXITCODE -ne 0) { throw "Regression build failed; tests were not run" }
    & "C:\msys64\ucrt64\bin\ctest.exe" --test-dir "C:\umicom\umicom-applications\build\windows-ucrt64-all-debug" -R "^(framework\.application_manifest|applications\.native_manifest|framework\.workspace_library|framework\.ui\.(workspace-checkpoint|workspace_library_checkpoint)|framework\.ui_workstation\.(maximize\.mode|workspace\.(maximise|canvas|content|checkpoint)\.gtk4|suite\.navigation\.gtk4|command\.bar\.lifetime\.gtk4|desk\.home\.gtk4|layout\.library\.gtk4)|desktop\.window\.titlebar\.gtk4|studio\.workspace\.canvas\.gtk4|framework\.application\.native_discovery|framework\.platform\.executable_path|applications\.validation_target_closure)$" --no-tests=error --output-on-failure
    if ($LASTEXITCODE -ne 0) { throw "Regression tests failed" }
}
```

This target deliberately excludes the graphical product executables. A build
message is not a passing test result. Headless configurations explicitly report
omitted native tests. GTK fixtures return skip code 77 if no display is available;
a skipped test is not a verified graphical journey.

## Rebuild and inspect the applications

Save your work and close the Umicom applications that will be rebuilt. Windows
can refuse to replace a running executable. If linking still reports Permission
denied after closing it, inspect the file permissions and security-software
notifications. Do not delete source files or terminate processes blindly.

```powershell
& {
    Set-Location "C:\umicom\umicom-applications"
    $env:Path = "C:\msys64\ucrt64\bin;$env:Path"
    & "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --target umicom-desktop-products umicom --parallel 2
    if ($LASTEXITCODE -ne 0) { throw "Application build failed" }
}
```

Start the application you want to inspect:

```powershell
& "C:\umicom\umicom-applications\build\windows-ucrt64-all-debug\bin\umicom-studio-ide.exe"
& "C:\umicom\umicom-applications\build\windows-ucrt64-all-debug\bin\umicom-trader.exe"
& "C:\umicom\umicom-applications\build\windows-ucrt64-all-debug\bin\umicom-bank.exe"
```

Check these behaviours in each interface:

1. Search and select a layout; verify its full ID before changing it.
2. Rename the active layout while a panel contains unsaved text. The text stays.
3. Duplicate using a new full ID. The copy opens and the old layout remains.
4. Attempt a duplicate with an existing ID. No existing layout is overwritten.
5. Remove the copy with confirmation. Another layout remains available.
6. Start Edit Layout. Library changes are unavailable until Apply or Cancel.
7. Close a window with a queued library action. It must not act on a released
   workspace or open an unexpected application window.
8. Confirm that the official icon remains in the main titlebar and that normal
   panel maximise remains in the panel menu while the layout is locked.
9. Save a library containing a renamed copy and a blank layout. Change the list
   again without saving, then confirm Restore library. Check that the saved
   names, order and active layout return. Check that unsaved editor text stays.
10. With disk-backed storage, close and reopen the application. Open Layout
    Library and explicitly Restore. Check the whole saved list, not just the
    active arrangement. Repeat with memory-only storage and confirm that no
    restart recovery is promised.
11. Using an isolated test workspace, save in one window and then try a stale
    save from another. The newer saved copy must not be overwritten. Restore
    and review it before trying another save.

The focused aggregate includes 19 registered tests in the all-products GTK4
configuration. New source coverage checks ordered archives, stale revisions,
invalid records, context policy, previous-copy recovery, transaction capacity,
the canonical product catalogue and the actual Suite and Studio buttons. These
fixtures have not been compiled or run for this update. Source registration is
not a passing test result.

## Evidence to retain locally

Keep the exact command, compiler result, CTest summary and manual observations
outside the public repository. Distinguish assertion failures from Not Run
results caused by missing executables. If product linking fails, fix that build
failure before treating older application binaries as the current interface.
