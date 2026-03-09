::-------------------------Set Env-------------------------------------
@echo off
:START
cd /d %~dp0
set retry_cycle=2
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
setlocal enabledelayedexpansion
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::----------------------------------------------------------------------
if exist D:\LOG\FirstLED.OK del D:\LOG\FirstLED.OK
if exist D:\LOG\SecondLED.OK del D:\LOG\SecondLED.OK
if exist D:\LOG\ThirdLED.OK del D:\LOG\ThirdLED.OK

REM ====================================================
REM GetLEDTestResult.BAT / V1.1 / 2023/11/07 / Owen Gu
REM Get LED Auto Test Result
REM ====================================================

::---------------------------------Main-----------------------------------------
:GetLEDTestResult
:LEDTEST1
call :GETIP
call :CreatPostData LEDTEST1
call :GetLEDResult %Web_IP% LEDTEST1
if @%Return%==@0 (ECHO OK>D:\LOG\FirstLED.OK) else (ECHO NG>D:\LOG\FirstLED.NG)
:LEDTEST2
call :CreatPostData LEDTEST2
call :GetLEDResult %Web_IP% LEDTEST2
if @%Return%==@0 (ECHO OK>D:\LOG\SecondLED.OK) else (ECHO NG>D:\LOG\SecondLED.NG)
:LEDTEST3
call :CreatPostData LEDTEST3
call :GetLEDResult %Web_IP% LEDTEST3
if @%Return%==@0 (ECHO OK>D:\LOG\ThirdLED.OK) else (ECHO NG>D:\LOG\ThirdLED.NG)
goto pass
::------------------------------------------------------------------------------

REM =======================Creat Post Data=========================
:CreatPostData
cd /d %~dp0
set LED_Group=%1
if exist %LED_Group%.txt del %LED_Group%.txt
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if defined SVCTAG (
echo %SVCTAG%^|%LED_Group% >%LED_Group%.txt
)else (
call D:\FA_PRO\BaseXML\GetSfcsInfo\GetSfcsInfo.bat
goto CreatPostData
)
goto :eof

REM ============================Get Server IP==============================
:GETIP
cd /d %~dp0
if exist web_ip.txt del web_ip.txt
set Web_IP=NA
ipconfig /all | find /i "Default Gateway . . . . . . . . . : 1">Web_IP.txt
for /f "tokens=13 delims= " %%i in (Web_IP.txt) do set Web_IP=%%i
if %Web_IP%==NA call D:\FA_PRO\TSLinkAP\TSLinkAP.bat & goto getIP
goto :eof

REM ==========================================GET LED AUTO TEST RESULT==============================================
:GetLEDResult
cd /d %~dp0
set Web_IP=%1
set LED_Group=%2
set Return=1
if exist %LED_Group%_RESULT.log del %LED_Group%_RESULT.log
D:\FA_PRO\BaseXML\GetSfcsInfo\GetDataToFile64.exe %Web_IP% GETUSNINFOLIST %LED_Group%.txt %LED_Group%_RESULT.log
if not @%errorlevel%==@0 goto :eof 
find /i "%LED_Group%=PASS" %LED_Group%_RESULT.log
if @%errorlevel%==@0 set Return=0
goto :eof

::-------------------------Result--------------------------------------
:PASS
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1