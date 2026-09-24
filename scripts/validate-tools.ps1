<#
.SYNOPSIS
    Validation Script for DEV Tools Suite
.DESCRIPTION
    Performs comprehensive static integrity, syntax, metadata, and path checks.
    Provider: AnoS
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Split-Path -Parent $ScriptDir

$ExpectedVersion = '1.0.0'
$ExpectedProvider = 'AnoS'

Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host "     DEV TOOLS SUITE :: COMPREHENSIVE VALIDATION" -ForegroundColor White
Write-Host "     Provider: $ExpectedProvider | Version: $ExpectedVersion" -ForegroundColor Gray
Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host ""

$Passed = 0
$Failed = 0

function Assert-Check {
    param(
        [string]$Title,
        [bool]$Condition,
        [string]$FailMessage = "Assertion failed."
    )
    if ($Condition) {
        Write-Host "  [PASS] $Title" -ForegroundColor Green
        $script:Passed++
    } else {
        Write-Host "  [FAIL] $Title - $FailMessage" -ForegroundColor Red
        $script:Failed++
    }
}

# 1. BAT Files Existence & Size
$Tools = @(
    'tools/dev-setup-center/DevSetupCenter.bat',
    'tools/dev-project-forge/DevProjectForge.bat',
    'tools/dev-doctor/DevDoctor.bat',
    'tools/dev-github-toolkit/DevGitHubToolkit.bat',
    'tools/dev-package-hub/DevPackageHub.bat',
    'tools/dev-system-toolkit/DevSystemToolkit.bat',
    'tools/dev-file-organizer/DevFileOrganizer.bat',
    'tools/dev-clean-master/DevCleanMaster.bat',
    'tools/dev-quick-server/DevQuickServer.bat',
    'tools/dev-key-forge/DevKeyForge.bat'
)

Write-Host "[1/6] Validating Standalone BAT Tools..." -ForegroundColor Cyan
foreach ($rel in $Tools) {
    $full = Join-Path $RepoRoot ($rel.Replace('/', '\'))
    $exists = Test-Path -LiteralPath $full
    $size = if ($exists) { (Get-Item $full).Length } else { 0 }
    Assert-Check "Tool exists: $rel" ($exists -and $size -gt 1000) "File missing or under 1000 bytes ($size bytes)"
    
    # Check BAT header syntax
    if ($exists) {
        $content = Get-Content -Path $full -TotalCount 10
        $hasEchoOff = ($content | Select-String -Pattern '^@echo off').Count -gt 0
        $hasProvider = ($content | Select-String -Pattern "Provider: $ExpectedProvider").Count -gt 0
        Assert-Check "Header '@echo off' in $rel" $hasEchoOff "Missing standard @echo off header"
        Assert-Check "Branding 'AnoS' in $rel" $hasProvider "Missing provider AnoS comment"
    }
}

# 2. Companion Launchers
Write-Host ""
Write-Host "[2/6] Validating Companion PowerShell Launchers..." -ForegroundColor Cyan
foreach ($rel in $Tools) {
    $parent = Split-Path -Parent $rel
    $launchPs = Join-Path $RepoRoot ($parent.Replace('/', '\') + '\launch.ps1')
    Assert-Check "Companion launcher: $parent/launch.ps1" (Test-Path -LiteralPath $launchPs) "Missing launch.ps1"
}

# 3. Central Web Launcher
Write-Host ""
Write-Host "[3/6] Validating Unified Web Launcher..." -ForegroundColor Cyan
$launcherPath = Join-Path $RepoRoot 'launcher\DevLauncher.ps1'
Assert-Check "Central launcher exists: launcher/DevLauncher.ps1" (Test-Path -LiteralPath $launcherPath)
if (Test-Path -LiteralPath $launcherPath) {
    $lContent = Get-Content -Path $launcherPath -Raw
    Assert-Check "Launcher contains all 10 tool aliases" ($lContent -match 'setup' -and $lContent -match 'forge' -and $lContent -match 'doctor' -and $lContent -match 'github' -and $lContent -match 'package' -and $lContent -match 'system' -and $lContent -match 'organizer' -and $lContent -match 'clean' -and $lContent -match 'server' -and $lContent -match 'key')
}

# 4. Tool Metadata (tools.json)
Write-Host ""
Write-Host "[4/6] Validating Tool Metadata (site/data/tools.json)..." -ForegroundColor Cyan
$jsonPath = Join-Path $RepoRoot 'site\data\tools.json'
Assert-Check "Metadata file exists: site/data/tools.json" (Test-Path -LiteralPath $jsonPath)
if (Test-Path -LiteralPath $jsonPath) {
    try {
        $data = Get-Content -Path $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
        Assert-Check "tools.json is valid JSON with 10 tools" ($data.tools.Count -eq 10) "Found $($data.tools.Count) tools"
        Assert-Check "Suite provider is '$ExpectedProvider'" ($data.suite.provider -eq $ExpectedProvider)
        Assert-Check "Suite version is '$ExpectedVersion'" ($data.suite.version -eq $ExpectedVersion)

        foreach ($t in $data.tools) {
            $toolBat = Join-Path $RepoRoot ($t.batPath.Replace('/', '\'))
            Assert-Check "Metadata batPath exists on disk: $($t.id)" (Test-Path -LiteralPath $toolBat)
            Assert-Check "Metadata version matches: $($t.id)" ($t.version -eq $ExpectedVersion)
        }
    } catch {
        Assert-Check "JSON parsing" $false $_.Exception.Message
    }
}

# 5. Check Release Hashes
Write-Host ""
Write-Host "[5/6] Validating Release Hashes (release/hashes.txt)..." -ForegroundColor Cyan
$hashesPath = Join-Path $RepoRoot 'release\hashes.txt'
Assert-Check "release/hashes.txt exists" (Test-Path -LiteralPath $hashesPath)
if (Test-Path -LiteralPath $hashesPath) {
    $hashLines = Get-Content -Path $hashesPath | Where-Object { $_ -match '^[A-Fa-f0-9]{64}' }
    Assert-Check "hashes.txt contains 10 SHA-256 hashes" ($hashLines.Count -eq 10) "Found $($hashLines.Count) hash lines"
}

# 6. Check Forbidden Personal Name
Write-Host ""
Write-Host "[6/6] Checking for Forbidden Personal Name in Branding & Code..." -ForegroundColor Cyan
# Reconstruct check pattern dynamically to avoid self-match
$forbiddenPattern = -join [char[]]@(115, 104, 114, 101, 121, 97, 115, 104)
$scannedFiles = Get-ChildItem -Path $RepoRoot -Recurse -File -Include *.bat, *.ps1, *.json, *.html, *.css, *.js, *.md | Where-Object { 
    $_.FullName -notmatch '\\\.git\\' -and 
    $_.FullName -notmatch '\\references\\' -and
    $_.FullName -notmatch '\\scripts\\validate-tools\.ps1'
}

$forbiddenFound = 0
foreach ($f in $scannedFiles) {
    $content = Get-Content -Path $f.FullName -Raw -ErrorAction SilentlyContinue
    if ($content -and $content.ToLower().Contains($forbiddenPattern.ToLower())) {
        Write-Host "  [FAIL] Forbidden personal name found in: $($f.FullName.Replace($RepoRoot, ''))" -ForegroundColor Red
        $forbiddenFound++
    }
}
Assert-Check "Zero personal name mentions across all project files" ($forbiddenFound -eq 0) "Found in $forbiddenFound file(s)"

Write-Host ""
Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host "VALIDATION SUMMARY: $Passed Passed, $Failed Failed" -ForegroundColor $(if ($Failed -eq 0) { 'Green' } else { 'Red' })
Write-Host "==============================================================" -ForegroundColor Cyan

if ($Failed -gt 0) {
    exit 1
} else {
    exit 0
}
