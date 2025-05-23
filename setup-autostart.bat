@echo off
title MCP Server Auto-Start Setup
echo.
echo ============================================
echo    Like I Said MCP Server Auto-Start Setup
echo ============================================
echo.
echo Choose your preferred auto-start method:
echo.
echo 1. Windows Startup (Simplest - starts with login)
echo 2. PM2 Process Manager (Recommended - more control)
echo 3. Manual start only
echo 4. Remove from startup
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto startup
if "%choice%"=="2" goto pm2
if "%choice%"=="3" goto manual
if "%choice%"=="4" goto remove
goto invalid

:startup
echo.
echo Installing to Windows Startup...
powershell -ExecutionPolicy Bypass -File "manage-server.ps1" -Action "install-startup"
echo.
echo The MCP server will now start automatically when you log in.
echo To start it now without rebooting, run: start-invisible.vbs
goto end

:pm2
echo.
echo Setting up PM2 Process Manager...
echo Installing PM2 globally...
call npm install -g pm2
echo.
echo Starting MCP server with PM2...
call npm run pm2:start
echo.
echo Setting up PM2 to start on boot...
call npm run pm2:startup
call npm run pm2:save
echo.
echo PM2 setup complete! Use these commands:
echo   npm run pm2:status  - Check status
echo   npm run pm2:logs    - View logs
echo   npm run pm2:restart - Restart server
goto end

:manual
echo.
echo Manual mode selected. Use these commands:
echo   npm start                           - Start server
echo   powershell .\manage-server.ps1     - Manage server
goto end

:remove
echo.
echo Removing from startup...
powershell -ExecutionPolicy Bypass -File "manage-server.ps1" -Action "remove-startup"
call npm run pm2:stop 2>nul
call pm2 delete like-i-said-mcp-server 2>nul
echo Cleanup complete.
goto end

:invalid
echo Invalid choice. Please run the script again.
goto end

:end
echo.
pause
