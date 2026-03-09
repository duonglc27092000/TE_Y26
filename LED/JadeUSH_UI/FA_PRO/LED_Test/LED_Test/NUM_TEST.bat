@echo oFF
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

if @%MODELFAMILY%==@4PD0VJ010001 GOTO PASS
if @%MODELFAMILY%==@4PD0VJ01B001 GOTO PASS
if @%MODELFAMILY%==@4PD0VJ01E001 GOTO PASS
if @%MODELFAMILY%==@4PD0VJ01F001 GOTO PASS

:NUMLOCKLED
python D:\FA_PRO\Retest\retest.py LED_NUM
NumLockLED_API.exe Numlock_off
showerror.exe NumLED.jpg

if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set times=0

:NUMLOCKLED_TEST
NumLockLED_API.exe Numlock_on >NUL
PING 127.0.0.1 -n 2 >NUL
NumLockLED_API.exe Numlock_off >NUL
PING 127.0.0.1 -n 2 >NUL
set /a times+=1
if %times% LSS %num% goto NUMLOCKLED_TEST

:NUMLOCK_CHOICE
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto NUMLOCK_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto NUMLOCKLED

:PASS
echo NUM has been Retested >> D:\TEST_UI\Retest.log
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0


:FAIL
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat fail %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1