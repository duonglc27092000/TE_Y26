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
if exist D:\LOG\BlackSite.ok del D:\LOG\BlackSite.ok
if exist D:\SFCS\SFCS_Log_Stage.bat call D:\SFCS\SFCS_Log_Stage.bat
IF @%LCDBLACKEDGETEST%==@PASS GOTO PASS

REM ====================================================
REM BlackSiteReTest.BAT / V1.0 / 2021/09/03 / Owen Gu
REM Black Site ReTest
REM ====================================================

::----------------------------------Function test-----------------------------------
:CheckLine
:CheckModelFamily
IF @%MODELFAMILY%==@4PD0VR010001 GOTO PASS
IF @%MODELFAMILY%==@4PD0VR01A001 GOTO PASS
IF @%MODELFAMILY%==@4PD0VS01C001 GOTO PASS
IF @%MODELFAMILY%==@4PD0VS01B001 GOTO PASS

:SetLCDLight

Bright2_x64.exe /set 100

call D:\FA_PRO\LCD\LCDSite.bat
echo BlackEdge Have been Retested >> D:\TEST_UI\Retest.log
goto pass





::-------------------------Result--------------------------------------
:PASS
echo OK>D:\LOG\BlackSite.ok
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1