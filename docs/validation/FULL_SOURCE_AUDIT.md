<!--
  Umicom Applications
  File: docs/validation/FULL_SOURCE_AUDIT.md

  PURPOSE:
    Record the repeatable source audit for the suite root, Framework and every
    application module. This is a review record, not generated build output.

  AUTHOR AND ORGANISATION:
  Sammy Hegab
  Umicom Foundation

  LICENCE:
  MIT
-->

# Full source audit

This record describes the audit of the copied worktree at
`C:/umicom/applications/umicom-applications-mb60`. The active checkout at
`C:/umicom/umicom-applications` was not changed.

The copied submodule directories contain their source trees but not a usable
`.git/modules` metadata store, so repository-level status and history must be
checked after the files are merged into the active checkout.

The audit is deliberately read-only. It inventories source ownership, public
contracts, CMake registration, application coverage, file naming, comments,
private-file patterns and obvious unsafe APIs. It does not claim that static
search can prove a program free of defects. A compiler, linker, test runner and
security tool are still required before release; those commands were not run
because the required local toolchain and libraries are unavailable in this
worktree.

## Inventory snapshot

The snapshot excludes `.git`, `build` and `tmp` directories:

| Area | Files |
| --- | ---: |
| Whole copied worktree | 22,767 |
| Framework | 20,557 |
| Application modules | 2,134 |
| Documentation | 51 |
| CMake extension files (`*.cmake`) | 114 |
| C implementations | 13,528 |
| C headers | 7,273 |
| JSON resources | 48 |
| SVG resources | 4 |

Every registered application has a `CMakeLists.txt` and `README.md`. The
application counts below include source, headers, tests, resources and module
documentation:

| Module | Files | Module | Files |
| --- | ---: | --- | ---: |
| accountant | 23 | bank | 31 |
| cad | 23 | creator | 22 |
| database-studio | 23 | desktop | 16 |
| education | 23 | exchange | 22 |
| games | 23 | integration-studio | 23 |
| kitchen | 23 | llm | 22 |
| marketplace | 23 | media | 23 |
| mobile-studio | 23 | music | 31 |
| operations | 23 | os | 14 |
| rag | 23 | security-centre | 23 |
| studio | 1,561 | tms | 29 |
| trader | 64 | web-studio | 23 |

The large Studio and Trader counts are expected: they contain the current
product workbenches, tests and adapter projections rather than only a thin
placeholder.

## Checks performed

1. **Ownership and graph:** the root CMake file configures Framework once;
   `.gitmodules` is the membership list for Framework and 24 application
   repositories; application CMake files consume exported `Umicom::*` targets.
   Production and journey sources are registered through bounded module lists in
   `UmicomApplicationProductionControlPlane.cmake` and
   `UmicomApplicationJourneyPlatform.cmake`; a text-only source-list check must
   follow those lists rather than treating their generated paths as unused.
2. **Incremental build surface:** the root exposes discovered product targets,
   grouped Framework/application/integration test targets and the optional
   living-documentation target. It does not require a developer to name every
   changed source file.
3. **Public-contract safety:** fixed-size catalogues and command surfaces now
   reject oversized counts and malformed borrowed arrays before indexing them.
   Lookup functions also refuse corrupted counts instead of walking beyond a
   fixed array.
4. **Path and request safety:** path normalisation no longer writes a segment
   pointer before checking the segment-array limit. Web request header lookups
   reject corrupted header counts. Authentication query parameters are built
   with bounded copies and checked arithmetic rather than `strcat`.
5. **Tool command safety:** CodeGuard external-tool command text quotes paths
   containing spaces and rejects shell metacharacters. The API remains a
   description of a command; a future runner must still use an argument-vector
   process API instead of a shell.
6. **Naming and private data:** CodeGuard source-name rules cover version,
   batch and semantic-version labels. The root ignore policy excludes build
   output, temporary evidence, local comparison archives and common secret
   files while retaining examples and source documentation.
7. **Documentation:** the existing source-comment, public-header,
   declaration-dependency, documentation-inventory and living-documentation
   checks are registered as explicit validation targets. Generated HTML belongs
   in the build directory and is not checked in.
8. **Resource ownership:** shared branding is Framework-owned under
   `framework/resources`; compatibility copies under `assets` and `win` are
   ignored generated staging files. Application modules own only their product
   resources.
9. **Intentional source mirrors:** `src/project/workspace_import.c` is retained
   as a compatibility mirror documented in `framework/CMakeLists.txt`; the
   canonical `workspace_import_plan.c` is compiled so public symbols are not
   defined twice. This is an intentional ownership decision, not a missing
   feature.
10. **Memory and string safety sweep:** production C sources were searched for
    unbounded string operations, fixed-buffer formatting, allocation sites and
    GTK reference release paths. The sweep is a triage aid rather than a proof
    of correctness; each finding was reviewed against its owning contract.

## Issues fixed in this batch

- `framework/src/application/experience.c` now bounds panel, layout and feature
  counts and checks nested identifiers before duplicate comparisons.
- `framework/src/application/runtime/command_surface.c` validates experience
  metadata before creating borrowed command descriptors and bounds corrupted
  command surfaces during lookup.
- `framework/src/application/runtime/session.c` now bounds active-panel counts,
  tolerates damaged borrowed IDs during lookup, revalidates a catalogue before
  selecting a layout and preserves detailed validation status codes.
- `framework/src/platform/path.c` checks the segment capacity before storing a
  pointer, removing an exact-limit out-of-bounds write.
- `framework/src/web/workbench/request.c` rejects malformed header counts in
  every public operation.
- `framework/src/web/workbench/auth_profile.c` validates the URL field without
  an unbounded read and appends encoded query data with explicit capacity
  checks.
- `framework/src/codeguard/external_tool.c` now provides quoted, metacharacter-
  checked paths; its regression test covers both spaces and injection text.
- The duplicate introductory banner in `framework/src/platform/directory.c`
  was consolidated into the more useful complete file description.
- The tracked `PHASE4_DELIVERY.txt` filename was moved to
  `docs/updates/OPERATIONAL_WORKBENCH_DELIVERY.txt` so durable documentation
  does not encode a delivery phase or version number in its filename.
- `framework/adapters/gtk4/workstation/panel_frame_gtk4.c` now has one
  interactive constructor, validates fixed text fields before GTK reads them,
  releases unparented widgets on allocation or signal-binding failure and keeps
  content attached through a vertical root box. This removes the
  duplicate-definition and stale-state errors reported by the Windows build
  log.
- `framework/tests/test_workbench_canvas.c` now registers fixtures through the
  public `windows` catalogue member rather than the removed `catalogue` field.
  `framework/tests/application_experience/test_portfolio_alignment.c` now
  invokes its universal contract assertion, removing the unused-function
  warning.
- `framework/include/umicom/reflection/macros.h` assigns string metadata
  directly instead of wrapping literals in parentheses, removing the strict C
  pedantic warning while keeping the macro API unchanged.
- `applications/studio/src/llm/studio_codestral_fim.c` uses a GLib length-aware
  string builder instead of repeated `strcat`, preventing prompt construction
  from overrunning its allocation when editor input is large.
- `framework/src/platform/process.c` and
  `framework/src/platform/process_supervisor.c` reject NULL entries in argv and
  environment arrays, check private-copy bounds and guard Windows environment
  size arithmetic against wraparound. Windows now fails a launch when an
  environment override block cannot be created instead of silently inheriting
  the wrong environment. Environment-name matching also checks the complete
  entry length before indexing the `name=` separator. Process results are now
  initialised before request validation, so capture callers cannot read stale
  output after a rejected request. A regression test covers sparse requests.
- `framework/src/platform/process_supervisor.c` now keeps request ownership and
  worker creation inside one reservation critical section. Failed copies or
  thread starts therefore cannot leave a ghost job consuming supervisor
  capacity, and overlong labels are reported instead of silently truncated.
- `framework/src/ai_developer_experience/approval_service.c` validates all
  bounded approval text and the caller output capacity before queue insertion,
  so a failed copy cannot leave an unidentifiable pending approval.
- `framework/src/ai_developer_experience/command_registry_bridge.c` now reports
  an oversized or unterminated approval argument instead of silently reusing
  stale context while enabling or executing a command.
- `framework/src/platform/path.c` avoids one-character and incomplete-drive
  out-of-bounds reads in absolute-path detection and checks copy lengths without
  adding to a potentially maximal `strlen` result. Short-input regressions were
  added to `framework/tests/test_path.c`.
- `framework/src/platform/document.c` now rejects unrepresentable file paths,
  checks document allocation arithmetic and refuses damaged length/pointer
  state before append operations.
- `framework/src/web/workbench/auth_profile.c` now validates base64 output
  sizing without `length + 2` wraparound and rejects missing output buffers
  before encoding.
- `framework/src/build/automation.c` shortens inherited provider names through
  the bounded summary helper, removing another format-truncation warning while
  retaining the full structured scope data.
- `framework/src/scaffold/repository.c` now checks template replacement
  arithmetic, rejects empty replacement tokens and unterminated template text,
  and copies the finished result only after proving its terminator fits.
- `framework/src/declarative/template_store.c` was expanded from a compressed
  implementation into readable, bounded ownership code. It now handles
  allocation failure, corrupted counts and missing stored source safely, and
  copies template text without an unchecked `strcpy`.
- `framework/src/declarative/types.c` now checks the destination limit before
  adding the copied terminator byte, so the shared declarative text helper
  cannot wrap its size comparison.
- `framework/src/declarative/parser.c` now checks token-line counts, token-join
  arithmetic and source-copy allocation size before indexing, allocating or
  appending a terminator.
- `framework/src/plugin/manifest.c` and `framework/src/toolchain/discovery.c`
  now guard PATH and manifest-copy allocation arithmetic and reject malformed
  list inputs before indexing fixed arrays.
- `framework/src/workbench_layout_data/chunk_store.c` and `backup.c` now guard
  chunk rounding, restore-buffer sizing, offset arithmetic and backup size
  accounting so corrupted persisted data cannot wrap a size or write outside
  its destination.
- `framework/src/ai_coding_tools/tools/checkpoint_create.c` now checks the
  normalised path length before copying it into checkpoint storage, making the
  ownership boundary explicit for future path-normaliser changes.
- `framework/src/platform/directory.c` now guards directory-name list growth
  and name allocation arithmetic against `size_t` wraparound, and copies names
  with their proven terminator rather than an unchecked `strcpy`.
- `framework/adapters/gtk4/workstation/shell_header_gtk4.c` no longer creates
  or shows a textual `<>` branding widget. Header and startup snapshots now
  report `icon_visible = 0` when the required SVG cannot be resolved, leaving
  the product name readable while packaging diagnostics identify the defect.
  ADR-0013 and the application-header validation record the same SVG-only rule.

## Remaining risks and next work

Static review found several areas that need tool-assisted follow-up rather than
speculative edits:

- The copied worktree contains many intentionally compact C files and generic
  comments. The comment audit checks the required header, but it cannot judge
  whether every explanation is useful to a reader.
- Some Studio UI, search, LLM and designer paths still advertise provider or
  dialog stubs. They should be completed as product vertical slices and given
  acceptance tests instead of being silently presented as production features.
- CMake configuration stages ignored compatibility assets into the source tree
  for the current Studio module. The long-term fix is to make Studio consume
  Framework resources directly and remove that compatibility staging step.
- The shared GTK4 header now follows the SVG-only identity decision, but a
  successful configure/build and packaged-resource smoke test is still needed
  in the developer's dependency-complete checkout to prove every branded
  target receives its `branding/` files.
- External analyzers, sanitizers, dependency review and a real Windows GTK4
  build remain outstanding because they require the developer's installed
  toolchain and libraries.
- Several legacy application presentation paths intentionally use
  `snprintf(..., "%s", ...)` without checking the return value. They are
  bounded writes, but the audit should continue converting them to a shared
  checked-copy helper where truncation would alter an identifier or command.
  The current pass did not rewrite every application-owned field blindly.
- Memory ownership for every GTK widget still needs runtime leak checking (for
  example, a GTK-aware heap profiler) because static reference counting review
  cannot observe signal closures and parent ownership during a live session.
- The document, process and authentication guards protect arithmetic and fixed
  records, but external sanitizers should still exercise very large files,
  malformed UTF-8 and concurrent supervisor submissions before release.
- Submodule commits are independent. A suite commit can pin a new submodule
  commit, but it cannot include that submodule's file changes; each repository
  must be reviewed and pushed separately.
- The application modules were inventoried and their CMake/readme contracts
  were checked in this pass, but no product-specific source was changed
  speculatively. Such changes belong in the corresponding application
  repository and must be committed there before the parent pin is updated.

## Repeating the audit

After configuring a suitable build directory, run the explicit targets below.
They do not alter source files:

```powershell
cmake --build --preset windows-ucrt64-headless-debug --target umicom-source-audit
cmake --build --preset windows-ucrt64-headless-debug --target umicom-product-governance
cmake --build --preset windows-ucrt64-headless-debug --target umicom-source-documentation-audit
```

The aggregate target runs whichever of these checks is available in the current
configuration. The product-governance target checks durable product and
application decisions. The documentation target uses the checked-in script to
report missing source explanations.
The native `umicom-codeguard` target additionally supports security,
architecture and CI profiles and can write JSON or SARIF reports.

Once the copied files have been compared and merged, the exact configure/build,
test and per-repository `git add -A`, commit and push sequence is documented in
[`BUILD_AND_REPOSITORY_HANDOFF.md`](BUILD_AND_REPOSITORY_HANDOFF.md).
