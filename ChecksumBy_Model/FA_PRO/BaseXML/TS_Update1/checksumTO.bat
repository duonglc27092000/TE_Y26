@ECHO ON
cd /d %~dp0

set count=0
:START
findstr "PARTNO=" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat > GET_PARTNO.BAT
call GET_PARTNO.BAT
IF NOT @%PARTNO%==@  GOTO NETCONN

:NETCONN
set /a count+=1
if %count% geq 6 GOTO FAIL
IF EXIST P:\NUL GOTO NEXT
CALL D:\BURNIN\Link\Link_net.BAT
cd /d %~dp0
GOTO NETCONN

:NEXT
SET DRV=D:
SET DRV1=D:
python Ckeck_Sum.py P:\%PARTNO% %DRV1%\
if errorlevel 1 goto NETCONN


:END
copy D:\TEST_UI\Runin.xml D:\TEST_UI\Modelname.xml /y
start D:\start.bat
exit /b 0

:fail
echo FAIL :((((((((((((((((((((((((((((((
exit /b 1


