<#
.SYNOPSIS
    DEV Tools Suite :: Unified PowerShell Web & Local Launcher
.DESCRIPTION
    Safely bootstraps, verifies, caches, and launches tools from the DEV Tools Suite.
    Provider: AnoS
    Product: DEV Tools Suite
    Version: 1.0.0
.PARAMETER Tool
    Identifier or number of the tool to launch:
    1 / setup   : DEV Setup Center
    2 / forge   : DEV Project Forge
    3 / doctor  : DEV Doctor
    4 / github  : DEV GitHub Toolkit
    5 / package : DEV Package Hub
    6 / system  : DEV System Toolkit
.PARAMETER Clean
    Purges local tool cache directory.
.PARAMETER List
    Lists available tools with descriptions.
.PARAMETER VerifyHash
    Enforces SHA-256 integrity verification before execution.
.PARAMETER NoCache
    Always downloads a fresh copy without persisting in the cache.
.EXAMPLE
    .\DevLauncher.ps1 -Tool setup
.EXAMPLE
    powershell -ExecutionPolicy Bypass -File DevLauncher.ps1
#>
[CmdletBinding()]
param(
    [Alias('t')]
    [string]$Tool,
    
    [switch]$Clean,
    [switch]$List,
    [switch]$VerifyHash,
    [switch]$NoCache
)

$ErrorActionPreference = 'Stop'
$SuiteVersion = '1.0.0'
$RepoOwner = if ($env:DEV_REPO_OWNER) { $env:DEV_REPO_OWNER } else { 'AnoS' }
$RepoName = if ($env:DEV_REPO_NAME) { $env:DEV_REPO_NAME } else { 'DevToolsSuite' }
try {
    $detectedRemote = git config --get remote.origin.url 2>$null
    if ($detectedRemote -match 'github\.com[:/]([^/]+)/([^/\.]+)') {
        $RepoOwner = $Matches[1]
        $RepoName = $Matches[2]
    }
} catch {}
$Branch = if ($env:DEV_REPO_BRANCH) { $env:DEV_REPO_BRANCH } else { 'main' }
$RawBaseUrl = "https://raw.githubusercontent.com/$RepoOwner/$RepoName/$Branch"

$ToolsCatalog = @(
    @{
        Id          = 'setup'
        Alias       = @('1', 'setup', 'dev-setup-center', 'setup-center')
        Name        = 'DEV Setup Center'
        File        = 'DevSetupCenter.bat'
        RelPath     = 'tools/dev-setup-center/DevSetupCenter.bat'
        Description = 'Developer environment installer with smart scan and developer packs'
        Sha256      = ''
    },
    @{
        Id          = 'forge'
        Alias       = @('2', 'forge', 'dev-project-forge', 'project-forge')
        Name        = 'DEV Project Forge'
        File        = 'DevProjectForge.bat'
        RelPath     = 'tools/dev-project-forge/DevProjectForge.bat'
        Description = 'Project scaffolding and initialization tool with 14 templates'
        Sha256      = ''
    },
    @{
        Id          = 'doctor'
        Alias       = @('3', 'doctor', 'dev-doctor', 'doc')
        Name        = 'DEV Doctor'
        File        = 'DevDoctor.bat'
        RelPath     = 'tools/dev-doctor/DevDoctor.bat'
        Description = 'Comprehensive developer environment and toolchain diagnostic'
        Sha256      = ''
    },
    @{
        Id          = 'github'
        Alias       = @('4', 'github', 'dev-github-toolkit', 'git', 'github-toolkit')
        Name        = 'DEV GitHub Toolkit'
        File        = 'DevGitHubToolkit.bat'
        RelPath     = 'tools/dev-github-toolkit/DevGitHubToolkit.bat'
        Description = 'Safe Git and GitHub workflow helper with secure authentication'
        Sha256      = ''
    },
    @{
        Id          = 'package'
        Alias       = @('5', 'package', 'dev-package-hub', 'pkg', 'package-hub')
        Name        = 'DEV Package Hub'
        File        = 'DevPackageHub.bat'
        RelPath     = 'tools/dev-package-hub/DevPackageHub.bat'
        Description = 'Windows Package Manager (WinGet) terminal interface and manager'
        Sha256      = ''
    },
    @{
        Id          = 'system'
        Alias       = @('6', 'system', 'dev-system-toolkit', 'sys', 'system-toolkit')
        Name        = 'DEV System Toolkit'
        File        = 'DevSystemToolkit.bat'
        RelPath     = 'tools/dev-system-toolkit/DevSystemToolkit.bat'
        Description = 'Developer-focused system hardware, ports, and diagnostics utility'
        Sha256      = ''
    },
    @{
        Id          = 'file-organizer'
        Alias       = @('7', 'organizer', 'file-organizer', 'dev-file-organizer')
        Name        = 'DEV File Organizer'
        File        = 'DevFileOrganizer.bat'
        RelPath     = 'tools/dev-file-organizer/DevFileOrganizer.bat'
        Description = 'Developer workspace, dotfiles, and 30+ language code classifier'
        Sha256      = ''
    },
    @{
        Id          = 'clean-master'
        Alias       = @('8', 'clean', 'cleaner', 'clean-master', 'dev-clean-master')
        Name        = 'DEV Clean Master'
        File        = 'DevCleanMaster.bat'
        RelPath     = 'tools/dev-clean-master/DevCleanMaster.bat'
        Description = 'Workspace, cache, node_modules, and build artifact cleaner'
        Sha256      = ''
    },
    @{
        Id          = 'quick-server'
        Alias       = @('9', 'server', 'quick-server', 'dev-quick-server', 'http')
        Name        = 'DEV Quick Server'
        File        = 'DevQuickServer.bat'
        RelPath     = 'tools/dev-quick-server/DevQuickServer.bat'
        Description = 'Instant developer static web, HTTP server, and port unblocker'
        Sha256      = ''
    },
    @{
        Id          = 'key-forge'
        Alias       = @('10', 'key', 'keys', 'key-forge', 'dev-key-forge', 'crypto')
        Name        = 'DEV Key Forge'
        File        = 'DevKeyForge.bat'
        RelPath     = 'tools/dev-key-forge/DevKeyForge.bat'
        Description = 'SSH keypairs, localhost SSL certificates, JWT secrets, and file hasher'
        Sha256      = ''
    }
)

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "  ==============================================================" -ForegroundColor Cyan
    Write-Host "               DDDD    EEEE   V     V" -ForegroundColor Cyan
    Write-Host "               D   D   E      V     V" -ForegroundColor Cyan
    Write-Host "               D   D   EEEE    V   V " -ForegroundColor Cyan
    Write-Host "               D   D   E        V V  " -ForegroundColor Cyan
    Write-Host "               DDDD    EEEE      V   " -ForegroundColor Cyan
    Write-Host ""
    Write-Host "                     DEV TOOLS SUITE LAUNCHER" -ForegroundColor White
    Write-Host "                          $Provider | v$SuiteVersion" -ForegroundColor Gray
    Write-Host "  ==============================================================" -ForegroundColor Cyan
    Write-Host ""
}

# Cache directory management
$CacheDir = Join-Path $env:LOCALAPPDATA 'DevToolsSuite\cache'
if ($NoCache) {
    $CacheDir = Join-Path $env:TEMP ("DevToolsSuite_Temp_" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
}

if ($Clean) {
    Show-Header
    if (Test-Path -LiteralPath $CacheDir) {
        Write-Host "  Cleaning cache directory: $CacheDir" -ForegroundColor Yellow
        Remove-Item -LiteralPath $CacheDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  [OK] Cache cleared." -ForegroundColor Green
    } else {
        Write-Host "  [INFO] Cache directory is already empty." -ForegroundColor Gray
    }
    Write-Host ""
    exit 0
}

if ($List) {
    Show-Header
    Write-Host "  AVAILABLE TOOLS IN SUITE:" -ForegroundColor White
    Write-Host "  --------------------------------------------------------------" -ForegroundColor Gray
    foreach ($entry in $ToolsCatalog) {
        Write-Host ("  [{0,-2}] {1}" -f $entry.Alias[0], $entry.Name) -ForegroundColor Cyan
        Write-Host ("       {0}" -f $entry.Description) -ForegroundColor Gray
    }
    Write-Host "  --------------------------------------------------------------" -ForegroundColor Gray
    Write-Host ""
    exit 0
}

# Interactive selection if no tool parameter specified
if (-not $Tool) {
    Show-Header
    Write-Host "  SELECT A TOOL TO LAUNCH:" -ForegroundColor White
    Write-Host ""
    $i = 1
    foreach ($entry in $ToolsCatalog) {
        Write-Host ("  [{0,-2}] {1}" -f $i, $entry.Name) -ForegroundColor Cyan
        Write-Host ("       {0}" -f $entry.Description) -ForegroundColor Gray
        $i++
    }
    Write-Host "  [0 ] Exit" -ForegroundColor Red
    Write-Host ""
    $sel = (Read-Host "  Enter choice [0-10]").Trim()
    if ($sel -eq '0' -or -not $sel) {
        Write-Host "  Launcher closed." -ForegroundColor Gray
        exit 0
    }
    $Tool = $sel
}

# Match selected tool
$SelectedEntry = $null
foreach ($entry in $ToolsCatalog) {
    if ($entry.Alias -contains $Tool.ToLower()) {
        $SelectedEntry = $entry
        break
    }
}

if (-not $SelectedEntry) {
    Write-Host ""
    Write-Host "  [ERROR] Unknown tool identifier: '$Tool'" -ForegroundColor Red
    Write-Host "  Run 'DevLauncher.ps1 -List' to view available tools." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# Determine script source: Local repository clone or Remote download
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Split-Path -Parent $ScriptDir
$LocalCandidate = Join-Path $RepoRoot $SelectedEntry.RelPath.Replace('/', '\')

$ExecutionTarget = $null

if (Test-Path -LiteralPath $LocalCandidate) {
    Write-Host "  [INFO] Using local tool file from repository clone..." -ForegroundColor Cyan
    $ExecutionTarget = $LocalCandidate
} else {
    # Ensure cache directory exists
    if (-not (Test-Path -LiteralPath $CacheDir)) {
        New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null
    }
    $CachedBat = Join-Path $CacheDir $SelectedEntry.File
    $RemoteUrl = "$RawBaseUrl/$($SelectedEntry.RelPath)"

    Write-Host "  [DEV] Synchronizing $($SelectedEntry.Name)..." -ForegroundColor Cyan
    Write-Host "        Source: $RemoteUrl" -ForegroundColor Gray

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $RemoteUrl -OutFile $CachedBat -UseBasicParsing
    } catch {
        Write-Host ""
        Write-Host "  [ERROR] Failed to download $($SelectedEntry.Name):" -ForegroundColor Red
        Write-Host "  $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  Troubleshooting:" -ForegroundColor White
        Write-Host "  - Verify internet and DNS connectivity" -ForegroundColor Gray
        Write-Host "  - Check if GitHub raw content is reachable" -ForegroundColor Gray
        Write-Host ""
        exit 1
    }

    # Validation
    if (-not (Test-Path -LiteralPath $CachedBat)) {
        Write-Host "  [ERROR] Cached file was not created." -ForegroundColor Red
        exit 1
    }

    $fileInfo = Get-Item -LiteralPath $CachedBat
    if ($fileInfo.Length -lt 200) {
        Write-Host "  [ERROR] Downloaded file appears corrupted or empty (${fileInfo.Length} bytes)." -ForegroundColor Red
        Remove-Item -LiteralPath $CachedBat -Force -ErrorAction SilentlyContinue
        exit 1
    }

    # Optional SHA256 verification
    if ($VerifyHash -and $SelectedEntry.Sha256) {
        $computedHash = (Get-FileHash -Path $CachedBat -Algorithm SHA256).Hash
        if ($computedHash -ne $SelectedEntry.Sha256) {
            Write-Host "  [SECURITY ERROR] Hash mismatch detected!" -ForegroundColor Red
            Write-Host "  Expected: $($SelectedEntry.Sha256)" -ForegroundColor Red
            Write-Host "  Computed: $computedHash" -ForegroundColor Red
            Remove-Item -LiteralPath $CachedBat -Force -ErrorAction SilentlyContinue
            exit 2
        }
        Write-Host "  [OK] SHA256 checksum verified." -ForegroundColor Green
    }

    $ExecutionTarget = $CachedBat
}

# Boot the tool
Write-Host "  [DEV] Starting $($SelectedEntry.Name)..." -ForegroundColor Green
Write-Host ""

try {
    $proc = Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$ExecutionTarget`"" -Wait -PassThru -NoNewWindow
    $exitCode = $proc.ExitCode
} catch {
    Write-Host "  [ERROR] Execution failure: $($_.Exception.Message)" -ForegroundColor Red
    $exitCode = 1
}

# Cleanup temporary files if NoCache was requested
if ($NoCache -and (Test-Path -LiteralPath $CacheDir)) {
    Remove-Item -LiteralPath $CacheDir -Recurse -Force -ErrorAction SilentlyContinue
}

exit $exitCode
