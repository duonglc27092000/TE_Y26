::-------------------------Set Env-------------------------------------
@echo off
:start
cd /d %~dp0
set acount=0
set acountM=0
set acountR=0
set retry_cycle=2
set retry_cycleM=1
set retry_cycleR=1
set name=%~n0
set spec1=0
set spec2=0
set spec3=0
set ERR_CODE=000000
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
::--------------Get Model-----------------------
:SetMTDL
set Cmdline="wRosaFan.exe /SET_CHECK_FAN_SPEED 0/1 spec_Min/spec_Max 10 10"
set BatchFile=%~dp0%name%.Bat
set Function=Test
set Process=mfg
set Type=Fan
set TestID=0X1101
set TestID1=0X1102
set TestID2=NA
set TestResponse="Fan speed test Passed"
set TestResponse1="Fan over speed test Passed"
set TestResponse2="test pass"
CALL D:\BURNIN\NEWMTDL\GetNowTime.bat
set StartTime=%TimeFormat%
cd /d %~dp0

rem goto pass

:CheckModel
cd /d %~dp0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
::-------------------------DVT1 QS CPU use QC PJ ------------------------------
IF @%MODELFAMILY%==@4PD0WR010001 GOTO Herancan14
IF @%MODELFAMILY%==@4PD0WR01A001 GOTO Performante16
::-------------------------DVT1 QS CPU use QC PJ ------------------------------

IF @%MODELFAMILY%==@4PD0XQ010001 GOTO Herancan14
IF @%MODELFAMILY%==@4PD0XQ01A001 GOTO Performante16

:modelfail
echo please check Model
exit /b 1

::--------------Set Fan speed spec-----------------------
:Herancan14
cd /d %~dp0
set Fan0_Min=2800
set Fan0_Max=5400
set Fan1_Min=2800
set Fan1_Max=5400
rem set Fan2_Min=5000
rem set Fan2_Max=7000
rem set Fan3_Min=3800
rem set Fan3_Max=5200
GOTO TEST

:Performante16
cd /d %~dp0
set Fan0_Min=2500
set Fan0_Max=4400
set Fan1_Min=2500
set Fan1_Max=4400
rem set Fan2_Min=5000
rem set Fan2_Max=7000
rem set Fan3_Min=3800
rem set Fan3_Max=5200
GOTO TEST

::--------------Set Fan speed spec-----------------------
:TEST
cd /d %~dp0
IF EXIST *.LOG del *.log
::---------------------------------------Function Test---------------------------------------
:KillTask
tasklist | find /i "wRosaFan.exe" & if not errorlevel 1 taskkill /f /t /im "wRosaFan.exe"
ping 127.0.0.1 -n 3
if exist D:\log\FanRebootHigh.ok goto Fan_Max_Test
::-------------------------------Double Fan Test----------------------------------
:FanTest
cd /d %~dp0
wRosaFan.exe /HOST_CTRL
:Fan_Min_Test
cd /d %~dp0
set low_acount=0
set test_cycle=1
ping 127.0.0.1 -n 3
:Set_Low_speed
cd /d %~dp0
set /a Low_acount=low_acount+1
if exist low*_fan.log del low*_fan.log
wRosaFan.exe /Set_Fan_Speed 0 %Fan0_Min%
ping 127.0.0.1 -n 1
wRosaFan.exe /Set_Fan_Speed 1 %Fan1_Min%
ping 127.0.0.1 -n 1
rem wRosaFan.exe /Set_Fan_Speed 2 %Fan2_Min%
ping 127.0.0.1 -n 1
rem wRosaFan.exe /Set_Fan_Speed 3 %Fan3_Min%
ping 127.0.0.1 -n 15
:Get_Low_Speed
cd /d %~dp0
wRosaFan.exe /SET_CHECK_FAN_SPEED 0 %Fan0_Min% 10 10>low0_fan.log
find /i "FAIL" low0_fan.log
if @%errorlevel%==@0 goto FAILLow
wRosaFan.exe /SET_CHECK_FAN_SPEED 1 %Fan1_Min% 10 10>low1_fan.log
find /i "FAIL" low1_fan.log
if @%errorlevel%==@0 goto FAILLow
rem wRosaFan.exe /SET_CHECK_FAN_SPEED 2 %Fan2_Min% 10 10>low2_fan.log
rem find /i "FAIL" low2_fan.log
rem if @%errorlevel%==@0 goto FAILLow
rem wRosaFan.exe /SET_CHECK_FAN_SPEED 3 %Fan3_Min% 10 10>low3_fan.log
rem find /i "FAIL" low3_fan.log
rem if @%errorlevel%==@0 goto FAILLow
if %low_acount% gtr %test_cycle% goto Fan_Max_Test
ping 127.0.0.1 -n 2
goto Set_Low_speed

:Fan_Max_Test
cd /d %~dp0
wRosaFan.exe /HOST_CTRL
set High_acount=0
set test_cycle=1
ping 127.0.0.1 -n 3
:Set_High_speed
cd /d %~dp0
set /a High_acount=High_acount+1
if exist High_fan.log del High_fan.log
wRosaFan.exe /Set_Fan_Speed 0 %Fan0_Max%
ping 127.0.0.1 -n 1
wRosaFan.exe /Set_Fan_Speed 1 %Fan1_Max%
ping 127.0.0.1 -n 1
rem wRosaFan.exe /Set_Fan_Speed 2 %Fan2_Max%
ping 127.0.0.1 -n 1
rem wRosaFan.exe /Set_Fan_Speed 3 %Fan3_Max%
ping 127.0.0.1 -n 8
:Get_High_Speed
cd /d %~dp0
if exist High*_fan.log del High*_fan.log 
ping 127.0.0.1 -n 8
wRosaFan.exe /SET_CHECK_FAN_SPEED 0 %Fan0_Max% 10 10>High0_fan.log
find /i "FAIL" High0_fan.log
if @%errorlevel%==@0 goto FAILHigh
wRosaFan.exe /SET_CHECK_FAN_SPEED 1 %Fan1_Max% 10 10>High1_fan.log
find /i "FAIL" High1_fan.log
if @%errorlevel%==@0 goto FAILHigh
rem wRosaFan.exe /SET_CHECK_FAN_SPEED 2 %Fan2_Max% 10 10>High2_fan.log
rem find /i "FAIL" High2_fan.log
rem if @%errorlevel%==@0 goto FAILHigh
rem wRosaFan.exe /SET_CHECK_FAN_SPEED 3 %Fan3_Max% 10 10>High3_fan.log
rem find /i "FAIL" High3_fan.log
rem if @%errorlevel%==@0 goto FAILHigh

if %High_acount% gtr %test_cycle% goto END
ping 127.0.0.1 -n 2
goto Set_High_speed

::-----------------------------------Result-------------------------------------
:FAILLow
cd /d %~dp0
wRosaFan.exe /EC_CTRL
set /a acountR=acountR+1
if %acountR% gtr %retry_cycleR% goto Reboot
ping 127.0.0.1 -n 10
GOTO CheckModel

:FAILHigh
cd /d %~dp0
wRosaFan.exe /EC_CTRL
set /a acountM=acountM+1
if %acountM% gtr %retry_cycleM% goto RebootHigh
ping 127.0.0.1 -n 10
GOTO Fan_Max_Test

:Reboot
cd /d %~dp0
MfgMode64W.exe CAMM
MfgMode64W.exe +CMM +SFMM +FAMM
if exist D:\log\FanReboot.ok goto FAIL1
echo reboot>D:\log\FanReboot.ok
ping 127.0.0.1 -n 5
shutdown -f -r -t 0
ping 127.0.0.1 -n 100

:RebootHigh
cd /d %~dp0
rem MfgMode64W.exe CAMM
MfgMode64W.exe +CMM +SFMM +FAMM
if exist D:\log\FanRebootHigh.ok goto FAIL2
echo reboot>D:\log\FanRebootHigh.ok
ping 127.0.0.1 -n 5
shutdown -f -r -t 0
ping 127.0.0.1 -n 100

:FAIL1
cd /d %~dp0
echo LOW Fan fail
rem MfgMode64W.exe CAMM
MfgMode64W.exe +CMM +SFMM +FAMM
echo LOW Fan fail
echo LOW Fan fail
::------------------------NG test LOG base info----------------------------------------------------------
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
IF @%SFCSPPID:~0,3%==@481 SET SERVICETAG=%SFCSPPID:~1,23%
IF @%SFCSPPID:~0,3%==@491 SET SERVICETAG=%SFCSPPID:~1,23%

set TEST_ITEM=WRosaFan
IF EXIST %SERVICETAG%_%TEST_ITEM%.ini del %SERVICETAG%_%TEST_ITEM%.ini
IF EXIST %SERVICETAG%_%TEST_ITEM%.xml del %SERVICETAG%_%TEST_ITEM%.xml

ECHO [NG_info]>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO TEST_ITEM=%TEST_ITEM%>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO test_path=%~dp0%name%.Bat>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO command_line="wRosaFan.exe">>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Category=FAN>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO SVCTAG=%SERVICETAG%>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO MODEL=%MODEL%>>%SERVICETAG%_%TEST_ITEM%.ini
set /p Line=<D:\TEST_UI\Line.dat
set Line=%Line: =%
set Line=%Line:~0,3%
ECHO Line=%Line%>>%SERVICETAG%_%TEST_ITEM%.ini
PowerShell (Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion >BIOS.LOG
for /f "tokens=1 delims= " %%i in ('TYPE BIOS.LOG') do ECHO BIOSVER=%%i>>%SERVICETAG%_%TEST_ITEM%.ini
PowerShell (Get-CimInstance Win32_ComputerSystem).Model >model.log
for /f "tokens=*" %%i in ('TYPE model.LOG') do ECHO Model_name=%%i>>%SERVICETAG%_%TEST_ITEM%.ini
powershell (Get-WmiObject -Class Win32_OperatingSystem).Version>winver.log
for /f "tokens=*" %%i in ('TYPE winver.LOG') do ECHO OSver=%%i>>%SERVICETAG%_%TEST_ITEM%.ini
::------------------------NG test LOG base info----------------------------------------------------------

::-------------------------NG test logVariable info & Auto upload------------------------------------------------------------------------
ECHO SFCS_PN=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO TEST_Result=Fail>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO stage=TO>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Vendor=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Tool_Ver=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO SPEC="PASS">>%SERVICETAG%_%TEST_ITEM%.ini
Echo Driver_ver=NA >>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Firmware=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO ERROR_Code=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Repir_direction="Please check FAN assemble">>%SERVICETAG%_%TEST_ITEM%.ini
ECHO TEST_Value=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO ERROR_message=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Start_Time=%StartTime%>>%SERVICETAG%_%TEST_ITEM%.ini
CALL D:\BURNIN\NEWMTDL\GetNowTime.bat
cd /d %~dp0
ECHO End_Time=%TimeFormat%>>%SERVICETAG%_%TEST_ITEM%.ini
if not defined TestID set TestID=NA
ECHO Test_ID=%TestID%>>%SERVICETAG%_%TEST_ITEM%.ini

:create_base_xml
CD /D D:\BURNIN\NG_DEBUGLOG
python AI_LOG.py base %~dp0\%SERVICETAG%_%TEST_ITEM%.ini %~dp0\%SERVICETAG%_%TEST_ITEM%.xml

:write_log_to_xml
type low_fan.log Mid_fan.log High_fan.log > Fan.log
python AI_LOG.py log %~dp0\Fan.log %~dp0\%SERVICETAG%_%TEST_ITEM%.xml
:uploadlog
copy %~dp0\%SERVICETAG%_%TEST_ITEM%.xml D:\BURNIN\NG_DEBUGLOG\. /y
call uploadlog.bat
::-------------------------NG test logVariable info & Auto upload------------------------------------------------------------------------
cd /d %~dp0
call uplog.bat FAIL
REM call D:\ERR_CODE\Set_Error.bat
REM call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
REM if not "%errorlevel%"=="0" goto start
ShowError.exe Fan_NG.JPG
echo LOW Fan fail
call D:\log\testlog.bat fail %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1

:FAIL2
cd /d %~dp0
echo High Fan fail
rem MfgMode64W.exe CAMM
MfgMode64W.exe +CMM +SFMM +FAMM
echo High Fan fail
echo High Fan fail
call uplog.bat FAIL
REM call D:\ERR_CODE\Set_Error.bat
REM call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
REM if not "%errorlevel%"=="0" goto start
echo High Fan fail
ShowError.exe Fan_NG.JPG
call D:\log\testlog.bat fail %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1

:FAIL
echo wrosafan test fail
exit /b 1

:END
cd /d %~dp0
wRosaFan.exe /EC_CTRL
ping 127.0.0.1 -n 5
rem MfgMode64W.exe CAMM
MfgMode64W.exe +SFMM +FAMM +OSMM -CMM
call uplog.bat PASS
goto PASS

:WebNG
ShowError.exe WebSVCNG.png
ping 127.0.0.1 -n 5
goto start

:PASS
cd /d %~dp0
::--------------------------Creat MTDL INI------------------------------------------
set name=%~n0
CD /D D:\BURNIN\NEWMTDL\RUNIN
IF EXIST %name%.INI DEL %name%.INI
CALL BASE_MDTL_INI.BAT %StartTime% %CmdLine% %BatchFile% %Function% %Process% %Type%

DoIni4MTDL.exe "%name%.INI" TestID %TestID% 	
DoIni4MTDL.exe "%name%.INI" TestResponse %TestResponse%

IF @%TestID1%==@NA GOTO SET_ID_END
DoIni4MTDL.exe "%name%.INI" TestID %TestID1%
DoIni4MTDL.exe "%name%.INI" TestResponse %TestResponse1%

IF @%TestID2%==@NA GOTO SET_ID_END
DoIni4MTDL.exe "%name%.INI" TestID %TestID2%
DoIni4MTDL.exe "%name%.INI" TestResponse %TestResponse2%

:SET_ID_END
cd /d %~dp0
if exist *.ok del *.ok
IF EXIST *.LOG del *.log
if exist D:\log\FanRebootHigh.ok del D:\log\FanRebootHigh.ok
if exist D:\log\FanReboot.ok del D:\log\FanReboot.ok
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0