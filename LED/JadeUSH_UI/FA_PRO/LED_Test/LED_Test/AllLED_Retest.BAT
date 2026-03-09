::-------------------------Set Env-------------------------------------
@echo off
:start
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
:CheckLog
if exist D:\SFCS\SFCS_Log_Stage.bat (
call D:\SFCS\SFCS_Log_Stage.bat
) else (goto LED_ALL )
python KB_LED_RETest.py

if exist led_check1.log del led_check.log1
if exist led_check2.log del led_check.log2
echo %LEDTEST1% > led_check.log1
find /i "PASS" led_check.log1
if %errorlevel%==0 (set LEDTEST1=PASS) else (set LEDTEST1=FAIL)
echo %LEDTEST2% > led_check.log2
find /i "PASS" led_check.log2
if %errorlevel%==0 (set LEDTEST2=PASS) else (set LEDTEST2=FAIL)
if @%LEDTEST1%==@PASS if @%LEDTEST2%==@PASS GOTO PASS
IF NOT EXIST D:\FA_PRO\LED_Test\retest_item.log goto LED_ALL
find /i "F4" D:\FA_PRO\LED_Test\retest_item.log
if %errorlevel%==0 CALL F4_TEST.bat
find /i "NUM" D:\FA_PRO\LED_Test\retest_item.log
if %errorlevel%==0 CALL NUM_TEST.bat
find /i "CAPS" D:\FA_PRO\LED_Test\retest_item.log
if %errorlevel%==0 CALL CAPS_TEST.bat
find /i "CHARGE" D:\FA_PRO\LED_Test\retest_item.log
if %errorlevel%==0 CALL CHARGELED.bat
find /i "POWER" D:\FA_PRO\LED_Test\retest_item.log
if %errorlevel%==0 CALL POWERBUTTON_TEST.bat
@REM find /i "CHARGEW" D:\FA_PRO\LED_Test\retest_item.log
@REM if %errorlevel%==0 CALL :CHARGEW_NG
@REM find /i "CHARGEY" D:\FA_PRO\LED_Test\retest_item.log
@REM if %errorlevel%==0 CALL :CHARGEY_NG
find /i "KBBL" D:\FA_PRO\LED_Test\retest_item.log
if %errorlevel%==0 CALL KBBL.bat
echo ALLLED Have been Retested >> D:\TEST_UI\Retest.log


::-------------------------Result--------------------------------------
:PASS
cd /d %~dp0
MfgMode64W.exe -CMM
set spec1=0000
set spec2=0000
set spec3=0000
echo ======================================================== >>D:\FA_PRO\LED_Test\%svctag%.log
date /t >>D:\FA_PRO\LED_Test\%svctag%.log
time /t >>D:\FA_PRO\LED_Test\%svctag%.log
echo Second LED Retest pass >>D:\FA_PRO\LED_Test\%svctag%.log
echo ======================================================== >>D:\FA_PRO\LED_Test\%svctag%.log
call D:\log\testlog.bat PASS %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0


:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1
:LED_ALL
call D:\FA_PRO\LED_Test\LED_Test.bat
CALL KBBL.bat
GOTO PASS
goto :eof
