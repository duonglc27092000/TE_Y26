@ECHO OFF

cd /d %~dp0
SET S3QTY1=%1
IF @%1==@ SET S3QTY1=1
REM ----------------------- Main Program -----------------------------
:START
rem =========for MTDL START===================
set CMDPATH=%~dp0
CALL D:\BURNIN\MTDL\GetSTIME.BAT
set ITEM=S3
SET S3QTY1=20

cd /d %~dp0
REM pwrtest /sleep /s:3 /c:%S3QTY1% /h:n /d:30 /p:30 /a:y
rem pwrtest64 /sleep /s:3 /c:%S3QTY1% /h:n /d:30 /p:30 /a:y
pwrtest64.exe /cs /p:150 /d:120 /c:%S3QTY1%
REM ----------------------- End & Clear Temporary Data ---------------

Ping 127.0.0.1 -n 15
:END
rem =========for MTDL END===================
CALL D:\BURNIN\MTDL\FA_ARMS.BAT


