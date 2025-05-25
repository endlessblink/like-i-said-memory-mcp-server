@echo off
title Like-I-Said MCP - Dashboard Launcher

echo ================================================
echo     Like-I-Said MCP - Web Dashboard Launcher
echo ================================================
echo.
echo This will start the web dashboard for managing
echo your MCP memories through a browser interface.
echo.

REM Find the MCP installation
if exist "like-i-said-mcp-server" (
    cd like-i-said-mcp-server
    echo ✅ Found MCP installation: %CD%
) else if exist "server.js" (
    echo ✅ Found MCP installation: %CD%
) else (
    echo ❌ MCP installation not found in current directory.
    echo Please run this from the folder containing the MCP server.
    pause
    exit /b 1
)

echo.
echo Starting web dashboard...
echo.
echo 🌐 Dashboard will open at: http://localhost:5173
echo 🔧 API server will run at: http://localhost:3001
echo.
echo ⚠️  Keep this window open while using the dashboard!
echo    Press Ctrl+C to stop the dashboard.
echo.
echo Starting servers...
echo.

REM Start the full development environment
npm run dev:full

echo.
echo Dashboard stopped.
pause
