@echo off
cd /d %~dp0

:START
MFGMODE64W.EXE +FAMM -CMM
PING 127.0.0.1 -n 1 

:END
