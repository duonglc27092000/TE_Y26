::-------------------------Set Env-------------------------------------
@echo off
:start
cd /d %~dp0
set retry_cycle=15
set name=%~n0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::-------------------------Function Test-------------------------------
::--------------Init----------
set acount=0
:test
set Model=SentryNVRPL_UI
goto HDDUP
set /a acount=acount+1
if %acount% gtr %retry_cycle% goto fail
ping 127.0.0.1 -n 2

COPY P:\%Model%\WLANCOPY\HDDVER.BAT D:\config\ /y
if not "%errorlevel%"=="0" goto test

call d:\config\hddver.bat
SET VER1=%VER%
call D:\hddver.bat
IF @%VER1%==@%VER% GOTO CopyEQU

:HDDUP
SET DRV=D:
XCOPY P:\%Model%\WLANCOPY\. %DRV%\. /E /Y /F /D
rem if not "%errorlevel%"=="0" goto test

:CopyEQU
XCOPY P:\Online\. C:\Users\Administrator\Desktop\. /E /Y /F /D


goto pass


::-------------------------Result--------------------------------------
:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat fail %name% %Model% %ModelEQU% %spec3% %ERR_CODE%
exit /b 1

:PASS
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %Model% %ModelEQU% %spec3% %ERR_CODE%
exit /b 0