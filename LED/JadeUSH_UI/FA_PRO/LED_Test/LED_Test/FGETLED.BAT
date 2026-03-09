@ECHO OFF
:START

cd /d %~dp0
call D:\SFCS\INFO.BAT

IF @%SFCSPPID:~0,3%==@481 SET SVCTAG=%SFCSPPID%
IF @%SFCSPPID:~0,3%==@491 SET SVCTAG=%SFCSPPID%

echo %SVCTAG%^|LEDTEST>USNPPID.TXT

REM =============GET WEB IP=================================
cd /d %~dp0

:GETIP
if exist web_ip.txt del web_ip.txt
set Web_IP=NA
ipconfig /all | find /i "Default Gateway . . . . . . . . . : 1">Web_IP.txt
for /f "tokens=13 delims= " %%i in (Web_IP.txt) do set Web_IP=%%i
if %Web_IP%==NA goto getIP
REM =============GET WEB IP=================================

ECHO ===================================
ECHO  ***  Get LED Test Result ... ***
ECHO ===================================
set Count=0

:STARGET
GetDataToFile64.exe %Web_IP% GETUSNINFOLIST USNPPID.TXT LED_RESULT.log
if errorlevel 1 goto GETNG
find /I "LEDTEST=Pass" LED_RESULT.LOG
if not errorlevel 1 goto PASS
GOTO FAIL

:GETNG
set /a Count+=1
if %Count% LSS 3 goto STARGET

:FAIL
EXIT /B 1

:PASS
exit /b 0
