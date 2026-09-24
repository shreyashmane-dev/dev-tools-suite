<#
.SYNOPSIS
    Launcher for DEV Setup Center (Tool 1 in DEV Tools Suite)
.DESCRIPTION
    Safely boots DEV Setup Center in Windows Terminal or cmd.exe.
    Provider: AnoS
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ToolName = 'DevSetupCenter.bat'
$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LocalBat = Join-Path $ToolDir $ToolName

if (Test-Path -LiteralPath $LocalBat) {
    Write-Host "[DEV] Starting DEV Setup Center..." -ForegroundColor Cyan
    & cmd.exe /c "`"$LocalBat`""
    exit $LASTEXITCODE
}

# If launched independently over web
$RemoteUri = 'https://raw.githubusercontent.com/AnoS/DevToolsSuite/main/tools/dev-setup-center/DevSetupCenter.bat'
$TargetDir = Join-Path $env:LOCALAPPDATA 'DevToolsSuite\tools\dev-setup-center'
if (-not (Test-Path -LiteralPath $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
$DownloadedBat = Join-Path $TargetDir $ToolName

Write-Host "[DEV] Downloading DEV Setup Center..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $RemoteUri -OutFile $DownloadedBat -UseBasicParsing

if ((Get-Item $DownloadedBat).Length -lt 500) {
    Write-Error "Failed to download $ToolName or file corrupted."
    exit 1
}

Write-Host "[DEV] Launching DEV Setup Center..." -ForegroundColor Green
& cmd.exe /c "`"$DownloadedBat`""
exit $LASTEXITCODE
