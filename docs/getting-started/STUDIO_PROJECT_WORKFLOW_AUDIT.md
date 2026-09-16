# Umicom Studio — project workflow investigation

Prepared 16 September 2026 from Sammy’s uploaded Applications archive.

## What this update establishes

The uploaded source contains substantial IDE infrastructure. It already has a Framework project generator, a document coordinator, a command registry, build providers, a background project-build session, diagnostic storage, a GTK editor adapter and a lesson catalogue. The immediate problem is not the absence of all these services. Several important routes between them are missing or inconsistent.

This update connects and tests the source-level workflow from project generation to installation. The Linux headless Applications build and its registered suite pass. The new GTK routes, dialogs and Notes window are provided as a **native qualification candidate**: they have not been compiled or executed here because GTK development dependencies are unavailable. This is not a declaration that every Studio feature is now finished.

The baseline is the uploaded `.umicom.zip`, SHA-256 `130ca7b8b8328c5d28f792d5a6015c5ad197807cff7e46ed1ed0b987fc7f3aaf`. The extraction retained 23,052 source files and omitted 25 Git pointer files. No source checkout was updated from a remote during this investigation, and no remote commit, push or release was made. Per-file before/after hashes are in the changed-file manifest.

## Findings and corrections

| Area | What the supplied source does | Change in this update |
|---|---|---|
| New Project | Framework has generation templates and a wizard model. Studio’s runtime router has no native New Project form that completes generation and adopts the resulting project. | Add a shared Framework GTK form over the existing generator. Studio only coordinates the accepted project with its workspace, profile and editor. A headless integration test exercises the same generation API. |
| Disabled commands | `runtime_command_enabled` consults generic host command state before some native and mapped service routes, while execution follows a different registry path. Menu flags also affect enabled state. | Evaluate native entry points and canonical mapped commands consistently; do not use descriptive flags as permission to enable a command. Refresh nested controls after state changes. This is not a blanket “enable everything” change. |
| Workspace build selection | Studio’s build service starts with a development profile that can launch Studio itself. Opening another workspace does not reliably adopt that workspace’s build profile. | Framework constructs a profile from the selected workspace or generated model. Imported folders have no guessed Run executable. Build Settings lets the user specify it. |
| Synchronous builds | GUI commands can call the synchronous build phase handler even though Framework already contains a background project session. | Reuse that existing session. GUI build requests submit background work; results and diagnostics are collected on the owning thread. Keep the synchronous command path for existing headless consumers. |
| Compile before Run/Test/Install | A standalone phase can use stale output or omit prerequisite work. | The background workflow runs Configure, then Build, then the requested Run/Test/Install phase. A failed prerequisite prevents subsequent phases. |
| Unsaved editor tabs | Save All routes through the older service facade rather than synchronising all editor working copies through the conflict-aware coordinator. | Add `UmiDocumentCoordinatorSaveAll`: synchronise drafts, check unnamed dirty documents, use the existing safe saver, preserve active selection and report failures. GUI builds use this route before submitting work. |
| Welcome page | Initial text in a pristine virtual Welcome document can be interpreted as an unsaved file, blocking Save All. | Track the untouched virtual document separately. Once edited, it needs the ordinary Save As treatment; changes are not silently discarded. |
| Build history | Multiple execution paths can assign overlapping operation identifiers. | Reserve monotonically increasing identifiers from the shared history owner under its mutex. History clearing does not recycle earlier identifiers. |
| Input boundaries | Some fixed-size generation, model and profile fields reach string operations without a bounded termination check. Template values can introduce C/CMake/YAML syntax. | Check field boundaries first and reject unsupported interpolation characters. Keep the original generated-file model and templates. |
| CMake/CTest commands | Some build/configuration paths depend on the host working directory, and an empty CTest run can look successful. | Resolve project paths without changing the host working directory; propagate configuration where applicable; require at least one CTest test. |
| CTest suite lifetime | The Studio registry borrows a suite. Studio does not release its owned suite on shutdown, and replacement discovery can lose the previous allocation. | Make ownership explicit. Build a replacement, install it only on success, and destroy the displaced or failed suite appropriately. Repeated discovery is covered by the sanitizer workflow. |
| Source-comment audit | A colon in indented Purpose prose can be interpreted as a new unknown field, producing false missing-Purpose findings. | Correct the parser’s indentation handling and add positive fixtures. Retain the existing negative unknown-heading checks. Do not rewrite dozens of valid source comments to satisfy the bug. |
| Parallel Studio tests | Older tests using the shared default working directory can race while removing `.umicom`. | Apply a CTest resource lock to Studio tests sharing that directory. Tests with an explicitly isolated working directory remain independently runnable. |
| Installation | A CMake install rule names `resources/testing/execution-profiles.json`, which is absent from the supplied tree and has no corresponding reader. | Remove the dangling install declaration and explain the missing configuration implementation in the CMake source. Do not invent an unused JSON file. |
| Training money arithmetic | Existing shared signed money addition/subtraction can overflow. | Check integer bounds and currency identity before arithmetic; preserve the output on rejection. The account lesson uses these actual Framework operations. |

## Follow the implementation

The paths below are relative to the Applications root. The manifest carries the exact bytes supplied in this delivery.

### Shared project and build services

- `framework/include/umicom/developer_project/new_project.h` and `framework/src/developer_project/new_project.c`: fresh-project entry point, delegating to the existing generator.
- `framework/include/umicom/build/project_profile.h` and `framework/src/build/project_profile.c`: workspace/model to build-profile translation.
- `framework/src/build/project_session.c`: existing worker session, prerequisite sequencing and cancellation.
- `framework/src/build/runner.c`, `cmake_provider.c`, `ctest_provider.c`, `profile.c`, `history.c`: execution paths, configuration, validation and identity.
- `framework/src/developer_project/generation_request.c`, `generation_plan.c`, `model.c`, `service.c`: bounded generation and model data, platform-specific generated profile.
- Fourteen CMake-backed template implementations retain their existing identities and add Linux presets. The complete built-in template catalogue remains in place.

### Documents and Studio coordination

- `framework/src/document/coordinator.c`: working-copy synchronisation and safe Save All.
- `applications/studio/src/app/build.c`: thin asynchronous facade over the Framework build session.
- `applications/studio/src/app/services.c`: workspace/profile adoption and busy-state checks.
- `applications/studio/src/app/commands.c`: existing command handlers, trust checks and background dispatch.
- `applications/studio/src/app/ui.c`: owner-thread result/diagnostic collection.
- `applications/studio/src/app/tests.c`: ownership of discovered CTest suites.

### Native presentation — awaiting compilation and execution

- `framework/adapters/gtk4/developer_dialog_gtk4.c`: shared New Project and Build Settings forms.
- `framework/include/umicom/ui/gtk4/developer_dialog.h`: dialog lifecycle contract.
- `applications/studio/src/gui/workbench/runtime/interaction/project.inc`: product-specific accepted-project coordination.
- The existing runtime helper/router/menu/refresh/output/build fragments are extended rather than replaced by another workbench.
- Canonical `studio.build.*` commands from the palette and context routes also request background work and Save All, not just the main-menu aliases.
- Output currently shows retained results for completed phases. This change does **not** provide a new live terminal-streaming implementation.

## What the end-to-end test actually proves

`applications/studio/tests/test_project_workflow.c` links the real Studio services and Framework libraries. In a disposable directory with spaces in its path, it generates a project, rejects a repeated creation request, bootstraps Studio services, opens the workspace, checks trust behaviour, edits a Framework editor working copy, saves it, builds and runs the generated program, runs CTest, repeats test discovery, and installs the executable. It then introduces a compiler error and confirms that the workflow does not proceed to Run with an old executable.

`framework/tests/developer_project/test_project_session.c` separately uses an injected test executor to make ordering, cancellation and failure deterministic. That controlled executor test is not presented as a real compiler test; the Studio integration test supplies the real compiler/process coverage.

`test_save_all.c` checks multiple documents, unnamed-document preflight, active-view preservation and external-file conflicts. `test_history_identity.c`, `test_project_input_boundaries.c` and `test_money_boundaries.c` cover their corresponding contracts.

## Practical learning material

Eleven new catalogue lessons follow an application journey: a Notes activity report; training account totals; binary display flags; note-memory ownership; conflict-aware saving; named commands; Model/View/Controller; a window and split panels; menus and feedback; project generation and background builds; and testing, installation and publication.

The new course begins at `framework/docs/learning/application-development.html`. Its source examples live in `framework/examples/learning/projects`. The Notes model uses Framework’s actual document store, workbench, coordinator and command registry. The graphical version shares that model rather than implementing a second document saver. The banking example uses training data and the existing `UmiMoney` contract; it does not connect to a bank.

The original 53 catalogue records remain byte-for-byte present, in the same order. Appending eleven brings the catalogue to 64. The original programming lessons remain available for deeper practice. The course index maps further work in algorithms, memory, design patterns, Assembly, concurrency, persistence, networking, security and richer GUI controls. This delivery does not claim to have completed that entire curriculum.

## Remaining work, in priority order

| Priority | Next qualification or implementation | Completion evidence |
|---|---|---|
| 1 | Compile Framework’s GTK adapter and the complete Studio executable on Windows UCRT64; fix any native build defects. | Successful native build log and focused tests, including the new GTK dialog test. |
| 1 | Click through New Project, New File, Save/Save As/Save All, Build Settings and explicit workspace trust. | Source file on disk matches the editor; correct workspace/profile is used; cancelled dialogs have no unintended effects. |
| 1 | Verify background configure/build/run/test/install, cancellation, UI responsiveness and close-during-work. | Responsive window, correct Output/Problems, safe teardown, no stale executable launched after failure. |
| 1 | Qualify installed Studio and the Notes window, not only build-tree copies. | Fresh-prefix test and documented runtime dependencies. |
| 2 | Persist/reload per-project settings and trust through existing authorised storage contracts. | Close/reopen and different-machine tests; no accidental automatic trust. Current form changes are session settings. |
| 2 | Complete and qualify live output streaming, richer diagnostics navigation, multi-target/multi-project selection and interactive console input. | End-to-end acceptance tests on both operating systems. |
| 2 | Review every remaining menu command with actual user scenarios. | An action performs its stated operation or explains precisely why it is unavailable. Generic registry presence alone is not completion evidence. |
| 3 | Qualify LSP completion/navigation, debugging, designer round trips, advanced widgets and extension lifecycle. | Real tool-backed and native UI tests, not source-string inventory checks alone. Existing implementations are retained. |
| 3 | Extend the same Notes/banking training projects into Data Server persistence, authenticated services, advanced patterns and profiling. | Runnable lesson source, regression tests and a progressive teaching sequence. |

## Boundaries that must remain visible

Fresh project creation refuses an already existing destination and does not deliberately overwrite user files. The underlying generator is not an atomic, race-proof filesystem transaction. An I/O failure may leave part of a newly created project; review that directory rather than repeatedly applying the command blindly.

Save All uses the existing per-document safe saver. It is not a multi-file transaction: a later file can fail after earlier files have saved, and the result reports that failure.

Workspace trust is not silently granted by opening a folder. Build Settings requires an explicit user choice. This batch does not weaken payment, live-order or broker authentication controls.

GTK, Windows, a clean-machine graphical deployment and all advanced IDE functions remain outside the completed qualification. See the validation report for the precise executed configurations and retained failure logs.
