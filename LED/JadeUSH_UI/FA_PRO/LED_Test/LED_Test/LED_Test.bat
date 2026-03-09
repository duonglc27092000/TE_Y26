::-------------------------Set Env-------------------------------------
@echo off
:CheckReboot
cd /d %~dp0
if exist D:\LOG\1.TXT (
echo reboot2 >D:\LOG\2.TXT
)else (
echo reboot1 >D:\LOG\1.TXT
)

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
call D:\log\testlog.bat start %name% %spec1% %spec2% %spec3% %ERR_CODE%
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
::-----------------------MTDL INT-----------------------------------------
::-------------------------Function Test-------------------------------
if @%KB_PN%==@  goto POWER_W_LED
MfgMode64W.exe +SFMM +FAMM +CMM +OSMM

:CAPSLED
CapsLED_API.exe off >NUL
PING 127.0.0.1 -n 1
echo 请按任意键开始测试CAPS灯！！
echo 请按任意键开始测试CAPS灯！！
showerror.exe CAPSLED.JPG

if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set times=0

:CAPS_TEST
CapsLED_API.exe on >NUL
PING 127.0.0.1 -n 1 >NUL
CapsLED_API.exe off >NUL
PING 127.0.0.1 -n 1 >NUL
set /a times+=1
if %times% LSS %num% goto CAPS_TEST

:CAPS_CHOICE
ECHO 请输入CAPS LED灯闪烁的次数！！
ECHO 请输入CAPS LED灯闪烁的次数！！

if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto CAPS_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto CAPSLED

::--------------F4 LED(白灯) TEST-----------------------
:F4LED
wDiagLed64.exe /setf4 0 >NUL
echo 请按任意键开始测试F4灯！！
echo 请按任意键开始测试F4灯！！
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
ECHO 请输入F4灯闪烁的次数！！
ECHO 请输入F4灯闪烁的次数！！

if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto F4_Button_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto F4LED

::--------------NUMLOCKLED LED(白灯) TEST-----------------------
call NumLockLED.bat

::--------------Power LED(白灯) TEST-----------------------
:POWER_W_LED
wDiagLed64.exe /setbt 0 >NUL
echo 请按任意键开始测试充电白灯！！
echo 请按任意键开始测试充电白灯！！
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
ECHO 请输入充电白灯闪烁的次数！！
ECHO 请输入充电白灯闪烁的次数！！

if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto POWER_W_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto POWER_W_LED


::--------------Power LED(黄灯) TEST-----------------------
:POWER_Y_LED
wDiagLed64.exe /setbt 0 >NUL
echo 请按任意键开始测试充电黄灯！！
echo 请按任意键开始测试充电黄灯！！
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
ECHO 请输入充电黄灯闪烁的次数！！
ECHO 请输入充电黄灯闪烁的次数！！

if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto POWER_Y_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto POWER_Y_LED

::--------------Power BUTTON(白灯) TEST-----------------------
IF NOT @%FINGERPRINT%==@  GOTO PASS
:POWER_BUTTON_TEST
cd /d %~dp0
wDiagLed64.exe /setpower 1
PING 127.0.0.1 -n 2 >NUL

if exist Result.bat del Result.bat
ShowErrorYN.exe POWER_BUTTON.png Result_W.bat
call Result_W.bat
if %CODE%==Y goto PASS

GOTO POWER_Y_CHOICE

::--------------Power BUTTON(白灯) TEST-----------------------


:POWERButton
wDiagLed64.exe /setpower 0 >NUL
showerror.exe pwrBTled.jpg

if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set times=0

:POWER_Button_TEST
wDiagLed64.exe /setpower 1 >NUL
PING 127.0.0.1 -n 1 >NUL
wDiagLed64.exe /setpower 0 >NUL
PING 127.0.0.1 -n 2 >NUL
set /a times+=1
if %times% LSS %num% goto POWER_Button_TEST

:POWER_Button_CHOICE
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto POWER_Button_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto POWERButton
goto pass



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
::--------------------------Creat MTDL INI------------------------------------------
MfgMode64W.exe -CMM
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
exit /b 0
