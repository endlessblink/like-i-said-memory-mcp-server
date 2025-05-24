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

:register_claude
set "CLAUDE_CONFIG=%USERPROFILE%\.claude\claude_desktop_config.json"
set "INSTALL_DIR_JSON=%INSTALL_DIR:\=/%"
if exist "%CLAUDE_CONFIG%" (
    echo Registering with Claude Desktop...
    echo Creating backup...
    copy "%CLAUDE_CONFIG%" "%CLAUDE_CONFIG%.backup" >nul 2>&1
    echo Updating config...
    echo {"mcpServers":{"LikeISaidMCP":{"command":"node","args":["%INSTALL_DIR_JSON%/server.js"],"env":{"MEMORY_FILE_PATH":"%INSTALL_DIR_JSON%/memory.json"}}}} > "%TEMP%\claude_update.json"
    powershell -Command ^
        "$existing = Get-Content '%CLAUDE_CONFIG%' | ConvertFrom-Json; $new = Get-Content '%TEMP%\claude_update.json' | ConvertFrom-Json; if (-not $existing.PSObject.Properties.Name -contains 'mcpServers' -or $null -eq $existing.mcpServers) { $existing | Add-Member -MemberType NoteProperty -Name mcpServers -Value @{} }; $existing.mcpServers.LikeISaidMCP = $new.mcpServers.LikeISaidMCP; $existing | ConvertTo-Json -Depth 10 | Set-Content '%CLAUDE_CONFIG%'"
    del "%TEMP%\claude_update.json" >nul 2>&1
    echo [OK] Registered with Claude Desktop.
) else (
    echo Claude Desktop config not found. Creating new one...
    mkdir "%USERPROFILE%\.claude" >nul 2>&1
    echo {"mcpServers":{"LikeISaidMCP":{"command":"node","args":["%INSTALL_DIR_JSON%/server.js"],"env":{"MEMORY_FILE_PATH":"%INSTALL_DIR_JSON%/memory.json"}}}} > "%CLAUDE_CONFIG%"
    echo [OK] Created Claude Desktop config.
)
goto :eof

:register_cursor
set "CURSOR_CONFIG=%USERPROFILE%\.cursor\mcp.json"
set "INSTALL_DIR_JSON=%INSTALL_DIR:\=/%"
if exist "%CURSOR_CONFIG%" (
    echo Registering with Cursor...
    echo Creating backup...
    copy "%CURSOR_CONFIG%" "%CURSOR_CONFIG%.backup" >nul 2>&1
    echo Updating config...
    echo {"mcpServers":{"LikeISaidMCP":{"command":"node","args":["%INSTALL_DIR_JSON%/server.js"],"env":{"MEMORY_FILE_PATH":"%INSTALL_DIR_JSON%/memory.json"}}}} > "%TEMP%\cursor_update.json"
    powershell -Command ^
        "$existing = Get-Content '%CURSOR_CONFIG%' | ConvertFrom-Json; $new = Get-Content '%TEMP%\cursor_update.json' | ConvertFrom-Json; if (-not $existing.PSObject.Properties.Name -contains 'mcpServers' -or $null -eq $existing.mcpServers) { $existing | Add-Member -MemberType NoteProperty -Name mcpServers -Value @{} }; $existing.mcpServers.LikeISaidMCP = $new.mcpServers.LikeISaidMCP; $existing | ConvertTo-Json -Depth 10 | Set-Content '%CURSOR_CONFIG%'"
    del "%TEMP%\cursor_update.json" >nul 2>&1
    echo [OK] Registered with Cursor.
) else (
    echo Cursor config not found. Creating new one...
    mkdir "%USERPROFILE%\.cursor" >nul 2>&1
    echo {"mcpServers":{"LikeISaidMCP":{"command":"node","args":["%INSTALL_DIR_JSON%/server.js"],"env":{"MEMORY_FILE_PATH":"%INSTALL_DIR_JSON%/memory.json"}}}} > "%CURSOR_CONFIG%"
    echo [OK] Created Cursor config.
)
goto :eof

:register_windsurf
set "WINDSURF_CONFIG=%USERPROFILE%\.windsurf\windsurf.mcp.json"
set "INSTALL_DIR_JSON=%INSTALL_DIR:\=/%"
if exist "%WINDSURF_CONFIG%" (
    echo Registering with Windsurf...
    echo Creating backup...
    copy "%WINDSURF_CONFIG%" "%WINDSURF_CONFIG%.backup" >nul 2>&1
    echo Updating config...
    echo {"mcpServers":{"LikeISaidMCP":{"command":"node","args":["%INSTALL_DIR_JSON%/server.js"],"env":{"MEMORY_FILE_PATH":"%INSTALL_DIR_JSON%/memory.json"}}}} > "%TEMP%\windsurf_update.json"
    powershell -Command ^
        "$existing = Get-Content '%WINDSURF_CONFIG%' | ConvertFrom-Json; $new = Get-Content '%TEMP%\windsurf_update.json' | ConvertFrom-Json; if (-not $existing.PSObject.Properties.Name -contains 'mcpServers' -or $null -eq $existing.mcpServers) { $existing | Add-Member -MemberType NoteProperty -Name mcpServers -Value @{} }; $existing.mcpServers.LikeISaidMCP = $new.mcpServers.LikeISaidMCP; $existing | ConvertTo-Json -Depth 10 | Set-Content '%WINDSURF_CONFIG%'"
    del "%TEMP%\windsurf_update.json" >nul 2>&1
    echo [OK] Registered with Windsurf.
) else (
    echo Windsurf config not found. Creating new one...
    mkdir "%USERPROFILE%\.windsurf" >nul 2>&1
    echo {"mcpServers":{"LikeISaidMCP":{"command":"node","args":["%INSTALL_DIR_JSON%/server.js"],"env":{"MEMORY_FILE_PATH":"%INSTALL_DIR_JSON%/memory.json"}}}} > "%WINDSURF_CONFIG%"
    echo [OK] Created Windsurf config.
)
goto :eof
