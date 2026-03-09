::-------------------------Set Env-------------------------------------
@echo off
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

if @%MODELFAMILY%==@4PD0WJ01N001 GOTO PASS
if @%MODELFAMILY%==@4PD0WJ01K001 GOTO PASS
if @%MODELFAMILY%==@4PD0WJ01J001 GOTO PASS
if @%MODELFAMILY%==@4PD0WJ01G001 GOTO PASS


::-------------------------Function Test-------------------------------

:NUMLOCKLED
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
PING 127.0.0.1 -n 1 >NUL
set /a times+=1
if %times% LSS %num% goto NUMLOCKLED_TEST

:NUMLOCK_CHOICE
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto NUMLOCK_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto NUMLOCKLED

:PASS
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0
