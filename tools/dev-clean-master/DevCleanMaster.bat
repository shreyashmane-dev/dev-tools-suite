@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV CLEAN MASTER
REM Developer Workspace, Cache & Artifact Deep Cleaning Utility
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV CLEAN MASTER
mode con cols=100 lines=42 >nul 2>&1

REM --- ANSI Terminal Colors
for /F "delims=" %%E in ('echo prompt $E^| cmd') do set "ESC=%%E"
set "C_RESET=!ESC![0m"
set "C_CYAN=!ESC![96m"
set "C_BLUE=!ESC![94m"
set "C_GREEN=!ESC![92m"
set "C_YELLOW=!ESC![93m"
set "C_RED=!ESC![91m"
set "C_MAGENTA=!ESC![95m"
set "C_WHITE=!ESC![97m"
set "C_GRAY=!ESC![90m"
set "C_BOLD=!ESC![1m"

set "APP_NAME=DEV Clean Master"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"

goto :MAIN_MENU

REM ------------------------------------------------------------
REM HEADER
REM ------------------------------------------------------------
:HEADER
cls
echo.
echo !C_CYAN!  +==============================================================================+!C_RESET!
echo !C_CYAN!  ^|    ____  _______     __   ______            __        _____       _ __       ^|!C_RESET!
echo !C_CYAN!  ^|   / __ \/ ____/ ^|   / /  /_  __/___  ____  / /____   / ___/__  __(_) /____   ^|!C_RESET!
echo !C_CYAN!  ^|  / / / / __/  ^| ^|  / /    / / / __ \/ __ \/ / ___/   \__ \/ / / / / __/ _ \  ^|!C_RESET!
echo !C_CYAN!  ^| / /_/ / /___  ^| ^| / /    / / / /_/ / /_/ / (__  )   ___/ / /_/ / / /_/  __/  ^|!C_RESET!
echo !C_CYAN!  ^|/_____/_____/  ^|___/     /_/  \____/\____/_/____/   /____/\__,_/_/\__/\___/   ^|!C_RESET!
echo !C_CYAN!  +==============================================================================+!C_RESET!
echo   !C_CYAN!::!C_RESET! !C_WHITE!!C_BOLD!%APP_NAME%!C_RESET!          !C_GRAY![ Provider: !C_WHITE!AnoS!C_GRAY! :: Version: !C_GREEN!v%APP_VERSION%!C_GRAY! :: Platform: !C_CYAN!Windows!C_GRAY! ]!C_RESET!
echo !C_CYAN!  --------------------------------------------------------------------------------!C_RESET!
echo.
exit /b

REM ------------------------------------------------------------
REM MAIN MENU
REM ------------------------------------------------------------
:MAIN_MENU
cls
call :HEADER

echo  !C_WHITE!DEVELOPER ARTIFACT & DISK RECOVERY!C_RESET!
echo  Reclaim disk space by clearing build folders, caches, and dependency blobs.
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET!  Scan Workspace for Heavy Folders (node_modules, target, .venv)
echo    !C_CYAN![2]!C_RESET!  Clean Node.js & NPM Cache
echo    !C_CYAN![3]!C_RESET!  Clean Python __pycache__ & Pip Cache
echo    !C_CYAN![4]!C_RESET!  Clean C/C++ Visual Studio .vs & Build Artifacts
echo    !C_CYAN![5]!C_RESET!  Clean Docker System & Build Cache
echo    !C_CYAN![6]!C_RESET!  Clean Windows Temp & WinGet Download Cache
echo    !C_CYAN![7]!C_RESET!  Deep Developer Storage Overview
echo    !C_RED![0]!C_RESET!  Exit
echo.

set "CHOICE="
set /p "CHOICE=Select an option [0-7]: "
if "!CHOICE!"=="1" goto :CLEAN_WORKSPACE
if "!CHOICE!"=="2" goto :CLEAN_NPM
if "!CHOICE!"=="3" goto :CLEAN_PYTHON
if "!CHOICE!"=="4" goto :CLEAN_VS
if "!CHOICE!"=="5" goto :CLEAN_DOCKER
if "!CHOICE!"=="6" goto :CLEAN_TEMP
if "!CHOICE!"=="7" goto :STORAGE_OVERVIEW
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 7.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] SCAN WORKSPACE FOR HEAVY FOLDERS
REM ------------------------------------------------------------
:CLEAN_WORKSPACE
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!SCAN WORKSPACE FOR HEAVY ARTIFACTS!C_RESET!
echo  ----------------------------------------------------------------------
set "SCAN_DIR="
set /p "SCAN_DIR=Enter workspace directory to scan [Press Enter for: %USERPROFILE%\Projects]: "
if not defined SCAN_DIR set "SCAN_DIR=%USERPROFILE%\Projects"
set "SCAN_DIR=%SCAN_DIR:"=%"

if not exist "%SCAN_DIR%" (
    echo !C_RED![FAIL] Directory does not exist: %SCAN_DIR%!C_RESET!
    pause
    goto :MAIN_MENU
)

echo.
echo  Scanning %SCAN_DIR% for node_modules, target, bin, obj, and .venv...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "
$root = '%SCAN_DIR%';
$targets = @('node_modules', 'target', 'bin', 'obj', '.venv', '__pycache__', '.pytest_cache');
$found = @();

foreach ($t in $targets) {
    Get-ChildItem -LiteralPath $root -Recurse -Directory -Filter $t -ErrorAction SilentlyContinue | ForEach-Object {
        $path = $_.FullName;
        $files = Get-ChildItem -LiteralPath $path -Recurse -File -Force -ErrorAction SilentlyContinue;
        $sizeMB = [math]::Round(($files | Measure-Object -Property Length -Sum).Sum / 1MB, 2);
        $found += [PSCustomObject]@{
            Folder = $path.Replace($root, '.');
            FullPath = $path;
            Type = $t;
            SizeMB = $sizeMB
        }
    }
}

if ($found.Count -eq 0) {
    Write-Host '  No heavy build artifacts found in this directory.' -ForegroundColor Green;
} else {
    $found | Sort-Object SizeMB -Descending | Format-Table -AutoSize -Property Type, SizeMB, Folder;
    $totalMB = [math]::Round(($found | Measure-Object -Property SizeMB -Sum).Sum, 2);
    Write-Host ('  Total Reclaimable Space: ' + $totalMB + ' MB across ' + $found.Count + ' folders.') -ForegroundColor Yellow;
    Write-Host '';
    $ans = (Read-Host '  Delete these detected build artifacts? [Y/N]').Trim();
    if ($ans -eq 'Y' -or $ans -eq 'y') {
        $deleted = 0;
        foreach ($item in $found) {
            try {
                Remove-Item -LiteralPath $item.FullPath -Recurse -Force -ErrorAction Stop;
                Write-Host ('  [REMOVED] ' + $item.Folder) -ForegroundColor Green;
                $deleted++;
            } catch {
                Write-Host ('  [SKIP] ' + $item.Folder + ': ' + $_.Exception.Message) -ForegroundColor Red;
            }
        }
        Write-Host ('  Successfully removed ' + $deleted + ' artifact folders.') -ForegroundColor Green;
    } else {
        Write-Host '  Cancelled. No folders were deleted.' -ForegroundColor Cyan;
    }
}
" 2>nul

pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [2] CLEAN NPM & NODE.JS CACHE
REM ------------------------------------------------------------
:CLEAN_NPM
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CLEAN NODE.JS & NPM CACHE!C_RESET!
echo  ----------------------------------------------------------------------
where npm >nul 2>&1
if errorlevel 1 (
    echo !C_YELLOW![INFO] npm is not installed or not in PATH.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo  Executing npm cache clean --force...
npm cache clean --force
echo.
echo !C_GREEN![OK] npm package cache cleared.!C_RESET!
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [3] CLEAN PYTHON CACHE
REM ------------------------------------------------------------
:CLEAN_PYTHON
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CLEAN PYTHON CACHE & PIP ARTIFACTS!C_RESET!
echo  ----------------------------------------------------------------------
where python >nul 2>&1
if not errorlevel 1 (
    echo  Executing pip cache purge...
    pip cache purge >nul 2>&1
    echo  !C_GREEN![OK] Pip cache purged.!C_RESET!
)

set "PY_DIR="
set /p "PY_DIR=Clean __pycache__ in directory [Enter for current: %CD%]: "
if not defined PY_DIR set "PY_DIR=%CD%"

powershell -NoProfile -Command "
$d = '%PY_DIR%';
$c = Get-ChildItem -LiteralPath $d -Recurse -Directory -Filter '__pycache__' -ErrorAction SilentlyContinue;
$cnt = 0;
foreach ($item in $c) {
    Remove-Item -LiteralPath $item.FullName -Recurse -Force -ErrorAction SilentlyContinue;
    $cnt++;
}
Write-Host ('  [OK] Removed ' + $cnt + ' __pycache__ folders.') -ForegroundColor Green;
" 2>nul

pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [4] CLEAN C/C++ & VISUAL STUDIO
REM ------------------------------------------------------------
:CLEAN_VS
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CLEAN C/C++ & VISUAL STUDIO TEMPORARY ARTIFACTS!C_RESET!
echo  ----------------------------------------------------------------------
set "VS_DIR="
set /p "VS_DIR=Directory to clean [Enter for current: %CD%]: "
if not defined VS_DIR set "VS_DIR=%CD%"

powershell -NoProfile -Command "
$d = '%VS_DIR%';
$targets = @('.vs', 'ipch', 'Debug', 'Release', 'x64');
$cnt = 0;
foreach ($t in $targets) {
    Get-ChildItem -LiteralPath $d -Recurse -Directory -Filter $t -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction SilentlyContinue;
        Write-Host ('  [REMOVED] ' + $_.FullName) -ForegroundColor Green;
        $cnt++;
    }
}
Write-Host ('  [OK] Cleared ' + $cnt + ' Visual Studio cache and build folders.') -ForegroundColor Green;
" 2>nul

pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [5] CLEAN DOCKER SYSTEM CACHE
REM ------------------------------------------------------------
:CLEAN_DOCKER
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CLEAN DOCKER CONTAINERS & BUILD CACHE!C_RESET!
echo  ----------------------------------------------------------------------
where docker >nul 2>&1
if errorlevel 1 (
    echo !C_YELLOW![INFO] Docker is not installed.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo  Docker disk footprint:
docker system df
echo.
set "DCONF="
set /p "DCONF=Run 'docker system prune -f' (removes unused containers, networks, images)? [Y/N]: "
if /I "!DCONF!"=="Y" (
    docker system prune -f
    echo !C_GREEN![OK] Docker system cache purged.!C_RESET!
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [6] CLEAN WINDOWS TEMP & WINGET CACHE
REM ------------------------------------------------------------
:CLEAN_TEMP
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CLEAN WINDOWS TEMP & WINGET DOWNLOAD CACHE!C_RESET!
echo  ----------------------------------------------------------------------
set "TCONF="
set /p "TCONF=Clear user temporary directory (%TEMP%)? [Y/N]: "
if /I "!TCONF!"=="Y" (
    powershell -NoProfile -Command "
    $t = [IO.Path]::GetTempPath();
    $files = Get-ChildItem -LiteralPath $t -Recurse -Force -ErrorAction SilentlyContinue;
    $freed = 0;
    foreach ($f in $files) {
        try {
            $freed += $f.Length;
            Remove-Item -LiteralPath $f.FullName -Force -Recurse -ErrorAction Stop;
        } catch {}
    }
    Write-Host ('  [OK] Freed ' + [math]::Round($freed/1MB, 2) + ' MB in Temp folder.') -ForegroundColor Green;
    " 2>nul
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [7] STORAGE OVERVIEW
REM ------------------------------------------------------------
:STORAGE_OVERVIEW
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!DEVELOPER STORAGE OVERVIEW!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "
$drives = Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3};
foreach ($d in $drives) {
    $tot = [math]::Round($d.Size/1GB, 1);
    $free = [math]::Round($d.FreeSpace/1GB, 1);
    $pct = [math]::Round(($free/$tot)*100, 1);
    Write-Host ('  Drive ' + $d.DeviceID + ' : ' + $free + ' GB Free / ' + $tot + ' GB Total (' + $pct + '% Available)') -ForegroundColor Cyan;
}
" 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM EXIT
REM ------------------------------------------------------------
:EXIT
cls
call :HEADER
echo  !C_GREEN!Thank you for using DEV.!C_RESET!
echo  !C_GRAY!Provider: AnoS ^| Developer Tools Suite!C_RESET!
echo.
echo  Press any key to close...
pause >nul
endlocal
exit /b 0
