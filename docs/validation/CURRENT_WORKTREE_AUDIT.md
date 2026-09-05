**Audit date:** 5 September 2026

## Architecture understood

The Framework is the owner of shared application identity, workspace layout
customisation, panel/window catalogues, session state and the portable Workbench
Canvas model. Thin applications provide product experiences and product-specific
surfaces. GTK4 adapters translate those contracts into native widgets; they are
not a second layout authority.

The common GTK4 suite workstation is the correct integration point for Trader,
Bank, TMS and the other suite-based products. Studio has a separate, older
GTK workbench translation unit and a separate professional-workspace model. It
must be connected through an explicit `UmiStudioUi` contract before it can
safely share the Canvas registry; this batch deliberately does not duplicate or
silently replace that model.

## Corrections made in this worktree

- Moved application-aware Canvas host loading into
  `framework/src/application/suite_layout/workbench_canvas_application_host.c`.
  The lower-level UI archive now owns Canvas mechanics without calling back into
  the application archive, removing a static-library dependency cycle.
- Registered that bridge in
  `framework/cmake/UmicomApplicationSuiteLayoutPlatform.cmake`.
- Hardened Canvas grid rounding, detached-monitor validation, placement input,
  fixed-capacity bounds and revision publication in
  `framework/src/ui/workbench_canvas.c`.
- Added explicit Canvas host removal with active-host repair for native-window
  shutdown, plus a two-host regression fixture.
- Wired the shared GTK4 suite workstation to retain its generated Canvas host
  key and unregister that host before destroying its layout widgets, preventing
  a borrowed customisation pointer from surviving a window close.
- Made Canvas edit publication validate surface state before committing; a
  rejected commit now cancels and re-synchronises instead of leaving an edit
  session or detached record half-applied.
- Extended `framework/tests/test_workbench_canvas.c` with an oversized-monitor
  regression case and application-experience host coverage.
- Corrected Studio build-system discovery so it examines the selected project
  root, not the IDE process directory, in
  `applications/studio/src/build/build_system.c`.
- Extended that discovery to reuse an existing nested CMake preset output such
  as `build/windows-ucrt64-debug`, instead of silently falling back to a
  different `build` cache.
- Added a CMake-cache origin check and preset fallback so a copied build tree
  whose `CMAKE_HOME_DIRECTORY` points to another checkout is not reused.
- Replaced the Studio build-task probe and Run/Test no-ops with calls to the
  existing shell-free `UmiBuildRunner`, using the detected workspace commands
  in `applications/studio/src/build/build_tasks.c`.
- Fixed silent-build pipe-reference cleanup and callback-created sink ownership
  in `applications/studio/src/build/build_runner.c`.
- Released the concrete diagnostic sink after the synchronous Studio run
  pipeline finishes, preventing one callback context from leaking per run.
- Added an allocation-failure unwind in that pipeline so a failed sink
  allocation cannot leave a stale “process running” context behind.

## Known remaining work

- No compiler, CMake configure, test runner or GUI executable was launched in
  this batch because the requested worktree does not have the required runtime
  libraries available and the active worktree is reserved for comparison.
- Canvas gesture dispatch, internal-window rendering, native monitor transfer
  and graphical Studio registration still need adapter work.
- Studio still contains clearly marked placeholder surfaces and provider stubs
  (LLM providers, search/demo panels and some legacy editor actions). They were
  catalogued during the audit but not replaced speculatively without their
  public contracts and runtime ownership being settled.
- The generated workspace `umicom` template still contains a deliberately
  simple command wrapper with fixed `windows-debug` configure/install paths.
  It should be migrated to the shared Framework build-profile provider before
  it is presented as the full automated build front end.
- The copied root contains pre-existing uncommitted documentation and build
  graph changes. They were preserved; no reset, cleanup or deletion was done.
