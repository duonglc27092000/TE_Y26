::-------------------------Set Env-------------------------------------
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

::-------------------------Check the first group LED test result----------------------------
:CheckResult
if exist D:\LOG\FirstLED.OK goto pass

::-------------------------Set MFG model----------------------------
:OpenMFG
MfgMode64W.exe +CMM +FAMM

::-------------------------Close ALL LED------------------------
:CloseLED
::Close CapsLock LED
CapsLED_API.exe OFF
:F4LED
REM PlatCfg64W.exe -w Global_mic_mute_status:disable >NUL
wDiagLed64.exe /setf4 0 >NUL
::Close Charge LED
wDiagLed64.exe /setbt 0
::Close keyboard background light LED
wDiagLed64.exe /setkbbl 0
::Close power button LED
if @%fingerprint%==@ (
wDiagLed64.exe /setpower 0
)

:Manual_Check
if exist result.bat del result.bat
showerrorYN.exe CloseAllLED.jpg result.bat
if not exist result.bat goto Manual_Check
call result.bat
if @%code%==@Y (
echo LED off status have been retested >> D:\TEST_UI\Retest.log
goto pass
)
goto start

::-------------------------Result--------------------------------------
:PASS
MfgMode64W.exe -CMM
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