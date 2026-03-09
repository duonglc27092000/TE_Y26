::-------------------------Set Env-------------------------------------
@echo off
:START
cd /d %~dp0
set retry_cycle=5
set name=%~n0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::-------------------------Function Test-------------------------------
::-----------------------MTDL INT-----------------------------------------
set Cmdline="pwrtest.exe"
set BatchFile=%~dp0%name%.Bat
set Function=test
set Process=mfg
set Type=Power_board
set TestID=0X1A00
set TestID1=NA
set TestID2=NA
set TestResponse="S3/CS/MS Test PassedS3/CS/MS Test Passed"
set TestResponse1="test pass"
set TestResponse2="test pass"
CALL D:\BURNIN\NEWMTDL\GetNowTime.bat
set StartTime=%TimeFormat%
cd /d %~dp0
::-----------------------MTDL INT-----------------------------------------

set CurDrv=%~dp0

:S3
REM ======SFCS S3 SMART START========
SET LEVEL_S=1
SET S3QTY=1
CALL D:\BURNIN\SMART\StartSMART.BAT S3
SET /A S3QTY=%S3QTY%*%LEVEL_S%
IF %S3QTY% EQU 0 (SET /A S3QTY=1)
cd /d %~dp0

CALL S3.BAT %S3QTY%

REM =======END S3 SMART===============
CALL D:\BURNIN\SMART\EndSMART.BAT S3 OK
REM =======END S3 SMART===============


goto pass
::-------------------------Result--------------------------------------
:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat FAIL %name% %S3QTY% %spec2% %spec3% %ERR_CODE%
exit /b 1

:PASS
set name=%~n0
CD /D D:\BURNIN\NEWMTDL\RUNIN
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
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %S3QTY% %spec2% %spec3% %ERR_CODE%
exit /b 0