<#
.SYNOPSIS
    Test Batch Syntax Integrity
.DESCRIPTION
    Checks labels, gotos, and calls in all six tools to ensure 0 broken routing labels.
    Provider: AnoS
#>
[CmdletBinding()]
param()

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Tools = @(
    'tools\dev-setup-center\DevSetupCenter.bat',
    'tools\dev-project-forge\DevProjectForge.bat',
    'tools\dev-doctor\DevDoctor.bat',
    'tools\dev-github-toolkit\DevGitHubToolkit.bat',
    'tools\dev-package-hub\DevPackageHub.bat',
    'tools\dev-system-toolkit\DevSystemToolkit.bat',
    'tools\dev-file-organizer\DevFileOrganizer.bat',
    'tools\dev-clean-master\DevCleanMaster.bat',
    'tools\dev-quick-server\DevQuickServer.bat',
    'tools\dev-key-forge\DevKeyForge.bat'
)

$TotalChecked = 0
$BrokenGotos = 0

foreach ($t in $Tools) {
    $full = Join-Path $RepoRoot "..\$t"
    if (-not (Test-Path $full)) { continue }

    $lines = Get-Content -Path $full
    $labels = @{}

    # First pass: collect labels
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed -match '^:([a-zA-Z0-9_\-]+)') {
            $label = $matches[1].ToLower()
            $labels[$label] = $true
        }
    }

    # Second pass: check gotos and internal calls
    $lineNum = 0
    foreach ($line in $lines) {
        $lineNum++
        $trimmed = $line.Trim()

        # Check goto
        if ($trimmed -match 'goto\s+:?([a-zA-Z0-9_\-]+)') {
            $target = $matches[1].ToLower()
            if ($target -ne 'eof' -and -not $labels.ContainsKey($target)) {
                Write-Host ("  [BROKEN GOTO] {0}:{1} -> :{2}" -f $t, $lineNum, $target) -ForegroundColor Red
                $BrokenGotos++
            }
            $TotalChecked++
        }

        # Check call :LABEL
        if ($trimmed -match 'call\s+:([a-zA-Z0-9_\-]+)') {
            $target = $matches[1].ToLower()
            if (-not $labels.ContainsKey($target)) {
                Write-Host ("  [BROKEN CALL] {0}:{1} -> :{2}" -f $t, $lineNum, $target) -ForegroundColor Red
                $BrokenGotos++
            }
            $TotalChecked++
        }
    }
}

Write-Host "Label and Routing Check Complete: $TotalChecked target jumps checked." -ForegroundColor Cyan
if ($BrokenGotos -eq 0) {
    Write-Host "All gotos and subroutine calls resolve to valid labels! (0 broken)" -ForegroundColor Green
    exit 0
} else {
    Write-Host "Found $BrokenGotos broken jumps!" -ForegroundColor Red
    exit 1
}
