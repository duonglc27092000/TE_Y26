::-------------------------Set Env-------------------------------------
@echo on
:start
cd /d %~dp0
set retry_cycle=15
set name=%~n0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%

::--------------MTDL Init----------------------------------------------
:SetMTDL
set Cmdline="wRosaFan.exe /Set_Fan_Speed 0/1 spec"
set BatchFile=%~dp0%name%.Bat
set Function=buildverify
set Process=mfg
set Type=Fan
set TestID=0X1103
set TestID1=0X1100
set TestID2=NA
set TestResponse="Fan noise test Passed"
set TestResponse1="Fan Build verification Passed"
set TestResponse2="test pass"
CALL D:\BURNIN\NEWMTDL\GetNowTime.bat
set StartTime=%TimeFormat%
::-----------------------MTDL INT-----------------------------------------
::-------------------------DVT2 XDP BYPASS fan-------------------------------
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
ping 127.0.0.1 -n 2
IF @%MO%==@000045646628 goto pass
IF @%MO%==@000045646689 goto pass
IF @%MO%==@000045646699 goto pass
IF @%MO%==@000045646700 goto pass
IF @%MO%==@000045698873 goto pass
cd /d %~dp0
::--------------------------------------------------------
::-------------------------Function Test-------------------------------
:SETMFG
cd /d %~dp0
rem IF EXIST fan*.log DEL fan*.log
MFGMODE64W.EXE -CMM +FAMM +SFMM +OSMM
ping 127.0.0.1 -n 2

IF EXIST fan*.log DEL fan*.log
wRosaFan.exe /HOST_CTRL
Ping 127.0.0.1 -n 3
wRosaFan.exe /Set_Fan_Speed 0 5100
Ping 127.0.0.1 -n 1
wRosaFan.exe /Set_Fan_Speed 1 5100
Ping 127.0.0.1 -n 5

:GETFAN
cd /d %~dp0
if exist fan.log del fan.log
wRosaFan.exe /Get_Fan_Speed 0 >fan0.log
find /i "Get Fan0_Speed = 0" fan0.log
IF not ERRORLEVEL 1 GOTO CheckFAN
wRosaFan.exe /Get_Fan_Speed 1 >fan3.log
find /i "Get Fan1_Speed = 0" fan3.log
IF ERRORLEVEL 1 GOTO TEST
ShowError.exe FAN_NG.jpg
ping 127.0.0.1 -n 1
GOTO START


:CheckFAN
cd /d %~dp0
ShowError.exe FAN_NG.jpg
ping 127.0.0.1 -n 1
GOTO START

:TEST
cd /d %~dp0
if exist FAN.bat del FAN.bat
PING 127.0.0.1 -n 2
rem MFGMODE64w.EXE +CMM +FAMM +SFMM

:setstage5
REM ping 127.0.0.1 -n 1
REM wRosaFan.exe /Set_Fan_Speed 0 /MAX 
REM ping 127.0.0.1 -n 1
REM wRosaFan.exe /Set_Fan_Speed 1 /MAX
rem wRosaFan.exe /Set_Fan_Speed_Stage 0 5
rem wRosaFan.exe /Set_Fan_Speed_Stage 1 5

ShowError.exe fannoise3.JPG
PING 127.0.0.1 -n 2
ShowErrorYN.EXE fannoiseYN.JPG FAN.bat 1
call FAN.bat
if @%CODE%==@N goto pass


::-------------------------Result--------------------------------------
:FAIL
cd /d %~dp0
wRosaFan.exe /EC_Ctrl
ping 127.0.0.1 -n 2
MFGMODE64w.EXE -CMM +FAMM +SFMM
IF EXIST fan*.log DEL fan*.log
if exist FAN.bat del FAN.bat
set spec1=0000
set spec2=0000
set spec3=0000
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat fail %name% %TOUCHPANEL% %TOUCHLCD% %spec3% %ERR_CODE%
exit /b 1

:PASS
set name=%~n0
CD /D D:\BURNIN\NEWMTDL\AFT
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
wRosaFan.exe /EC_Ctrl
ping 127.0.0.1 -n 2
MFGMODE64w.EXE -CMM +FAMM +SFMM
IF EXIST fan*.log DEL fan*.log
if exist FAN.bat del FAN.bat
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat pass %name% %TOUCHPANEL% %TOUCHLCD% %spec3% %ERR_CODE%
exit /b 0