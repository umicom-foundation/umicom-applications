# Cross-platform Build Qualification

Owner: Umicom Foundation
Scope: Umicom Applications and its shared Framework test/build contracts
Status: Implemented source changes; focused Linux fixture evidence available;
full-suite Linux execution, Windows execution and remote CI execution pending.

## Problem and exact baseline

The reported Linux and Windows compiler commands for
`umicom-applications-validation-target-closure-test` omit the Framework include
path. The test includes `umicom/test_runtime/check.h`, but its CMake target does
not declare the public SDK dependency. The header is present in Framework.

Source baseline inspected on 9 September 2026:

- Applications: `2ce7e0a88661fc5f4fe8baad95f22003cd951b74`.
- Framework pin: `bb496d15541e7263fbfd3f0b59a293e90b370744`.
- `tests/CMakeLists.txt` blob: `4fc40584e9374cb906fd092594f2f3b2a368db75`.
- `CMakePresets.json` blob: `53750ae37be80823bab6d512966631dc4a5dbee6`.
- Existing `check.h` blob: `2a7771b3ab91f4ca0078620ad9e5a4a9b99143f3`.

The real fix is `target_link_libraries(... PRIVATE Umicom::base)` in the
application-suite test definition. The base target already publishes the public
SDK include directory. No header copy, global include path, compiler wrapper or
suppressed test is introduced.

## Ownership and decisions

Framework owns the reusable `umicom_assert_test_build_contract` CMake assertion
and its portable fixtures. Applications owns the product-composition binding,
platform presets, and CI selection. Individual product modules do not receive
copies. The Master Controller / Slave Controllers, Data Server authority,
existing UI features and application public ABI are unchanged.

This guard is opt-in and intentionally narrow. For an opted-in local executable
it checks that Framework is configured, the diagnostic header exists, and the
target explicitly links `Umicom::base` or the same underlying target. It resolves
CMake aliases. An unrelated transitive include path or a dependency wrapped only
in a generator expression is not accepted as this explicit contract.

The guard does not mutate a target to make the error disappear. It reports an
actionable configure failure. It does not scan every source file, evaluate every
CMake generator expression, certify an installed SDK, or prove that an entire
application will link. The compiler and executable tests retain those roles.

A future small test can adopt the same contract:

```cmake
include("${framework_root}/cmake/UmicomTestBuildContract.cmake")
add_executable(my-test test_example.c)
target_link_libraries(my-test PRIVATE Umicom::base)
umicom_assert_test_build_contract(my-test)
```

## Regression design

Thirteen Framework CTest cases exercise the actual existing diagnostic header:

- successful single-evaluation and conditional-statement use;
- the same behaviour with `NDEBUG` defined;
- deliberate failed checks return 1 and identify source/expression;
- valid alias and concrete dependency targets compile and run;
- missing dependency, header, SDK target and consumer target fail configuration;
- a non-executable consumer is rejected;
- bypassing the guard and omitting the dependency recreates the compiler error.

The fixture's standalone `Umicom::base` is explicitly an interface-only model
of the SDK usage requirement; it is not the production library. The integrated
suite consumes the real `Umicom::base`. The header remains unchanged, is never
copied into application code, and is excluded from this source delivery.

The native configure fixtures are omitted during cross-compilation rather than
being reported as target-runtime passes. No RISC-V or ARM qualification is
claimed. Multi-configuration builds use per-configuration fixture directories.

The suite adds `applications.build_presets`, a CMake JSON regression checking
all-module selection, testing, warnings, disabled graphical switches, compiler
choice, separate build directories and nonempty-test requirements.

## Qualification entry points

Existing presets are preserved, with no renamed build directory. The additions
are:

| Preset | Compiler | Scope |
|---|---|---|
| `linux-all-headless-debug` | Clang | All registered modules, no GTK4 |
| `linux-gcc-all-headless-debug` | GCC | Same scope, separate build tree |
| `windows-ucrt64-all-headless-debug` | UCRT64 GCC | Same scope on Windows |

Each new build/test preset defaults to two jobs. The new test presets fail when
no tests are discovered and display failing-test output. Existing preset
objects and their behaviour are retained unchanged.

`umicom-build-contract-tests` is a small build-only target. It depends on the
existing validation-target closure test, existing CMake graph closure test and
the two new diagnostic executables. It does not run CTest or relink all products.
The focused CTest selection includes 13 Framework cases, the preset case and the
two existing source-wiring tests. These are not full application tests.

## CI and application-family scope

The new `Build contracts` workflow uses Linux GCC, Linux Clang and Windows
UCRT64 GCC. It checks out the parent and its recorded submodule commits,
configures all registered headless modules, builds the focused closure, runs
its tests and retains diagnostics. Windows tool paths are overridden from the
actual MSYS2 action installation root, not assumed to be C:/msys64 on a runner.
It has read-only repository permission and does not commit or push code.

This configures application-family composition; it does NOT execute every
product workflow, build every product binary, or prove graphical layouts. Full
builds, complete CTest runs and graphical acceptance remain separate gates.
The workflow was authored and structurally checked, not run on GitHub here.

No changes are made to `umicomOS`, its older Framework pin, application modules,
the kernel, branding, themes, Workbench placement or saved layouts.

## Roadmap and acceptance sequence

1. Publish this fix and its prevention tests in Framework and Applications.
2. Complete the existing Linux all-module headless build and full CTest run.
3. Run the focused CI matrix, then the complete Windows build and tests.
4. Qualify Linux GTK4 product startup, resources, window lifetime and layouts.
5. Converge OS and Applications Framework pins through explicit integration tests.
6. Proceed to minimal OS image work with qualified Linux user-space components.

The universal-canvas and multi-monitor design remains unchanged. This delivery
is build reliability work, not completion of the GUI or OS-image roadmap.

## Sources

- [Applications test definitions](https://github.com/umicom-foundation/umicom-applications/blob/2ce7e0a88661fc5f4fe8baad95f22003cd951b74/tests/CMakeLists.txt).
- [Applications presets](https://github.com/umicom-foundation/umicom-applications/blob/2ce7e0a88661fc5f4fe8baad95f22003cd951b74/CMakePresets.json).
- [Framework public dependency](https://github.com/umicom-foundation/umicom-framework/blob/bb496d15541e7263fbfd3f0b59a293e90b370744/CMakeLists.txt).
- [Actual diagnostic header](https://github.com/umicom-foundation/umicom-framework/blob/bb496d15541e7263fbfd3f0b59a293e90b370744/include/umicom/test_runtime/check.h).
- [CMake target usage requirements](https://cmake.org/cmake/help/latest/command/target_link_libraries.html).
- [CMake presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html).
- [MSYS2 GitHub Action](https://github.com/msys2/setup-msys2).
