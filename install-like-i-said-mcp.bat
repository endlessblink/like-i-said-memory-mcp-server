@echo off
setlocal enabledelayedexpansion

:: Set title and colors
title MCP Memory Server Installer
color 0A

echo ========================================
echo    MCP Memory Server Installer
echo ========================================
echo.

:: Get script directory
set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%like-i-said-mcp-server"
set "REPO_URL=https://github.com/endlessblink/like-i-said-memory-mcp-server.git"

echo Script directory: %SCRIPT_DIR%
echo Project will be installed to: %PROJECT_DIR%
echo.

:: Check if Git is installed
echo [1/6] Checking Git installation...
git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git is not installed or not in PATH
    echo Please install Git from https://git-scm.com/
    goto :error_exit
)
echo Git found successfully
echo.

:: Check if Node.js is installed
echo [2/6] Checking Node.js installation...
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    goto :error_exit
)
echo Node.js found successfully

npm --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: npm is not available
    goto :error_exit
)
echo npm found successfully
echo.

:: Clone or update repository
echo [3/6] Setting up repository...
if exist "%PROJECT_DIR%" (
    echo Project directory already exists. Updating...
    cd /d "%PROJECT_DIR%" || goto :error_exit
    echo Pulling latest changes...
    git pull origin main || (
        echo WARNING: Git pull failed, continuing with existing files...
    )
) else (
    echo Cloning repository...
    git clone "%REPO_URL%" "%PROJECT_DIR%" || goto :error_exit
    cd /d "%PROJECT_DIR%" || goto :error_exit
)
echo Repository setup complete
echo.

:: Install dependencies
echo [4/6] Installing dependencies...
npm install || goto :error_exit
echo Dependencies installed successfully
echo.

:: Create memory.json if it doesn't exist
echo [5/6] Initializing memory file...
if not exist "memory.json" (
    echo Creating initial memory.json file...
    echo {"memories":[],"metadata":{"created":"%date% %time%","version":"1.0.0"}} > memory.json
    echo Memory file created
) else (
    echo Memory file already exists
)
echo.

:: Configure MCP clients
echo [6/6] Configuring MCP clients...
echo.
echo Available MCP clients to configure:
echo 1. Cursor
echo 2. Claude Desktop  
echo 3. Windsurf
echo 4. All of the above
echo 5. Skip configuration
echo.
set /p "choice=Enter your choice (1-5): "

if "%choice%"=="1" call :configure_cursor
if "%choice%"=="2" call :configure_claude
if "%choice%"=="3" call :configure_windsurf
if "%choice%"=="4" (
    call :configure_cursor
    call :configure_claude
    call :configure_windsurf
)
if "%choice%"=="5" echo Skipping MCP client configuration

echo.
echo ========================================
echo    Installation Complete!
echo ========================================
echo.
echo Project installed at: %PROJECT_DIR%
echo.
echo To start the server manually, run:
echo   cd "%PROJECT_DIR%"
echo   node server.js
echo.
echo The server is now configured for your selected MCP clients.
echo.
goto :keep_open

:configure_cursor
echo Configuring Cursor...
set "CURSOR_CONFIG=%USERPROFILE%\.cursor\mcp.json"
set "NODE_PATH=%PROJECT_DIR%/server.js"
call :update_mcp_config "%CURSOR_CONFIG%" "cursor" "%NODE_PATH%"
goto :eof

:configure_claude
echo Configuring Claude Desktop...
set "CLAUDE_CONFIG=%USERPROFILE%\.claude\claude_desktop_config.json"
set "NODE_PATH=%PROJECT_DIR%/server.js"
call :update_mcp_config "%CLAUDE_CONFIG%" "claude" "%NODE_PATH%"
goto :eof

:configure_windsurf
echo Configuring Windsurf...
set "WINDSURF_CONFIG=%USERPROFILE%\.windsurf\windsurf.mcp.json"
set "NODE_PATH=%PROJECT_DIR%/server.js"
call :update_mcp_config "%WINDSURF_CONFIG%" "windsurf" "%NODE_PATH%"
goto :eof

:update_mcp_config
set "CONFIG_FILE=%~1"
set "CLIENT_TYPE=%~2"
set "SERVER_PATH=%~3"

:: Convert backslashes to forward slashes for JSON
set "SERVER_PATH=!SERVER_PATH:\=/!"

:: Create config directory if it doesn't exist
for %%F in ("%CONFIG_FILE%") do (
    if not exist "%%~dpF" (
        mkdir "%%~dpF" 2>nul
    )
)

:: Create or update config file using PowerShell
powershell -Command "& {
    $configPath = '%CONFIG_FILE%'
    $serverPath = '%SERVER_PATH%'
    
    # Create config object
    if (Test-Path $configPath) {
        try {
            $config = Get-Content $configPath -Raw | ConvertFrom-Json
        } catch {
            $config = @{}
        }
    } else {
        $config = @{}
    }
    
    # Ensure mcpServers property exists
    if (-not $config.PSObject.Properties['mcpServers']) {
        $config | Add-Member -Type NoteProperty -Name 'mcpServers' -Value @{}
    }
    
    # Add memory server configuration
    $memoryConfig = @{
        command = 'node'
        args = @($serverPath)
    }
    
    $config.mcpServers | Add-Member -Type NoteProperty -Name 'memory' -Value $memoryConfig -Force
    
    # Save configuration
    $config | ConvertTo-Json -Depth 10 | Out-File -FilePath $configPath -Encoding UTF8
    
    Write-Host 'Configuration updated successfully'
}" || (
    echo WARNING: Failed to update %CLIENT_TYPE% configuration
    echo You may need to manually add the server configuration
)

goto :eof

:error_exit
echo.
echo ========================================
echo    Installation Failed!
echo ========================================
echo.
echo An error occurred during installation.
echo Please check the error messages above and try again.
echo.
goto :keep_open

:keep_open
echo Press any key to exit...
pause >nul
exit /b
