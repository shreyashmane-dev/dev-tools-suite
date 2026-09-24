<#
.SYNOPSIS
    Launcher for DEV Key Forge (Tool 10 in DEV Tools Suite)
.DESCRIPTION
    Safely boots DEV Key Forge in Windows Terminal or cmd.exe.
    Provider: AnoS
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$ToolName = 'DevKeyForge.bat'
$ToolDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LocalBat = Join-Path $ToolDir $ToolName

if (Test-Path -LiteralPath $LocalBat) {
    Write-Host "[DEV] Starting DEV Key Forge..." -ForegroundColor Cyan
    & cmd.exe /c "`"$LocalBat`""
    exit $LASTEXITCODE
}

$RemoteUri = 'https://raw.githubusercontent.com/AnoS/DevToolsSuite/main/tools/dev-key-forge/DevKeyForge.bat'
$TargetDir = Join-Path $env:LOCALAPPDATA 'DevToolsSuite\tools\dev-key-forge'
if (-not (Test-Path -LiteralPath $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
$DownloadedBat = Join-Path $TargetDir $ToolName

Write-Host "[DEV] Downloading DEV Key Forge..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $RemoteUri -OutFile $DownloadedBat -UseBasicParsing

if ((Get-Item $DownloadedBat).Length -lt 500) {
    Write-Error "Failed to download $ToolName or file corrupted."
    exit 1
}

Write-Host "[DEV] Launching DEV Key Forge..." -ForegroundColor Green
& cmd.exe /c "`"$DownloadedBat`""
exit $LASTEXITCODE
