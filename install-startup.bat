@echo off
echo Installing MCP Server to Windows Startup...
powershell -ExecutionPolicy Bypass -File "manage-server.ps1" -Action "install-startup"
pause
