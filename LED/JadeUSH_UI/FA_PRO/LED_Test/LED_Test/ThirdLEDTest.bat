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
::---------------KB Backgroud Light LED------------
:KBL
IF NOT @%KEYBL%==@NBL (
wDiagLed64.exe /setkbbl 4 >>LED.LOG
::turn on KB Light again when it turn off automatically
if exist OpenKBL.bat start /min OpenKBL.bat
)

:ChargeLED_Y
wDiagLed64.exe /setbt 2 >>LED.LOG
call :write_log "End Run"
echo ================================================================================================================ >>LED.LOG

::------------Get Result Key Word----------
:GetResultKey
cd /d %~dp0
call GetKBInfo.bat
echo Get ThirdLED KB Key is %VkCode% >>GetLEDResult.log
if @%VkCode%==@D GOTO PASS
if @%VkCode%==@F GOTO FAIL
GOTO FAIL


::-------------------------Result--------------------------------------
:PASS
cd /d %~dp0
MfgMode64W.exe -cmm

ECHO OK>D:\LOG\ThirdLED.OK
::LCD Light Auto Test --20220814 by Owen Gu
call D:\FA_PRO\LCD\LCDLight\AutoLCDLightTest.bat 100 Light100.jpg
tasklist|find /i "QRCodeUI.EXE" & if not errorlevel 1 taskkill /f /t /im "QRCodeUI.EXE"
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
::LCD Light Auto Test --20220814 by Owen Gu
call D:\FA_PRO\LCD\LCDLight\AutoLCDLightTest.bat 100 Light100.jpg
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
goto :eof