@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV SYSTEM TOOLKIT
REM Developer-Focused Windows System & Diagnostics Utility
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV SYSTEM TOOLKIT
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

set "APP_NAME=DEV System Toolkit"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"
set "REPORT_FILE=%~dp0Dev-System-Report.txt"

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
echo !C_WHITE!!C_BOLD!                         DEV SYSTEM TOOLKIT!C_RESET!
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

echo  !C_WHITE!SYSTEM HARDWARE & RUNTIME!C_RESET!
echo  Computer: !C_CYAN!%COMPUTERNAME%!C_RESET!   Architecture: !C_CYAN!%PROCESSOR_ARCHITECTURE%!C_RESET!
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET!  System Information            !C_CYAN![7]!C_RESET!  PATH Viewer & Health
echo    !C_CYAN![2]!C_RESET!  CPU Information               !C_CYAN![8]!C_RESET!  Developer Processes
echo    !C_CYAN![3]!C_RESET!  Memory Information            !C_CYAN![9]!C_RESET!  Developer Ports (netstat)
echo    !C_CYAN![4]!C_RESET!  Storage Information           !C_CYAN![10]!C_RESET! Windows Terminal Tools
echo    !C_CYAN![5]!C_RESET!  Network Information           !C_CYAN![11]!C_RESET! Generate System Report
echo    !C_CYAN![6]!C_RESET!  Environment Variables         !C_RED![0]!C_RESET!  Exit
echo.

set "CHOICE="
set /p "CHOICE=Select an option [0-11]: "
if "!CHOICE!"=="1" goto :SYS_INFO
if "!CHOICE!"=="2" goto :CPU_INFO
if "!CHOICE!"=="3" goto :MEM_INFO
if "!CHOICE!"=="4" goto :STORAGE_INFO
if "!CHOICE!"=="5" goto :NET_INFO
if "!CHOICE!"=="6" goto :ENV_VARS
if "!CHOICE!"=="7" goto :PATH_VIEWER
if "!CHOICE!"=="8" goto :DEV_PROCESSES
if "!CHOICE!"=="9" goto :DEV_PORTS
if "!CHOICE!"=="10" goto :WT_TOOLS
if "!CHOICE!"=="11" goto :SYS_REPORT
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 11.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] SYSTEM INFORMATION
REM ------------------------------------------------------------
:SYS_INFO
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!WINDOWS OPERATING SYSTEM OVERVIEW!C_RESET!
echo  ----------------------------------------------------------------------
cmd /c ver
echo.
powershell -NoProfile -Command "
$os = Get-CimInstance Win32_OperatingSystem;
$cs = Get-CimInstance Win32_ComputerSystem;
$uptime = (Get-Date) - $os.LastBootUpTime;
Write-Host ('  OS Edition      : ' + $os.Caption);
Write-Host ('  OS Version      : ' + $os.Version + ' (Build ' + $os.BuildNumber + ')');
Write-Host ('  System Model    : ' + $cs.Manufacturer + ' ' + $cs.Model);
Write-Host ('  System Type     : ' + $cs.SystemType);
Write-Host ('  System Uptime   : ' + [int]$uptime.TotalDays + ' days, ' + $uptime.Hours + ' hours, ' + $uptime.Minutes + ' mins');
Write-Host ('  Registered User : ' + $os.RegisteredUser);
" 2>nul
echo.
net session >nul 2>&1
if not errorlevel 1 (
    echo   Elevated Privileges: !C_GREEN!Yes (Administrator)!C_RESET!
) else (
    echo   Elevated Privileges: !C_CYAN!No (Standard User)!C_RESET!
)
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [2] CPU INFORMATION
REM ------------------------------------------------------------
:CPU_INFO
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!PROCESSOR (CPU) DETAILS!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1;
Write-Host ('  Model            : ' + $cpu.Name);
Write-Host ('  Cores            : ' + $cpu.NumberOfCores);
Write-Host ('  Logical Threads  : ' + $cpu.NumberOfLogicalProcessors);
Write-Host ('  Base Clock Speed : ' + $cpu.MaxClockSpeed + ' MHz');
Write-Host ('  Socket / Type    : ' + $cpu.SocketDesignation);
Write-Host ('  Virtualization   : ' + $(if ($cpu.VirtualizationFirmwareEnabled) { 'Enabled' } else { 'Disabled or Unknown' }));
" 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [3] MEMORY INFORMATION
REM ------------------------------------------------------------
:MEM_INFO
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!MEMORY (RAM) STATUS!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "
$os = Get-CimInstance Win32_OperatingSystem;
$total = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2);
$free = [math]::Round($os.FreePhysicalMemory / 1MB, 2);
$used = [math]::Round($total - $free, 2);
$pct = [math]::Round(($used / $total) * 100, 1);
Write-Host ('  Total Physical RAM : ' + $total + ' GB');
Write-Host ('  Used RAM           : ' + $used + ' GB (' + $pct + '%)');
Write-Host ('  Available Free RAM : ' + $free + ' GB');
Write-Host '';
$swapTotal = [math]::Round($os.TotalVirtualMemorySize / 1MB, 2);
$swapFree = [math]::Round($os.FreeVirtualMemory / 1MB, 2);
Write-Host ('  Total Virtual/Page : ' + $swapTotal + ' GB');
Write-Host ('  Free Virtual Memory: ' + $swapFree + ' GB');
" 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [4] STORAGE INFORMATION
REM ------------------------------------------------------------
:STORAGE_INFO
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!STORAGE DRIVES & FREE SPACE!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "
$drives = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 };
foreach ($d in $drives) {
    $totalGB = [math]::Round($d.Size / 1GB, 1);
    $freeGB = [math]::Round($d.FreeSpace / 1GB, 1);
    $usedGB = [math]::Round($totalGB - $freeGB, 1);
    $pctFree = [math]::Round(($freeGB / $totalGB) * 100, 1);
    Write-Host ('  Drive ' + $d.DeviceID + ' [' + $d.FileSystem + ']  ' + $(if ($d.VolumeName) { $d.VolumeName } else { 'Local Disk' }));
    Write-Host ('    Total: ' + $totalGB + ' GB | Used: ' + $usedGB + ' GB | Free: ' + $freeGB + ' GB (' + $pctFree + '% Free)');
}
" 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [5] NETWORK INFORMATION
REM ------------------------------------------------------------
:NET_INFO
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!NETWORK ADAPTERS & IP CONFIGURATION!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "
$adapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true };
foreach ($a in $adapters) {
    Write-Host ('  Adapter     : ' + $a.Description) -ForegroundColor Cyan;
    Write-Host ('  IPv4 Address: ' + ($a.IPAddress -join ', '));
    Write-Host ('  Gateway     : ' + ($a.DefaultIPGateway -join ', '));
    Write-Host ('  DNS Servers : ' + ($a.DNSServerSearchOrder -join ', '));
    Write-Host '';
}
$ping = Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet -ErrorAction SilentlyContinue;
if ($ping) {
    Write-Host '  Internet Connectivity : [ONLINE]' -ForegroundColor Green;
} else {
    Write-Host '  Internet Connectivity : [OFFLINE / UNREACHABLE]' -ForegroundColor Red;
}
" 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [6] ENVIRONMENT VARIABLES
REM ------------------------------------------------------------
:ENV_VARS
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!ENVIRONMENT VARIABLES INSPECTOR!C_RESET!
echo  ----------------------------------------------------------------------
echo  Filter variable name [Press Enter to show standard dev variables]:
set "VAR_QUERY="
set /p "VAR_QUERY=Filter: "

if defined VAR_QUERY (
    set | findstr /I "%VAR_QUERY%"
) else (
    echo.
    echo  Standard Developer Variables:
    for %%V in (COMPUTERNAME USERPROFILE OS PROCESSOR_ARCHITECTURE JAVA_HOME PYTHONPATH NODE_PATH GOPATH CARGO_HOME DOCKER_HOST ComSpec) do (
        if defined %%V (
            echo   !C_GREEN!%%V!C_RESET! = !%%V!
        ) else (
            echo   !C_GRAY!%%V!C_RESET! = ^<not defined^>
        )
    )
)
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [7] PATH VIEWER
REM ------------------------------------------------------------
:PATH_VIEWER
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!PATH VIEWER & INTEGRITY CHECK!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "
$entries = $env:Path -split ';' | Where-Object { $_ -match '\S' };
$idx = 1;
foreach ($entry in $entries) {
    $clean = $entry.Trim('\"').Trim();
    if (Test-Path -LiteralPath $clean) {
        Write-Host ('  [{0:D2}] [OK]    {1}' -f $idx, $clean) -ForegroundColor Green;
    } else {
        Write-Host ('  [{0:D2}] [MISS]  {1}' -f $idx, $clean) -ForegroundColor Yellow;
    }
    $idx++;
}
" 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [8] DEVELOPER PROCESSES
REM ------------------------------------------------------------
:DEV_PROCESSES
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!ACTIVE DEVELOPER PROCESSES!C_RESET!
echo  ----------------------------------------------------------------------
powershell -NoProfile -Command "
$devProcs = @('node','python','py','java','code','git','docker','mongod','postgres','mysqld','dotnet','cargo','rustc','pwsh','WindowsTerminal');
$found = Get-Process -ErrorAction SilentlyContinue | Where-Object { $devProcs -contains $_.ProcessName };
if ($found) {
    $found | Select-Object Id, ProcessName, @{Name='WorkingSetMB';Expression={[math]::Round($_.WorkingSet64/1MB,1)}}, Path | Format-Table -AutoSize;
} else {
    Write-Host '  No standard developer processes currently active.' -ForegroundColor Gray;
}
" 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [9] DEVELOPER PORTS
REM ------------------------------------------------------------
:DEV_PORTS
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!COMMON DEVELOPER LISTENING PORTS!C_RESET!
echo  ----------------------------------------------------------------------
echo  Scanning 3000, 3001, 4200, 5000, 5173, 8000, 8080, 8443, 9000, 5432, 27017, 3306, 6379...
echo.
powershell -NoProfile -Command "
$ports = @(3000, 3001, 4200, 5000, 5173, 8000, 8080, 8443, 9000, 27017, 5432, 3306, 6379, 1433);
$lines = netstat -ano | Where-Object { $_ -match 'LISTENING' };
$detected = 0;
foreach ($p in $ports) {
    $match = $lines | Where-Object { $_ -match (':0*' + $p + '\s+') };
    if ($match) {
        $detected++;
        foreach ($m in $match) {
            $tokens = $m.Trim() -split '\s+';
            $pidVal = $tokens[-1];
            $procName = 'Unknown';
            try { $procName = (Get-Process -Id $pidVal -ErrorAction SilentlyContinue).ProcessName } catch {}
            Write-Host ('  Port ' + $p + ' [LISTENING] -> PID: ' + $pidVal + ' (' + $procName + ')') -ForegroundColor Green;
        }
    }
}
if ($detected -eq 0) {
    Write-Host '  No developer server ports currently listening.' -ForegroundColor Gray;
}
" 2>nul
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [10] WINDOWS TERMINAL TOOLS
REM ------------------------------------------------------------
:WT_TOOLS
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!WINDOWS TERMINAL & SYSTEM UTILITIES!C_RESET!
echo  ----------------------------------------------------------------------
echo    !C_CYAN![1]!C_RESET! Flush DNS Cache (ipconfig /flushdns)
echo    !C_CYAN![2]!C_RESET! Check WSL Linux Distributions (wsl -l -v)
echo    !C_CYAN![3]!C_RESET! Check PowerShell Execution Policy
echo    !C_CYAN![4]!C_RESET! Open Elevated Windows Terminal
echo    !C_RED![0]!C_RESET! Back to Menu
echo.
set "WT_ACT="
set /p "WT_ACT=Choose action [0-4]: "
if "!WT_ACT!"=="1" (
    echo.
    ipconfig /flushdns
)
if "!WT_ACT!"=="2" (
    echo.
    where wsl >nul 2>&1
    if not errorlevel 1 (
        wsl -l -v
    ) else (
        echo [INFO] WSL is not enabled on this system.
    )
)
if "!WT_ACT!"=="3" (
    echo.
    powershell -NoProfile -Command "Get-ExecutionPolicy -List"
)
if "!WT_ACT!"=="4" (
    powershell -NoProfile -Command "Start-Process wt.exe -Verb RunAs" 2>nul
    if errorlevel 1 (
        powershell -NoProfile -Command "Start-Process cmd.exe -Verb RunAs" 2>nul
    )
)
echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [11] GENERATE SYSTEM REPORT
REM ------------------------------------------------------------
:SYS_REPORT
cls
call :HEADER
echo  Writing comprehensive system report to file...

> "%REPORT_FILE%" echo ============================================================
>>"%REPORT_FILE%" echo DEV TOOLS SUITE :: DEV SYSTEM REPORT
>>"%REPORT_FILE%" echo Provider: %APP_PROVIDER%
>>"%REPORT_FILE%" echo Date: %date% %time%
>>"%REPORT_FILE%" echo Computer: %COMPUTERNAME%
>>"%REPORT_FILE%" echo Architecture: %PROCESSOR_ARCHITECTURE%
>>"%REPORT_FILE%" echo ============================================================
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo SYSTEM SUMMARY:
cmd /c ver >>"%REPORT_FILE%"
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo CPU & HARDWARE:
powershell -NoProfile -Command "(Get-CimInstance Win32_Processor | Select-Object -First 1).Name" >>"%REPORT_FILE%" 2>nul
powershell -NoProfile -Command "$m=(Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB; 'RAM: {0:N1} GB' -f $m" >>"%REPORT_FILE%" 2>nul
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo STORAGE VOLUMES:
powershell -NoProfile -Command "Get-CimInstance Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | ForEach-Object { '{0} {1:N1} GB Total, {2:N1} GB Free' -f $_.DeviceID, ($_.Size/1GB), ($_.FreeSpace/1GB) }" >>"%REPORT_FILE%" 2>nul
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo PATH ENTRIES:
>>"%REPORT_FILE%" echo %PATH%
>>"%REPORT_FILE%" echo.
>>"%REPORT_FILE%" echo ============================================================

echo.
echo  !C_GREEN![OK]!C_RESET! System report successfully saved to:
echo  !C_CYAN!%REPORT_FILE%!C_RESET!
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
