@echo off
echo Starting Like-I-Said MCP Server Development Environment...
echo.
echo Starting Backend API server on port 3001...
start "API Server" cmd /k "cd /d "%~dp0" && npm run dashboard"
echo.
echo Waiting 3 seconds...
timeout /t 3 /nobreak >nul
echo.
echo Starting Frontend UI server on port 5173...
start "UI Server" cmd /k "cd /d "%~dp0" && npm run dev"
echo.
echo Both servers are starting in separate windows.
echo - Backend API: http://localhost:3001
echo - Frontend UI: http://localhost:5173
echo.
echo Press any key to exit this window...
pause >nul
