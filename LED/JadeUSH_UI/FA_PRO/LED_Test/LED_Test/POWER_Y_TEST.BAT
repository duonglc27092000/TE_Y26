::-------------------------Set Env-------------------------------------
@echo off
:start
cd /d %~dp0
rem cd SetMFG

rem call SetMFG.bat

cd /d %~dp0


::-----------------CAPS LED TEST----------------------

::--------------Power LED(°×µÆ) TEST-----------------------
wDiagLed64.exe /setbt 2 >NUL
PING 127.0.0.1 -n 2 >NUL

if exist Result.bat del Result.bat
ShowErrorYN.exe POWER_Y.png Result_Y.bat
call Result_Y.bat
if %CODE%==Y goto PASS

::----------------------------
::-------------------------Result--------------------------------------
:FAIL
goto start

::-------------------------Result--------------------------------------
:PASS
wDiagLed64.exe /setbt 0 >NUL
exit /b 0
