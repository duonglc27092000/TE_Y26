::-------------------------Set Env-------------------------------------
@echo off
:START
cd /d %~dp0
set retry_cycle=2
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
setlocal enabledelayedexpansion
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::----------------------------------------------------------------------

REM ====================================================
REM UpAutoTestLog.BAT / V1.0 / 2021/09/13 / Owen Gu
REM Upload auto test log to server
REM ====================================================

REM ======================Upload auto test log start========================
:CheckLine

:UpAutoTestLog
call :CheckNetWork
call :GetDateTime
call :UpAutoSPKLog
call :UpRetestLog
::call :TPlog
call :UpLCDRGBLog
call :UpLEDLog
call :UpCSVLog
goto pass

REM ======================Check NetWork========================
:CheckNetWork
if not exist M:\nul call D:\BURNIN\Link\Link_net.bat
ipconfig|find /i " Default Gateway . . . . . . . . . : 1"> IP.TXT
if errorlevel 1 goto CheckNetWork
for /f "tokens=2 delims=:" %%a in (ip.txt) do echo %%a>ip.tmp
for /f "tokens=1 delims= " %%a in (ip.tmp) do set Server_IP=%%a
if @%Server_IP%==@ goto CheckNetWork
cd /d %~dp0
goto :eof

REM =============Get date & time=================================
:GetDateTime
tzutil /s "SE Asia Standard Time"
SAFETIME.EXE /g >CurrentTime.bat
call CurrentTime.bat
set date1=%DATETIME:~0,4%
set date2=%DATETIME:~5,2%
set date3=%DATETIME:~8,2%
set time1=%DATETIME:~11,2%
set time2=%DATETIME:~14,2%
set time3=%DATETIME:~17,2%
set CurDate=%date1%%date2%%date3%
set CurTime=%time1%%time2%%time3%
set CurTime1=%time1%:%time2%
set MODEL=%MODEL: =%
goto :eof


REM =====================Upload speaker and mic auto test log=========================
:UpAutoSPKLog
IF NOT EXIST M:\AFTAUDIO MD M:\AFTAUDIO
IF NOT EXIST M:\AFTAUDIO\%MODEL% MD M:\AFTAUDIO\%MODEL%
IF NOT EXIST M:\AFTAUDIO\%MODEL%\%CurDate% MD M:\AFTAUDIO\%MODEL%\%CurDate%
ping 127.0.0.1 -n 3
if exist D:\Log\AudioLog.txt copy D:\Log\AudioLog.txt M:\AFTAUDIO\%MODEL%\%CurDate%\%SVCTAG%.txt /y
goto :eof

:TPlog
IF NOT EXIST M:\TP_TEST_LOG MD M:\TP_TEST_LOG
IF NOT EXIST M:\TP_TEST_LOG\%MODEL% MD M:\TP_TEST_LOG\%MODEL%
IF NOT EXIST M:\TP_TEST_LOG\%MODEL%\%CurDate%\%SVCTAG% MD M:\TP_TEST_LOG\%MODEL%\%CurDate%\%SVCTAG%
ping 127.0.0.1 -n 3
if exist D:\FA_PRO\TouchPad\TP_Program\TP_Test_Result.txt copy D:\FA_PRO\TouchPad\TP_Program\TP_Test_Result.txt M:\TP_TEST_LOG\%MODEL%\%CurDate%\%SVCTAG%\ /y
if exist D:\FA_PRO\TouchPad\TP_Program\TP_Test.jpg copy D:\FA_PRO\TouchPad\TP_Program\TP_Test.jpg M:\TP_TEST_LOG\%MODEL%\%CurDate%\%SVCTAG%\ /y
if exist D:\FA_PRO\TouchPad\TP_Program\TP_Test_Logs.txt copy D:\FA_PRO\TouchPad\TP_Program\TP_Test_Logs.txt M:\TP_TEST_LOG\%MODEL%\%CurDate%\%SVCTAG%\ /y
goto :eof

REM ===========================Upload all retest log===============================
:UpRetestLog
echo LEGO > D:\LOG\%SVCTAG%.txt
if exist D:\FA_PRO\IOTEST\LinkIO\Result.bat call D:\FA_PRO\IOTEST\LinkIO\Result.bat
IF NOT EXIST M:\LEGORetestLOG\%MODEL%\%CurDate%\FAIL MD M:\LEGORetestLOG\%MODEL%\%CurDate%\FAIL
IF NOT EXIST M:\LEGORetestLOG\%MODEL%\%CurDate%\PSensor MD M:\LEGORetestLOG\%MODEL%\%CurDate%\PSensor
ping 127.0.0.1 -n 3
if exist D:\LOG\AudioLog.txt copy D:\LOG\AudioLog.txt M:\LEGORetestLOG\%MODEL%\%CurDate%\FAIL\%SVCTAG%.txt /y
if exist D:\LOG\%SVCTAG%.txt copy D:\LOG\%SVCTAG%.txt M:\LEGORetestLOG\%MODEL%\%CurDate%\%SVCTAG%.txt /y
if exist D:\TEST_UI\Retest.log copy D:\TEST_UI\Retest.log M:\LEGORetestLOG\%MODEL%\%CurDate%\%SVCTAG%.txt /y
if @%PSENSOR%==@Y echo PSENSOR >%SVCTAG%.txt
if exist %SVCTAG%.txt copy %SVCTAG%.txt M:\LEGORetestLOG\%MODEL%\%CurDate%\PSensor /y
goto :eof

:UpLCDLightLog
IF NOT EXIST M:\LCDLightLog\%MODEL%\%CurDate%\FAIL MD M:\LCDLightLog\%MODEL%\%CurDate%\FAIL
IF NOT EXIST M:\LCDLightLog\%MODEL%\%CurDate%\PASS MD M:\LCDLightLog\%MODEL%\%CurDate%\PASS
IF EXIST D:\Log\LCDLight.ok (
IF EXIST D:\FA_PRO\LCD\LCDLight\%SVCTAG%.txt COPY D:\FA_PRO\LCD\LCDLight\%SVCTAG%.txt M:\LCDLightLog\%MODEL%\%CurDate%\PASS /Y
)ELSE (
IF EXIST D:\FA_PRO\LCD\LCDLight\%SVCTAG%.txt COPY D:\FA_PRO\LCD\LCDLight\%SVCTAG%.txt M:\LCDLightLog\%MODEL%\%CurDate%\FAIL /Y
)
goto :eof

:UpPSensorLog
IF @%PSENSOR%==@N goto :eof
IF EXIST D:\Log\PSensorTest.OK (
IF NOT EXIST M:\PSensorLog\%MODEL%\%CurDate%\PASS\%SVCTAG% MD M:\PSensorLog\%MODEL%\%CurDate%\PASS\%SVCTAG%
IF EXIST D:\FA_PRO\PSensor\config\*.txt COPY D:\FA_PRO\PSensor\config\*.txt M:\PSensorLog\%MODEL%\%CurDate%\PASS\%SVCTAG% /Y
)ELSE (
IF NOT EXIST M:\PSensorLog\%MODEL%\%CurDate%\FAIL\%SVCTAG% MD M:\PSensorLog\%MODEL%\%CurDate%\FAIL\%SVCTAG%
IF EXIST D:\FA_PRO\PSensor\config\*.txt COPY D:\FA_PRO\PSensor\config\*.txt M:\PSensorLog\%MODEL%\%CurDate%\FAIL\%SVCTAG% /Y
)
goto :eof

:UpLCDRGBLog
IF NOT EXIST M:\LCDRGBLog\%MODEL%\%CurDate% MD M:\LCDRGBLog\%MODEL%\%CurDate%
IF EXIST D:\FA_PRO\LCD\%svctag%.log COPY D:\FA_PRO\LCD\%svctag%.log M:\LCDRGBLog\%MODEL%\%CurDate% /Y
goto :eof

:UpLEDLog
IF NOT EXIST M:\LEDLog\%MODEL%\%CurDate%\tool MD M:\LEDLog\%MODEL%\%CurDate%\tool
IF NOT EXIST M:\LEDLog\%MODEL%\%CurDate%\time MD M:\LEDLog\%MODEL%\%CurDate%\time
IF NOT EXIST M:\LEDLog\%MODEL%\%CurDate%\result MD M:\LEDLog\%MODEL%\%CurDate%\result
IF NOT EXIST M:\LEDLog\%MODEL%\%CurDate%\retest MD M:\LEDLog\%MODEL%\%CurDate%\retest
IF EXIST D:\FA_PRO\LED_Test\LED.log (
COPY D:\FA_PRO\LED_Test\LED.log M:\LEDLog\%MODEL%\%CurDate%\tool\%svctag%.log /Y
)
IF EXIST D:\FA_PRO\LED_Test\GetLEDResult.log (
COPY D:\FA_PRO\LED_Test\GetLEDResult.log M:\LEDLog\%MODEL%\%CurDate%\result\%svctag%.log /Y
)
IF EXIST D:\FA_PRO\LED_Test\FirstLEDTest.log IF EXIST D:\FA_PRO\LED_Test\SecondLEDTest.log IF EXIST D:\FA_PRO\LED_Test\ThirdLEDTest.log (
copy D:\FA_PRO\LED_Test\FirstLEDTest.log+D:\FA_PRO\LED_Test\SecondLEDTest.log+D:\FA_PRO\LED_Test\ThirdLEDTest.log M:\LEDLog\%MODEL%\%CurDate%\time\%svctag%.log /Y 
)
::---------------------------------------Recording LED retest log---------------------------------------------
if exist D:\FA_PRO\LED_Test\%SVCTAG%.log (
copy D:\FA_PRO\LED_Test\%SVCTAG%.log M:\LEDLog\%MODEL%\%CurDate%\retest /y
)
::------------------------------------------------------------------------------------------------------------
goto :eof

REM ===========================Upload csv log===============================
:UpCSVLog
call D:\SFCS\info.bat
set MODEL=%MODEL: =%
echo %Model%
call :GetFIX_ID
set FIXID=%FIXID%
echo %FIXID%
call :Get_Line
set Line=%Line%
echo %Line%
rem if not exist M:\Auto_Machine_Retest_Log\%CurDate% md M:\Auto_Machine_Retest_Log\%CurDate%
if exist AutoTestLog.csv del AutoTestLog.csv

call :CountNG_ITEM
echo !RESULT!
if @%RESULT%==@FAIL (
echo !NG_F4!
echo !NG_NUM!
echo !NG_CAPS!
echo !NG_CHARGE!
echo !NG_POWER!
echo !NG_WHITE!
echo !NG_YELLOW!
echo !NG_KBLIGHT!
echo !NG_IR!
echo !NG_N-CAMERA!
echo !NG_USB20!
echo !NG_USB30!
echo !NG_HDMI!
echo !NG_SD!
echo !NG_TYPEC!
echo !NG_AUDIO!
echo !NG_MiniDP!
echo !NG_RGB!
echo !NG_BlackEdge!
echo !NG_TP!
echo !NG_KB!
echo !NG_TouchPanel!
echo !NG_TouchPen!
echo !NG_SN!
echo !NG_Camerashadow!
echo !NG_Marketingname!
echo !NG_Speaker!
echo !NG_TBT!
echo !NG_DOCKING!
echo !NG_TPHAPTIC!
echo !NG_FANNOISE!
echo !NG_SENSOR!

echo SN,Model,FIXID,Line,Result,NG_F4,NG_NUM,NG_CAPS,NG_CHARGE,NG_POWER,NG_WHITE,NG_YELLOW,NG_KBLIGHT,NG_IR,NG_N_CAMERA,NG_USB20,NG_USB30,NG_HDMI,NG_SD,NG_TYPEC,NG_AUDIO,NG_MiniDP,NG_RGB,NG_BlackEdge,NG_TP,NG_KB,NG_TouchPanel,NG_TouchPen,NG_SN,NG_Camerashadow,NG_Marketingname,NG_Speaker,NG_TBT,NG_DOCKING,NG_TPHAPTIC,NG_FANNOISE,NG_SENSOR,Date,Time >AutoTestLog.csv
echo %SVCTAG%,%MODEL%,%FIXID%,%Line%,!RESULT!,!NG_F4!,!NG_NUM!,!NG_CAPS!,!NG_CHARGE!,!NG_POWER!,!NG_WHITE!,!NG_YELLOW!,!NG_KBLIGHT!,!NG_IR!,!NG_N-CAMERA!,!NG_USB20!,!NG_USB30!,!NG_HDMI!,!NG_SD!,!NG_TYPEC!,!NG_AUDIO!,!NG_MiniDP!,!NG_RGB!,!NG_BlackEdge!,!NG_TP!,!NG_KB!,!NG_TouchPanel!,!NG_TouchPen!,!NG_SN!,!NG_Camerashadow!,!NG_Marketingname!,!NG_Speaker!,!NG_TBT!,!NG_DOCKING!,!NG_TPHAPTIC!,!NG_FANNOISE!,!NG_SENSOR!,%CurDate%,%CurTime1% >>AutoTestLog.csv
) else (
call :GetFIX_ID
set FIXID=!FIXID!
echo !FIXID!
call :Get_Line
set Line=!Line!
echo !Line!
echo SN,Model,FIXID,Line,Result,NG_F4,NG_NUM,NG_CAPS,NG_CHARGE,NG_POWER,NG_WHITE,NG_YELLOW,NG_KBLIGHT,NG_IR,NG_N_CAMERA,NG_USB20,NG_USB30,NG_HDMI,NG_SD,NG_TYPEC,NG_AUDIO,NG_MiniDP,NG_RGB,NG_BlackEdge,NG_TP,NG_KB,NG_TouchPanel,NG_TouchPen,NG_SN,NG_Camerashadow,NG_Marketingname,NG_Speaker,NG_TBT,NG_DOCKING,NG_TPHAPTIC,NG_FANNOISE,NG_SENSOR,Date,Time >AutoTestLog.csv
echo %SVCTAG%,%MODEL%,%FIXID%,%Line%,!RESULT!,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%CurDate%,%CurTime1% >>AutoTestLog.csv
)

if not exist M:\AudioLoop_Retest_Time\%CurDate% md M:\AudioLoop_Retest_Time\%CurDate%
if not exist M:\AudioLoop_Retest_Time\%CurDate%\AudioLoop_Retest_Time.csv (
echo Unit S/N,Model,FIXID,Line,Retest Time,Date,Time >M:\AudioLoop_Retest_Time\%CurDate%\AudioLoop_Retest_Time.csv
)
if exist D:\FA_PRO\AudioLoop\retest_time.bat (
call D:\FA_PRO\AudioLoop\retest_time.bat
set retest_time=!retest_time: =!
echo !retest_time!
echo %SVCTAG%,%model%,%fixid%,!line!,!retest_time!,%CurDate%,%CurTime1% >>M:\AudioLoop_Retest_Time\%CurDate%\AudioLoop_Retest_Time.csv
)

::uploadlog to database Online_upload_retest_data_to_db.exe IPaddress csv 
if exist AutoTestLog.csv if exist Online_upload_retest_data_to_db.exe start /min Online_upload_retest_data_to_db.exe %Server_IP% AutoTestLog.csv
goto :eof

:CountNG_ITEM
set RESULT=PASS
set NG_F4=
set NG_NUM=
set NG_CAPS=
set NG_CHARGE=
set NG_POWER=
set NG_WHITE=
set NG_YELLOW=
set NG_KBLIGHT=
set NG_IR=
set NG_N-CAMERA=
set NG_USB20=
set NG_USB30=
set NG_HDMI=
set NG_SD=
set NG_TYPEC=
set NG_AUDIO=
set NG_MiniDP=
set NG_RGB=
set NG_BlackEdge=
set NG_TP=
set NG_KB=
set NG_TouchPanel=
set NG_TouchPen=
set NG_SN=
set NG_Camerashadow=
set NG_Marketingname=
set NG_Speaker=
set NG_TBT=
set NG_DOCKING=
set NG_TPHAPTIC=
set NG_FANNOISE=
set NG_SENSOR=

if not exist D:\SFCS\SFCS_Log_Stage.bat goto :eof
if not exist D:\FA_PRO\IOTEST\IoTestResult.OK goto :eof
::F4 LED
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "_F4" D:\SFCS\SFCS_Log_Stage.bat
if @%errorlevel%==@0 set RESULT=FAIL & set NG_F4=F4

::NUM LED
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "_NUM" D:\SFCS\SFCS_Log_Stage.bat
if @%errorlevel%==@0 set RESULT=FAIL & set NG_NUM=NUM

::CAPS LED
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "_CAPS" D:\SFCS\SFCS_Log_Stage.bat
if @%errorlevel%==@0 set RESULT=FAIL & set NG_CAPS=CAPS

::CHARGE LED
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "_CHARGE" D:\SFCS\SFCS_Log_Stage.bat
if @%errorlevel%==@0 set RESULT=FAIL & set NG_CHARGE=CHARGE

::POWER LED
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "_POWER" D:\SFCS\SFCS_Log_Stage.bat
if @%errorlevel%==@0 set RESULT=FAIL & set NG_POWER=POWER

::WHITE LED
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "_WHITE" D:\SFCS\SFCS_Log_Stage.bat
if @%errorlevel%==@0 set RESULT=FAIL & set NG_WHITE=WHITE

::YELLOW LED
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "_YELLOW" D:\SFCS\SFCS_Log_Stage.bat
if @%errorlevel%==@0 set RESULT=FAIL & set NG_YELLOW=YELLOW

::KBLIGHT LED
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "_KBLIGHT" D:\SFCS\SFCS_Log_Stage.bat
if @%errorlevel%==@0 set RESULT=FAIL & set NG_KBLIGHT=KBLIGHT

::IR LED
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "_IR" D:\SFCS\SFCS_Log_Stage.bat
if @%errorlevel%==@0 set RESULT=FAIL & set NG_IR=IR

::N-CAMERA LED
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "_N-CAMERA" D:\SFCS\SFCS_Log_Stage.bat
if @%errorlevel%==@0 set RESULT=FAIL & set NG_N-CAMERA=N-CAMERA

::USB20 IO
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "USB" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_USB20=USB20

::USB30 IO
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "USB" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_USB30=USB30

::HDMI IO
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "HDMI" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_HDMI=HDMI

::SD IO
if exist D:\FA_PRO\IOTEST\IoTestResult.OK find /i "SD" D:\FA_PRO\IOTEST\IoTestResult.OK | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_SD=SD

::TYPEC IO
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "TYPEC" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_TYPEC=TYPEC

::TBT IO
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "TBT" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_TBT=TBT

::DOCKING IO
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "DOCKING" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_DOCKING=DOCKING

::TPHAPTIC
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "TPHAPTIC" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_TPHAPTIC=TPHAPTIC

::FANNOISE
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "FANNOISE" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_FANNOISE=FANNOISE

::SENSOR
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "SENSOR" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_TYPEC=SENSOR

::AUDIO LOOP IO
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "AUDIOLOOP" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_AUDIO=AUDIO

::MinDP IO
if exist D:\FA_PRO\IOTEST\IoTestResult.OK find /i "MinDP" D:\FA_PRO\IOTEST\IoTestResult.OK | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_MinDP=MinDP

::RGB -- FAIL exist : points:x,lines:x,Regions:x,NA
if exist RGB.log del RGB.log
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "RGB" D:\SFCS\SFCS_Log_Stage.bat >RGB.log
ping 127.0.0.1 -n 2
if not exist RGB.log echo RGB >RGB.log
find /i "points" RGB.log
if @%errorlevel%==@0 set RESULT=FAIL & set NG_RGB=RGB
find /i "lines" RGB.log
if @%errorlevel%==@0 set RESULT=FAIL & set NG_RGB=RGB
find /i "Regions" RGB.log
if @%errorlevel%==@0 set RESULT=FAIL & set NG_RGB=RGB

::BlackEdge
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "BlackEdge" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set NG_BlackEdge=BlackEdge

::TP
if not exist D:\LOG\TP.OK set RESULT=FAIL & set NG_TP=TP

::KB
if not exist D:\LOG\AUTOKB.OK set RESULT=FAIL & set NG_KB=KB

::TouchPanel
if not exist D:\LOG\TouchPanel.ok set RESULT=FAIL & set NG_TouchPanel=TouchPanel

::TouchPen -- no test 
::if not exist D:\LOG\TouchPen.ok set RESULT=FAIL & set NG_TouchPen=TouchPen

::SN
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "SVCTAGTEST" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_SN=SN

::Camerashadow
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "CAM_TEST" D:\SFCS\SFCS_Log_Stage.bat | find /i "FAIL"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_Camerashadow=Camerashadow

::Marketingname
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "Marketingname" D:\SFCS\SFCS_Log_Stage.bat | find /i "NG"
if @%errorlevel%==@0 set RESULT=FAIL & set NG_Marketingname=Marketingname

::Speaker
if exist AUDIOTEST.log del AUDIOTEST.log
if exist D:\SFCS\SFCS_Log_Stage.bat find /i "AUDIOTEST" D:\SFCS\SFCS_Log_Stage.bat >AUDIOTEST.log
ping 127.0.0.1 -n 2
if not exist AUDIOTEST.log echo AUDIOTEST >AUDIOTEST.log
find /i "SPK" AUDIOTEST.log
if @%errorlevel%==@0 set RESULT=FAIL & set NG_Speaker=Speaker
find /i "Timeout" AUDIOTEST.log
if @%errorlevel%==@0 set RESULT=FAIL & set NG_Speaker=Speaker


goto :eof

:GetFIX_ID
if exist D:\LOG\ID.TXT (
for /f %%i in (D:\LOG\ID.TXT) do set FIXID=%%i
) else (
set FIXID=NA
)
goto :eof

:Get_Line
for /f %%i in (D:\TEST_UI\Line.dat) do set line=%%i
goto :eof
REM =========================================================================

::-------------------------Result--------------------------------------
:PASS
set spec1=0000
set spec2=0000
set spec3=0000
rem CALL D:\UploadNgError.BAT UpAutoTestLog PASS
cd /d %~dp0
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0


:FAIL
rem CALL D:\UploadNgError.BAT UpAutoTestLog FAIL
cd /d %~dp0
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat FAIL %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0
