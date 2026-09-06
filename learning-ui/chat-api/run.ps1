#Requires -Version 5.1
$ErrorActionPreference = "Stop"
$Root = $PSScriptRoot

Write-Host "Installing chat-api dependencies..." -ForegroundColor Cyan
pip install -r "$Root\requirements.txt"

Write-Host ""
Write-Host "Checking Ollama..." -ForegroundColor Cyan
try {
    ollama list 2>$null
    if ($LASTEXITCODE -ne 0) { throw "not installed" }
} catch {
    Write-Host "Install Ollama from https://ollama.com then run: ollama pull llama3.2" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Starting Flask chat API on http://localhost:5001" -ForegroundColor Green
Set-Location $Root
python app.py
