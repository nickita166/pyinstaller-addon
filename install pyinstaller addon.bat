@echo off
setlocal

set "URL=https://github.com/nickita166/pyinstaller-addon/raw/refs/heads/main/pyinstaller.bat"
set "UNINSTALL_URL=https://github.com/nickita166/pyinstaller-addon/raw/refs/heads/main/Uninstaller.bat"

set "INSTALL_DIR=%ProgramData%\Pyinstalleraddon"
set "UNINSTALLER=%INSTALL_DIR%\Uninstaller.bat"

echo Searching for Python installation...

for /f "delims=" %%i in ('where python 2^>nul') do (
    set "PYTHON_PATH=%%i"
    goto FOUND
)

echo Could not auto-detect Python.
goto MANUAL

:FOUND
for %%i in ("%PYTHON_PATH%") do set "DEST1=%%~dpi"
goto CHECK

:MANUAL
set /p "DEST1=Enter where Python is located: "

:CHECK
if not exist "%DEST1%\Scripts" (
    echo Invalid Python path.
    pause
    exit /b
)

set "SCRIPTS=%DEST1%\Scripts"
set "DEST=%SCRIPTS%\pyinstaller.bat"

:: Check already installed
if exist "%DEST%" (
    echo Already installed.
    pause
    exit /b
)

:: Rename original pyinstaller
if exist "%SCRIPTS%\pyinstaller.exe" (
    ren "%SCRIPTS%\pyinstaller.exe" "pyinstaller1.exe"
)

echo Installing...

curl -L -o "%DEST%" "%URL%"

:: Create install directory
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Download uninstaller
curl -L -s -o "%UNINSTALLER%" "%UNINSTALL_URL%"

:: -----------------------------
:: Add uninstall entry to registry
:: -----------------------------
set "APPNAME=PyInstaller Addon"
set "KEY=HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\PyInstallerAddon"

reg add "%KEY%" /f >nul
reg add "%KEY%" /v "DisplayName" /t REG_SZ /d "%APPNAME%" /f >nul
reg add "%KEY%" /v "DisplayVersion" /t REG_SZ /d "1.0" /f >nul
reg add "%KEY%" /v "Publisher" /t REG_SZ /d "nickita166" /f >nul
reg add "%KEY%" /v "InstallLocation" /t REG_SZ /d "%INSTALL_DIR%" /f >nul
reg add "%KEY%" /v "UninstallString" /t REG_SZ /d "\"%UNINSTALLER%\"" /f >nul
reg add "%KEY%" /v "NoModify" /t REG_DWORD /d 1 /f >nul
reg add "%KEY%" /v "NoRepair" /t REG_DWORD /d 1 /f >nul

echo.
echo Installation complete.
echo Appears in Installed Apps now.
pause > nul