# -----------------------------------------------------------------------------
# Umicom Applications
# File: scripts/update-version-lock.ps1
#
# PURPOSE:
#   Compatibility helper for the consolidated umicom-applications repository.
#   The repository now records Framework and application-module versions as Git
#   submodule gitlinks. This script refreshes/stages those gitlink pointers so
#   the established developer workflow can continue to call update-version-lock.
#
# Created by: Sammy Hegab
# Organisation: Umicom Foundation
# Licence: MIT
# -----------------------------------------------------------------------------
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$RepositoryRoot = "."
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $RepositoryRoot).Path
$gitModules = Join-Path $root ".gitmodules"

if (-not (Test-Path -LiteralPath (Join-Path $root ".git"))) {
    throw "RepositoryRoot is not a Git working tree: $root"
}

if (-not (Test-Path -LiteralPath $gitModules)) {
    Write-Host "No .gitmodules file exists. No gitlink version pointers require updating."
    exit 0
}

Push-Location $root
try {
    $paths = @(& git config --file .gitmodules --get-regexp path 2>$null |
        ForEach-Object {
            $parts = $_ -split '\s+', 2
            if ($parts.Count -eq 2) { $parts[1].Trim() }
        } |
        Where-Object { $_ })

    if ($paths.Count -eq 0) {
        Write-Host "No submodule paths were found in .gitmodules."
        exit 0
    }

    foreach ($path in $paths) {
        $fullPath = Join-Path $root $path
        if (-not (Test-Path -LiteralPath $fullPath)) {
            Write-Warning "Skipping uninitialised submodule: $path"
            continue
        }

        $sha = (& git -C $fullPath rev-parse HEAD).Trim()
        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($sha)) {
            throw "Unable to resolve submodule HEAD for $path"
        }

        & git add -- $path
        if ($LASTEXITCODE -ne 0) {
            throw "Unable to stage gitlink pointer for $path"
        }

        Write-Host ("Locked {0} -> {1}" -f $path, $sha)
    }

    Write-Host "Umicom submodule version pointers refreshed and staged."
}
finally {
    Pop-Location
}
