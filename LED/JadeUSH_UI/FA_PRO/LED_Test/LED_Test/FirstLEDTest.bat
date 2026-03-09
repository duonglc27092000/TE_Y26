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
if exist D:\FA_PRO\LCD\LCDLight\Liht0.jpg del D:\FA_PRO\LCD\LCDLight\Liht0.jpg
if exist D:\FA_PRO\LCD\LCDLight\Liht100.jpg del D:\FA_PRO\LCD\LCDLight\Liht100.jpg
::-------------------------Function Test-------------------------------------
:OpenMFG
MfgMode64W.exe +cmm +famm

:ShowSN
start /min D:\FA_PRO\LED_Auto\QRCode\ShowSN_LED.bat

:CloseNvdiaPanel
tasklist|find /i "NVDisplay.Container.exe" & if not errorlevel 1 taskkill /f /t /im "NVDisplay.Container.exe"

::-------Set LCD Light--------
:SetLCD
Bright2.exe /set 50
Mouse_Click.exe 1200 0

::-------------------------Close ALL LED------------------------
:CloseLED
::Close CapsLock LED
CapsLED_API.exe OFF
::Close Charge LED
wDiagLed64.exe /setbt 0
:F4LED
rem PlatCfg64W.exe -w Global_mic_mute_status:disable >NUL
PlatCfg2W64.exe -set MicMuteLed=Disabled >NUL
::Close keyboard background light LED
wDiagLed64.exe /setkbbl 0
:Numlock_led
NumLockLED_API.exe Numlock_off >NUL
::Close power button LED
if @%fingerprint%==@ (
wDiagLed64.exe /setpower 0
)


::------------Get Start Key Word----------
:GetKBInfo
cd /d %~dp0
call GetKBInfo.bat
ECHO %VkCode% >LCD1.LOG
if @%VkCode%==@D GOTO PASS
if @%VkCode%==@F GOTO FAIL
goto FAIL

::-------------------------Result--------------------------------------
:PASS
ECHO OK>D:\LOG\FirstLED.OK
::LCD Light Auto Test --20220814 by Owen Gu
start /min D:\FA_PRO\LCD\LCDLight\AutoLCDLightTest.bat 0 Light0.jpg
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
::LCD Light Auto Test --20220814 by Owen Gu
start /min D:\FA_PRO\LCD\LCDLight\AutoLCDLightTest.bat 0 Light0.jpg
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0