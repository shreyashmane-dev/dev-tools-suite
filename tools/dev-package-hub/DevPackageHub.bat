@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV PACKAGE HUB
REM Developer Package Manager Interface for Windows (WinGet)
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV PACKAGE HUB
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

set "APP_NAME=DEV Package Hub"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"

REM Log file initialization
set "LOG_DIR=%LOCALAPPDATA%\DevToolsSuite"
if not exist "%LOG_DIR%" md "%LOG_DIR%" >nul 2>&1
set "LOG_FILE=%LOG_DIR%\package-hub.log"

set "WINGET_OK=0"
call :CHECK_WINGET

goto :MAIN_MENU

REM ------------------------------------------------------------
REM WINGET DETECTION
REM ------------------------------------------------------------
:CHECK_WINGET
where winget >nul 2>&1
if errorlevel 1 (
    set "WINGET_OK=0"
    exit /b
)
winget --version >nul 2>&1
if errorlevel 1 (
    set "WINGET_OK=0"
) else (
    set "WINGET_OK=1"
)
exit /b

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

echo  !C_WHITE!BACKEND STATUS!C_RESET!
if "!WINGET_OK!"=="1" (
    for /f "delims=" %%V in ('winget --version 2^>nul') do (
        echo  WinGet Provider : !C_GREEN!Available (%%V)!C_RESET!
    )
) else (
    echo  WinGet Provider : !C_RED!Not Detected (Install Windows App Installer)!C_RESET!
)
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET! Search Packages               !C_CYAN![6]!C_RESET! Package Information
echo    !C_CYAN![2]!C_RESET! Install Package               !C_CYAN![7]!C_RESET! Developer Quick-Picks
echo    !C_CYAN![3]!C_RESET! Upgrade Packages              !C_CYAN![8]!C_RESET! Refresh Package Sources
echo    !C_CYAN![4]!C_RESET! Uninstall Package             !C_CYAN![9]!C_RESET! Diagnostics & History
echo    !C_CYAN![5]!C_RESET! Installed Packages List       !C_RED![0]!C_RESET! Exit
echo.

set "CHOICE="
set /p "CHOICE=Select an option [0-9]: "
if "!CHOICE!"=="1" goto :SEARCH_PKG
if "!CHOICE!"=="2" goto :INSTALL_PKG
if "!CHOICE!"=="3" goto :UPGRADE_PKG
if "!CHOICE!"=="4" goto :UNINSTALL_PKG
if "!CHOICE!"=="5" goto :LIST_PKG
if "!CHOICE!"=="6" goto :INFO_PKG
if "!CHOICE!"=="7" goto :DEV_PACKAGES
if "!CHOICE!"=="8" goto :REFRESH_SOURCES
if "!CHOICE!"=="9" goto :DIAG_HISTORY
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 9.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] SEARCH PACKAGES
REM ------------------------------------------------------------
:SEARCH_PKG
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!SEARCH WINGET REPOSITORY!C_RESET!
echo  ----------------------------------------------------------------------
if "!WINGET_OK!"=="0" (
    echo !C_RED![FAIL] WinGet is required for searching packages.!C_RESET!
    pause
    goto :MAIN_MENU
)

set "QUERY="
set /p "QUERY=Enter package name or keyword to search: "
if not defined QUERY goto :MAIN_MENU

echo.
echo  Searching WinGet catalog for: !C_CYAN!"%QUERY%"!C_RESET! ...
echo.
winget search "%QUERY%" --source winget
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [2] INSTALL PACKAGE
REM ------------------------------------------------------------
:INSTALL_PKG
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!INSTALL PACKAGE!C_RESET!
echo  ----------------------------------------------------------------------
if "!WINGET_OK!"=="0" (
    echo !C_RED![FAIL] WinGet is required to install packages.!C_RESET!
    pause
    goto :MAIN_MENU
)

set "IN_ID="
set /p "IN_ID=Enter exact Package ID (e.g. Git.Git, OpenJS.NodeJS.LTS): "
if not defined IN_ID goto :MAIN_MENU

echo.
echo  Target Package ID : !C_CYAN!%IN_ID%!C_RESET!
echo  Source            : winget official community repository
echo.
set "CONFIRM_IN="
set /p "CONFIRM_IN=Confirm installation? [Y/N]: "
if /I not "!CONFIRM_IN!"=="Y" (
    echo !C_YELLOW!Installation cancelled.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo.
echo  ----------------------------------------------------------------------
echo  Starting installation...
echo  ----------------------------------------------------------------------
winget install --id "%IN_ID%" -e --source winget --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
    echo.
    echo  !C_RED![FAIL] Installation failed or was cancelled by user.!C_RESET!
    >> "%LOG_FILE%" echo %date% %time% ^| FAILED INSTALL ^| %IN_ID%
) else (
    echo.
    echo  !C_GREEN![OK] %IN_ID% installed successfully.!C_RESET!
    >> "%LOG_FILE%" echo %date% %time% ^| INSTALLED ^| %IN_ID%
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [3] UPGRADE PACKAGES
REM ------------------------------------------------------------
:UPGRADE_PKG
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!UPGRADE PACKAGES!C_RESET!
echo  ----------------------------------------------------------------------
if "!WINGET_OK!"=="0" (
    echo !C_RED![FAIL] WinGet is required.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo  Checking for available updates across all installed packages...
echo.
winget upgrade --include-unknown
echo.
echo    !C_CYAN![1]!C_RESET! Upgrade specific package by ID
echo    !C_CYAN![2]!C_RESET! Upgrade ALL available packages
echo    !C_RED![0]!C_RESET! Back to Menu
echo.
set "UP_OPT="
set /p "UP_OPT=Select action [0-2]: "
if "!UP_OPT!"=="1" (
    set "UP_ID="
    set /p "UP_ID=Enter Package ID to upgrade: "
    if defined UP_ID (
        echo.
        winget upgrade --id "!UP_ID!" --accept-source-agreements --accept-package-agreements
        >> "%LOG_FILE%" echo %date% %time% ^| UPGRADE ^| !UP_ID!
    )
)
if "!UP_OPT!"=="2" (
    echo.
    set "CONF_ALL="
    set /p "CONF_ALL=Are you sure you want to upgrade ALL packages? [Y/N]: "
    if /I "!CONF_ALL!"=="Y" (
        winget upgrade --all --accept-source-agreements --accept-package-agreements
        >> "%LOG_FILE%" echo %date% %time% ^| UPGRADE ALL ^| Success
    )
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [4] UNINSTALL PACKAGE
REM ------------------------------------------------------------
:UNINSTALL_PKG
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!UNINSTALL PACKAGE!C_RESET!
echo  ----------------------------------------------------------------------
if "!WINGET_OK!"=="0" (
    echo !C_RED![FAIL] WinGet is required.!C_RESET!
    pause
    goto :MAIN_MENU
)

set "UN_ID="
set /p "UN_ID=Enter Package ID or name to uninstall: "
if not defined UN_ID goto :MAIN_MENU

echo.
echo  !C_RED!!C_BOLD!CONFIRMATION REQUIRED!C_RESET!
echo  You are about to uninstall: !C_YELLOW!%UN_ID%!C_RESET!
echo.
set "UN_CONF="
set /p "UN_CONF=Are you sure you want to proceed with removal? [Y/N]: "
if /I not "!UN_CONF!"=="Y" (
    echo !C_CYAN!Uninstallation cancelled. No changes made.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo.
echo  Uninstalling %UN_ID%...
winget uninstall --id "%UN_ID%"
if errorlevel 1 (
    echo !C_RED![FAIL] Could not uninstall %UN_ID%.!C_RESET!
    >> "%LOG_FILE%" echo %date% %time% ^| FAILED UNINSTALL ^| %UN_ID%
) else (
    echo !C_GREEN![OK] %UN_ID% uninstalled.!C_RESET!
    >> "%LOG_FILE%" echo %date% %time% ^| UNINSTALLED ^| %UN_ID%
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [5] INSTALLED PACKAGES
REM ------------------------------------------------------------
:LIST_PKG
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!INSTALLED PACKAGES!C_RESET!
echo  ----------------------------------------------------------------------
if "!WINGET_OK!"=="0" (
    echo !C_RED![FAIL] WinGet is required.!C_RESET!
    pause
    goto :MAIN_MENU
)

set "FILTER="
set /p "FILTER=Filter query [Press Enter to show all]: "
echo.
if defined FILTER (
    winget list "%FILTER%"
) else (
    winget list
)
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [6] PACKAGE INFO
REM ------------------------------------------------------------
:INFO_PKG
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!PACKAGE METADATA & INFORMATION!C_RESET!
echo  ----------------------------------------------------------------------
if "!WINGET_OK!"=="0" (
    echo !C_RED![FAIL] WinGet is required.!C_RESET!
    pause
    goto :MAIN_MENU
)

set "INFO_ID="
set /p "INFO_ID=Enter Package ID (e.g. Git.Git): "
if not defined INFO_ID goto :MAIN_MENU

echo.
winget show --id "%INFO_ID%" -e --source winget
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [7] DEVELOPER QUICK-PICKS
REM ------------------------------------------------------------
:DEV_PACKAGES
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!DEVELOPER QUICK-PICKS!C_RESET!
echo  ----------------------------------------------------------------------
echo  Choose a category to browse popular packages:
echo    !C_CYAN![1]!C_RESET! Compilers & Core Runtimes
echo    !C_CYAN![2]!C_RESET! IDEs & Text Editors
echo    !C_CYAN![3]!C_RESET! Database Servers & Clients
echo    !C_CYAN![4]!C_RESET! Cloud, Containers & DevOps
echo    !C_CYAN![5]!C_RESET! Power Utilities & Tools
echo    !C_RED![0]!C_RESET! Back to Menu
echo.

set "DP_CAT="
set /p "DP_CAT=Select category [0-5]: "
if "!DP_CAT!"=="1" call :SUB_PICK "COMPILERS & RUNTIMES" "Python.Python.3.14 OpenJS.NodeJS.LTS GoLang.Go Rustlang.Rustup Microsoft.OpenJDK.21 Kitware.CMake DenoLand.Deno"
if "!DP_CAT!"=="2" call :SUB_PICK "IDES & TEXT EDITORS" "Microsoft.VisualStudioCode JetBrains.Toolbox JetBrains.IntelliJIDEA.Community JetBrains.PyCharm.Community Neovim.Neovim dail8859.NotepadNext"
if "!DP_CAT!"=="3" call :SUB_PICK "DATABASES" "dbeaver.dbeaver PostgreSQL.PostgreSQL MongoDB.Server MongoDB.MongoDBCLI Insomnia.Insomnia Postman.Postman"
if "!DP_CAT!"=="4" call :SUB_PICK "CLOUD & DEVOPS" "Docker.DockerDesktop RedHat.Podman HashiCorp.Terraform Kubernetes.kubectl Helm.Helm Amazon.AWSCLI Microsoft.AzureCLI Google.CloudSDK"
if "!DP_CAT!"=="5" call :SUB_PICK "POWER UTILITIES" "Microsoft.PowerToys Microsoft.WindowsTerminal 7zip.7zip Git.Git GitHub.cli voidtools.Everything"
goto :MAIN_MENU

:SUB_PICK
set "CAT_NAME=%~1"
set "CAT_PKGS=%~2"
cls
call :HEADER
echo  !C_WHITE!QUICK-PICKS / !CAT_NAME!!C_RESET!
echo  ----------------------------------------------------------------------
set /a CNT=0
for %%P in (!CAT_PKGS!) do (
    set /a CNT+=1
    set "P_!CNT!=%%P"
    echo    !C_CYAN![!CNT!]!C_RESET! %%P
)
echo    !C_RED![0]!C_RESET! Back
echo.
set "CHOOSEN_P="
set /p "CHOOSEN_P=Enter number to install [0-!CNT!]: "
if "!CHOOSEN_P!"=="0" exit /b
if defined CHOOSEN_P (
    set "SELECTED_PKG=!P_%CHOOSEN_P%!"
    if defined SELECTED_PKG (
        echo.
        echo Installing !SELECTED_PKG!...
        winget install --id "!SELECTED_PKG!" -e --source winget --accept-source-agreements --accept-package-agreements
        >> "%LOG_FILE%" echo %date% %time% ^| QUICK-PICK ^| !SELECTED_PKG!
        pause
    )
)
exit /b

REM ------------------------------------------------------------
REM [8] REFRESH SOURCES
REM ------------------------------------------------------------
:REFRESH_SOURCES
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!REFRESH WINGET PACKAGE SOURCES!C_RESET!
echo  ----------------------------------------------------------------------
if "!WINGET_OK!"=="0" (
    echo !C_RED![FAIL] WinGet is required.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo  Updating package metadata from WinGet community source...
winget source update
echo.
echo !C_GREEN![OK] WinGet sources updated.!C_RESET!
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [9] DIAGNOSTICS & HISTORY
REM ------------------------------------------------------------
:DIAG_HISTORY
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!DIAGNOSTICS & OPERATION HISTORY!C_RESET!
echo  ----------------------------------------------------------------------
echo  WinGet Diagnostic Information:
winget --info 2>nul
echo.
echo  ----------------------------------------------------------------------
echo  Recent DEV Package Hub Operation History:
echo  Log file: !C_CYAN!%LOG_FILE%!C_RESET!
echo.
if exist "%LOG_FILE%" (
    powershell -NoProfile -Command "Get-Content -Path '%LOG_FILE%' -Tail 15" 2>nul
) else (
    echo  No operations logged yet.
)
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
