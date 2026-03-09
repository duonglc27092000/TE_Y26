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
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
::-------------------------Function Test-------------------------------

if not @%FINGERPRINT%==@  goto pass

:POWER_Button_TEST
wDiagLed64.exe /setpower 0 >NUL
PING 127.0.0.1 -n 1
wDiagLed64.exe /setpower 1 >NUL

ShowErrorYN.EXE CheckLightleak.jpg LightLeak.bat 1
call LightLeak.bat
if @%CODE%==@Y goto pass

::-------------------------Result--------------------------------------
:FAIL
exit /b 1

:PASS
exit /b 0