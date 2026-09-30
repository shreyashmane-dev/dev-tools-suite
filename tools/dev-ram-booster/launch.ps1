<#
.SYNOPSIS
    Launcher for DEV RAM Booster (Tool 11 in DEV Tools Suite)
.DESCRIPTION
    Safely boots DEV RAM Booster in Windows Terminal or cmd.exe.
    Provider: AnoS
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ToolName = 'DevRamBooster.bat'
$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LocalBat = Join-Path $ToolDir $ToolName

if (Test-Path -LiteralPath $LocalBat) {
    Write-Host "[DEV] Starting DEV RAM Booster..." -ForegroundColor Cyan
    & cmd.exe /c "`"$LocalBat`""
    exit $LASTEXITCODE
}

$RemoteUri = 'https://raw.githubusercontent.com/shreyashmane-dev/dev-tools-suite/main/tools/dev-ram-booster/DevRamBooster.bat'
$TargetDir = Join-Path $env:LOCALAPPDATA 'DevToolsSuite\tools\dev-ram-booster'
if (-not (Test-Path -LiteralPath $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
$DownloadedBat = Join-Path $TargetDir $ToolName

Write-Host "[DEV] Downloading DEV RAM Booster..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $RemoteUri -OutFile $DownloadedBat -UseBasicParsing

if ((Get-Item $DownloadedBat).Length -lt 500) {
    Write-Error "Failed to download $ToolName or file corrupted."
    exit 1
}

Write-Host "[DEV] Launching DEV RAM Booster..." -ForegroundColor Green
& cmd.exe /c "`"$DownloadedBat`""
exit $LASTEXITCODE
