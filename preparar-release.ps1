param(
    [Parameter(Mandatory = $true)]
    [string]$Version,

    [Parameter(Mandatory = $true)]
    [string]$DownloadBaseUrl,

    [string]$MainExecutable = "D:\FacturasSAT_contexto_y_programa\transferencia_agente\programa\FacturasSAT_corregido.exe",

    [string]$Notes = "Actualización de Facturas SAT"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$ReleaseDirectory = Join-Path $RepoRoot "release"
$TargetExecutable = Join-Path $ReleaseDirectory "FacturasSAT_app.exe"
$ManifestPath = Join-Path $ReleaseDirectory "version.json"

if (-not (Test-Path -LiteralPath $MainExecutable -PathType Leaf)) {
    throw "No existe el ejecutable principal: $MainExecutable"
}

New-Item -ItemType Directory -Force $ReleaseDirectory | Out-Null
Copy-Item -LiteralPath $MainExecutable -Destination $TargetExecutable -Force
$Hash = (Get-FileHash -LiteralPath $TargetExecutable -Algorithm SHA256).Hash.ToLowerInvariant()
$Manifest = [ordered]@{
    version = $Version
    url = "$DownloadBaseUrl/FacturasSAT_app.exe"
    sha256 = $Hash
    notes = $Notes
}
$Manifest | ConvertTo-Json | Set-Content -LiteralPath $ManifestPath -Encoding UTF8

Write-Host "Activo preparado: $TargetExecutable"
Write-Host "Manifiesto preparado: $ManifestPath"
Write-Host "SHA-256: $Hash"
