param(
    [string]$Environment = "dev",
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"
$envPath = Join-Path $Root "environment\$Environment"

if (-not (Test-Path $envPath)) {
    Write-Error "Environment path not found: $envPath"
}

$layers = Get-ChildItem -Path $envPath -Directory | Sort-Object Name
$results = @()

Write-Host "Validating Terraform layers under $envPath" -ForegroundColor Cyan

$SkipLayers = @("foundation")

foreach ($layer in $layers) {
    if ($SkipLayers -contains $layer.Name) {
        Write-Host "`n=== $($layer.Name) === (skipped — merged into governance)" -ForegroundColor DarkGray
        continue
    }
    $layerPath = $layer.FullName
    Write-Host "`n=== $($layer.Name) ===" -ForegroundColor Yellow

    Push-Location $layerPath
    try {
        terraform init -backend=false -input=false | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "terraform init failed" }

        terraform validate
        if ($LASTEXITCODE -ne 0) { throw "terraform validate failed" }

        $results += [PSCustomObject]@{
            Layer   = $layer.Name
            Status  = "PASS"
            Message = "OK"
        }
        Write-Host "PASS: $($layer.Name)" -ForegroundColor Green
    }
    catch {
        $results += [PSCustomObject]@{
            Layer   = $layer.Name
            Status  = "FAIL"
            Message = $_.Exception.Message
        }
        Write-Host "FAIL: $($layer.Name) - $($_.Exception.Message)" -ForegroundColor Red
    }
    finally {
        Pop-Location
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
$results | Format-Table -AutoSize

$failed = @($results | Where-Object { $_.Status -eq "FAIL" })
if ($failed.Count -gt 0) {
    exit 1
}

exit 0
