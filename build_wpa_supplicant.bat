@echo off
set VCVARS_ARCH=x86
set "VCVARS=%ProgramFiles(x86)%\Microsoft Visual Studio 8\VC\vcvarsall.bat"
set QTDIR=C:\Qt\4.4.3\msvc2005_static
set CMAKEDIR="%ProgramFiles%\CMake"
set BUILDDIR=build
set SRCDIR=wpa_supplicant-2.10
set DSTDIR=wpa_supplicant-windows-bin-2.10
set "ZIP_CMD=%~dp0\tools\zip.exe"

call "%VCVARS%" %VCVARS_ARCH%
set "PATH=%QTDIR%\bin;%CMAKEDIR%\bin;%PATH%"

cd "%~dp0"
rmdir /S /Q "%BUILDDIR%" 2>nul >nul
mkdir "%BUILDDIR%"
cd "%BUILDDIR%"
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release "%~dp0"
cmake --build . --config Release --target all

rem @todo CMake
rmdir /S /Q "%DSTDIR%" 2>nul >nul
mkdir "%DSTDIR%"
copy /Y "win_if_list.exe" "%DSTDIR%\win_if_list.exe"
copy /Y "wpa_cli.exe" "%DSTDIR%\wpa_cli.exe"
copy /Y "wpa_gui.exe" "%DSTDIR%\wpa_gui.exe"
copy /Y "wpa_passphrase.exe" "%DSTDIR%\wpa_passphrase.exe"
copy /Y "wpa_supplicant.exe" "%DSTDIR%\wpa_supplicant.exe"
copy /Y "wpasvc.exe" "%DSTDIR%\wpasvc.exe"
copy /Y "%~dp0\%SRCDIR%\COPYING" "%DSTDIR%\COPYING"
copy /Y "%~dp0\%SRCDIR%\wpa_supplicant\README" "%DSTDIR%\README"
copy /Y "%~dp0\%SRCDIR%\wpa_supplicant\README-Windows.txt" "%DSTDIR%\README-Windows.txt"
copy /Y "%~dp0\%SRCDIR%\wpa_supplicant\win_example.reg" "%DSTDIR%\win_example.reg"
copy /Y "%~dp0\%SRCDIR%\wpa_supplicant\wpa_supplicant.conf" "%DSTDIR%\wpa_supplicant.conf"
lrelease "%~dp0\%SRCDIR%\wpa_supplicant\wpa_gui-qt4\lang\wpa_gui_de.ts"
move /Y "%~dp0\%SRCDIR%\wpa_supplicant\wpa_gui-qt4\lang\wpa_gui_de.qm" "%DSTDIR%\wpa_gui_de.qm"

del /F /S /Q "%DSTDIR%.zip"
"%ZIP_CMD%" -9r "%DSTDIR%.zip" "%DSTDIR%"
move /Y "%DSTDIR%.zip" "%~dp0\%DSTDIR%.zip"

cd "%~dp0"
pause
