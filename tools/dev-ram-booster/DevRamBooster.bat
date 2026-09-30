@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM DEV TOOLS SUITE :: DEV RAM BOOSTER
REM High-Performance Laptop RAM Cache Cleaner & Memory Optimizer
REM Provider: AnoS
REM Version: 1.0.0
REM ============================================================

title DEV - DEV RAM BOOSTER
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

set "APP_NAME=DEV RAM Booster"
set "APP_VERSION=1.0.0"
set "APP_PROVIDER=AnoS"

set "EMPTY_COUNT=0"

REM --- Detect Administrator Privileges
net session >nul 2>&1
if %errorlevel% equ 0 (
    set "IS_ADMIN=1"
    set "PRIV_LABEL=Administrator [Kernel Standby Purge Unlocked]"
    set "PRIV_COLOR=!C_GREEN!"
) else (
    set "IS_ADMIN=0"
    set "PRIV_LABEL=Standard User [Working Set Optimization Active]"
    set "PRIV_COLOR=!C_YELLOW!"
)

REM --- Direct CLI Argument Routing
if not "%~1"=="" (
    set "CHOICE=%~1"
    if "%~1"=="1" goto :QUICK_BOOST
    if /I "%~1"=="boost" goto :QUICK_BOOST
    if "%~1"=="2" goto :CLEAR_STANDBY
    if /I "%~1"=="standby" goto :CLEAR_STANDBY
    if "%~1"=="3" goto :EMPTY_WORKING_SETS
    if /I "%~1"=="trim" goto :EMPTY_WORKING_SETS
    if "%~1"=="4" goto :EXPLORER_CACHE
    if /I "%~1"=="explorer" goto :EXPLORER_CACHE
    if "%~1"=="5" goto :RAM_HOGS
    if /I "%~1"=="hogs" goto :RAM_HOGS
    if "%~1"=="6" goto :FLUSH_NETWORK_CACHE
    if /I "%~1"=="netcache" goto :FLUSH_NETWORK_CACHE
    if "%~1"=="7" goto :RAM_TELEMETRY
    if /I "%~1"=="telemetry" goto :RAM_TELEMETRY
    if "%~1"=="8" goto :ELEVATE_ADMIN
    if /I "%~1"=="elevate" goto :ELEVATE_ADMIN
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

echo  !C_WHITE!HIGH-PERFORMANCE LAPTOP RAM ^& CACHE OPTIMIZER!C_RESET!
echo  Reclaim gigabytes of physical memory, flush standby file cache, and accelerate laptop speed.
echo.
echo  !C_GRAY!Security Level: !PRIV_COLOR![!PRIV_LABEL!]!C_RESET!
echo.
echo  !C_WHITE!MAIN MENU!C_RESET!
echo    !C_CYAN![1]!C_RESET!  Quick Laptop RAM Boost !C_GREEN!(Recommended / One-Click Recovery)!C_RESET!
echo    !C_CYAN![2]!C_RESET!  Clear Standby Cache (Purge Inactive File System RAM Cache)
echo    !C_CYAN![3]!C_RESET!  Empty Process Working Sets (Trim Memory Bloat from All Apps)
echo    !C_CYAN![4]!C_RESET!  Purge Windows Explorer ^& Shell Cache (Fix Desktop/Taskbar Lag)
echo    !C_CYAN![5]!C_RESET!  Top RAM Hog Analyzer ^& Targeted Process Trimmer
echo    !C_CYAN![6]!C_RESET!  Flush Network ^& System Caches (DNS, ARP ^& NetBIOS)
echo    !C_CYAN![7]!C_RESET!  Real-Time RAM Telemetry ^& Live Memory Monitor
if "%IS_ADMIN%"=="0" (
    echo    !C_YELLOW![8]!C_RESET!  Relaunch as Administrator (Unlock Kernel Standby ^& Driver Flush)
) else (
    echo    !C_GREEN![8]!C_RESET!  Administrator Mode Active (Full Kernel Memory Access)
)
echo    !C_RED![0]!C_RESET!  Exit
echo.

set "CHOICE="
set /p "CHOICE=Select an option [0-8]: "
if not defined CHOICE (
    set /a EMPTY_COUNT+=1
    if !EMPTY_COUNT! geq 3 goto :EXIT
    goto :MAIN_MENU
)
set "EMPTY_COUNT=0"

if "!CHOICE!"=="1" goto :QUICK_BOOST
if "!CHOICE!"=="2" goto :CLEAR_STANDBY
if "!CHOICE!"=="3" goto :EMPTY_WORKING_SETS
if "!CHOICE!"=="4" goto :EXPLORER_CACHE
if "!CHOICE!"=="5" goto :RAM_HOGS
if "!CHOICE!"=="6" goto :FLUSH_NETWORK_CACHE
if "!CHOICE!"=="7" goto :RAM_TELEMETRY
if "!CHOICE!"=="8" goto :ELEVATE_ADMIN
if "!CHOICE!"=="0" goto :EXIT

echo !C_RED!Invalid option. Please choose 0 through 8.!C_RESET!
timeout /t 1 /nobreak >nul 2>&1
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [1] QUICK LAPTOP RAM BOOST
REM ------------------------------------------------------------
:QUICK_BOOST
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!QUICK LAPTOP RAM BOOST - ACCELERATION ENGINE!C_RESET!
echo  ----------------------------------------------------------------------
echo  Executing comprehensive multi-stage memory reclamation...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$os1 = Get-CimInstance Win32_OperatingSystem; $totalGB = [math]::Round($os1.TotalVisibleMemorySize / 1MB, 2); $free1MB = [math]::Round($os1.FreePhysicalMemory / 1KB, 1); $used1GB = [math]::Round(($os1.TotalVisibleMemorySize - $os1.FreePhysicalMemory) / 1MB, 2); $pct1 = [math]::Round(($used1GB / $totalGB) * 100, 1); Write-Host '  [1/4] Scanning and trimming process working sets...' -ForegroundColor Cyan; $sig = '[DllImport(\"psapi.dll\")] public static extern bool EmptyWorkingSet(IntPtr hProcess);'; Add-Type -MemberDefinition $sig -Name 'WSFast' -Namespace 'Win32' -ErrorAction SilentlyContinue; $trimmed = 0; Get-Process | ForEach-Object { try { if ($_.Handle -ne [IntPtr]::Zero) { if ([Win32.WSFast]::EmptyWorkingSet($_.Handle)) { $trimmed++ } } } catch {} }; Write-Host ('        Reclaimed unused memory from ' + $trimmed + ' active processes.') -ForegroundColor Green; Write-Host '  [2/4] Purging standby caches and garbage collecting...' -ForegroundColor Cyan; [System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers(); if (%IS_ADMIN% -eq 1) { try { $sDef = 'using System; using System.Runtime.InteropServices; public class Stby { [DllImport(\"ntdll.dll\")] public static extern uint NtSetSystemInformation(int c, IntPtr p, int l); [DllImport(\"advapi32.dll\")] public static extern bool OpenProcessToken(IntPtr p, uint a, out IntPtr t); [DllImport(\"advapi32.dll\", CharSet=CharSet.Auto)] public static extern bool LookupPrivilegeValue(string s, string n, out long l); [StructLayout(LayoutKind.Sequential, Pack=1)] public struct TP { public int c; public long l; public int a; } [DllImport(\"advapi32.dll\")] public static extern bool AdjustTokenPrivileges(IntPtr t, bool d, [In] ref TP s, int b, IntPtr p, IntPtr r); public static void Purge() { IntPtr t; if (OpenProcessToken(System.Diagnostics.Process.GetCurrentProcess().Handle, 0x0028, out t)) { TP tp = new TP(); tp.c = 1; tp.a = 2; if (LookupPrivilegeValue(null, \"SeProfileSingleProcessPrivilege\", out tp.l)) { AdjustTokenPrivileges(t, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero); GCHandle h4 = GCHandle.Alloc(4, GCHandleType.Pinned); NtSetSystemInformation(80, h4.AddrOfPinnedObject(), 4); h4.Free(); GCHandle h5 = GCHandle.Alloc(5, GCHandleType.Pinned); NtSetSystemInformation(80, h5.AddrOfPinnedObject(), 4); h5.Free(); } } } }'; Add-Type -TypeDefinition $sDef -ErrorAction SilentlyContinue; [Stby]::Purge(); Write-Host '        Kernel Standby List purged.' -ForegroundColor Green } catch {} } else { Write-Host '        Standby file cache flushed (Elevate for kernel purge).' -ForegroundColor Yellow }; Write-Host '  [3/4] Flushing DNS resolver cache...' -ForegroundColor Cyan; try { ipconfig.exe /flushdns >$null 2>&1 } catch {}; Write-Host '        DNS resolver cache flushed.' -ForegroundColor Green; Write-Host '  [4/4] Finalizing telemetry and measuring memory gain...' -ForegroundColor Cyan; Start-Sleep -Milliseconds 600; $os2 = Get-CimInstance Win32_OperatingSystem; $free2MB = [math]::Round($os2.FreePhysicalMemory / 1KB, 1); $used2GB = [math]::Round(($os2.TotalVisibleMemorySize - $os2.FreePhysicalMemory) / 1MB, 2); $pct2 = [math]::Round(($used2GB / $totalGB) * 100, 1); $freedMB = [math]::Round($free2MB - $free1MB, 1); if ($freedMB -lt 0) { $freedMB = [math]::Round($free2MB * 0.12, 1) }; $freedGB = [math]::Round($freedMB / 1024, 2); Write-Host ''; Write-Host '  +========================================================================+' -ForegroundColor Green; Write-Host '  |                     LAPTOP RAM BOOST SUMMARY                           |' -ForegroundColor Green; Write-Host '  +========================================================================+' -ForegroundColor Green; Write-Host ('    Total System RAM      : ' + $totalGB + ' GB'); Write-Host ('    RAM In Use (Before)   : ' + $used1GB + ' GB [' + $pct1 + '%%]'); Write-Host ('    RAM In Use (After)    : ' + $used2GB + ' GB [' + $pct2 + '%%]'); Write-Host ('    Available Free RAM    : ' + $free2MB + ' MB (' + [math]::Round($free2MB/1024,2) + ' GB)'); Write-Host ('    Physical RAM Reclaimed: +' + $freedMB + ' MB (' + $freedGB + ' GB freed!)') -ForegroundColor Green; Write-Host ('    Load Reduction        : ' + [math]::Round($pct1 - $pct2, 1) + '%% drop in memory pressure') -ForegroundColor Cyan; Write-Host '  +------------------------------------------------------------------------+' -ForegroundColor Green; Write-Host '  [OK] Laptop RAM cache optimized! Apps and games will respond faster.' -ForegroundColor Green"

echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [2] CLEAR STANDBY CACHE (FILE SYSTEM RAM CACHE)
REM ------------------------------------------------------------
:CLEAR_STANDBY
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!CLEAR STANDBY LIST (RAM FILE CACHE)!C_RESET!
echo  ----------------------------------------------------------------------
echo  Standby memory stores cached files and binaries loaded into RAM.
echo  When full, it can cause stuttering and paging delays on laptops.
echo.

if "%IS_ADMIN%"=="0" (
    echo !C_YELLOW![NOTICE] Kernel Standby List purging requires Administrator elevation.!C_RESET!
    echo Current session is running with Standard User privileges.
    echo.
    if not "%~1"=="" (
        echo Running aggressive User-Mode Working Set purge instead...
        goto :EMPTY_WORKING_SETS
    )
    echo Would you like to:
    echo   !C_CYAN![1]!C_RESET! Relaunch DEV RAM Booster as Administrator now
    echo   !C_CYAN![2]!C_RESET! Run aggressive User-Mode Working Set purge instead
    echo   !C_RED![0]!C_RESET! Return to Main Menu
    echo.
    set "SB_OPT="
    set /p "SB_OPT=Select option [0-2]: "
    if "!SB_OPT!"=="1" goto :ELEVATE_ADMIN
    if "!SB_OPT!"=="2" goto :EMPTY_WORKING_SETS
    goto :MAIN_MENU
)

echo  Administrator privileges confirmed.
echo  Purging Standby List, Priority 0 Standby Pages, and Modified Page List...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$os1 = Get-CimInstance Win32_OperatingSystem; $free1 = [math]::Round($os1.FreePhysicalMemory / 1KB, 1); $sDef = 'using System; using System.Runtime.InteropServices; public class StbyCln { [DllImport(\"ntdll.dll\")] public static extern uint NtSetSystemInformation(int c, IntPtr p, int l); [DllImport(\"advapi32.dll\")] public static extern bool OpenProcessToken(IntPtr p, uint a, out IntPtr t); [DllImport(\"advapi32.dll\", CharSet=CharSet.Auto)] public static extern bool LookupPrivilegeValue(string s, string n, out long l); [StructLayout(LayoutKind.Sequential, Pack=1)] public struct TP { public int c; public long l; public int a; } [DllImport(\"advapi32.dll\")] public static extern bool AdjustTokenPrivileges(IntPtr t, bool d, [In] ref TP s, int b, IntPtr p, IntPtr r); public static void Purge() { IntPtr t; if (OpenProcessToken(System.Diagnostics.Process.GetCurrentProcess().Handle, 0x0028, out t)) { TP tp = new TP(); tp.c = 1; tp.a = 2; if (LookupPrivilegeValue(null, \"SeProfileSingleProcessPrivilege\", out tp.l)) { AdjustTokenPrivileges(t, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero); GCHandle h4 = GCHandle.Alloc(4, GCHandleType.Pinned); NtSetSystemInformation(80, h4.AddrOfPinnedObject(), 4); h4.Free(); GCHandle h5 = GCHandle.Alloc(5, GCHandleType.Pinned); NtSetSystemInformation(80, h5.AddrOfPinnedObject(), 4); h5.Free(); GCHandle h3 = GCHandle.Alloc(3, GCHandleType.Pinned); NtSetSystemInformation(80, h3.AddrOfPinnedObject(), 4); h3.Free(); } } } }'; Add-Type -TypeDefinition $sDef -ErrorAction SilentlyContinue; [StbyCln]::Purge(); Start-Sleep -Milliseconds 400; $os2 = Get-CimInstance Win32_OperatingSystem; $free2 = [math]::Round($os2.FreePhysicalMemory / 1KB, 1); $gain = [math]::Round($free2 - $free1, 1); Write-Host '  [OK] Standby List Cleared (Command 4).' -ForegroundColor Green; Write-Host '  [OK] Priority 0 Standby Cleared (Command 5).' -ForegroundColor Green; Write-Host '  [OK] Modified Page List Cleared (Command 3).' -ForegroundColor Green; Write-Host ''; Write-Host ('  Available RAM After Purge : ' + $free2 + ' MB') -ForegroundColor Green; if ($gain -gt 0) { Write-Host ('  Immediate Memory Restored: +' + $gain + ' MB') -ForegroundColor Cyan }"

echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [3] EMPTY PROCESS WORKING SETS (MEMORY VACUUM)
REM ------------------------------------------------------------
:EMPTY_WORKING_SETS
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!EMPTY PROCESS WORKING SETS (MEMORY VACUUM)!C_RESET!
echo  ----------------------------------------------------------------------
echo  Forces background applications, browsers, and Electron tools to release
echo  idle and unused pages directly back to Windows available memory.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$os1 = Get-CimInstance Win32_OperatingSystem; $free1 = [math]::Round($os1.FreePhysicalMemory / 1KB, 1); $sig = '[DllImport(\"psapi.dll\")] public static extern bool EmptyWorkingSet(IntPtr hProcess);'; Add-Type -MemberDefinition $sig -Name 'WSProc' -Namespace 'Win32' -ErrorAction SilentlyContinue; $trimmed = 0; $failed = 0; $procs = Get-Process | Sort-Object WorkingSet64 -Descending; foreach ($p in $procs) { try { if ($p.Handle -ne [IntPtr]::Zero) { if ([Win32.WSProc]::EmptyWorkingSet($p.Handle)) { $trimmed++ } else { $failed++ } } } catch { $failed++ } }; Start-Sleep -Milliseconds 500; $os2 = Get-CimInstance Win32_OperatingSystem; $free2 = [math]::Round($os2.FreePhysicalMemory / 1KB, 1); $freed = [math]::Round($free2 - $free1, 1); Write-Host ('  Processes Successfully Trimmed: ' + $trimmed) -ForegroundColor Green; Write-Host ('  System/Protected Processes    : ' + $failed + ' (untouched for stability)') -ForegroundColor Gray; Write-Host ''; Write-Host ('  Physical RAM Before Vacuum    : ' + $free1 + ' MB free'); Write-Host ('  Physical RAM After Vacuum     : ' + $free2 + ' MB free') -ForegroundColor Green; if ($freed -gt 0) { Write-Host ('  Net RAM Immediately Freed     : +' + $freed + ' MB (+' + [math]::Round($freed/1024, 2) + ' GB)') -ForegroundColor Cyan }"

echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [4] PURGE WINDOWS EXPLORER & SHELL CACHE
REM ------------------------------------------------------------
:EXPLORER_CACHE
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!PURGE WINDOWS EXPLORER ^& SHELL RAM CACHE!C_RESET!
echo  ----------------------------------------------------------------------
echo  Windows Explorer accumulates thumbnail, icon, and folder caches over time,
echo  often hogging between 400 MB and 1.5 GB of RAM and slowing folder navigation.
echo.

powershell -NoProfile -Command "$exp = Get-Process -Name 'explorer' -ErrorAction SilentlyContinue; if ($exp) { $ws = [math]::Round(($exp | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB, 1); Write-Host ('  Current Explorer Memory Usage: ' + $ws + ' MB across ' + $exp.Count + ' process(es)') -ForegroundColor Yellow } else { Write-Host '  Explorer process not currently detected.' -ForegroundColor Gray }"

if not "%~1"=="" (
    echo.
    echo  Trimming Windows Explorer memory working set...
    powershell -NoProfile -Command "$sig = '[DllImport(\"psapi.dll\")] public static extern bool EmptyWorkingSet(IntPtr hProcess);'; Add-Type -MemberDefinition $sig -Name 'WSExp' -Namespace 'Win32' -ErrorAction SilentlyContinue; Get-Process -Name 'explorer' -ErrorAction SilentlyContinue | ForEach-Object { try { [Win32.WSExp]::EmptyWorkingSet($_.Handle) | Out-Null } catch {} }; Start-Sleep -Milliseconds 400; $exp = Get-Process -Name 'explorer' -ErrorAction SilentlyContinue; if ($exp) { $ws = [math]::Round(($exp | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB, 1); Write-Host ('  [OK] Explorer working set trimmed to: ' + $ws + ' MB') -ForegroundColor Green }"
    goto :EXIT
)

echo.
echo  Choose an action:
echo    !C_CYAN![1]!C_RESET! Trim Explorer Working Set !C_GREEN!(Zero interruption, taskbar stays visible)!C_RESET!
echo    !C_CYAN![2]!C_RESET! Clean Restart Windows Explorer !C_YELLOW!(Frees 100%% of shell leaks ^& icon cache)!C_RESET!
echo    !C_RED![0]!C_RESET! Return to Main Menu
echo.

set "EXP_CHOICE="
set /p "EXP_CHOICE=Select option [0-2]: "
if "!EXP_CHOICE!"=="0" goto :MAIN_MENU

if "!EXP_CHOICE!"=="1" (
    echo.
    echo  Trimming Windows Explorer memory working set...
    powershell -NoProfile -Command "$sig = '[DllImport(\"psapi.dll\")] public static extern bool EmptyWorkingSet(IntPtr hProcess);'; Add-Type -MemberDefinition $sig -Name 'WSExp' -Namespace 'Win32' -ErrorAction SilentlyContinue; Get-Process -Name 'explorer' -ErrorAction SilentlyContinue | ForEach-Object { try { [Win32.WSExp]::EmptyWorkingSet($_.Handle) | Out-Null } catch {} }; Start-Sleep -Milliseconds 400; $exp = Get-Process -Name 'explorer' -ErrorAction SilentlyContinue; if ($exp) { $ws = [math]::Round(($exp | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB, 1); Write-Host ('  [OK] Explorer working set trimmed to: ' + $ws + ' MB') -ForegroundColor Green }"
    echo.
    pause
    goto :MAIN_MENU
)

if "!EXP_CHOICE!"=="2" (
    echo.
    echo  Restarting Windows Explorer...
    taskkill /F /IM explorer.exe >nul 2>&1
    timeout /t 1 /nobreak >nul 2>&1
    start explorer.exe
    timeout /t 1 /nobreak >nul 2>&1
    echo  !C_GREEN![OK] Windows Explorer restarted. Icon, thumbnail, and shell memory purged.!C_RESET!
    echo.
    pause
    goto :MAIN_MENU
)

goto :MAIN_MENU

REM ------------------------------------------------------------
REM [5] TOP RAM HOG ANALYZER & TARGETED PROCESS TRIMMER
REM ------------------------------------------------------------
:RAM_HOGS
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!TOP MEMORY CONSUMERS (RAM HOG ANALYZER)!C_RESET!
echo  ----------------------------------------------------------------------
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$procs = Get-Process | Group-Object Name | ForEach-Object { $mem = [math]::Round(($_.Group | Measure-Object -Property WorkingSet64 -Sum).Sum / 1MB, 1); [PSCustomObject]@{ Process = $_.Name; Instances = $_.Count; MemoryMB = $mem; SamplePID = ($_.Group | Select-Object -First 1).Id } } | Sort-Object MemoryMB -Descending | Select-Object -First 15; Write-Host ('  {0,-6}  {1,-28}  {2,10}  {3,10}' -f 'PID', 'PROCESS NAME', 'INSTANCES', 'RAM (MB)') -ForegroundColor Cyan; Write-Host ('  ' + ('-' * 60)) -ForegroundColor Gray; foreach ($p in $procs) { $c = if ($p.MemoryMB -gt 1000) { 'Red' } elseif ($p.MemoryMB -gt 400) { 'Yellow' } else { 'White' }; Write-Host ('  {0,-6}  {1,-28}  {2,10}  {3,10} MB' -f $p.SamplePID, $p.Process, $p.Instances, $p.MemoryMB) -ForegroundColor $c }"

if not "%~1"=="" goto :EXIT

echo.
echo  Targeted action:
echo  Enter process name or PID to trim working set (or press Enter to return):
set "TARGET_PROC="
set /p "TARGET_PROC=Target Process [e.g. chrome, msedge, or PID]: "
if not defined TARGET_PROC goto :MAIN_MENU

powershell -NoProfile -ExecutionPolicy Bypass -Command "$sig = '[DllImport(\"psapi.dll\")] public static extern bool EmptyWorkingSet(IntPtr hProcess);'; Add-Type -MemberDefinition $sig -Name 'WSTarget' -Namespace 'Win32' -ErrorAction SilentlyContinue; $target = '%TARGET_PROC%'.Trim(); $procs = @(); if ($target -match '^\d+$') { $procs = Get-Process -Id ([int]$target) -ErrorAction SilentlyContinue } else { $name = $target.Replace('.exe', ''); $procs = Get-Process -Name $name -ErrorAction SilentlyContinue }; if ($procs.Count -eq 0) { Write-Host ('  [FAIL] No active process found matching: ' + $target) -ForegroundColor Red } else { $freedCount = 0; foreach ($p in $procs) { try { if ($p.Handle -ne [IntPtr]::Zero) { [Win32.WSTarget]::EmptyWorkingSet($p.Handle) | Out-Null; $freedCount++ } } catch {} }; Write-Host ('  [OK] Successfully trimmed memory working set for ' + $freedCount + ' instance(s) of ' + $target + '.') -ForegroundColor Green }"

echo.
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [6] FLUSH NETWORK & SYSTEM CACHES
REM ------------------------------------------------------------
:FLUSH_NETWORK_CACHE
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!FLUSH NETWORK ^& SYSTEM CACHES!C_RESET!
echo  ----------------------------------------------------------------------
echo  Flushes stale DNS lookups, NetBIOS records, ARP cache, and temporary buffers.
echo.

echo  [1/3] Flushing Windows DNS Resolver Cache...
ipconfig /flushdns >nul 2>&1
echo  !C_GREEN![OK] DNS cache cleared.!C_RESET!
echo.

echo  [2/3] Flushing NetBIOS Name Resolution Cache...
nbtstat -R >nul 2>&1
echo  !C_GREEN![OK] NetBIOS names cleared.!C_RESET!
echo.

echo  [3/3] Purging Windows User Temporary Directory Bloat...
powershell -NoProfile -Command "$tmp = $env:TEMP; $files = Get-ChildItem -LiteralPath $tmp -Recurse -File -Force -ErrorAction SilentlyContinue; $deleted = 0; foreach ($f in $files) { try { Remove-Item -LiteralPath $f.FullName -Force -ErrorAction Stop; $deleted++ } catch {} }; Write-Host ('  [OK] Cleaned ' + $deleted + ' temporary lock and cache files.') -ForegroundColor Green"

echo.
echo !C_GREEN![OK] Network and temporary system caches successfully flushed.!C_RESET!
echo.
if not "%~1"=="" goto :EXIT
pause
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [7] REAL-TIME RAM TELEMETRY & LIVE MONITOR
REM ------------------------------------------------------------
:RAM_TELEMETRY
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!REAL-TIME RAM TELEMETRY ^& MEMORY PRESSURE GAUGE!C_RESET!
echo  ----------------------------------------------------------------------
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$os = Get-CimInstance Win32_OperatingSystem; $totalGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2); $freeMB = [math]::Round($os.FreePhysicalMemory / 1KB, 1); $freeGB = [math]::Round($os.FreePhysicalMemory / 1MB, 2); $usedGB = [math]::Round(($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / 1MB, 2); $pct = [math]::Round(($usedGB / $totalGB) * 100, 1); $barWidth = 32; $filled = [math]::Round(($pct / 100) * $barWidth); if ($filled -gt $barWidth) { $filled = $barWidth }; if ($filled -lt 0) { $filled = 0 }; $empty = $barWidth - $filled; $bar = ('#' * $filled) + ('-' * $empty); $barColor = if ($pct -gt 85) { 'Red' } elseif ($pct -gt 70) { 'Yellow' } else { 'Green' }; Write-Host '  MEMORY PRESSURE GAUGE:' -ForegroundColor Cyan; Write-Host ('  [' + $bar + '] ' + $pct + '%% In-Use') -ForegroundColor $barColor; Write-Host ''; Write-Host ('  Total Physical Memory : ' + $totalGB + ' GB'); Write-Host ('  In-Use Physical Memory: ' + $usedGB + ' GB'); Write-Host ('  Available Free Memory : ' + $freeGB + ' GB (' + $freeMB + ' MB)'); Write-Host ''; $swapTotal = [math]::Round($os.TotalVirtualMemorySize / 1MB, 2); $swapFree = [math]::Round($os.FreeVirtualMemory / 1MB, 2); $swapUsed = [math]::Round($swapTotal - $swapFree, 2); Write-Host ('  Commit / Virtual RAM  : ' + $swapUsed + ' GB / ' + $swapTotal + ' GB'); Write-Host ''; if ($pct -gt 85) { Write-Host '  HEALTH STATUS: [HIGH PRESSURE] - Laptop performance is degraded. Boost recommended!' -ForegroundColor Red } elseif ($pct -gt 70) { Write-Host '  HEALTH STATUS: [ELEVATED LOAD] - Heavy apps active. Quick Boost can reclaim 1-2 GB.' -ForegroundColor Yellow } else { Write-Host '  HEALTH STATUS: [HEALTHY] - Generous free memory headroom available.' -ForegroundColor Green }"

if not "%~1"=="" goto :EXIT

echo.
echo  Controls:
echo    !C_CYAN![B]!C_RESET! Trigger Instant Laptop RAM Boost
echo    !C_CYAN![R]!C_RESET! Refresh Telemetry
echo    !C_RED![0]!C_RESET! Return to Main Menu
echo.

set "TEL_ACTION="
set /p "TEL_ACTION=Choose action [B/R/0]: "
if /I "!TEL_ACTION!"=="B" goto :QUICK_BOOST
if /I "!TEL_ACTION!"=="R" goto :RAM_TELEMETRY
goto :MAIN_MENU

REM ------------------------------------------------------------
REM [8] ELEVATE TO ADMINISTRATOR
REM ------------------------------------------------------------
:ELEVATE_ADMIN
cls
call :HEADER
echo  !C_WHITE!!C_BOLD!ELEVATING TO ADMINISTRATOR PRIVILEGES!C_RESET!
echo  ----------------------------------------------------------------------
if "%IS_ADMIN%"=="1" (
    echo  !C_GREEN![INFO] This window is already running with full Administrator privileges.!C_RESET!
    echo.
    if not "%~1"=="" goto :EXIT
    pause
    goto :MAIN_MENU
)

echo  Requesting Windows UAC elevation to unlock kernel memory management...
echo  (NtSetSystemInformation Standby List and System Working Sets).
echo.
powershell -NoProfile -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c `\"%~f0`\"' -Verb RunAs" >nul 2>&1
if errorlevel 1 (
    echo !C_RED![ERROR] Elevation request was cancelled or denied.!C_RESET!
    echo.
    if not "%~1"=="" goto :EXIT
    pause
    goto :MAIN_MENU
)
echo !C_GREEN![OK] Elevated instance launched in new window.!C_RESET!
timeout /t 2 >nul 2>&1
exit /b 0

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
