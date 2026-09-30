@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: MASTER CMD & BATCH LAUNCHER
REM Interactive Terminal Launcher for all 11 Developer Tools
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV TOOLS SUITE
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

set "APP_NAME=DEV Tools Suite"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"
set "RAW_BASE=https://raw.githubusercontent.com/shreyashmane-dev/dev-tools-suite/main"

REM --- Direct CLI Argument Routing
if not "%~1"=="" (
    set "CHOICE=%~1"
    goto :ROUTE_CHOICE
)

REM ------------------------------------------------------------
REM MAIN INTERACTIVE LOOP
REM ------------------------------------------------------------
:MAIN_MENU
cls
echo.
echo !C_CYAN!  +==============================================================================+!C_RESET!
echo !C_CYAN!  ^|    ____  _______     __   ______            __        _____       _ __       ^|!C_RESET!
echo !C_CYAN!  ^|   / __ \/ ____/ ^|   / /  /_  __/___  ____  / /____   / ___/__  __(_) /____   ^|!C_RESET!
echo !C_CYAN!  ^|  / / / / __/  ^| ^|  / /    / / / __ \/ __ \/ / ___/   \__ \/ / / / / __/ _ \  ^|!C_RESET!
echo !C_CYAN!  ^| / /_/ / /___  ^| ^| / /    / / / /_/ / /_/ / (__  )   ___/ / /_/ / / /_/  __/  ^|!C_RESET!
echo !C_CYAN!  ^|/_____/_____/  ^|___/     /_/  \____/\____/_/____/   /____/\__,_/_/\__/\___/   ^|!C_RESET!
echo !C_CYAN!  +==============================================================================+!C_RESET!
echo   !C_WHITE!>> DEV TOOLS SUITE LAUNCHER        !C_GRAY![ Provider: AnoS ^| Version: v1.0.0 ^| CMD ]!C_RESET!
echo   !C_CYAN!--------------------------------------------------------------------------------!C_RESET!
echo.
echo   !C_WHITE!!C_BOLD!SELECT A DEVELOPER TOOL TO LAUNCH:!C_RESET!
echo.
echo   !C_CYAN![1 ]!C_RESET! !C_WHITE!DEV Setup Center!C_RESET!      !C_GRAY!Environment installer, smart scan ^& packs!C_RESET!
echo   !C_CYAN![2 ]!C_RESET! !C_WHITE!DEV Project Forge!C_RESET!     !C_GRAY!Project scaffolding ^& 14 modern templates!C_RESET!
echo   !C_CYAN![3 ]!C_RESET! !C_WHITE!DEV Doctor!C_RESET!            !C_GRAY!Developer toolchain diagnostics ^& PATH check!C_RESET!
echo   !C_CYAN![4 ]!C_RESET! !C_WHITE!DEV GitHub Toolkit!C_RESET!    !C_GRAY!Git ^& GitHub workflow helper ^& auth check!C_RESET!
echo   !C_CYAN![5 ]!C_RESET! !C_WHITE!DEV Package Hub!C_RESET!       !C_GRAY!WinGet package manager terminal UI!C_RESET!
echo   !C_CYAN![6 ]!C_RESET! !C_WHITE!DEV System Toolkit!C_RESET!    !C_GRAY!System hardware, dev ports ^& telemetry!C_RESET!
echo   !C_CYAN![7 ]!C_RESET! !C_WHITE!DEV File Organizer!C_RESET!    !C_GRAY!Code workspace, dotfiles ^& 30+ lang sorter!C_RESET!
echo   !C_CYAN![8 ]!C_RESET! !C_WHITE!DEV Clean Master!C_RESET!      !C_GRAY!Deep cleaner: node_modules, cache, artifacts!C_RESET!
echo   !C_CYAN![9 ]!C_RESET! !C_WHITE!DEV Quick Server!C_RESET!      !C_GRAY!Instant HTTP server, IP viewer ^& port killer!C_RESET!
echo   !C_CYAN![10]!C_RESET! !C_WHITE!DEV Key Forge!C_RESET!         !C_GRAY!SSH keys, SSL certs, JWT secrets ^& hash tools!C_RESET!
echo   !C_CYAN![11]!C_RESET! !C_WHITE!DEV RAM Booster!C_RESET!        !C_GRAY!Laptop RAM cache cleaner, working sets ^& speed booster!C_RESET!
echo.
echo   !C_RED![0 ]!C_RESET! !C_GRAY!Exit Suite!C_RESET!
echo.
echo   !C_CYAN!--------------------------------------------------------------------------------!C_RESET!
set "CHOICE="
set /p "CHOICE=  Enter selection [0-11]: "
if not defined CHOICE goto :MAIN_MENU

:ROUTE_CHOICE
if "%CHOICE%"=="0" goto :EXIT
if /i "%CHOICE%"=="q" goto :EXIT
if "%CHOICE%"=="1"  set "SUB_PATH=tools\dev-setup-center\DevSetupCenter.bat"& goto :RUN_TOOL
if "%CHOICE%"=="2"  set "SUB_PATH=tools\dev-project-forge\DevProjectForge.bat"& goto :RUN_TOOL
if "%CHOICE%"=="3"  set "SUB_PATH=tools\dev-doctor\DevDoctor.bat"& goto :RUN_TOOL
if "%CHOICE%"=="4"  set "SUB_PATH=tools\dev-github-toolkit\DevGitHubToolkit.bat"& goto :RUN_TOOL
if "%CHOICE%"=="5"  set "SUB_PATH=tools\dev-package-hub\DevPackageHub.bat"& goto :RUN_TOOL
if "%CHOICE%"=="6"  set "SUB_PATH=tools\dev-system-toolkit\DevSystemToolkit.bat"& goto :RUN_TOOL
if "%CHOICE%"=="7"  set "SUB_PATH=tools\dev-file-organizer\DevFileOrganizer.bat"& goto :RUN_TOOL
if "%CHOICE%"=="8"  set "SUB_PATH=tools\dev-clean-master\DevCleanMaster.bat"& goto :RUN_TOOL
if "%CHOICE%"=="9"  set "SUB_PATH=tools\dev-quick-server\DevQuickServer.bat"& goto :RUN_TOOL
if "%CHOICE%"=="10" set "SUB_PATH=tools\dev-key-forge\DevKeyForge.bat"& goto :RUN_TOOL
if "%CHOICE%"=="11" set "SUB_PATH=tools\dev-ram-booster\DevRamBooster.bat"& goto :RUN_TOOL

echo.
echo !C_RED!  [ERROR] Invalid selection: %CHOICE%!C_RESET!
timeout /t 2 >nul
goto :MAIN_MENU

:RUN_TOOL
REM Check local repository file
set "EXEC_BAT="
if exist "%~dp0%SUB_PATH%" set "EXEC_BAT=%~dp0%SUB_PATH%"
if not defined EXEC_BAT (
    if exist "%SUB_PATH%" set "EXEC_BAT=%SUB_PATH%"
)

REM If not found locally, cache from remote GitHub
if not defined EXEC_BAT (
    set "CACHE_DIR=%LOCALAPPDATA%\DevToolsSuite\cache"
    if not exist "!CACHE_DIR!" mkdir "!CACHE_DIR!" >nul 2>&1
    for %%F in ("%SUB_PATH%") do set "F_NAME=%%~nxF"
    set "EXEC_BAT=!CACHE_DIR!\!F_NAME!"
    
    echo.
    echo !C_CYAN!  [DEV] Downloading !F_NAME!... !C_RESET!
    set "REMOTE_URL=%RAW_BASE%/%SUB_PATH:\=/%"
    powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '!REMOTE_URL!' -OutFile '!EXEC_BAT!' -UseBasicParsing" >nul 2>&1
    if not exist "!EXEC_BAT!" (
        echo !C_RED!  [ERROR] Failed to download tool from GitHub.!C_RESET!
        timeout /t 2 >nul
        goto :MAIN_MENU
    )
)

echo.
echo !C_GREEN!  [DEV] Launching tool...!C_RESET!
call "%EXEC_BAT%" %2 %3 %4 %5

if not "%~1"=="" goto :EXIT

echo.
echo !C_CYAN!  --------------------------------------------------------------------------------!C_RESET!
set "CONT="
set /p "CONT=  Press Enter to return to Suite Menu, or 0 to exit: "
if "%CONT%"=="0" goto :EXIT
if /i "%CONT%"=="q" goto :EXIT
goto :MAIN_MENU

:EXIT
cls
echo.
echo !C_GREEN!  Thank you for using DEV Tools Suite.!C_RESET!
echo !C_GRAY!  Provider: AnoS ^| Developer Tools Suite!C_RESET!
echo.
endlocal
exit /b 0
