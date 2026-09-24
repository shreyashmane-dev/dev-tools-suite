<#
.SYNOPSIS
    Launcher for DEV Package Hub (Tool 5 in DEV Tools Suite)
.DESCRIPTION
    Safely boots DEV Package Hub in Windows Terminal or cmd.exe.
    Provider: AnoS
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ToolName = 'DevPackageHub.bat'
$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LocalBat = Join-Path $ToolDir $ToolName

if (Test-Path -LiteralPath $LocalBat) {
    Write-Host "[DEV] Starting DEV Package Hub..." -ForegroundColor Cyan
    & cmd.exe /c "`"$LocalBat`""
    exit $LASTEXITCODE
}

$RemoteUri = 'https://raw.githubusercontent.com/AnoS/DevToolsSuite/main/tools/dev-package-hub/DevPackageHub.bat'
$TargetDir = Join-Path $env:LOCALAPPDATA 'DevToolsSuite\tools\dev-package-hub'
if (-not (Test-Path -LiteralPath $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
$DownloadedBat = Join-Path $TargetDir $ToolName

Write-Host "[DEV] Downloading DEV Package Hub..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $RemoteUri -OutFile $DownloadedBat -UseBasicParsing

if ((Get-Item $DownloadedBat).Length -lt 500) {
    Write-Error "Failed to download $ToolName or file corrupted."
    exit 1
}

Write-Host "[DEV] Launching DEV Package Hub..." -ForegroundColor Green
& cmd.exe /c "`"$DownloadedBat`""
exit $LASTEXITCODE
