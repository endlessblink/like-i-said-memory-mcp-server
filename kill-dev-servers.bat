@echo off
echo ================================================
echo           Kill All Dev Servers
echo ================================================
echo.

echo Checking for running servers...
echo.

REM Check and kill common development ports
set "PORTS=3000 3001 5173 5174 8080 8000"

for %%p in (%PORTS%) do (
    echo Checking port %%p...
    for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr :%%p') do (
        echo   Killing process %%a on port %%p
        taskkill /PID %%a /F >nul 2>&1
    )
)

echo.
echo ================================================
echo All development servers have been terminated!
echo ================================================
echo.
pause