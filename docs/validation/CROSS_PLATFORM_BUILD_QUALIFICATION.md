# Cross-platform Build Qualification Evidence

Date: 9 September 2026
Status: Focused local Linux regression evidence; full-suite and Windows gates pending.

## Source provenance

Applications baseline: `2ce7e0a88661fc5f4fe8baad95f22003cd951b74`.
Framework baseline: `bb496d15541e7263fbfd3f0b59a293e90b370744`.

The two modified existing files are the Applications root `CMakePresets.json`
and `tests/CMakeLists.txt`. Their complete original bytes were verified against
the Git blob IDs reported by the connected repository reader. All existing
preset objects and CMake declarations were preserved; the dependency fix and
new qualification registration are additive. New Framework files implement one
reusable guard and its tests. No production C library, public header or product
UI is replaced. The real `check.h` is unchanged and excluded from the update.

Direct Git cloning from this container failed because github.com did not resolve.
Selected source files were retrieved through the connected GitHub reader. This
is NOT a complete repository checkout or an all-source audit.

## Executed focused checks

The standalone Framework test project uses the real public diagnostic header.
Its interface-only base fixture models include propagation; it does not build
the production base library. The same test project links the actual
`Umicom::base` when integrated by the Applications root.

| Configuration executed locally | Result |
|---|---|
| GCC 14.2.0, Ninja, Debug | 13/13 CTest cases passed |
| Clang 17.0.0, Ninja, Debug | 13/13 CTest cases passed |
| GCC 14.2.0, Ninja, Release | 13/13 CTest cases passed |
| Clang 17.0.0, Ninja Multi-Config, Release | 13/13 CTest cases passed |
| Suite preset JSON semantics regression | Passed |
| Actual CMake preset discovery | Passed on Linux |

These are repeated configurations of 13 cases, not 52 distinct application
features. The cases include expected configure/compile failures; a negative
case passes only when its required diagnostic is observed. Normal and NDEBUG
consumers execute the real header code. No assertions are disabled to pass tests.

A fresh extraction of the final archive is checked separately during packaging;
its exact result is in the machine-readable delivery record. Per-file original
and updated hashes, non-whitespace diff counts and changed implementation areas
are in the external manifest. The evidence archive contains actual command logs,
fixture outputs and the tool versions used. It does not contain invented Windows
results or reuse earlier unrelated validation logs.

## Not executed / not established

- Complete Applications configure/build/CTest against all real submodule sources.
- The existing source-wiring regression executable against a complete checkout.
- Native Windows GCC/UCRT64 compile, link, CTest or application startup.
- GitHub Actions jobs; the authored workflow still needs a real remote run.
- GTK4 display, layout, brand-resource or application lifecycle acceptance.
- macOS, ARM, RISC-V or an Umicom OS boot/image test.
- Comprehensive audit of every header dependency in every repository target.

The direct target dependency corrects the reported platform-neutral CMake
omission. Only the above executed checks should be cited as passing. The focused
suite target and CI jobs are provided to obtain the outstanding integration
evidence on full checkouts. Complete-suite testing remains mandatory before
installation or release.

## Reproduce standalone evidence

From the Applications root on Linux:

```bash
cmake -S framework/tests/cmake/test_build_contract \
  -B build/test-build-contract-gcc -G Ninja \
  -DCMAKE_C_COMPILER=gcc -DCMAKE_BUILD_TYPE=Debug \
&& cmake --build build/test-build-contract-gcc --parallel 2 \
&& ctest --test-dir build/test-build-contract-gcc --parallel 2 \
  --output-on-failure --no-tests=error
```

Use a separate directory and `-DCMAKE_C_COMPILER=clang` for Clang. Do not change
a compiler inside an existing configured tree.

Run the preset regression independently:

```bash
cmake -DPRESET_FILE="$PWD/CMakePresets.json" \
  -P tests/cmake/test_cross_platform_presets.cmake
```

Follow `docs/getting-started/CROSS_PLATFORM_BUILD_AND_PUBLISH.md` for integration
checks and safe main-branch publication. No build directory deletion is needed.
