@echo off
:START

set "DIR=\Scripts"

set /p "DEST1=Enter where Python is located: "

:: Check if Scripts folder exists
if not exist "%DEST1%\Scripts" (
    echo.
    echo "%DEST1%" is not a valid Python install path.
    echo Run "where python" in CMD, then remove python.exe from the end of the path.
    echo.
    pause
    goto START
)

set "REDEST=%DEST1%%DIR%"

:: Delete custom pyinstaller.bat
if exist "%REDEST%\pyinstaller.bat" (
    del /f /q "%REDEST%\pyinstaller.bat"
    echo Removed pyinstaller.bat
) else (
    echo pyinstaller.bat was not found.
)

:: Restore original pyinstaller.exe
if exist "%REDEST%\pyinstaller1.exe" (
    ren "%REDEST%\pyinstaller1.exe" "pyinstaller.exe"
    echo Restored pyinstaller.exe
) else (
    echo pyinstaller1.exe was not found.
)

echo.
echo Uninstall complete.
echo Press any key to close
pause > nul