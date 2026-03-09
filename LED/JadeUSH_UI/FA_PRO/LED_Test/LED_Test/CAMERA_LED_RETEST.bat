@echo oFF
:start
set retry_cycle=5
set name=%~n0
set spec1=0
set spec2=0
set spec3=0
set ERR_CODE=000000
cd /d %~dp0
call D:\log\testlog.bat start %name% %spec1% %spec2% %spec3% %ERR_CODE%
::-------------------------Function Test-------------------------------
::-----------------------MTDL INT-----------------------------------------
set Cmdline="CapsLED_API.exe"
set BatchFile=%~dp0%name%.Bat
set Function=test
set Process=mfg
set Type=LED
set TestID=0X130B
set TestID1=NA
set TestID2=NA
set TestResponse="ALL LED test pass"
set TestResponse1="test pass"
set TestResponse2="test pass"
CALL D:\BURNIN\NEWMTDL\GetNowTime.bat
set StartTime=%TimeFormat%
if exist D:\FA_PRO\TouchPad\TP_Program\lefttest.ok del D:\FA_PRO\TouchPad\TP_Program\lefttest.ok /Q

if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
IF @%CAMERA%==@  GOTO END
find /I "_N-camera" D:\SFCS\SFCS_Log_Stage.bat
if errorlevel 1 goto END

:TEST
cd /d %~dp0
start /min python Camera_Led.py
ping 127.0.0.1 -n 2

:CHECKRESULT
ShowErrorYN.EXE CAMERA_LED_RETEST.png LED_RETEST_RESULT.bat
call LED_RETEST_RESULT.bat
if @%CODE%==@Y goto pass
GOTO FAIL

:PASS
cd /d D:\FA_PRO\TouchPad\TP_Program
python Kill_Camera_Led.py
cd /d %~dp0
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0


:FAIL
cd /d D:\FA_PRO\TouchPad\TP_Program
python Kill_Camera_Led.py
cd /d %~dp0
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat fail %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1

:END
cd /d %~dp0
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0