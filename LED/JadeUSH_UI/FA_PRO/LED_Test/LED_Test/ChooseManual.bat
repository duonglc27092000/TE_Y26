::--------------------------------Set Env-------------------------------------------
@echo off
:start
cd /d %~dp0
set retry_cycle=2
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
::----------------------------------------------------------------------------------
find /i "B1B" D:\TEST_UI\Line.dat
if not @%errorlevel%==@0 goto pass

start showerror.exe Manual.png
KB_HookTest.exe
find /i "Y" KeyVkCode.Bat
if @%errorlevel%==@0 goto Reloadxml
goto pass

:Reloadxml
start taskkill /f /im "showerror.exe"
start /w reloadxml.bat


::-------------------------Result--------------------------------------
:PASS
start taskkill /f /im "showerror.exe"
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 1