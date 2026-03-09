::-------------------------Set Env-------------------------------------
@echo off
:start
cd /d %~dp0
::-----------------------MTDL INT-----------------------------------------
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
IF @%CAMERA%==@  GOTO PASS

:CAMERA_LED
cd /d %~dp0
START /min python Camera_Led.py
ping 127.0.0.1 -n 2
GOTO PASS

:PASS
exit