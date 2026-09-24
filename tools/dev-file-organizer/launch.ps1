<#
.SYNOPSIS
    Launcher for DEV File Organizer (Tool 7 in DEV Tools Suite)
.DESCRIPTION
    Safely boots DEV File Organizer in Windows Terminal or cmd.exe.
    Provider: AnoS
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ToolName = 'DevFileOrganizer.bat'
$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LocalBat = Join-Path $ToolDir $ToolName

if (Test-Path -LiteralPath $LocalBat) {
    Write-Host "[DEV] Starting DEV File Organizer..." -ForegroundColor Cyan
    & cmd.exe /c "`"$LocalBat`""
    exit $LASTEXITCODE
}

$RemoteUri = 'https://raw.githubusercontent.com/AnoS/DevToolsSuite/main/tools/dev-file-organizer/DevFileOrganizer.bat'
$TargetDir = Join-Path $env:LOCALAPPDATA 'DevToolsSuite\tools\dev-file-organizer'
if (-not (Test-Path -LiteralPath $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
$DownloadedBat = Join-Path $TargetDir $ToolName

Write-Host "[DEV] Downloading DEV File Organizer..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $RemoteUri -OutFile $DownloadedBat -UseBasicParsing

if ((Get-Item $DownloadedBat).Length -lt 500) {
    Write-Error "Failed to download $ToolName or file corrupted."
    exit 1
}

Write-Host "[DEV] Launching DEV File Organizer..." -ForegroundColor Green
& cmd.exe /c "`"$DownloadedBat`""
exit $LASTEXITCODE
