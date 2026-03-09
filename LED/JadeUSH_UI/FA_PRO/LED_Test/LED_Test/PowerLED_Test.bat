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
REM call D:\log\testlog.bat start %name% %spec1% %spec2% %spec3% %ERR_CODE%
rem call D:\SFCS\INFO.BAT
::-------------------------Function Test-------------------------------

::--------------Power BUTTON(白灯) TEST-----------------------
:POWERButton
wDiagLed64.exe /setpower 0 >NUL
echo 请按任意键开始测试电源灯！！
echo 请按任意键开始测试电源灯！！
showerror.exe chgled.jpg

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
ECHO 请输入电源灯闪烁的次数！！
ECHO 请输入电源灯闪烁的次数！！

if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto POWER_Button_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto POWER_Button_LED
GOTO PASS

::-------------------------Result--------------------------------------
:FAIL
exit /b 1

:PASS
exit /b 0
