::-------------------------Set Env-------------------------------------
@echo off
:START
cd /d %~dp0
set retry_cycle=5
set name=%~n0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%

::-----------------------MTDL INT-----------------------------------------
set Cmdline="FurMark.exe"
set BatchFile=%~dp0%name%.Bat
set Function=test
set Process=mfg
set Type=System_board
set TestID=0X1B06
set TestID1=0X1B04
set TestID2=NA
set TestResponse="Verify the correct video card installation."
set TestResponse1="UMA Video controller functional Test Passed"
set TestResponse2="test pass"
CALL D:\BURNIN\NEWMTDL\GetNowTime.bat
set StartTime=%TimeFormat%
cd /d %~dp0
::-----------------------MTDL INT-----------------------------------------
IF EXIST D:\LOG\NETLOSS%SFCSPPID%.LOG GOTO UPLOAD
:Setmfgmode
cd /d %~dp0
MfgMode64W.exe +SFMM +FAMM +OSMM -CMM
ping 127.0.0.1 -n 1

:setting
if not exist C:\Windows\SysWOW64\msvcr100.dll copy %~dp0\msvcr100.dll C:\Windows\SysWOW64\.
ping 127.0.0.1 -n 2

::-------------------------Function Test-------------------------------
set CurDrv=%~dp0
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
::-------------------------UMA TEMP Spec-------------------------------
SET GPUTEMP_SPEC=87
::-------------------------GPU TEMP Spec-------------------------------
IF @%MBType%==@DIS  GOTO SetGPUTEMPSPEC
goto SetTime
:SetGPUTEMPSPEC
::-------------------------T3 GPU TEMP Spec-------------------------------
IF @%MODELFAMILY%==@4PD0VB01A001 SET GPUTEMP_SPEC=85
::-------------------------T4 GPU TEMP Spec-------------------------------
IF @%MODELFAMILY%==@4PD0VB010001 SET GPUTEMP_SPEC=85
:SetTime
SET LOG_Folder=HP_PTL_LOG

cd /d %~dp0
rem set RunCycle=57600000
::========PVT=8hours===============
rem set RunCycle=28000000
::============1hours===============
set RunCycle=3600000
cd /d %~dp0
::=======================T4 0.2H=================
rem if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
rem IF @%MODELFAMILY%==@4PD0VB010001 set RunCycle=600000
rem cd /d %~dp0
::-------------------------Runin 4h by npi 20250504-------------------------------
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
ping 127.0.0.1 -n 2
IF @%MO%==@000045698505 set RunCycle=3600000
cd /d %~dp0
::--------------------------------------------------------
::============4hours===============
rem set RunCycle=8000000
::============0.5hours===============
rem set RunCycle=600000

::============Rework===============
FIND /I "%SERVICETAG%" MO.TXT 
IF NOT ERRORLEVEL 1 set RunCycle=360000
::============4hours===============

rem IF @%SFCSPPID:~0,3%==@481 SET RunCycle=57600000
rem IF @%SFCSPPID:~0,3%==@491 SET RunCycle=5760

REM ======SFCS 3DMARK SMART START========
cd /d %~dp0
SET LEVEL_S=1
CALL D:\BURNIN\SMART\StartSMART.BAT 3DMARK
SET LEVEL_S=1
SET /A RunCyCle=%RunCyCle%*%LEVEL_S%
IF %RunCyCle% EQU 0 SET /A RunCyCle=360000
REM ======SFCS 3DMARK SMART START========

:SAVE START TIME
cd /d %CurDrv%
safetime.exe /g >curtime.bat
call curtime.bat
set DATETIME1=%DATETIME%

:BURNIN

:FurMark
if exist Furmark*.csv del Furmark*.csv
echo %RunCyCle%
CALL FurMark.bat
ping 127.0.0.1 -n 5

:GET END TIME
cd /d %CurDrv%
safetime.exe /g >curtime.bat
call curtime.bat
set DATETIME2=%DATETIME%
safetime /d "%DATETIME1%" "%DATETIME2%" > DURA.BAT
call dura.bat

IF %DURA% GEQ %RunCycle% goto ENDRUN
goto BURNIN

:ENDRUN
cd /d %~dp0
IF EXIST IPlossRestart.BAT call IPlossRestart.BAT
:NET
IF EXIST M:\NUL GOTO CHK_TEMP
CALL D:\BURNIN\Link\Link_net.BAT
ping 127.0.0.1 -n 2
GOTO NET


:CHK_TEMP
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

cd /d %CurDrv%
IF NOT @%MBType%==@DIS  GOTO COPYLOG

::=====ITM1 Bios default disabld GPU====
rem GOTO COPYLOG
::======================================

CALL furmarkGetLog.bat
IF @%average%==@ (%~dp0\ShowError.exe Furmark_tempNG.jpg & GOTO START)
IF %average% GTR %GPUTEMP_SPEC% GOTO CHK_TEMP_NG

:CHK_TEMP_PASS
IF NOT EXIST M:\%LOG_Folder%\Furmark\%CurDate% MD M:\%LOG_Folder%\Furmark\%CurDate%
COPY FurmarkLOG.csv F_Fur_PASS_%SVCTAG%FurmarkLOG.csv /Y
COPY F_Fur_PASS_%SVCTAG%FurmarkLOG.csv M:\%LOG_Folder%\Furmark\%CurDate%\. /Y
PING 127.0.0.1 -n 2
GOTO COPYLOG

:CHK_TEMP_NG
IF NOT EXIST M:\%LOG_Folder%\Furmark\%CurDate% MD M:\%LOG_Folder%\Furmark\%CurDate%
COPY FurmarkLOG.csv F_Fur_NG_%SVCTAG%FurmarkLOG.csv /Y
COPY F_Fur_NG_%SVCTAG%FurmarkLOG.csv M:\%LOG_Folder%\Furmark\%CurDate%\. /Y
ECHO check CPU TEMP NG
ECHO check CPU TEMP NG
PING 127.0.0.1 -n 2
GOTO FAIL

:COPYLOG
cd /d %CurDrv%
IF NOT EXIST M:\%LOG_Folder%\Furmark\%CurDate% MD M:\%LOG_Folder%\FURMARK\%CurDate%
COPY D:\BURNIN\Furmark\FurmakTAT\LOG\FURMARKTAT_AVGTemperature.LOG  D:\BURNIN\Furmark\FurmakTAT\LOG\F-TAT%SVCTAG%.LOG /Y
COPY D:\BURNIN\Furmark\FurmakTAT\LOG\TATLOG.csv D:\BURNIN\Furmark\FurmakTAT\LOG\F-TAT%SVCTAG%.csv  /Y
IF EXIST D:\BURNIN\Furmark\FurmakTAT\LOG\F-TAT%SVCTAG%.LOG COPY D:\BURNIN\Furmark\FurmakTAT\LOG\F-TAT%SVCTAG%.LOG  M:\%LOG_Folder%\Furmark\%CurDate%\. /Y
IF EXIST D:\BURNIN\Furmark\FurmakTAT\LOG\F-TAT%SVCTAG%.csv COPY D:\BURNIN\Furmark\FurmakTAT\LOG\F-TAT%SVCTAG%.csv M:\%LOG_Folder%\Furmark\%CurDate%\. /Y
PING 127.0.0.1 -n 5
GOTO PASS
::-------------------------Result--------------------------------------
PING 127.0.0.1 -n 5
:FAIL
::------------------------NG test LOG base info----------------------------------------------------------
IF @%SFCSPPID:~0,3%==@481 SET SERVICETAG=%SFCSPPID:~1,23%
IF @%SFCSPPID:~0,3%==@491 SET SERVICETAG=%SFCSPPID:~1,23%

set TEST_ITEM=Furmark
IF EXIST %SERVICETAG%_%TEST_ITEM%.ini del %SERVICETAG%_%TEST_ITEM%.ini
IF EXIST %SERVICETAG%_%TEST_ITEM%.xml del %SERVICETAG%_%TEST_ITEM%.xml

ECHO [NG_info]>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO TEST_ITEM=%TEST_ITEM%>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO test_path=%BatchFile%>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO command_line=%CmdLine%>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Category=%Type%>>%SERVICETAG%_%TEST_ITEM%.ini
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
ECHO stage=TS>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Vendor=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Tool_Ver="1.31.0">>%SERVICETAG%_%TEST_ITEM%.ini
ECHO SPEC="0,90">>%SERVICETAG%_%TEST_ITEM%.ini
Echo Driver_ver=NA >>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Firmware=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO ERROR_Code=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Repir_direction="Please check Heatsink assemble">>%SERVICETAG%_%TEST_ITEM%.ini
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
python AI_LOG.py log %~dp0\GPUTemperature.log %~dp0\%SERVICETAG%_%TEST_ITEM%.xml
:uploadlog
copy %~dp0\%SERVICETAG%_%TEST_ITEM%.xml D:\BURNIN\NG_DEBUGLOG\. /y
call uploadlog.bat
::-------------------------NG test logVariable info & Auto upload------------------------------------------------------------------------
cd /d %~dp0
set spec1=0000
set spec2=0000
set spec3=0000
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1

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
cd /d %~dp0
REM END 3DMARK SMART===========
ping 127.0.0.1 -n 10
CALL D:\BURNIN\SMART\EndSMART.BAT 3DMARK OK
REM END 3DMARK SMART===========
cd /d %~dp0
MfgMode64W.exe -CMM
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %DURA% %spec2% %spec3% %ERR_CODE%
exit /b 0