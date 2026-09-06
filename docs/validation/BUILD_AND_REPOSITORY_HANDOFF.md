<!--
  Umicom Applications
  File: docs/validation/BUILD_AND_REPOSITORY_HANDOFF.md

  PURPOSE:
    Give maintainers a safe, repeatable build and multi-repository handoff after
    reviewing the copied worktree. Commands are examples for the active checkout;
    this document itself never runs them.

  AUTHOR AND ORGANISATION:
  Sammy Hegab
  Umicom Foundation

  LICENCE:
  MIT
-->

# Build and repository handoff

This handoff is for the active checkout at
`C:/umicom/umicom-applications`. The copied audit worktree at
`C:/umicom/applications/umicom-applications-mb60` is only a comparison area and
its submodule metadata is incomplete. Do not run the Git commands below in the
copied area. First compare and merge the files, then run the commands from the
active checkout.

## Build and test

The configure step creates the selected build directory. The build step then
uses Ninja's dependency graph: unchanged source files are reused and only
affected targets are rebuilt. No source file list is needed.

```powershell
Set-Location "C:\umicom\umicom-applications"

# Configure the complete Windows GTK4 product estate once.
& "C:\msys64\ucrt64\bin\cmake.exe" --preset windows-ucrt64-all-debug

# Build every enabled product; Ninja still recompiles only changed inputs.
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --parallel 2

# Run the complete registered test suite after the build succeeds.
& "C:\msys64\ucrt64\bin\ctest.exe" --preset windows-ucrt64-all-debug
```

For a faster dependency-light check, use the headless preset. It keeps GTK
frontends disabled while still exercising Framework, Desk, Studio, Trader, TMS,
Bank, OS and their tests:

```powershell
Set-Location "C:\umicom\umicom-applications"
& "C:\msys64\ucrt64\bin\cmake.exe" --preset windows-ucrt64-headless-debug
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-headless-debug --parallel 2
& "C:\msys64\ucrt64\bin\ctest.exe" --preset windows-ucrt64-headless-debug
```

After the first configure, the Framework build planner can be used without
naming changed files. The aggregate target follows the configured manifests:

```powershell
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --target umicom-products --parallel 2
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-all-debug --target umicom-tests --parallel 2
```

The following checks are optional and read source files without launching a
compiled application. The documentation target is available on Windows when
PowerShell is installed:

```powershell
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-headless-debug --target umicom-source-audit
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-headless-debug --target umicom-product-governance
& "C:\msys64\ucrt64\bin\cmake.exe" --build --preset windows-ucrt64-headless-debug --target umicom-source-documentation-audit
```

## Native Umicom command sequence

After the Framework CLI has been built, add its `bin` directory to the current
PowerShell session. This does not change the machine-wide PATH and does not
remove or overwrite source files:

```powershell
Set-Location "C:\umicom\umicom-applications"
$env:Path = "C:\umicom\umicom-applications\build\windows-ucrt64-headless-debug\bin;$env:Path"

umicom check --project "C:\umicom\umicom-applications"
umicom automate plan "C:\umicom\umicom-applications"
umicom automate run "C:\umicom\umicom-applications" --preset windows-ucrt64-headless-debug --jobs 2
```

`automate plan` is read-only. `automate run` discovers changed modules from
the configured manifests, verifies them, builds their affected targets and
runs focused tests. It does not require a product or source-file list. For a
developer-controlled overnight or delayed watcher, use the local
`.umicom/automation.conf` policy and start:

```powershell
umicom automate settings "C:\umicom\umicom-applications"
umicom automate watch "C:\umicom\umicom-applications" --preset windows-ucrt64-headless-debug --jobs 2
```

The CLI is optional; if `umicom` is not on PATH, build the `umicom` target first
or use the explicit executable path from the build directory. No Umicom command
silently pushes, deletes or force-resets a repository.

## Commit Framework and application repositories

Framework and every application are independent Git repositories. Commit and
push a changed submodule first; then commit the new submodule pins and suite
files in the parent repository. The loop below discovers all paths recorded in
`.gitmodules`, stages with `git add -A`, skips repositories with no changes and
stops before committing if a private path is staged.

```powershell
Set-Location "C:\umicom\umicom-applications"
$suiteRoot = (Get-Location).Path
$submodulePaths = @(git config --file .gitmodules --get-regexp '^submodule\..*\.path$' |
    ForEach-Object { ($_ -split ' ', 2)[1] })

foreach ($relativePath in $submodulePaths) {
    $repositoryPath = Join-Path $suiteRoot $relativePath
    if (-not (Test-Path -LiteralPath (Join-Path $repositoryPath ".git"))) {
        throw "Submodule metadata is missing: $repositoryPath"
    }
    Set-Location $repositoryPath
    git status --short
    git add -A
    $staged = @(git diff --cached --name-only)
    $private = @($staged | Where-Object {
        $_ -match '(^|/)(tmp|analysis|research|notes)/' -or
        $_ -match '(^|/)\.env(\.|$)' -or
        $_ -match '\.(key|keystore|jks|p12|pfx|pem|crt|csr|der|secret|token|credentials)$'
    })
    if ($private.Count -gt 0) {
        Write-Error "Private files are staged in ${relativePath}: $($private -join ', ')"
        throw "Review and unstage private files before committing."
    }
    git diff --cached --check
    if ($LASTEXITCODE -ne 0) {
        throw "Whitespace errors found in staged changes for $relativePath"
    }
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 0) {
        Write-Host "No changes to commit in $relativePath"
        continue
    }
    if ($LASTEXITCODE -gt 1) {
        throw "Unable to inspect staged changes in $relativePath"
    }
    $moduleName = Split-Path -Leaf $repositoryPath
    git commit -m "feat($moduleName): apply audited source improvements"
    if ($LASTEXITCODE -ne 0) {
        throw "Commit failed in $relativePath"
    }
    git push origin HEAD
    if ($LASTEXITCODE -ne 0) {
        throw "Push failed in $relativePath"
    }
}

# Record changed submodule commit IDs and suite-owned files in the parent.
Set-Location $suiteRoot
git status --short
git add -A
$staged = @(git diff --cached --name-only)
$private = @($staged | Where-Object {
    $_ -match '(^|/)(tmp|analysis|research|notes)/' -or
    $_ -match '(^|/)\.env(\.|$)' -or
    $_ -match '\.(key|keystore|jks|p12|pfx|pem|crt|csr|der|secret|token|credentials)$'
})
if ($private.Count -gt 0) {
    Write-Error "Private files are staged in the suite: $($private -join ', ')"
    throw "Review and unstage private files before committing."
}
git diff --cached --check
if ($LASTEXITCODE -ne 0) {
    throw "Whitespace errors found in staged suite changes"
}
git diff --cached --quiet
if ($LASTEXITCODE -eq 1) {
    git commit -m "feat(audit): harden shared runtime and document suite review"
    if ($LASTEXITCODE -ne 0) {
        throw "Commit failed in the suite repository"
    }
    git push origin HEAD
    if ($LASTEXITCODE -ne 0) {
        throw "Push failed in the suite repository"
    }
}
if ($LASTEXITCODE -gt 1) {
    throw "Unable to inspect staged changes in the suite repository"
}
```

The repository ignore policy excludes build output, temporary evidence,
analysis/research notes, local comparison folders and common credentials. Still
inspect `git diff --cached --name-only` before each commit: an ignore rule is a
guardrail, not a substitute for human review. Never use `git add -f` for private
or generated files.
