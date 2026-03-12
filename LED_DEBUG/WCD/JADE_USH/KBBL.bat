::--------------------------------Set Env-------------------------------------------
@echo off
:start
cd /d %~dp0
set retry_cycle=5
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
::----------------------------------------------------------------------------------

set acount=0

:KBBL
if @%KEYBL%==@NBL goto pass

set /a acount=acount+1
if %acount% gtr %retry_cycle% goto fail

wDiagLed64.exe /setkbbl 0 >NUL
showerror.exe kblight.jpg
call :Get_Random
set num=%num%
set times=0

:KBBL_Test
wDiagLed64.exe /setkbbl 4 >NUL
PING 127.0.0.1 -n 1 >NUL
wDiagLed64.exe /setkbbl 0 >NUL
PING 127.0.0.1 -n 2 >NUL
set /a times+=1
if %times% LSS %num% goto KBBL_Test
call :LED_Choice %num%
if not @%return%==@1 goto KBBL

::-------------------------Result--------------------------------------
:PASS
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
::------------------------NG test LOG base info----------------------------------------------------------
IF @%SFCSPPID:~0,3%==@481 SET SERVICETAG=%SFCSPPID:~1,23%
IF @%SFCSPPID:~0,3%==@491 SET SERVICETAG=%SFCSPPID:~1,23%

set TEST_ITEM=KBBL
IF EXIST %SERVICETAG%_%TEST_ITEM%.ini del %SERVICETAG%_%TEST_ITEM%.ini
IF EXIST %SERVICETAG%_%TEST_ITEM%.xml del %SERVICETAG%_%TEST_ITEM%.xml

ECHO [NG_info]>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO TEST_ITEM=%TEST_ITEM%>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO test_path=%~dp0%name%.Bat>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO command_line="wDiagLed64.exe /setkbbl 4">>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Category=KBBL>>%SERVICETAG%_%TEST_ITEM%.ini
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
wDiagLed64.exe>kbbl.log
SET /P Tool_Ver=<kbbl.log
ECHO Tool_Ver=%Tool_Ver%>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO SPEC=NA>>%SERVICETAG%_%TEST_ITEM%.ini
Echo Driver_ver=NA >>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Firmware=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO ERROR_Code=NA>>%SERVICETAG%_%TEST_ITEM%.ini
ECHO Repir_direction="Please check Main Board assemble">>%SERVICETAG%_%TEST_ITEM%.ini
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
python AI_LOG.py log %~dp0\kbbl.log %~dp0\%SERVICETAG%_%TEST_ITEM%.xml
:uploadlog
copy %~dp0\%SERVICETAG%_%TEST_ITEM%.xml D:\BURNIN\NG_DEBUGLOG\. /y
call uploadlog.bat
::-------------------------NG test logVariable info & Auto upload------------------------------------------------------------------------
cd /d %~dp0
goto KBBL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 1

REM ============================Functions================================
:LED_Choice
cd /d %~dp0
set num=%1
set return=0
if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto LED_Choice
call inputnum.bat
if %ipnum% equ %num% set return=1
goto :eof

:Get_Random
if exist num.ini del NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
goto :eof
