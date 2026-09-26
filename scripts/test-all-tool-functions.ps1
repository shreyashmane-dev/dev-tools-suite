# ============================================================
# DEV TOOLS SUITE :: Automated Tool & Function Testing Suite
# Runs each tool, exercises menu options, checks for runtime errors
# ============================================================

$ErrorActionPreference = 'Continue'
$rootDir = (Get-Item $PSScriptRoot).Parent.FullName
$toolsDir = Join-Path $rootDir 'tools'

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " DEV TOOLS SUITE - FUNCTIONAL & RUNTIME TEST SUITE" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$testResults = @()

function Run-ToolTest {
    param(
        [string]$ToolName,
        [string]$BatRelPath,
        [string]$CliArg = "0",
        [string]$ExpectedOutputPattern,
        [string]$TestDescription
    )

    $batPath = Join-Path $rootDir $BatRelPath
    if (-not (Test-Path $batPath)) {
        Write-Host "  [FAIL] $ToolName - File not found: $batPath" -ForegroundColor Red
        $script:testResults += [PSCustomObject]@{ Tool = $ToolName; Test = $TestDescription; Passed = $false; Error = "File not found" }
        return
    }

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "cmd.exe"
    $psi.Arguments = "/c `"$batPath`" $CliArg"
    $psi.WorkingDirectory = (Split-Path $batPath)
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true

    $proc = [System.Diagnostics.Process]::Start($psi)
    $stdoutTask = $proc.StandardOutput.ReadToEndAsync()
    $stderrTask = $proc.StandardError.ReadToEndAsync()

    $finished = $proc.WaitForExit(15000) # 15 second timeout per test
    if (-not $finished) {
        try { cmd /c "taskkill /F /T /PID $($proc.Id) >nul 2>&1" } catch {}
        Write-Host "  [TIMEOUT] $ToolName :: $TestDescription (exceeded 15s)" -ForegroundColor Yellow
        $script:testResults += [PSCustomObject]@{ Tool = $ToolName; Test = $TestDescription; Passed = $false; Error = "Timeout" }
        return
    }

    $stdout = $stdoutTask.Result
    $stderr = $stderrTask.Result
    $combined = $stdout + "`n" + $stderr

    # Check for fatal cmd syntax errors
    $hasCmdError = $false
    $fatalError = ""
    $errorPatterns = @(
        "'[^']+' is not recognized as an internal or external command",
        "was unexpected at this time",
        "The syntax of the command is incorrect",
        "The system cannot find the batch label specified",
        "The filename, directory name, or volume label syntax is incorrect"
    )

    foreach ($p in $errorPatterns) {
        if ($combined -match $p) {
            $hasCmdError = $true
            $fatalError = $matches[0]
            break
        }
    }

    $patternMatched = $true
    if ($ExpectedOutputPattern -and ($combined -notmatch $ExpectedOutputPattern)) {
        $patternMatched = $false
    }

    if ($hasCmdError) {
        Write-Host "  [FAIL] $ToolName :: $TestDescription" -ForegroundColor Red
        Write-Host "         Command parser error: $fatalError" -ForegroundColor Red
        $script:testResults += [PSCustomObject]@{ Tool = $ToolName; Test = $TestDescription; Passed = $false; Error = $fatalError }
    } elseif (-not $patternMatched) {
        Write-Host "  [FAIL] $ToolName :: $TestDescription" -ForegroundColor Red
        Write-Host "         Expected pattern '$ExpectedOutputPattern' not found in output" -ForegroundColor Red
        $script:testResults += [PSCustomObject]@{ Tool = $ToolName; Test = $TestDescription; Passed = $false; Error = "Pattern mismatch" }
    } else {
        Write-Host "  [PASS] $ToolName :: $TestDescription" -ForegroundColor Green
        $script:testResults += [PSCustomObject]@{ Tool = $ToolName; Test = $TestDescription; Passed = $true; Error = "" }
    }
}

# --- TEST 1: DevSystemToolkit (Every function & menu option)
Write-Host "`n>>> Testing DevSystemToolkit..." -ForegroundColor Yellow
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "0" -ExpectedOutputPattern "DEV SYSTEM TOOLKIT" -TestDescription "Menu launch & exit [0]"
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "1" -ExpectedOutputPattern "WINDOWS OPERATING SYSTEM OVERVIEW" -TestDescription "System Info [1]"
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "2" -ExpectedOutputPattern "PROCESSOR" -TestDescription "CPU Info [2]"
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "3" -ExpectedOutputPattern "MEMORY" -TestDescription "Memory Info [3]"
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "4" -ExpectedOutputPattern "STORAGE DRIVES" -TestDescription "Storage Info [4]"
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "5" -ExpectedOutputPattern "NETWORK ADAPTERS" -TestDescription "Network Info [5]"
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "6" -ExpectedOutputPattern "ENVIRONMENT VARIABLES" -TestDescription "Env Variables [6]"
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "7" -ExpectedOutputPattern "PATH VIEWER" -TestDescription "PATH Viewer [7]"
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "8" -ExpectedOutputPattern "ACTIVE DEVELOPER PROCESSES" -TestDescription "Dev Processes [8]"
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "9" -ExpectedOutputPattern "COMMON DEVELOPER LISTENING PORTS" -TestDescription "Dev Ports [9]"
Run-ToolTest -ToolName "DevSystemToolkit" -BatRelPath "tools\dev-system-toolkit\DevSystemToolkit.bat" -CliArg "11" -ExpectedOutputPattern "Dev-System-Report.txt" -TestDescription "Generate System Report [11]"

# --- TEST 2: DevDoctor (System diagnostics & PATH check)
Write-Host "`n>>> Testing DevDoctor..." -ForegroundColor Yellow
Run-ToolTest -ToolName "DevDoctor" -BatRelPath "tools\dev-doctor\DevDoctor.bat" -CliArg "0" -ExpectedOutputPattern "DEV DOCTOR" -TestDescription "Menu launch & exit [0]"
Run-ToolTest -ToolName "DevDoctor" -BatRelPath "tools\dev-doctor\DevDoctor.bat" -CliArg "1" -ExpectedOutputPattern "DEVELOPER ENVIRONMENT DIAGNOSIS" -TestDescription "Doctor Full Overview [1]"
Run-ToolTest -ToolName "DevDoctor" -BatRelPath "tools\dev-doctor\DevDoctor.bat" -CliArg "2" -ExpectedOutputPattern "GIT ENVIRONMENT CHECK" -TestDescription "Git check [2]"
Run-ToolTest -ToolName "DevDoctor" -BatRelPath "tools\dev-doctor\DevDoctor.bat" -CliArg "3" -ExpectedOutputPattern "PYTHON ENVIRONMENT CHECK" -TestDescription "Python check [3]"
Run-ToolTest -ToolName "DevDoctor" -BatRelPath "tools\dev-doctor\DevDoctor.bat" -CliArg "4" -ExpectedOutputPattern "NODE.JS" -TestDescription "Node.js check [4]"
Run-ToolTest -ToolName "DevDoctor" -BatRelPath "tools\dev-doctor\DevDoctor.bat" -CliArg "9" -ExpectedOutputPattern "SYSTEM PATH HEALTH CHECK" -TestDescription "PATH health [9]"

# --- TEST 3: DevKeyForge (Crypto, SSL, JWT, Hashes, Base64, UUID)
Write-Host "`n>>> Testing DevKeyForge..." -ForegroundColor Yellow
Run-ToolTest -ToolName "DevKeyForge" -BatRelPath "tools\dev-key-forge\DevKeyForge.bat" -CliArg "0" -ExpectedOutputPattern "DEV KEY FORGE" -TestDescription "Menu launch & exit [0]"
Run-ToolTest -ToolName "DevKeyForge" -BatRelPath "tools\dev-key-forge\DevKeyForge.bat" -CliArg "3" -ExpectedOutputPattern "32-Character" -TestDescription "Generate API Keys [3]"
Run-ToolTest -ToolName "DevKeyForge" -BatRelPath "tools\dev-key-forge\DevKeyForge.bat" -CliArg "4" -ExpectedOutputPattern "Base64 Encoded" -TestDescription "Generate JWT Secret [4]"
Run-ToolTest -ToolName "DevKeyForge" -BatRelPath "tools\dev-key-forge\DevKeyForge.bat" -CliArg "7" -ExpectedOutputPattern "[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}" -TestDescription "Generate UUID v4 [7]"

# --- TEST 4: DevCleanMaster (Cache clean & storage)
Write-Host "`n>>> Testing DevCleanMaster..." -ForegroundColor Yellow
Run-ToolTest -ToolName "DevCleanMaster" -BatRelPath "tools\dev-clean-master\DevCleanMaster.bat" -CliArg "0" -ExpectedOutputPattern "DEV CLEAN MASTER" -TestDescription "Menu launch & exit [0]"
Run-ToolTest -ToolName "DevCleanMaster" -BatRelPath "tools\dev-clean-master\DevCleanMaster.bat" -CliArg "7" -ExpectedOutputPattern "DEVELOPER STORAGE OVERVIEW" -TestDescription "Storage Overview [7]"

# --- TEST 5: DevQuickServer (Network URLs & Port inspection)
Write-Host "`n>>> Testing DevQuickServer..." -ForegroundColor Yellow
Run-ToolTest -ToolName "DevQuickServer" -BatRelPath "tools\dev-quick-server\DevQuickServer.bat" -CliArg "0" -ExpectedOutputPattern "DEV QUICK SERVER" -TestDescription "Menu launch & exit [0]"
Run-ToolTest -ToolName "DevQuickServer" -BatRelPath "tools\dev-quick-server\DevQuickServer.bat" -CliArg "4" -ExpectedOutputPattern "LOCAL" -TestDescription "Show IPs [4]"
Run-ToolTest -ToolName "DevQuickServer" -BatRelPath "tools\dev-quick-server\DevQuickServer.bat" -CliArg "5 59999" -ExpectedOutputPattern "PORT UNBLOCKER" -TestDescription "Port Inspection [5]"

# --- TEST 6: DevFileOrganizer (Dry-run toggle & Catalog)
Write-Host "`n>>> Testing DevFileOrganizer..." -ForegroundColor Yellow
Run-ToolTest -ToolName "DevFileOrganizer" -BatRelPath "tools\dev-file-organizer\DevFileOrganizer.bat" -CliArg "0" -ExpectedOutputPattern "DEV FILE ORGANIZER" -TestDescription "Menu launch & exit [0]"
Run-ToolTest -ToolName "DevFileOrganizer" -BatRelPath "tools\dev-file-organizer\DevFileOrganizer.bat" -CliArg "5" -ExpectedOutputPattern "SUPPORTED FILE TYPES" -TestDescription "View Catalog [5]"

# --- TEST 7: DevGitHubToolkit (Menu & checks)
Write-Host "`n>>> Testing DevGitHubToolkit..." -ForegroundColor Yellow
Run-ToolTest -ToolName "DevGitHubToolkit" -BatRelPath "tools\dev-github-toolkit\DevGitHubToolkit.bat" -CliArg "0" -ExpectedOutputPattern "DEV GITHUB TOOLKIT" -TestDescription "Menu launch & exit [0]"
Run-ToolTest -ToolName "DevGitHubToolkit" -BatRelPath "tools\dev-github-toolkit\DevGitHubToolkit.bat" -CliArg "1" -ExpectedOutputPattern "GIT INSTALLATION CHECK" -TestDescription "Check Git [1]"
Run-ToolTest -ToolName "DevGitHubToolkit" -BatRelPath "tools\dev-github-toolkit\DevGitHubToolkit.bat" -CliArg "2" -ExpectedOutputPattern "GITHUB CLI" -TestDescription "Check GH CLI [2]"
Run-ToolTest -ToolName "DevGitHubToolkit" -BatRelPath "tools\dev-github-toolkit\DevGitHubToolkit.bat" -CliArg "11" -ExpectedOutputPattern "REPOSITORY STATUS" -TestDescription "Repository Status [11]"

# --- TEST 8: DevPackageHub (Menu & Status)
Write-Host "`n>>> Testing DevPackageHub..." -ForegroundColor Yellow
Run-ToolTest -ToolName "DevPackageHub" -BatRelPath "tools\dev-package-hub\DevPackageHub.bat" -CliArg "0" -ExpectedOutputPattern "DEV PACKAGE HUB" -TestDescription "Menu launch & exit [0]"
Run-ToolTest -ToolName "DevPackageHub" -BatRelPath "tools\dev-package-hub\DevPackageHub.bat" -CliArg "9" -ExpectedOutputPattern "DIAGNOSTICS" -TestDescription "Diagnostics & History [9]"

# --- TEST 9: DevProjectForge (Menu & Templates)
Write-Host "`n>>> Testing DevProjectForge..." -ForegroundColor Yellow
Run-ToolTest -ToolName "DevProjectForge" -BatRelPath "tools\dev-project-forge\DevProjectForge.bat" -CliArg "0" -ExpectedOutputPattern "DEV PROJECT FORGE" -TestDescription "Menu launch & exit [0]"
Run-ToolTest -ToolName "DevProjectForge" -BatRelPath "tools\dev-project-forge\DevProjectForge.bat" -CliArg "2" -ExpectedOutputPattern "SUPPORTED PROJECT TEMPLATES" -TestDescription "View Templates [2]"

# --- TEST 10: DevSetupCenter (Menu & Antigravity)
Write-Host "`n>>> Testing DevSetupCenter..." -ForegroundColor Yellow
Run-ToolTest -ToolName "DevSetupCenter" -BatRelPath "tools\dev-setup-center\DevSetupCenter.bat" -CliArg "0" -ExpectedOutputPattern "DEV SETUP CENTER" -TestDescription "Menu launch & exit [0]"
Run-ToolTest -ToolName "DevSetupCenter" -BatRelPath "tools\dev-setup-center\DevSetupCenter.bat" -CliArg "9" -ExpectedOutputPattern "ABOUT DEV SETUP CENTER" -TestDescription "About DEV [9]"

Write-Host "`n============================================================" -ForegroundColor Cyan
Write-Host " TEST RESULTS SUMMARY" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
$passed = ($testResults | Where-Object { $_.Passed }).Count
$failed = ($testResults | Where-Object { -not $_.Passed }).Count
Write-Host "Total Tests: $($testResults.Count) | Passed: $passed | Failed: $failed" -ForegroundColor $(if ($failed -eq 0) { 'Green' } else { 'Red' })

if ($failed -gt 0) {
    Write-Host "`nFailed Tests:" -ForegroundColor Red
    $testResults | Where-Object { -not $_.Passed } | Format-Table -AutoSize
    exit 1
} else {
    Write-Host "`nALL TESTS PASSED! ZERO SYNTAX ERRORS! ZERO RUNTIME ERRORS!" -ForegroundColor Green
    exit 0
}
