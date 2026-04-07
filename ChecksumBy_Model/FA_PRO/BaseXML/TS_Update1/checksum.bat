@ECHO ON
cd /d %~dp0

set count=0
:START
SET PARTNO=SentryNVRPL_UI
IF NOT @%PARTNO%==@  GOTO NETCONN

:NETCONN
set /a count+=1
if %count% geq 5 GOTO FAIL
IF EXIST P:\NUL GOTO NEXT
CALL D:\FA_PRO\BaseXML\LinkAP\LinkAP.bat
cd /d %~dp0
goto NETCONN

:NEXT
SET DRV=D:
SET DRV1=D:\
rem python Ckeck_Sum.py P:\%PARTNO%\FA_PRO %DRV%\FA_PRO
python Ckeck_Sum.py P:\%PARTNO%\WLANCOPY %DRV1%
if errorlevel 1 goto NETCONN

:END
exit /b 0

:fail
echo FAIL :((((((((((((((((((((((((((((((
exit /b 1


