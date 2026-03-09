::-------------------------Set Env-------------------------------------
@echo off
:START
cd /d %~dp0
set retry_cycle=15
set name=%~n0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::-------------------------Function Test-------------------------------
MfgMode64W.exe +CMM
:CAPSLED
CapsLED_API.exe off >NUL
PING 127.0.0.1 -n 1
showerror.exe CAPSLED.JPG

if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set times=0

:CAPS_TEST
CapsLED_API.exe on >NUL
PING 127.0.0.1 -n 2 >NUL
CapsLED_API.exe off >NUL
PING 127.0.0.1 -n 2 >NUL
set /a times+=1
if %times% LSS %num% goto CAPS_TEST

:CAPS_CHOICE

if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto CAPS_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto CAPSLED


:F4LED
wDiagLed64.exe /setf4 0 >NUL
rem PlatCfg64W.exe -w Global_mic_mute_status:disable
showerror.exe F4LED.jpg

if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set times=0

:F4LED_TEST
wDiagLed64.exe /setf4 1 >NUL
PING 127.0.0.1 -n 1 >NUL
wDiagLed64.exe /setf4 0 >NUL
PING 127.0.0.1 -n 1 >NUL
set /a times+=1
if %times% LSS %num% goto F4LED_TEST

:F4_Button_CHOICE
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto F4_Button_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto F4LED

::--------------Power LED(°×µÆ) TEST-----------------------
:POWER_W_LED
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
PING 127.0.0.1 -n 2 >NUL
set /a times+=1
if %times% LSS %num% goto POWER_W_TEST

:POWER_W_CHOICE
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto POWER_W_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto POWER_W_LED


::--------------Power LED(»ÆµÆ) TEST-----------------------
:POWER_Y_LED
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
PING 127.0.0.1 -n 2 >NUL
set /a times+=1
if %times% LSS %num% goto POWER_Y_TEST

:POWER_Y_CHOICE
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto POWER_Y_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto POWER_Y_LED
GOTO PASS

::-------------------------Result--------------------------------------
:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1

:PASS
MfgMode64W.exe -CMM
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0
