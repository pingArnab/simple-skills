[CmdletBinding()]
param(
    [ValidateSet("all", "ask-first", "demo-first")]
    [string]$Skill = "all",

    [ValidateSet("auto", "agents", "codex", "claude", "copilot", "all")]
    [string]$Harness = "auto",

    [string]$Project = ".",
    [string]$Target,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Get-SkillNames {
    if ($Skill -eq "all") { return @("ask-first", "demo-first") }
    return @($Skill)
}

function Get-InstallRoots {
    param([string]$ProjectPath)

    if ($Target) {
        if ([IO.Path]::IsPathRooted($Target)) {
            return @([IO.Path]::GetFullPath($Target))
        }
        return @([IO.Path]::GetFullPath((Join-Path $ProjectPath $Target)))
    }

    switch ($Harness) {
        "agents" { return @(Join-Path $ProjectPath ".agents\skills") }
        "codex" { return @(Join-Path $ProjectPath ".agents\skills") }
        "claude" { return @(Join-Path $ProjectPath ".claude\skills") }
        "copilot" { return @(Join-Path $ProjectPath ".github\skills") }
        "all" {
            return @(
                (Join-Path $ProjectPath ".agents\skills"),
                (Join-Path $ProjectPath ".claude\skills"),
                (Join-Path $ProjectPath ".github\skills")
            )
        }
        "auto" {
            $roots = @()
            if (Test-Path -LiteralPath (Join-Path $ProjectPath ".agents")) {
                $roots += Join-Path $ProjectPath ".agents\skills"
            }
            if (Test-Path -LiteralPath (Join-Path $ProjectPath ".claude")) {
                $roots += Join-Path $ProjectPath ".claude\skills"
            }
            if (Test-Path -LiteralPath (Join-Path $ProjectPath ".github\skills")) {
                $roots += Join-Path $ProjectPath ".github\skills"
            }
            if ($roots.Count -eq 0) {
                $roots = @(Join-Path $ProjectPath ".agents\skills")
            }
            return @($roots | Select-Object -Unique)
        }
    }
}

$projectPath = (Get-Item -LiteralPath $Project).FullName
$sourceRoot = Join-Path $PSScriptRoot "skills"
$skillNames = Get-SkillNames
$installRoots = Get-InstallRoots -ProjectPath $projectPath

foreach ($name in $skillNames) {
    $source = Join-Path $sourceRoot $name
    if (-not (Test-Path -LiteralPath (Join-Path $source "SKILL.md"))) {
        throw "Packaged skill is missing: $source"
    }
}

foreach ($root in $installRoots) {
    foreach ($name in $skillNames) {
        $destination = Join-Path $root $name
        if ((Test-Path -LiteralPath $destination) -and -not $Force) {
            throw "Skill already exists at '$destination'. Re-run with -Force to replace it."
        }
    }
}

foreach ($root in $installRoots) {
    New-Item -ItemType Directory -Path $root -Force | Out-Null
    foreach ($name in $skillNames) {
        $source = Join-Path $sourceRoot $name
        $destination = Join-Path $root $name
        if (Test-Path -LiteralPath $destination) {
            Remove-Item -LiteralPath $destination -Recurse -Force
        }
        Copy-Item -LiteralPath $source -Destination $destination -Recurse
        Write-Output "Installed $name -> $destination"
    }
}
