@echo off
set VCVARS_ARCH=x86
set "VCVARS=%ProgramFiles(x86)%\Microsoft Visual Studio 8\VC\vcvarsall.bat"
set QTDIR=C:\Qt\4.4.3\msvc2005_static
set CMAKEDIR="%ProgramFiles%\CMake"
set IFACE=pipe
set BUILDDIR=build_%IFACE%

call "%VCVARS%" %VCVARS_ARCH%
set "PATH=%QTDIR%\bin;%CMAKEDIR%\bin;%PATH%"

cd "%~dp0"
rmdir /S /Q "%BUILDDIR%" 2>nul >nul
mkdir "%BUILDDIR%"
cd "%BUILDDIR%"
cmake -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DWPAS_STATIC_RUNTIME=ON -DWPAS_CTRL_IFACE=%IFACE% "%~dp0"
cmake --build . --config Release --target all
cpack -D CPACK_OUTPUT_FILE_PREFIX="%~dp0\."

cd "%~dp0"
pause
