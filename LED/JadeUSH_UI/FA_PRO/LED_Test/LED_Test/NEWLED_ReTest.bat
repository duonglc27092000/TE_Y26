::-------------------------Set Env-------------------------------------
@echo on
:start
set retry_cycle=5
set name=%~n0
set spec1=0
set spec2=0
set spec3=0
set ERR_CODE=000000
cd /d %~dp0
REM call D:\log\testlog.bat start %name% %spec1% %spec2% %spec3% %ERR_CODE%
call D:\SFCS\INFO.BAT
::-------------------------Function Test-------------------------------

call FGETLED.BAT
IF ERRORLEVEL 1 GOTO RETEST
IF ERRORLEVEL 0 GOTO AUtotest

:AUtotest
cd /d %~dp0
GOTO PASS


:RETEST
cd /d %~dp0
CALL NEWLEDTEST.BAT
IF "%ERRORLEVEL%"=="0" GOTO PASS

:NG
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
REM call D:\log\testlog.bat fail %name% %HDD_1_Size% %SFCS_HDD% %spec3% %ERR_CODE%
exit /b 1

:PASS
REM call D:\log\testlog.bat pass %name% %HDD_1_Size% %SFCS_HDD% %spec3% %ERR_CODE%
exit /b 0