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
if exist D:\LOG\SecondLED.OK del D:\LOG\SecondLED.OK

::------------CapsLock LED----------
:CAPLED_ON
CapsLED_API.exe ON

::---------------Charge White LED------------
:ChargeLED_White
wDiagLed64.exe /setbt 1

::---------------F4 LED------------
:F4LED
REM PlatCfg64W.exe -w Global_mic_mute_status:enable >NUL
wDiagLed64.exe /setf4 1 >NUL
::---------------Numlock LED------------
:Numlock_led
NumLockLED_API.exe Numlock_on >NUL

:PWR_LED_W
::----------------power button white LED-----------------
if @%fingerprint%==@ (
wDiagLed64.exe /setpower 1
)

::------------Get Result Key Word----------
:GetResultKey
cd /d %~dp0
call GetKBInfo.bat
ECHO %VkCode% >LCD2.log
if @%VkCode%==@D GOTO PASS
if @%VkCode%==@F GOTO FAIL
GOTO FAIL

::-------------------------Result--------------------------------------
:PASS
if exist D:\FA_PRO\Common_PlayNoiseSpk\Common_PlayNoiseSpk.py start python D:\FA_PRO\Common_PlayNoiseSpk\Common_PlayNoiseSpk.py
ECHO OK>D:\LOG\SecondLED.OK
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