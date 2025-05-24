@echo off
setlocal enabledelayedexpansion

REM === CONFIGURATION ===
set "REPO_URL=https://github.com/endlessblink/like-i-said-memory-mcp-server.git"
set "INSTALL_DIR=%~dp0like-i-said-mcp-server"

echo.
echo ==== Like-I-said-mcp-server Installer ====
echo.

REM === 1. Clone if not already present ===
if exist "%INSTALL_DIR%\.git" (
    echo Repo already exists at "%INSTALL_DIR%", skipping clone.
) else (
    echo Cloning repo to "%INSTALL_DIR%"...
    git clone "%REPO_URL%" "%INSTALL_DIR%"
    if errorlevel 1 (
        echo Git clone failed. Exiting.
        exit /b 1
    )
)

cd /d "%INSTALL_DIR%"

REM === 2. Install dependencies ===
echo Installing dependencies...
call npm install
if errorlevel 1 (
    echo npm install failed. Exiting.
    exit /b 1
)

REM === 3. Ask user which client(s) to register with ===
echo.
set /p CLIENT=Which client do you want to register the MCP server with? (claude/cursor/windsurf/all/none) [none]: 
if "%CLIENT%"=="" set CLIENT=none

REM === 4. Register with clients ===
if /i "%CLIENT%"=="claude" (
    call :register_claude
) else if /i "%CLIENT%"=="cursor" (
    call :register_cursor
) else if /i "%CLIENT%"=="windsurf" (
    call :register_windsurf
) else if /i "%CLIENT%"=="all" (
    call :register_claude
    call :register_cursor
    call :register_windsurf
) else (
    echo No client registration selected.
)

echo.
echo Done! To start the dashboard, run:
echo cd "%INSTALL_DIR%"
echo npm run dashboard
echo npm run dev
pause
goto :eof

REM === Functions ===

:register_cursor
set "CURSOR_CONFIG=%USERPROFILE%\.cursor\mcp.json"
set "INSTALL_DIR_JSON=%INSTALL_DIR:\=/%"
(
    echo {
    echo   "mcpServers": {
    echo     "LikeISaidMCP": {
    echo       "command": "node",
    echo       "args": ["%INSTALL_DIR_JSON%/server.js"],
    echo       "env": {"MEMORY_FILE_PATH": "%INSTALL_DIR_JSON%/memory.json"}
    echo     }
    echo   }
    echo }
) > "%TEMP%\cursor_template.json"

if exist "%CURSOR_CONFIG%" (
    echo Registering with Cursor...
    echo Creating backup...
    copy "%CURSOR_CONFIG%" "%CURSOR_CONFIG%.backup" >nul 2>&1
    powershell -Command ^
        "$config = Get-Content '%CURSOR_CONFIG%' | ConvertFrom-Json -ErrorAction SilentlyContinue; $new = Get-Content '%TEMP%\cursor_template.json' | ConvertFrom-Json; if (-not $config.mcpServers) { $config | Add-Member -MemberType NoteProperty 'mcpServers' @{} -Force }; $config.mcpServers.LikeISaidMCP = $new.mcpServers.LikeISaidMCP; $config | ConvertTo-Json -Depth 10 | Set-Content '%CURSOR_CONFIG%'"
) else (
    echo Creating new config...
    mkdir "%USERPROFILE%\.cursor" >nul 2>&1
    copy "%TEMP%\cursor_template.json" "%CURSOR_CONFIG%" >nul 2>&1
)
del "%TEMP%\cursor_template.json" >nul 2>&1
echo [OK] Registered with Cursor.
goto :eof

:register_claude
REM Use the same pattern as :register_cursor, just update the config path and template file names

:register_windsurf
REM Use the same pattern as :register_cursor, just update the config path and template file names
