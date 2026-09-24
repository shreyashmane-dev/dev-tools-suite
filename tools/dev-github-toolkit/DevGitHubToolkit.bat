@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV GITHUB TOOLKIT
REM Git & GitHub Workflow Automation & Management
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV GITHUB TOOLKIT
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

set "APP_NAME=DEV GitHub Toolkit"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"

goto :MAIN_MENU

REM ------------------------------------------------------------
REM HEADER
REM ------------------------------------------------------------
:HEADER
cls
echo.
echo !C_CYAN!  ======================================================================!C_RESET!
echo !C_CYAN!               DDDD    EEEE   V     V!C_RESET!
echo !C_CYAN!               D   D   E      V     V!C_RESET!
echo !C_CYAN!               D   D   EEEE    V   V !C_RESET!
echo !C_CYAN!               D   D   E        V V  !C_RESET!
echo !C_CYAN!               DDDD    EEEE      V   !C_RESET!
echo.
echo !C_WHITE!!C_BOLD!                         DEV GITHUB TOOLKIT!C_RESET!
echo !C_GRAY!                             AnoS !C_WHITE!^| !C_CYAN!v%APP_VERSION%!C_RESET!
echo !C_CYAN!  ======================================================================!C_RESET!
echo.
exit /b

REM ------------------------------------------------------------
REM MAIN MENU
REM ------------------------------------------------------------
:MAIN_MENU
cls
call :HEADER

echo  !C_WHITE!WORKING REPOSITORY!C_RESET!
git rev-parse --is-inside-work-tree >nul 2>&1
if not errorlevel 1 (
    for /f "delims=" %%B in ('git branch --show-current 2^>nul') do set "CUR_BRANCH=%%B"
    if not defined CUR_BRANCH set "CUR_BRANCH=HEAD (detached)"
    echo  Directory : !C_CYAN!%CD%!C_RESET!
    echo  Branch    : !C_GREEN!!CUR_BRANCH!!C_RESET!
) else (
    echo  Directory : !C_YELLOW!%CD% (Not a git repository)!C_RESET!
)
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET!  Check Git                     !C_CYAN![7]!C_RESET!  Commit Changes
echo    !C_CYAN![2]!C_RESET!  Check GitHub CLI              !C_CYAN![8]!C_RESET!  Push to Remote
echo    !C_CYAN![3]!C_RESET!  Configure Git Identity        !C_CYAN![9]!C_RESET!  Pull from Remote
echo    !C_CYAN![4]!C_RESET!  GitHub Authentication Status  !C_CYAN![10]!C_RESET! Branch Manager
echo    !C_CYAN![5]!C_RESET!  Initialize Repository         !C_CYAN![11]!C_RESET! Repository Status
echo    !C_CYAN![6]!C_RESET!  Add Remote                    !C_CYAN![12]!C_RESET! Open on GitHub.com
echo    !C_RED![0]!C_RESET!  Exit
echo.

set "CHOICE="
set /p "CHOICE=Select an option [0-12]: "
if "!CHOICE!"=="1" goto :CHECK_GIT
if "!CHOICE!"=="2" goto :CHECK_GH
if "!CHOICE!"=="3" goto :CONFIG_IDENTITY
if "!CHOICE!"=="4" goto :AUTH_STATUS
if "!CHOICE!"=="5" goto :INIT_REPO
if "!CHOICE!"=="6" goto :ADD_REMOTE
if "!CHOICE!"=="7" goto :COMMIT_CHANGES
if "!CHOICE!"=="8" goto :PUSH_REPO
if "!CHOICE!"=="9" goto :PULL_REPO
if "!CHOICE!"=="10" goto :BRANCH_MGR
if "!CHOICE!"=="11" goto :STATUS_REPO
if "!CHOICE!"=="12" goto :OPEN_GITHUB
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 12.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] CHECK GIT
REM ------------------------------------------------------------
:CHECK_GIT
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!GIT INSTALLATION CHECK!C_RESET!
echo  ----------------------------------------------------------------------
where git >nul 2>&1
if errorlevel 1 (
    echo  !C_RED![FAIL] Git CLI was not found in PATH.!C_RESET!
    echo  Install Git via DEV Setup Center or DEV Package Hub.
) else (
    for /f "delims=" %%I in ('where git 2^>nul') do echo  !C_GREEN![OK]!C_RESET! Binary Location : %%I
    for /f "delims=" %%V in ('git --version 2^>nul') do echo  !C_GREEN![OK]!C_RESET! Installed Version : %%V
)
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [2] CHECK GITHUB CLI
REM ------------------------------------------------------------
:CHECK_GH
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!GITHUB CLI (GH) CHECK!C_RESET!
echo  ----------------------------------------------------------------------
where gh >nul 2>&1
if errorlevel 1 (
    echo  !C_YELLOW![INFO] GitHub CLI (gh) is not installed.!C_RESET!
    echo  GitHub CLI enables secure browser-based authentication without raw tokens.
    echo  Install via: winget install --id GitHub.cli
) else (
    for /f "delims=" %%I in ('where gh 2^>nul') do echo  !C_GREEN![OK]!C_RESET! Binary Location : %%I
    for /f "delims=" %%V in ('gh --version 2^>nul') do (
        echo  !C_GREEN![OK]!C_RESET! Installed Version : %%V
        goto :END_CHECK_GH
    )
)
:END_CHECK_GH
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [3] CONFIGURE GIT IDENTITY
REM ------------------------------------------------------------
:CONFIG_IDENTITY
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CONFIGURE GIT IDENTITY!C_RESET!
echo  ----------------------------------------------------------------------
for /f "delims=" %%U in ('git config --global user.name 2^>nul') do set "CUR_NAME=%%U"
for /f "delims=" %%E in ('git config --global user.email 2^>nul') do set "CUR_EMAIL=%%E"

echo  Current Global user.name  : !C_CYAN!%CUR_NAME%!C_RESET!
echo  Current Global user.email : !C_CYAN!%CUR_EMAIL%!C_RESET!
echo.
set "SET_NAME="
set /p "SET_NAME=Enter new global user.name [Press Enter to keep current]: "
if defined SET_NAME (
    git config --global user.name "%SET_NAME%"
    echo !C_GREEN![OK] user.name updated to: %SET_NAME%!C_RESET!
)

set "SET_EMAIL="
set /p "SET_EMAIL=Enter new global user.email [Press Enter to keep current]: "
if defined SET_EMAIL (
    git config --global user.email "%SET_EMAIL%"
    echo !C_GREEN![OK] user.email updated to: %SET_EMAIL%!C_RESET!
)
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [4] GITHUB AUTHENTICATION STATUS
REM ------------------------------------------------------------
:AUTH_STATUS
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!GITHUB AUTHENTICATION STATUS!C_RESET!
echo  ----------------------------------------------------------------------
where gh >nul 2>&1
if errorlevel 1 (
    echo  !C_YELLOW![INFO] GitHub CLI (gh) is not installed.!C_RESET!
    echo.
    echo  Safe Authentication Recommendations:
    echo  1. Use GitHub CLI for safe web login (does not store plain tokens):
    echo     winget install --id GitHub.cli
    echo     gh auth login -w
    echo.
    echo  2. Or generate and add an SSH key to github.com:
    echo     ssh-keygen -t ed25519 -C "your_email@example.com"
    echo.
    echo  SECURITY NOTICE: Never paste Personal Access Tokens into plain-text scripts!
) else (
    echo  Querying GitHub CLI authentication state...
    echo.
    gh auth status
    echo.
    echo    !C_CYAN![1]!C_RESET! Login via Web Browser (gh auth login -w)
    echo    !C_CYAN![2]!C_RESET! Refresh Authentication (gh auth refresh)
    echo    !C_RED![0]!C_RESET! Back to Menu
    echo.
    set "AUTH_ACT="
    set /p "AUTH_ACT=Choose action [0-2]: "
    if "!AUTH_ACT!"=="1" gh auth login -w
    if "!AUTH_ACT!"=="2" gh auth refresh
)
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [5] INITIALIZE REPOSITORY
REM ------------------------------------------------------------
:INIT_REPO
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!INITIALIZE GIT REPOSITORY!C_RESET!
echo  ----------------------------------------------------------------------
echo  Current folder: %CD%
git rev-parse --is-inside-work-tree >nul 2>&1
if not errorlevel 1 (
    echo !C_YELLOW![WARN] A Git repository is already initialized here.!C_RESET!
    pause
    goto :MAIN_MENU
)

set "INIT_CONF="
set /p "INIT_CONF=Initialize Git repository in current folder? [Y/N]: "
if /I not "!INIT_CONF!"=="Y" goto :MAIN_MENU

git init
git branch -M main >nul 2>&1
echo !C_GREEN![OK] Initialized empty Git repository with default branch 'main'.!C_RESET!
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [6] ADD REMOTE
REM ------------------------------------------------------------
:ADD_REMOTE
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!MANAGE GIT REMOTES!C_RESET!
echo  ----------------------------------------------------------------------
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] Not inside a Git repository.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo  Current configured remotes:
git remote -v
echo.
echo    !C_CYAN![1]!C_RESET! Add New Remote
echo    !C_CYAN![2]!C_RESET! Change Remote URL (set-url)
echo    !C_CYAN![3]!C_RESET! Remove Remote
echo    !C_RED![0]!C_RESET! Back to Menu
echo.
set "REM_ACT="
set /p "REM_ACT=Choose action [0-3]: "
if "!REM_ACT!"=="1" (
    set "REM_NAME="
    set /p "REM_NAME=Remote name [Default: origin]: "
    if not defined REM_NAME set "REM_NAME=origin"
    
    set "REM_URL="
    set /p "REM_URL=Remote URL (e.g. https://github.com/org/repo.git): "
    if defined REM_URL (
        git remote add "!REM_NAME!" "!REM_URL!"
        echo !C_GREEN![OK] Remote added.!C_RESET!
    )
)
if "!REM_ACT!"=="2" (
    set "REM_NAME="
    set /p "REM_NAME=Remote name [Default: origin]: "
    if not defined REM_NAME set "REM_NAME=origin"
    set "REM_URL="
    set /p "REM_URL=New URL: "
    if defined REM_URL (
        git remote set-url "!REM_NAME!" "!REM_URL!"
        echo !C_GREEN![OK] Remote URL updated.!C_RESET!
    )
)
if "!REM_ACT!"=="3" (
    set "REM_NAME="
    set /p "REM_NAME=Remote name to remove: "
    if defined REM_NAME (
        git remote remove "!REM_NAME!"
        echo !C_GREEN![OK] Remote removed.!C_RESET!
    )
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [7] COMMIT CHANGES
REM ------------------------------------------------------------
:COMMIT_CHANGES
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!COMMIT CHANGES!C_RESET!
echo  ----------------------------------------------------------------------
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] Not inside a Git repository.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo  Current Status:
git status -s
echo.
set "STAGE_ALL="
set /p "STAGE_ALL=Stage all changes (git add .)? [Y/N]: "
if /I "!STAGE_ALL!"=="Y" (
    git add .
    echo !C_GREEN![OK] All modified files staged.!C_RESET!
)

echo.
set "COMMIT_MSG="
set /p "COMMIT_MSG=Enter commit message: "
if not defined COMMIT_MSG (
    echo !C_RED![FAIL] Commit message cannot be empty.!C_RESET!
    pause
    goto :MAIN_MENU
)

git commit -m "%COMMIT_MSG%"
if errorlevel 1 (
    echo !C_YELLOW![WARN] Commit did not record any new changes.!C_RESET!
) else (
    echo !C_GREEN![OK] Commit recorded successfully.!C_RESET!
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [8] PUSH TO REMOTE
REM ------------------------------------------------------------
:PUSH_REPO
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!GIT PUSH TO REMOTE!C_RESET!
echo  ----------------------------------------------------------------------
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] Not inside a Git repository.!C_RESET!
    pause
    goto :MAIN_MENU
)

for /f "delims=" %%B in ('git branch --show-current 2^>nul') do set "P_BRANCH=%%B"
if not defined P_BRANCH set "P_BRANCH=main"

set "P_REM="
set /p "P_REM=Remote [Default: origin]: "
if not defined P_REM set "P_REM=origin"

set "P_B="
set /p "P_B=Branch [Default: !P_BRANCH!]: "
if not defined P_B set "P_B=!P_BRANCH!"

echo.
echo  Command: git push -u !P_REM! !P_B!
set "CONF_PUSH="
set /p "CONF_PUSH=Execute push? [Y/N]: "
if /I not "!CONF_PUSH!"=="Y" goto :MAIN_MENU

echo.
git push -u "!P_REM!" "!P_B!"
if errorlevel 1 (
    echo !C_RED![FAIL] Push failed. Check your network or permissions.!C_RESET!
) else (
    echo !C_GREEN![OK] Push succeeded.!C_RESET!
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [9] PULL FROM REMOTE
REM ------------------------------------------------------------
:PULL_REPO
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!GIT PULL FROM REMOTE!C_RESET!
echo  ----------------------------------------------------------------------
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] Not inside a Git repository.!C_RESET!
    pause
    goto :MAIN_MENU
)

set "PULL_REM="
set /p "PULL_REM=Remote [Default: origin]: "
if not defined PULL_REM set "PULL_REM=origin"

for /f "delims=" %%B in ('git branch --show-current 2^>nul') do set "PULL_B=%%B"
if not defined PULL_B set "PULL_B=main"

echo.
git pull "!PULL_REM!" "!PULL_B!"
if errorlevel 1 (
    echo !C_RED![FAIL] Pull encountered conflicts or network error.!C_RESET!
) else (
    echo !C_GREEN![OK] Pull complete.!C_RESET!
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [10] BRANCH MANAGER
REM ------------------------------------------------------------
:BRANCH_MGR
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!GIT BRANCH MANAGER!C_RESET!
echo  ----------------------------------------------------------------------
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] Not inside a Git repository.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo  Local Branches:
git branch -v
echo.
echo    !C_CYAN![1]!C_RESET! Create and Switch to New Branch
echo    !C_CYAN![2]!C_RESET! Switch Existing Branch
echo    !C_CYAN![3]!C_RESET! Delete Branch
echo    !C_RED![0]!C_RESET! Back to Menu
echo.
set "BR_ACT="
set /p "BR_ACT=Choose action [0-3]: "
if "!BR_ACT!"=="1" (
    set "NEW_B="
    set /p "NEW_B=Enter new branch name: "
    if defined NEW_B (
        git checkout -b "!NEW_B!"
        echo !C_GREEN![OK] Created and switched to !NEW_B!.!C_RESET!
    )
)
if "!BR_ACT!"=="2" (
    set "SW_B="
    set /p "SW_B=Enter target branch name: "
    if defined SW_B (
        git checkout "!SW_B!"
        echo !C_GREEN![OK] Switched to !SW_B!.!C_RESET!
    )
)
if "!BR_ACT!"=="3" (
    set "DEL_B="
    set /p "DEL_B=Enter branch name to delete: "
    if defined DEL_B (
        git branch -d "!DEL_B!"
        echo !C_GREEN![OK] Branch deleted.!C_RESET!
    )
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [11] REPOSITORY STATUS
REM ------------------------------------------------------------
:STATUS_REPO
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!COMPREHENSIVE REPOSITORY STATUS!C_RESET!
echo  ----------------------------------------------------------------------
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] Current directory is not a Git repository.!C_RESET!
    pause
    goto :MAIN_MENU
)

git status
echo.
echo  Recent Commits:
git log --oneline -n 5 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [12] OPEN ON GITHUB
REM ------------------------------------------------------------
:OPEN_GITHUB
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!OPEN REPOSITORY ON GITHUB!C_RESET!
echo  ----------------------------------------------------------------------
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] Not inside a Git repository.!C_RESET!
    pause
    goto :MAIN_MENU
)

for /f "delims=" %%R in ('git remote get-url origin 2^>nul') do set "RAW_REMOTE=%%R"

if not defined RAW_REMOTE (
    echo !C_YELLOW![WARN] No 'origin' remote found.!C_RESET!
    pause
    goto :MAIN_MENU
)

echo  Detected Remote URL: !RAW_REMOTE!

REM Convert git@github.com:owner/repo.git or https://github.com/owner/repo.git
powershell -NoProfile -Command "
$u = '%RAW_REMOTE%';
if ($u -match 'git@github\.com:(.+?)\.git') {
    $target = 'https://github.com/' + $matches[1];
} elseif ($u -match 'https://github\.com/(.+?)\.git') {
    $target = 'https://github.com/' + $matches[1];
} elseif ($u -match '^https?://') {
    $target = $u;
} else {
    $target = 'https://github.com';
}
Write-Host ('Opening: ' + $target) -ForegroundColor Green;
Start-Process $target;
" 2>nul

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
