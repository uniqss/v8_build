Rem set VERSION=8.8.278.15
Rem 20210207 branch-heads's 8.8 means 8.8.278.15
set VERSION=8.8

cd .\v8\v8

set build=debug
set v8_home=..\..\%VERSION%\%build%\
xcopy .\include\*.h %v8_home%include\ /Q /Y
xcopy .\out.gn\x64.release\obj\*.lib %v8_home%%build%\lib\ /Q /Y

pause
