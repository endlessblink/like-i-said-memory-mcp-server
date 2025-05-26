@echo off
setlocal enabledelayedexpansion
title MCP Memory Server - Auto Installer (Single File)

echo ================================================
echo    MCP Memory Server - Auto Installer v2.0
echo ================================================
echo.
echo This installer is completely self-contained:
echo - Downloads and installs the memory server
echo - Configures it for Claude Desktop, Cursor, and Windsurf
echo - Creates your personal memory database
echo - SAFELY preserves existing MCP servers
echo - Uses Node.js for reliable JSON handling
echo - Works from any empty folder!
echo.
echo IMPORTANT: Windows users should avoid spaces in paths!
echo Current path: %CD%
echo.

REM Check for spaces in current path
echo %CD% | findstr " " >nul
if %errorlevel% equ 0 (
    echo.
    echo ⚠️  WARNING: Current path contains SPACES!
    echo    This may cause issues with Cursor on Windows.
    echo.
    echo    Recommended paths without spaces:
    echo    - C:\MCP\
    echo    - D:\Development\
    echo    - C:\Users\%USERNAME%\mcp-servers\
    echo.
    echo    Continue anyway? Y/N
    set /p continue_anyway="Your choice: "
    if /i "!continue_anyway!" neq "Y" (
        echo.
        echo Installation cancelled. Please run from a path without spaces.
        pause
        exit /b 1
    )
    echo.
    echo Continuing with installation...
)

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

echo Installation complete!
echo.

echo Step 2: Detecting AI assistants...
echo.

REM Correct detection paths
if exist "%APPDATA%\Claude" (
    echo Claude Desktop found
    set "CLAUDE_AVAILABLE=1"
) else (
    echo Claude Desktop not found
    set "CLAUDE_AVAILABLE=0"
)
if exist "%USERPROFILE%\.cursor" (
    echo Cursor found
    set "CURSOR_AVAILABLE=1"
) else (
    echo Cursor not found
    set "CURSOR_AVAILABLE=0"
)

if exist "%USERPROFILE%\.codeium\windsurf" (
    echo Windsurf found
    set "WINDSURF_AVAILABLE=1"
) else (
    echo Windsurf not found
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
echo Step 4: Creating embedded config updater...
echo.

set "SERVER_PATH=%CD%\server.js"
echo Server path: !SERVER_PATH!
echo.
REM Create embedded Node.js config updater
echo Creating safe config updater...
(
echo const fs = require('fs'^);
echo const path = require('path'^);
echo.
echo class SafeConfigUpdater {
echo     constructor(^) {
echo         this.configPaths = {
echo             claude: path.join(process.env.APPDATA, 'Claude', 'claude_desktop_config.json'^),
echo             cursor: path.join(process.env.USERPROFILE, '.cursor', 'mcp.json'^),
echo             windsurf: path.join(process.env.USERPROFILE, '.codeium', 'windsurf', 'mcp_config.json'^)
echo         };
echo     }
echo.
echo     readConfig(configPath^) {
echo         try {
echo             if (^^!fs.existsSync(configPath^)^) {
echo                 return { mcpServers: {} };
echo             }
echo             const content = fs.readFileSync(configPath, 'utf8'^);
echo             if (^^!content.trim(^)^) {
echo                 return { mcpServers: {} };
echo             }
echo             const parsed = JSON.parse(content^);
echo             if (^^!parsed.mcpServers^) {
echo                 parsed.mcpServers = {};
echo             }
echo             return parsed;
echo         } catch (error^) {
echo             console.error('Error reading config:', error.message^);
echo             return null;
echo         }
echo     }
echo.
echo     writeConfig(configPath, config^) {
echo         try {
echo             const dir = path.dirname(configPath^);
echo             if (^^!fs.existsSync(dir^)^) {
echo                 fs.mkdirSync(dir, { recursive: true }^);
echo             }
echo             const jsonString = JSON.stringify(config, null, 2^);
echo             JSON.parse(jsonString^);
echo             const tempPath = configPath + '.tmp';
echo             fs.writeFileSync(tempPath, jsonString, 'utf8'^);
echo             fs.renameSync(tempPath, configPath^);
echo             return true;
echo         } catch (error^) {
echo             console.error('Error writing config:', error.message^);
echo             return false;
echo         }
echo     }
echo.
echo     addMemoryServer(client, serverPath^) {
echo         const configPath = this.configPaths[client];
echo         if (^^!configPath^) {
echo             console.error('Unknown client:', client^);
echo             return false;
echo         }
echo         console.log('Configuring ' + client + '...'^);
echo         const config = this.readConfig(configPath^);
echo         if (^^!config^) {
echo             console.error('Failed to read ' + client + ' config'^);
echo             return false;
echo         }
echo         if (config.mcpServers['like-i-said-memory']^) {
echo             console.log('SKIP: Server already exists in ' + client^);
echo             return true;
echo         }
echo         config.mcpServers['like-i-said-memory'] = {
echo             command: 'node',
echo             args: [serverPath]
echo         };
echo         if (this.writeConfig(configPath, config^)^) {
echo             console.log('SUCCESS: Added server to ' + client^);
echo             return true;
echo         } else {
echo             console.error('FAILED: Could not update ' + client + ' config'^);
echo             return false;
echo         }
echo     }
echo }
echo.
echo const args = process.argv.slice(2^);
echo if (args.length ^< 2^) {
echo     console.error('Usage: node updater.js ^<client^> ^<server-path^>'^);
echo     process.exit(1^);
echo }
echo const [client, serverPath] = args;
echo const updater = new SafeConfigUpdater(^);
echo const success = updater.addMemoryServer(client, serverPath^);
echo process.exit(success ? 0 : 1^);
) > temp-updater.js
REM Configure using the embedded Node.js updater
if /i "!claude_config!"=="Y" (
    echo Configuring Claude Desktop safely...
    node temp-updater.js claude "!SERVER_PATH!"
)

if /i "!cursor_config!"=="Y" (
    echo Configuring Cursor safely...
    node temp-updater.js cursor "!SERVER_PATH!"
)

if /i "!windsurf_config!"=="Y" (
    echo Configuring Windsurf safely...
    node temp-updater.js windsurf "!SERVER_PATH!"
)

echo.
echo Cleaning up...
del "temp-updater.js" >nul 2>&1

echo.
echo ================================================
echo                SUCCESS!
echo ================================================
echo.
echo MCP Memory Server installed and configured SAFELY!
echo Server: !SERVER_PATH!
echo Memory: %CD%\memory.json
echo.
echo Configuration Summary:
if /i "!claude_config!"=="Y" echo    Claude Desktop processed
if /i "!cursor_config!"=="Y" echo    Cursor processed  
if /i "!windsurf_config!"=="Y" echo    Windsurf processed
echo.
echo CRITICAL: RESTART your AI assistants now!
if /i "!claude_config!"=="Y" echo    * Close and restart Claude Desktop
if /i "!cursor_config!"=="Y" echo    * Close and restart Cursor
if /i "!windsurf_config!"=="Y" echo    * Close and restart Windsurf
echo.
echo Memory tools available after restart:
echo    * add_memory(key, value, context?)
echo    * get_memory(key)
echo    * list_memories(prefix?)
echo    * delete_memory(key)
echo.
echo Installation complete! This window stays open.
echo.
echo Press any key to exit...
pause >nul

echo Exiting...