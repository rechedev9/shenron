[CmdletBinding()]
param(
    [ValidateSet("codex", "claude", "both")]
    [string]$Target = "codex",

    [string]$CodexHome = $(if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }),

    [string]$ClaudeHome = $(if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $env:USERPROFILE ".claude" })
)

$ErrorActionPreference = "Stop"
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$skillNames = @("shenron", "e2e-qa-team")

foreach ($skillName in $skillNames) {
    $manifest = Join-Path $scriptRoot "skills\$skillName\SKILL.md"
    if (-not (Test-Path -LiteralPath $manifest -PathType Leaf)) {
        throw "Missing skill manifest: $manifest"
    }
}

function Install-ShenronSkill {
    param(
        [Parameter(Mandatory)]
        [string]$ProductHome,

        [Parameter(Mandatory)]
        [string]$SkillName
    )

    $resolvedHome = [System.IO.Path]::GetFullPath($ProductHome)
    $skillsDirectory = Join-Path $resolvedHome "skills"
    $destination = Join-Path $skillsDirectory $SkillName
    $backupRoot = Join-Path $resolvedHome ".shenron-backups\$timestamp"
    $source = Join-Path $scriptRoot "skills\$SkillName"

    New-Item -ItemType Directory -Force -Path $skillsDirectory | Out-Null

    if (Test-Path -LiteralPath $destination) {
        New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
        $backupDestination = Join-Path $backupRoot $SkillName
        Move-Item -LiteralPath $destination -Destination $backupDestination
        Write-Host "Backed up $destination to $backupDestination"
    }

    Copy-Item -LiteralPath $source -Destination $destination -Recurse
    Write-Host "Installed $SkillName to $destination"
}

if ($Target -in @("codex", "both")) {
    foreach ($skillName in $skillNames) {
        Install-ShenronSkill -ProductHome $CodexHome -SkillName $skillName
    }
}

if ($Target -in @("claude", "both")) {
    foreach ($skillName in $skillNames) {
        Install-ShenronSkill -ProductHome $ClaudeHome -SkillName $skillName
    }
}

Write-Host "Shenron installation complete."
