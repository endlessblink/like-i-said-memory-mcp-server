@echo off
setlocal enabledelayedexpansion

set "REPO_URL=https://github.com/endlessblink/like-i-said-memory-mcp-server.git"
set "INSTALL_DIR=%~dp0like-i-said-mcp-server"

echo.
echo ==== Like-I-said-mcp-server Installer ====
echo.

if exist "%INSTALL_DIR%\.git" (
    echo Repo exists. Skipping clone.
) else (
    git clone "%REPO_URL%" "%INSTALL_DIR%"
    if errorlevel 1 exit /b 1
)

cd /d "%INSTALL_DIR%"
call npm install
if errorlevel 1 exit /b 1

echo.
set /p CLIENT=Register with client (claude/cursor/windsurf/all/none): 
if "%CLIENT%"=="" set CLIENT=none

if /i "%CLIENT%"=="cursor" call :register_cursor
if /i "%CLIENT%"=="all" (call :register_claude & call :register_cursor & call :register_windsurf)

echo.
echo Done! Start with:
echo cd "%INSTALL_DIR%" && npm run dashboard && npm run dev
pause
exit /b 0

:register_cursor
set "CURSOR_CONFIG=%USERPROFILE%\.cursor\mcp.json"
set "INSTALL_DIR_JSON=%INSTALL_DIR:\=/%"

echo Creating/Updating Cursor config...
powershell -Command ^
    "$configPath = '%CURSOR_CONFIG%'; ^
    $template = @{ ^
        mcpServers = @{ ^
            LikeISaidMCP = @{ ^
                command = 'node'; ^
                args = @('%INSTALL_DIR_JSON%/server.js'); ^
                env = @{MEMORY_FILE_PATH = '%INSTALL_DIR_JSON%/memory.json'} ^
            } ^
        } ^
    }; ^
    if (Test-Path $configPath) { ^
        $existing = Get-Content $configPath | ConvertFrom-Json; ^
        if (-not $existing.mcpServers) { $existing | Add-Member mcpServers @{} -Force }; ^
        $existing.mcpServers.LikeISaidMCP = $template.mcpServers.LikeISaidMCP; ^
        $existing | ConvertTo-Json -Depth 10 | Set-Content $configPath ^
    } else { ^
        New-Item -Path (Split-Path $configPath) -ItemType Directory -Force | Out-Null; ^
        $template | ConvertTo-Json -Depth 10 | Set-Content $configPath ^
    }"

echo [SUCCESS] Cursor configuration updated
goto :eof

:register_claude
REM Same pattern as cursor but with CLAUDE_CONFIG
:register_windsurf
REM Same pattern as cursor but with WINDSURF_CONFIG
