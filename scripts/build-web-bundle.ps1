<#
.SYNOPSIS
    Builds site/js/tools-bundle.js with all tools metadata and full standalone BAT Base64 payload.
    Provider: AnoS
#>
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoRoot = Split-Path -Parent $ScriptDir
$toolsJsonPath = Join-Path $RepoRoot 'site\data\tools.json'
$bundleJsPath = Join-Path $RepoRoot 'site\js\tools-bundle.js'

$rawJson = Get-Content -Raw -Encoding UTF8 $toolsJsonPath
$data = $rawJson | ConvertFrom-Json

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("/** DEV Tools Suite :: Client Data & Binary Payload Bundle */")
[void]$sb.AppendLine("window.DEV_TOOLS_DATA = $rawJson;")
[void]$sb.AppendLine("window.DEV_BATCH_BASE64 = {")

$first = $true
foreach ($t in $data.tools) {
    $batPath = Join-Path $RepoRoot ($t.batPath.Replace('/', '\'))
    if (Test-Path -LiteralPath $batPath) {
        $bytes = [System.IO.File]::ReadAllBytes($batPath)
        $b64 = [System.Convert]::ToBase64String($bytes)
        if (-not $first) { [void]$sb.AppendLine(",") }
        [void]$sb.Append("  `"$($t.id)`": `"$b64`"")
        $first = $false
    }
}
[void]$sb.AppendLine("")
[void]$sb.AppendLine("};")

[System.IO.File]::WriteAllText($bundleJsPath, $sb.ToString(), [System.Text.Encoding]::UTF8)
$size = (Get-Item $bundleJsPath).Length
Write-Host "Successfully generated site/js/tools-bundle.js ($size bytes)"
