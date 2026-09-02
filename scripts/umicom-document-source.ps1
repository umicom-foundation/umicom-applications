<#-----------------------------------------------------------------------------
 * Umicom Applications
 * File: scripts/umicom-document-source.ps1
 *
 * PURPOSE:
 *   Audit project-owned source and script files for the standard Umicom file
 *   header and nearby explanations for functions, contracts and decisions.
 *   Apply mode adds missing guidance without deleting code or comments.
 *
 * AUTHOR AND ORGANISATION:
 * Sammy Hegab
 * Umicom Foundation
 *
 * LICENCE:
 * MIT
 *---------------------------------------------------------------------------#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateSet("Audit", "Apply")]
    [string]$Mode = "Audit",

    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot),

    [string[]]$PathPrefix = @(),

    [switch]$IncludeTemplates
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# These folders contain generated output or code owned by another project.
# Editing them would either be temporary or make future dependency updates hard.
$ExcludedFolderNames = @(
    ".git", "build", "vendor", "third_party", "external", "node_modules"
)

# JSON does not permit comments, so it is deliberately absent. YAML and TOML
# are configuration data rather than executable source and keep their own rules.
$AuditedExtensions = @(
    ".c", ".h", ".cpp", ".inc", ".s", ".zig", ".rs", ".cmake",
    ".ps1", ".sh", ".css", ".svg"
)

# Convert a path to forward slashes before recording it in a portable header.
function ConvertTo-UmicomPortablePath {
    param([Parameter(Mandatory)][string]$Path)

    return $Path.Replace("\", "/")
}

# Turn an identifier or filename into ordinary words without changing the
# identifier stored in code. Descriptive names therefore remain intact.
function ConvertTo-UmicomWords {
    param([Parameter(Mandatory)][string]$Text)

    $words = [regex]::Replace($Text, '([a-z0-9])([A-Z])', '$1 $2')
    $words = $words -replace '[_\-.]+', ' '
    $words = $words -replace '\s+', ' '
    return $words.Trim().ToLowerInvariant()
}

# Wrap prose at word boundaries so generated guidance remains comfortable to
# read in an editor without changing any code token or identifier.
function Split-UmicomCommentText {
    param(
        [Parameter(Mandatory)][string]$Text,
        [ValidateRange(40, 120)][int]$Width = 88
    )

    $result = [Collections.Generic.List[string]]::new()
    $current = ""
    # Visit each bounded item once so every record receives the same rule.
    foreach ($word in ($Text -split '\s+')) {
        # Keep the operation inside its valid bounds before reading, writing or adding data.
        if ($current.Length -eq 0) {
            $current = $word
        } elseif ($current.Length + 1 + $word.Length -le $Width) {
            $current += " " + $word
        } else {
            $result.Add($current)
            $current = $word
        }
    }
    # Keep the operation inside its valid bounds before reading, writing or adding data.
    if ($current.Length -gt 0) { $result.Add($current) }
    return $result.ToArray()
}

# Format ordinary or structured C guidance with a consistent readable width.
function New-UmicomCComment {
    param(
        [Parameter(Mandatory)][string]$Text,
        [string]$Indent = "",
        [switch]$Structured
    )

    $wrapped = @(Split-UmicomCommentText -Text $Text)
    # Keep the operation inside its valid bounds before reading, writing or adding data.
    if (-not $Structured -and $wrapped.Count -eq 1) {
        return @("$Indent/* $($wrapped[0]) */")
    }
    $opening = if ($Structured) { "/**" } else { "/*" }
    $result = [Collections.Generic.List[string]]::new()
    $result.Add($Indent + $opening)
    # Visit each bounded item once so every record receives the same rule.
    foreach ($line in $wrapped) { $result.Add("$Indent * $line") }
    $result.Add("$Indent */")
    return $result.ToArray()
}

# Format script guidance using the same word-wrapping policy as C comments.
function New-UmicomHashComment {
    param(
        [Parameter(Mandatory)][string]$Text,
        [string]$Indent = ""
    )

    return @(Split-UmicomCommentText -Text $Text | ForEach-Object {
        "$Indent# $_"
    })
}

# Identify the owning product from the repository path so each header gives a
# reader useful context before they inspect includes or build files.
function Get-UmicomOwner {
    param([Parameter(Mandatory)][string]$RelativePath)

    $portablePath = ConvertTo-UmicomPortablePath $RelativePath
    # Apply this branch only when its contract condition is satisfied.
    if ($portablePath.StartsWith("framework/", [StringComparison]::OrdinalIgnoreCase)) {
        return "Umicom Framework"
    }
    # Apply this branch only when its contract condition is satisfied.
    if ($portablePath.StartsWith("applications/studio/", [StringComparison]::OrdinalIgnoreCase)) {
        return "Umicom Studio IDE"
    }
    # Apply this branch only when its contract condition is satisfied.
    if ($portablePath.StartsWith("applications/trader/", [StringComparison]::OrdinalIgnoreCase)) {
        return "Umicom Trader"
    }
    # Apply this branch only when its contract condition is satisfied.
    if ($portablePath.StartsWith("applications/tms/", [StringComparison]::OrdinalIgnoreCase)) {
        return "Umicom TMS"
    }
    # Apply this branch only when its contract condition is satisfied.
    if ($portablePath.StartsWith("applications/bank/", [StringComparison]::OrdinalIgnoreCase)) {
        return "Umicom Bank"
    }
    # Apply this branch only when its contract condition is satisfied.
    if ($portablePath.StartsWith("applications/music/", [StringComparison]::OrdinalIgnoreCase)) {
        return "Umicom Music Studio"
    }
    # Apply this branch only when its contract condition is satisfied.
    if ($portablePath.StartsWith("applications/desktop/", [StringComparison]::OrdinalIgnoreCase)) {
        return "Umicom Desktop"
    }
    # Apply this branch only when its contract condition is satisfied.
    if ($portablePath.StartsWith("applications/os/", [StringComparison]::OrdinalIgnoreCase)) {
        return "Umicom OS"
    }
    return "Umicom Applications"
}

# Remove the outer repository prefix from a file label because application
# repositories are reviewed and committed independently as submodules.
function Get-UmicomOwnedFileLabel {
    param([Parameter(Mandatory)][string]$RelativePath)

    $portablePath = ConvertTo-UmicomPortablePath $RelativePath
    # Apply this branch only when its contract condition is satisfied.
    if ($portablePath.StartsWith("framework/", [StringComparison]::OrdinalIgnoreCase)) {
        return $portablePath.Substring("framework/".Length)
    }
    # Apply this branch only when its contract condition is satisfied.
    if ($portablePath.StartsWith("applications/", [StringComparison]::OrdinalIgnoreCase)) {
        $segments = $portablePath.Split('/')
        # Keep the operation inside its valid bounds before reading, writing or adding data.
        if ($segments.Length -ge 3) {
            return ($segments[2..($segments.Length - 1)] -join '/')
        }
    }
    return $portablePath
}

# Build a concise purpose from the file's role. The generated sentence is a
# starting explanation, while detailed behaviour remains beside each contract.
function Get-UmicomFilePurpose {
    param([Parameter(Mandatory)][string]$RelativePath)

    $portablePath = ConvertTo-UmicomPortablePath $RelativePath
    $name = [IO.Path]::GetFileNameWithoutExtension($portablePath)
    # Apply this branch only when its contract condition is satisfied.
    if ([IO.Path]::GetFileName($portablePath) -eq "CMakeLists.txt") {
        $name = Split-Path -Leaf (Split-Path -Parent $portablePath)
        # Apply this branch only when its contract condition is satisfied.
        if ([string]::IsNullOrWhiteSpace($name)) {
            $name = "suite"
        }
    }
    $subject = ConvertTo-UmicomWords $name
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($portablePath -match '(^|/)tests?(/|$)') {
        return "Verify the $subject behaviour and report a clear failure when its contract changes."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($portablePath -match '(^|/)include(/|$)' -or
        [IO.Path]::GetExtension($portablePath).Equals(".h", [StringComparison]::OrdinalIgnoreCase)) {
        return "Declare the $subject contract shared by Framework services and thin applications."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($portablePath -match '(^|/)templates?(/|$)') {
        return "Provide reusable $subject source for projects created with Umicom tooling."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ([IO.Path]::GetExtension($portablePath).Equals(".svg", [StringComparison]::OrdinalIgnoreCase)) {
        return "Store scalable $subject artwork with accessible metadata for every supported frontend."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ([IO.Path]::GetExtension($portablePath).Equals(".cmake", [StringComparison]::OrdinalIgnoreCase) -or
        [IO.Path]::GetFileName($portablePath) -eq "CMakeLists.txt") {
        return "Configure the $subject build rules without duplicating product logic."
    }
    # Apply this branch only when its contract condition is satisfied.
    if ([IO.Path]::GetExtension($portablePath) -in @(".ps1", ".sh")) {
        return "Provide readable $subject automation with explicit checks and failure messages."
    }
    return "Implement the $subject behaviour used by its public contract and client applications."
}

# Determine which comment syntax is accepted before any executable statement.
function Get-UmicomCommentStyle {
    param([Parameter(Mandatory)][string]$Path)

    $extension = [IO.Path]::GetExtension($Path).ToLowerInvariant()
    # Apply this branch only when its contract condition is satisfied.
    if ($extension -eq ".ps1") { return "PowerShell" }
    # Apply this branch only when its contract condition is satisfied.
    if ($extension -eq ".sh") { return "Hash" }
    # Apply this branch only when its contract condition is satisfied.
    if ($extension -eq ".cmake" -or [IO.Path]::GetFileName($Path) -eq "CMakeLists.txt") {
        return "Hash"
    }
    # Apply this branch only when its contract condition is satisfied.
    if ($extension -eq ".svg") { return "Xml" }
    return "C"
}

# Create the standard ownership header using the syntax required by the file.
function New-UmicomFileHeader {
    param(
        [Parameter(Mandatory)][string]$Owner,
        [Parameter(Mandatory)][string]$FileLabel,
        [Parameter(Mandatory)][string]$Purpose,
        [Parameter(Mandatory)][string]$Style
    )

    $purposeLines = @(Split-UmicomCommentText -Text $Purpose -Width 76)
    # Apply this branch only when its contract condition is satisfied.
    switch ($Style) {
        "PowerShell" {
            return @(
                "<#-----------------------------------------------------------------------------",
                " * $Owner",
                " * File: $FileLabel",
                " *",
                " * PURPOSE:"
            ) + @($purposeLines | ForEach-Object { " *   $_" }) + @(
                " *",
                " * AUTHOR AND ORGANISATION:",
                " * Sammy Hegab",
                " * Umicom Foundation",
                " *",
                " * LICENCE:",
                " * MIT",
                " *---------------------------------------------------------------------------#>"
            )
        }
        "Hash" {
            return @(
                "#-----------------------------------------------------------------------------",
                "# $Owner",
                "# File: $FileLabel",
                "#",
                "# PURPOSE:"
            ) + @($purposeLines | ForEach-Object { "#   $_" }) + @(
                "#",
                "# AUTHOR AND ORGANISATION:",
                "# Sammy Hegab",
                "# Umicom Foundation",
                "#",
                "# LICENCE:",
                "# MIT",
                "#-----------------------------------------------------------------------------"
            )
        }
        "Xml" {
            return @(
                "<!--",
                "  $Owner",
                "  File: $FileLabel",
                "",
                "  PURPOSE:"
            ) + @($purposeLines | ForEach-Object { "  $_" }) + @(
                "",
                "  AUTHOR AND ORGANISATION:",
                "  Sammy Hegab",
                "  Umicom Foundation",
                "",
                "  LICENCE:",
                "  MIT",
                "-->"
            )
        }
        default {
            return @(
                "/*-----------------------------------------------------------------------------",
                " * $Owner",
                " * File: $FileLabel",
                " *",
                " * PURPOSE:"
            ) + @($purposeLines | ForEach-Object { " *   $_" }) + @(
                " *",
                " * AUTHOR AND ORGANISATION:",
                " * Sammy Hegab",
                " * Umicom Foundation",
                " *",
                " * LICENCE:",
                " * MIT",
                " *---------------------------------------------------------------------------*/"
            )
        }
    }
}

# A complete header is recognised by its information rather than decoration,
# allowing older but accurate Umicom header styles to remain untouched.
function Test-UmicomStandardHeader {
    param([Parameter(Mandatory)][string]$Text)

    $prefixLength = [Math]::Min(8192, $Text.Length)
    $prefix = $Text.Substring(0, $prefixLength)
    return $prefix.Contains("File:") -and
        $prefix.Contains("PURPOSE:") -and
        $prefix.Contains("AUTHOR AND ORGANISATION:") -and
        $prefix.Contains("Sammy Hegab") -and
        $prefix.Contains("Umicom Foundation") -and
        $prefix.Contains("LICENCE:") -and
        $prefix.Contains("MIT")
}

# Remove strings and comments from one C-family line while preserving character
# positions. Stable positions let decision comments be inserted safely later.
function ConvertTo-UmicomCCodeView {
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$Line,
        [Parameter(Mandatory)][ref]$InsideBlockComment
    )

    $characters = $Line.ToCharArray()
    $result = [Text.StringBuilder]::new($Line.Length)
    $insideString = $false
    $insideCharacter = $false
    $escaped = $false
    # Visit each bounded item once so every record receives the same rule.
    for ($index = 0; $index -lt $characters.Length; ++$index) {
        $current = $characters[$index]
        $next = if ($index + 1 -lt $characters.Length) { $characters[$index + 1] } else { [char]0 }
        # Apply this branch only when its contract condition is satisfied.
        if ($InsideBlockComment.Value) {
            [void]$result.Append(' ')
            # Apply this branch only when its contract condition is satisfied.
            if ($current -eq '*' -and $next -eq '/') {
                [void]$result.Append(' ')
                ++$index
                $InsideBlockComment.Value = $false
            }
            continue
        }
        # Apply this branch only when its contract condition is satisfied.
        if ($insideString -or $insideCharacter) {
            [void]$result.Append(' ')
            # Apply this branch only when its contract condition is satisfied.
            if ($escaped) {
                $escaped = $false
                continue
            }
            # Apply this branch only when its contract condition is satisfied.
            if ($current -eq '\') {
                $escaped = $true
                continue
            }
            # Apply this branch only when its contract condition is satisfied.
            if (($insideString -and $current -eq '"') -or
                ($insideCharacter -and $current -eq "'")) {
                $insideString = $false
                $insideCharacter = $false
            }
            continue
        }
        # Apply this branch only when its contract condition is satisfied.
        if ($current -eq '/' -and $next -eq '*') {
            [void]$result.Append(' ')
            [void]$result.Append(' ')
            ++$index
            $InsideBlockComment.Value = $true
            continue
        }
        # Apply this branch only when its contract condition is satisfied.
        if ($current -eq '/' -and $next -eq '/') {
            # Continue only while work remains available; the loop body advances the state on each
            # pass.
            while ($index -lt $characters.Length) {
                [void]$result.Append(' ')
                ++$index
            }
            break
        }
        # Apply this branch only when its contract condition is satisfied.
        if ($current -eq '"') {
            $insideString = $true
            [void]$result.Append(' ')
            continue
        }
        # Apply this branch only when its contract condition is satisfied.
        if ($current -eq "'") {
            $insideCharacter = $true
            [void]$result.Append(' ')
            continue
        }
        [void]$result.Append($current)
    }
    return $result.ToString()
}

# Return true when the closest meaningful line is already a comment. Existing
# explanations are preserved even when their wording differs from newer style.
function Test-UmicomHasPreviousComment {
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][AllowEmptyString()][string[]]$Lines,
        [Parameter(Mandatory)][int]$LineIndex,
        [Parameter(Mandatory)][string]$Style
    )

    # Visit each bounded item once so every record receives the same rule.
    for ($index = $LineIndex - 1; $index -ge 0; --$index) {
        $trimmed = $Lines[$index].Trim()
        # Keep the operation inside its valid bounds before reading, writing or adding data.
        if ($trimmed.Length -eq 0) { continue }
        # Apply this branch only when its contract condition is satisfied.
        if ($Style -eq "Hash") { return $trimmed.StartsWith("#") }
        # Apply this branch only when its contract condition is satisfied.
        if ($Style -eq "PowerShell") {
            return $trimmed.StartsWith("#") -or $trimmed.EndsWith("#>")
        }
        # Apply this branch only when its contract condition is satisfied.
        if ($Style -eq "Xml") { return $trimmed.EndsWith("-->") }
        return $trimmed.EndsWith("*/") -or $trimmed.StartsWith("//")
    }
    return $false
}

# Derive a truthful operation summary from stable naming conventions used by
# Framework and application APIs. The result never changes the identifier.
function Get-UmicomFunctionExplanation {
    param(
        [Parameter(Mandatory)][string]$FunctionName,
        [Parameter(Mandatory)][string]$FilePath
    )

    $plainName = ConvertTo-UmicomWords $FunctionName
    $subject = $plainName -replace '^(umi|umicom) ', ''
    $subject = $subject -replace ' (init|initialize|create|dispose|destroy|release|clear|reset|is valid|validate|valid|find|lookup|selected|at|count|size|add|append|insert|register|remove|erase|unregister|copy|assign|set|load|read|parse|decode|save|write|encode|serialize|execute|run|dispatch|handle|apply)$', ''
    # Apply this branch only when its contract condition is satisfied.
    if ($FunctionName -eq "main") {
        return "Start this command or application, report setup failures, and return a process exit code to the operating system."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ([IO.Path]::GetExtension($FilePath).Equals(".cmake", [StringComparison]::OrdinalIgnoreCase) -or
        [IO.Path]::GetFileName($FilePath) -eq "CMakeLists.txt") {
        return "Define the $subject build helper so parent and application projects apply one consistent rule."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FunctionName -match '(_init|_initialize|_create)$') {
        return "Initialise $subject from caller-provided values so later operations receive a known state."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FunctionName -match '(_dispose|_destroy|_release|_clear|_reset)$') {
        return "Release or reset state held by $subject so the same storage can be reused safely."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FunctionName -match '(_is_valid|_validate|_valid)$') {
        return "Check that $subject satisfies its contract before another service relies on it."
    }
    # Preserve the original failure result so the caller can respond to the correct cause.
    if ($FunctionName -match '(_find|_lookup|_selected|_at)$') {
        return "Find $subject while leaving the underlying catalogue or model owned by this module."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FunctionName -match '(_count|_size)$') {
        return "Return the number of records represented by $subject without changing their state."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FunctionName -match '(_add|_append|_insert|_register)$') {
        return "Add $subject only after its inputs and available capacity have been checked."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FunctionName -match '(_remove|_erase|_unregister)$') {
        return "Remove $subject while keeping the remaining records in a valid and discoverable state."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FunctionName -match '(_copy|_assign|_set)$') {
        return "Copy $subject into module-owned storage so callers keep ownership of their input values."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FunctionName -match '(_load|_read|_parse|_decode)$') {
        return "Read $subject into validated module state and return a status when input cannot be used."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FunctionName -match '(_save|_write|_encode|_serialize)$') {
        return "Write $subject in its stable representation and report capacity or input failures to the caller."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FunctionName -match '(_execute|_run|_dispatch|_handle|_apply)$') {
        return "Perform $subject through the module contract so client applications do not duplicate its policy."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($FilePath -match '(^|[\\/])tests?([\\/]|$)') {
        return "Exercise $subject and return a clear result when the behaviour no longer matches its contract."
    }
    return "Provide the $subject operation used by this module and its client applications."
}

# Explain why a control-flow decision exists. The wording uses clues from the
# condition, but stays valid when variable names differ between modules.
function Get-UmicomDecisionExplanation {
    param(
        [Parameter(Mandatory)][string]$Keyword,
        [Parameter(Mandatory)][string]$Code
    )

    $normalised = $Code.ToLowerInvariant()
    # Apply this branch only when its contract condition is satisfied.
    if ($Keyword -eq "else") {
        return "Use this fallback path when the earlier condition does not apply."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match '^if\s*\(not\s+target\b') {
        return "Load the dependency only when the parent build has not already provided its target."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match '^if\s*\(not\s+command\b') {
        return "Define the local fallback only when the parent build did not provide the shared helper."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match '^if\s*\(command\b') {
        return "Use the shared build helper when it is available from the parent composition."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match '^if\s*\(build_testing\b') {
        return "Register verification targets only when the developer has enabled testing."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match '^if\s*\(exists\b') {
        return "Use the optional file only when it is present in this checkout."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match '^if\s*\(target\b') {
        return "Configure the optional target only when its feature has created it."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match '^if\s*\(msvc\b') {
        return "Select the warning options understood by the active compiler."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match '^if\s*\([^\)]*build[_a-z0-9]*\)') {
        return "Create this optional product surface only when its build option is enabled."
    }
    # Apply this branch only when its contract condition is satisfied.
    switch -Regex ($Keyword) {
        '^for$' {
            return "Visit each bounded item once so every record receives the same rule."
        }
        '^while$' {
            return "Continue only while work remains available; the loop body advances the state on each pass."
        }
        '^switch$' {
            return "Select the behaviour associated with the requested command or state value."
        }
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match '==\s*null|!=\s*null') {
        return "Protect caller-owned memory by checking that required state is available before it is used."
    }
    # Keep the operation inside its valid bounds before reading, writing or adding data.
    if ($normalised -match '\b(capacity|count|size|length|index|maximum|minimum|limit)\b|>=|<=') {
        return "Keep the operation inside its valid bounds before reading, writing or adding data."
    }
    # Preserve the original failure result so the caller can respond to the correct cause.
    if ($normalised -match 'status|result|error|failed|ok') {
        return "Preserve the original failure result so the caller can respond to the correct cause."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match 'strcmp|strncmp|match|equal|identifier|_id') {
        return "Use the stable identifier comparison to choose the matching record or policy."
    }
    # Use the stable identifier comparison to choose the matching record or policy.
    if ($normalised -match 'enabled|visible|active|ready|valid|supported|allowed') {
        return "Apply this operation only while the related capability or state is available."
    }
    return "Apply this branch only when its contract condition is satisfied."
}

# Discover top-level C function declarations and definitions. The scanner is
# conservative: uncertain macro and initializer syntax is left for review.
function Get-UmicomCFunctionCandidates {
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][AllowEmptyString()][string[]]$Lines,
        [Parameter(Mandatory)][AllowEmptyCollection()][AllowEmptyString()][string[]]$CodeLines,
        [switch]$AllowNestedDeclarations
    )

    $candidates = [Collections.Generic.List[object]]::new()
    $braceDepth = 0
    $lineIndex = 0
    # Continue only while work remains available; the loop body advances the state on each
    # pass.
    while ($lineIndex -lt $CodeLines.Count) {
        $code = $CodeLines[$lineIndex]
        $trimmed = $code.Trim()
        # Apply this branch only when its contract condition is satisfied.
        if (($braceDepth -eq 0 -or $AllowNestedDeclarations) -and
            $code -match '^[A-Za-z_]' -and
            $trimmed -notmatch '^(typedef|return|case|sizeof|_Static_assert)\b' -and
            $trimmed -notmatch '^#') {
            $declaration = $code
            $endIndex = $lineIndex
            # Continue only while work remains available; the loop body advances the state on each
            # pass.
            while ($endIndex + 1 -lt $CodeLines.Count -and
                   $declaration -notmatch '[;{]' -and
                   $endIndex - $lineIndex -lt 40) {
                ++$endIndex
                $declaration += "`n" + $CodeLines[$endIndex]
            }
            $open = $declaration.IndexOf('(')
            # Apply this branch only when its contract condition is satisfied.
            if ($open -gt 0) {
                $prefix = $declaration.Substring(0, $open)
                $nameMatch = [regex]::Match($prefix, '([A-Za-z_][A-Za-z0-9_]*)\s*$')
                # Use the stable identifier comparison to choose the matching record or policy.
                if ($nameMatch.Success -and $prefix -match '[\s*]' -and
                    $prefix -notmatch '=' -and $declaration -match '\)\s*(?:;|\{)') {
                    $name = $nameMatch.Groups[1].Value
                    # Apply this branch only when its contract condition is satisfied.
                    if ($name -notin @("if", "for", "while", "switch")) {
                        $candidates.Add([PSCustomObject]@{
                            LineIndex = $lineIndex
                            Name = $name
                        })
                    }
                }
            }
        }
        $opens = ([regex]::Matches($code, '\{')).Count
        $closes = ([regex]::Matches($code, '\}')).Count
        $braceDepth = [Math]::Max(0, $braceDepth + $opens - $closes)
        ++$lineIndex
    }
    return $candidates
}

# Create insertions for C functions, public contract types and control flow.
# Insertions are returned separately so the original code never changes during
# analysis and line numbers remain stable.
function Get-UmicomCInsertions {
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][AllowEmptyString()][string[]]$Lines,
        [Parameter(Mandatory)][string]$FilePath
    )

    $insertions = [Collections.Generic.List[object]]::new()
    $codeLines = [Collections.Generic.List[string]]::new()
    $insideBlockComment = $false
    $insideMacro = $false
    # Visit each bounded item once so every record receives the same rule.
    foreach ($line in $Lines) {
        $codeLine = ConvertTo-UmicomCCodeView -Line $line -InsideBlockComment ([ref]$insideBlockComment)
        $codeLines.Add($codeLine)
    }

    $isHeader = [IO.Path]::GetExtension($FilePath).Equals(".h", [StringComparison]::OrdinalIgnoreCase)
    $functionCandidates = Get-UmicomCFunctionCandidates -Lines $Lines -CodeLines $codeLines -AllowNestedDeclarations:$isHeader
    # Visit each bounded item once so every record receives the same rule.
    foreach ($candidate in $functionCandidates) {
        # Apply this branch only when its contract condition is satisfied.
        if (-not (Test-UmicomHasPreviousComment -Lines $Lines -LineIndex $candidate.LineIndex -Style "C")) {
            $explanation = Get-UmicomFunctionExplanation -FunctionName $candidate.Name -FilePath $FilePath
            $structured = $isHeader
            $comment = @(New-UmicomCComment -Text $explanation -Structured:$structured)
            $insertions.Add([PSCustomObject]@{
                LineIndex = $candidate.LineIndex
                Column = 0
                Lines = $comment
                Kind = "Function"
            })
        }
    }

    # Public structures and enumerations are contracts too. One structured
    # comment explains the whole block without repeating every field name.
    if ([IO.Path]::GetExtension($FilePath).Equals(".h", [StringComparison]::OrdinalIgnoreCase)) {
        # Visit each bounded item once so every record receives the same rule.
        for ($index = 0; $index -lt $codeLines.Count; ++$index) {
            # Keep the operation inside its valid bounds before reading, writing or adding data.
            if ($codeLines[$index] -match '^\s*typedef\s+(struct|enum)\s+([A-Za-z_][A-Za-z0-9_]*)') {
                # Keep the operation inside its valid bounds before reading, writing or adding data.
                if (-not (Test-UmicomHasPreviousComment -Lines $Lines -LineIndex $index -Style "C")) {
                    $kind = $Matches[1]
                    $name = (ConvertTo-UmicomWords $Matches[2]) -replace '^umi ', ''
                    $explanation = if ($kind -eq "enum") {
                        "List the named $name values accepted by this public contract."
                    } else {
                        "Represent the $name data shared with callers of this public contract."
                    }
                    $insertions.Add([PSCustomObject]@{
                        LineIndex = $index
                        Column = 0
                        Lines = @(New-UmicomCComment -Text $explanation -Structured)
                        Kind = "Contract"
                    })
                }
            }
        }
    }

    # Track macro continuations because inserting an ordinary source line in a
    # multi-line macro would change where the preprocessor ends the definition.
    for ($index = 0; $index -lt $codeLines.Count; ++$index) {
        $code = $codeLines[$index]
        $trimmed = $code.Trim()
        # Use the stable identifier comparison to choose the matching record or policy.
        if (-not $insideMacro -and $trimmed -match '^#\s*define\b' -and $trimmed.EndsWith('\')) {
            $insideMacro = $true
        }
        # Apply this branch only when its contract condition is satisfied.
        if (-not $insideMacro -and -not $trimmed.StartsWith("#")) {
            $decisionMatches = [regex]::Matches(
                $code,
                '\b(if|for|while|switch)\s*\(|\belse\b(?!\s*if)')
            # Visit each bounded item once so every record receives the same rule.
            foreach ($decisionMatch in $decisionMatches) {
                $keyword = if ($decisionMatch.Groups[1].Success) {
                    $decisionMatch.Groups[1].Value
                } else {
                    "else"
                }
                $before = $code.Substring(0, $decisionMatch.Index)
                $hasInlineComment = $Lines[$index].Substring(0, [Math]::Min($decisionMatch.Index, $Lines[$index].Length)) -match '/\*|//'
                # Apply this branch only when its contract condition is satisfied.
                if ($hasInlineComment) { continue }
                # Keep the operation inside its valid bounds before reading, writing or adding data.
                if ($before.Trim().Length -eq 0) {
                    # Keep the operation inside its valid bounds before reading, writing or adding data.
                    if (Test-UmicomHasPreviousComment -Lines $Lines -LineIndex $index -Style "C") { continue }
                    $indent = $Lines[$index].Substring(0, $Lines[$index].Length - $Lines[$index].TrimStart().Length)
                    $explanation = Get-UmicomDecisionExplanation -Keyword $keyword -Code $trimmed
                    $insertions.Add([PSCustomObject]@{
                        LineIndex = $index
                        Column = 0
                        Lines = @(New-UmicomCComment -Text $explanation -Indent $indent)
                        Kind = "Decision"
                    })
                } else {
                    $explanation = Get-UmicomDecisionExplanation -Keyword $keyword -Code $trimmed
                    $insertions.Add([PSCustomObject]@{
                        LineIndex = $index
                        Column = $decisionMatch.Index
                        Lines = @("/* $explanation */ ")
                        Kind = "InlineDecision"
                    })
                }
            }
        }
        # Apply this branch only when its contract condition is satisfied.
        if ($insideMacro -and -not $trimmed.EndsWith('\')) {
            $insideMacro = $false
        }
    }
    return $insertions
}

# Explain functions and decisions in CMake, PowerShell and shell scripts. Only
# line-leading statements are changed, avoiding here-documents and arguments.
function Get-UmicomScriptInsertions {
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][AllowEmptyString()][string[]]$Lines,
        [Parameter(Mandatory)][string]$FilePath,
        [Parameter(Mandatory)][string]$Style
    )

    $insertions = [Collections.Generic.List[object]]::new()
    # Visit each bounded item once so every record receives the same rule.
    for ($index = 0; $index -lt $Lines.Count; ++$index) {
        $trimmed = $Lines[$index].Trim()
        $functionName = $null
        # Use the stable identifier comparison to choose the matching record or policy.
        if ($Style -eq "PowerShell" -and $trimmed -match '^function\s+([A-Za-z0-9_-]+)') {
            $functionName = $Matches[1]
        } elseif ($Style -eq "Hash" -and [IO.Path]::GetExtension($FilePath) -eq ".sh" -and
                  $trimmed -match '^([A-Za-z_][A-Za-z0-9_]*)\s*\(\)\s*\{') {
            $functionName = $Matches[1]
        } elseif ($Style -eq "Hash" -and $trimmed -match '^function\s*\(\s*([^\s\)]+)') {
            $functionName = $Matches[1]
        }
        # Apply this branch only when its contract condition is satisfied.
        if ($null -ne $functionName -and
            -not (Test-UmicomHasPreviousComment -Lines $Lines -LineIndex $index -Style $Style)) {
            $indent = $Lines[$index].Substring(0, $Lines[$index].Length - $Lines[$index].TrimStart().Length)
            $explanation = Get-UmicomFunctionExplanation -FunctionName $functionName -FilePath $FilePath
            $insertions.Add([PSCustomObject]@{
                LineIndex = $index
                Column = 0
                Lines = @(New-UmicomHashComment -Text $explanation -Indent $indent)
                Kind = "Function"
            })
        }

        $decisionKeyword = $null
        # Use the stable identifier comparison to choose the matching record or policy.
        if ($trimmed -match '^(if|elseif|elif|else|foreach|for|while|switch|case)\b') {
            $decisionKeyword = $Matches[1]
        }
        # Apply this branch only when its contract condition is satisfied.
        if ($null -ne $decisionKeyword -and
            -not (Test-UmicomHasPreviousComment -Lines $Lines -LineIndex $index -Style $Style)) {
            $indent = $Lines[$index].Substring(0, $Lines[$index].Length - $Lines[$index].TrimStart().Length)
            # Apply this branch only when its contract condition is satisfied.
            if ($decisionKeyword -eq "else") {
                $explanation = "Use this fallback path when the earlier condition does not apply."
            } else {
                $mappedKeyword = if ($decisionKeyword -in @("foreach", "for")) { "for" } elseif ($decisionKeyword -eq "while") { "while" } else { "if" }
                $explanation = Get-UmicomDecisionExplanation -Keyword $mappedKeyword -Code $trimmed
            }
            $insertions.Add([PSCustomObject]@{
                LineIndex = $index
                Column = 0
                Lines = @(New-UmicomHashComment -Text $explanation -Indent $indent)
                Kind = "Decision"
            })
        }
    }
    return $insertions
}

# Apply insertions from the end of a file to the beginning. Reversing the order
# prevents one insertion from invalidating another insertion's original index.
function Add-UmicomInsertions {
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][AllowEmptyString()]
        [Collections.Generic.List[string]]$Lines,
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Insertions
    )

    $ordered = $Insertions | Sort-Object LineIndex, Column -Descending
    # Visit each bounded item once so every record receives the same rule.
    foreach ($insertion in $ordered) {
        $commentLines = @($insertion.Lines)
        # Apply this branch only when its contract condition is satisfied.
        if ($insertion.Column -gt 0) {
            $line = $Lines[$insertion.LineIndex]
            $prefix = $line.Substring(0, $insertion.Column)
            $suffix = $line.Substring($insertion.Column)
            $Lines[$insertion.LineIndex] = $prefix + $commentLines[0] + $suffix
            continue
        }
        # Visit each bounded item once so every record receives the same rule.
        for ($commentIndex = $commentLines.Count - 1; $commentIndex -ge 0; --$commentIndex) {
            $Lines.Insert($insertion.LineIndex, $commentLines[$commentIndex])
        }
    }
}

# Locate project-owned source while excluding generated and dependency trees.
function Get-UmicomSourceFiles {
    param([Parameter(Mandatory)][string]$Root)

    $files = Get-ChildItem -LiteralPath $Root -Recurse -File
    return @($files | Where-Object {
        $relative = [IO.Path]::GetRelativePath($Root, $_.FullName)
        $segments = $relative -split '[\\/]'
        $isExcluded = @($segments | Where-Object { $_ -in $ExcludedFolderNames }).Count -gt 0
        $isTemplate = @($segments | Where-Object { $_ -in @("template", "templates") }).Count -gt 0
        $isSupported = $_.Name -eq "CMakeLists.txt" -or $_.Extension.ToLowerInvariant() -in $AuditedExtensions
        return -not $isExcluded -and ($IncludeTemplates -or -not $isTemplate) -and $isSupported
    } | Sort-Object FullName)
}

# Read, audit and optionally update one file. Existing content is retained and
# only missing comments are inserted; code tokens are never removed or renamed.
function Invoke-UmicomFileDocumentation {
    param(
        [Parameter(Mandatory)][IO.FileInfo]$File,
        [Parameter(Mandatory)][string]$Root,
        [Parameter(Mandatory)][string]$RequestedMode
    )

    $relativePath = [IO.Path]::GetRelativePath($Root, $File.FullName)
    $style = Get-UmicomCommentStyle $File.FullName
    $bytes = [IO.File]::ReadAllBytes($File.FullName)
    $hasUtf8Bom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    $text = [Text.Encoding]::UTF8.GetString($bytes, $(if ($hasUtf8Bom) { 3 } else { 0 }), $bytes.Length - $(if ($hasUtf8Bom) { 3 } else { 0 }))
    $newline = if ($text.Contains("`r`n")) { "`r`n" } else { "`n" }
    $hadFinalNewline = $text.EndsWith("`n")
    $normalised = $text.Replace("`r`n", "`n").Replace("`r", "`n")
    $lineArray = $normalised.Split("`n")
    # Keep the operation inside its valid bounds before reading, writing or adding data.
    if ($hadFinalNewline -and $lineArray.Count -gt 0 -and $lineArray[-1] -eq "") {
        $lineArray = $lineArray[0..($lineArray.Count - 2)]
    }
    $lines = [Collections.Generic.List[string]]::new()
    # Visit each bounded item once so every record receives the same rule.
    foreach ($line in $lineArray) { $lines.Add($line) }

    $headerMissing = -not (Test-UmicomStandardHeader $text)
    $insertions = @()
    $extension = $File.Extension.ToLowerInvariant()
    # Apply this branch only when its contract condition is satisfied.
    if ($extension -in @(".c", ".h", ".cpp", ".inc")) {
        $insertions = @(Get-UmicomCInsertions -Lines $lines.ToArray() -FilePath $relativePath)
    } elseif ($extension -in @(".ps1", ".sh", ".cmake") -or $File.Name -eq "CMakeLists.txt") {
        $insertions = @(Get-UmicomScriptInsertions -Lines $lines.ToArray() -FilePath $relativePath -Style $style)
    }

    $findingCount = $insertions.Count + $(if ($headerMissing) { 1 } else { 0 })
    # Apply this branch only when its contract condition is satisfied.
    if ($findingCount -eq 0) {
        return [PSCustomObject]@{ Path=$relativePath; Findings=0; Changed=$false }
    }
    # Apply this branch only when its contract condition is satisfied.
    if ($RequestedMode -eq "Apply" -and $PSCmdlet.ShouldProcess($relativePath, "add missing Umicom documentation")) {
        Add-UmicomInsertions -Lines $lines -Insertions $insertions
        # Apply this branch only when its contract condition is satisfied.
        if ($headerMissing) {
            $owner = Get-UmicomOwner $relativePath
            $label = Get-UmicomOwnedFileLabel $relativePath
            $purpose = Get-UmicomFilePurpose $relativePath
            $header = New-UmicomFileHeader -Owner $owner -FileLabel $label -Purpose $purpose -Style $style
            $headerIndex = 0
            # Apply this branch only when its contract condition is satisfied.
            if ($style -eq "Hash" -and $extension -eq ".sh" -and
                $lines.Count -gt 0 -and $lines[0].StartsWith("#!")) {
                $headerIndex = 1
            } elseif ($style -eq "Xml" -and $lines.Count -gt 0 -and
                      $lines[0].StartsWith("<?xml")) {
                $headerIndex = 1
            }
            # Visit each bounded item once so every record receives the same rule.
            for ($index = $header.Count - 1; $index -ge 0; --$index) {
                $lines.Insert($headerIndex, $header[$index])
            }
            $lines.Insert($headerIndex + $header.Count, "")
        }
        $output = [string]::Join($newline, $lines)
        # Apply this branch only when its contract condition is satisfied.
        if ($hadFinalNewline) { $output += $newline }
        $encoding = [Text.UTF8Encoding]::new($hasUtf8Bom)
        [IO.File]::WriteAllText($File.FullName, $output, $encoding)
        return [PSCustomObject]@{ Path=$relativePath; Findings=$findingCount; Changed=$true }
    }
    return [PSCustomObject]@{ Path=$relativePath; Findings=$findingCount; Changed=$false }
}

# Refuse an incorrect root early because a recursive documentation pass must
# never wander into a developer's broader filesystem by mistake.
$resolvedRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
# Apply this branch only when its contract condition is satisfied.
if (-not (Test-Path -LiteralPath (Join-Path $resolvedRoot "framework")) -or
    -not (Test-Path -LiteralPath (Join-Path $resolvedRoot "applications"))) {
    throw "ProjectRoot must contain the framework and applications directories: $resolvedRoot"
}

$sourceFiles = Get-UmicomSourceFiles -Root $resolvedRoot
# A path filter supports focused review while the default still audits the
# complete repository. Prefixes use repository-relative portable paths.
if ($PathPrefix.Count -gt 0) {
    $portablePrefixes = @($PathPrefix | ForEach-Object {
        (ConvertTo-UmicomPortablePath $_).TrimStart('/')
    })
    $sourceFiles = @($sourceFiles | Where-Object {
        $relative = ConvertTo-UmicomPortablePath (
            [IO.Path]::GetRelativePath($resolvedRoot, $_.FullName))
        @($portablePrefixes | Where-Object {
            $relative.StartsWith($_, [StringComparison]::OrdinalIgnoreCase)
        }).Count -gt 0
    })
}
$results = [Collections.Generic.List[object]]::new()
# Visit each bounded item once so every record receives the same rule.
foreach ($sourceFile in $sourceFiles) {
    $result = Invoke-UmicomFileDocumentation -File $sourceFile -Root $resolvedRoot -RequestedMode $Mode
    $results.Add($result)
}

$filesWithFindings = @($results | Where-Object { $_.Findings -gt 0 })
$changedFiles = @($results | Where-Object { $_.Changed })
$findingTotal = ($results | Measure-Object Findings -Sum).Sum
# Apply this branch only when its contract condition is satisfied.
if ($null -eq $findingTotal) { $findingTotal = 0 }

Write-Host "Umicom source documentation"
Write-Host "  Files scanned:       $($sourceFiles.Count)"
Write-Host "  Files with findings: $($filesWithFindings.Count)"
Write-Host "  Missing explanations: $findingTotal"
Write-Host "  Files updated:       $($changedFiles.Count)"

# Audit mode returns a failure when work remains so it can protect future pull
# requests. Apply mode reports success after writing the requested update.
if ($Mode -eq "Audit" -and $findingTotal -gt 0) {
    $filesWithFindings | Select-Object -First 100 | ForEach-Object {
        Write-Host "  [NEEDS DOCUMENTATION] $($_.Path) ($($_.Findings))"
    }
    # Keep the operation inside its valid bounds before reading, writing or adding data.
    if ($filesWithFindings.Count -gt 100) {
        Write-Host "  ... and $($filesWithFindings.Count - 100) more files."
    }
    exit 1
}
