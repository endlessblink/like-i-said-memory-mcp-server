@echo off
setlocal enabledelayedexpansion
title MCP Memory Server - Auto Installer

echo ================================================
echo        MCP Memory Server - Auto Installer
echo ================================================
echo.
echo This installer will set up the MCP Memory Server for you:
echo - Downloads and installs the memory server
echo - Configures it for Claude Desktop, Cursor, and Windsurf
echo - Creates your personal memory database
echo Every step will be shown and confirmed.
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

echo ✅ Installation complete!
echo.

echo Step 2: Detecting AI assistants...
echo.

if exist "%APPDATA%\Claude" (
    echo ✅ Claude Desktop found
    set "CLAUDE_AVAILABLE=1"
) else (
    echo ⚪ Claude Desktop not found
    set "CLAUDE_AVAILABLE=0"
)

if exist "%APPDATA%\Cursor" (
    echo ✅ Cursor found
    set "CURSOR_AVAILABLE=1"
) else (
    echo ⚪ Cursor not found
    set "CURSOR_AVAILABLE=0"
)

if exist "%APPDATA%\Windsurf" (
    echo ✅ Windsurf found
    set "WINDSURF_AVAILABLE=1"
) else (
    echo ⚪ Windsurf not found
    set "WINDSURF_AVAILABLE=0"
)

echo.
echo Step 3: Configuration choices...
echo.

if "!CLAUDE_AVAILABLE!"=="1" (
    set /p claude_config="Configure Claude Desktop? (Y/N): "
    echo You chose: !claude_config!
) else (
    set "claude_config=N"
)

if "!CURSOR_AVAILABLE!"=="1" (
    set /p cursor_config="Configure Cursor? (Y/N): "
    echo You chose: !cursor_config!
) else (
    set "cursor_config=N"
)

if "!WINDSURF_AVAILABLE!"=="1" (
    set /p windsurf_config="Configure Windsurf? (Y/N): "
    echo You chose: !windsurf_config!
) else (
    set "windsurf_config=N"
)

echo.
echo Step 4: Creating configurations...
echo.

set "SERVER_PATH=%CD%\server.js"
echo Server path: !SERVER_PATH!

REM Configure Claude Desktop
if /i "!claude_config!"=="Y" (
    echo Configuring Claude Desktop...
    
    echo Creating directory if needed...
    if not exist "%APPDATA%\Claude" mkdir "%APPDATA%\Claude"
    
    echo Writing config file...
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
        echo ✅ Claude Desktop config created successfully!
    ) else (
        echo ❌ Failed to create Claude Desktop config
    )
)

REM Configure Cursor
if /i "!cursor_config!"=="Y" (
    echo Configuring Cursor...
    
    echo Creating directory if needed...
    if not exist "%APPDATA%\Cursor\User\globalStorage\cursor.mcp" (
        mkdir "%APPDATA%\Cursor\User\globalStorage\cursor.mcp"
    )
    
    echo Writing config file...
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
        echo ✅ Cursor config created successfully!
    ) else (
        echo ❌ Failed to create Cursor config
    )
)

REM Configure Windsurf
if /i "!windsurf_config!"=="Y" (
    echo Configuring Windsurf...
    
    echo Creating directory if needed...
    if not exist "%APPDATA%\Windsurf\User\globalStorage\windsurf.mcp" (
        mkdir "%APPDATA%\Windsurf\User\globalStorage\windsurf.mcp"
    )
    
    echo Writing config file...
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
        echo ✅ Windsurf config created successfully!
    ) else (
        echo ❌ Failed to create Windsurf config
    )
)

echo.
echo ================================================
echo                🎉 SUCCESS! 🎉
echo ================================================
echo.
echo ✅ MCP Memory Server installed and configured!
echo 📍 Server: !SERVER_PATH!
echo 📍 Memory: %CD%\memory.json
echo.
echo 📋 Configuration Summary:
if /i "!claude_config!"=="Y" echo    ✅ Claude Desktop configured
if /i "!cursor_config!"=="Y" echo    ✅ Cursor configured  
if /i "!windsurf_config!"=="Y" echo    ✅ Windsurf configured
echo.
echo ⚠️  CRITICAL: RESTART your AI assistants now!
if /i "!claude_config!"=="Y" echo    • Close and restart Claude Desktop
if /i "!cursor_config!"=="Y" echo    • Close and restart Cursor
if /i "!windsurf_config!"=="Y" echo    • Close and restart Windsurf
echo.
echo 🚀 Memory tools available after restart:
echo    • add_memory(key, value, context?)
echo    • get_memory(key)
echo    • list_memories(prefix?)
echo    • delete_memory(key)
echo.
echo ✨ Installation complete! This window stays open.
echo.
echo Press any key to exit...
pause >nul

echo Exiting...
