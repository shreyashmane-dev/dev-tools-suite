# DEV Tools Suite - Multi-Network Dispatch Proxy Engine
# Provider: AnoS
[CmdletBinding()]
param(
    [int]$Port = 8080,
    [string]$CliMode = ""
)

$ErrorActionPreference = 'Stop'

Write-Host ""
Write-Host "  ======================================================================" -ForegroundColor Cyan
Write-Host "     DEV MULTI-NET DISPATCH PROXY ENGINE (v1.0.0)" -ForegroundColor White
Write-Host "     Provider: AnoS | Parallel Socket Load Balancer" -ForegroundColor Gray
Write-Host "  ======================================================================" -ForegroundColor Cyan
Write-Host ""

# Discover active network interfaces with default gateways
$adapters = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces() | Where-Object { 
    $_.OperationalStatus -eq [System.Net.NetworkInformation.OperationalStatus]::Up -and 
    $_.NetworkInterfaceType -ne [System.Net.NetworkInformation.NetworkInterfaceType]::Loopback 
}

$ipList = @()
$adapterDetails = @()

foreach ($a in $adapters) {
    $ipProp = $a.GetIPProperties()
    $ipv4 = ($ipProp.UnicastAddresses | Where-Object { $_.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork }).Address
    $gw = ($ipProp.GatewayAddresses | Where-Object { $_.Address.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork }).Address
    if ($ipv4 -and $gw) {
        $ipList += $ipv4.IPAddressToString
        $adapterDetails += [PSCustomObject]@{
            Name = $a.Name
            Description = $a.Description
            Type = $a.NetworkInterfaceType.ToString()
            IPv4 = $ipv4.IPAddressToString
            Gateway = $gw.IPAddressToString
            SpeedMbps = [math]::Round($a.Speed / 1000000, 0)
        }
    }
}

if ($ipList.Count -eq 0) {
    Write-Host "  [FAIL] No active network interfaces with default gateway found." -ForegroundColor Red
    Write-Host "  Please ensure Wi-Fi, Ethernet, or USB tethering is connected." -ForegroundColor Yellow
    exit 1
}

Write-Host ("  Active Network Adapters Discovered: " + $adapterDetails.Count) -ForegroundColor Green
$idx = 1
foreach ($d in $adapterDetails) {
    Write-Host ("  [" + $idx + "] " + $d.Name + " (" + $d.Type + ")") -ForegroundColor Cyan
    Write-Host ("      Hardware : " + $d.Description) -ForegroundColor Gray
    Write-Host ("      IPv4 IP  : " + $d.IPv4) -ForegroundColor Green
    Write-Host ("      Gateway  : " + $d.Gateway) -ForegroundColor Gray
    Write-Host ("      Link Spd : " + $d.SpeedMbps + " Mbps") -ForegroundColor Gray
    $idx++
}

Write-Host ""
if ($adapterDetails.Count -eq 1) {
    Write-Host "  [NOTICE] 1 active interface detected." -ForegroundColor Yellow
    Write-Host "           To combine speeds, connect a second Wi-Fi dongle, phone USB tethering, or LAN cable." -ForegroundColor Yellow
} else {
    Write-Host ("  [READY] " + $adapterDetails.Count + " interfaces detected! Download traffic will be distributed equally.") -ForegroundColor Green
}
Write-Host ""

# C# Socket Dispatcher Implementation
$cSharpCode = @"
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

public class NetDispatchProxy
{
    private TcpListener _listener;
    private IPAddress[] _adapterIps;
    private int _rr = 0;
    private bool _running = false;
    public long TotalRequests = 0;
    public long ActiveSockets = 0;

    public NetDispatchProxy(int port, string[] ips)
    {
        var list = new System.Collections.ArrayList();
        foreach (var s in ips)
        {
            IPAddress ip;
            if (IPAddress.TryParse(s, out ip))
                list.Add(ip);
        }
        _adapterIps = (IPAddress[])list.ToArray(typeof(IPAddress));
        _listener = new TcpListener(IPAddress.Loopback, port);
    }

    public void Start()
    {
        _running = true;
        _listener.Start();
        Task.Run(async () =>
        {
            while (_running)
            {
                try
                {
                    TcpClient client = await _listener.AcceptTcpClientAsync();
                    Task ignored = HandleClientAsync(client);
                }
                catch
                {
                    if (!_running) break;
                }
            }
        });
    }

    public void Stop()
    {
        _running = false;
        try { _listener.Stop(); } catch {}
    }

    private IPAddress GetNextAdapterIp()
    {
        if (_adapterIps.Length == 0) return IPAddress.Any;
        int next = Interlocked.Increment(ref _rr);
        return _adapterIps[Math.Abs(next) % _adapterIps.Length];
    }

    private async Task HandleClientAsync(TcpClient client)
    {
        Interlocked.Increment(ref ActiveSockets);
        Interlocked.Increment(ref TotalRequests);

        using (client)
        {
            try
            {
                NetworkStream clientStream = client.GetStream();
                byte[] buffer = new byte[8192];
                int bytesRead = await clientStream.ReadAsync(buffer, 0, buffer.Length);
                if (bytesRead == 0) return;

                string headerText = Encoding.ASCII.GetString(buffer, 0, bytesRead);
                string[] lines = headerText.Split(new string[] { "\r\n", "\n" }, StringSplitOptions.RemoveEmptyEntries);
                if (lines.Length == 0) return;

                string[] reqLine = lines[0].Split(' ');
                if (reqLine.Length != 3) return;

                string method = reqLine[0].ToUpperInvariant();
                string host = "";
                int targetPort = 80;

                if (method == "CONNECT")
                {
                    string[] hostPort = reqLine[1].Split(':');
                    host = hostPort[0];
                    targetPort = hostPort.Length > 1 ? int.Parse(hostPort[1]) : 443;
                }
                else
                {
                    Uri uri = new Uri(reqLine[1].StartsWith("http") ? reqLine[1] : "http://" + reqLine[1]);
                    host = uri.DnsSafeHost;
                    targetPort = uri.Port;
                }

                IPAddress outgoingIp = GetNextAdapterIp();
                Socket outboundSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                outboundSocket.Bind(new IPEndPoint(outgoingIp, 0));

                await outboundSocket.ConnectAsync(host, targetPort);

                using (NetworkStream outboundStream = new NetworkStream(outboundSocket, true))
                {
                    if (method == "CONNECT")
                    {
                        byte[] okMsg = Encoding.ASCII.GetBytes("HTTP/1.1 200 Connection Established\r\n\r\n");
                        await clientStream.WriteAsync(okMsg, 0, okMsg.Length);
                    }
                    else
                    {
                        await outboundStream.WriteAsync(buffer, 0, bytesRead);
                    }

                    Task t1 = clientStream.CopyToAsync(outboundStream);
                    Task t2 = outboundStream.CopyToAsync(clientStream);
                    await Task.WhenAny(t1, t2);
                }
            }
            catch
            {
                // Silently drop closed or aborted sockets
            }
            finally
            {
                Interlocked.Decrement(ref ActiveSockets);
            }
        }
    }
}
"@

Add-Type -TypeDefinition $cSharpCode -ErrorAction SilentlyContinue

$proxy = New-Object NetDispatchProxy($Port, $ipList)
$proxy.Start()

Write-Host ("  [ACTIVE] Dispatch Proxy listening on: 127.0.0.1:" + $Port) -ForegroundColor Green
Write-Host "  ----------------------------------------------------------------------"
Write-Host "  HOW TO USE IN APPS FOR SPEED BOOST:"
Write-Host ("  * Windows System Proxy    : Settings > Network > Proxy -> 127.0.0.1:" + $Port)
Write-Host ("  * IDM / Download Manager  : Options > Proxy -> 127.0.0.1:" + $Port)
Write-Host ("  * Web Browser Proxy       : HTTP/HTTPS -> 127.0.0.1:" + $Port)
Write-Host "  * Each parallel download chunk routes through a different connection!"
Write-Host "  ----------------------------------------------------------------------"

if ($CliMode -ne "" -or $env:DEV_CLI_TEST -eq "1") {
    Start-Sleep -Milliseconds 1200
    $proxy.Stop()
    Write-Host "  [OK] Proxy test completed successfully." -ForegroundColor Green
    exit 0
}

Write-Host "  Proxy is actively dispatching traffic in background." -ForegroundColor Cyan
Write-Host "  Press Enter at any time to stop the proxy server..."
[void][Console]::ReadLine()
$proxy.Stop()
Write-Host "  [STOPPED] Dispatch Proxy terminated." -ForegroundColor Yellow
exit 0
