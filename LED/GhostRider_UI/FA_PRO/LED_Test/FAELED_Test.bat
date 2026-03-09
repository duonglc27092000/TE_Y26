::-------------------------Set Env-------------------------------------
@echo on
:start
set retry_cycle=5
set name=%~n0
set spec1=0
set spec2=0
set spec3=0
set ERR_CODE=000000
cd /d %~dp0
call D:\log\testlog.bat start %name% %spec1% %spec2% %spec3% %ERR_CODE%
IF EXIST D:\SFCS\INFO.BAT call D:\SFCS\INFO.BAT
REM for platcfg2.exe  command line usage as below 
REM Set Charge LED to White : Platcfg2W64.exe -set LEDButtonTest=0x03
REM Set Charge LED to Orange : Platcfg2W64.exe -set LEDButtonTest=0x04
REM Set Charge LED to OFF : Platcfg2W64.exe -set LEDButtonTest:0x05
REM Turn on MicMute F4 LED : Platcfg2W64.exe -set MicMuteLed=Enabled
REM Turn off MicMute F4 LED : Platcfg2W64.exe -set MicMuteLed=Disabled
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
MfgMode64W.exe +CMM +FAMM

rem IF @%KB_PN%==@ GOTO POWER_W_LED

::-----------------------MTDL INT-----------------------------------------
::-------------------------DVT1 XDP BYPASS KEYBOADR-------------------------------
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
ping 127.0.0.1 -n 1
IF @%MO%==@000044125519 goto POWER_W_LED
IF @%MO%==@000044125589 goto POWER_W_LED
IF @%MO%==@000044125525 goto POWER_W_LED
IF @%MO%==@000044196233 goto POWER_W_LED
IF @%MO%==@000044196240 goto POWER_W_LED
IF @%MO%==@000044196244 goto POWER_W_LED
::--------------------------------------------------------
:POWER_W_LED
rem PlatCfg64w.exe led_button_test:0x05 >NUL
REM wDiagLed64.exe /setbt 0 >NUL
Platcfg2W64.exe -set LEDButtonTest=0x05 >NUL
showerror.exe pwrWled.jpg

if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set times=0

:POWER_W_TEST
rem PlatCfg64w.exe led_button_test:0x03 >NUL
rem PING 127.0.0.1 -n 1 >NUL
rem PlatCfg64w.exe led_button_test:0x05 >NUL
REM wDiagLed64.exe /setbt 1 >NUL
Platcfg2W64.exe -set LEDButtonTest=0x03 >NUL
PING 127.0.0.1 -n 2 >NUL
Platcfg2W64.exe -set LEDButtonTest=0x05 >NUL
PING 127.0.0.1 -n 2 >NUL
set /a times+=1
if %times% LSS %num% goto POWER_W_TEST

:POWER_W_CHOICE


if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto POWER_W_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto POWER_W_LED

::--------------Power LED( ׵ ) TEST-----------------------


::--------------Power LED( Ƶ ) TEST-----------------------

goto pass
::-------------------------Result--------------------------------------
:FAIL
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat fail %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1

:PASS
::--------------------------Creat MTDL INI------------------------------------------
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
cd /d %~dp0
MfgMode64W.exe +SFMM +FAMM -CMM +OSMM 
::--------------------------Creat MTDL INI------------------------------------------
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0
