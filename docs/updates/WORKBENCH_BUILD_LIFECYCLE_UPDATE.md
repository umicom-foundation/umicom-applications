# Workbench and build lifecycle update

**Recorded:** 5 September 2026  
**Scope:** Umicom Framework and the shared Studio build services

This update makes two parts of the product estate safer to compose: a native
application window can register and unregister its Framework Workbench Canvas,
and Studio can discover the build output that belongs to the workspace the user
opened.

## Canvas lifecycle

`UmiUiWorkbenchCanvas` remains a toolkit-neutral registry. It does not own GTK
widgets or the customisation object supplied by an application. The new
`umi_ui_workbench_canvas_remove_host()` operation removes one host, clears its
slot, repairs the active-host index and advances one canvas revision. A caller's
`UmiUiWorkspaceCustomisation` value is never freed.

The shared GTK4 suite workstation now stores the generated `<application>.host`
identity and unregisters it before destroying its layout host. This means a
closed Studio, Trader, Bank, TMS or Music workstation cannot leave a route to a
released customisation value.

Canvas edits synchronise surface records while the edit baseline is available.
The coordinator also snapshots detached-surface metadata for the transaction.
If synchronisation or layout validation fails, the edit is cancelled and that
metadata is restored. A rejected operation therefore does not leave a half-open
edit or a detached-monitor record that no longer matches the layout.

The coordinator test now covers two hosts, active-host repair and unknown-host
no-op behaviour in addition to the existing blank-layout, move, resize, snap,
detach, attach and clear journeys.

## Studio build discovery

Studio's build detector now uses the selected project root for every marker
lookup. It prefers existing generated directories in this order:

```text
build/windows-ucrt64-debug
build/windows-ucrt64-headless-debug
build/windows-ucrt64-all-debug
build/headless-debug
build/debug
build/release
build
```

When a `CMakeCache.txt` file contains an explicit
`CMAKE_HOME_DIRECTORY:INTERNAL` value, the detector compares its canonical
path with the selected workspace. A cache belonging to another checkout is
ignored. If no usable cache exists, the detector chooses a matching build
preset from `CMakePresets.json`; `UMICOM_CMAKE_BUILD_PRESET` can select one
explicitly.

The resulting command text is parsed into an argument vector and passed to the
existing `UmiBuildRunner`. Studio Build, Run and Test therefore execute with an
explicit working directory and no shell interpolation. The runner now releases
its pipe references and owns callback-created sinks only when ownership was
explicitly transferred. The synchronous Run pipeline releases its concrete sink
after both output readers have joined and unwinds cleanly when sink allocation
fails. Suite-layout configuration now fails early when the canonical UI target
is absent, instead of allowing the Canvas bridge to become a late linker error.

## Deliberate boundaries

No compiler, CMake configure, test runner or GUI executable was launched while
preparing this copied worktree because its native dependencies are not
available here and the user's active checkout is reserved for comparison.
The graphical Canvas renderer still needs explicit support for the `canvas`
placement token, pointer gesture dispatch, monitor enumeration and persistence
integration. The generated workspace template still has a fixed configure and
install wrapper and should later consume the same Framework build-profile
provider.
