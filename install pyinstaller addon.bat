@echo off
:START

set "URL=https://github.com/nickita166/pyinstaller-addon/raw/refs/heads/main/pyinstaller.bat"
set "DIR=\Scripts"

set /p "DEST1=Enter where Python is located: "

if not exist "%DEST1%\Scripts" (
    echo.
    echo "%DEST1%" is not a valid Python install path.
    echo Run "where python" in CMD, then remove python.exe from the end of the path.
    echo.
    pause
    goto START
)

set "DEST=%DEST1%%DIR%\pyinstaller.bat"
set "REDEST=%DEST1%%DIR%"

if exist "%REDEST%\pyinstaller.exe" (
    ren "%REDEST%\pyinstaller.exe" "pyinstaller1.exe"
) else (
echo please install pyinstaller with "pip install pyinstaller"
)

echo Downloading file from GitHub...

curl -L -s -o "%DEST%" "%URL%"

if exist "%DEST%" (
    echo File installed to: "%DEST%"
) else (
    echo ERROR: Download failed.
)

echo.
echo Press any key to close
pause > nul