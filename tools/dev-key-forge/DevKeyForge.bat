@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV KEY FORGE
REM Developer Cryptography, SSH Keys, SSL & Hash Utility
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV KEY FORGE
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

set "APP_NAME=DEV Key Forge"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"

set "EMPTY_COUNT=0"

REM --- Direct CLI Argument Routing
if not "%~1"=="" (
    set "CHOICE=%~1"
    if "%~1"=="1" goto :GEN_SSH
    if "%~1"=="2" goto :GEN_SSL
    if "%~1"=="3" goto :GEN_API_KEY
    if "%~1"=="4" goto :GEN_JWT
    if "%~1"=="5" goto :COMPUTE_HASH
    if "%~1"=="6" goto :BASE64_TOOL
    if "%~1"=="7" goto :GEN_UUID
    if "%~1"=="0" goto :EXIT
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

echo  !C_WHITE!DEVELOPER CRYPTOGRAPHIC TOOLKIT!C_RESET!
echo  Secure generation of SSH keys, local SSL certs, API tokens, and file hashes.
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET!  Generate SSH Keypair (ed25519 / RSA-4096)
echo    !C_CYAN![2]!C_RESET!  Generate Localhost SSL / TLS Self-Signed Certificate
echo    !C_CYAN![3]!C_RESET!  Generate Cryptographically Secure API Keys / Passwords
echo    !C_CYAN![4]!C_RESET!  Generate JWT HMAC-SHA256 Signing Secret
echo    !C_CYAN![5]!C_RESET!  Compute File Hashes (MD5, SHA-256, SHA-512)
echo    !C_CYAN![6]!C_RESET!  Base64 Encode / Decode Text
echo    !C_CYAN![7]!C_RESET!  Generate UUID / GUID v4
echo    !C_RED![0]!C_RESET!  Exit
echo.

set "CHOICE="
set /p "CHOICE=Select an option [0-7]: "
if not defined CHOICE (
    set /a EMPTY_COUNT+=1
    if !EMPTY_COUNT! geq 3 goto :EXIT
    goto :MAIN_MENU
)
set "EMPTY_COUNT=0"

if "!CHOICE!"=="1" goto :GEN_SSH
if "!CHOICE!"=="2" goto :GEN_SSL
if "!CHOICE!"=="3" goto :GEN_API_KEY
if "!CHOICE!"=="4" goto :GEN_JWT
if "!CHOICE!"=="5" goto :COMPUTE_HASH
if "!CHOICE!"=="6" goto :BASE64_TOOL
if "!CHOICE!"=="7" goto :GEN_UUID
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 7.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] GENERATE SSH KEYPAIR
REM ------------------------------------------------------------
:GEN_SSH
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!GENERATE SSH KEYPAIR!C_RESET!
echo  ----------------------------------------------------------------------
where ssh-keygen >nul 2>&1
if errorlevel 1 (
    echo !C_RED![FAIL] ssh-keygen is not found in PATH.!C_RESET!
    if not "%~1"=="" goto :EXIT
    pause
    goto :MAIN_MENU
)

echo    !C_CYAN![1]!C_RESET! ed25519 (Recommended modern standard)
echo    !C_CYAN![2]!C_RESET! RSA 4096-bit (Legacy compatibility)
echo.
set "SSH_T="
if not "%~2"=="" (
    set "SSH_T=%~2"
) else (
    set /p "SSH_T=Select algorithm [1-2]: "
)

set "SSH_EMAIL="
if not "%~3"=="" (
    set "SSH_EMAIL=%~3"
) else (
    set /p "SSH_EMAIL=Comment / Email label [e.g. developer@local]: "
)
if not defined SSH_EMAIL set "SSH_EMAIL=dev@local"

if "%SSH_T%"=="2" (
    ssh-keygen -t rsa -b 4096 -C "%SSH_EMAIL%"
) else (
    ssh-keygen -t ed25519 -C "%SSH_EMAIL%"
)
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [2] GENERATE LOCALHOST SSL CERTIFICATE
REM ------------------------------------------------------------
:GEN_SSL
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!GENERATE LOCALHOST SSL / TLS CERTIFICATE!C_RESET!
echo  ----------------------------------------------------------------------
echo  Generates a self-signed X.509 certificate for https://localhost testing.
echo.
powershell -NoProfile -Command "$cert = New-SelfSignedCertificate -DnsName 'localhost', '127.0.0.1' -CertStoreLocation 'cert:\CurrentUser\My' -NotAfter (Get-Date).AddYears(2); Write-Host ('  [OK] Certificate Created: ' + $cert.Thumbprint) -ForegroundColor Green; Write-Host ('  Subject   : ' + $cert.Subject); Write-Host ('  Valid Thru: ' + $cert.NotAfter); Write-Host '  Stored in : CurrentUser\Personal Certificates'" 2>nul
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [3] GENERATE API KEYS
REM ------------------------------------------------------------
:GEN_API_KEY
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CRYPTOGRAPHIC API KEYS ^& PASSWORDS!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "$rng = [Security.Cryptography.RandomNumberGenerator]::Create(); $b16 = New-Object byte[] 16; $rng.GetBytes($b16); $k32 = [BitConverter]::ToString($b16).Replace('-','').ToLower(); Write-Host '  32-Character Hex Key :' -ForegroundColor Cyan; Write-Host ('  ' + $k32) -ForegroundColor White; echo ''; $b32 = New-Object byte[] 32; $rng.GetBytes($b32); $k64 = [BitConverter]::ToString($b32).Replace('-','').ToLower(); Write-Host '  64-Character Hex Key :' -ForegroundColor Cyan; Write-Host ('  ' + $k64) -ForegroundColor White; echo ''; Write-Host '  Base64 Secure Secret :' -ForegroundColor Cyan; Write-Host ('  ' + [Convert]::ToBase64String($b32)) -ForegroundColor Green" 2>nul
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [4] GENERATE JWT SECRET
REM ------------------------------------------------------------
:GEN_JWT
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!JWT HMAC-SHA256 SIGNING SECRET!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "$bytes = New-Object byte[] 64; (New-Object Security.Cryptography.RNGCryptoServiceProvider).GetBytes($bytes); $b64 = [Convert]::ToBase64String($bytes); $hex = ($bytes | ForEach-Object { '{0:x2}' -f $_ }) -join ''; Write-Host '  Base64 Encoded [512-bit]:' -ForegroundColor Cyan; Write-Host ('  ' + $b64) -ForegroundColor Green; Write-Host ''; Write-Host '  Hex Encoded [512-bit]:' -ForegroundColor Cyan; Write-Host ('  ' + $hex) -ForegroundColor White" 2>nul
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [5] COMPUTE FILE HASH
REM ------------------------------------------------------------
:COMPUTE_HASH
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!COMPUTE FILE HASHES!C_RESET!
echo  ----------------------------------------------------------------------
set "H_FILE="
if not "%~2"=="" (
    set "H_FILE=%~2"
) else (
    set /p "H_FILE=Enter or drag-and-drop file path: "
)
if not defined H_FILE (
    if not "%~1"=="" goto :EXIT
    goto :MAIN_MENU
)
set "H_FILE=%H_FILE:"=%"

if not exist "%H_FILE%" (
    echo !C_RED![FAIL] File does not exist.!C_RESET!
    if not "%~1"=="" goto :EXIT
    pause
    goto :MAIN_MENU
)

echo.
powershell -NoProfile -Command "$p = '%H_FILE%'; Write-Host ('  MD5    : ' + (Get-FileHash -Path $p -Algorithm MD5).Hash); Write-Host ('  SHA1   : ' + (Get-FileHash -Path $p -Algorithm SHA1).Hash); Write-Host ('  SHA256 : ' + (Get-FileHash -Path $p -Algorithm SHA256).Hash) -ForegroundColor Green; Write-Host ('  SHA512 : ' + (Get-FileHash -Path $p -Algorithm SHA512).Hash) -ForegroundColor Cyan" 2>nul
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [6] BASE64 TOOL
REM ------------------------------------------------------------
:BASE64_TOOL
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!BASE64 ENCODE / DECODE!C_RESET!
echo  ----------------------------------------------------------------------
echo    !C_CYAN![1]!C_RESET! Encode string to Base64
echo    !C_CYAN![2]!C_RESET! Decode Base64 string to text
echo.
set "B_ACT="
if not "%~2"=="" (
    set "B_ACT=%~2"
) else (
    set /p "B_ACT=Choose action [1-2]: "
)

if "!B_ACT!"=="1" goto :BASE64_ENC
if "!B_ACT!"=="2" goto :BASE64_DEC
goto :BASE64_DONE

:BASE64_ENC
set "B_TXT="
if not "%~3"=="" (
    set "B_TXT=%~3"
) else (
    set /p "B_TXT=Enter text to encode: "
)
if not defined B_TXT goto :BASE64_DONE
set "PS_TXT=%B_TXT%"
powershell -NoProfile -Command "$b = [Text.Encoding]::UTF8.GetBytes($env:PS_TXT); Write-Host ('  Base64: ' + [Convert]::ToBase64String($b)) -ForegroundColor Green"
goto :BASE64_DONE

:BASE64_DEC
set "B_RAW="
if not "%~3"=="" (
    set "B_RAW=%~3"
) else (
    set /p "B_RAW=Enter Base64 string: "
)
if not defined B_RAW goto :BASE64_DONE
set "PS_RAW=%B_RAW%"
powershell -NoProfile -Command "try { $bytes = [Convert]::FromBase64String($env:PS_RAW); Write-Host ('  Decoded: ' + [Text.Encoding]::UTF8.GetString($bytes)) -ForegroundColor Green } catch { Write-Host '  [ERROR] Invalid Base64 string.' -ForegroundColor Red }"
goto :BASE64_DONE

:BASE64_DONE
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [7] GENERATE UUID
REM ------------------------------------------------------------
:GEN_UUID
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!UUID / GUID v4 GENERATOR!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "for ($i=1; $i -le 5; $i++) { Write-Host ('  ' + [Guid]::NewGuid().ToString()) -ForegroundColor Green }" 2>nul
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
