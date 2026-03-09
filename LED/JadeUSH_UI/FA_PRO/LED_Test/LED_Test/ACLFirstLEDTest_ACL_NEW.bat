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
if exist D:\LOG\FirstLED.OK del D:\LOG\FirstLED.OK
if exist LED.LOG del LED.LOG
if exist D:\FA_PRO\LCD\LCDLight\Light0.jpg del D:\FA_PRO\LCD\LCDLight\Light0.jpg
if exist D:\FA_PRO\LCD\LCDLight\Light100.jpg del D:\FA_PRO\LCD\LCDLight\Light100.jpg
if exist D:\FA_PRO\LCD\LCDLight\capture_light0.ok del D:\FA_PRO\LCD\LCDLight\capture_light0.ok
if exist D:\FA_PRO\LCD\LCDLight\capture_light100.ok del D:\FA_PRO\LCD\LCDLight\capture_light100.ok
if exist D:\FA_PRO\LCD\LCDLight\captureDone0.ok del D:\FA_PRO\LCD\LCDLight\captureDone0.ok
if exist D:\FA_PRO\LCD\LCDLight\captureDone100.ok del D:\FA_PRO\LCD\LCDLight\captureDone100.ok
if exist D:\FA_PRO\TouchPad\TP_Program\lefttest.ok del D:\FA_PRO\TouchPad\TP_Program\lefttest.ok

::-------------------------Function Test-------------------------------------
::-------------------------Turn on CAM LED-------------------------------------
start /min D:\FA_PRO\Disable_touchscreen\disable.bat 
:CAMERA_LED
cd /d %~dp0
start /min opencamera.bat
if exist SetVol_X64.exe SetVol_X64.exe SPK Unmute
nircmdc.exe setsysvolume2 65555 65555

::-------------------------Turn on CAM LED-------------------------------------

:FixError
cd /d %~dp0
REM =====FOR XDP SKU=====================
rem ====S/T for DM unknown YB issue ==========
DEVCON64.EXE -r remove "ROOT\DBUtilDrv2"
rem ====for fix PLATCFG TOOL error  ==========


:OpenMFG
cd /d %~dp0
MfgMode64W.exe +cmm +famm +LCMM
PING 127.0.0.1 -n 1 >NUL 
:ShowSN
rem start LCDTest.exe
start /min D:\FA_PRO\LED_Auto\QRCode\ShowSN_LED_ACL_NEW.bat

:OPENTP
cd /d D:\FA_PRO\TouchPad\TP_Program
START /min autoaudio.bat
START TP_Program_ACL_NEW.py KB
cd /d %~dp0

:CloseNvdiaPanel
tasklist|find /i "NVDisplay.Container.exe" & if not errorlevel 1 taskkill /f /t /im "NVDisplay.Container.exe"

::-------Set LCD Light--------
:SetLCD
Bright2.exe /set 20
REM Mouse_Click.exe 1200 0

echo ================================================First LED Log================================================== >>LED.LOG
call :write_log "Start Run"
::-------------------------Close ALL LED------------------------

cd /d %~dp0

:Turn on LED
wDiagLed64.exe /setkbbl 0 >>LED.LOG
wDiagLed64.exe /setbt 1 >>LED.LOG
python KB_LED_Test.py ON

::power led (FP)
if not @%fingerprint%==@ (
wDiagLed64.exe /setpower_FP 1 >>LED.LOG
wDiagLed64.exe /setpower_FP 1 >>LED.LOG
) else (
wDiagLed64.exe /setpower 1 >>LED.LOG
wDiagLed64.exe /setpower 1 >>LED.LOG
)

::charge white
wDiagLed64.exe /setbt 1

::Open CapsLock LED
::CapsLED_API.exe CAP_ON >>LED.LOG
::wDiagLed64.exe /setcap 1 >>LED.LOG
::Open Charge LED

::Close keyboard background light LED
::PlatCfg64w.exe -w Keyboard_Illumination:off
::Open power button LED
::if not @%fingerprint%==@ (
::wDiagLed64.exe /setpower_FP 1 >>LED.LOG
::ping 127.0.0.1 -n 2
::wDiagLed64.exe /setpower_FP 1 >>LED.LOG
::) else (
::wDiagLed64.exe /setpower 1 >>LED.LOG
::ping 127.0.0.1 -n 2
::wDiagLed64.exe /setpower 1 >>LED.LOG
::)
::Open F4 LED
::PlatCfg64W.exe -w Global_mic_mute_status:disable >>LED.LOG
::wDiagLed64.exe /setF4 1 >>LED.LOG
::start D:\FA_PRO\AUDIO\MIC\SetVol_X64.exe MIC Mute
::start D:\FA_PRO\AUDIO\MIC\SetVol_X64.exe MIC Mute
::Open NumLock LED
::NumLockLED_API.exe Numlock_on >>LED.LOG
::if exist OpenLED.bat start /min OpenLED.bat
call :write_log "End Run"
echo ================================================================================================================ >>LED.LOG


::------------Get TP Key Word----------
:GetTPInfo
IF EXIST D:\FA_PRO\TouchPad\TP_Program\lefttest.ok GOTO PASS
goto GetTPInfo

::-------------------------Result--------------------------------------
:PASS
ECHO OK>D:\LOG\FirstLED.OK
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
exit /b 0

::-------------------------------------Show LED Test QRCode---------------------------------------------
:ShowSN_LED
tasklist|find /i "QR_ShowForTouch.exe" & if not errorlevel 1 taskkill /f /t /im "QR_ShowForTouch.exe"
if not @%fingerprint%==@ (
start QR_ShowForTouch.exe %SVCTAG%_%KEYBL%_FP
) else (
start QR_ShowForTouch.exe %SVCTAG%_%KEYBL%
)
goto :eof

REM ============================Write test log================================
:write_log
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