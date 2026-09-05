:: copy chuong trinh 
:start
if EXIST GET_PARTNO.BAT del GET_PARTNO.BAT
findstr "PARTNO=" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat > GET_PARTNO.BAT
call GET_PARTNO.BAT
echo %PARTNO%
if not defined PARTNO goto end
set count=0
:NETCONN
set /a count+=1
if %count% geq 6 GOTO FAIL
IF EXIST P:\NUL GOTO NEXT
CALL D:\FA_PRO\BaseXML\LinkAP\LinkAP.bat
cd /d %~dp0
GOTO NETCONN

:NEXT
cd /d %~dp0
if EXIST P:\%PARTNO%\WLANCOPY\FA_PRO\TimeZone copy P:\%PARTNO%\WLANCOPY\FA_PRO\TimeZone\* D:\FA_PRO\TimeZone\ /y
if EXIST P:\%PARTNO%\WLANCOPY\FA_PRO\Disable_touchscreen copy P:\%PARTNO%\WLANCOPY\FA_PRO\Disable_touchscreen\* D:\FA_PRO\Disable_touchscreen\ /y

D:\TEST_UI\SendMsg.exe 1 reloadxml
:end
exit 