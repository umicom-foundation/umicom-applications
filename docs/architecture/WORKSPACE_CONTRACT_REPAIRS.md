# Workspace contract repairs

## Scope and source baseline

This correction set addresses the documented public-header audit, source-banner audit,
Studio command-inventory mismatch, designer inspector expectation, and native-window
source-check drift. It is not a replacement layout engine or a completed graphical
application release.

The source files were read from these immutable remote revisions:

| Repository | Revision |
| --- | --- |
| Applications parent | `d7fb3987701c5638e48703a0462087696ee964e5` |
| Framework | `9c4a09e38fad58e7dd26ecaae52f414fbd845feb` |
| Studio | `b783beee4232654f584de3eb5f14072f9fa073d5` |
| Desktop | `7938bf2f348a80b9ecfaa205b6e3f9bae4ff107d` |

Original complete-file bytes were verified against GitHub's Git blob identifiers
before editing. Compare rather than overwrite when a local file has other changes.

## Corrections

### Public headers and source documentation

Three public headers use `AUTHOR:` instead of the required `AUTHOR AND ORGANISATION:`.
Seventeen C or include-fragment files have 41 missing required-label findings.
Their existing purpose, attribution and MIT licence are retained; only the labels in
the leading file banner are corrected. Code after each banner is unchanged.

The public-header and source-comment audit implementations are not changed,
relaxed, disabled or excluded. All three header findings and all 41 source-banner
findings were reproduced with the original auditors on the recovered affected files,
then eliminated on the corrected files. This was a scoped audit, not an independent
rescan of every file in every repository.

### Studio command inventory

`UMI_STUDIO_COMMAND_WORKSPACE_OPEN_FOLDER` already exists in the public workbench
command contract. The production `WORKBENCH_COMMAND_IDS` inventory omitted it.
The inventory now includes the existing identifier. A compile-time assertion compares
its actual length with `UMI_STUDIO_WORKBENCH_COMMAND_COUNT`, which remains 26.
The existing runtime test and command identifiers remain unchanged.

The public count is not lowered to match an incomplete implementation. The change
repairs the Studio composition declaration; it does not create another command bus.

### Designer inspector

Palette insertion assigns geometry properties as well as subsequent edited properties.
The previous test incorrectly required exactly two attributes and inspected a numeric
array slot as if it were always the boolean property.

The corrected test resolves `title`, `visible`, `x`, `y`, `width` and `height` by name,
checks their types and values, rejects duplicate requested properties, preserves the
original invalid-boolean test, and checks that geometry survives the property edits.
It retains the original live-source success and invalid-source preview checks.
Assertions remain enabled in Release builds. No designer properties or production
behaviours are removed to satisfy the test.

### Native-window source checks

The test follows the current shared owner rather than requiring obsolete Studio-local
helpers. Studio supplies its centre/editor stack; Framework supplies edge tools,
scrollable notebook tabs, shrinkable populated-region splitters and canvas geometry.
Identity is checked for the separate main and startup windows rather than enforcing
one textual identity call in a whole source file.

Startup cleanup is checked through the existing window-release helper. The source
checks retain ordering requirements for idle cancellation, observer removal, window
release, controller disposal and application release. Successful startup and failed
startup preserve their separate existing paths.

The preset check resolves in-file inheritance with child overrides, first-parent
precedence, explicit null values, boolean values, cycle detection and missing-parent
errors. Seven new regression methods protect that resolver. It is deliberately not
an implementation of every CMake macro or included-preset-file rule. A future preset
include requires extending this audit, not silently ignoring imported settings.

These remain source-wiring checks. They cannot establish rendered geometry,
accessibility, native focus, docking, multi-monitor placement or real GTK lifetimes.
Native integration tests and interactive acceptance remain required.

## Resource-broker failure is not closed

The current Framework test already expects `development`. The latest supplied summary
still lists `framework.application_resource_broker` as aborted, but does not show its
current failed assertion. It would be unsupported to infer another broker defect, or
change a lease/permission rule to force a pass.

The earlier parent-only pull fetched Framework objects but did not demonstrate that
Framework's working tree was updated. An older Framework checkout or test binary is
one possibility, not a confirmed diagnosis. Check the parent gitlink, checked-out
Framework revision and focused verbose test output using the companion procedure.
Do not regard this correction set as proof that all six tests pass.

## Architectural decisions preserved

Framework remains the sole owner of reusable controllers, layouts, panel placement,
resource policy and native workbench components. The Master Controller / Slave
Controller terminology and existing public ABI are retained. Studio and Desktop
consume the shared implementation; no alternative docking engine is introduced.
A test must validate the intended current contract, not require an obsolete code
location or re-create an application-local implementation.

## Validation actually performed during preparation

| Check | Before | After |
| --- | --- | --- |
| Original public-header auditor, three affected headers | Three findings reproduced | Passed |
| Original source-comment auditor, 19 recovered implementation files including the 17 offending files | 41 findings reproduced | Passed |
| Four selected native-source/preset methods against the complete, Git-verified product-runner and preset files | 21 failed subchecks and two errors | Four methods passed |
| Preset inheritance unit methods | New coverage | Seven passed |
| Isolated production-inventory harness using the actual public macros and extracted inventory, GCC and Clang | Both executables rejected the 25-entry inventory | Both accepted 26 unique entries including Open Folder |
| Remove Open Folder from the corrected inventory | Deliberate mutation | Both compilers rejected the compile-time assertion |
| Remove idle cancellation, weak-observer removal, startup guard; reorder splash disposal | Four deliberate source mutations | All four rejected by the corrected checks |

Native Windows execution, the fully linked Studio tests, the whole native source-check
suite and the full Linux application build were not executed in this preparation
environment. The archive is a reviewable source correction set, not a validated binary
release. Windows and Linux qualification must still be performed in the working
checkouts.

## Roadmap and release gates

1. Complete Windows build and the six focused regressions. Diagnose any remaining
   resource-broker assertion without weakening capability or lease checks.
2. Run the complete Windows suite; review warnings and any skipped tests separately.
3. Publish the changed Framework, Studio and Desktop revisions, then the parent pin.
4. Update the existing Linux checkout to those same pins and qualify its full build.
5. Continue actual GTK canvas, panel retention, close/restore, layout persistence and
   multi-monitor acceptance before adding further layout features.
6. Align the separate OS project only after a qualified application baseline exists.
   This update does not change Umicom OS or its dependency selection.

## References

Source paths and immutable Git blobs are recorded in the external delivery manifest.
CMake preset inheritance semantics: https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html
Git recorded-submodule checkout semantics: https://git-scm.com/docs/git-submodule
CTest selection and diagnostics: https://cmake.org/cmake/help/latest/manual/ctest.1.html
