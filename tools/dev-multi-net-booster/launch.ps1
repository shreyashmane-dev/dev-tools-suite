<#
.SYNOPSIS
    Launcher for DEV Multi-Net Booster (Tool 12 in DEV Tools Suite)
.DESCRIPTION
    Safely boots DEV Multi-Net Booster in Windows Terminal or cmd.exe.
    Provider: AnoS
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ToolName = 'DevMultiNetBooster.bat'
$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LocalBat = Join-Path $ToolDir $ToolName

if (Test-Path -LiteralPath $LocalBat) {
    Write-Host "[DEV] Starting DEV Multi-Net Booster..." -ForegroundColor Cyan
    & cmd.exe /c "`"$LocalBat`""
    exit $LASTEXITCODE
}

$RemoteUri = 'https://raw.githubusercontent.com/shreyashmane-dev/dev-tools-suite/main/tools/dev-multi-net-booster/DevMultiNetBooster.bat'
$RemoteEngineUri = 'https://raw.githubusercontent.com/shreyashmane-dev/dev-tools-suite/main/tools/dev-multi-net-booster/proxy-engine.ps1'
$TargetDir = Join-Path $env:LOCALAPPDATA 'DevToolsSuite\tools\dev-multi-net-booster'
if (-not (Test-Path -LiteralPath $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
$DownloadedBat = Join-Path $TargetDir $ToolName
$DownloadedEngine = Join-Path $TargetDir 'proxy-engine.ps1'

Write-Host "[DEV] Downloading DEV Multi-Net Booster..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $RemoteUri -OutFile $DownloadedBat -UseBasicParsing
try {
    Invoke-WebRequest -Uri $RemoteEngineUri -OutFile $DownloadedEngine -UseBasicParsing
} catch {}

if ((Get-Item $DownloadedBat).Length -lt 500) {
    Write-Error "Failed to download $ToolName or file corrupted."
    exit 1
}

Write-Host "[DEV] Launching DEV Multi-Net Booster..." -ForegroundColor Green
& cmd.exe /c "`"$DownloadedBat`""
exit $LASTEXITCODE
