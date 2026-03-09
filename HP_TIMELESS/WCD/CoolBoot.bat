@Echo ON

rem =========for MTDL START===================
set CMDPATH=%~dp0
CALL D:\BURNIN\MTDL\GetSTIME.BAT
set ITEM=CBOOT

cd /d %CMDPATH%

:Begin

SET STDQTY=%1
IF @%1==@ SET STDQTY=5

set LogFile=CB.log
Echo %DATE%, %TIME%, StresTest Start >> %LogFile%

:SetupAutoOn 
RosaNbColdReboot.exe /DUR 210 >> %LogFile%
If %ERRORLEVEL% EQU 0 goto  SetAuoOnOK

:SetupAutoOn1 
Echo RosaNbColdReboot.exe Retry-1 >> %LogFile%
RosaNbColdReboot.exe /DUR 210 >> %LogFile%
If %ERRORLEVEL% EQU 0 goto  SetAuoOnOK

:SetupAutoOn2 
Echo RosaNbColdReboot.exe Retry-2 >> %LogFile%
RosaNbColdReboot.exe /DUR 210 >> %LogFile%
If %ERRORLEVEL% EQU 0 goto  SetAuoOnOK

:SetupAutoOn3 
Echo RosaNbColdReboot.exe Retry-3 >> %LogFile%
RosaNbColdReboot.exe /DUR 210 >> %LogFile%
If %ERRORLEVEL% EQU 0 goto  SetAuoOnOK
Echo Fail to setup Auto Power On


:SetAuoOnOK
if not exist time.bat echo set a=0 > time.bat
call time.bat
set /a a=%a%+1
echo set a=%a% > time.bat
Echo %DATE%, %TIME%, Shuddown >> %LogFile%
Echo ========  Cool Boot %a% cycle ============= >>%LogFile%
echo %a%
if %a% GEQ %CBQTY% goto PASS

Shutdown /s /f /t 1


:PASS
Echo ========== Cool Boot PASS===================
CALL D:\BURNIN\MTDL\FA_ARMS.BAT CBOOT