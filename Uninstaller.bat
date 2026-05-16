@echo off
setlocal

set "DIR=\Scripts"
set "INSTALL_DIR=%ProgramData%\Pyinstalleraddon"
set "UNINSTALL_KEY=HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\PyInstallerAddon"

echo Searching for Python installation...
echo.

:: Auto-detect python
for /f "delims=" %%i in ('where python 2^>nul') do (
    set "PYTHON_PATH=%%i"
    goto FOUND
)

echo Could not auto-detect Python.
goto MANUAL

:FOUND
for %%i in ("%PYTHON_PATH%") do set "DEST1=%%~dpi"
goto RUN

:MANUAL
set /p "DEST1=Enter where Python is located: "

:RUN
if not exist "%DEST1%\Scripts" (
    echo Invalid Python path.
    pause
    exit /b
)

set "SCRIPTS=%DEST1%\Scripts"

echo.
echo Uninstalling PyInstaller addon...

:: Remove pyinstaller addon script
if exist "%SCRIPTS%\pyinstaller.bat" (
    del /f /q "%SCRIPTS%\pyinstaller.bat"
    echo Removed pyinstaller.bat
)

:: Restore original pyinstaller
if exist "%SCRIPTS%\pyinstaller1.exe" (
    ren "%SCRIPTS%\pyinstaller1.exe" "pyinstaller.exe"
    echo Restored pyinstaller.exe
)

:: Remove registry entry
reg delete "%UNINSTALL_KEY%" /f >nul 2>&1

:: Remove ProgramData folder
if exist "%INSTALL_DIR%" (
    rmdir /s /q "%INSTALL_DIR%"
    echo Removed ProgramData files
)

echo.
echo Uninstall complete.
pause > nul