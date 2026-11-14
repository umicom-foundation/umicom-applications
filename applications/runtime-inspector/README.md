<!--
Umicom Applications
File: applications/runtime-inspector/README.md

PURPOSE:
  Build and use the thin native dependency inspector.

EDUCATIONAL OVERVIEW:
  The application presents one selected file; reusable parsing belongs to
  Framework and does not require the inspected code to execute.

AUTHOR AND ORGANISATION:
  Sammy Hegab
  Umicom Foundation

LICENCE:
  MIT for Umicom contributions. Existing third-party terms remain applicable.
-->

# Runtime inspector

Build from the Applications root with the existing UCRT64 toolchain:

```powershell
cmake -S ".\applications\runtime-inspector" -B ".\build\runtime-inspector" -G Ninja -DCMAKE_C_COMPILER="C:/msys64/ucrt64/bin/gcc.exe" -DCMAKE_BUILD_TYPE=Debug
cmake --build ".\build\runtime-inspector" --parallel 2
ctest --test-dir ".\build\runtime-inspector" --output-on-failure --no-tests=error
```

Run each command separately and stop when a command fails.

The CLI prints JSON for a complete selected PE file. It reads data only:

```powershell
.\build\runtime-inspector\umicom-runtime-inspect.exe "C:\umicom\local-nsfw-model-router\tools\native\umicom-ai-bridge.exe"
```

This command is not `umicom.exe` and does not replace it. It is a focused diagnostic
consumer of `Umicom::pe_imports`, not another Framework implementation. File paths
are supplied by the caller; no drive scan, download, DLL load or model inference
is performed. A rejected file produces a non-zero exit status. The caller owns
any redirected output and should keep private filenames out of public reports.
