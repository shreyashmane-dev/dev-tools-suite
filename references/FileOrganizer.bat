@echo off
setlocal EnableExtensions
title Simple File Organizer
color 0B
set "BAT_FILE=%~f0"
set "PS_FILE=%TEMP%\FileOrganizer_%RANDOM%_%RANDOM%.ps1"
set "MARKER_LINE="
for /f "tokens=1 delims=:" %%L in ('findstr /n /b /c:"#__POWERSHELL__" "%~f0"') do set "MARKER_LINE=%%L"
if not defined MARKER_LINE goto :launcher_error
more +%MARKER_LINE% "%~f0" > "%PS_FILE%"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%PS_FILE%"
set "RESULT=%ERRORLEVEL%"
del "%PS_FILE%" >nul 2>&1
if not "%RESULT%"=="0" (
    echo.
    echo Organizer stopped with an error. The message above explains why.
    pause
)
exit /b %RESULT%

:launcher_error
echo Could not find the embedded organizer script.
pause
exit /b 1
#__POWERSHELL__
$ErrorActionPreference = 'Stop'
$Host.UI.RawUI.WindowTitle = 'Simple File Organizer'
function Header {
    Clear-Host
    Write-Host ''
    Write-Host '  =====================================' -ForegroundColor Cyan
    Write-Host '          SIMPLE FILE ORGANIZER' -ForegroundColor White
    Write-Host '  =====================================' -ForegroundColor Cyan
    Write-Host ''
}
function Wait-Close { [void](Read-Host '  Press Enter to close') }
Header
Write-Host '  Choose the folder to organize:' -ForegroundColor White
Write-Host ''
Write-Host '  [1] This folder (where this BAT is saved)' -ForegroundColor Green
Write-Host '  [2] Enter another folder path' -ForegroundColor Green
Write-Host '  [Q] Quit' -ForegroundColor Yellow
Write-Host ''
$choice = (Read-Host '  Choose 1, 2, or Q').Trim()
if ($choice -match '^[Qq]$') { exit 0 }
if ($choice -eq '1') {
    $target = Split-Path -Parent $env:BAT_FILE
} elseif ($choice -eq '2') {
    $target = (Read-Host '  Paste the folder path').Trim().Trim('"')
} else {
    Write-Host '  Choose 1, 2, or Q.' -ForegroundColor Red
    Wait-Close
    exit 1
}
try {
    if (-not (Test-Path -LiteralPath $target -PathType Container)) { throw 'That folder does not exist.' }
    $target = (Resolve-Path -LiteralPath $target).Path
} catch {
    Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
    Wait-Close
    exit 1
}
Write-Host ''
Write-Host '  Folder:' -ForegroundColor Cyan
Write-Host "  $target" -ForegroundColor White
Write-Host ''
Write-Host '  Main folders: Images, Videos, Audio, Documents, PDFs, Archives,' -ForegroundColor Cyan
Write-Host '  Installers, Development, and Other.' -ForegroundColor Cyan
Write-Host '  Programming languages and dotfiles go under Development\Developer-Code.' -ForegroundColor Gray
Write-Host '  It checks loose files and files directly inside organizer folders only.' -ForegroundColor Gray
Write-Host ''
$confirm = (Read-Host '  Start organizing? [Y/N]').Trim()
if ($confirm -notmatch '^[Yy]$') {
    Write-Host '  Cancelled. No files were moved.' -ForegroundColor Yellow
    Wait-Close
    exit 0
}

$codeRoot = 'Development\Developer-Code'
$language = @{
    '.py'='Python'; '.pyw'='Python'; '.pyx'='Python'
    '.c'='C'; '.h'='C'; '.cc'='C++'; '.cpp'='C++'; '.cxx'='C++'; '.hpp'='C++'; '.hh'='C++'; '.hxx'='C++'
    '.java'='Java'; '.class'='Java'; '.jar'='Java'
    '.js'='JavaScript'; '.mjs'='JavaScript'; '.cjs'='JavaScript'; '.jsx'='JavaScript'
    '.ts'='TypeScript'; '.tsx'='TypeScript'; '.cs'='CSharp'; '.go'='Go'; '.rs'='Rust'
    '.kt'='Kotlin'; '.kts'='Kotlin'; '.swift'='Swift'; '.dart'='Dart'; '.php'='PHP'
    '.rb'='Ruby'; '.lua'='Lua'; '.r'='R'; '.rmd'='R'; '.sql'='SQL'
    '.html'='Web'; '.htm'='Web'; '.css'='Web'; '.scss'='Web'; '.sass'='Web'; '.vue'='Web'; '.svelte'='Web'
    '.sh'='Shell'; '.bash'='Shell'; '.zsh'='Shell'; '.ps1'='PowerShell'; '.psm1'='PowerShell'; '.psd1'='PowerShell'
}
$dotFiles = @('.env','.gitignore','.gitattributes','.gitmodules','.dockerignore','dockerfile','makefile','justfile','procfile','cmakelists.txt','requirements.txt','pyproject.toml','package.json','package-lock.json','yarn.lock','pnpm-lock.yaml','tsconfig.json','cargo.toml','go.mod','composer.json','gemfile','pom.xml','build.gradle','gradle.properties')
$managed = @('Images','Videos','Audio','Documents','PDFs','Archives','Installers','Development','Other')
$files = @(Get-ChildItem -LiteralPath $target -File -Force)
foreach ($category in $managed) {
    $folder = Join-Path $target $category
    if (Test-Path -LiteralPath $folder -PathType Container) {
        $files += Get-ChildItem -LiteralPath $folder -File -Force
    }
}
$files = @($files | Where-Object { $_.FullName -ne $env:BAT_FILE } | Sort-Object -Property FullName -Unique)
$moved = 0
$skipped = 0
foreach ($file in $files) {
    $ext = $file.Extension.ToLowerInvariant()
    $name = $file.Name.ToLowerInvariant()
    if (($dotFiles -contains $name) -or ($name -match '^\.env\..+')) { $relative = "$codeRoot\Configuration" }
    elseif ($language.ContainsKey($ext)) { $relative = "$codeRoot\$($language[$ext])" }
    elseif ($ext -in @('.blend','.blend1','.fbx','.obj','.stl','.gltf','.glb','.dae','.3ds','.abc')) { $relative = 'Development\3D' }
    elseif ($ext -in @('.jpg','.jpeg','.png','.gif','.bmp','.webp','.tif','.tiff','.heic','.ico')) { $relative = 'Images' }
    elseif ($ext -in @('.mp4','.mkv','.mov','.avi','.wmv','.webm','.m4v')) { $relative = 'Videos' }
    elseif ($ext -in @('.mp3','.wav','.flac','.aac','.m4a','.ogg','.wma')) { $relative = 'Audio' }
    elseif ($ext -eq '.pdf') { $relative = 'PDFs' }
    elseif ($ext -in @('.doc','.docx','.odt','.rtf','.txt','.md','.epub','.mobi')) { $relative = 'Documents' }
    elseif ($ext -in @('.xls','.xlsx','.ods','.csv')) { $relative = 'Documents\Spreadsheets' }
    elseif ($ext -in @('.ppt','.pptx','.odp')) { $relative = 'Documents\Presentations' }
    elseif ($ext -in @('.zip','.rar','.7z','.tar','.gz','.bz2')) { $relative = 'Archives' }
    elseif ($ext -in @('.exe','.msi','.msix','.appx')) { $relative = 'Installers' }
    else { $relative = 'Other' }

    $destination = Join-Path $target $relative
    if ($file.DirectoryName -eq $destination) { continue }
    try {
        New-Item -ItemType Directory -Path $destination -Force | Out-Null
        $destFile = Join-Path $destination $file.Name
        if (Test-Path -LiteralPath $destFile) {
            $base = [IO.Path]::GetFileNameWithoutExtension($file.Name)
            $suffix = [IO.Path]::GetExtension($file.Name)
            $number = 1
            do { $destFile = Join-Path $destination "$base ($number)$suffix"; $number++ }
            while (Test-Path -LiteralPath $destFile)
        }
        Move-Item -LiteralPath $file.FullName -Destination $destFile
        $moved++
    } catch {
        $skipped++
        Write-Host "  Could not move $($file.Name): $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
Write-Host ''
Write-Host '  Finished.' -ForegroundColor Green
Write-Host "  Files moved: $moved"
if ($skipped -gt 0) { Write-Host "  Files skipped: $skipped" -ForegroundColor Yellow }
Write-Host '  You can run the organizer again for new or misplaced files.' -ForegroundColor Gray
Write-Host ''
Wait-Close
