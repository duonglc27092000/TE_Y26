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
if exist D:\sfcs\info.bat call D:\sfcs\info.bat
IF @%CAMERA%==@ GOTO PASS

find /I "_N-camera" D:\SFCS\SFCS_Log_Stage.bat
if errorlevel 1 goto PASS

:OpenCam
set /a acount=acount+1
if %acount% gtr %retry_cycle% goto FAIL
start microsoft.windows.camera:
goto CHECKRESULT

:CHECKRESULT
ShowErrorYN.EXE CAMERA_LED_RETEST.png CAMLED_RETEST_RESULT.bat
taskkill /im WindowsCamera.exe /t /f
call CAMLED_RETEST_RESULT.bat
if @%CODE%==@Y goto pass
ping 127.0.0.1 -n 3
GOTO OpenCam

:PASS
call D:\log\testlog.bat PASS %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1
