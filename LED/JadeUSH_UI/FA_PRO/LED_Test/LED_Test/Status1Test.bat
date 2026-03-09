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
if exist D:\LOG\FirstLED.OK del D:\LOG\FirstLED.OK
if exist D:\FA_PRO\LCD\LCDLight\Liht0.jpg del D:\FA_PRO\LCD\LCDLight\Liht0.jpg
if exist D:\FA_PRO\LCD\LCDLight\Liht100.jpg del D:\FA_PRO\LCD\LCDLight\Liht100.jpg
::----------------------------------------------------------------------------------

::--------------------------------Function Test-------------------------------------
:FixError
REM =====FOR XDP SKU=====================
rem ====S/T for DM unknown YB issue ==========
DEVCON64.EXE -r remove "ROOT\DBUtilDrv2"
rem ====for fix PLATCFG TOOL error  ==========

:OpenMFG
MfgMode64W.exe +cmm

:ShowWhiteScreen
start WhiteLCD.exe

:ShowSN
start /min D:\FA_PRO\LED_Auto\QRCode\ShowSN_LED.bat

:CloseNvdiaPanel
start taskkill /f /t /im "NVDisplay.Container.exe"

:MouseMove
Mouse_Click.exe 1200 0

::--------------------------------Status LED-------------------------------
:: LED:      LCD   Caps   F4   Num    Power   Charge W   Charge O   KB BL
:: Status1:  50%   On     On   On     On      On         NA         Off
:: Status2:  0%    Off    Off  Off    NA      NA         On         On    
::-------------------------------------------------------------------------
:Status1
::LCD 50%
Bright2.exe /set 50
::Caps On
CapsLED_API.exe CAP_ON
CapsLED_API.exe ON
::F4 On
wDiagLed64.exe /setF4 1
::Num On
NumLockLED_API.exe Numlock_On
::Power On
if @%fingerprint%==@ (
wDiagLed64.exe /setpower 1
) else (
wDiagLed64.exe /setpower_FP 1
)
::Change W On
wDiagLed64.exe /setbt 1
::Charge O NA
::KB BL Off
wDiagLed64.exe /setkbbl 0

::------------Get Test Key Word----------
:GetKBInfo
cd /d %~dp0
KB_HookTest.exe

::-------------------------Result--------------------------------------
:PASS
if exist D:\FA_PRO\Common_PlayNoiseSpk\Common_PlayNoiseSpk.py start python D:\FA_PRO\Common_PlayNoiseSpk\Common_PlayNoiseSpk.py
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
if exist D:\FA_PRO\Common_PlayNoiseSpk\Common_PlayNoiseSpk.py start python D:\FA_PRO\Common_PlayNoiseSpk\Common_PlayNoiseSpk.py
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