::-------------------------Set Env-------------------------------------
@echo off
:start
cd /d %~dp0
set acount=0
set retry_cycle=5
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::--------------------------------------------------------------------------

REM ====================================================
REM OpenKBL.BAT / V1.0 / 2022/08/24 / Owen Gu
REM  Open KB Background Lights when it auto turn off
REM ====================================================

::----------------------------Open KB Lights-----------------------------------
:OpenKBL
set /a acount+=1
if %acount% gtr 5 goto pass
wDiagLed64.exe /setkbbl 4
ping 127.0.0.1 -n 2
goto OpenKBL

::-------------------------Result--------------------------------------
:PASS
exit

:FAIL
exit
