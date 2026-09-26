@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV DOCTOR
REM Developer Environment Health & Configuration Diagnostic
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV DOCTOR
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

set "APP_NAME=DEV Doctor"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"
set "REPORT_FILE=%~dp0Dev-Doctor-Report.txt"
set "EMPTY_COUNT=0"

REM --- Direct CLI Argument Routing
if not "%~1"=="" (
    set "ARG_OPT=%~1"
    if /I "!ARG_OPT!"=="1" goto :DIAG_FULL
    if /I "!ARG_OPT!"=="full" goto :DIAG_FULL
    if /I "!ARG_OPT!"=="all" goto :DIAG_FULL
    if /I "!ARG_OPT!"=="2" goto :DIAG_GIT
    if /I "!ARG_OPT!"=="git" goto :DIAG_GIT
    if /I "!ARG_OPT!"=="3" goto :DIAG_PYTHON
    if /I "!ARG_OPT!"=="python" goto :DIAG_PYTHON
    if /I "!ARG_OPT!"=="4" goto :DIAG_NODE
    if /I "!ARG_OPT!"=="node" goto :DIAG_NODE
    if /I "!ARG_OPT!"=="5" goto :DIAG_JAVA
    if /I "!ARG_OPT!"=="java" goto :DIAG_JAVA
    if /I "!ARG_OPT!"=="6" goto :DIAG_CPP
    if /I "!ARG_OPT!"=="cpp" goto :DIAG_CPP
    if /I "!ARG_OPT!"=="7" goto :DIAG_DOCKER
    if /I "!ARG_OPT!"=="docker" goto :DIAG_DOCKER
    if /I "!ARG_OPT!"=="8" goto :DIAG_WINGET
    if /I "!ARG_OPT!"=="winget" goto :DIAG_WINGET
    if /I "!ARG_OPT!"=="9" goto :DIAG_PATH
    if /I "!ARG_OPT!"=="path" goto :DIAG_PATH
    if /I "!ARG_OPT!"=="10" goto :DIAG_ENV
    if /I "!ARG_OPT!"=="env" goto :DIAG_ENV
    if /I "!ARG_OPT!"=="11" goto :DIAG_REPORT
    if /I "!ARG_OPT!"=="report" goto :DIAG_REPORT
    if /I "!ARG_OPT!"=="0" goto :EXIT
    if /I "!ARG_OPT!"=="exit" goto :EXIT
)

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

echo  !C_WHITE!DIAGNOSTIC DASHBOARD!C_RESET!
echo  Platform: Windows (%PROCESSOR_ARCHITECTURE%)
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET!  Full Diagnosis              !C_CYAN![7]!C_RESET!  Docker Check
echo    !C_CYAN![2]!C_RESET!  Git Check                   !C_CYAN![8]!C_RESET!  WinGet Check
echo    !C_CYAN![3]!C_RESET!  Python Check                !C_CYAN![9]!C_RESET!  PATH Health Check
echo    !C_CYAN![4]!C_RESET!  Node.js Check               !C_CYAN![10]!C_RESET! Environment Variables
echo    !C_CYAN![5]!C_RESET!  Java Check                  !C_CYAN![11]!C_RESET! Generate Diagnostic Report
echo    !C_CYAN![6]!C_RESET!  C / C++ Check               !C_RED![0]!C_RESET!  Exit
echo.

set "CHOICE="
set /p "CHOICE=Select an option [0-11]: "
if not defined CHOICE (
    set /a "EMPTY_COUNT+=1"
    if !EMPTY_COUNT! GEQ 3 goto :EXIT
    goto :MAIN_MENU
)
set "EMPTY_COUNT=0"
set "CHOICE=!CHOICE: =!"
if "!CHOICE!"=="1" goto :DIAG_FULL
if "!CHOICE!"=="2" goto :DIAG_GIT
if "!CHOICE!"=="3" goto :DIAG_PYTHON
if "!CHOICE!"=="4" goto :DIAG_NODE
if "!CHOICE!"=="5" goto :DIAG_JAVA
if "!CHOICE!"=="6" goto :DIAG_CPP
if "!CHOICE!"=="7" goto :DIAG_DOCKER
if "!CHOICE!"=="8" goto :DIAG_WINGET
if "!CHOICE!"=="9" goto :DIAG_PATH
if "!CHOICE!"=="10" goto :DIAG_ENV
if "!CHOICE!"=="11" goto :DIAG_REPORT
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 11.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] FULL DIAGNOSIS
REM ------------------------------------------------------------
:DIAG_FULL
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!STARTING FULL DEVELOPER ENVIRONMENT DIAGNOSIS...!C_RESET!
echo  ======================================================================
echo.

echo  !C_WHITE![SYSTEM ^& OS IDENTITY]!C_RESET!
cmd /c ver
echo  Architecture: %PROCESSOR_ARCHITECTURE%   Computer: %COMPUTERNAME%
net session >nul 2>&1
if not errorlevel 1 (
    echo  Privileges  : !C_GREEN![OK] Administrator session!C_RESET!
) else (
    echo  Privileges  : !C_CYAN![INFO] Standard user session!C_RESET!
)
echo.

echo  !C_WHITE![1/8] Git ^& Version Control!C_RESET!
call :SUB_GIT
echo.

echo  !C_WHITE![2/8] Python Ecosystem!C_RESET!
call :SUB_PYTHON
echo.

echo  !C_WHITE![3/8] Node.js ^& JavaScript!C_RESET!
call :SUB_NODE
echo.

echo  !C_WHITE![4/8] Java Runtime ^& JDK!C_RESET!
call :SUB_JAVA
echo.

echo  !C_WHITE![5/8] C / C++ Toolchains!C_RESET!
call :SUB_CPP
echo.

echo  !C_WHITE![6/8] Docker ^& Containers!C_RESET!
call :SUB_DOCKER
echo.

echo  !C_WHITE![7/8] Windows Package Manager!C_RESET!
call :SUB_WINGET
echo.

echo  !C_WHITE![8/8] Critical PATH Integrity!C_RESET!
call :SUB_PATH_BRIEF
echo.
echo  ======================================================================
echo  !C_GREEN!Full diagnosis completed.!C_RESET!
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [2] GIT CHECK
REM ------------------------------------------------------------
:DIAG_GIT
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!GIT ENVIRONMENT CHECK!C_RESET!
echo  ----------------------------------------------------------------------
call :SUB_GIT
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

:SUB_GIT
where git >nul 2>&1
if errorlevel 1 (
    echo    !C_CYAN![INFO]!C_RESET! Git CLI is not installed.
    exit /b
)
for /f "delims=" %%I in ('where git 2^>nul') do set "GIT_LOC=%%I"
echo    !C_GREEN![OK]!C_RESET!   Binary  : !GIT_LOC!
for /f "delims=" %%V in ('git --version 2^>nul') do echo    !C_GREEN![OK]!C_RESET!   Version : %%V

for /f "delims=" %%U in ('git config --global user.name 2^>nul') do set "GIT_U=%%U"
for /f "delims=" %%E in ('git config --global user.email 2^>nul') do set "GIT_E=%%E"
if defined GIT_U (
    echo    !C_GREEN![OK]!C_RESET!   Identity: !GIT_U! ^<!GIT_E!^>
) else (
    echo    !C_YELLOW![WARN]!C_RESET! Git user.name and user.email are not configured globally.
)
where gh >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%V in ('gh --version 2^>nul') do (
        echo    !C_GREEN![OK]!C_RESET!   GitHub  : %%V
        goto :END_SUB_GIT
    )
) else (
    echo    !C_CYAN![INFO]!C_RESET! GitHub CLI [gh] is optional and not currently installed.
)
:END_SUB_GIT
exit /b

REM ------------------------------------------------------------
REM [3] PYTHON CHECK
REM ------------------------------------------------------------
:DIAG_PYTHON
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!PYTHON ENVIRONMENT CHECK!C_RESET!
echo  ----------------------------------------------------------------------
call :SUB_PYTHON
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

:SUB_PYTHON
set "PY_FOUND=0"
where python >nul 2>&1
if errorlevel 1 goto :CHECK_PY_LAUNCHER
set "PY_FOUND=1"
for /f "delims=" %%I in ('where python 2^>nul') do set "PY_LOC=%%I"
echo    !C_GREEN![OK]!C_RESET!   Binary  : !PY_LOC!
for /f "delims=" %%V in ('python --version 2^>nul') do echo    !C_GREEN![OK]!C_RESET!   Version : %%V
goto :CHECK_PIP

:CHECK_PY_LAUNCHER
where py >nul 2>&1
if errorlevel 1 goto :NO_PYTHON
set "PY_FOUND=1"
for /f "delims=" %%V in ('py --version 2^>nul') do echo    !C_GREEN![OK]!C_RESET!   Python Launcher: %%V

:CHECK_PIP
where pip >nul 2>&1
if errorlevel 1 goto :NO_PIP
for /f "delims=" %%V in ('pip --version 2^>nul') do echo    !C_GREEN![OK]!C_RESET!   Pip     : %%V
goto :CHECK_PYPATH

:NO_PIP
echo    !C_YELLOW![WARN]!C_RESET! pip command not found in active PATH.
goto :CHECK_PYPATH

:NO_PYTHON
echo    !C_CYAN![INFO]!C_RESET! Python is not installed.
exit /b

:CHECK_PYPATH
if defined PYTHONPATH echo    !C_CYAN![INFO]!C_RESET! PYTHONPATH: %PYTHONPATH%
exit /b

REM ------------------------------------------------------------
REM [4] NODE.JS CHECK
REM ------------------------------------------------------------
:DIAG_NODE
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!NODE.JS ^& JAVASCRIPT CHECK!C_RESET!
echo  ----------------------------------------------------------------------
call :SUB_NODE
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

:SUB_NODE
where node >nul 2>&1
if errorlevel 1 (
    echo    !C_CYAN![INFO]!C_RESET! Node.js is not installed.
    exit /b
)
for /f "delims=" %%I in ('where node 2^>nul') do set "NODE_LOC=%%I"
echo    !C_GREEN![OK]!C_RESET!   Binary  : !NODE_LOC!
for /f "delims=" %%V in ('node --version 2^>nul') do echo    !C_GREEN![OK]!C_RESET!   Version : Node %%V

where npm >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%V in ('npm --version 2^>nul') do echo    !C_GREEN![OK]!C_RESET!   npm     : v%%V
) else (
    echo    !C_YELLOW![WARN]!C_RESET! npm package manager not found.
)
exit /b

REM ------------------------------------------------------------
REM [5] JAVA CHECK
REM ------------------------------------------------------------
:DIAG_JAVA
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!JAVA ENVIRONMENT CHECK!C_RESET!
echo  ----------------------------------------------------------------------
call :SUB_JAVA
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

:SUB_JAVA
where java >nul 2>&1
if errorlevel 1 (
    echo    !C_CYAN![INFO]!C_RESET! Java Runtime is not installed.
    exit /b
)
for /f "delims=" %%I in ('where java 2^>nul') do set "JAVA_LOC=%%I"
echo    !C_GREEN![OK]!C_RESET!   Binary  : !JAVA_LOC!
for /f "tokens=*" %%V in ('java -version 2^>^&1') do (
    echo    !C_GREEN![OK]!C_RESET!   %%V
    goto :CHECK_JAVA_HOME
)
:CHECK_JAVA_HOME
if defined JAVA_HOME (
    if exist "%JAVA_HOME%" (
        echo    !C_GREEN![OK]!C_RESET!   JAVA_HOME: %JAVA_HOME%
    ) else (
        echo    !C_YELLOW![WARN]!C_RESET! JAVA_HOME points to a non-existent folder: %JAVA_HOME%
    )
) else (
    echo    !C_CYAN![INFO]!C_RESET! JAVA_HOME is not explicitly set in environment variables.
)
where mvn >nul 2>&1
if not errorlevel 1 echo    !C_GREEN![OK]!C_RESET!   Build tool: Apache Maven available
where gradle >nul 2>&1
if not errorlevel 1 echo    !C_GREEN![OK]!C_RESET!   Build tool: Gradle available
exit /b

REM ------------------------------------------------------------
REM [6] C / C++ CHECK
REM ------------------------------------------------------------
:DIAG_CPP
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!C / C++ COMPILERS ^& BUILD TOOLS CHECK!C_RESET!
echo  ----------------------------------------------------------------------
call :SUB_CPP
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

:SUB_CPP
set "HAS_COMPILER=0"

where cl >nul 2>&1
if not errorlevel 1 (
    set "HAS_COMPILER=1"
    echo    !C_GREEN![OK]!C_RESET!   MSVC Compiler [cl.exe] is in active PATH.
)
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
    for /f "delims=" %%V in ('"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2^>nul') do (
        set "HAS_COMPILER=1"
        echo    !C_GREEN![OK]!C_RESET!   Visual Studio VC++ Tools: %%V
    )
)

where gcc >nul 2>&1
if errorlevel 1 goto :CHECK_CLANG
set "HAS_COMPILER=1"
for /f "delims=" %%V in ('gcc --version 2^>nul') do (
    echo    !C_GREEN![OK]!C_RESET!   GCC: %%V
    goto :CHECK_CMAKE
)

:CHECK_CLANG
where clang >nul 2>&1
if errorlevel 1 goto :CHECK_CMAKE
set "HAS_COMPILER=1"
for /f "delims=" %%V in ('clang --version 2^>nul') do (
    echo    !C_GREEN![OK]!C_RESET!   Clang: %%V
    goto :CHECK_CMAKE
)

:CHECK_CMAKE
where cmake >nul 2>&1
if errorlevel 1 goto :NO_CMAKE
for /f "delims=" %%V in ('cmake --version 2^>nul') do (
    echo    !C_GREEN![OK]!C_RESET!   CMake: %%V
    goto :AFTER_CPP
)

:NO_CMAKE
echo    !C_CYAN![INFO]!C_RESET! CMake is not installed.

:AFTER_CPP
if "!HAS_COMPILER!"=="0" (
    echo    !C_CYAN![INFO]!C_RESET! No native C/C++ compiler detected.
)
exit /b

REM ------------------------------------------------------------
REM [7] DOCKER CHECK
REM ------------------------------------------------------------
:DIAG_DOCKER
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!DOCKER ^& CONTAINER CHECK!C_RESET!
echo  ----------------------------------------------------------------------
call :SUB_DOCKER
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

:SUB_DOCKER
where docker >nul 2>&1
if errorlevel 1 (
    echo    !C_CYAN![INFO]!C_RESET! Docker Desktop / CLI is not installed [optional].
    exit /b
)
for /f "delims=" %%I in ('where docker 2^>nul') do set "DOCK_LOC=%%I"
echo    !C_GREEN![OK]!C_RESET!   Binary  : !DOCK_LOC!
for /f "delims=" %%V in ('docker --version 2^>nul') do echo    !C_GREEN![OK]!C_RESET!   Version : %%V

docker info >nul 2>&1
if not errorlevel 1 (
    echo    !C_GREEN![OK]!C_RESET!   Daemon  : Docker engine daemon is running.
) else (
    echo    !C_YELLOW![WARN]!C_RESET! Docker daemon is stopped or Docker Desktop is not started.
)
exit /b

REM ------------------------------------------------------------
REM [8] WINGET CHECK
REM ------------------------------------------------------------
:DIAG_WINGET
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!WINDOWS PACKAGE MANAGER (WINGET) CHECK!C_RESET!
echo  ----------------------------------------------------------------------
call :SUB_WINGET
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

:SUB_WINGET
where winget >nul 2>&1
if errorlevel 1 (
    echo    !C_YELLOW![WARN]!C_RESET! WinGet command was not found in PATH.
    echo    To install WinGet, get 'App Installer' from the Microsoft Store.
    exit /b
)
for /f "delims=" %%I in ('where winget 2^>nul') do set "WG_LOC=%%I"
echo    !C_GREEN![OK]!C_RESET!   Binary  : !WG_LOC!
for /f "delims=" %%V in ('winget --version 2^>nul') do echo    !C_GREEN![OK]!C_RESET!   Version : WinGet %%V
exit /b

REM ------------------------------------------------------------
REM [9] PATH HEALTH CHECK
REM ------------------------------------------------------------
:DIAG_PATH
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!SYSTEM PATH HEALTH CHECK!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "$raw = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User'); $paths = $raw -split ';' | Where-Object { $_ -match '\S' }; $seen = @{}; $valid = 0; $missing = 0; $dupes = 0; foreach ($p in $paths) { $clean = $p.Trim().Trim([char]34); if ($seen.ContainsKey($clean.ToLower())) { Write-Host ('  [WARN] Duplicate entry: ' + $clean) -ForegroundColor Yellow; $dupes++; continue }; $seen[$clean.ToLower()] = $true; if (Test-Path -LiteralPath $clean) { Write-Host ('  [OK]   ' + $clean) -ForegroundColor Green; $valid++ } else { Write-Host ('  [FAIL] Directory not found: ' + $clean) -ForegroundColor Red; $missing++ } }; Write-Host ''; Write-Host ('  Summary: ' + $valid + ' Valid, ' + $missing + ' Missing/Broken, ' + $dupes + ' Duplicates.')" 2>nul
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

:SUB_PATH_BRIEF
powershell -NoProfile -Command "$raw = $env:Path; $paths = $raw -split ';' | Where-Object { $_ -match '\S' }; $valid = 0; $missing = 0; foreach ($p in $paths) { $clean = $p.Trim().Trim([char]34); if (Test-Path -LiteralPath $clean) { $valid++ } else { $missing++ } }; if ($missing -eq 0) { Write-Host ('    [OK] PATH contains ' + $valid + ' active valid entries, 0 broken.') -ForegroundColor Green } else { Write-Host ('    [WARN] PATH contains ' + $missing + ' missing/broken directory entries.') -ForegroundColor Yellow }" 2>nul
exit /b

REM ------------------------------------------------------------
REM [10] ENVIRONMENT VARIABLES
REM ------------------------------------------------------------
:DIAG_ENV
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!DEVELOPER ENVIRONMENT VARIABLES!C_RESET!
echo  ----------------------------------------------------------------------
call :CHECK_VAR "JAVA_HOME"
call :CHECK_VAR "PYTHONPATH"
call :CHECK_VAR "NODE_PATH"
call :CHECK_VAR "GOPATH"
call :CHECK_VAR "GOROOT"
call :CHECK_VAR "CARGO_HOME"
call :CHECK_VAR "RUSTUP_HOME"
call :CHECK_VAR "DOCKER_HOST"
call :CHECK_VAR "VCPKG_ROOT"
call :CHECK_VAR "ANDROID_HOME"
call :CHECK_VAR "MAVEN_HOME"
call :CHECK_VAR "GRADLE_USER_HOME"
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

:CHECK_VAR
set "VNAME=%~1"
set "VVAL=!%VNAME%!"
if defined VVAL (
    if exist "!VVAL!" (
        echo    !C_GREEN![OK]!C_RESET!   !VNAME! = !VVAL!
    ) else (
        echo    !C_YELLOW![WARN]!C_RESET! !VNAME! is defined but path does not exist: !VVAL!
    )
) else (
    echo    !C_GRAY![INFO]!C_RESET! !VNAME! is not set.
)
exit /b

REM ------------------------------------------------------------
REM [11] GENERATE DIAGNOSTIC REPORT
REM ------------------------------------------------------------
:DIAG_REPORT
cls
call :HEADER
echo  Writing diagnostic report to file...

> "%REPORT_FILE%" echo ============================================================
>>"%REPORT_FILE%" echo DEV TOOLS SUITE :: DEV DOCTOR REPORT
>>"%REPORT_FILE%" echo Provider: %APP_PROVIDER%
>>"%REPORT_FILE%" echo Date: %date% %time%
>>"%REPORT_FILE%" echo Machine: %COMPUTERNAME% (%PROCESSOR_ARCHITECTURE%)
>>"%REPORT_FILE%" echo OS: 
cmd /c ver >>"%REPORT_FILE%"
>>"%REPORT_FILE%" echo ============================================================
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo COMMAND AVAILABILITY:
for %%C in (git gh code python node npm java cmake docker winget go rustc cl) do (
    where %%C >nul 2>&1
    if not errorlevel 1 (
        >>"%REPORT_FILE%" echo [OK]      %%C is present
    ) else (
        >>"%REPORT_FILE%" echo [MISSING] %%C is not found
    )
)
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo DEVELOPER ENVIRONMENT VARIABLES:
for %%V in (JAVA_HOME PYTHONPATH NODE_PATH GOPATH GOROOT CARGO_HOME DOCKER_HOST VCPKG_ROOT ANDROID_HOME) do (
    set "VAL=!%%V!"
    if defined VAL (
        >>"%REPORT_FILE%" echo %%V = !VAL!
    ) else (
        >>"%REPORT_FILE%" echo %%V = ^<NOT SET^>
    )
)
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo ACTIVE PATH:
>>"%REPORT_FILE%" echo %PATH%
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo ============================================================

echo.
echo  !C_GREEN![OK]!C_RESET! Diagnostic report generated:
echo  !C_CYAN!%REPORT_FILE%!C_RESET!
echo.
if not "%~1"=="" goto :EXIT
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
endlocal
exit /b 0
