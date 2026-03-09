@echo off

:START
cd /d %~dp0
setlocal enabledelayedexpansion
set retry_cycle=5
set acount=0
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%

=======================================================================
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
IF @%CAMERA%==@  GOTO PASS
if @%LATTICEBD%==@Y goto PASS
IF @%MIPI%==@Y  goto pass
IF @%MIPI%==@N  GOTO PASS

find /I "_IR" D:\SFCS\SFCS_Log_Stage.bat
if errorlevel 1 goto PASS

IF @%CAMERA%==@  GOTO PASS
if @%LATTICEBD%==@Y goto PASS
IF @%MIPI%==@Y  goto pass
IF @%MIPI%==@N  GOTO PASS
IF @%IRCMRA%==@Y  GOTO Test

:Test
cd /d D:\FA_PRO\IRCAMERA
START /W UIAutomation_IQCapture.exe -n:5 -c:1500
ping 127.0.0.1 -n 2
goto CHECKRESULT

:CHECKRESULT
cd /d %~dp0
ShowErrorYN.EXE IRCAMERA_LED_RETEST.png IRLED_RETEST_RESULT.bat
call IRLED_RETEST_RESULT.bat
tasklist | findstr UIAutomation_IQCapture.exe
if not errorlevel 1 taskkill /im UIAutomation_IQCapture.exe /f 
if @%CODE%==@Y goto pass
GOTO Check

:PASS
call D:\log\testlog.bat PASS %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1
