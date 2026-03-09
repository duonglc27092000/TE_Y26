SET ipnum=2@echo oFF
:start
set retry_cycle=5
set name=%~n0
set spec1=0
set spec2=0
set spec3=0
set ERR_CODE=000000
cd /d %~dp0
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

:POWER_W_LED
python D:\FA_PRO\Retest\retest.py LED_W_POWER
rem PlatCfg64w.exe led_button_test:0x05 >NUL
wDiagLed64.exe /setbt 0 >NUL
showerror.exe pwrled.jpg
if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set times=0

:POWER_W_TEST
wDiagLed64.exe /setbt 1 >NUL
PING 127.0.0.1 -n 1 >NUL
wDiagLed64.exe /setbt 0 >NUL
PING 127.0.0.1 -n 1 >NUL
set /a times+=1
if %times% LSS %num% goto POWER_W_TEST

:POWER_W_CHOICE
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto POWER_W_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto POWER_W_LED


:POWER_Y_LED
python D:\FA_PRO\Retest\retest.py LED_Y_POWER
rem PlatCfg64w.exe led_button_test:0x05 >NUL
wDiagLed64.exe /setbt 0 >NUL
showerror.exe chgled.jpg
if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set times=0

:POWER_Y_TEST
wDiagLed64.exe /setbt 2 >NUL
PING 127.0.0.1 -n 1 >NUL
wDiagLed64.exe /setbt 0 >NUL
PING 127.0.0.1 -n 1 >NUL

set /a times+=1
if %times% LSS %num% goto POWER_Y_TEST

:POWER_Y_CHOICE
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto POWER_Y_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto POWER_Y_LED


:PASS
echo CHARGE has been Retested >> D:\TEST_UI\Retest.log
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0


:FAIL
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat fail %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1