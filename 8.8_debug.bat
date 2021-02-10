Rem set VERSION=8.8.278.15
Rem 20210207 branch-heads's 8.8 means 8.8.278.15
set VERSION=8.8
set build=debug
cd c:\
cd %HOMEPATH%
echo =====[ Getting Depot Tools ]=====
Rem powershell -command "Invoke-WebRequest https://storage.googleapis.com/chrome-infra/depot_tools.zip -O depot_tools.zip"
7z x depot_tools.zip -o*
set PATH=%CD%\depot_tools;%PATH%
set GYP_MSVS_VERSION=2019
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
call gclient
mkdir v8
cd v8
echo =====[ Fetching V8 ]=====
call fetch v8
cd v8
Rem call git checkout refs/tags/%VERSION%
call git checkout refs/remotes/branch-heads/%VERSION%
cd test\test262\data
call git config --system core.longpaths true
call git restore *
cd ..\..\..\
call gclient sync
echo =====[ Building V8 ]=====
call gn gen out.gn\x64.%build% -args="target_os=""win"" target_cpu=""x64"" v8_use_external_startup_data=true v8_enable_i18n_support=false is_debug=true v8_static_library=true is_clang=false strip_debug_info=true symbol_level=0 v8_enable_pointer_compression=false"
call ninja -C out.gn\x64.%build% -t clean
call ninja -C out.gn\x64.%build% wee8
node %~dp0\genBlobHeader.js "window x64" out.gn\x64.%build%\snapshot_blob.bin
md output\v8\%build%\Lib
copy /Y out.gn\x64.%build%\obj\wee8.lib output\v8\%build%\Lib
md output\v8\%build%\Inc\Blob\Win64
copy SnapshotBlob.h output\v8\%build%\Inc\Blob\Win64\
echo =====[ Copy V8 header ]=====
xcopy include output\v8\%build%\Inc\  /s/h/e/k/f/c

set v8_home=..\..\%VERSION%\%build%\
xcopy .\include\*.h %v8_home%include\ /S /Q /Y
xcopy .\out.gn\x64.%build%\obj\*.lib %v8_home%lib\ /Q /Y

pause