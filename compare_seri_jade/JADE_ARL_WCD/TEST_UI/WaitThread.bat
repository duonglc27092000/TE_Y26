@echo off
if @%1==@ (exit /b 1)
 
:waitT
if exist %1 (exit /b 0)
echo Wait %1 End!
echo Wait %1 End!
ping 127.0.0.1 -n 2
goto waitT
exit /b 1
