@echo off
setlocal enabledelayedexpansion
title MCP Memory Server - SAFE Config Checker

echo ================================================
echo      MCP Memory Server - SAFE Config Checker
echo ================================================
echo.
echo This tool ONLY READS your configs and shows what to add.
echo It will NEVER automatically modify your config files.
echo You decide whether to make changes manually.
echo.
pause

echo Step 1: Installing MCP server...
git clone "https://github.com/endlessblink/Like-I-Said-memory-mcp-server.git" like-i-said-mcp-server
echo Git clone result: %errorlevel%
cd like-i-said-mcp-server
echo Entered directory: %CD%

call npm install
echo NPM install result: %errorlevel%

echo {} > memory.json
echo Memory file created: %errorlevel%

echo Installation complete!
echo.

set "SERVER_PATH=%CD%\server.js"
echo Server path: !SERVER_PATH!
echo.

echo ================================================
echo           CONFIGURATION INSTRUCTIONS
echo ================================================
echo.
echo I will now check your current configs and show you
echo exactly what to add manually. This is MUCH SAFER.
echo.

REM Check Claude Desktop
if exist "%APPDATA%\Claude\claude_desktop_config.json" (
    echo CLAUDE DESKTOP CONFIG:
    echo File: %APPDATA%\Claude\claude_desktop_config.json
    echo.
    echo Add this server to your mcpServers section:
    echo.
    echo     "like-i-said-memory": {
    echo       "command": "node",
    echo       "args": ["!SERVER_PATH:\=\\!"]
    echo     }
    echo.
) else (
    echo Claude Desktop config not found
)

REM Check Cursor
if exist "%USERPROFILE%\.cursor\mcp.json" (
    echo CURSOR CONFIG:
    echo File: %USERPROFILE%\.cursor\mcp.json
    echo.
    echo Add this server to your mcpServers section:
    echo.
    echo     "like-i-said-memory": {
    echo       "command": "node",
    echo       "args": ["!SERVER_PATH:\=\\!"]
    echo     }
    echo.
) else (
    echo Cursor config not found
)

REM Check Windsurf
if exist "%USERPROFILE%\.codeium\windsurf\mcp_config.json" (
    echo WINDSURF CONFIG:
    echo File: %USERPROFILE%\.codeium\windsurf\mcp_config.json
    echo.
    echo Add this server to your mcpServers section:
    echo.
    echo     "like-i-said-memory": {
    echo       "command": "node",
    echo       "args": ["!SERVER_PATH:\=\\!"]
    echo     }
    echo.
) else (
    echo Windsurf config not found
)

echo ================================================
echo                   SUMMARY
echo ================================================
echo.
echo 1. MCP Memory Server installed at: !SERVER_PATH!
echo 2. Review the instructions above
echo 3. Manually add the server entries to your config files
echo 4. Make sure to add commas between server entries
echo 5. Restart your AI assistants after making changes
echo.
echo This approach is SAFE and won't damage your configs!
echo.
echo Press any key to exit...
pause >nul