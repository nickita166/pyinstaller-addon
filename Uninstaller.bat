@echo off
setlocal

set "SELF=%~f0"
set "INSTALL_DIR=%ProgramData%\Pyinstalleraddon"
set "KEY=HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\PyInstallerAddon"

echo ==================================
echo   PyInstaller Addon Uninstaller
echo ==================================
echo.

:: ---------------------------
:: Auto detect Python
:: ---------------------------
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

if exist "%SCRIPTS%\pyinstaller.bat" (
    del /f /q "%SCRIPTS%\pyinstaller.bat"
    echo Removed pyinstaller.bat
)

if exist "%SCRIPTS%\pyinstaller1.exe" (
    ren "%SCRIPTS%\pyinstaller1.exe" "pyinstaller.exe"
    echo Restored pyinstaller.exe
)

:: ---------------------------
:: Registry cleanup
:: ---------------------------
reg delete "%KEY%" /f >nul 2>&1

echo.

:: ---------------------------
:: Self cleanup system
:: ---------------------------
if /i "%SELF%"=="%ProgramData%\Pyinstalleraddon\Uninstaller.bat" (
    echo Scheduling full cleanup...

    start "" /min cmd /c ^
    "timeout /t 3 >nul && rmdir /s /q \"%ProgramData%\Pyinstalleraddon\""
) else (
    rmdir /s /q "%ProgramData%\Pyinstalleraddon"
)

echo.
echo Uninstall complete.
exit /b