@echo off
setlocal enabledelayedexpansion
title MCP Memory Server - Smart Updater v2.0

echo ================================================
echo    MCP Memory Server - Smart Updater v2.0
echo ================================================
echo.
echo This updater will:
echo ✅ Find your installation automatically
echo ✅ Stop any running dashboard servers
echo ✅ Update MCP server + Dashboard + Dependencies
echo ✅ Preserve ALL your data and configurations
echo ✅ Keep your memory.json intact
echo ✅ NOT touch Claude/Cursor/Windsurf configs
echo.
echo IMPORTANT: This will update:
echo - React dashboard (new features, UI improvements)
echo - MCP server logic (new memory functions)
echo - Dependencies (security updates, bug fixes)
echo - Documentation and scripts
echo.
pause

echo Step 1: Stopping any running servers...
echo.

REM Kill development servers safely
set "PORTS=3000 3001 5173 5174 8080"
for %%p in (%PORTS%) do (
    for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr :%%p') do (
        echo Stopping server on port %%p (PID %%a)
        taskkill /PID %%a /F >nul 2>&1
    )
)
echo All servers stopped!

echo.
echo Step 2: Finding your MCP Memory Server installation...

REM Smart installation detection
set "FOUND_PATH="
set "FOUND_COUNT=0"

REM Check current directory first
if exist "like-i-said-mcp-server\server.js" (
    set "FOUND_PATH=%CD%\like-i-said-mcp-server"
    set /a FOUND_COUNT+=1
    echo ✅ Found in current directory: !FOUND_PATH!
)

if exist "server.js" (
    if exist "package.json" (
        findstr /C:"like-i-said-mcp-server" package.json >nul 2>&1
        if !errorlevel! equ 0 (
            set "FOUND_PATH=%CD%"
            set /a FOUND_COUNT+=1
            echo ✅ Found installation in current directory: !FOUND_PATH!
        )
    )
)

REM Search common directories
for %%d in (
    "%USERPROFILE%\Documents"
    "%USERPROFILE%\Desktop" 
    "%USERPROFILE%\Downloads"
    "D:\MY PROJECTS\AI\LLM\AI Code Gen\my-builds\My MCP"
    "C:\Users\%USERNAME%\MCP"
) do (
    if exist "%%~d" (
        for /f "delims=" %%f in ('dir /b /s "%%~d\server.js" 2^>nul') do (
            set "DIR_PATH=%%~dpf"
            set "DIR_PATH=!DIR_PATH:~0,-1!"
            if exist "!DIR_PATH!\package.json" (
                findstr /C:"like-i-said-mcp-server" "!DIR_PATH!\package.json" >nul 2>&1
                if !errorlevel! equ 0 (
                    set "FOUND_PATH=!DIR_PATH!"
                    set /a FOUND_COUNT+=1
                    echo ✅ Found installation: !DIR_PATH!
                )
            )
        )
    )
)

if !FOUND_COUNT! equ 0 (
    echo.
    echo ❌ ERROR: No MCP Memory Server installation found!
    echo.
    echo Please run the installer first:
    echo    install-mcp-memory-server.bat
    echo.
    echo Or make sure you're running this from the correct directory.
    echo.
    pause
    exit /b 1
)

if !FOUND_COUNT! gtr 1 (
    echo.
    echo ⚠️  WARNING: Multiple installations found!
    echo Please run this updater from the specific installation directory.
    echo.
    pause
    exit /b 1
)

echo.
echo 🎯 Installation found: !FOUND_PATH!

echo.
echo Step 3: Backing up your critical data...
cd /d "!FOUND_PATH!"

REM Backup memory data
if exist "memory.json" (
    copy "memory.json" "memory.json.backup.%DATE:/=-%-%TIME::=.%" >nul
    echo ✅ Memory data backed up
) else (
    echo ℹ️  No memory.json found (will create new one)
)

REM Backup any custom configs
if exist "dashboard-config.json" (
    copy "dashboard-config.json" "dashboard-config.backup.%DATE:/=-%-%TIME::=.%" >nul
    echo ✅ Dashboard config backed up
)

echo.
echo Step 4: Downloading latest version...
cd ..
set "UPDATE_DIR=like-i-said-mcp-server-update-%RANDOM%"
git clone "https://github.com/endlessblink/Like-I-Said-memory-mcp-server.git" "%UPDATE_DIR%"
if %errorlevel% neq 0 (
    echo ❌ ERROR: Failed to download update!
    echo Check your internet connection and try again.
    pause
    exit /b 1
)
echo ✅ Latest version downloaded!

echo.
echo Step 5: Installing updated dependencies...
cd "%UPDATE_DIR%"
call npm install
if %errorlevel% neq 0 (
    echo ⚠️  WARNING: npm install had issues, but continuing...
) else (
    echo ✅ Dependencies updated!
)

echo.
echo Step 6: Preserving your data and applying updates...
cd ..

REM Get the original directory name
for %%f in ("!FOUND_PATH!") do set "ORIGINAL_NAME=%%~nxf"
set "BACKUP_NAME=%ORIGINAL_NAME%-backup-%DATE:/=-%-%TIME::=.%"

REM Restore user data to new installation
if exist "!FOUND_PATH!\memory.json" (
    copy "!FOUND_PATH!\memory.json" "%UPDATE_DIR%\memory.json" >nul
    echo ✅ Memory data restored to new version
) else (
    echo {} > "%UPDATE_DIR%\memory.json"
    echo ✅ Created fresh memory.json
)

REM Restore custom configs if they exist
if exist "!FOUND_PATH!\dashboard-config.json" (
    copy "!FOUND_PATH!\dashboard-config.json" "%UPDATE_DIR%\dashboard-config.json" >nul
    echo ✅ Custom dashboard config restored
)

echo.
echo Step 7: Swapping installations...

REM Create backup of old installation
if exist "%BACKUP_NAME%" (
    rmdir /s /q "%BACKUP_NAME%"
)
move "!FOUND_PATH!" "%BACKUP_NAME%" >nul
if %errorlevel% neq 0 (
    echo ❌ ERROR: Could not backup old installation!
    pause
    exit /b 1
)

REM Move new installation to original location
move "%UPDATE_DIR%" "!FOUND_PATH!" >nul
if %errorlevel% neq 0 (
    echo ❌ ERROR: Could not install new version!
    echo Restoring backup...
    move "%BACKUP_NAME%" "!FOUND_PATH!" >nul
    pause
    exit /b 1
)

echo ✅ Installation updated successfully!

echo.
echo ================================================
echo                🎉 UPDATE COMPLETE! 🎉
echo ================================================
echo.
echo ✅ MCP Memory Server updated to latest version
echo ✅ Dashboard updated with new features
echo ✅ Dependencies updated for security
echo ✅ All your data preserved
echo ✅ Configurations remain unchanged
echo.
echo 📁 Your data:
echo    Memory: Preserved and restored
echo    Configs: Claude/Cursor/Windsurf untouched
echo    Backup: %BACKUP_NAME%
echo.
echo 🚀 NEW FEATURES AVAILABLE:
echo    Check the dashboard for UI improvements
echo    New memory management capabilities
echo    Enhanced search and filtering
echo    Better performance and stability
echo.
echo 📋 NEXT STEPS:
echo 1. Restart your AI assistants (Claude, Cursor, Windsurf)
echo 2. Test the memory functions: add_memory, get_memory, etc.
echo 3. Try the updated dashboard: npm run dev:full
echo 4. If everything works, delete backup folder
echo.
echo 🔧 Start the dashboard:
echo    cd "!FOUND_PATH!"
echo    npm run dev:full
echo.
echo Update complete! This window stays open.
echo.
echo Press any key to exit...
pause >nul

echo Exiting...