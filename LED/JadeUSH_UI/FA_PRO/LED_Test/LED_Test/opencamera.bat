@echo off
:start
cd /d %~dp0
if not exist D:\FA_PRO\TouchPad\TP_Program\lefttest.ok del D:\FA_PRO\TouchPad\TP_Program\lefttest.ok
start /min Camera.exe


:wait_turn_off
if not exist D:\FA_PRO\TouchPad\TP_Program\lefttest.ok goto wait_turn_off
tasklist | find /i "Camera.exe" & if not errorlevel 1 taskkill /f /t /im "Camera.exe"

:end
exit


