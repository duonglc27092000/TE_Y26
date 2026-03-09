::-------------------------Set Env-------------------------------------
@echo off
:start
cd /d D:\FA_PRO\IRCAMERA
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::-------------------------Function Test-------------------------------
::-----------------------MTDL INT-----------------------------------------
set name=%~n0
set Cmdline="IRCamera.exe"
set BatchFile=%~dp0%name%.Bat
set Function=test
set Process=mfg
set Type=EMZA CAMERA
set TestID=0X4003
set TestID1=0X4004
set TestID2=0X4005
set TestResponse="IR Camera Build Verify Passed"
set TestResponse1="IR Camera FT test Passed"
set TestResponse2="test pass"
CALL D:\BURNIN\NEWMTDL\GetNowTime.bat
set StartTime=%TimeFormat%
cd /d D:\FA_PRO\IRCAMERA
::-----------------------MTDL INT-----------------------------------------
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
if exist d:\log\IRFAIL.log del d:\log\IRFAIL.log 
IF @%CAMERA%==@  GOTO PASS_IR
IF @%EMZACMRA%==@Y  GOTO CHECK
IF @%IRCMRA%==@Y  GOTO CHECK
IF @%IRCMRA%==@N  GOTO PASS_IR
:CHECK
cd /d D:\FA_PRO\IRCAMERA
IF EXIST WHWID.LOG DEL WHWID.LOG
DEVCON64.EXE hwids *>WHWID.LOG
REM =====Jade R8P09$AA $DB============
FIND /I "USB\VID_0C45&PID_6A27" WHWID.LOG
IF NOT ERRORLEVEL 1 GOTO IR20
REM =====Jade R8P09$AA $DB============

:IR10
CD /d IR10
START /min IRLEDTestTool.exe
ping 127.0.0.1 -n 2
GOTO CHECK_IR_RESULT

:IR20
cd D:\FA_PRO\IRCAMERA\IR20
IF EXIST Result.txt DEL Result.txt
START /min IRLEDTestTool.exe
GOTO CHECK_IR_RESULT

:CHECK_IR_RESULT
IF EXIST Result.txt (find /i "pass" Result.txt
if not errorlevel 1 (goto PASS_IR
) ELSE (GOTO FAIL_IR
)
) ELSE (GOTO CHECK_IR_RESULT
)

:PASS_IR
::Capture LCD brightness added by Tim Lai - 20240824
cd /d D:\FA_PRO\LCD\LCDLight
start Capture_LCD_Light.py
CALL D:\FA_PRO\LCD\LCDLight\AutoLCDLightCapture.bat 0 Light0.jpg

cd /d D:\FA_PRO\IRCAMERA
set name=%~n0
CD /D D:\BURNIN\NEWMTDL\AFT
IF EXIST %name%.INI DEL %name%.INI
CALL BASE_MDTL_INI.BAT %StartTime% %CmdLine% %BatchFile% %Function% %Process% %Type%

DoIni4MTDL.exe "%name%.INI" TestID %TestID% 	
DoIni4MTDL.exe "%name%.INI" TestResponse %TestResponse%

IF @%TestID1%==@NA GOTO SET_ID_END
DoIni4MTDL.exe "%name%.INI" TestID %TestID1%
DoIni4MTDL.exe "%name%.INI" TestResponse %TestResponse1%

IF @%TestID2%==@NA GOTO SET_ID_END
DoIni4MTDL.exe "%name%.INI" TestID %TestID2%
DoIni4MTDL.exe "%name%.INI" TestResponse %TestResponse2%

:SET_ID_END
cd /d %~dp0
::--------------------------Creat MTDL INI------------------------------------------

set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %spec1% %spec2% %spec3% %ERR_CODE%
start /min D:\FA_PRO\ShowRes\ShowResult.bat IR PASS 200 400
exit


:FAIL_IR
::Capture LCD brightness added by Tim Lai - 20240824
cd /d D:\FA_PRO\LCD\LCDLight
start Capture_LCD_Light.py
CALL D:\FA_PRO\LCD\LCDLight\AutoLCDLightCapture.bat 0 Light0.jpg





cd /d D:\FA_PRO\IRCAMERA
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
ECHO >d:\log\IRFAIL.log
start /min D:\FA_PRO\ShowRes\ShowResult.bat IR FAIL 200 400
exit