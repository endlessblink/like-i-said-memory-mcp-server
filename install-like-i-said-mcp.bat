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
if exist "%CLAUDE_CONFIG%" (
    echo Registering with Claude Desktop...
    set "TMP_PS=%TEMP%\register_claude.ps1"
    (
        echo param([string]$configPath, [string]$installDir^)
        echo $config = Get-Content -Raw -Path $configPath ^| ConvertFrom-Json
        echo if (-not $config.mcpServers^) { $config ^| Add-Member -MemberType NoteProperty -Name mcpServers -Value @{} }
        echo $config.mcpServers.LikeISaidMCP = @{
        echo   command = 'node'
        echo   args = @("$installDir\server.js")
        echo   env = @{MEMORY_FILE_PATH = "$installDir\memory.json"}
        echo }
        echo $config ^| ConvertTo-Json -Depth 10 ^| Set-Content -Path $configPath
    ) > "%TMP_PS%"
    powershell -ExecutionPolicy Bypass -File "%TMP_PS%" "%CLAUDE_CONFIG%" "%INSTALL_DIR%"
    del "%TMP_PS%"
    echo [OK] Registered with Claude Desktop.
) else (
    echo Claude Desktop config not found at "%CLAUDE_CONFIG%".
)
goto :eof

:register_cursor
set "CURSOR_CONFIG=%USERPROFILE%\.cursor\mcp.json"
if exist "%CURSOR_CONFIG%" (
    echo Registering with Cursor...
    set "TMP_PS=%TEMP%\register_cursor.ps1"
    (
        echo param([string]$configPath, [string]$installDir^)
        echo $config = Get-Content -Raw -Path $configPath ^| ConvertFrom-Json
        echo if (-not $config.mcpServers^) { $config ^| Add-Member -MemberType NoteProperty -Name mcpServers -Value @{} }
        echo $config.mcpServers.LikeISaidMCP = @{
        echo   command = 'node'
        echo   args = @("$installDir\server.js")
        echo   env = @{MEMORY_FILE_PATH = "$installDir\memory.json"}
        echo }
        echo $config ^| ConvertTo-Json -Depth 10 ^| Set-Content -Path $configPath
    ) > "%TMP_PS%"
    powershell -ExecutionPolicy Bypass -File "%TMP_PS%" "%CURSOR_CONFIG%" "%INSTALL_DIR%"
    del "%TMP_PS%"
    echo [OK] Registered with Cursor.
) else (
    echo Cursor config not found at "%CURSOR_CONFIG%".
)
goto :eof

:register_windsurf
set "WINDSURF_CONFIG=%USERPROFILE%\.windsurf\windsurf.mcp.json"
if exist "%WINDSURF_CONFIG%" (
    echo Registering with Windsurf...
    set "TMP_PS=%TEMP%\register_windsurf.ps1"
    (
        echo param([string]$configPath, [string]$installDir^)
        echo $config = Get-Content -Raw -Path $configPath ^| ConvertFrom-Json
        echo if (-not $config.mcpServers^) { $config ^| Add-Member -MemberType NoteProperty -Name mcpServers -Value @{} }
        echo $config.mcpServers.LikeISaidMCP = @{
        echo   command = 'node'
        echo   args = @("$installDir\server.js")
        echo   env = @{MEMORY_FILE_PATH = "$installDir\memory.json"}
        echo }
        echo $config ^| ConvertTo-Json -Depth 10 ^| Set-Content -Path $configPath
    ) > "%TMP_PS%"
    powershell -ExecutionPolicy Bypass -File "%TMP_PS%" "%WINDSURF_CONFIG%" "%INSTALL_DIR%"
    del "%TMP_PS%"
    echo [OK] Registered with Windsurf.
) else (
    echo Windsurf config not found at "%WINDSURF_CONFIG%".
)
goto :eof
