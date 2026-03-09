@ECHO OFF

cd /d %~dp0
SET S4QTY1=%1
IF @%1==@ SET S4QTY1=1
REM ----------------------- Main Program -----------------------------
:START
rem =========for MTDL START===================
set CMDPATH=%~dp0
CALL D:\BURNIN\MTDL\GetSTIME.BAT
set ITEM=S4
cd /d %CMDPATH%
CLS

::==A00 C/R====
rem PwrTest /sleep /s:4 /c:100 /d:40 /p:30
::======

CLS
PwrTest /sleep /s:4 /c:20 /d:40 /p:30
ping 127.0.0.1 -n 5 >nul

REM ----------------------- End & Clear Temporary Data ---------------

:END
rem =========for MTDL END===================
CALL D:\BURNIN\MTDL\FA_ARMS.BAT
