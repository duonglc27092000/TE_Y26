::-------------------------Set Env-------------------------------------
@echo off
:START
cd /d %~dp0
set retry_cycle=5
set name=%~n0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
if exist "C:\Program Files\UL\3DMark\custom_timespy.3dmdef" del "C:\Program Files\UL\3DMark\custom_timespy.3dmdef"
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
rem call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::-----------------------MTDL INT-----------------------------------------
set Cmdline="3DMarkCmd.exe"
set BatchFile=%~dp0%name%.Bat
set Function=test
set Process=mfg
set Type=System_board
set TestID=0X1B00
set TestID1=0X1B06
set TestID2=0X1B05
set TestResponse="Verify the correct video card installation."
set TestResponse1="3D Mark Test Passed"
set TestResponse2="Discrete Video controller functional test pass"
CALL D:\BURNIN\NEWMTDL\GetNowTime.bat
set StartTime=%TimeFormat%
cd /d %~dp0
::-----------------------MTDL INT-----------------------------------------
::---diablo arl DVT2 UMA Night Raid UI conflict xShow64,can not load,so kill xShow64----------------
tasklist|Find /I "xShow64.exe" & if not errorlevel 1 taskkill /F /T /IM "xShow64.exe"

IF EXIST D:\LOG\NETLOSS%SFCSPPID%.LOG GOTO UPLOAD
::=============Xbuild 3dmark autorestart add show fail==================
rem IF EXIST D:\LOG\3dmarkstartflag.OK GOTO 3dmarkautorestartfail
rem ECHO 3dmark start > D:\LOG\3dmarkstartflag.OK
::=============Xbuild 3dmark autorestart add show fail==================
if exist 3DMarkCycle.bat del 3DMarkCycle.bat
rem goto pass
set Cycle=0
::-------------------------Function Test-------------------------------
::=============DVT2 3DMark hang 1-8 issue PM waive==================

::=============DVT2 3DMark hang 1-8 issue PM waive==================

:Setmfgmode
cd /d %~dp0
MfgMode64W.exe +SFMM +FAMM +OSMM -CMM
ping 127.0.0.1 -n 1

:SET3DMARK
cd /d %~dp0
nircmdc.exe setsysvolume2 0 0


:Copy3DMark
copy D:\BURNIN\3DMARK\custom_cloudgate.3dmdef "C:\Program Files\UL\3DMark" /y
copy D:\BURNIN\3DMARK\custom_icestorm_extreme.3dmdef "C:\Program Files\UL\3DMark" /y
copy D:\BURNIN\3DMARK\custom_firestrike_extreme.3dmdef "C:\Program Files\UL\3DMark" /y
copy D:\BURNIN\3DMARK\custom_timespy_extreme.3dmdef "C:\Program Files\UL\3DMark" /y
copy D:\BURNIN\3DMARK\custom_portroyal.3dmdef "C:\Program Files\UL\3DMark" /y

ping 127.0.0.1 -n 5
rem goto Set3DF
:3DTimeSPY
cd /d %~dp0
rem if exist D:\log\3dmarkrestart.ok goto Set3DF
rem start /w 3dmarkTimespy.bat
ping 127.0.0.1 -n 40
rem echo 3dmarkrestart > D:\log\3dmarkrestart.ok
rem ping 127.0.0.1 -n 2
rem shutdown -f -r -t 0
rem ping 127.0.0.1 -n 100

:Set3DF
tasklist|Find /I "3DMarkCmd.exe" & if not errorlevel 1 taskkill /F /IM "3DMarkCmd.exe"
tasklist|Find /I "3DMarkICFWorkload.exe" & if not errorlevel 1 taskkill /F /IM "3DMarkICFWorkload.exe"
tasklist|Find /I "3DMarkICFDemo.exe" & if not errorlevel 1 taskkill /F /IM "3DMarkICFDemo.exe"
ping 127.0.0.1 -n 2
rem copy D:\BURNIN\3DMARK\custom_timespy.3dmdef "C:\Program Files\UL\3DMark" /y
rem copy D:\BURNIN\3DMARK\custom_skydiver.3dmdef "C:\Program Files\Futuremark\3DMark\bin\x64" /y
rem copy D:\BURNIN\3DMARK\burnin_icestorm_definition.3dmdef "C:\Program Files\Futuremark\3DMark\bin\x64" /y
rem start /w example_burnin_firestrike_performance.bat

::=============DVT2 3DMark hang issue==================
:checkMO
rem if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
rem IF @%MO%==@000046922468 GOTO checkMOEND
rem IF @%MO%==@000046922465 GOTO checkMOEND
rem IF @%MO%==@000046922248 GOTO checkMOEND
rem IF @%MO%==@000046922245 GOTO checkMOEND
rem goto pass
:checkMOEND
::=============DVT2 3DMark hang issue==================

cd /d %~dp0
:SETTIME
set CurDrv=%~dp0
SET GPUTEMP_SPEC=85
SET LOG_Folder=HP_PTL_LOG
::=======================3Dmark 14hours=======================================================================
rem set RunCycle=50000000

::=======================3Dmark 10hours=================
set RunCycle=36000000
cd /d %~dp0
::=======================3pcs Runin 7h by npi 20251224=================
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
FIND /I "%SERVICETAG%" D:\BURNIN\3DMARK\ppid.txt
IF NOT ERRORLEVEL 1 set RunCycle=3600000
FIND /I "%SVCTAG%" D:\BURNIN\3DMARK\ppid.txt
IF NOT ERRORLEVEL 1 set RunCycle=3600000
cd /d %~dp0
::=======================3pcs Runin 7h by npi 20251224=================
::=======================T3 mp Runin 7h by npi 20250716=================
rem if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
rem IF @%MODELFAMILY%==@4PD0VB01A001 set RunCycle=3600000
cd /d %~dp0
::-------------------------T3 mp Runin 7h by npi 20250716-----------------------
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
ping 127.0.0.1 -n 2
IF @%MO%==@000045698505 set RunCycle=36000000
cd /d %~dp0
::--------------------------------------------------------
::========================3Dmark 7hours=================
rem set RunCycle=25000000

::========================3Dmark 4hours=================
rem set RunCycle=14400000

::========================3Dmark 2hours=================
rem set RunCycle=7000000

::========================3Dmark 1hours=================
rem set RunCycle=3600000

::========================3Dmark 0.5hours=================
rem set RunCycle=600000

::===================XBUILD PLB BLOCK BUILD=========
FIND /I "%SERVICETAG%" D:\CONFIG\ppid.txt
rem IF NOT ERRORLEVEL 1 set RunCycle=7000000


::===================3DMark Cycle==========================================================================
set Run3DCycle=80
::===========14h============Furmark 1hours====
REM set Run3DCycle=60
::===========8h=============Furmark 1hours====
rem set Run3DCycle=12
::===========4h=============Furmark 1hours====
REM set Run3DCycle=3
::===========1h=============Furmark 1hours====
::============"1 cycle=10 min"=================

:Precision
goto MOEND
cd /d %~dp0
rem IF NOT DEFINED MODELFAMILY GOTO MO
rem IF @%MODELFAMILY%==@4PD0TC010001 set RunCycle=5400000
rem IF @%MODELFAMILY%==@4PD0TC01B001 set Run3DCycle=5

:MO
REM IF NOT DEFINED MO GOTO MOEND
REM IF NOT EXIST MO.TXT GOTO MOEND
FIND /I "%MO%" MO.TXT
IF NOT ERRORLEVEL 1 set RunCycle=3600000
FIND /I "%MO%" MO.TXT
IF NOT ERRORLEVEL 1 set Run3DCycle=3

:MOEND
:Bios 
::========================A00 Bios C/R===================================================
rem IF @%SFCSPPID:~0,3%==@491 SET Run3DCycle=6

::========================GET TAT LOG WHEN RUN 3DMARK=====================================
rem START /min D:\BURNIN\3DMARK\3DMarkTAT\RUNTEST_TAT.BAT
rem ping 127.0.0.1 -n 10
rem IF @%SFCSPPID:~0,3%==@481 SET RunCycle=15000000
rem IF @%SFCSPPID:~0,3%==@491 SET RunCycle=15000000
::==================BIOS B/R ================================================================

:SAVE START TIME
cd /d %CurDrv%
safetime.exe /g >curtime.bat
call curtime.bat
set DATETIME1=%DATETIME%
ping 127.0.0.1 -n 5

:BURNIN
ping 127.0.0.1 -n 10
if exist D:\LOG\Check3DMark.ok del D:\LOG\Check3DMark.ok

:3DMark
cd /d %CurDrv%
if exist 3Dmark*.csv del 3Dmark*.csv
start /min  D:\BURNIN\3DMARK\Check3DMark.bat
echo %RunCyCle%
Start /w 3DMark.bat

set /a Cycle=%Cycle%+1
ping 127.0.0.1 -n 20
ECHO SET Cycle=%Cycle% >%CurDrv%\3DMarkCycle.bat

rem IF %Cycle% GEQ %Run3DCycle% goto ENDRUN

:GET END TIME
cd /d %CurDrv%
safetime.exe /g >curtime.bat
call curtime.bat
set DATETIME2=%DATETIME%
ping 127.0.0.1 -n 5
safetime /d "%DATETIME1%" "%DATETIME2%" > DURA.BAT
call dura.bat



IF %DURA% GEQ %RunCycle% goto ENDRUN

rem IF %Cycle% GEQ 300 goto ENDRUN
goto BURNIN

:ENDRUN

IF EXIST d:\log\3Dresult.txt DEL d:\log\3Dresult.txt /Q
ping 127.0.0.1 -n 2
if exist "C:\Program Files\UL\3DMark\result.txt" copy "C:\Program Files\UL\3DMark\result.txt" d:\log\3Dresult.txt /Y
ping 127.0.0.1 -n 10
FIND /I "Benchmark completed" d:\log\3Dresult.txt
if not "%errorlevel%"=="0" GOTO FAIL
rem FIND /I "ERROR" d:\log\3Dresult.txt
rem if "%errorlevel%"=="0" GOTO FAIL

rem FIND /I "ERROR" d:\log\3Dresult.txt
rem if "%errorlevel%"=="0" GOTO CopyFailLog

ECHO 3DMARKOK>D:\LOG\3DMark.ok

IF EXIST IPlossRestart.BAT call IPlossRestart.BAT

:NET
cd /d %CurDrv%
rem CALL D:\BURNIN\Link\Link_net.BAT
ping 127.0.0.1 -n 2

goto PASS

:CopyFailLog
cd /d %CurDrv%
IF EXIST M:\NUL GOTO COPYLOG
CALL D:\BURNIN\Link\Link_net.BAT
ping 127.0.0.1 -n 2
GOTO CopyFailLog

:COPYLOG
call D:\SFCS\info.bat
IF @%SFCSPPID:~0,3%==@481 SET SERVICETAG=%SFCSPPID%
IF @%SFCSPPID:~0,3%==@491 SET SERVICETAG=%SFCSPPID%

cd /d %~dp0
SAFETIME /g >CurrentTime.bat
call CurrentTime.bat

set "date1=%DATETIME:~0,4%"
set "date2=%DATETIME:~5,2%"
set "date3=%DATETIME:~8,2%"
set "time1=%DATETIME:~11,2%"
set "time2=%DATETIME:~14,2%"
set "time3=%DATETIME:~17,2%"
set CurDate=%date1%%date2%%date3%
set time=%time1%%time2%%time3%
cd /d %~dp0

IF NOT EXIST M:\HP_PTL_LOG\3Dmark\%CurDate% MD M:\HP_PTL_LOG\3Dmark\%CurDate%
COPY d:\log\3Dresult.txt M:\HP_PTL_LOG\3Dmark\%CurDate%\3DMark%SERVICETAG%.txt

::========NV Issue==BY PASS==========
goto pass

::-------------------------Result--------------------------------------
:FAIL
SAFETIME.EXE 3Dmark.jpg
set spec1=0000
set spec2=0000
set spec3=0000
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1

:END
cd /d %CurDrv%
IF NOT EXIST M:\%LOG_Folder%\3Dmark MD M:\%LOG_Folder%\3Dmark
COPY D:\BURNIN\3Dmark\3DmarkTAT\LOG\3DmarkTAT_AVGTemperature.LOG  D:\BURNIN\3Dmark\3DmarkTAT\LOG\F-TAT%SVCTAG%.LOG /Y
COPY D:\BURNIN\3Dmark\3DmarkTAT\LOG\TATLOG.csv D:\BURNIN\3Dmark\3DmarkTAT\LOG\F-TAT%SVCTAG%.csv  /Y
IF EXIST D:\BURNIN\3Dmark\3DmarkTAT\LOG\F-TAT%SVCTAG%.LOG COPY D:\BURNIN\3Dmark\3DmarkTAT\LOG\F-TAT%SVCTAG%.LOG  M:\%LOG_Folder%\3Dmark\. /Y
IF EXIST D:\BURNIN\3Dmark\3DmarkTAT\LOG\F-TAT%SVCTAG%.csv COPY D:\BURNIN\3Dmark\3DmarkTAT\LOG\F-TAT%SVCTAG%.csv M:\%LOG_Folder%\3Dmark\. /Y
ping 127.0.0.1 -n 5
tasklist|Find /I "ThermalAnalysisToolCmd.exe.EXE" & if not errorlevel 1 taskkill /F /T /IM "ThermalAnalysisToolCmd.exe.EXE"
echo 3DMarkpass>d:\log\3DMark.log
rem call START3DMark.bat


:UPLOAD
ping 127.0.0.1 -n 2
:NET1
IF EXIST M:\NUL GOTO COPYLOG
CALL D:\BURNIN\Link\Link_net.BAT
ping 127.0.0.1 -n 2
GOTO NET1

:COPYLOG
IF NOT EXIST M:\HP_PTL_LOG\NETWORK\NG MD M:\HP_PTL_LOG\NETWORK\NG
COPY D:\LOG\NETLOSS%SFCSPPID%.LOG M:\HP_PTL_LOG\NETWORK\NG\. /Y


:PASS
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
IF EXIST D:\LOG\NETLOSS%SFCSPPID%.LOG del D:\LOG\NETLOSS%SFCSPPID%.LOG
IF EXIST D:\LOG\3dmarkstartflag.OK del D:\LOG\3dmarkstartflag.OK
cd /d %~dp0
nircmdc.exe setsysvolume2 65536 65536
MfgMode64W.exe -CMM
set spec1=0000
set spec2=0000
set spec3=0000
rem  call D:\log\testlog.bat PASS %name% %DURA% %spec2% %spec3% %ERR_CODE%
exit /b 0

:3dmarkautorestartfail
cd /d %~dp0
call :ShowErrorPE PENG01 NGITEM.INI & goto start
GOTO START

::-------------------------New ShowErrorTool--------------------------------------
:ShowErrorTE
cd /d %~dp0
set name=%~n0
IF @%SHIPMODE%==@ATB CALL :Blockbuild TENG99 NGcode.ini & goto start
IF @%SHIPMODE%==@CTB CALL :Blockbuild TENG99 NGcode.ini & goto start
D:\ShowErrorNew\ShowErrorTE.exe "%name% test fail" %1 %2
ping 127.0.0.1 -n 5
tasklist|find /i "ShowErrorTE.exe" & if not errorlevel 1 taskkill /f /t /im "ShowErrorTE.exe"
goto :eof

:ShowErrorPE
cd /d %~dp0
set name=%~n0
IF @%SHIPMODE%==@ATB CALL :Blockbuild TENG99 NGcode.ini & goto start
IF @%SHIPMODE%==@CTB CALL :Blockbuild TENG99 NGcode.ini & goto start
D:\ShowErrorNew\ShowErrorPE.exe "%name% test fail" %1 %2
ping 127.0.0.1 -n 5
tasklist|find /i "ShowErrorPE.exe" & if not errorlevel 1 taskkill /f /t /im "ShowErrorPE.exe"
goto :eof

:ShowErrorPD
cd /d %~dp0
set name=%~n0
IF @%SHIPMODE%==@ATB CALL :Blockbuild TENG99 NGcode.ini & goto start
IF @%SHIPMODE%==@CTB CALL :Blockbuild TENG99 NGcode.ini & goto start
D:\ShowErrorNew\ShowErrorPD.exe "%name% test fail" %1 %2
ping 127.0.0.1 -n 5
tasklist|find /i "ShowErrorPD.exe" & if not errorlevel 1 taskkill /f /t /im "ShowErrorPD.exe"
goto :eof

:Blockbuild
cd /d %~dp0
set name=%~n0
D:\ShowErrorNew\ShowErrorTE.exe "%name% test fail" %1 %2
ping 127.0.0.1 -n 5
tasklist|find /i "ShowErrorTE.exe" & if not errorlevel 1 taskkill /f /t /im "ShowErrorTE.exe"
goto :eof