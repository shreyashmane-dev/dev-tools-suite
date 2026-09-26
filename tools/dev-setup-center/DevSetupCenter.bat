@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV SETUP CENTER
REM Developer Environment Installer & Environment Manager
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEVELOPER SETUP CENTER
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

set "APP_NAME=DEV Setup Center"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"
set "TOTAL_APPS=46"
set "REPORT_FILE=%~dp0Dev-Environment-Report.txt"
set "CATALOG_CACHE=%TEMP%\DevSetupCenter_Catalog.txt"

set "WINGET_OK=0"
set "ADMIN_OK=0"
set "CATALOG_OK=0"
set /a INSTALLED_COUNT=0
set /a FAILED_COUNT=0
set /a SKIPPED_COUNT=0

call :INIT_CATALOG
call :INIT_STATUS
goto :BOOT_SCAN

REM ------------------------------------------------------------
REM INITIALIZE CATALOG METADATA
REM ------------------------------------------------------------
:INIT_CATALOG
set "NAME_1=Git"                        & set "PKG_1=Git.Git"                           & set "CMD_1=git"
set "NAME_2=GitHub CLI"                 & set "PKG_2=GitHub.cli"                        & set "CMD_2=gh"
set "NAME_3=Visual Studio Code"         & set "PKG_3=Microsoft.VisualStudioCode"        & set "CMD_3=code"
set "NAME_4=Python 3.14"                & set "PKG_4=Python.Python.3.14"               & set "CMD_4=python"
set "NAME_5=Node.js LTS + npm"          & set "PKG_5=OpenJS.NodeJS.LTS"                 & set "CMD_5=node"
set "NAME_6=CMake"                      & set "PKG_6=Kitware.CMake"                     & set "CMD_6=cmake"
set "NAME_7=PowerShell 7"               & set "PKG_7=Microsoft.PowerShell"              & set "CMD_7=pwsh"
set "NAME_8=7-Zip"                      & set "PKG_8=7zip.7zip"                         & set "CMD_8=7z"
set "NAME_9=Docker Desktop"             & set "PKG_9=Docker.DockerDesktop"              & set "CMD_9=docker"
set "NAME_10=OpenJDK 21"                & set "PKG_10=Microsoft.OpenJDK.21"             & set "CMD_10=java"
set "NAME_11=Go Programming Language"   & set "PKG_11=GoLang.Go"                        & set "CMD_11=go"
set "NAME_12=Rustup (Rust Toolchain)"   & set "PKG_12=Rustlang.Rustup"                  & set "CMD_12=rustc"
set "NAME_13=C/C++ Build Tools"         & set "PKG_13=Microsoft.VisualStudio.2022.BuildTools" & set "CMD_13=cl"
set "NAME_14=Postman API Client"        & set "PKG_14=Postman.Postman"                  & set "CMD_14=postman"
set "NAME_15=Deno Runtime"              & set "PKG_15=DenoLand.Deno"                    & set "CMD_15=deno"
set "NAME_16=JetBrains Toolbox"         & set "PKG_16=JetBrains.Toolbox"                & set "CMD_16="
set "NAME_17=IntelliJ IDEA Community"   & set "PKG_17=JetBrains.IntelliJIDEA.Community" & set "CMD_17=idea"
set "NAME_18=PyCharm Community"         & set "PKG_18=JetBrains.PyCharm.Community"      & set "CMD_18=pycharm"
set "NAME_19=Azure CLI"                 & set "PKG_19=Microsoft.AzureCLI"               & set "CMD_19=az"
set "NAME_20=AWS CLI"                   & set "PKG_20=Amazon.AWSCLI"                    & set "CMD_20=aws"
set "NAME_21=Google Cloud SDK"          & set "PKG_21=Google.CloudSDK"                 & set "CMD_21=gcloud"
set "NAME_22=Terraform"                 & set "PKG_22=HashiCorp.Terraform"              & set "CMD_22=terraform"
set "NAME_23=HashiCorp Vagrant"         & set "PKG_23=Hashicorp.Vagrant"                & set "CMD_23=vagrant"
set "NAME_24=kubectl (Kubernetes CLI)"  & set "PKG_24=Kubernetes.kubectl"               & set "CMD_24=kubectl"
set "NAME_25=Helm (K8s Package Mgr)"    & set "PKG_25=Helm.Helm"                        & set "CMD_25=helm"
set "NAME_26=Podman Desktop"            & set "PKG_26=RedHat.Podman"                    & set "CMD_26=podman"
set "NAME_27=DBeaver Universal DB"      & set "PKG_27=dbeaver.dbeaver"                  & set "CMD_27=dbeaver"
set "NAME_28=PostgreSQL Database"       & set "PKG_28=PostgreSQL.PostgreSQL"           & set "CMD_28=psql"
set "NAME_29=pgAdmin 4"                 & set "PKG_29=PostgreSQL.pgAdmin"               & set "CMD_29=pgadmin4"
set "NAME_30=MongoDB Community Server"  & set "PKG_30=MongoDB.Server"                   & set "CMD_30=mongod"
set "NAME_31=MongoDB Shell (mongosh)"   & set "PKG_31=MongoDB.MongoDBCLI"              & set "CMD_31=mongosh"
set "NAME_32=Insomnia REST Client"      & set "PKG_32=Insomnia.Insomnia"                & set "CMD_32=insomnia"
set "NAME_33=OBS Studio"                & set "PKG_33=OBSProject.OBSStudio"             & set "CMD_33=obs64"
set "NAME_34=VLC Media Player"          & set "PKG_34=VideoLAN.VLC"                     & set "CMD_34=vlc"
set "NAME_35=ShareX Screen Capture"     & set "PKG_35=ShareX.ShareX"                   & set "CMD_35=sharex"
set "NAME_36=GIMP Image Editor"         & set "PKG_36=GIMP.GIMP"                        & set "CMD_36=gimp"
set "NAME_37=Inkscape Vector Graphics"  & set "PKG_37=Inkscape.Inkscape"                & set "CMD_37=inkscape"
set "NAME_38=Krita Digital Painting"    & set "PKG_38=KDE.Krita"                        & set "CMD_38=krita"
set "NAME_39=Everything File Search"    & set "PKG_39=voidtools.Everything"             & set "CMD_39=everything"
set "NAME_40=Sysinternals Autoruns"     & set "PKG_40=Microsoft.Sysinternals.Autoruns"  & set "CMD_40=autoruns"
set "NAME_41=Notepad Next"              & set "PKG_41=dail8859.NotepadNext"             & set "CMD_41=notepad-next"
set "NAME_42=GitHub Desktop"            & set "PKG_42=GitHub.GitHubDesktop"            & set "CMD_42=github"
set "NAME_43=Microsoft PowerToys"       & set "PKG_43=Microsoft.PowerToys"              & set "CMD_43=powertoys"
set "NAME_44=Windows Terminal"          & set "PKG_44=Microsoft.WindowsTerminal"        & set "CMD_44=wt"
set "NAME_45=Blender 3D Suite"          & set "PKG_45=BlenderFoundation.Blender"        & set "CMD_45=blender"
set "NAME_46=MongoDB Database Tools"    & set "PKG_46=MongoDB.DatabaseTools"            & set "CMD_46=mongoimport"
exit /b

REM ------------------------------------------------------------
REM INITIALIZE STATUS FLAGS
REM ------------------------------------------------------------
:INIT_STATUS
for /L %%A in (1,1,%TOTAL_APPS%) do (
    set "STATUS_%%A=MISSING"
)
exit /b

REM ------------------------------------------------------------
REM BOOT / STARTUP SCAN
REM ------------------------------------------------------------
:BOOT_SCAN
cls
call :HEADER
echo  !C_WHITE!SYSTEM STARTUP SCAN!C_RESET!
echo  ----------------------------------------------------------------------
echo  [1/4] Checking Windows Package Manager (WinGet)...
call :CHECK_WINGET
if "!WINGET_OK!"=="1" (
    echo        !C_GREEN![OK]!C_RESET! WinGet package manager is ready.
) else (
    echo        !C_YELLOW![WARN]!C_RESET! WinGet was not detected in PATH.
)

echo.
echo  [2/4] Checking Administrator Privileges...
call :CHECK_ADMIN
if "!ADMIN_OK!"=="1" (
    echo        !C_GREEN![OK]!C_RESET! Administrator privileges detected.
) else (
    echo        !C_CYAN![INFO]!C_RESET! Standard user privileges.
)

echo.
echo  [3/4] Scanning Local Developer Tools...
call :SCAN_LOCAL_COMMANDS
echo        !C_GREEN![OK]!C_RESET! Command scan completed.

echo.
echo  [4/4] Scanning WinGet Package Catalog...
call :SCAN_WINGET_CATALOG
if "!CATALOG_OK!"=="1" (
    echo        !C_GREEN![OK]!C_RESET! Package catalog indexed.
) else (
    echo        !C_CYAN![INFO]!C_RESET! WinGet catalog scan skipped.
)

echo  ----------------------------------------------------------------------
echo  !C_GREEN!DEV Setup Center is ready.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM CHECKS
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

:CHECK_ADMIN
net session >nul 2>&1
if errorlevel 1 (
    set "ADMIN_OK=0"
) else (
    set "ADMIN_OK=1"
)
exit /b

:SCAN_LOCAL_COMMANDS
for /L %%A in (1,1,%TOTAL_APPS%) do (
    set "CURRENT_CMD=!CMD_%%A!"
    if defined CURRENT_CMD (
        where !CURRENT_CMD! >nul 2>&1
        if not errorlevel 1 (
            set "STATUS_%%A=INSTALLED"
        )
    )
)
REM Special detection for C/C++ Build Tools via vswhere
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
    set "VS_FOUND="
    for /f "delims=" %%V in ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2^>nul') do (
        set "VS_FOUND=%%V"
    )
    if defined VS_FOUND set "STATUS_13=INSTALLED"
)
exit /b

:SCAN_WINGET_CATALOG
set "CATALOG_OK=0"
if "!WINGET_OK!"=="0" exit /b

del /q "%CATALOG_CACHE%" >nul 2>&1
winget list --source winget --accept-source-agreements >"%CATALOG_CACHE%" 2>nul
if errorlevel 1 (
    winget list >"%CATALOG_CACHE%" 2>nul
)
if not exist "%CATALOG_CACHE%" exit /b

for /L %%A in (1,1,%TOTAL_APPS%) do (
    set "CPKG=!PKG_%%A!"
    findstr /I /C:"!CPKG!" "%CATALOG_CACHE%" >nul 2>&1
    if not errorlevel 1 (
        set "STATUS_%%A=INSTALLED"
    )
)
set "CATALOG_OK=1"
exit /b

REM ------------------------------------------------------------
REM HEADER BANNER
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
REM TWO COLUMN STATUS DISPLAY (WITH CLEAR NUMBERED SELECTION)
REM ------------------------------------------------------------
:TWO_COLUMN_STATUS
set "TARGET_IDS=%~1"
for /L %%A in (1,1,50) do (
    set "COL_L_%%A="
    set "COL_R_%%A="
    set "MAP_R_%%A="
)
set /a NUM_L=0
set /a NUM_R=0

for %%N in (!TARGET_IDS!) do (
    set "LABEL=!NAME_%%N!"
    set "STAT=!STATUS_%%N!"
    if /I "!STAT!"=="INSTALLED" (
        set /a NUM_L+=1
        set "COL_L_!NUM_L!=!LABEL!"
    ) else (
        set /a NUM_R+=1
        set "COL_R_!NUM_R!=!LABEL!"
        set "MAP_R_!NUM_R!=%%N"
    )
)

echo   !C_GREEN!!C_BOLD!INSTALLED (!NUM_L!)!C_RESET!                             !C_RED!!C_BOLD!MISSING (!NUM_R! to install)!C_RESET!
echo   --------------------------------------------------------------------------------
set /a MAX_ROWS=NUM_L
if !NUM_R! GTR !MAX_ROWS! set /a MAX_ROWS=NUM_R

if !MAX_ROWS! EQU 0 (
    echo   No applications in this category.
    exit /b
)

for /L %%R in (1,1,!MAX_ROWS!) do (
    set "ITEM_L=!COL_L_%%R!"
    set "ITEM_R=!COL_R_%%R!"
    if defined ITEM_L (
        set "ITEM_L=[OK] !ITEM_L!"
    ) else (
        set "ITEM_L=     -"
    )
    if defined ITEM_R (
        set "ITEM_R=[%%R] !ITEM_R!"
    ) else (
        set "ITEM_R=     -"
    )
    
    set "ITEM_L=!ITEM_L!                                        "
    set "ITEM_R=!ITEM_R!                                        "
    echo   !C_GREEN!!ITEM_L:~0,38!!C_RESET!  !C_RED!!ITEM_R:~0,38!!C_RESET!
)
echo   --------------------------------------------------------------------------------
echo   !C_GREEN!Installed: !NUM_L!!C_RESET!                            !C_RED!Missing: !NUM_R!!C_RESET!
exit /b

REM ------------------------------------------------------------
REM COUNT OVERALL STATS
REM ------------------------------------------------------------
:COUNT_TOTALS
set /a TOTAL_INSTALLED=0
set /a TOTAL_MISSING=0
for /L %%A in (1,1,%TOTAL_APPS%) do (
    if /I "!STATUS_%%A!"=="INSTALLED" (
        set /a TOTAL_INSTALLED+=1
    ) else (
        set /a TOTAL_MISSING+=1
    )
)
exit /b

REM ------------------------------------------------------------
REM MAIN MENU
REM ------------------------------------------------------------
:MAIN_MENU
cls
call :HEADER
call :COUNT_TOTALS

echo  !C_WHITE!SYSTEM STATUS!C_RESET!
echo  WinGet: !C_CYAN!!WINGET_OK!!C_RESET! (1=OK)   Admin: !C_CYAN!!ADMIN_OK!!C_RESET! (1=Yes)   Catalog: !C_YELLOW!%TOTAL_APPS%!C_RESET! Tools
echo  Environment: !C_GREEN!Installed: !TOTAL_INSTALLED!!C_RESET!  ^|  !C_RED!Missing: !TOTAL_MISSING!!C_RESET!
echo.
echo  !C_WHITE!CORE ESSENTIALS PREVIEW!C_RESET!
call :TWO_COLUMN_STATUS "1 2 3 4 5 6 7 8 9 10 13"
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET! Standard Developer Pack        !C_CYAN![6]!C_RESET! System Information
echo    !C_CYAN![2]!C_RESET! Custom Installation              !C_CYAN![7]!C_RESET! Google Antigravity
echo    !C_CYAN![3]!C_RESET! Developer Packs                  !C_CYAN![8]!C_RESET! Generate Report
echo    !C_CYAN![4]!C_RESET! Refresh Scan                     !C_CYAN![9]!C_RESET! About DEV
echo    !C_CYAN![5]!C_RESET! Diagnostics                      !C_RED![0]!C_RESET! Exit
echo.

set "EMPTY_COUNT=0"

REM --- Direct CLI Argument Routing
if not "%~1"=="" (
    set "CHOICE=%~1"
    if "%~1"=="1" goto :STANDARD_PACK
    if "%~1"=="2" goto :CUSTOM_MENU
    if "%~1"=="3" goto :PACKS_MENU
    if "%~1"=="4" goto :REFRESH_MENU
    if "%~1"=="5" goto :DIAGNOSTICS_MENU
    if "%~1"=="6" goto :SYSTEM_INFO_MENU
    if "%~1"=="7" goto :ANTIGRAVITY_MENU
    if "%~1"=="8" goto :REPORT_MENU
    if "%~1"=="9" goto :ABOUT_MENU
    if "%~1"=="0" goto :EXIT
)

set "CHOICE="
set /p "CHOICE=Select an option [0-9]: "
if not defined CHOICE (
    set /a EMPTY_COUNT+=1
    if !EMPTY_COUNT! geq 3 goto :EXIT
    goto :MAIN_MENU
)
set "EMPTY_COUNT=0"

if "!CHOICE!"=="1" goto :STANDARD_PACK
if "!CHOICE!"=="2" goto :CUSTOM_MENU
if "!CHOICE!"=="3" goto :PACKS_MENU
if "!CHOICE!"=="4" goto :REFRESH_MENU
if "!CHOICE!"=="5" goto :DIAGNOSTICS_MENU
if "!CHOICE!"=="6" goto :SYSTEM_INFO_MENU
if "!CHOICE!"=="7" goto :ANTIGRAVITY_MENU
if "!CHOICE!"=="8" goto :REPORT_MENU
if "!CHOICE!"=="9" goto :ABOUT_MENU
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 9.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM STANDARD DEVELOPER PACK
REM ------------------------------------------------------------
:STANDARD_PACK
cls
call :HEADER
echo   !C_CYAN!::!C_RESET! !C_WHITE!!C_BOLD!STANDARD DEVELOPER PACK!C_RESET!
echo   The recommended foundational stack for Windows development.
echo.
set "STD_IDS=1 2 3 4 5 6 7 8 9 10 13"
call :TWO_COLUMN_STATUS "!STD_IDS!"
echo.

if !NUM_R! EQU 0 (
    echo   !C_GREEN![OK] All tools in the Standard Pack are already installed!!C_RESET!
    echo.
    pause
    goto :MAIN_MENU
)

echo   !C_WHITE!!C_BOLD!SELECTION ACTIONS:!C_RESET!
echo     - Type !C_GREEN!Y!C_RESET! or !C_GREEN!A!C_RESET! to install ALL !NUM_R! missing tools
echo     - Type specific numbers (e.g. !C_CYAN!1 2 3!C_RESET!) to install only those
echo     - Type !C_RED!Q!C_RESET! or !C_RED!N!C_RESET! to return to main menu
echo.
set "CONFIRM="
set /p "CONFIRM=  Select option: "
if /I "!CONFIRM!"=="Q" goto :MAIN_MENU
if /I "!CONFIRM!"=="N" goto :MAIN_MENU
if /I "!CONFIRM!"=="" goto :MAIN_MENU

set "INSTALL_IDS="
if /I "!CONFIRM!"=="Y" set "CONFIRM=A"
if /I "!CONFIRM!"=="A" (
    for /L %%K in (1,1,!NUM_R!) do (
        set "INSTALL_IDS=!INSTALL_IDS! !MAP_R_%%K!"
    )
) else (
    for %%K in (!CONFIRM!) do (
        set "REAL_ID=!MAP_R_%%K!"
        if defined REAL_ID (
            set "INSTALL_IDS=!INSTALL_IDS! !REAL_ID!"
        )
    )
)

if not defined INSTALL_IDS (
    echo   !C_YELLOW![WARN]!C_RESET! No valid tools selected.
    timeout /t 2 >nul
    goto :MAIN_MENU
)

set /a INSTALLED_COUNT=0
set /a FAILED_COUNT=0
set /a SKIPPED_COUNT=0

for %%N in (!INSTALL_IDS!) do (
    call :INSTALL_APP %%N
)

call :REFRESH_INTERNAL
call :SHOW_SUMMARY
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM CUSTOM INSTALLATION MENU
REM ------------------------------------------------------------
:CUSTOM_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CUSTOM INSTALLATION!C_RESET!
echo  Select a category to view and install individual tools:
echo.
echo    !C_CYAN![1]!C_RESET! Core and Editors               !C_CYAN![6]!C_RESET! Cloud and DevOps
echo    !C_CYAN![2]!C_RESET! Web and JavaScript             !C_CYAN![7]!C_RESET! Database and API
echo    !C_CYAN![3]!C_RESET! Python and Data                !C_CYAN![8]!C_RESET! Creative and Media
echo    !C_CYAN![4]!C_RESET! C and C++ Systems              !C_CYAN![9]!C_RESET! Windows Utilities
echo    !C_CYAN![5]!C_RESET! Java and JVM                   !C_RED![0]!C_RESET! Back to Main Menu
echo.

set "CCAT="
set /p "CCAT=Select category [0-9]: "
if "!CCAT!"=="1" call :CATEGORY_VIEW "CORE AND EDITORS" "1 2 3 7 8 6 16 42"
if "!CCAT!"=="2" call :CATEGORY_VIEW "WEB AND JAVASCRIPT" "5 15 14 32 1 2 3 42"
if "!CCAT!"=="3" call :CATEGORY_VIEW "PYTHON AND DATA" "4 18 27 28 30 31 3 1"
if "!CCAT!"=="4" call :CATEGORY_VIEW "C AND C++ SYSTEMS" "13 6 12 11 7 44 39 40"
if "!CCAT!"=="5" call :CATEGORY_VIEW "JAVA AND JVM" "10 17 16 3 1 2 8"
if "!CCAT!"=="6" call :CATEGORY_VIEW "CLOUD AND DEVOPS" "9 19 20 21 22 23 24 25 26"
if "!CCAT!"=="7" call :CATEGORY_VIEW "DATABASE AND API" "27 28 29 30 31 46 14 32"
if "!CCAT!"=="8" call :CATEGORY_VIEW "CREATIVE AND MEDIA" "45 36 37 38 33 34 35"
if "!CCAT!"=="9" call :CATEGORY_VIEW "WINDOWS UTILITIES" "39 40 41 43 44 42 8 7"
if "!CCAT!"=="0" goto :MAIN_MENU
goto :CUSTOM_MENU

:CATEGORY_VIEW
set "VIEW_TITLE=%~1"
set "VIEW_IDS=%~2"
cls
call :HEADER
echo   !C_CYAN!::!C_RESET! !C_WHITE!!C_BOLD!CUSTOM / !VIEW_TITLE!!C_RESET!
echo.
call :TWO_COLUMN_STATUS "!VIEW_IDS!"
echo.

if !NUM_R! EQU 0 (
    echo   !C_GREEN![OK] All applications in this category are already installed!!C_RESET!
    echo.
    pause
    exit /b
)

echo   !C_WHITE!!C_BOLD!SELECTION ACTIONS:!C_RESET!
echo     - Type item numbers separated by spaces (e.g. !C_CYAN!1 3 5!C_RESET! or !C_CYAN!1!C_RESET!)
echo     - Type !C_GREEN!A!C_RESET! to install ALL !NUM_R! missing tools
echo     - Type !C_RED!Q!C_RESET! to return to category list
echo.
set "SEL="
set /p "SEL=  Select tools to install: "
if /I "!SEL!"=="Q" exit /b
if /I "!SEL!"=="" exit /b

set "INSTALL_IDS="
if /I "!SEL!"=="A" (
    for /L %%K in (1,1,!NUM_R!) do (
        set "INSTALL_IDS=!INSTALL_IDS! !MAP_R_%%K!"
    )
) else (
    for %%K in (!SEL!) do (
        set "REAL_ID=!MAP_R_%%K!"
        if defined REAL_ID (
            set "INSTALL_IDS=!INSTALL_IDS! !REAL_ID!"
        )
    )
)

if not defined INSTALL_IDS (
    echo   !C_YELLOW![WARN]!C_RESET! No valid missing tool numbers were selected.
    timeout /t 2 >nul
    exit /b
)

set /a INSTALLED_COUNT=0
set /a FAILED_COUNT=0
set /a SKIPPED_COUNT=0

for %%N in (!INSTALL_IDS!) do (
    call :INSTALL_APP %%N
)

call :REFRESH_INTERNAL
call :SHOW_SUMMARY
pause
exit /b

REM ------------------------------------------------------------
REM DEVELOPER PACKS MENU
REM ------------------------------------------------------------
:PACKS_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!DEVELOPER PACKS!C_RESET!
echo  Curated technology stacks for immediate onboarding:
echo.
echo    !C_CYAN![1]!C_RESET! Web and JavaScript Pack        !C_CYAN![6]!C_RESET! Database and API Pack
echo    !C_CYAN![2]!C_RESET! Python and Data Pack           !C_CYAN![7]!C_RESET! Creative and Media Pack
echo    !C_CYAN![3]!C_RESET! C and C++ Systems Pack         !C_CYAN![8]!C_RESET! Windows Power User Pack
echo    !C_CYAN![4]!C_RESET! Java and JVM Pack              !C_CYAN![9]!C_RESET! Full Suite (All 46 Tools)
echo    !C_CYAN![5]!C_RESET! Cloud and DevOps Pack          !C_RED![0]!C_RESET! Back to Main Menu
echo.

set "CPACK="
set /p "CPACK=Select pack [0-9]: "
if "!CPACK!"=="1" call :RUN_PACK "WEB AND JAVASCRIPT PACK" "1 2 3 5 14 15 32 42"
if "!CPACK!"=="2" call :RUN_PACK "PYTHON AND DATA PACK" "1 3 4 18 27 28 30 31"
if "!CPACK!"=="3" call :RUN_PACK "C AND C++ SYSTEMS PACK" "1 2 3 6 7 8 11 12 13 39 40 44"
if "!CPACK!"=="4" call :RUN_PACK "JAVA AND JVM PACK" "1 2 3 10 16 17"
if "!CPACK!"=="5" call :RUN_PACK "CLOUD AND DEVOPS PACK" "1 2 3 5 9 19 20 21 22 23 24 25 26"
if "!CPACK!"=="6" call :RUN_PACK "DATABASE AND API PACK" "14 27 28 29 30 31 32 46"
if "!CPACK!"=="7" call :RUN_PACK "CREATIVE AND MEDIA PACK" "33 34 35 36 37 38 45"
if "!CPACK!"=="8" call :RUN_PACK "WINDOWS POWER USER PACK" "7 8 39 40 41 42 43 44"
if "!CPACK!"=="9" call :RUN_PACK "FULL DEVELOPER PACK" "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46"
if "!CPACK!"=="0" goto :MAIN_MENU
goto :PACKS_MENU

:RUN_PACK
set "PACK_TITLE=%~1"
set "PACK_IDS=%~2"
cls
call :HEADER
echo   !C_CYAN!::!C_RESET! !C_WHITE!!C_BOLD!DEVELOPER PACK / !PACK_TITLE!!C_RESET!
echo.
call :TWO_COLUMN_STATUS "!PACK_IDS!"
echo.

if !NUM_R! EQU 0 (
    echo   !C_GREEN![OK] All applications in this pack are already installed!!C_RESET!
    echo.
    pause
    exit /b
)

echo   !C_WHITE!!C_BOLD!SELECTION ACTIONS:!C_RESET!
echo     - Type !C_GREEN!Y!C_RESET! or !C_GREEN!A!C_RESET! to install ALL !NUM_R! missing tools
echo     - Type specific numbers (e.g. !C_CYAN!1 2!C_RESET!) to install only those
echo     - Type !C_RED!Q!C_RESET! or !C_RED!N!C_RESET! to go back
echo.
set "PCONF="
set /p "PCONF=  Select option: "
if /I "!PCONF!"=="Q" exit /b
if /I "!PCONF!"=="N" exit /b
if /I "!PCONF!"=="" exit /b

set "INSTALL_IDS="
if /I "!PCONF!"=="Y" set "PCONF=A"
if /I "!PCONF!"=="A" (
    for /L %%K in (1,1,!NUM_R!) do (
        set "INSTALL_IDS=!INSTALL_IDS! !MAP_R_%%K!"
    )
) else (
    for %%K in (!PCONF!) do (
        set "REAL_ID=!MAP_R_%%K!"
        if defined REAL_ID (
            set "INSTALL_IDS=!INSTALL_IDS! !REAL_ID!"
        )
    )
)

if not defined INSTALL_IDS (
    echo   !C_YELLOW![WARN]!C_RESET! No valid tools selected.
    timeout /t 2 >nul
    exit /b
)

set /a INSTALLED_COUNT=0
set /a FAILED_COUNT=0
set /a SKIPPED_COUNT=0

for %%N in (!INSTALL_IDS!) do (
    call :INSTALL_APP %%N
)

call :REFRESH_INTERNAL
call :SHOW_SUMMARY
pause
exit /b
exit /b

REM ------------------------------------------------------------
REM INSTALL LOGIC (DATA-DRIVEN)
REM ------------------------------------------------------------
:INSTALL_APP
set "TID=%~1"
set "TLABEL=!NAME_%TID%!"
set "TPKG=!PKG_%TID%!"
set "TSTAT=!STATUS_%TID%!"

if not defined TLABEL (
    exit /b
)

if /I "!TSTAT!"=="INSTALLED" (
    echo   !C_YELLOW![SKIP]!C_RESET! !TLABEL! is already installed.
    set /a SKIPPED_COUNT+=1
    exit /b
)

if "!WINGET_OK!"=="0" (
    echo   !C_RED![FAIL]!C_RESET! WinGet is required to install !TLABEL!.
    set /a FAILED_COUNT+=1
    exit /b
)

echo.
echo  ----------------------------------------------------------------------
echo  !C_CYAN![INSTALLING]!C_RESET! !TLABEL!
echo  WinGet Package ID: !TPKG!
echo  ----------------------------------------------------------------------

if "%TID%"=="13" (
    winget install --id Microsoft.VisualStudio.2022.BuildTools -e --source winget --accept-source-agreements --accept-package-agreements --override "--wait --passive --norestart --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
) else (
    winget install --id "!TPKG!" -e --source winget --accept-source-agreements --accept-package-agreements
)

if errorlevel 1 (
    echo   !C_RED![FAIL]!C_RESET! Installation of !TLABEL! returned an error.
    set /a FAILED_COUNT+=1
) else (
    echo   !C_GREEN![OK]!C_RESET! !TLABEL! installed successfully.
    set /a INSTALLED_COUNT+=1
    set "STATUS_%TID%=INSTALLED"
)
exit /b

REM ------------------------------------------------------------
REM REFRESH SCAN
REM ------------------------------------------------------------
:REFRESH_INTERNAL
call :SCAN_LOCAL_COMMANDS
call :SCAN_WINGET_CATALOG
exit /b

:REFRESH_MENU
cls
call :HEADER
echo  !C_WHITE!REFRESHING ENVIRONMENT SCAN...!C_RESET!
echo  ----------------------------------------------------------------------
echo  Checking commands...
call :SCAN_LOCAL_COMMANDS
echo  Updating catalog cache...
call :SCAN_WINGET_CATALOG
echo.
echo  !C_GREEN!Scan refreshed successfully.!C_RESET!
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM DIAGNOSTICS
REM ------------------------------------------------------------
:DIAGNOSTICS_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!DEVELOPER ENVIRONMENT DIAGNOSTICS!C_RESET!
echo  ----------------------------------------------------------------------
call :CHECK_CMD_DIAG "git" "Git CLI"
call :CHECK_CMD_DIAG "gh" "GitHub CLI"
call :CHECK_CMD_DIAG "code" "Visual Studio Code"
call :CHECK_CMD_DIAG "python" "Python"
call :CHECK_CMD_DIAG "node" "Node.js"
call :CHECK_CMD_DIAG "npm" "npm Package Manager"
call :CHECK_CMD_DIAG "cmake" "CMake"
call :CHECK_CMD_DIAG "pwsh" "PowerShell 7"
call :CHECK_CMD_DIAG "7z" "7-Zip"
call :CHECK_CMD_DIAG "docker" "Docker CLI"
call :CHECK_CMD_DIAG "java" "Java Runtime"
call :CHECK_CMD_DIAG "go" "Go Toolchain"
call :CHECK_CMD_DIAG "rustc" "Rust Compiler"
call :CHECK_CMD_DIAG "cl" "MSVC Compiler (cl.exe)"
echo.
echo  !C_WHITE!Active PATH Entries:!C_RESET!
echo  !C_GRAY!%PATH%!C_RESET!
echo.
pause
goto :MAIN_MENU

:CHECK_CMD_DIAG
where %~1 >nul 2>&1
if errorlevel 1 (
    echo   !C_RED![MISSING]!C_RESET! %~2
) else (
    echo   !C_GREEN![OK]!C_RESET!      %~2
)
exit /b

REM ------------------------------------------------------------
REM SYSTEM INFORMATION
REM ------------------------------------------------------------
:SYSTEM_INFO_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!SYSTEM INFORMATION!C_RESET!
echo  ----------------------------------------------------------------------
echo  Operating System:
cmd /c ver
echo.
echo  Computer Name: %COMPUTERNAME%
echo  Architecture:  %PROCESSOR_ARCHITECTURE%
echo.
echo  Processor:
powershell -NoProfile -Command "(Get-CimInstance Win32_Processor | Select-Object -First 1 -ExpandProperty Name)" 2>nul
echo.
echo  Memory (RAM):
powershell -NoProfile -Command "$m=(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB; '{0:N1} GB Installed' -f $m" 2>nul
echo.
echo  WinGet Status:
if "!WINGET_OK!"=="1" (
    winget --version 2>nul
) else (
    echo WinGet is not installed or not in PATH.
)
echo.
echo  Administrator Access:
if "!ADMIN_OK!"=="1" (
    echo Yes [Elevated session]
) else (
    echo No [Standard user session]
)
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM GOOGLE ANTIGRAVITY SECTION
REM ------------------------------------------------------------
:ANTIGRAVITY_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!GOOGLE ANTIGRAVITY!C_RESET!
echo  ----------------------------------------------------------------------
echo  Google Antigravity is Google's advanced agentic coding platform.
echo  DEV provides safe navigation to verified official documentation.
echo.
echo    !C_CYAN![1]!C_RESET! Official Download Page
echo    !C_CYAN![2]!C_RESET! Getting Started and CLI Documentation
echo    !C_RED![0]!C_RESET! Back to Main Menu
echo.
set "AG_OPT="
set /p "AG_OPT=Select option [0-2]: "
if "!AG_OPT!"=="1" (
    start "" "https://antigravity.google/download"
    goto :MAIN_MENU
)
if "!AG_OPT!"=="2" (
    start "" "https://antigravity.google/docs/getting-started"
    goto :MAIN_MENU
)
if "!AG_OPT!"=="0" goto :MAIN_MENU
goto :ANTIGRAVITY_MENU

REM ------------------------------------------------------------
REM GENERATE REPORT
REM ------------------------------------------------------------
:REPORT_MENU
cls
call :HEADER
call :COUNT_TOTALS
echo  Generating developer environment report...

> "%REPORT_FILE%" echo ============================================================
>>"%REPORT_FILE%" echo DEV TOOLS SUITE :: DEV SETUP CENTER REPORT
>>"%REPORT_FILE%" echo Provider: %APP_PROVIDER%
>>"%REPORT_FILE%" echo Suite Version: %APP_VERSION%
>>"%REPORT_FILE%" echo Generated: %date% %time%
>>"%REPORT_FILE%" echo Machine: %COMPUTERNAME% (%PROCESSOR_ARCHITECTURE%)
>>"%REPORT_FILE%" echo ============================================================
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo SYSTEM STATUS:
>>"%REPORT_FILE%" echo - WinGet Available: !WINGET_OK!
>>"%REPORT_FILE%" echo - Administrator:    !ADMIN_OK!
>>"%REPORT_FILE%" echo - Total Tools:      %TOTAL_APPS%
>>"%REPORT_FILE%" echo - Installed:        !TOTAL_INSTALLED!
>>"%REPORT_FILE%" echo - Missing:          !TOTAL_MISSING!
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo APPLICATION INVENTORY:
for /L %%A in (1,1,%TOTAL_APPS%) do (
    >>"%REPORT_FILE%" echo [%%A] !NAME_%%A! (!PKG_%%A!) : !STATUS_%%A!
)
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo RECENT SESSION ACTIVITY:
>>"%REPORT_FILE%" echo - Newly Installed:  !INSTALLED_COUNT!
>>"%REPORT_FILE%" echo - Skipped Existing: !SKIPPED_COUNT!
>>"%REPORT_FILE%" echo - Failed Attempts:  !FAILED_COUNT!
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo ============================================================

echo.
echo  !C_GREEN![OK]!C_RESET! Report saved successfully to:
echo  !C_CYAN!%REPORT_FILE%!C_RESET!
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM ABOUT DEV
REM ------------------------------------------------------------
:ABOUT_MENU
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!ABOUT DEV SETUP CENTER!C_RESET!
echo  ----------------------------------------------------------------------
echo  Product   : DEV Tools Suite
echo  Tool      : DEV Setup Center
echo  Provider  : AnoS
echo  Version   : %APP_VERSION%
echo  Platform  : Windows 10 / 11 (x64, ARM64)
echo.
echo  KEY FEATURES
echo  * High-performance pre-install environment scan
echo  * Standard Developer Pack for instant onboarding
echo  * 9 specialized Developer Packs and custom catalog
echo  * Clean 2-column Installed / Missing visual dashboard
echo  * Automated skipping of pre-existing software
echo  * Comprehensive diagnostics and local report generation
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM OPERATION SUMMARY
REM ------------------------------------------------------------
:SHOW_SUMMARY
echo.
echo  ----------------------------------------------------------------------
echo  !C_WHITE!!C_BOLD!OPERATION COMPLETE!C_RESET!
echo  ----------------------------------------------------------------------
echo    Installed successfully : !C_GREEN!!INSTALLED_COUNT!!C_RESET!
echo    Already installed      : !C_YELLOW!!SKIPPED_COUNT!!C_RESET!
echo    Failed / Errors        : !C_RED!!FAILED_COUNT!!C_RESET!
echo  ----------------------------------------------------------------------
echo.
exit /b

REM ------------------------------------------------------------
REM EXIT
REM ------------------------------------------------------------
:EXIT
cls
call :HEADER
del /q "%CATALOG_CACHE%" >nul 2>&1
echo  !C_GREEN!Thank you for using DEV.!C_RESET!
echo  !C_GRAY!Provider: AnoS ^| Developer Tools Suite!C_RESET!
echo.
endlocal
exit /b 0
