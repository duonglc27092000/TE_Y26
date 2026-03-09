::-------------------------Set Env-------------------------------------
@echo off
:start

call D:\Config\cfg.bat


::-----------------CAPS LED TEST----------------------

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
PING 127.0.0.1 -n 1 >NUL
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
PING 127.0.0.1 -n 1 >NUL
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
GOTO PASS

::-------------------------Result--------------------------------------
:FAIL
exit /b 1

:PASS
exit /b 0
