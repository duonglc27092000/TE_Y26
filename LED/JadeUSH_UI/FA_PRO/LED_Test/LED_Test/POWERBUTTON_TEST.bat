@echo off
:start
set retry_cycle=5
set name=%~n0
set spec1=0
set spec2=0
set spec3=0
set ERR_CODE=000000
cd /d %~dp0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
call D:\log\testlog.bat start %name% %spec1% %spec2% %spec3% %ERR_CODE%
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
cd /d %~dp0
::------------

IF NOT @%FINGERPRINT%==@  GOTO PASS
:POWER_BUTTON_TEST
cd /d %~dp0
wDiagLed64.exe /setpower 1
PING 127.0.0.1 -n 2 >NUL

if exist Result.bat del Result.bat
ShowErrorYN.exe POWER_BUTTON.png Result_W.bat
call Result_W.bat
if %CODE%==Y goto PASS

:FAIL
exit /b 1

:PASS
echo POWER has been Retested >> D:\TEST_UI\Retest.log
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0
