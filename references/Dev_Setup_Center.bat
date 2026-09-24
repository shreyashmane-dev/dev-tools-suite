@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV - DEVELOPER SETUP CENTER
REM Single-file Windows developer environment assistant
REM Provider: AnoS
REM Version: 7.0
REM ============================================================

REM --- Safe launcher: keeps the window open so errors stay visible.
if /I not "%~1"=="__DEV_MAIN" (
    start "Dev - Developer Setup Center" "%ComSpec%" /d /k call "%~f0" __DEV_MAIN
    exit /b
)

title DEV - DEVELOPER SETUP CENTER
color 0B
mode con cols=118 lines=60 >nul 2>&1

REM --- ANSI colours (modern Windows Terminal / cmd)
for /F "delims=" %%E in ('echo prompt $E^| cmd') do set "ESC=%%E"
set "C_RESET=!ESC![0m"
set "C_CYAN=!ESC![96m"
set "C_BLUE=!ESC![94m"
set "C_GREEN=!ESC![92m"
set "C_YELLOW=!ESC![93m"
set "C_RED=!ESC![91m"
set "C_MAGENTA=!ESC![95m"
set "C_WHITE=!ESC![97m"

set "APP_VERSION=7.0"
set "APP_PROVIDER=AnoS"
set "TOTAL_APPS=46"
set "REPORT=%~dp0Dev-Environment-Report.txt"
set "CATALOG_FILE=%TEMP%\DevSetupCenter-Catalog.txt"
set "WINGET_OK=0"
set "ADMIN_OK=0"
set /a INSTALLED_COUNT=0
set /a FAILED_COUNT=0
set /a SKIPPED_COUNT=0

call :FIRST_RUN
goto :BOOT

:BOOT
call :INIT_STATUS

cls
call :HEADER
echo.
echo SYSTEM CHECK
echo -------------------------------------------------------------------------------
echo [1/4] Checking Windows Package Manager...
call :CHECK_WINGET
if "!WINGET_OK!"=="1" (
    echo       [OK] WinGet is available
) else (
    echo       [INFO] WinGet was not detected
)

echo.
echo [2/4] Checking administrator access...
call :CHECK_ADMIN
if "!ADMIN_OK!"=="1" (
    echo       [OK] Administrator access available
) else (
    echo       [INFO] Running without administrator access
)

echo.
echo [3/4] Checking core developer commands...
call :SCAN_CORE
echo       [OK] Core command scan completed

echo.
echo [4/4] Scanning application catalog...
call :SCAN_CATALOG
if "!CATALOG_OK!"=="1" (
    echo       [OK] Application catalog scan completed
) else (
    echo       [INFO] Catalog scan unavailable - command detection still active
)

echo.
echo -------------------------------------------------------------------------------
echo DEV is ready. Opening the main menu...
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

:FIRST_RUN
set "FIRST_DIR=%APPDATA%\DevSetupCenter"
set "FIRST_MARK=%FIRST_DIR%\first-run.dat"
if exist "%FIRST_MARK%" exit /b

cls
call :HEADER
echo.
echo WELCOME TO DEV
echo Windows Developer Environment Setup Center
echo.
echo   SMART SCAN     Detect installed tools before making changes
echo   STANDARD       Install the essential developer stack
echo   CUSTOM         Choose individual tools by category
echo   PACKS          Install focused development stacks
echo   VERIFY         Diagnose developer commands and PATH
echo.
echo Catalog: %TOTAL_APPS% applications
echo Provider: %APP_PROVIDER%   Version: %APP_VERSION%
echo.
echo No software is installed during this welcome screen.
echo.
timeout /t 2 /nobreak >nul 2>&1
if not exist "%FIRST_DIR%" md "%FIRST_DIR%" >nul 2>&1
> "%FIRST_MARK%" echo First run %date% %time%
exit /b

:HEADER
cls
echo.
echo !C_CYAN!      DDDDDD    EEEEEEEE  V      V!C_RESET!
echo !C_BLUE!      DD   DD   EE         V    V !C_RESET!
echo !C_MAGENTA!     DD    DD  EEEEE       V  V  !C_RESET!
echo !C_CYAN!     DD    DD  EE           VV   !C_RESET!
echo !C_BLUE!     DD   DD   EE            VV   !C_RESET!
echo !C_MAGENTA!    DDDDDD    EEEEEEEE      VV   !C_RESET!
echo.
echo !C_CYAN!                  DEVELOPER SETUP CENTER!C_RESET!
echo !C_WHITE!                  Smart Windows Developer Environment!C_RESET!
echo !C_YELLOW! Provider: !APP_PROVIDER!    !C_MAGENTA!Version: !APP_VERSION!    !C_GREEN!Status: READY!C_RESET!
echo.
exit /b

:MAIN_MENU
cls
call :HEADER
call :COUNT_STATUS

echo !C_WHITE!PC STATUS!C_RESET!
echo !C_GREEN!Installed: !INSTALLED_TOTAL! !C_WHITE! / !C_RED!Missing: !MISSING_TOTAL! !C_WHITE! / !C_YELLOW!Catalog: %TOTAL_APPS%!C_RESET!
if "!WINGET_OK!"=="1" (
    echo !C_GREEN!WinGet: AVAILABLE!C_RESET!
) else (
    echo !C_RED!WinGet: NOT AVAILABLE!C_RESET!
)
echo.
call :TWO_COLUMN_STATUS "1 2 3 4 5 6 7 8 9 13 10"
echo.
echo !C_WHITE!MAIN MENU!C_RESET!
echo   !C_CYAN![1]!C_RESET! Standard Developer Pack       !C_CYAN![6]!C_RESET! System Information
echo   !C_CYAN![2]!C_RESET! Custom Installation             !C_CYAN![7]!C_RESET! Google Antigravity
echo   !C_CYAN![3]!C_RESET! Developer Packs                 !C_CYAN![8]!C_RESET! Generate Report
echo   !C_CYAN![4]!C_RESET! Refresh Scan                    !C_CYAN![9]!C_RESET! About Dev
echo   !C_CYAN![5]!C_RESET! Verify / Diagnose               !C_RED![0]!C_RESET! Exit
echo.
choice /c 1234567890 /n /m "Select: "
if errorlevel 10 goto :QUIT
if errorlevel 9 goto :ABOUT
if errorlevel 8 goto :WRITE_REPORT_MENU
if errorlevel 7 goto :ANTIGRAVITY
if errorlevel 6 goto :SYSTEM_INFO
if errorlevel 5 goto :DIAGNOSE
if errorlevel 4 goto :REFRESH_SCAN
if errorlevel 3 goto :PACKS
if errorlevel 2 goto :CUSTOM
if errorlevel 1 goto :STANDARD
goto :MAIN_MENU

:TWO_COLUMN_STATUS
set "STATUS_IDS=%~1"
for /L %%A in (1,1,50) do (
    set "LEFT_%%A="
    set "RIGHT_%%A="
)
set /a LEFT_COUNT=0
set /a RIGHT_COUNT=0
for %%N in (!STATUS_IDS!) do (
    call :GET_APP_NAME %%N
    call :GET_STATUS %%N
    if /I "!APP_STATUS!"=="INSTALLED" (
        set /a LEFT_COUNT+=1
        set "LEFT_!LEFT_COUNT!=!APP_LABEL!"
    ) else (
        set /a RIGHT_COUNT+=1
        set "RIGHT_!RIGHT_COUNT!=!APP_LABEL!"
    )
)
echo !C_GREEN!INSTALLED!C_RESET!                                         !C_RED!MISSING!C_RESET!
echo.
set /a STATUS_ROWS=LEFT_COUNT
if !RIGHT_COUNT! GTR !STATUS_ROWS! set /a STATUS_ROWS=RIGHT_COUNT
if !STATUS_ROWS! EQU 0 (
    echo   No items in this view.
    exit /b
)
for /L %%R in (1,1,!STATUS_ROWS!) do (
    set "L=!LEFT_%%R!"
    set "R=!RIGHT_%%R!"
    if not defined L set "L=-"
    if not defined R set "R=-"
    set "L=!L!                                                        "
    set "R=!R!                                                        "
    echo   !C_GREEN!!L:~0,40!!C_RESET!    !C_RED!!R:~0,40!!C_RESET!
)
exit /b

:SHOW_CORE_SUMMARY
call :CORE_STATUS_TEXT "!S_GIT!" "Git"
call :CORE_STATUS_TEXT "!S_GH!" "GitHub CLI"
call :CORE_STATUS_TEXT "!S_VSCODE!" "VS Code"
call :CORE_STATUS_TEXT "!S_PYTHON!" "Python"
call :CORE_STATUS_TEXT "!S_NODE!" "Node.js"
call :CORE_STATUS_TEXT "!S_CMAKE!" "CMake"
call :CORE_STATUS_TEXT "!S_PWSH!" "PowerShell 7"
call :CORE_STATUS_TEXT "!S_7ZIP!" "7-Zip"
call :CORE_STATUS_TEXT "!S_DOCKER!" "Docker"
call :CORE_STATUS_TEXT "!S_JAVA!" "OpenJDK 21"
call :CORE_STATUS_TEXT "!S_CPP!" "C/C++ Build Tools"
exit /b

:CORE_STATUS_TEXT
if /I "%~1"=="INSTALLED" (
    echo       %~2 : [INSTALLED]
) else (
    echo       %~2 : [MISSING]
)
exit /b

:STANDARD
cls
call :HEADER
echo.
echo !C_WHITE!STANDARD DEVELOPER PACK!C_RESET!
echo Essentials for a fresh Windows developer machine.
echo.
call :TWO_COLUMN_STATUS "1 2 3 4 5 6 7 8 9 13 10"
echo.
echo !C_YELLOW!Green column = already installed.  Red column = missing.!C_RESET!
echo.
set "ANS="
set /p "ANS=Install all MISSING standard tools? [Y/N]: "
if /I not "!ANS!"=="Y" goto :MAIN_MENU

set /a INSTALLED_COUNT=0
set /a FAILED_COUNT=0
set /a SKIPPED_COUNT=0

call :INSTALL_BY_ID 1
call :INSTALL_BY_ID 2
call :INSTALL_BY_ID 3
call :INSTALL_BY_ID 4
call :INSTALL_BY_ID 5
call :INSTALL_BY_ID 6
call :INSTALL_BY_ID 7
call :INSTALL_BY_ID 8
call :INSTALL_BY_ID 9
call :INSTALL_BY_ID 13
call :INSTALL_BY_ID 10

call :REFRESH_AFTER_INSTALL
call :SUMMARY
pause
goto :MAIN_MENU

:CUSTOM
:CUSTOM_MENU
cls
call :HEADER
echo.
echo CUSTOM INSTALLATION
echo Select one category, then choose multiple tools with space-separated numbers.
echo.
echo   [1] Core and Editors
echo   [2] Web and JavaScript
echo   [3] Python and Data
echo   [4] C and C++ Systems
echo   [5] Java and JVM
echo   [6] Cloud and DevOps
echo   [7] Database and API
echo   [8] Creative and Media
echo   [9] Windows and Utilities
echo   [0] Back
echo.
choice /c 1234567890 /n /m "Category: "
if errorlevel 10 goto :MAIN_MENU
if errorlevel 9 goto :CUSTOM_WINDOWS
if errorlevel 8 goto :CUSTOM_CREATIVE
if errorlevel 7 goto :CUSTOM_DATABASE
if errorlevel 6 goto :CUSTOM_CLOUD
if errorlevel 5 goto :CUSTOM_JAVA
if errorlevel 4 goto :CUSTOM_CPP
if errorlevel 3 goto :CUSTOM_PYTHON
if errorlevel 2 goto :CUSTOM_WEB
if errorlevel 1 goto :CUSTOM_CORE
goto :CUSTOM_MENU

:CUSTOM_CORE
call :CATEGORY_SCREEN "CORE AND EDITORS" "1 2 3 7 8 6 16 42"
goto :CUSTOM_MENU

:CUSTOM_WEB
call :CATEGORY_SCREEN "WEB AND JAVASCRIPT" "5 15 14 32 1 2 3 42"
goto :CUSTOM_MENU

:CUSTOM_PYTHON
call :CATEGORY_SCREEN "PYTHON AND DATA" "4 18 27 28 30 31 3 1"
goto :CUSTOM_MENU

:CUSTOM_CPP
call :CATEGORY_SCREEN "C AND C++ SYSTEMS" "13 6 12 11 7 44 39 40"
goto :CUSTOM_MENU

:CUSTOM_JAVA
call :CATEGORY_SCREEN "JAVA AND JVM" "10 17 16 3 1 2 8"
goto :CUSTOM_MENU

:CUSTOM_CLOUD
call :CATEGORY_SCREEN "CLOUD AND DEVOPS" "9 19 20 21 22 23 24 25 26"
goto :CUSTOM_MENU

:CUSTOM_DATABASE
call :CATEGORY_SCREEN "DATABASE AND API" "27 28 29 30 31 46 14 32"
goto :CUSTOM_MENU

:CUSTOM_CREATIVE
call :CATEGORY_SCREEN "CREATIVE AND MEDIA" "45 36 37 38 33 34 35"
goto :CUSTOM_MENU

:CUSTOM_WINDOWS
call :CATEGORY_SCREEN "WINDOWS AND UTILITIES" "39 40 41 43 44 42 8 7"
goto :CUSTOM_MENU

:CATEGORY_SCREEN
set "CAT_TITLE=%~1"
set "CAT_IDS=%~2"
cls
call :HEADER
echo.
echo CUSTOM / !CAT_TITLE!
call :TWO_COLUMN_STATUS "!CAT_IDS!"
echo Enter numbers separated by spaces. A = all. Q = back.
echo.
set "SEL="
set /p "SEL=Select: "
if /I "!SEL!"=="Q" exit /b
if /I "!SEL!"=="A" set "SEL=!CAT_IDS!"
if not defined SEL exit /b

for %%N in (!SEL!) do call :INSTALL_BY_ID %%N
call :REFRESH_AFTER_INSTALL
call :SUMMARY
pause
exit /b

:PACKS
:PACK_MENU
cls
call :HEADER
echo.
echo DEVELOPER PACKS
echo.
echo   [1] Web and JavaScript
echo   [2] Python and Data
echo   [3] C and C++ Systems
echo   [4] Java and JVM
echo   [5] Cloud and DevOps
echo   [6] Database and API
echo   [7] Creative and Media
echo   [8] Windows Power User
echo   [9] Full Developer Pack
echo   [0] Back
echo.
choice /c 1234567890 /n /m "Select pack: "
if errorlevel 10 goto :MAIN_MENU
if errorlevel 9 goto :PACK_FULL
if errorlevel 8 goto :PACK_WINDOWS
if errorlevel 7 goto :PACK_CREATIVE
if errorlevel 6 goto :PACK_DATABASE
if errorlevel 5 goto :PACK_CLOUD
if errorlevel 4 goto :PACK_JAVA
if errorlevel 3 goto :PACK_CPP
if errorlevel 2 goto :PACK_PYTHON
if errorlevel 1 goto :PACK_WEB
goto :PACK_MENU

:PACK_WEB
call :PACK_INSTALL_SCREEN "WEB AND JAVASCRIPT PACK" "1 2 3 5 14 15 32 42"
goto :PACK_MENU

:PACK_PYTHON
call :PACK_INSTALL_SCREEN "PYTHON AND DATA PACK" "1 3 4 18 27 28 30 31"
goto :PACK_MENU

:PACK_CPP
call :PACK_INSTALL_SCREEN "C AND C++ SYSTEMS PACK" "1 2 3 6 7 8 11 12 13 39 40 44"
goto :PACK_MENU

:PACK_JAVA
call :PACK_INSTALL_SCREEN "JAVA AND JVM PACK" "1 2 3 10 16 17"
goto :PACK_MENU

:PACK_CLOUD
call :PACK_INSTALL_SCREEN "CLOUD AND DEVOPS PACK" "1 2 3 5 9 19 20 21 22 23 24 25 26"
goto :PACK_MENU

:PACK_DATABASE
call :PACK_INSTALL_SCREEN "DATABASE AND API PACK" "14 27 28 29 30 31 32 46"
goto :PACK_MENU

:PACK_CREATIVE
call :PACK_INSTALL_SCREEN "CREATIVE AND MEDIA PACK" "33 34 35 36 37 38 45"
goto :PACK_MENU

:PACK_WINDOWS
call :PACK_INSTALL_SCREEN "WINDOWS POWER USER PACK" "7 8 39 40 41 42 43 44"
goto :PACK_MENU

:PACK_FULL
call :PACK_INSTALL_SCREEN "FULL DEVELOPER PACK" "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46"
goto :PACK_MENU

:PACK_INSTALL_SCREEN
set "PACK_TITLE=%~1"
set "PACK_IDS=%~2"
cls
call :HEADER
echo.
echo !PACK_TITLE!
echo Review Installed / Missing before installing.
call :TWO_COLUMN_STATUS "!PACK_IDS!"
echo.
set "ANS="
set /p "ANS=Install all MISSING items in this pack? [Y/N]: "
if /I not "!ANS!"=="Y" exit /b
set /a INSTALLED_COUNT=0
set /a FAILED_COUNT=0
set /a SKIPPED_COUNT=0
for %%N in (!PACK_IDS!) do call :INSTALL_BY_ID %%N
call :REFRESH_AFTER_INSTALL
call :SUMMARY
pause
exit /b

:PREVIEW_ID
set "PN=%~1"
call :GET_APP_NAME %PN%
call :GET_STATUS %PN%
if /I "!APP_STATUS!"=="INSTALLED" (
    echo   %PN%. !APP_LABEL! [INSTALLED]
) else (
    echo   %PN%. !APP_LABEL! [MISSING]
)
exit /b

:STATUS_LINE
if /I "%~2"=="INSTALLED" (
    echo   %~1 [INSTALLED]
) else (
    echo   %~1 [MISSING]
)
exit /b

:GET_STATUS
set "APP_STATUS=MISSING"
for /L %%A in (1,1,46) do (
    if "%~1"=="%%A" set "APP_STATUS=!S_%%A!"
)
exit /b

:GET_APP_NAME
set "APP_LABEL=Unknown"
if "%~1"=="1" set "APP_LABEL=Git"
if "%~1"=="2" set "APP_LABEL=GitHub CLI"
if "%~1"=="3" set "APP_LABEL=Visual Studio Code"
if "%~1"=="4" set "APP_LABEL=Python 3.14"
if "%~1"=="5" set "APP_LABEL=Node.js LTS + npm"
if "%~1"=="6" set "APP_LABEL=CMake"
if "%~1"=="7" set "APP_LABEL=PowerShell 7"
if "%~1"=="8" set "APP_LABEL=7-Zip"
if "%~1"=="9" set "APP_LABEL=Docker Desktop"
if "%~1"=="10" set "APP_LABEL=OpenJDK 21"
if "%~1"=="11" set "APP_LABEL=Go"
if "%~1"=="12" set "APP_LABEL=Rustup"
if "%~1"=="13" set "APP_LABEL=C/C++ Build Tools"
if "%~1"=="14" set "APP_LABEL=Postman"
if "%~1"=="15" set "APP_LABEL=Deno"
if "%~1"=="16" set "APP_LABEL=JetBrains Toolbox"
if "%~1"=="17" set "APP_LABEL=IntelliJ IDEA Community"
if "%~1"=="18" set "APP_LABEL=PyCharm Community"
if "%~1"=="19" set "APP_LABEL=Azure CLI"
if "%~1"=="20" set "APP_LABEL=AWS CLI"
if "%~1"=="21" set "APP_LABEL=Google Cloud SDK"
if "%~1"=="22" set "APP_LABEL=Terraform"
if "%~1"=="23" set "APP_LABEL=Vagrant"
if "%~1"=="24" set "APP_LABEL=kubectl"
if "%~1"=="25" set "APP_LABEL=Helm"
if "%~1"=="26" set "APP_LABEL=Podman"
if "%~1"=="27" set "APP_LABEL=DBeaver"
if "%~1"=="28" set "APP_LABEL=PostgreSQL"
if "%~1"=="29" set "APP_LABEL=pgAdmin 4"
if "%~1"=="30" set "APP_LABEL=MongoDB Server"
if "%~1"=="31" set "APP_LABEL=MongoDB CLI"
if "%~1"=="32" set "APP_LABEL=Insomnia"
if "%~1"=="33" set "APP_LABEL=OBS Studio"
if "%~1"=="34" set "APP_LABEL=VLC"
if "%~1"=="35" set "APP_LABEL=ShareX"
if "%~1"=="36" set "APP_LABEL=GIMP"
if "%~1"=="37" set "APP_LABEL=Inkscape"
if "%~1"=="38" set "APP_LABEL=Krita"
if "%~1"=="39" set "APP_LABEL=Everything"
if "%~1"=="40" set "APP_LABEL=Sysinternals Autoruns"
if "%~1"=="41" set "APP_LABEL=Notepad Next"
if "%~1"=="42" set "APP_LABEL=GitHub Desktop"
if "%~1"=="43" set "APP_LABEL=Microsoft PowerToys"
if "%~1"=="44" set "APP_LABEL=Windows Terminal"
if "%~1"=="45" set "APP_LABEL=Blender"
if "%~1"=="46" set "APP_LABEL=MongoDB Database Tools"
exit /b

:INSTALL_BY_ID
set "N=%~1"
if "%N%"=="1"  call :INSTALL_ONE 1  "Git"                    "Git.Git"
if "%N%"=="2"  call :INSTALL_ONE 2  "GitHub CLI"             "GitHub.cli"
if "%N%"=="3"  call :INSTALL_ONE 3  "Visual Studio Code"     "Microsoft.VisualStudioCode"
if "%N%"=="4"  call :INSTALL_ONE 4  "Python 3.14"            "Python.Python.3.14"
if "%N%"=="5"  call :INSTALL_ONE 5  "Node.js LTS + npm"      "OpenJS.NodeJS.LTS"
if "%N%"=="6"  call :INSTALL_ONE 6  "CMake"                  "Kitware.CMake"
if "%N%"=="7"  call :INSTALL_ONE 7  "PowerShell 7"           "Microsoft.PowerShell"
if "%N%"=="8"  call :INSTALL_ONE 8  "7-Zip"                  "7zip.7zip"
if "%N%"=="9"  call :INSTALL_ONE 9  "Docker Desktop"         "Docker.DockerDesktop"
if "%N%"=="10" call :INSTALL_ONE 10 "OpenJDK 21"             "Microsoft.OpenJDK.21"
if "%N%"=="11" call :INSTALL_ONE 11 "Go"                     "GoLang.Go"
if "%N%"=="12" call :INSTALL_ONE 12 "Rustup"                 "Rustlang.Rustup"
if "%N%"=="13" call :INSTALL_CPP
if "%N%"=="14" call :INSTALL_ONE 14 "Postman"                "Postman.Postman"
if "%N%"=="15" call :INSTALL_ONE 15 "Deno"                   "DenoLand.Deno"
if "%N%"=="16" call :INSTALL_ONE 16 "JetBrains Toolbox"       "JetBrains.Toolbox"
if "%N%"=="17" call :INSTALL_ONE 17 "IntelliJ IDEA Community" "JetBrains.IntelliJIDEA.Community"
if "%N%"=="18" call :INSTALL_ONE 18 "PyCharm Community"       "JetBrains.PyCharm.Community"
if "%N%"=="19" call :INSTALL_ONE 19 "Azure CLI"              "Microsoft.AzureCLI"
if "%N%"=="20" call :INSTALL_ONE 20 "AWS CLI"                 "Amazon.AWSCLI"
if "%N%"=="21" call :INSTALL_ONE 21 "Google Cloud SDK"        "Google.CloudSDK"
if "%N%"=="22" call :INSTALL_ONE 22 "Terraform"               "HashiCorp.Terraform"
if "%N%"=="23" call :INSTALL_ONE 23 "Vagrant"                 "Hashicorp.Vagrant"
if "%N%"=="24" call :INSTALL_ONE 24 "kubectl"                 "Kubernetes.kubectl"
if "%N%"=="25" call :INSTALL_ONE 25 "Helm"                    "Helm.Helm"
if "%N%"=="26" call :INSTALL_ONE 26 "Podman"                  "RedHat.Podman"
if "%N%"=="27" call :INSTALL_ONE 27 "DBeaver"                 "dbeaver.dbeaver"
if "%N%"=="28" call :INSTALL_ONE 28 "PostgreSQL"              "PostgreSQL.PostgreSQL"
if "%N%"=="29" call :INSTALL_ONE 29 "pgAdmin 4"               "PostgreSQL.pgAdmin"
if "%N%"=="30" call :INSTALL_ONE 30 "MongoDB Server"          "MongoDB.Server"
if "%N%"=="31" call :INSTALL_ONE 31 "MongoDB CLI"             "MongoDB.MongoDBCLI"
if "%N%"=="32" call :INSTALL_ONE 32 "Insomnia"                "Insomnia.Insomnia"
if "%N%"=="33" call :INSTALL_ONE 33 "OBS Studio"              "OBSProject.OBSStudio"
if "%N%"=="34" call :INSTALL_ONE 34 "VLC"                     "VideoLAN.VLC"
if "%N%"=="35" call :INSTALL_ONE 35 "ShareX"                  "ShareX.ShareX"
if "%N%"=="36" call :INSTALL_ONE 36 "GIMP"                    "GIMP.GIMP"
if "%N%"=="37" call :INSTALL_ONE 37 "Inkscape"                "Inkscape.Inkscape"
if "%N%"=="38" call :INSTALL_ONE 38 "Krita"                   "KDE.Krita"
if "%N%"=="39" call :INSTALL_ONE 39 "Everything"              "voidtools.Everything"
if "%N%"=="40" call :INSTALL_ONE 40 "Sysinternals Autoruns"   "Microsoft.Sysinternals.Autoruns"
if "%N%"=="41" call :INSTALL_ONE 41 "Notepad Next"             "dail8859.NotepadNext"
if "%N%"=="42" call :INSTALL_ONE 42 "GitHub Desktop"           "GitHub.GitHubDesktop"
if "%N%"=="43" call :INSTALL_ONE 43 "Microsoft PowerToys"      "Microsoft.PowerToys"
if "%N%"=="44" call :INSTALL_ONE 44 "Windows Terminal"          "Microsoft.WindowsTerminal"
if "%N%"=="45" call :INSTALL_ONE 45 "Blender"                  "BlenderFoundation.Blender"
if "%N%"=="46" call :INSTALL_ONE 46 "MongoDB Database Tools"    "MongoDB.DatabaseTools"
exit /b

:INSTALL_ONE
set "INSTALL_ID=%~1"
set "INSTALL_LABEL=%~2"
set "INSTALL_PKG=%~3"
call :GET_STATUS !INSTALL_ID!
if /I "!APP_STATUS!"=="INSTALLED" (
    echo [SKIP] !INSTALL_LABEL! - already installed
    set /a SKIPPED_COUNT+=1
    exit /b
)
if "!WINGET_OK!"=="0" (
    echo [FAIL] WinGet unavailable - !INSTALL_LABEL!
    set /a FAILED_COUNT+=1
    exit /b
)

echo.
echo -------------------------------------------------------------------------------
echo [INSTALL] !INSTALL_LABEL!
echo WinGet ID: !INSTALL_PKG!
echo -------------------------------------------------------------------------------
winget install --id "!INSTALL_PKG!" -e --source winget --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
    echo [FAIL] !INSTALL_LABEL!
    set /a FAILED_COUNT+=1
) else (
    echo [OK] !INSTALL_LABEL!
    set /a INSTALLED_COUNT+=1
    set "S_!INSTALL_ID!=INSTALLED"
)
exit /b

:INSTALL_CPP
call :GET_STATUS 13
if /I "!APP_STATUS!"=="INSTALLED" (
    echo [SKIP] C/C++ Build Tools - already installed
    set /a SKIPPED_COUNT+=1
    exit /b
)
if "!WINGET_OK!"=="0" (
    echo [FAIL] WinGet unavailable - C/C++ Build Tools
    set /a FAILED_COUNT+=1
    exit /b
)

echo.
echo -------------------------------------------------------------------------------
echo [INSTALL] C/C++ Build Tools
echo Visual Studio Build Tools with the VC workload
echo -------------------------------------------------------------------------------
winget install --id Microsoft.VisualStudio.2022.BuildTools -e --source winget --accept-source-agreements --accept-package-agreements --override "--wait --passive --norestart --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
if errorlevel 1 (
    echo [FAIL] C/C++ Build Tools
    set /a FAILED_COUNT+=1
) else (
    echo [OK] C/C++ Build Tools
    set /a INSTALLED_COUNT+=1
    set "S_13=INSTALLED"
)
exit /b

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

:INIT_STATUS
for /L %%A in (1,1,46) do set "S_%%A=MISSING"
exit /b

:SCAN_CORE
set "S_GIT=MISSING"
set "S_GH=MISSING"
set "S_VSCODE=MISSING"
set "S_PYTHON=MISSING"
set "S_NODE=MISSING"
set "S_CMAKE=MISSING"
set "S_PWSH=MISSING"
set "S_7ZIP=MISSING"
set "S_DOCKER=MISSING"
set "S_JAVA=MISSING"
set "S_CPP=MISSING"

where git >nul 2>&1
if not errorlevel 1 set "S_GIT=INSTALLED"

where gh >nul 2>&1
if not errorlevel 1 set "S_GH=INSTALLED"

where code >nul 2>&1
if not errorlevel 1 set "S_VSCODE=INSTALLED"

where python >nul 2>&1
if not errorlevel 1 set "S_PYTHON=INSTALLED"
if /I "!S_PYTHON!"=="MISSING" (
    where py >nul 2>&1
    if not errorlevel 1 set "S_PYTHON=INSTALLED"
)

where node >nul 2>&1
if not errorlevel 1 (
    where npm >nul 2>&1
    if not errorlevel 1 set "S_NODE=INSTALLED"
)

where cmake >nul 2>&1
if not errorlevel 1 set "S_CMAKE=INSTALLED"

where pwsh >nul 2>&1
if not errorlevel 1 set "S_PWSH=INSTALLED"

where 7z >nul 2>&1
if not errorlevel 1 set "S_7ZIP=INSTALLED"

where docker >nul 2>&1
if not errorlevel 1 set "S_DOCKER=INSTALLED"

where java >nul 2>&1
if not errorlevel 1 set "S_JAVA=INSTALLED"

if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
    set "CPP_FOUND="
    for /f "delims=" %%V in ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2^>nul') do set "CPP_FOUND=%%V"
    if defined CPP_FOUND set "S_CPP=INSTALLED"
)
where cl >nul 2>&1
if not errorlevel 1 set "S_CPP=INSTALLED"

set "S_1=!S_GIT!"
set "S_2=!S_GH!"
set "S_3=!S_VSCODE!"
set "S_4=!S_PYTHON!"
set "S_5=!S_NODE!"
set "S_6=!S_CMAKE!"
set "S_7=!S_PWSH!"
set "S_8=!S_7ZIP!"
set "S_9=!S_DOCKER!"
set "S_10=!S_JAVA!"
set "S_13=!S_CPP!"
exit /b

:SCAN_CATALOG
set "CATALOG_OK=0"
if "!WINGET_OK!"=="0" exit /b

del /q "%CATALOG_FILE%" >nul 2>&1
winget list --source winget --accept-source-agreements >"%CATALOG_FILE%" 2>nul
if errorlevel 1 (
    winget list >"%CATALOG_FILE%" 2>nul
)
if not exist "%CATALOG_FILE%" exit /b

for %%A in (
    "1 Git.Git"
    "2 GitHub.cli"
    "3 Microsoft.VisualStudioCode"
    "4 Python.Python.3.14"
    "5 OpenJS.NodeJS.LTS"
    "6 Kitware.CMake"
    "7 Microsoft.PowerShell"
    "8 7zip.7zip"
    "9 Docker.DockerDesktop"
    "10 Microsoft.OpenJDK.21"
    "11 GoLang.Go"
    "12 Rustlang.Rustup"
    "13 Microsoft.VisualStudio.2022.BuildTools"
    "14 Postman.Postman"
    "15 DenoLand.Deno"
    "16 JetBrains.Toolbox"
    "17 JetBrains.IntelliJIDEA.Community"
    "18 JetBrains.PyCharm.Community"
    "19 Microsoft.AzureCLI"
    "20 Amazon.AWSCLI"
    "21 Google.CloudSDK"
    "22 HashiCorp.Terraform"
    "23 Hashicorp.Vagrant"
    "24 Kubernetes.kubectl"
    "25 Helm.Helm"
    "26 RedHat.Podman"
    "27 dbeaver.dbeaver"
    "28 PostgreSQL.PostgreSQL"
    "29 PostgreSQL.pgAdmin"
    "30 MongoDB.Server"
    "31 MongoDB.MongoDBCLI"
    "32 Insomnia.Insomnia"
    "33 OBSProject.OBSStudio"
    "34 VideoLAN.VLC"
    "35 ShareX.ShareX"
    "36 GIMP.GIMP"
    "37 Inkscape.Inkscape"
    "38 KDE.Krita"
    "39 voidtools.Everything"
    "40 Microsoft.Sysinternals.Autoruns"
    "41 dail8859.NotepadNext"
    "42 GitHub.GitHubDesktop"
    "43 Microsoft.PowerToys"
    "44 Microsoft.WindowsTerminal"
    "45 BlenderFoundation.Blender"
    "46 MongoDB.DatabaseTools"
) do call :CATALOG_ENTRY %%A

set "CATALOG_OK=1"
exit /b

:CATALOG_ENTRY
set "CATALOG_ITEM=%~1"
for /f "tokens=1,2" %%B in ("!CATALOG_ITEM!") do (
    set "CID=%%B"
    set "CPKG=%%C"
)
findstr /I /C:"!CPKG!" "%CATALOG_FILE%" >nul 2>&1
if not errorlevel 1 set "S_!CID!=INSTALLED"
exit /b

:REFRESH_AFTER_INSTALL
call :SCAN_CORE
call :SCAN_CATALOG
exit /b

:REFRESH_SCAN
cls
call :HEADER
echo.
echo REFRESHING SCAN
echo -------------------------------------------------------------------------------
echo [1/2] Checking core commands...
call :SCAN_CORE
echo [OK] Core scan
echo.
echo [2/2] Checking application catalog...
call :SCAN_CATALOG
if "!CATALOG_OK!"=="1" (
    echo [OK] Catalog scan
) else (
    echo [INFO] Catalog scan unavailable
)
echo.
echo Scan refreshed.
pause
goto :MAIN_MENU

:COUNT_STATUS
set /a INSTALLED_TOTAL=0
set /a MISSING_TOTAL=0
for /L %%A in (1,1,46) do (
    if /I "!S_%%A!"=="INSTALLED" (
        set /a INSTALLED_TOTAL+=1
    ) else (
        set /a MISSING_TOTAL+=1
    )
)
exit /b

:DIAGNOSE
cls
call :HEADER
echo.
echo DEVELOPER DIAGNOSTIC
echo -------------------------------------------------------------------------------
call :CMD_STATUS "git" "Git"
call :CMD_STATUS "gh" "GitHub CLI"
call :CMD_STATUS "code" "VS Code"
call :CMD_STATUS "python" "Python"
call :CMD_STATUS "node" "Node.js"
call :CMD_STATUS "npm" "npm"
call :CMD_STATUS "cmake" "CMake"
call :CMD_STATUS "pwsh" "PowerShell 7"
call :CMD_STATUS "7z" "7-Zip"
call :CMD_STATUS "docker" "Docker"
call :CMD_STATUS "java" "Java"
call :CMD_STATUS "go" "Go"
call :CMD_STATUS "rustc" "Rust"
echo.
echo PATH used by this Dev session:
echo %PATH%
echo.
pause
goto :MAIN_MENU

:CMD_STATUS
where %~1 >nul 2>&1
if errorlevel 1 (
    echo   %~2 : [MISSING]
) else (
    echo   %~2 : [OK]
)
exit /b

:SYSTEM_INFO
cls
call :HEADER
echo.
echo SYSTEM INFORMATION
echo -------------------------------------------------------------------------------
echo Operating System:
ver
echo.
echo Architecture: %PROCESSOR_ARCHITECTURE%
echo Computer: %COMPUTERNAME%
echo.
echo CPU:
powershell -NoProfile -Command "(Get-CimInstance Win32_Processor ^| Select-Object -First 1 -ExpandProperty Name)"
echo.
echo RAM:
powershell -NoProfile -Command "$r=(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB; '{0:N1} GB' -f $r"
echo.
echo WinGet:
if "!WINGET_OK!"=="1" (
    winget --version
) else (
    echo Not available
)
echo.
echo Administrator:
if "!ADMIN_OK!"=="1" (
    echo Yes
) else (
    echo No
)
echo.
pause
goto :MAIN_MENU

:ANTIGRAVITY
cls
call :HEADER
echo.
echo GOOGLE ANTIGRAVITY
echo -------------------------------------------------------------------------------
echo Dev uses official Google pages and does not silently execute remote scripts.
echo.
echo   [1] Open official download page
echo   [2] Open official getting-started / CLI docs
echo   [3] Back
echo.
choice /c 123 /n /m "Select: "
if errorlevel 3 goto :MAIN_MENU
if errorlevel 2 (
    start "" "https://antigravity.google/docs/getting-started"
    goto :MAIN_MENU
)
if errorlevel 1 (
    start "" "https://antigravity.google/download"
    goto :MAIN_MENU
)
goto :MAIN_MENU

:WRITE_REPORT_MENU
call :WRITE_REPORT
echo.
echo Report generated:
echo %REPORT%
pause
goto :MAIN_MENU

:WRITE_REPORT
> "%REPORT%" echo ============================================================
>>"%REPORT%" echo DEV - DEVELOPER SETUP CENTER
>>"%REPORT%" echo Version: %APP_VERSION%
>>"%REPORT%" echo Provider: %APP_PROVIDER%
>>"%REPORT%" echo Date: %date% %time%
>>"%REPORT%" echo ============================================================
>>"%REPORT%" echo WinGet available: !WINGET_OK!
>>"%REPORT%" echo Administrator: !ADMIN_OK!
>>"%REPORT%" echo.
call :COUNT_STATUS
>>"%REPORT%" echo Catalog installed: !INSTALLED_TOTAL!
>>"%REPORT%" echo Catalog missing: !MISSING_TOTAL!
>>"%REPORT%" echo.
for /L %%A in (1,1,46) do (
    call :GET_APP_NAME %%A
    >>"%REPORT%" echo %%A. !APP_LABEL! - !S_%%A!
)
>>"%REPORT%" echo.
>>"%REPORT%" echo Successful install attempts: !INSTALLED_COUNT!
>>"%REPORT%" echo Already installed / skipped: !SKIPPED_COUNT!
>>"%REPORT%" echo Failed install attempts: !FAILED_COUNT!
>>"%REPORT%" echo ============================================================
exit /b

:ABOUT
cls
call :HEADER
echo.
echo ABOUT DEV
echo -------------------------------------------------------------------------------
echo Name       : Dev
echo Provider   : AnoS
echo Version    : %APP_VERSION%
echo Format     : Single-file BAT utility
echo.
echo FEATURES
echo   Smart pre-install scan
echo   Standard developer pack
echo   Category-based custom installation
echo   Developer packs
echo   Installed / Missing status
echo   Diagnostics and PATH checks
echo   System information
echo   Local environment report
echo   Official-source Google Antigravity launcher
echo   Already-installed tools are skipped automatically
echo.
pause
goto :MAIN_MENU

:SUMMARY
echo.
echo -------------------------------------------------------------------------------
echo OPERATION COMPLETE
echo -------------------------------------------------------------------------------
echo   Installed successfully : !INSTALLED_COUNT!
echo   Already installed      : !SKIPPED_COUNT!
echo   Failed                 : !FAILED_COUNT!
echo -------------------------------------------------------------------------------
exit /b

:QUIT
cls
call :HEADER
echo.
echo Dev closed.
echo.
echo Press any key to exit.
pause >nul
del /q "%CATALOG_FILE%" >nul 2>&1
endlocal
exit /b
