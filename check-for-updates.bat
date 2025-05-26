@echo off
echo ================================================
echo         MCP Memory Server - Update Checker
echo ================================================
echo.

if exist "version.json" (
    echo Current installation version:
    findstr "version" version.json | head -1
    echo.
) else (
    echo Version: Unknown (older installation)
    echo.
)

echo To update to the latest version:
echo 1. Download: update-mcp-memory-server.bat
echo 2. Run it from anywhere
echo 3. Your data will be preserved automatically
echo.
echo Or visit: https://github.com/endlessblink/Like-I-Said-memory-mcp-server
echo.
pause