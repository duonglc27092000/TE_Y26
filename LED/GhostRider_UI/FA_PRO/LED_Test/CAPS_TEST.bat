::-------------------------Set Env-------------------------------------
@echo off
:start

IF EXIST D:\Config\cfg.bat call D:\Config\cfg.bat


::-----------------CAPS LED TEST----------------------
:CAPSLED
cd /d %~dp0
CapsLED_API.exe off >NUL
PING 127.0.0.1 -n 1
echo  밴       ʼ    CAPS ƣ   
echo  밴       ʼ    CAPS ƣ   
showerror.exe CAPSLED.JPG

if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set times=0

:CAPS_TEST
CapsLED_API.exe cap_on >NUL
PING 127.0.0.1 -n 1 >NUL
CapsLED_API.exe cap_off >NUL
PING 127.0.0.1 -n 2 >NUL
set /a times+=1
if %times% LSS %num% goto CAPS_TEST

:CAPS_CHOICE
ECHO       CAPS LED    ˸ Ĵ       
ECHO       CAPS LED    ˸ Ĵ       

if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto CAPS_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto CAPSLED

GOTO PASS

::-------------------------Result--------------------------------------
:FAIL
exit /b 1

:PASS
exit /b 0
