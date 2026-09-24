<#
.SYNOPSIS
    Generate SHA-256 Hashes for DEV Tools Suite BAT Files
.DESCRIPTION
    Scans the six BAT tools, calculates SHA-256 hashes, and writes release/hashes.txt.
    Provider: AnoS
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Split-Path -Parent $ScriptDir
$ReleaseDir = Join-Path $RepoRoot 'release'

if (-not (Test-Path -LiteralPath $ReleaseDir)) {
    New-Item -ItemType Directory -Path $ReleaseDir -Force | Out-Null
}

$OutputFile = Join-Path $ReleaseDir 'hashes.txt'
$ToolsJsonPath = Join-Path $RepoRoot 'site\data\tools.json'

$Tools = @(
    @{ Id = 'setup';   Path = 'tools\dev-setup-center\DevSetupCenter.bat' },
    @{ Id = 'forge';   Path = 'tools\dev-project-forge\DevProjectForge.bat' },
    @{ Id = 'doctor';  Path = 'tools\dev-doctor\DevDoctor.bat' },
    @{ Id = 'github';  Path = 'tools\dev-github-toolkit\DevGitHubToolkit.bat' },
    @{ Id = 'package'; Path = 'tools\dev-package-hub\DevPackageHub.bat' },
    @{ Id = 'system';  Path = 'tools\dev-system-toolkit\DevSystemToolkit.bat' }
)

Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host "     DEV TOOLS SUITE :: SHA-256 HASH GENERATOR" -ForegroundColor White
Write-Host "     Provider: AnoS" -ForegroundColor Gray
Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host ""

$HashLines = @(
    "# DEV Tools Suite - SHA-256 Release Hashes",
    "# Provider: AnoS",
    "# Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "#"
)

$HashMap = @{}

foreach ($t in $Tools) {
    $fullPath = Join-Path $RepoRoot $t.Path
    if (-not (Test-Path -LiteralPath $fullPath)) {
        Write-Error "Tool file not found: $fullPath"
        continue
    }

    $hashObj = Get-FileHash -Path $fullPath -Algorithm SHA256
    $hashVal = $hashObj.Hash
    $fileName = Split-Path -Leaf $fullPath
    $fileSize = (Get-Item $fullPath).Length

    $HashMap[$t.Id] = $hashVal
    $entry = "$hashVal  $($t.Path.Replace('\', '/'))"
    $HashLines += $entry

    $shortHash = $hashVal.Substring(0, 16) + "..."
    Write-Host ("  [HASHED] {0,-22} : {1} ({2:N0} bytes)" -f $fileName, $shortHash, $fileSize) -ForegroundColor Green
}

$HashLines | Set-Content -Path $OutputFile -Encoding UTF8
Write-Host ""
Write-Host "  [OK] Release hashes saved to: $OutputFile" -ForegroundColor Green

# Update site/data/tools.json with calculated hashes
if (Test-Path -LiteralPath $ToolsJsonPath) {
    try {
        $jsonContent = Get-Content -Path $ToolsJsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($toolEntry in $jsonContent.tools) {
            if ($HashMap.ContainsKey($toolEntry.shortId)) {
                $toolEntry | Add-Member -NotePropertyName "sha256" -NotePropertyValue $HashMap[$toolEntry.shortId] -Force
            }
        }
        $updatedJson = $jsonContent | ConvertTo-Json -Depth 10
        [IO.File]::WriteAllText($ToolsJsonPath, $updatedJson, [Text.Encoding]::UTF8)
        Write-Host "  [OK] Synchronized SHA-256 hashes into site/data/tools.json" -ForegroundColor Green
    } catch {
        Write-Warning "Could not update tools.json: $($_.Exception.Message)"
    }
}

Write-Host ""
