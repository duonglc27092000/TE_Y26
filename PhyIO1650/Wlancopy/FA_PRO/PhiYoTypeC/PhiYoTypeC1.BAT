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
if exist D:\SFCS\Info.bat call D:\SFCS\Info.bat
if exist D:\Config\CFG.bat call D:\Config\CFG.bat
call D:\log\testlog.bat START %name% %spec1% %spec2% %spec3% %ERR_CODE%
::----------------------------------------------------------------------
::-----------------------MTDL INT-----------------------------------------
set Cmdline="PQAW3_USB.exe /a"
set BatchFile=%~dp0%name%.Bat
set Function=test
set Process=mfg
set Type=USB
set TestID=0X1D00
set TestID1=0X1D01
set TestID2=0X1D02
set TestID3=0X1D03
set TestID4=0X1D05

set TestResponse="USB 3.0\2.0\Type C Speed Type-C 1 Test Passed"
set TestResponse1="Verify USB ports Type-C 1 pass"
set TestResponse2="Functional Type-C 1 Test pass"
set TestResponse3="TypeC Charge Type-C 1Test pass"
set TestResponse4="Power Delivery/USB Type C 1 Test pass"
CALL D:\BURNIN\NEWMTDL\GetNowTime.bat
set StartTime=%TimeFormat%
cd /d %~dp0
::-----------------------MTDL INT-----------------------------------------


::------SetupDriver---------
:SetupDriver
cd /d %~dp0
cd SetupDriver
call SetupDriver.bat
::--------------------------

:Phiyo_Wave
cd /d %~dp0
WinPlay.exe ALL.wav

:CHECKCC1
cd /d %~dp0
IF EXIST TYPEC1.LOG DEL TYPEC1.LOG
showerror.exe PhiYo1.jpg
D:\FA_PRO\Write_SVC_PPID\PlatCfg64W.exe Get_TypeC_Port_Status:0 >TYPEC1.LOG
type TYPEC1.log |find /i "0xfe"
if NOT @%errorlevel%==@0 goto Reboot
GOTO START

:Reboot
REM =============================================
REM PHIYOTYPEC.BAT / V1.0 / 2019/10/21 / Owen Gu
REM USAGE: Test USB 3.0, USB2.0,DP,CHARGE
REM =============================================

cd /d %~dp0
start /min killstart.bat
ShowError.exe  TypeCplug.jpg

::-------------------------Init-------------------------------
:Init
cd /d %~dp0
if exist device.txt del device.txt
devcon.exe find * > device.txt
ping 127.0.0.1 -n 2
find /i "USB\VID_FF68&PID_FF68" device.txt
if not @%errorlevel%==@0 goto Init
::------------------------------------------------------------


::-----------------------------Test--------------------------
set acount=0
:Test
set /a acount=acount+1
if %acount% gtr %retry_cycle% goto fail

if exist Detail_Result.txt del Detail_Result.txt
if exist Result.txt del Result.txt
if exist TypeCTester_1605log.txt del TypeCTester_1605log.txt
if exist TypeCTester_1605.ini del TypeCTester_1605.ini
IF EXIST D:\FA_PRO\PHIYOTYPEC\log\*.log DEL D:\FA_PRO\PHIYOTYPEC\log\*.log
PING 127.0.0.1 -n 2

copy PHIYOTYPEC.ini TypeCTester_1605.ini /y

:TEST1
TypeCTester_1605.exe
::-----------------------------------------------------------

::--------------------Check Pass-----------------
ping 127.0.0.1 -n 4
if not exist Result.txt if not exist Detail_Result.txt goto test
find /i "FAIL" Detail_Result.txt >temp.txt
if @%errorlevel%==@0 goto FAIL1

:NG
find /i "open short fail" D:\FA_PRO\PHIYOTYPEC\log\*.log
if @%errorlevel%==@0 goto OpenShort
find /i "USB2.0" temp.txt
if @%errorlevel%==@0 goto USB20NG
find /i "USB3.0" temp.txt
if @%errorlevel%==@0 goto USB30NG
find /i "CC1/CC2" temp.txt
if @%errorlevel%==@0 goto CC1CC2NG
find /i "DP" temp.txt
if @%errorlevel%==@0 goto DPNG
find /i "PD" temp.txt
if @%errorlevel%==@0 goto PDNG

find /i "PASS" Result.txt
if @%errorlevel%==@0 goto PASS
rem goto test
goto CHECKCC1
::-----------------------------------------------

::--------------------NG Show-----------------
:OpenShort
ShowError.exe TPCOpenShort.jpg
GOTO TEST

:USB20NG
ShowError.exe TypeCUSB20NG.jpg
GOTO START

:USB30NG
ShowError.exe TypeCUSB30NG.jpg
GOTO START

:CC1CC2NG
ShowError.exe TypeCCC1CC2NG.jpg
GOTO START

:DPNG
ShowError.exe TypeCHdmiNG.jpg
GOTO START

:PDNG
ShowError.exe TypeCChargeNG.jpg
GOTO START

::--------------------------------------------

::-------------------------Result--------------------------------------
:FAIL1
find /i "Getting Resolution faild" D:\FA_PRO\PHIYOTYPEC\log\*.log
if not @%errorlevel%==@0 goto REBOOT
if exist d:\log\Phiyo4K.ok goto REBOOT
echo ok>d:\log\Phiyo4K.ok
copy PHIYOTYPEC_4K.ini TypeCTester_1605.ini /y
GOTO TEST1

:REBOOT
if exist d:\log\PhiyoReboot.ok goto NG
echo ok>d:\log\PhiyoReboot.ok
PING 127.0.0.1 -n 3
SHUTDOWN.EXE -F -R -T 0
ping 127.0.0.1 -n 100
exit /b 1

:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
ShowError.exe TypeCNG.jpg
goto start
call D:\log\testlog.bat fail %name% %spec1% %spec2% %spec3% %ERR_CODE%
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
IF @%TestID3%==@NA GOTO SET_ID_END
DoIni4MTDL.exe "%name%.INI" TestID %TestID3%
DoIni4MTDL.exe "%name%.INI" TestResponse %TestResponse3%
IF @%TestID4%==@NA GOTO SET_ID_END
DoIni4MTDL.exe "%name%.INI" TestID %TestID4%
DoIni4MTDL.exe "%name%.INI" TestResponse %TestResponse4%
:SET_ID_END
cd /d %~dp0

set spec1=0000
set spec2=0000
set spec3=0000

ping 127.0.0.1 -n 1
rem start /min killpass.bat
rem ShowError.exe  showpass.jpg
call D:\log\testlog.bat pass %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0
::---------------------------------------------------------------------

