::-------------------------Set Env-------------------------------------
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
if exist D:\LOG\ThirdLED.OK del D:\LOG\ThirdLED.OK
::--------------------------------------------------------------------------

echo ================================================Third LED Log=================================================== >>LED.LOG
call :write_log "Start Run"

:OPEN_IR_CAMERA_LED
::start /min IR_CAMERA_LED_TEST.BAT
::Capture LCD brightness added by Tim Lai - 20240824
cd /d D:\FA_PRO\LCD\LCDLight
start Capture_LCD_Light.py
CALL D:\FA_PRO\LCD\LCDLight\AutoLCDLightCapture.bat 0 Light0.jpg
cd /d %~dp0



echo control charge y on
:ChargeLED_Y
ping 127.0.0.1 -n 1
Platcfg2W64.exe -set LEDButtonTest=0x04 >>LED.LOG

python KB_LED_Test.py OFF

::---------------KB Backgroud Light LED------------
:KBL
echo control kbbl on
echo start >LED.LOG
IF NOT @%KEYBL%==@NBL (
PlatCfg2W64.exe -set KeyboardIllumination=Bright >>LED.LOG
)

::Close CapsLock LED
::CapsLED_API.exe CAP_OFF >>LED.LOG
::wDiagLed64.exe /setcap 0 >>LED.LOG


::Close F4 LED
::PlatCfg64W.exe -w Global_mic_mute_status:disable >>LED.LOG
::wDiagLed64.exe /setF4 0 >>LED.LOG
::Close NumLock LED
::NumLockLED_API.exe Numlock_OFF >>LED.LOG

call :write_log "End Run"
echo ================================================================================================================ >>LED.LOG

::------------Get TP Key Word----------
:GetTPInfo
IF EXIST D:\FA_PRO\TouchPad\TP_Program\righttest.ok GOTO PASS
goto GetTPInfo

::-------------------------Result--------------------------------------
:PASS
PlatCfg2W64.exe -set KeyboardIllumination=Disabled
ECHO OK>D:\LOG\SECOND.OK
::LCD Light Auto Test --20220814 by Owen Gu
CALL D:\FA_PRO\LCD\LCDLight\AutoLCDLightCapture.bat 100 Light100.jpg
tasklist|find /i "QRCodeUI.EXE" & if not errorlevel 1 taskkill /f /t /im "QRCodeUI.EXE"
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
PlatCfg2W64.exe -set KeyboardIllumination=Disabled
::LCD Light Auto Test --20220814 by Owen Gu
CALL D:\FA_PRO\LCD\LCDLight\AutoLCDLightCapture.bat 100 Light100.jpg
tasklist|find /i "QRCodeUI.EXE" & if not errorlevel 1 taskkill /f /t /im "QRCodeUI.EXE"
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

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
echo %cd%
goto :eof