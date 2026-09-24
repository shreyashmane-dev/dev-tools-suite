<#
.SYNOPSIS
    Automated Tool Discovery & Catalog Synchronizer
.DESCRIPTION
    Scans the tools/ directory, discovers all standalone BAT tools, computes SHA-256
    checksums, and updates site/data/tools.json, release/hashes.txt, and launcher/DevLauncher.ps1.
    Run this script whenever you add or modify tools in the suite!
    Provider: AnoS
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Split-Path -Parent $ScriptDir
$ToolsDir = Join-Path $RepoRoot 'tools'
$ToolsJsonPath = Join-Path $RepoRoot 'site\data\tools.json'
$HashesPath = Join-Path $RepoRoot 'release\hashes.txt'

Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host "     DEV TOOLS SUITE :: TOOL CATALOG AUTO-SYNCHRONIZER" -ForegroundColor White
Write-Host "     Provider: AnoS" -ForegroundColor Gray
Write-Host "==============================================================" -ForegroundColor Cyan
Write-Host ""

$ToolFolders = Get-ChildItem -LiteralPath $ToolsDir -Directory | Sort-Object Name
Write-Host "Discovered $($ToolFolders.Count) tool package directories in tools/..." -ForegroundColor Cyan

$DiscoveredTools = @()
$HashLines = @(
    "# DEV Tools Suite - SHA-256 Release Hashes",
    "# Provider: AnoS",
    "# Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "#"
)

foreach ($folder in $ToolFolders) {
    $batFiles = Get-ChildItem -LiteralPath $folder.FullName -Filter "*.bat"
    if ($batFiles.Count -eq 0) { continue }
    $bat = $batFiles[0]

    $shortId = $folder.Name.Replace('dev-', '')
    $id = $folder.Name
    $fileName = $bat.Name
    $relPath = "tools/$($folder.Name)/$fileName"
    $fileSizeKB = [math]::Round($bat.Length / 1KB)

    $hashVal = (Get-FileHash -Path $bat.FullName -Algorithm SHA256).Hash
    $HashLines += "$hashVal  $relPath"

    $name = "DEV " + (Get-Culture).TextInfo.ToTitleCase($shortId.Replace('-', ' '))
    $tagline = "Windows Developer Utility"
    $desc = "Standalone developer command-line utility from the DEV Tools Suite."
    $icon = "terminal"
    $features = @("Fast execution", "Standalone zero-dependency batch file", "Unified DEV terminal UI")

    if ($shortId -eq 'setup-center') {
        $name = "DEV Setup Center"
        $tagline = "Smart Windows Developer Environment Installer"
        $desc = "Developer environment installer with pre-install scans, 9 specialized packs, and clean two-column dashboard."
        $icon = "terminal"
        $features = @("Pre-install system scan", "Visual 2-column Installed / Missing layout", "9 specialized packs", "46 cataloged developer tools", "Report generation", "Google Antigravity navigation")
    } elseif ($shortId -eq 'project-forge') {
        $name = "DEV Project Forge"
        $tagline = "Rapid Project Scaffolding & Environment Initialization"
        $desc = "Instant scaffolding tool supporting 14 modern project templates, path character validation, Git initialization, virtual environments, and workspace integration."
        $icon = "folder-plus"
        $features = @("14 production-ready templates", "Strict Windows path validation", "Collision protection", "Tailored .gitignore and README generation", "Python .venv creation", "Git repository initialization")
    } elseif ($shortId -eq 'doctor') {
        $name = "DEV Doctor"
        $tagline = "Developer Environment Health & Toolchain Diagnostic"
        $desc = "Comprehensive diagnostic utility inspecting command availability, version strings, PATH directory health, environment variables, and compiler toolchains."
        $icon = "activity"
        $features = @("Non-alarmist [OK], [WARN], [FAIL], and [INFO] classification", "Git, Python, Node, Java, C++, Docker checks", "Deep PATH integrity inspection", "Developer environment variables audit", "Export to diagnostic report")
    } elseif ($shortId -eq 'github-toolkit') {
        $name = "DEV GitHub Toolkit"
        $tagline = "Safe Git & GitHub Workflow Helper"
        $desc = "Secure version control workflow assistant automating identity setup, branch management, staging, commits, push/pull, and safe GitHub browser auth."
        $icon = "git-pull-request"
        $features = @("Zero plain-text credential prompts", "GitHub CLI browser login integration", "Global Git identity configuration", "Interactive branch manager", "Staging and commit assistant")
    } elseif ($shortId -eq 'package-hub') {
        $name = "DEV Package Hub"
        $tagline = "Windows Package Manager (WinGet) Terminal Interface"
        $desc = "Safe, transparent terminal wrapper around Windows Package Manager providing curated developer categories, upgrade monitors, and operation history."
        $icon = "package"
        $features = @("Pre-execution preview", "Mandatory confirmation on destructive operations", "Interactive WinGet catalog search", "Upgrade manager (single or bulk)", "Developer Quick-Picks", "Audit logging to package-hub.log")
    } elseif ($shortId -eq 'system-toolkit') {
        $name = "DEV System Toolkit"
        $tagline = "Developer-Focused Windows System & Diagnostics Utility"
        $desc = "Legitimate developer productivity utility for monitoring active development ports, developer process consumption, storage quotas, and system health."
        $icon = "cpu"
        $features = @("Developer port scanner (PID & Process mapping)", "Developer-filtered process monitor", "CPU, RAM, and Storage telemetry", "Numbered PATH viewer with disk verification", "Windows Terminal utilities")
    } elseif ($shortId -eq 'file-organizer') {
        $name = "DEV File Organizer"
        $tagline = "Smart Developer Workspace & File Classification"
        $desc = "Categorizes developer workspaces by language (30+ formats), dotfiles, 3D assets, archives, installers, and media with dry-run preview."
        $icon = "folder-plus"
        $features = @("Classifies 30+ programming languages", "Dedicated dotfiles and config categorization", "Safe simulation / dry-run mode", "Collision renaming protection", "Organizes downloads or workspace")
    } elseif ($shortId -eq 'clean-master') {
        $name = "DEV Clean Master"
        $tagline = "Developer Workspace, Cache & Artifact Deep Cleaner"
        $desc = "Reclaim gigabytes by scanning and safely cleaning node_modules, target, .venv, build caches, and package manager blobs."
        $icon = "activity"
        $features = @("Scans for heavy build artifacts with size calculations", "Cleans NPM, pip, and Python __pycache__", "Cleans Visual Studio .vs and C++ temp files", "Docker system prune integration", "Mandatory confirmation safety")
    } elseif ($shortId -eq 'quick-server') {
        $name = "DEV Quick Server"
        $tagline = "Instant Developer Static Web & HTTP Testing Server"
        $desc = "Lightning fast local HTTP development server with custom port selection, LAN mobile access URLs, and port unblocking."
        $icon = "terminal"
        $features = @("Zero-dependency native .NET HttpListener or Python", "Auto-opens default browser", "Displays local Wi-Fi LAN URLs for mobile testing", "Built-in port conflict detection and unblocker", "Custom serving directory")
    } elseif ($shortId -eq 'key-forge') {
        $name = "DEV Key Forge"
        $tagline = "Developer Cryptography, SSH Keys, SSL & Hash Utility"
        $desc = "Generates secure SSH keypairs, localhost SSL certificates, cryptographic API tokens, JWT signing secrets, and file hashes."
        $icon = "cpu"
        $features = @("SSH key generation (ed25519 and RSA-4096)", "Instant localhost SSL/TLS self-signed certificates", "Cryptographically secure API keys and secrets", "JWT HMAC-SHA256 signing secret generator", "MD5, SHA-256, and SHA-512 file hasher")
    }

    $psCommand = 'powershell -ExecutionPolicy Bypass -Command "$f=\"$env:TEMP\DevLauncher.ps1\"; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri ''https://raw.githubusercontent.com/AnoS/DevToolsSuite/main/launcher/DevLauncher.ps1'' -OutFile $f; & $f -Tool ' + $shortId + '; Remove-Item -Force $f"'

    $toolEntry = [ordered]@{
        id = $id
        shortId = $shortId
        name = $name
        title = $name.Replace('DEV ', '')
        tagline = $tagline
        description = $desc
        version = "1.0.0"
        status = "Production Ready"
        batPath = $relPath
        fileName = $fileName
        fileSize = "$fileSizeKB KB"
        sha256 = $hashVal
        powershellCommand = $psCommand
        downloadUrl = "https://raw.githubusercontent.com/AnoS/DevToolsSuite/main/$relPath"
        githubUrl = "https://github.com/AnoS/DevToolsSuite/blob/main/$relPath"
        icon = $icon
        features = $features
        requirements = [ordered]@{
            os = "Windows 10 / 11 (x64, ARM64)"
            shell = "cmd.exe or Windows Terminal"
            dependencies = "Built-in Windows components"
            privileges = "Standard user access"
        }
        preview = @(
            "==============================================================",
            "                    " + $name.ToUpper(),
            "                         AnoS | v1.0.0",
            "==============================================================",
            "",
            "  MAIN MENU",
            "    [1] Start Primary Action",
            "    [2] Options and Diagnostics",
            "    [0] Exit"
        )
    }

    $DiscoveredTools += $toolEntry
    Write-Host ("  [SYNCED] {0,-24} -> {1} ({2} KB)" -f $name, $fileName, $fileSizeKB) -ForegroundColor Green
}

$HashLines | Set-Content -Path $HashesPath -Encoding UTF8
Write-Host "  [OK] Saved hashes to release/hashes.txt" -ForegroundColor Green

$CatalogObj = [ordered]@{
    suite = [ordered]@{
        name = "DEV Tools Suite"
        provider = "AnoS"
        version = "1.0.0"
        description = "A collection of practical Windows developer tools built for setup, diagnostics, project creation and GitHub workflows."
        githubUrl = "https://github.com/AnoS/DevToolsSuite"
        rawBaseUrl = "https://raw.githubusercontent.com/AnoS/DevToolsSuite/main"
    }
    tools = $DiscoveredTools
}

$jsonText = $CatalogObj | ConvertTo-Json -Depth 10
[IO.File]::WriteAllText($ToolsJsonPath, $jsonText, [Text.Encoding]::UTF8)
Write-Host "  [OK] Saved $($DiscoveredTools.Count) tools to site/data/tools.json" -ForegroundColor Green
Write-Host ""
Write-Host "Catalog synchronization complete!" -ForegroundColor Cyan
