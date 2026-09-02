<#-----------------------------------------------------------------------------
 * Umicom Applications
 * File: scripts/update-version-lock.ps1
 *
 * PURPOSE:
 *   Provide readable update version lock automation with explicit checks and
 *   failure messages.
 *
 * AUTHOR AND ORGANISATION:
 * Sammy Hegab
 * Umicom Foundation
 *
 * LICENCE:
 * MIT
 *---------------------------------------------------------------------------#>

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

# Apply this branch only when its contract condition is satisfied.
if (-not (Test-Path -LiteralPath (Join-Path $root ".git"))) {
    throw "RepositoryRoot is not a Git working tree: $root"
}

# Apply this branch only when its contract condition is satisfied.
if (-not (Test-Path -LiteralPath $gitModules)) {
    Write-Host "No .gitmodules file exists. No gitlink version pointers require updating."
    exit 0
}

Push-Location $root
try {
    $paths = @(& git config --file .gitmodules --get-regexp path 2>$null |
        # Visit each bounded item once so every record receives the same rule.
        ForEach-Object {
            $parts = $_ -split '\s+', 2
            # Keep the operation inside its valid bounds before reading, writing or adding data.
            if ($parts.Count -eq 2) { $parts[1].Trim() }
        } |
        Where-Object { $_ })

    # Keep the operation inside its valid bounds before reading, writing or adding data.
    if ($paths.Count -eq 0) {
        Write-Host "No submodule paths were found in .gitmodules."
        exit 0
    }

    # Visit each bounded item once so every record receives the same rule.
    foreach ($path in $paths) {
        $fullPath = Join-Path $root $path
        # Apply this branch only when its contract condition is satisfied.
        if (-not (Test-Path -LiteralPath $fullPath)) {
            Write-Warning "Skipping uninitialised submodule: $path"
            continue
        }

        $sha = (& git -C $fullPath rev-parse HEAD).Trim()
        # Apply this branch only when its contract condition is satisfied.
        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($sha)) {
            throw "Unable to resolve submodule HEAD for $path"
        }

        & git add -- $path
        # Apply this branch only when its contract condition is satisfied.
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
