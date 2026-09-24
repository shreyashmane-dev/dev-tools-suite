@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV FILE ORGANIZER
REM Smart Developer Workspace & File Classification Utility
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV FILE ORGANIZER
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

set "APP_NAME=DEV File Organizer"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"

set "LAST_FOLDER="
set "DRY_RUN=0"

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

echo  !C_WHITE!WORKSPACE CLASSIFIER DASHBOARD!C_RESET!
echo  Categorizes developer code (30+ languages), dotfiles, media, archives, and docs.
if defined LAST_FOLDER (
    echo  Last Processed: !C_CYAN!%LAST_FOLDER%!C_RESET!
)
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET! Organize Current Working Directory (%CD%)
echo    !C_CYAN![2]!C_RESET! Organize Downloads Folder (%USERPROFILE%\Downloads)
echo    !C_CYAN![3]!C_RESET! Organize Custom Directory
echo    !C_CYAN![4]!C_RESET! Dry Run / Simulation (Preview without moving files)
echo    !C_CYAN![5]!C_RESET! View Supported Extensions & Language Catalog
echo    !C_RED![0]!C_RESET! Exit
echo.

set "CHOICE="
set /p "CHOICE=Select an option [0-5]: "
if "!CHOICE!"=="1" goto :ORG_CURRENT
if "!CHOICE!"=="2" goto :ORG_DOWNLOADS
if "!CHOICE!"=="3" goto :ORG_CUSTOM
if "!CHOICE!"=="4" goto :ORG_DRY_RUN
if "!CHOICE!"=="5" goto :VIEW_CATALOG
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 5.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] ORGANIZE CURRENT WORKING DIRECTORY
REM ------------------------------------------------------------
:ORG_CURRENT
set "DRY_RUN=0"
call :RUN_ORGANIZER "%CD%"
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [2] ORGANIZE DOWNLOADS FOLDER
REM ------------------------------------------------------------
:ORG_DOWNLOADS
set "DRY_RUN=0"
call :RUN_ORGANIZER "%USERPROFILE%\Downloads"
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [3] ORGANIZE CUSTOM DIRECTORY
REM ------------------------------------------------------------
:ORG_CUSTOM
set "DRY_RUN=0"
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CUSTOM DIRECTORY ORGANIZER!C_RESET!
echo  ----------------------------------------------------------------------
set "CUST_PATH="
set /p "CUST_PATH=Enter or paste full folder path: "
if not defined CUST_PATH goto :MAIN_MENU
set "CUST_PATH=%CUST_PATH:"=%"

if not exist "%CUST_PATH%" (
    echo !C_RED![FAIL] Directory does not exist: %CUST_PATH%!C_RESET!
    pause
    goto :MAIN_MENU
)

call :RUN_ORGANIZER "%CUST_PATH%"
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [4] DRY RUN / SIMULATION
REM ------------------------------------------------------------
:ORG_DRY_RUN
set "DRY_RUN=1"
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!SIMULATION / DRY RUN!C_RESET!
echo  ----------------------------------------------------------------------
echo  Shows planned moves without modifying any files on disk.
echo.
set "DRY_PATH="
set /p "DRY_PATH=Folder path [Press Enter for current: %CD%]: "
if not defined DRY_PATH set "DRY_PATH=%CD%"
set "DRY_PATH=%DRY_PATH:"=%"

if not exist "%DRY_PATH%" (
    echo !C_RED![FAIL] Directory does not exist: %DRY_PATH%!C_RESET!
    pause
    goto :MAIN_MENU
)

call :RUN_ORGANIZER "%DRY_PATH%"
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM ORGANIZER ENGINE
REM ------------------------------------------------------------
:RUN_ORGANIZER
set "TARGET_DIR=%~1"
set "LAST_FOLDER=%TARGET_DIR%"
cls
call :HEADER

echo  Target Directory: !C_CYAN!%TARGET_DIR%!C_RESET!
if "!DRY_RUN!"=="1" (
    echo  Mode            : !C_YELLOW!SIMULATION / DRY RUN (No files will be moved)!C_RESET!
) else (
    echo  Mode            : !C_GREEN!LIVE EXECUTION!C_RESET!
    set "CONF="
    set /p "CONF=Proceed with organizing files? [Y/N]: "
    if /I not "!CONF!"=="Y" (
        echo !C_YELLOW!Operation cancelled.!C_RESET!
        exit /b
    )
)
echo.
echo  Scanning and categorizing files...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "
$target = '%TARGET_DIR%';
$dryRun = (%DRY_RUN% -eq 1);
$codeRoot = 'Development\Developer-Code';

$langMap = @{
    '.py'='Python'; '.pyw'='Python'; '.pyx'='Python'
    '.c'='C'; '.h'='C'; '.cc'='C++'; '.cpp'='C++'; '.cxx'='C++'; '.hpp'='C++'; '.hh'='C++'
    '.java'='Java'; '.class'='Java'; '.jar'='Java'
    '.js'='JavaScript'; '.mjs'='JavaScript'; '.cjs'='JavaScript'; '.jsx'='JavaScript'
    '.ts'='TypeScript'; '.tsx'='TypeScript'; '.cs'='CSharp'; '.go'='Go'; '.rs'='Rust'
    '.kt'='Kotlin'; '.kts'='Kotlin'; '.swift'='Swift'; '.dart'='Dart'; '.php'='PHP'
    '.rb'='Ruby'; '.lua'='Lua'; '.r'='R'; '.rmd'='R'; '.sql'='SQL'
    '.html'='Web'; '.htm'='Web'; '.css'='Web'; '.scss'='Web'; '.sass'='Web'; '.vue'='Web'; '.svelte'='Web'
    '.sh'='Shell'; '.bash'='Shell'; '.zsh'='Shell'; '.ps1'='PowerShell'; '.psm1'='PowerShell'
}

$dotFiles = @('.env','.gitignore','.gitattributes','.gitmodules','.dockerignore','dockerfile','makefile','justfile','cmakelists.txt','requirements.txt','pyproject.toml','package.json','package-lock.json','yarn.lock','pnpm-lock.yaml','tsconfig.json','cargo.toml','go.mod','pom.xml','build.gradle')

$managed = @('Images','Videos','Audio','Documents','PDFs','Archives','Installers','Development','Other')

$files = @(Get-ChildItem -LiteralPath $target -File -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -notlike '*.bat' -and $_.Name -notlike '*.ps1' })

$moved = 0
$skipped = 0

foreach ($file in $files) {
    $ext = $file.Extension.ToLowerInvariant()
    $name = $file.Name.ToLowerInvariant()

    if (($dotFiles -contains $name) -or ($name -match '^\.env\..+')) { $rel = \"$codeRoot\Configuration\" }
    elseif ($langMap.ContainsKey($ext)) { $rel = \"$codeRoot\$($langMap[$ext])\" }
    elseif ($ext -in @('.blend','.fbx','.obj','.stl','.gltf','.glb','.dae','.3ds')) { $rel = 'Development\3D-Assets' }
    elseif ($ext -in @('.jpg','.jpeg','.png','.gif','.bmp','.webp','.svg','.ico','.tiff')) { $rel = 'Images' }
    elseif ($ext -in @('.mp4','.mkv','.mov','.avi','.wmv','.webm','.m4v')) { $rel = 'Videos' }
    elseif ($ext -in @('.mp3','.wav','.flac','.aac','.m4a','.ogg','.wma')) { $rel = 'Audio' }
    elseif ($ext -eq '.pdf') { $rel = 'PDFs' }
    elseif ($ext -in @('.doc','.docx','.odt','.rtf','.txt','.md','.epub')) { $rel = 'Documents' }
    elseif ($ext -in @('.xls','.xlsx','.ods','.csv')) { $rel = 'Documents\Spreadsheets' }
    elseif ($ext -in @('.ppt','.pptx','.odp')) { $rel = 'Documents\Presentations' }
    elseif ($ext -in @('.zip','.rar','.7z','.tar','.gz','.bz2')) { $rel = 'Archives' }
    elseif ($ext -in @('.exe','.msi','.msix','.appx')) { $rel = 'Installers' }
    else { $rel = 'Other' }

    $destFolder = Join-Path $target $rel
    $destFile = Join-Path $destFolder $file.Name

    if ($dryRun) {
        Write-Host ('  [PLAN] ' + $file.Name + ' -> ' + $rel) -ForegroundColor Cyan
        $moved++
    } else {
        try {
            if (-not (Test-Path -LiteralPath $destFolder)) {
                New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
            }
            if (Test-Path -LiteralPath $destFile) {
                $base = [IO.Path]::GetFileNameWithoutExtension($file.Name)
                $suf = [IO.Path]::GetExtension($file.Name)
                $num = 1
                do { $destFile = Join-Path $destFolder \"$base ($num)$suf\"; $num++ }
                while (Test-Path -LiteralPath $destFile)
            }
            Move-Item -LiteralPath $file.FullName -Destination $destFile -Force
            Write-Host ('  [MOVED] ' + $file.Name + ' -> ' + $rel) -ForegroundColor Green
            $moved++
        } catch {
            Write-Host ('  [SKIP] ' + $file.Name + ': ' + $_.Exception.Message) -ForegroundColor Yellow
            $skipped++
        }
    }
}

Write-Host ''
Write-Host '----------------------------------------------------------------------'
if ($dryRun) {
    Write-Host ('  Simulation complete. Files analyzed for organization: ' + $moved) -ForegroundColor Yellow
} else {
    Write-Host ('  Operation complete. Successfully moved: ' + $moved + ' | Skipped: ' + $skipped) -ForegroundColor Green
}
" 2>nul

exit /b

REM ------------------------------------------------------------
REM [5] VIEW CATALOG
REM ------------------------------------------------------------
:VIEW_CATALOG
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!SUPPORTED FILE TYPES & EXTENSIONS!C_RESET!
echo  ----------------------------------------------------------------------
echo  * Developer Languages : Python, C, C++, Java, JS, TS, C#, Go, Rust, Kotlin,
echo                          Swift, Dart, PHP, Ruby, Lua, R, SQL, Web (HTML/CSS),
echo                          Shell, PowerShell
echo  * Configuration Files   : .env, .gitignore, package.json, CMakeLists.txt,
echo                          pom.xml, build.gradle, cargo.toml, dockerfile
echo  * 3D & Spatial Assets  : .blend, .fbx, .obj, .stl, .gltf, .glb, .dae
echo  * Media Categories     : Images, Videos, Audio, PDFs, Documents, Archives
echo  * Installers           : .exe, .msi, .msix, .appx
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
