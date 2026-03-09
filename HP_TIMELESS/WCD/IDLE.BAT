::-------------------------Set Env-------------------------------------
@echo off
:START
cd /d %~dp0
set retry_cycle=2
set name=%~n0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::-----------------------MTDL INT-----------------------------------------
set acount=0
:TEST1
rem =========IDLE===================
ping 127.0.0.1 -n 120
rem =========MS===================
pwrtest64.exe /cs /p:150 /d:150 /c:1
REM ----------------------- End & Clear Temporary Data ---------------

:Retry
set /a acount=acount+1
IF %acount% GEQ %retry_cycle% goto PASS
GOTO TEST1 

:PASS
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %S3QTY% %spec2% %spec3% %ERR_CODE%
exit /b 0