@echo off
setlocal enabledelayedexpansion

for /f %%i in ('powershell -NoP "[Environment]::GetFolderPath('Desktop')"') do set DESKTOP=%%i

set CACHE_DIR=%temp%\pyinstaller_cache

if not exist "%CACHE_DIR%" (
    mkdir "%CACHE_DIR%"
)

pyinstaller1 --distpath "%DESKTOP%" --workpath "%CACHE_DIR%" --specpath "%CACHE_DIR%" %*

set "ERR=%errorlevel%"

rmdir /s /q "%CACHE_DIR%" >nul 2>&1

if not "%ERR%"=="0" (
    echo.
    echo [ERROR] PyInstaller failed with exit code %ERR%
    pause
) else (

cls

echo Done Building EXE!
echo Output: %DESKTOP%
)