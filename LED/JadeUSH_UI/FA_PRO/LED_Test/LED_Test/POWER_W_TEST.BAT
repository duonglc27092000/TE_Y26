::-------------------------Set Env-------------------------------------
@echo off
:start
cd /d %~dp0
rem cd SetMFG

rem call SetMFG.bat

::-----------------CAPS LED TEST----------------------

::--------------Power LED(°×µÆ) TEST-----------------------

:POWER_W_TEST
cd /d %~dp0
wDiagLed64.exe /setbt 1 >NUL
PING 127.0.0.1 -n 2 >NUL

if exist Result.bat del Result.bat
ShowErrorYN.exe POWER_W.png Result_W.bat
call Result_W.bat
if %CODE%==Y goto PASS


::----------------------------
::-------------------------Result--------------------------------------
:FAIL
GOTO START

::-------------------------Result--------------------------------------
:PASS
wDiagLed64.exe /setbt 0 >NUL
exit /b 0
