@echo on

:START
cd /d %~dp0
set retry_cycle=5
set name=%~n0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
if exist D:\SFCS\SFCS_Log_Stage.bat call D:\SFCS\SFCS_Log_Stage.bat
if exist D:\FA_PRO\RGB\LCDBLACK.log del D:\FA_PRO\RGB\LCDBLACK.log 
if exist D:\FA_PRO\RGB\LCDWHITE.log del D:\FA_PRO\RGB\LCDWHITE.log 
if exist D:\FA_PRO\RGB\LCDRED.log del D:\FA_PRO\RGB\LCDRED.log 
if exist D:\FA_PRO\RGB\LCDBLUE.log del D:\FA_PRO\RGB\LCDBLUE.log 
if exist D:\FA_PRO\RGB\LCDGREEN.log del D:\FA_PRO\RGB\LCDGREEN.log

::find /i "A4A" D:\TEST_UI\LINE.DAT
::if "%errorlevel%"=="0" if exist D:\FA_PRO\RGBAuto\rgb_retest_data.json del D:\FA_PRO\RGBAuto\rgb_retest_data.json 
::find /i "A4B" D:\TEST_UI\LINE.DAT
::if "%errorlevel%"=="0" if exist D:\FA_PRO\RGBAuto\rgb_retest_data.json del D:\FA_PRO\RGBAuto\rgb_retest_data.json 
::find /i "A5A" D:\TEST_UI\LINE.DAT
::if "%errorlevel%"=="0" if exist D:\FA_PRO\RGBAuto\rgb_retest_data.json del D:\FA_PRO\RGBAuto\rgb_retest_data.json 
::find /i "A5B" D:\TEST_UI\LINE.DAT
::if "%errorlevel%"=="0" if exist D:\FA_PRO\RGBAuto\rgb_retest_data.json del D:\FA_PRO\RGBAuto\rgb_retest_data.json 
::find /i "A5C" D:\TEST_UI\LINE.DAT
::if "%errorlevel%"=="0" if exist D:\FA_PRO\RGBAuto\rgb_retest_data.json del D:\FA_PRO\RGBAuto\rgb_retest_data.json 
::find /i "A5D" D:\TEST_UI\LINE.DAT
::if "%errorlevel%"=="0" if exist D:\FA_PRO\RGBAuto\rgb_retest_data.json del D:\FA_PRO\RGBAuto\rgb_retest_data.json 

set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
if exist RGB.OK DEL RGB.OK

cd RGB_Retest_Display_Color
goto RGB_OLD
IF NOT EXIST RGB_Retest_Display_Color_New.py goto RGB_OLD

find /i "A4A" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" goto RGB_NEW
find /i "A4B" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" goto RGB_NEW
find /i "A5A" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" goto RGB_NEW
find /i "A5B" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" goto RGB_NEW
find /i "A5C" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" goto RGB_NEW
find /i "A5D" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" goto RGB_NEW

goto RGB_OLD
:RGB_NEW
python RGB_Retest_Display_Color_New.py
ping 127.0.0.1 -n 1
IF EXIST rgb_retest_result.bat (
find /i "Y" rgb_retest_result.bat
if not errorlevel 1 goto end 
)
goto NG

:RGB_OLD
python RGB_Retest_Display_Color.py
ping 127.0.0.1 -n 1
IF EXIST rgb_retest_result.bat (
find /i "Y" rgb_retest_result.bat
if not errorlevel 1 goto end 
)

:NG
echo 123
ping 127.0.0.1 -n 3
call d:\Error_QR_Code\Error_Code.bat ND04 LCD lines
goto START
goto NG


:End
echo result is pass
call D:\log\testlog.bat PASS %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0