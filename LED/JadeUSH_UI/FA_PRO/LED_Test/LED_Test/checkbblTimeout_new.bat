::-------------------------Set Env-------------------------------------
@echo off
:start
cd /d %~dp0
set retry_cycle=5
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
::--------------------------------------------------------------------------

::-------------------------Function Test-------------------------------------
:collect_info
start /min D:\FA_PRO\HWINFO\Hwinfo.py %name%


:FixError
REM =====FOR XDP SKU=====================
rem ====S/T for DM unknown YB issue ==========
DEVCON64.EXE -r remove "ROOT\DBUtilDrv2"
rem ====for fix PLATCFG TOOL error  ==========

set cycle=0
:SetTimeoutMode
if %cycle% gtr %retry_cycle% goto FAIL
MfgMode64W.exe +cmm
PlatCfg2W64.exe -set KbdBacklightTimeoutBatt=Never

:CheckTimeoutmode:
if exist timeout.log del timeout.log
PlatCfg2W64.exe -get KbdBacklightTimeoutBatt >timeout.log
find /i "Current Value : Never" timeout.log
if @%errorlevel%==@0 goto pass
ping 127.0.0.1 -n 1
set /a cycle=%cycle%+1
goto SetTimeoutMode

:PASS

::LCD Light Auto Test --20220814 by Owen Gu
start /min D:\FA_PRO\LCD\LCDLight\AutoLCDLightTest.bat 0 Light0.jpg
::Enable DFMM to detect Fn key 
MfgMode64W.exe +DFMM
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
::LCD Light Auto Test --20220814 by Owen Gu
start /min D:\FA_PRO\LCD\LCDLight\AutoLCDLightTest.bat 0 Light0.jpg
::Enable DFMM to detect Fn key 
MfgMode64W.exe +DFMM
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0