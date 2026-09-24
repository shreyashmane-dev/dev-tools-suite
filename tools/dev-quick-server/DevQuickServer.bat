@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV QUICK SERVER
REM Instant Developer Static Web & HTTP Testing Server
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV QUICK SERVER
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

set "APP_NAME=DEV Quick Server"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"

set "SERVE_DIR=%CD%"
set "SERVE_PORT=8000"

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
echo !C_WHITE!!C_BOLD!                           DEV QUICK SERVER!C_RESET!
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

echo  !C_WHITE!CURRENT SERVER CONFIGURATION!C_RESET!
echo  Directory : !C_CYAN!%SERVE_DIR%!C_RESET!
echo  Port      : !C_CYAN!%SERVE_PORT%!C_RESET!
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET!  Start HTTP Server Now
echo    !C_CYAN![2]!C_RESET!  Change Serving Directory
echo    !C_CYAN![3]!C_RESET!  Change Port (Default: 8000)
echo    !C_CYAN![4]!C_RESET!  Show Local & LAN Access IP Addresses
echo    !C_CYAN![5]!C_RESET!  Check / Terminate Process on Port (Port Unblocker)
echo    !C_RED![0]!C_RESET!  Exit
echo.

set "CHOICE="
set /p "CHOICE=Select an option [0-5]: "
if "!CHOICE!"=="1" goto :START_SERVER
if "!CHOICE!"=="2" goto :CHANGE_DIR
if "!CHOICE!"=="3" goto :CHANGE_PORT
if "!CHOICE!"=="4" goto :SHOW_IPS
if "!CHOICE!"=="5" goto :UNBLOCK_PORT
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 5.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] START SERVER
REM ------------------------------------------------------------
:START_SERVER
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!STARTING DEVELOPER HTTP SERVER!C_RESET!
echo  ----------------------------------------------------------------------
echo  Serving Directory : !C_CYAN!%SERVE_DIR%!C_RESET!
echo  Listening Port    : !C_CYAN!%SERVE_PORT%!C_RESET!
echo.
echo  Local URL: !C_GREEN!http://localhost:%SERVE_PORT%!C_RESET!
echo.

REM Launch browser in background
start "" "http://localhost:%SERVE_PORT%"

REM Prefer Python if available, else built-in .NET HttpListener
where python >nul 2>&1
if not errorlevel 1 (
    echo  Running via Python 3 http.server...
    echo  Press Ctrl+C to stop the server.
    echo.
    python -m http.server %SERVE_PORT% --directory "%SERVE_DIR%"
    goto :MAIN_MENU
)

REM Fallback to native PowerShell HttpListener (zero dependencies required!)
echo  Running via native Windows .NET HttpListener...
echo  Press Ctrl+C to stop the server.
echo.
powershell -NoProfile -Command "
$port = %SERVE_PORT%;
$dir = '%SERVE_DIR%';
$listener = New-Object System.Net.HttpListener;
$listener.Prefixes.Add('http://localhost:' + $port + '/');
$listener.Prefixes.Add('http://127.0.0.1:' + $port + '/');
try {
    $listener.Start();
    Write-Host ('  Server active at http://localhost:' + $port) -ForegroundColor Green;
    while ($listener.IsListening) {
        $context = $listener.GetContext();
        $req = $context.Request;
        $res = $context.Response;
        $localPath = Join-Path $dir $req.Url.LocalPath.TrimStart('/');
        if (Test-Path -LiteralPath $localPath -PathType Container) {
            $localPath = Join-Path $localPath 'index.html';
        }
        if (Test-Path -LiteralPath $localPath -PathType Leaf) {
            $bytes = [IO.File]::ReadAllBytes($localPath);
            $res.ContentType = 'text/html';
            if ($localPath.EndsWith('.css')) { $res.ContentType = 'text/css'; }
            if ($localPath.EndsWith('.js')) { $res.ContentType = 'application/javascript'; }
            if ($localPath.EndsWith('.json')) { $res.ContentType = 'application/json'; }
            $res.ContentLength64 = $bytes.Length;
            $res.OutputStream.Write($bytes, 0, $bytes.Length);
        } else {
            $res.StatusCode = 404;
            $msg = [Text.Encoding]::UTF8.GetBytes('<h1>404 Not Found</h1>');
            $res.OutputStream.Write($msg, 0, $msg.Length);
        }
        $res.Close();
    }
} finally {
    $listener.Stop();
}
"
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [2] CHANGE DIRECTORY
REM ------------------------------------------------------------
:CHANGE_DIR
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CHANGE SERVING DIRECTORY!C_RESET!
echo  ----------------------------------------------------------------------
echo  Current: %SERVE_DIR%
echo.
set "NEW_DIR="
set /p "NEW_DIR=Enter directory path [Enter to keep current]: "
if defined NEW_DIR (
    set "NEW_DIR=%NEW_DIR:"=%"
    if exist "!NEW_DIR!" (
        set "SERVE_DIR=!NEW_DIR!"
        echo !C_GREEN![OK] Serving directory updated.!C_RESET!
    ) else (
        echo !C_RED![FAIL] Directory does not exist.!C_RESET!
    )
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [3] CHANGE PORT
REM ------------------------------------------------------------
:CHANGE_PORT
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CHANGE SERVER PORT!C_RESET!
echo  ----------------------------------------------------------------------
echo  Current Port: %SERVE_PORT%
echo.
set "NEW_PORT="
set /p "NEW_PORT=Enter port [e.g. 3000, 5000, 8080]: "
if defined NEW_PORT (
    set "SERVE_PORT=%NEW_PORT%"
    echo !C_GREEN![OK] Port updated to %SERVE_PORT%.!C_RESET!
)
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [4] SHOW LOCAL & LAN IPS
REM ------------------------------------------------------------
:SHOW_IPS
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!LOCAL & NETWORK ACCESS URLS!C_RESET!
echo  ----------------------------------------------------------------------
echo  Loopback URL : !C_GREEN!http://localhost:%SERVE_PORT%!C_RESET!
echo  Localhost IP : !C_GREEN!http://127.0.0.1:%SERVE_PORT%!C_RESET!
echo.
echo  LAN URLs (Accessible from phones, tablets, or other PCs on same Wi-Fi):
powershell -NoProfile -Command "
$ips = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true };
foreach ($adapter in $ips) {
    foreach ($ip in $adapter.IPAddress) {
        if ($ip -match '^\d+\.\d+\.\d+\.\d+$' -and $ip -ne '127.0.0.1') {
            Write-Host ('  http://' + $ip + ':%SERVE_PORT% (' + $adapter.Description + ')') -ForegroundColor Cyan;
        }
    }
}
" 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [5] UNBLOCK PORT
REM ------------------------------------------------------------
:UNBLOCK_PORT
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!PORT UNBLOCKER & PROCESS TERMINATOR!C_RESET!
echo  ----------------------------------------------------------------------
set "CHECK_P="
set /p "CHECK_P=Enter port to inspect [Default: %SERVE_PORT%]: "
if not defined CHECK_P set "CHECK_P=%SERVE_PORT%"

echo.
powershell -NoProfile -Command "
$p = %CHECK_P%;
$match = netstat -ano | Where-Object { $_ -match (':0*' + $p + '\s+.*LISTENING') };
if ($match) {
    foreach ($m in $match) {
        $tokens = $m.Trim() -split '\s+';
        $pidVal = $tokens[-1];
        $proc = Get-Process -Id $pidVal -ErrorAction SilentlyContinue;
        $name = if ($proc) { $proc.ProcessName } else { 'Unknown' };
        Write-Host ('  Port ' + $p + ' is in use by PID: ' + $pidVal + ' (' + $name + ')') -ForegroundColor Yellow;
        $ans = (Read-Host '  Kill this process? [Y/N]').Trim();
        if ($ans -eq 'Y' -or $ans -eq 'y') {
            Stop-Process -Id $pidVal -Force -ErrorAction SilentlyContinue;
            Write-Host '  [OK] Process terminated.' -ForegroundColor Green;
        }
    }
} else {
    Write-Host ('  Port ' + $p + ' is free and available!') -ForegroundColor Green;
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
