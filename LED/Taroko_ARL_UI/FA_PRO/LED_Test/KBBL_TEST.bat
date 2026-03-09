@echo oFF
:start
set retry_cycle=5
set name=%~n0
set spec1=0
set spec2=0
set spec3=0
set ERR_CODE=000000
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
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
if @%KEYBL%==@NBL GOTO PASS
:KBBL_LED
python D:\FA_PRO\Retest\retest.py KB_BL
rem PlatCfg64W.exe -w Global_mic_mute_status:disable
wDiagLed64.exe /setkbbl 0 >NUL
showerror.exe D:\FA_PRO\KBLIGHT\kblight.jpg

if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i

if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set ping=%%i
set times=0

:KBBL_TEST
wDiagLed64.exe /setkbbl 4 >NUL
PING 127.0.0.1 -n 1 >NUL
wDiagLed64.exe /setkbbl 0 >NUL
PING 127.0.0.1 -n %ping%
set /a times+=1
if %times% LSS %num% goto KBBL_TEST

:KBBL_Button_CHOICE
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto F4_Button_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto KBBL_LED

:PASS
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0


:FAIL
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat fail %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1