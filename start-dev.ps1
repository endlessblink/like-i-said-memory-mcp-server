# PowerShell script to start both servers
Write-Host "Starting Like-I-Said MCP Server Development Environment..." -ForegroundColor Green
Write-Host ""

# Change to script directory
Set-Location $PSScriptRoot

Write-Host "Starting Backend API server on port 3001..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "npm run dashboard"

Start-Sleep -Seconds 3

Write-Host "Starting Frontend UI server on port 5173..." -ForegroundColor Magenta  
Start-Process powershell -ArgumentList "-NoExit", "-Command", "npm run dev"

Write-Host ""
Write-Host "Both servers are starting in separate windows:" -ForegroundColor Yellow
Write-Host "- Backend API: http://localhost:3001" -ForegroundColor Cyan
Write-Host "- Frontend UI: http://localhost:5173" -ForegroundColor Magenta
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
