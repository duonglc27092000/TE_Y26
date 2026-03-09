::--------------------------------Set Env-------------------------------------------
@echo off
:start
cd /d %~dp0
set retry_cycle=2
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
::----------------------------------------------------------------------------------
if @%MODELFAMILY%==@4PD0WJ01N001 GOTO PASS
if @%MODELFAMILY%==@4PD0WJ01K001 GOTO PASS
if @%MODELFAMILY%==@4PD0WJ01J001 GOTO PASS
if @%MODELFAMILY%==@4PD0WJ01G001 GOTO PASS


:Num
NumLockLED_API.exe Numlock_off
showerror.exe NumLED.jpg
call :Get_Random
set num=%num%
set times=0

:Num_Test
NumLockLED_API.exe Numlock_on >NUL
PING 127.0.0.1 -n 1 >NUL
NumLockLED_API.exe Numlock_off >NUL
PING 127.0.0.1 -n 1 >NUL
set /a times+=1
if %times% LSS %num% goto Num_Test
call :LED_Choice %num%
if not @%return%==@1 goto Num

::-------------------------Result--------------------------------------
:PASS
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 1

REM ============================Functions================================
:LED_Choice
cd /d %~dp0
set num=%1
set return=0
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto LED_Choice
call inputnum.bat
if %ipnum% equ %num% set return=1
goto :eof

:Get_Random
if exist num.ini del NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
goto :eof
