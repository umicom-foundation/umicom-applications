<#
Umicom Applications
File: scripts/publish-repositories.ps1
Author: Sammy Hegab
Organisation: Umicom Foundation
Licence: MIT

.SYNOPSIS
Preview or publish changes in a checkout and its configured submodules.
.DESCRIPTION
Run against the original checkout after merging reviewed source changes. The
default is a read-only preview. -Execute stages allowed changes with git add -A,
commits when needed, and pushes each child before its parent. Every repository
is checked before any staging begins. Detached HEADs, missing upstreams,
uninitialized modules, merge conflicts, and tracked protected paths stop the run.

Protected paths are excluded independently in every repository; a parent
.gitignore does not protect files staged inside a submodule. Filename exclusions
cannot detect credentials embedded in an otherwise ordinary source file. Review
the changes and ignore rules first. This script never fetches, pulls, forces a
push, bypasses hooks, or changes Git configuration. A failed push stops the run;
earlier successful child commits/pushes remain and can be resumed with a rerun.
.EXAMPLE
./scripts/publish-repositories.ps1 -RepositoryRoot C:\umicom\umicom-applications
.EXAMPLE
./scripts/publish-repositories.ps1 -RepositoryRoot C:\umicom\umicom-applications -Message "feat: update shared application workbench" -Execute
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$RepositoryRoot,

    [string]$Message,

    [switch]$Execute
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ($Execute -and [string]::IsNullOrWhiteSpace($Message)) {
    throw '-Execute requires a meaningful -Message for the commits.'
}

# Git glob pathspecs use **/ for zero or more directories. Match case-insensitively
# on every host, including Linux, so the preview and staging share one policy.
$protectedGlobs = @(
    '**/.env', '**/.env.*',
    '**/credentials.json', '**/credentials.yaml', '**/credentials.yml',
    '**/credentials.toml', '**/credentials.ini', '**/credentials.txt',
    '**/secrets.json', '**/secrets.yaml', '**/secrets.yml',
    '**/secrets.toml', '**/secrets.ini', '**/secrets.txt',
    '**/*.secret', '**/*.token', '**/*.credentials',
    '**/*.key', '**/*.pem', '**/*.p12', '**/*.pfx', '**/*.jks', '**/*.keystore',
    '**/id_rsa*', '**/id_dsa*', '**/id_ecdsa*', '**/id_ed25519*',
    '**/.ssh/**', '**/.aws/**', '**/.azure/**',
    '**/.umicom/**', '**/private/**', '**/local-only/**', '**/scratch/**',
    '**/tmp/**', '**/temp/**', '**/analysis/**', '**/research/**', '**/notes/**',
    '**/*.tmp', '**/*.temp', '**/*.log', '**/*~',
    '**/*.7z', '**/*.rar', '**/*.zip', '**/*.tar', '**/*.tar.gz', '**/*.tgz'
)
$protectedIncludes = @($protectedGlobs | ForEach-Object { ':(glob,icase)' + $_ })
$stagePathspecs = @('.') + @($protectedGlobs | ForEach-Object { ':(exclude,glob,icase)' + $_ })
$repositories = [System.Collections.Generic.List[object]]::new()
$visited = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

# Run one Git command and stop immediately if it returns an unexpected result.
function Invoke-RepositoryGit {
    param([string]$Path, [string[]]$Arguments, [int[]]$AllowedExitCodes = @(0))

    $output = @(& git --no-optional-locks -c core.quotePath=false -C $Path @Arguments)
    $code = $LASTEXITCODE
    if ($AllowedExitCodes -notcontains $code) {
        throw "Git $($Arguments[0]) failed in '$Path' (exit $code)."
    }
    return ($output -join "`n")
}

# Decode Git's path list without splitting filenames that contain spaces.
function Get-NullSeparatedPaths {
    param([string]$Text)
    return @($Text -split "`0" | Where-Object { $_.Length -gt 0 })
}

# Refuse publication if protected local data is already in a repository index.
function Assert-NoProtectedTrackedPaths {
    param([string]$Path)

    $tracked = Invoke-RepositoryGit $Path (@('ls-files', '--cached', '-z', '--') + $protectedIncludes)
    $count = @(Get-NullSeparatedPaths $tracked).Count
    if ($count -gt 0) {
        throw "'$Path' has $count tracked or already staged protected path(s). Review and remove them from version control separately before publishing; no files have been deleted by this script."
    }
}

# Validate the entire checkout and place each child before its parent in the plan.
function Add-RepositoryToPlan {
    param([string]$Path)

    $resolved = (Resolve-Path -LiteralPath $Path).ProviderPath
    if (-not $visited.Add($resolved)) {
        throw "Duplicate or cyclic repository path: '$resolved'."
    }
    if ((Get-Item -LiteralPath $resolved).Attributes -band [IO.FileAttributes]::ReparsePoint) {
        throw "Repository links/junctions are not supported: '$resolved'."
    }
    $top = Invoke-RepositoryGit $resolved @('rev-parse', '--show-toplevel')
    if ([IO.Path]::GetFullPath($top) -ne [IO.Path]::GetFullPath($resolved)) {
        throw "Not an initialized repository at its own root: '$resolved'."
    }

    $branch = Invoke-RepositoryGit $resolved @('symbolic-ref', '--quiet', '--short', 'HEAD')
    $null = Invoke-RepositoryGit $resolved @('rev-parse', '--verify', '@{upstream}')
    $remote = Invoke-RepositoryGit $resolved @('config', '--get', "branch.$branch.remote")
    $mergeRef = Invoke-RepositoryGit $resolved @('config', '--get', "branch.$branch.merge")
    if ($remote -eq '.' -or [string]::IsNullOrWhiteSpace($remote) -or
        $mergeRef -notmatch '^refs/heads/[^\r\n]+$') {
        throw "A single remote branch upstream is required in '$resolved'."
    }
    $pushUrls = Invoke-RepositoryGit $resolved @('remote', 'get-url', '--push', '--all', $remote)
    if ([string]::IsNullOrWhiteSpace($pushUrls) -or $pushUrls.Contains("`n")) {
        throw "A single push destination is required in '$resolved'."
    }
    $conflicts = Invoke-RepositoryGit $resolved @('ls-files', '--unmerged', '-z')
    if ($conflicts.Length -gt 0) {
        throw "Unresolved merge conflicts in '$resolved'."
    }
    Assert-NoProtectedTrackedPaths $resolved

    $moduleFile = Join-Path $resolved '.gitmodules'
    if (Test-Path -LiteralPath $moduleFile -PathType Leaf) {
        $moduleLines = Invoke-RepositoryGit $resolved @('config', '--file', $moduleFile, '--get-regexp', '^submodule\..*\.path$') @(0, 1)
        foreach ($line in @($moduleLines -split "`n" | Where-Object { $_ })) {
            $relative = ($line -split '\s+', 2)[1]
            if ([IO.Path]::IsPathRooted($relative) -or $relative -match '(^|[/\\])\.\.([/\\]|$)') {
                throw "Submodule path must stay inside its parent: '$relative'."
            }
            $child = [IO.Path]::GetFullPath((Join-Path $resolved $relative))
            $prefix = $resolved.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
            if (-not $child.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
                throw "Submodule path escapes its parent: '$relative'."
            }
            # Reject links at intermediate levels too, before operating on a child.
            $ancestor = Get-Item -LiteralPath $child
            while ($ancestor.FullName -ne $resolved) {
                if ($ancestor.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                    throw "Submodule path contains a link/junction: '$relative'."
                }
                $ancestor = $ancestor.Parent
            }
            Add-RepositoryToPlan $child
        }
    }
    # Postorder ensures new descendant commits are recorded in parent gitlinks.
    $repositories.Add([pscustomobject]@{ Path = $resolved; Branch = $branch; Remote = $remote; MergeRef = $mergeRef })
}

Add-RepositoryToPlan $RepositoryRoot
Write-Host "Preflight passed for $($repositories.Count) repositories. Processing children before parents."

foreach ($repository in $repositories) {
    Write-Host "`n$($repository.Path) [$($repository.Branch) -> $($repository.Remote)/$($repository.MergeRef -replace '^refs/heads/', '')]"
    if (-not $Execute) {
        # Even git add --dry-run may acquire index.lock. Status with optional
        # locks disabled keeps the preview usable against read-only checkouts.
        $preview = Invoke-RepositoryGit $repository.Path (@('status', '--short', '--untracked-files=all', '--ignore-submodules=none', '--') + $stagePathspecs)
        if ($preview) { Write-Host $preview }
        $staged = Invoke-RepositoryGit $repository.Path @('diff', '--cached', '--stat')
        if ($staged) { Write-Host $staged }
        continue
    }

    Assert-NoProtectedTrackedPaths $repository.Path
    $null = Invoke-RepositoryGit $repository.Path (@('add', '-A', '--') + $stagePathspecs)
    Assert-NoProtectedTrackedPaths $repository.Path
    & git --no-optional-locks -C $repository.Path diff --cached --quiet
    $diffExit = $LASTEXITCODE
    if ($diffExit -eq 1) {
        $result = Invoke-RepositoryGit $repository.Path @('commit', '-m', $Message)
        Write-Host $result
    } elseif ($diffExit -ne 0) {
        throw "Cannot inspect staged changes in '$($repository.Path)' (exit $diffExit)."
    }
    $result = Invoke-RepositoryGit $repository.Path @('push', '--recurse-submodules=check', $repository.Remote, "HEAD:$($repository.MergeRef)")
    if ($result) { Write-Host $result }
}

if (-not $Execute) {
    Write-Host "`nPreview only: no staging, commits, pushes, or fetches. Protected paths (including .env templates) are excluded. Review changes, then rerun with -Message and -Execute to publish."
} else {
    Write-Host "`nFinished publishing $($repositories.Count) repositories."
}
