::-------------------------Set Env-------------------------------------
@echo off
:start
exit /b 0
cd /d D:\FA_PRO\IRCAMERA
set retry_cycle=5
set name=%~n0
set spec1=0
set spec2=0
set spec3=0
set ERR_CODE=000000
cd /d %~dp0
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::-------------------------Function Test-------------------------------
::-----------------------MTDL INT-----------------------------------------
set Cmdline="CapsLED_API.exe"
set BatchFile=%~dp0%name%.Bat
set Function=test
set Process=mfg
set Type=LED
set TestID=0X130B
set TestID1=NA
set TestID2=NA
set TestResponse="ALL LED test pass"
set TestResponse1="test pass"
set TestResponse2="test pass"
CALL D:\BURNIN\NEWMTDL\GetNowTime.bat
set StartTime=%TimeFormat%
:start
cd /d %~dp0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat

find /I "_IR" D:\SFCS\SFCS_Log_Stage.bat
if errorlevel 1 goto PASS

set acount=0
IF @%CAMERA%==@  GOTO PASS
IF @%EMZACMRA%==@Y  GOTO CHECK
IF @%IRCMRA%==@Y  GOTO CHECK
IF @%IRCMRA%==@N  GOTO PASS

:CHECK
cd /d D:\FA_PRO\IRCAMERA
set /a acount=acount+1
if %acount% gtr %retry_cycle% goto fail
IF EXIST WHWID.LOG DEL WHWID.LOG
DEVCON64.EXE hwids *>WHWID.LOG

REM =====Jade R8P09$AA $DB============
FIND /I "USB\VID_0C45&PID_6A27" WHWID.LOG
IF NOT ERRORLEVEL 1 GOTO IR20
REM =====Jade R8P09$AA $DB============

:IR10
cd D:\FA_PRO\IRCAMERA\IR10
CALL IRLEDTestTool.exe
ping 127.0.0.1 -n 2
GOTO CHECKRESULT


:IR20
cd D:\FA_PRO\IRCAMERA\IR20
start IRLEDTestTool.exe
ping 127.0.0.1 -n 2
goto CHECKRESULT

:CHECKRESULT
cd /d %~dp0
ShowErrorYN.EXE IRCAMERA_LED_RETEST.png LED_RETEST_RESULT.bat
call LED_RETEST_RESULT.bat
if @%CODE%==@Y goto pass
GOTO FAIL
::-------------------------Result--------------------------------------

:PASS
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL





call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1






