@echo off
setlocal enabledelayedexpansion
title MCP - Quick Configuration Only

echo ================================================
echo         MCP Memory Server - Quick Config
echo ================================================
echo.
echo This will configure your AI assistants for an
echo existing MCP Memory Server installation.
echo.
pause

REM Find existing installation
echo Looking for existing MCP installation...
echo.

if exist "like-i-said-mcp-server\server.js" (
    cd like-i-said-mcp-server
    echo ✅ Found installation in: %CD%
) else if exist "server.js" (
    echo ✅ Found installation in: %CD%
) else (
    echo ❌ No MCP installation found in current directory.
    echo Please run this from the folder containing the MCP server.
    pause
    exit /b 1
)

set "SERVER_PATH=%CD%\server.js"
echo 📍 Server location: !SERVER_PATH!

echo.
echo Detecting AI assistants...

if exist "%APPDATA%\Claude" (
    echo ✅ Claude Desktop found
    set /p claude_config="Configure Claude Desktop? (Y/N): "
) else (
    echo ⚪ Claude Desktop not found
    set "claude_config=N"
)

if exist "%APPDATA%\Cursor" (
    echo ✅ Cursor found
    set /p cursor_config="Configure Cursor? (Y/N): "
) else (
    echo ⚪ Cursor not found
    set "cursor_config=N"
)

if exist "%APPDATA%\Windsurf" (
    echo ✅ Windsurf found
    set /p windsurf_config="Configure Windsurf? (Y/N): "
) else (
    echo ⚪ Windsurf not found
    set "windsurf_config=N"
)

echo.
echo Configuring selected assistants...
echo.

REM Configure Claude Desktop
if /i "!claude_config!"=="Y" (
    echo Configuring Claude Desktop...
    if not exist "%APPDATA%\Claude" mkdir "%APPDATA%\Claude"
    
    (
    echo {
    echo   "mcpServers": {
    echo     "like-i-said-memory": {
    echo       "command": "node",
    echo       "args": ["!SERVER_PATH:\=\\!"]
    echo     }
    echo   }
    echo }
    ) > "%APPDATA%\Claude\claude_desktop_config.json"
    
    if exist "%APPDATA%\Claude\claude_desktop_config.json" (
        echo ✅ Claude Desktop configured!
    ) else (
        echo ❌ Claude Desktop configuration failed
    )
)

REM Configure Cursor  
if /i "!cursor_config!"=="Y" (
    echo Configuring Cursor...
    if not exist "%APPDATA%\Cursor\User\globalStorage\cursor.mcp" (
        mkdir "%APPDATA%\Cursor\User\globalStorage\cursor.mcp"
    )
    
    (
    echo {
    echo   "mcpServers": {
    echo     "like-i-said-memory": {
    echo       "command": "node",
    echo       "args": ["!SERVER_PATH:\=\\!"]
    echo     }
    echo   }
    echo }
    ) > "%APPDATA%\Cursor\User\globalStorage\cursor.mcp\claude_desktop_config.json"
    
    if exist "%APPDATA%\Cursor\User\globalStorage\cursor.mcp\claude_desktop_config.json" (
        echo ✅ Cursor configured!
    ) else (
        echo ❌ Cursor configuration failed
    )
)

REM Configure Windsurf
if /i "!windsurf_config!"=="Y" (
    echo Configuring Windsurf...
    if not exist "%APPDATA%\Windsurf\User\globalStorage\windsurf.mcp" (
        mkdir "%APPDATA%\Windsurf\User\globalStorage\windsurf.mcp"
    )
    
    (
    echo {
    echo   "mcpServers": {
    echo     "like-i-said-memory": {
    echo       "command": "node",
    echo       "args": ["!SERVER_PATH:\=\\!"]
    echo     }
    echo   }
    echo }
    ) > "%APPDATA%\Windsurf\User\globalStorage\windsurf.mcp\claude_desktop_config.json"
    
    if exist "%APPDATA%\Windsurf\User\globalStorage\windsurf.mcp\claude_desktop_config.json" (
        echo ✅ Windsurf configured!
    ) else (
        echo ❌ Windsurf configuration failed
    )
)

echo.
echo ================================================
echo           🎉 CONFIGURATION COMPLETE! 🎉
echo ================================================
echo.

echo 📋 What was configured:
if /i "!claude_config!"=="Y" echo    ✅ Claude Desktop
if /i "!cursor_config!"=="Y" echo    ✅ Cursor
if /i "!windsurf_config!"=="Y" echo    ✅ Windsurf

echo.
echo ⚠️  RESTART your configured AI assistants now!
echo.
echo 🚀 Available memory tools after restart:
echo    • add_memory(key, value, context?)
echo    • get_memory(key)
echo    • list_memories(prefix?)
echo    • delete_memory(key)
echo.
echo Press any key to exit...
pause >nul
