::-------------------------Set Env--------------------------------------
@echo off
:start
cd /d %~dp0
set retry_cycle=5
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
if exist D:\LOG\SecondLED.OK del D:\LOG\SecondLED.OK
::----------------------------------------------------------------------

::--------------------------------Status LED-------------------------------
:: LED:      LCD   Caps   F4   Num    Power   Change W   Charge O   KB BL
:: Status1:  50%   On     On   On     On      On         NA         Off
:: Status2:  0%    Off    Off  Off    NA      NA         On         On    
::-------------------------------------------------------------------------
:Status2
::LCD 0%
Bright2.exe /set 0
::Caps Off
CapsLED_API.exe CAP_OFF
CapsLED_API.exe OFF
::F4 Off
wDiagLed64.exe /setF4 0
::Num Off
NumLockLED_API.exe Numlock_Off
::Power NA
::Change W NA
::Charge O On
wDiagLed64.exe /setbt 2
::KB BL On
wDiagLed64.exe /setkbbl 1
start /min OpenKBL.bat
::PlatCfg2W64.exe -set KbdBacklightTimeoutAc=Never

::------------Get Test Key Word----------
:GetKBInfo
cd /d %~dp0
KB_HookTest.exe

::-------------------------Result--------------------------------------
:PASS
Bright2_x64.exe /set 100
ping 127.0.0.1 -n 1
Bright2_x64.exe /set 100
start taskkill /f /t /im "QRCodeUI.exe"
start taskkill /f /t /im "WhiteLCD.exe"
::KBBLTimeout10s
::start PlatCfg2W64.exe -set KbdBacklightTimeoutAc=10s
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
Bright2_x64.exe /set 100
ping 127.0.0.1 -n 1
Bright2_x64.exe /set 100

start taskkill /f /t /im "QRCodeUI.exe"
start taskkill /f /t /im "WhiteLCD.exe"
::KBBLTimeout10s
::start PlatCfg2W64.exe -set KbdBacklightTimeoutAc=10s
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

REM ============================Write test log================================
:write_log
cd /d %~dp0
safetime.exe /g >curtime.bat
call curtime.bat
set current_datetime=%datetime%
set content_log_path=%~dp0
set script_name=%~n0
set LowDataName=%content_log_path%%script_name%.log
set info=%1
set details=%2
echo %info%
if not @%details%==@ (
set log=%current_datetime% %script_name% %info% %details%
) else (
set log=%current_datetime% %script_name% %info%
)
echo %log% >>%LowDataName%
goto :eof