@echo off
setlocal

@echo off
:: --- Admin check ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

set "PY_KEY=HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\PyInstallerAddon"

echo ===============================
echo   PyInstaller Addon Uninstaller
echo ===============================
echo.

:: ------------------ AUTO DETECT PYTHON ------------------
echo Detecting Python...

for /f "delims=" %%i in ('where python 2^>nul') do (
    set "PYTHON_PATH=%%i"
    goto FOUND
)

echo Could not auto-detect Python.
goto MANUAL

:FOUND
for %%i in ("%PYTHON_PATH%") do set "PYTHON_DIR=%%~dpi"
goto RUN

:MANUAL
set /p "PYTHON_DIR=Enter Python install folder: "

:RUN
if not exist "%PYTHON_DIR%\Scripts" (
    echo Invalid Python path.
    pause
    exit /b
)

set "SCRIPTS=%PYTHON_DIR%\Scripts"

echo Removing addon files...

:: Remove addon script
if exist "%SCRIPTS%\pyinstaller.bat" (
    del /f /q "%SCRIPTS%\pyinstaller.bat"
)

:: Restore original pyinstaller
if exist "%SCRIPTS%\pyinstaller1.exe" (
    ren "%SCRIPTS%\pyinstaller1.exe" "pyinstaller.exe"
)

:: Remove registry entry
reg delete "%PY_KEY%" /f >nul 2>&1

echo.

echo Cleaning ProgramData folder...

:: FORCE DELETE EVERYTHING (IMPORTANT PART)
if exist "%ProgramData%\Pyinstalleraddon" (
    rmdir /s /q "%ProgramData%\Pyinstalleraddon"
)

:: verify
if exist "%ProgramData%\Pyinstalleraddon" (
    echo WARNING: Folder could not be fully removed.
) else (
    echo Fully removed: %ProgramData%\Pyinstalleraddon
)

echo.
echo Uninstall complete.
pause > nul
