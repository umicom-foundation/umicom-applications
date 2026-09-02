<#-----------------------------------------------------------------------------
 * Umicom Applications
 * File: scripts/umicom-bootstrap.ps1
 *
 * PURPOSE:
 *   Give a new Windows developer a small, readable fallback before the native
 *   Umicom command has been compiled. The script can install tools, inspect the
 *   computer, clone the project, configure, build, test and use safe Git steps.
 *
 * AUTHOR AND ORGANISATION:
 * Sammy Hegab
 * Umicom Foundation
 *
 * LICENCE:
 * MIT
 *---------------------------------------------------------------------------#>

[CmdletBinding()]
param(
    [ValidateSet(
        "help", "install", "doctor", "clone", "configure", "build",
        "test", "all", "run-studio", "status", "add", "commit", "push",
        "new-branch")]
    [string]$Action = "help",

    [string]$ProjectRoot = "C:\umicom\umicom-applications",
    [string]$Destination = "C:\umicom\umicom-applications",
    [string]$RepositoryUrl =
        "https://github.com/umicom-foundation/umicom-applications.git",
    [string]$Preset = "windows-ucrt64-debug",
    [ValidateRange(1, 64)]
    [int]$Jobs = 2,
    [string]$Message = "",
    [string]$Branch = ""
)

$ErrorActionPreference = "Stop"

# Provide the show umicom bootstrap help operation used by this module and its client
# applications.
function Show-UmicomBootstrapHelp {
    Write-Host @"
Umicom beginner bootstrap for Windows

Use one action at a time:
  help          Show this page.
  install       Install Git, GitHub CLI, MSYS2 and the UCRT64 development tools.
  doctor        Check that the computer is ready.
  clone         Download Umicom Applications and every submodule.
  configure     Prepare the CMake build directory.
  build         Compile the project.
  test          Run the complete test suite.
  all           Run doctor, configure, build and test in that order.
  run-studio    Open Umicom Studio IDE after a successful build.
  status        Show changes in the parent project and every submodule.
  add           Stage every change in one repository.
  commit        Commit staged changes; also pass -Message "your message".
  push          Push the current branch to its configured remote.
  new-branch    Create a branch; also pass -Branch "feature/short-name".

First commands on a new computer:
  powershell -ExecutionPolicy Bypass -File .\scripts\umicom-bootstrap.ps1 install
  powershell -ExecutionPolicy Bypass -File .\scripts\umicom-bootstrap.ps1 doctor
  powershell -ExecutionPolicy Bypass -File .\scripts\umicom-bootstrap.ps1 clone
  powershell -ExecutionPolicy Bypass -File .\scripts\umicom-bootstrap.ps1 all
"@
}

# Provide the invoke checked command operation used by this module and its client
# applications.
function Invoke-CheckedCommand {
    param(
        [Parameter(Mandatory = $true)][string]$Program,
        [Parameter(ValueFromRemainingArguments = $true)][string[]]$Arguments
    )

    & $Program @Arguments
    # Apply this branch only when its contract condition is satisfied.
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code ${LASTEXITCODE}: $Program"
    }
}

# Provide the assert project exists operation used by this module and its client
# applications.
function Assert-ProjectExists {
    # Apply this branch only when its contract condition is satisfied.
    if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot "CMakePresets.json"))) {
        throw "Umicom Applications was not found at $ProjectRoot. Run the clone action first."
    }
}

# Provide the install umicom tools operation used by this module and its client
# applications.
function Install-UmicomTools {
    # Preserve the original failure result so the caller can respond to the correct cause.
    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
        throw "Windows Package Manager (winget) is required. Install App Installer from Microsoft Store, then run this action again."
    }

    Write-Host "Installing Git..." -ForegroundColor Cyan
    Invoke-CheckedCommand "winget.exe" install --id Git.Git --exact --accept-package-agreements --accept-source-agreements

    Write-Host "Installing GitHub CLI..." -ForegroundColor Cyan
    Invoke-CheckedCommand "winget.exe" install --id GitHub.cli --exact --accept-package-agreements --accept-source-agreements

    Write-Host "Installing MSYS2..." -ForegroundColor Cyan
    Invoke-CheckedCommand "winget.exe" install --id MSYS2.MSYS2 --exact --accept-package-agreements --accept-source-agreements

    # Apply this branch only when its contract condition is satisfied.
    if (-not (Test-Path -LiteralPath "C:\msys64\usr\bin\bash.exe")) {
        throw "MSYS2 did not appear at C:\msys64. Restart Windows, then run the install action again."
    }

    Write-Host "Updating MSYS2 and installing the Umicom UCRT64 toolchain..." -ForegroundColor Cyan
    Invoke-CheckedCommand "C:\msys64\usr\bin\bash.exe" -lc "pacman -Syu --noconfirm"
    Invoke-CheckedCommand "C:\msys64\usr\bin\bash.exe" -lc "pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-toolchain mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-ninja mingw-w64-ucrt-x86_64-pkgconf mingw-w64-ucrt-x86_64-gtk4 mingw-w64-ucrt-x86_64-gtksourceview5 mingw-w64-ucrt-x86_64-json-glib mingw-w64-ucrt-x86_64-libsoup3 mingw-w64-ucrt-x86_64-curl mingw-w64-ucrt-x86_64-sqlite3 mingw-w64-ucrt-x86_64-gdb"

    Write-Host "Tool installation completed. Restart PowerShell, then run the doctor action." -ForegroundColor Green
}

# Provide the test umicom computer operation used by this module and its client
# applications.
function Test-UmicomComputer {
    $failed = $false
    $requiredFiles = @(
        "C:\msys64\usr\bin\bash.exe",
        "C:\msys64\ucrt64\bin\gcc.exe",
        "C:\msys64\ucrt64\bin\cmake.exe",
        "C:\msys64\ucrt64\bin\ninja.exe",
        "C:\msys64\ucrt64\bin\pkg-config.exe"
    )

    # Visit each bounded item once so every record receives the same rule.
    foreach ($requiredFile in $requiredFiles) {
        # Apply this branch only when its contract condition is satisfied.
        if (Test-Path -LiteralPath $requiredFile) {
            Write-Host "[OK] $requiredFile" -ForegroundColor Green
        } else {
            Write-Host "[MISSING] $requiredFile" -ForegroundColor Red
            $failed = $true
        }
    }

    # Preserve the original failure result so the caller can respond to the correct cause.
    if (Get-Command git.exe -ErrorAction SilentlyContinue) {
        Invoke-CheckedCommand "git.exe" --version
    } else {
        Write-Host "[MISSING] git.exe" -ForegroundColor Red
        $failed = $true
    }

    # Preserve the original failure result so the caller can respond to the correct cause.
    if (-not $failed) {
        Invoke-CheckedCommand "C:\msys64\ucrt64\bin\gcc.exe" --version
        Invoke-CheckedCommand "C:\msys64\ucrt64\bin\cmake.exe" --version
        Invoke-CheckedCommand "C:\msys64\ucrt64\bin\ninja.exe" --version

        # Visit each bounded item once so every record receives the same rule.
        foreach ($library in @(
            "gtk4", "gtksourceview-5", "json-glib-1.0", "libsoup-3.0",
            "libcurl", "sqlite3")) {
            & "C:\msys64\ucrt64\bin\pkg-config.exe" --modversion $library
            # Apply this branch only when its contract condition is satisfied.
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] library $library" -ForegroundColor Green
            } else {
                Write-Host "[MISSING] library $library" -ForegroundColor Red
                $failed = $true
            }
        }
    }

    # Apply this branch only when its contract condition is satisfied.
    if (Test-Path -LiteralPath $ProjectRoot) {
        # Apply this branch only when its contract condition is satisfied.
        if (Test-Path -LiteralPath (Join-Path $ProjectRoot "CMakePresets.json")) {
            Write-Host "[OK] Umicom project $ProjectRoot" -ForegroundColor Green
        } else {
            Write-Host "[WARNING] The folder exists but CMakePresets.json is missing: $ProjectRoot" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[INFO] The project has not been cloned yet." -ForegroundColor Yellow
    }

    # Preserve the original failure result so the caller can respond to the correct cause.
    if ($failed) {
        throw "This computer is not ready yet. Run the install action, restart PowerShell, and run doctor again."
    }
    Write-Host "Your computer passed the Umicom checks." -ForegroundColor Green
}

# Provide the clone umicom project operation used by this module and its client
# applications.
function Clone-UmicomProject {
    # Apply this branch only when its contract condition is satisfied.
    if (Test-Path -LiteralPath $Destination) {
        throw "The destination already exists: $Destination. Choose an empty destination or use the existing checkout."
    }
    New-Item -ItemType Directory -Path (Split-Path -Parent $Destination) -Force | Out-Null
    Invoke-CheckedCommand "git.exe" clone --recurse-submodules $RepositoryUrl $Destination
    Write-Host "Umicom Applications was cloned to $Destination" -ForegroundColor Green
}

# Provide the configure umicom project operation used by this module and its client
# applications.
function Configure-UmicomProject {
    Assert-ProjectExists
    Push-Location $ProjectRoot
    try {
        Invoke-CheckedCommand "C:\msys64\ucrt64\bin\cmake.exe" --preset $Preset
    } finally {
        Pop-Location
    }
}

# Provide the build umicom project operation used by this module and its client
# applications.
function Build-UmicomProject {
    Assert-ProjectExists
    Push-Location $ProjectRoot
    try {
        Invoke-CheckedCommand "C:\msys64\ucrt64\bin\cmake.exe" --build --preset $Preset --parallel $Jobs
    } finally {
        Pop-Location
    }
}

# Provide the test umicom project operation used by this module and its client
# applications.
function Test-UmicomProject {
    Assert-ProjectExists
    Push-Location $ProjectRoot
    try {
        Invoke-CheckedCommand "C:\msys64\ucrt64\bin\ctest.exe" --preset $Preset
    } finally {
        Pop-Location
    }
}

# Provide the show repository status operation used by this module and its client
# applications.
function Show-RepositoryStatus {
    # Apply this branch only when its contract condition is satisfied.
    if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot ".git"))) {
        throw "A Git checkout was not found at $ProjectRoot."
    }
    Invoke-CheckedCommand "git.exe" -C $ProjectRoot status --short
    Push-Location $ProjectRoot
    try {
        Invoke-CheckedCommand "git.exe" submodule foreach --recursive 'echo ===== $displaypath =====; git status --short'
    } finally {
        Pop-Location
    }
}

# Apply this branch only when its contract condition is satisfied.
switch ($Action) {
    "help" { Show-UmicomBootstrapHelp }
    "install" { Install-UmicomTools }
    "doctor" { Test-UmicomComputer }
    "clone" { Clone-UmicomProject }
    "configure" { Configure-UmicomProject }
    "build" { Build-UmicomProject }
    "test" { Test-UmicomProject }
    "all" {
        Test-UmicomComputer
        Configure-UmicomProject
        Build-UmicomProject
        Test-UmicomProject
    }
    "run-studio" {
        Assert-ProjectExists
        $studioExecutable = Join-Path $ProjectRoot "build\$Preset\bin\umicom-studio-ide.exe"
        # Apply this branch only when its contract condition is satisfied.
        if (-not (Test-Path -LiteralPath $studioExecutable)) {
            throw "Studio has not been built at $studioExecutable. Run the build action first."
        }
        & $studioExecutable --console
    }
    "status" { Show-RepositoryStatus }
    "add" { Invoke-CheckedCommand "git.exe" -C $ProjectRoot add -A }
    "commit" {
        # Apply this branch only when its contract condition is satisfied.
        if ([string]::IsNullOrWhiteSpace($Message)) {
            throw 'The commit action needs -Message "a meaningful description".'
        }
        Invoke-CheckedCommand "git.exe" -C $ProjectRoot commit -m $Message
    }
    "push" { Invoke-CheckedCommand "git.exe" -C $ProjectRoot push }
    "new-branch" {
        # Apply this branch only when its contract condition is satisfied.
        if ([string]::IsNullOrWhiteSpace($Branch)) {
            throw 'The new-branch action needs -Branch "feature/short-name".'
        }
        Invoke-CheckedCommand "git.exe" -C $ProjectRoot switch -c $Branch
    }
}
