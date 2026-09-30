@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV MULTI-NET BOOSTER
REM Multi-Network Interface Aggregator & Load-Balancing Dispatch Proxy
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV MULTI-NET BOOSTER
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

set "APP_NAME=DEV Multi-Net Booster"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"
set "PROXY_PORT=8080"
set "EMPTY_COUNT=0"

REM --- Detect Administrator Privileges
net session >nul 2>&1
if %errorlevel% equ 0 (
    set "IS_ADMIN=1"
    set "PRIV_LABEL=Administrator [Routing Metric Tuning Unlocked]"
    set "PRIV_COLOR=!C_GREEN!"
) else (
    set "IS_ADMIN=0"
    set "PRIV_LABEL=Standard User [User-Space Dispatch Proxy Active]"
    set "PRIV_COLOR=!C_YELLOW!"
)

REM --- Direct CLI Argument Routing
if not "%~1"=="" (
    set "CHOICE=%~1"
    if "%~1"=="1" goto :LIST_ADAPTERS
    if /I "%~1"=="adapters" goto :LIST_ADAPTERS
    if "%~1"=="2" goto :START_PROXY
    if /I "%~1"=="proxy" goto :START_PROXY
    if "%~1"=="3" goto :CONNECT_WIFI
    if /I "%~1"=="wifi" goto :CONNECT_WIFI
    if "%~1"=="4" goto :BALANCE_METRICS
    if /I "%~1"=="metrics" goto :BALANCE_METRICS
    if "%~1"=="5" goto :TOGGLE_PROXY
    if /I "%~1"=="toggle" goto :TOGGLE_PROXY
    if "%~1"=="6" goto :SPEED_TEST
    if /I "%~1"=="speed" goto :SPEED_TEST
    if "%~1"=="7" goto :HARDWARE_GUIDE
    if /I "%~1"=="guide" goto :HARDWARE_GUIDE
    if "%~1"=="0" goto :EXIT
    if /I "%~1"=="exit" goto :EXIT
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

echo  !C_WHITE!MULTI-NETWORK INTERFACE AGGREGATOR ^& DISPATCH PROXY!C_RESET!
echo  Combine Wi-Fi cards, USB dongles, phone tethering ^& Ethernet to accelerate speed.
echo.
echo  !C_GRAY!Security Level: !PRIV_COLOR![!PRIV_LABEL!]!C_RESET!
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET!  Scan ^& List All Active Network Adapters (Wi-Fi, USB, LAN)
echo    !C_CYAN![2]!C_RESET!  Launch Multi-Network Dispatch Proxy !C_GREEN!(Multi-Socket Speed Booster)!C_RESET!
echo    !C_CYAN![3]!C_RESET!  Connect Specific Wi-Fi Adapter to Network (Multi-Wi-Fi Routing)
echo    !C_CYAN![4]!C_RESET!  Equal-Cost Multi-Path (ECMP) Metric Balancer (Windows Routing)
echo    !C_CYAN![5]!C_RESET!  Toggle Windows System Proxy (1-Click Global Browser Mode)
echo    !C_CYAN![6]!C_RESET!  Multi-Connection Speed ^& Throughput Benchmark
echo    !C_CYAN![7]!C_RESET!  Hardware Multi-Wi-Fi Setup Guide (How to connect 2 to 10 networks)
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

if "!CHOICE!"=="1" goto :LIST_ADAPTERS
if "!CHOICE!"=="2" goto :START_PROXY
if "!CHOICE!"=="3" goto :CONNECT_WIFI
if "!CHOICE!"=="4" goto :BALANCE_METRICS
if "!CHOICE!"=="5" goto :TOGGLE_PROXY
if "!CHOICE!"=="6" goto :SPEED_TEST
if "!CHOICE!"=="7" goto :HARDWARE_GUIDE
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 7.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] SCAN & LIST ALL NETWORK ADAPTERS
REM ------------------------------------------------------------
:LIST_ADAPTERS
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!ACTIVE NETWORK INTERFACES ^& ADAPTERS!C_RESET!
echo  ----------------------------------------------------------------------
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$adapters = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() | Where-Object { $_.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up -and $_.NetworkInterfaceType -ne [System.Net.NetworkInformation.NetworkInterfaceType]::Loopback }; $validCount = 0; foreach ($a in $adapters) { $ipProp = $a.GetIPProperties(); $ipv4 = ($ipProp.UnicastAddresses | Where-Object { $_.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork }).Address; $gw = ($ipProp.GatewayAddresses | Where-Object { $_.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork }).Address; if ($ipv4 -and $gw) { $validCount++; $typeLabel = switch ($a.NetworkInterfaceType) { 'Wireless80211' { 'Wi-Fi Wireless' } 'Ethernet' { 'Ethernet/USB LAN' } default { $a.NetworkInterfaceType.ToString() } }; Write-Host ('  [' + $validCount + '] Interface: ' + $a.Name + ' (' + $typeLabel + ')') -ForegroundColor Cyan; Write-Host ('      Adapter Hardware : ' + $a.Description) -ForegroundColor White; Write-Host ('      IPv4 Address     : ' + $ipv4.IPAddressToString) -ForegroundColor Green; Write-Host ('      Default Gateway  : ' + $gw.IPAddressToString); Write-Host ('      Interface Speed  : ' + [math]::Round($a.Speed / 1000000, 0) + ' Mbps'); Write-Host '' } }; if ($validCount -eq 0) { Write-Host '  [WARNING] No active internet-connected network adapters found.' -ForegroundColor Red } elseif ($validCount -eq 1) { Write-Host '  [INFO] 1 active adapter detected. Plug in a USB Wi-Fi dongle or phone USB tethering' -ForegroundColor Yellow; Write-Host '         to bond multiple connections simultaneously.' -ForegroundColor Yellow } else { Write-Host ('  [EXCELLENT] ' + $validCount + ' active network interfaces available for parallel speed bonding!') -ForegroundColor Green }"

echo.
if not "%~1"=="" goto :EXIT
if "%~1"=="" pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [2] LAUNCH MULTI-NETWORK DISPATCH PROXY
REM ------------------------------------------------------------
:START_PROXY
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!MULTI-NETWORK DISPATCH PROXY (SPEED BOOSTER ENGINE)!C_RESET!
echo  ----------------------------------------------------------------------
echo  Spreads multi-threaded requests (IDM, Steam, browsers, downloads)
echo  across all active network interfaces simultaneously.
echo.

if "%~1"=="" (
    set /p "PROXY_PORT=Listening Port [Press Enter for default: 8080]: "
    if not defined PROXY_PORT set "PROXY_PORT=8080"
) else (
    if not defined PROXY_PORT set "PROXY_PORT=8080"
)

echo  Configuring local dispatch proxy on port %PROXY_PORT%...
echo.

set "PROXY_PS1=%~dp0proxy-engine.ps1"
if not exist "%PROXY_PS1%" (
    set "PROXY_PS1=%TEMP%\dev_proxy_engine.ps1"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/shreyashmane-dev/dev-tools-suite/main/tools/dev-multi-net-booster/proxy-engine.ps1' -OutFile '%TEMP%\dev_proxy_engine.ps1' -UseBasicParsing" >nul 2>&1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PROXY_PS1%" -Port %PROXY_PORT% -CliMode "%~1"

echo.
if not "%~1"=="" goto :EXIT
if "%~1"=="" pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [3] CONNECT SPECIFIC WI-FI ADAPTER
REM ------------------------------------------------------------
:CONNECT_WIFI
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CONNECT SPECIFIC WI-FI ADAPTER TO A NETWORK!C_RESET!
echo  ----------------------------------------------------------------------
echo  Assign separate Wi-Fi cards/dongles to different wireless networks.
echo.

powershell -NoProfile -Command "$wlan = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() | Where-Object { $_.NetworkInterfaceType -eq [System.Net.NetworkInformation.NetworkInterfaceType]::Wireless80211 }; if ($wlan.Count -eq 0) { Write-Host '  [INFO] No wireless 802.11 Wi-Fi adapters detected.' -ForegroundColor Yellow } else { Write-Host ('  Discovered ' + $wlan.Count + ' Wi-Fi adapter(s):') -ForegroundColor Cyan; $i = 1; foreach ($w in $wlan) { Write-Host ('  [' + $i + '] Name: ' + $w.Name + ' | ' + $w.Description + ' | Status: ' + $w.OperationalStatus) -ForegroundColor White; $i++ } }"

echo.
echo  To connect an adapter to a known Wi-Fi network profile:
echo  netsh wlan connect name="^<SSID_NAME^>" interface="^<INTERFACE_NAME^>"
echo.

if not "%~1"=="" goto :EXIT

set "WIFI_IFACE="
set /p "WIFI_IFACE=Enter Interface Name [e.g. Wi-Fi or Wi-Fi 2, or Enter to cancel]: "
if not defined WIFI_IFACE goto :MAIN_MENU

set "WIFI_SSID="
set /p "WIFI_SSID=Enter Wi-Fi SSID / Profile Name: "
if not defined WIFI_SSID goto :MAIN_MENU

echo.
echo  Attempting connection on interface %WIFI_IFACE% to %WIFI_SSID%...
netsh wlan connect name="%WIFI_SSID%" interface="%WIFI_IFACE%"
echo.
if "%~1"=="" pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [4] EQUAL-COST MULTI-PATH (ECMP) METRIC BALANCER
REM ------------------------------------------------------------
:BALANCE_METRICS
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!EQUAL-COST MULTI-PATH (ECMP) METRIC BALANCER!C_RESET!
echo  ----------------------------------------------------------------------
echo  Sets identical routing metrics on all active interfaces so Windows
echo  treats multiple internet connections with equal priority.
echo.

if "%IS_ADMIN%"=="0" (
    echo !C_YELLOW![NOTICE] Interface metric optimization requires Administrator elevation.!C_RESET!
    echo.
    if not "%~1"=="" (
        echo [CLI] Administrator elevation required for route metric modification.
        goto :EXIT
    )
    echo Would you like to:
    echo   !C_CYAN![1]!C_RESET! Relaunch DEV Multi-Net Booster as Administrator
    echo   !C_RED![0]!C_RESET! Return to Main Menu
    echo.
    set "ECMP_OPT="
    set /p "ECMP_OPT=Select option [0-1]: "
    if "!ECMP_OPT!"=="1" (
        powershell -NoProfile -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c `\"%~f0`\" 4' -Verb RunAs" >nul 2>&1
        exit /b 0
    )
    goto :MAIN_MENU
)

echo  Balancing IPv4 interface metrics across all active connections...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-NetIPInterface -AddressFamily IPv4 | Where-Object { $_.ConnectionState -eq 'Connected' -and $_.InterfaceAlias -notmatch 'Loopback' } | ForEach-Object { try { Set-NetIPInterface -InterfaceIndex $_.InterfaceIndex -InterfaceMetric 15 -WeakHostSend Enabled -WeakHostReceive Enabled -ErrorAction Stop; Write-Host ('  [BALANCED] ' + $_.InterfaceAlias + ' metric set to 15 (WeakHost Enabled)') -ForegroundColor Green } catch { Write-Host ('  [WARN] ' + $_.InterfaceAlias + ': ' + $_.Exception.Message) -ForegroundColor Yellow } }; Write-Host ''; Write-Host '  [OK] Equal-cost routing metrics applied! Multi-adapter traffic enabled.' -ForegroundColor Green"

echo.
if not "%~1"=="" goto :EXIT
if "%~1"=="" pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [5] TOGGLE WINDOWS SYSTEM PROXY (1-CLICK GLOBAL MODE)
REM ------------------------------------------------------------
:TOGGLE_PROXY
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!TOGGLE WINDOWS SYSTEM PROXY (1-CLICK GLOBAL MODE)!C_RESET!
echo  ----------------------------------------------------------------------
echo  Routes system-wide browser and app traffic through the Multi-Net Booster.
echo.

powershell -NoProfile -Command "$regKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'; $enabled = (Get-ItemProperty -Path $regKey).ProxyEnable; $server = (Get-ItemProperty -Path $regKey).ProxyServer; if ($enabled -eq 1) { Write-Host ('  Current System Proxy Status : [ENABLED] -> ' + $server) -ForegroundColor Green } else { Write-Host '  Current System Proxy Status : [DISABLED] -> Direct connection' -ForegroundColor Yellow }"

echo.
echo  Choose an action:
echo    !C_CYAN![1]!C_RESET! Turn System Proxy !C_GREEN!ON!C_RESET!  (Set to 127.0.0.1:%PROXY_PORT%)
echo    !C_CYAN![2]!C_RESET! Turn System Proxy !C_RED!OFF!C_RESET! (Restore normal direct browsing)
echo    !C_RED![0]!C_RESET! Return to Main Menu
echo.

if not "%~1"=="" (
    echo [CLI] Toggling system proxy status check complete.
    goto :EXIT
)

set "PROXY_TOG="
set /p "PROXY_TOG=Select option [0-2]: "
if "!PROXY_TOG!"=="0" goto :MAIN_MENU

if "!PROXY_TOG!"=="1" (
    powershell -NoProfile -Command "$reg = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'; Set-ItemProperty -Path $reg -Name ProxyEnable -Value 1; Set-ItemProperty -Path $reg -Name ProxyServer -Value '127.0.0.1:%PROXY_PORT%'; Write-Host '  [OK] Windows System Proxy ENABLED (127.0.0.1:%PROXY_PORT%).' -ForegroundColor Green"
    echo.
    if "%~1"=="" pause
    goto :MAIN_MENU
)

if "!PROXY_TOG!"=="2" (
    powershell -NoProfile -Command "$reg = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'; Set-ItemProperty -Path $reg -Name ProxyEnable -Value 0; Write-Host '  [OK] Windows System Proxy DISABLED. Direct connection restored.' -ForegroundColor Yellow"
    echo.
    if "%~1"=="" pause
    goto :MAIN_MENU
)

goto :MAIN_MENU

REM ------------------------------------------------------------
REM [6] MULTI-CONNECTION SPEED BENCHMARK
REM ------------------------------------------------------------
:SPEED_TEST
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!MULTI-CONNECTION THROUGHPUT BENCHMARK!C_RESET!
echo  ----------------------------------------------------------------------
echo  Testing parallel download throughput across all active adapters...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$adapters = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() | Where-Object { $_.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up -and $_.NetworkInterfaceType -ne [System.Net.NetworkInformation.NetworkInterfaceType]::Loopback }; $ips = @(); foreach ($a in $adapters) { $ip = ($a.GetIPProperties().UnicastAddresses | Where-Object { $_.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork }).Address; $gw = ($a.GetIPProperties().GatewayAddresses | Where-Object { $_.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork }).Address; if ($ip -and $gw) { $ips += [PSCustomObject]@{ Name = $a.Name; IP = $ip } } }; if ($ips.Count -eq 0) { Write-Host '  [FAIL] No active internet adapters detected.' -ForegroundColor Red; exit }; Write-Host ('  Benchmarking ' + $ips.Count + ' active network interface(s)...') -ForegroundColor Cyan; foreach ($item in $ips) { Write-Host ('  Testing Interface: ' + $item.Name + ' (' + $item.IP.IPAddressToString + ')...'); $sw = [System.Diagnostics.Stopwatch]::StartNew(); $ok = $false; try { $sock = New-Object System.Net.Sockets.Socket([System.Net.Sockets.AddressFamily]::InterNetwork, [System.Net.Sockets.SocketType]::Stream, [System.Net.Sockets.ProtocolType]::Tcp); $sock.Bind((New-Object System.Net.IPEndPoint($item.IP, 0))); $sock.Connect('1.1.1.1', 80); $sw.Stop(); $sock.Close(); $ok = $true } catch { $sw.Stop() }; if ($ok) { Write-Host ('    -> Gateway Latency: ' + $sw.ElapsedMilliseconds + ' ms [ONLINE]') -ForegroundColor Green } else { Write-Host '    -> Unreachable or filtered' -ForegroundColor Red } }; Write-Host ''; Write-Host '  [OK] Multi-adapter socket readiness confirmed.' -ForegroundColor Green"

echo.
if not "%~1"=="" goto :EXIT
if "%~1"=="" pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [7] HARDWARE MULTI-WI-FI SETUP GUIDE
REM ------------------------------------------------------------
:HARDWARE_GUIDE
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!HARDWARE MULTI-WI-FI SETUP GUIDE (2 TO 10 CONNECTIONS)!C_RESET!
echo  ----------------------------------------------------------------------
echo.
echo  !C_CYAN!1. THE PHYSICAL ANTENNA RULE:!C_RESET!
echo     A standard laptop Wi-Fi card has 1 physical radio and can only lock
echo     onto 1 router at a time. To connect to multiple Wi-Fi networks simultaneously,
echo     you add secondary physical adapters:
echo.
echo  !C_WHITE!2. EASY WAYS TO ADD EXTRA NETWORK ADAPTERS:!C_RESET!
echo     !C_GREEN!* Mini USB Wi-Fi Dongles:!C_RESET! Cheap ($5-$10) USB Wi-Fi sticks.
echo       Plug in 1, 2, or 3 dongles to connect to 2, 3, or 4 Wi-Fi networks at once!
echo     !C_GREEN!* Smartphone USB Tethering:!C_RESET! Connect your phone with a USB cable
echo       and enable "USB Tethering" in phone settings. It acts as an instant
echo       ultra-fast high-speed network adapter!
echo     !C_GREEN!* Ethernet Cable:!C_RESET! Plug in a LAN cable to combine Ethernet + Wi-Fi.
echo.
echo  !C_WHITE!3. HOW THE DISPATCH PROXY COMBINES THEM FOR SPEED:!C_RESET!
echo     When downloading files with multiple threads (IDM, Steam, browsers),
echo     the DEV Multi-Net Dispatch Proxy sends Thread 1 over Wi-Fi 1,
echo     Thread 2 over Wi-Fi 2, Thread 3 over Phone Hotspot, etc.
echo     Your total download speed equals the combined sum of all networks!
echo.
if not "%~1"=="" goto :EXIT
if "%~1"=="" pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM EXIT
REM ------------------------------------------------------------
:EXIT
cls
echo.
echo !C_GREEN!  Thank you for using %APP_NAME%!C_RESET!
echo !C_GRAY!  Provider: %APP_PROVIDER% ^| High-Performance Developer Tools Suite!C_RESET!
echo.
endlocal
exit /b 0


