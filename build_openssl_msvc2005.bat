@echo off
set OPENSSL_SRC=openssl-1.1.1u
set OPENSSL_DST=openssl-1.1.1-x86

call "%ProgramFiles(x86)%\Microsoft Visual Studio 8\VC\vcvarsall.bat" x86
set PATH=%PATH%;C:\Perl64\bin;C:\Strawberry\perl\bin

cd "%~dp0"
set "BUILDDIR=%cd%\%OPENSSL_DST%"

cd "%OPENSSL_SRC%"
perl Configure VC-WIN32 no-asm no-shared no-hw enable-static-engine no-threads no-dso enable-rc5 enable-mdc2 enable-ssl2 enable-weak-ssl-ciphers --prefix="%BUILDDIR%" --openssldir="%BUILDDIR%\etc\ssl" -DOPENSSL_NO_ASYNC
nmake depend
nmake
nmake install
nmake clean
nmake distclean

rmdir /s /q "%BUILDDIR%\bin"
rmdir /s /q "%BUILDDIR%\etc"
rmdir /s /q "%BUILDDIR%\html"
rmdir /s /q "%BUILDDIR%\share"
rmdir /s /q "%BUILDDIR%\lib\pkgconfig"
rmdir /s /q "%BUILDDIR%\lib\engines-1_1"

pause
