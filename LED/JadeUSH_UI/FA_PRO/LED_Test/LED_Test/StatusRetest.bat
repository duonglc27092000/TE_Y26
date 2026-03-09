::--------------------------------Set Env-------------------------------------------
@echo off
:start
cd /d %~dp0
set retry_cycle=2
set name=%~n0
set spec1=0000
set spec2=0000
set spec3=0000
set ERR_CODE=000000
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
::----------------------------------------------------------------------------------

::--------------------------------Status1 Retest------------------------------------

::--------------------------------Status LED-------------------------------
:: LED:      LCD   Caps   F4   Num    Power   Charge W   Charge O   KB BL
:: Status1:  50%   On     On   On     On      On         NA         Off
:: Status2:  0%    Off    Off  Off    NA      NA         On         On    
::-------------------------------------------------------------------------

:CheckWlan
IF @%WLAN_PN%==@ GOTO Test

:CheckManual
if exist D:\FA_PRO\IOTEST\LinkIO\Result.bat call D:\FA_PRO\IOTEST\LinkIO\Result.bat
if @%CODE%==@Y goto test

:StatusRetest
if exist D:\SFCS\TestResult.bat call D:\SFCS\TestResult.bat
if @"%LEDTEST1%"==@"PASS" if @"%LEDTEST2%"==@"PASS" goto pass

:Test
MfgMode64W.exe +SFMM +FAMM +CMM +OSMM
::---------------------Check Whether LED is tested.---------------------
if not defined LEDTEST1 (
call :write_log "The first group LED is not tested."
call Caps.bat
call F4.bat
call Num.bat
call Power.bat
call ChargeW.bat
call ChargeO.bat
call KBBL.bat
goto pass
) else if not defined LEDTEST2 (
call :write_log "The second group LED is not tested."
call Caps.bat
call F4.bat
call Num.bat
call Power.bat
call ChargeW.bat
call ChargeO.bat
call KBBL.bat
goto pass
) else (
call :write_log "Check detail item."
)
::----------------------------------------------------------------------

::---------------------Check detail item.---------------------
::Caps
set LEDTEST1_Caps=1
set LEDTEST2_Caps=1
echo %LEDTEST1%|find /i "Caps"
if @%errorlevel%==@0 set LEDTEST1_Caps=0
echo %LEDTEST2%|find /i "Caps"
if @%errorlevel%==@0 set LEDTEST2_Caps=0
call :write_log LEDTEST1_Caps:%LEDTEST1_Caps%
call :write_log LEDTEST2_Caps:%LEDTEST2_Caps%
if @%LEDTEST1_Caps%==@0 (
call Caps.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else if @%LEDTEST2_Caps%==@0 (
call Caps.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else (
call :write_log "Caps not need retest."
)

::F4
set LEDTEST1_F4=1
set LEDTEST2_F4=1
echo %LEDTEST1%|find /i "F4"
if @%errorlevel%==@0 set LEDTEST1_F4=0
echo %LEDTEST2%|find /i "F4"
if @%errorlevel%==@0 set LEDTEST2_F4=0
call :write_log LEDTEST1_F4:%LEDTEST1_F4%
call :write_log LEDTEST2_F4:%LEDTEST2_F4%
if @%LEDTEST1_F4%==@0 (
call F4.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else if @%LEDTEST2_F4%==@0 (
call F4.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else (
call :write_log "F4 not need retest."
)

::Num
set LEDTEST1_Num=1
set LEDTEST2_Num=1
echo %LEDTEST1%|find /i "Num"
if @%errorlevel%==@0 set LEDTEST1_Num=0
echo %LEDTEST2%|find /i "Num"
if @%errorlevel%==@0 set LEDTEST2_Num=0
call :write_log LEDTEST1_Num:%LEDTEST1_Num%
call :write_log LEDTEST2_Num:%LEDTEST2_Num%
if @%LEDTEST1_Num%==@0 (
call Num.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else if @%LEDTEST2_Num%==@0 (
call Num.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else (
call :write_log "Num not need retest."
)

::Power
set LEDTEST1_Power=1
set LEDTEST2_Power=1
echo %LEDTEST1%|find /i "Power"
if @%errorlevel%==@0 set LEDTEST1_Power=0
echo %LEDTEST1%|find /i "Finger"
if @%errorlevel%==@0 set LEDTEST1_Power=0
echo %LEDTEST2%|find /i "Power"
if @%errorlevel%==@0 set LEDTEST2_Power=0
echo %LEDTEST2%|find /i "Finger"
if @%errorlevel%==@0 set LEDTEST2_Power=0
call :write_log LEDTEST1_Power:%LEDTEST1_Power%
call :write_log LEDTEST2_Power:%LEDTEST2_Power%
if @%LEDTEST1_Power%==@0 (
call Power.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else if @%LEDTEST2_Power%==@0 (
call Power.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else (
call :write_log "Power not need retest."
)

::ChargeW
set LEDTEST1_ChargeW=1
set LEDTEST2_ChargeW=1
echo %LEDTEST1%|find /i "Charge-white"
if @%errorlevel%==@0 set LEDTEST1_ChargeW=0
echo %LEDTEST2%|find /i "Charge-white"
if @%errorlevel%==@0 set LEDTEST2_ChargeW=0
call :write_log LEDTEST1_ChargeW:%LEDTEST1_ChargeW%
call :write_log LEDTEST2_ChargeW:%LEDTEST2_ChargeW%
if @%LEDTEST1_ChargeW%==@0 (
call ChargeW.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else if @%LEDTEST2_ChargeW%==@0 (
call ChargeW.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else (
call :write_log "ChargeW not need retest."
)

::ChargeO
set LEDTEST1_ChargeO=1
set LEDTEST2_ChargeO=1
echo %LEDTEST1%|find /i "Charge-yellow"
if @%errorlevel%==@0 set LEDTEST1_ChargeO=0
echo %LEDTEST2%|find /i "Charge-yellow"
if @%errorlevel%==@0 set LEDTEST2_ChargeO=0
call :write_log LEDTEST1_ChargeO:%LEDTEST1_ChargeO%
call :write_log LEDTEST2_ChargeO:%LEDTEST2_ChargeO%
if @%LEDTEST1_ChargeO%==@0 (
call ChargeO.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else if @%LEDTEST2_ChargeO%==@0 (
call ChargeO.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else (
call :write_log "ChargeO not need retest."
)

::KBBL
set LEDTEST1_KBBL=1
set LEDTEST2_KBBL=1
echo %LEDTEST1%|find /i "KBlight"
if @%errorlevel%==@0 set LEDTEST1_KBBL=0
echo %LEDTEST2%|find /i "KBlight"
if @%errorlevel%==@0 set LEDTEST2_KBBL=0
call :write_log LEDTEST1_KBBL:%LEDTEST1_KBBL%
call :write_log LEDTEST2_KBBL:%LEDTEST2_KBBL%
if @%LEDTEST1_KBBL%==@0 (
call KBBL.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else if @%LEDTEST2_KBBL%==@0 (
call KBBL.bat
echo LED Have been Retested >> D:\TEST_UI\Retest.log
) else (
call :write_log "KBBL not need retest."
)
::------------------------------------------------------------

::-------------------------Result--------------------------------------
:PASS
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 0

:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %SVCTAG% %spec2% %spec3% %ERR_CODE%
exit /b 1

REM ============================Write test log================================
:write_log
cd /d %~dp0
safetime.exe /g >curtime.bat
call curtime.bat
set current_datetime=%datetime%
set content_log_path=%~dp0
set script_name=%~n0
set LowDataName=%content_log_path%%script_name%.log
set info=%1
set details=%2
echo %info%
if not @%details%==@ (
set log=%current_datetime% %script_name% %info% %details%
) else (
set log=%current_datetime% %script_name% %info%
)
echo %log% >>%LowDataName%
goto :eof
