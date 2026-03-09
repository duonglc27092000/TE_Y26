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
call D:\log\testlog.bat start %name% %spec1% %spec2% %spec3% %ERR_CODE%
::-----------------------MTDL INT-----------------------------------------
set Cmdline="CapsLED_API.exe"
set BatchFile=%~dp0%name%.Bat
set Function=test
set Process=mfg
set Type=LED
set TestID=0X130B
set TestID1=NA
set TestID2=NA
set TestResponse="ALL LED test pass"
set TestResponse1="test pass"
set TestResponse2="test pass"
CALL D:\BURNIN\MTDL2020\GetNowTime.bat
set StartTime=%TimeFormat%
cd /d %~dp0
::-----------------------MTDL INT-----------------------------------------
::-------------------------Function Test-------------------------------
if @%KB_PN%==@  goto POWER_W_LED

:CAPSLED
CapsLED_API.exe off >NUL
PING 127.0.0.1 -n 1
echo 请按任意键开始测试CAPS灯！！
echo 请按任意键开始测试CAPS灯！！
showerror.exe CAPSLED.JPG

if exist num.ini DEL NUM.ini
random3.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set times=0

:CAPS_TEST
CapsLED_API.exe on >NUL
PING 127.0.0.1 -n 2 >NUL
CapsLED_API.exe off >NUL
PING 127.0.0.1 -n 2 >NUL
set /a times+=1
if %times% LSS %num% goto CAPS_TEST

:CAPS_CHOICE
ECHO 请输入CAPS LED灯闪烁的次数！！
ECHO 请输入CAPS LED灯闪烁的次数！！

if exist inputnum.bat del inputnum.bat
ShowInNum.exe ledNum.jpg inputnum.bat
if not exist inputnum.bat goto CAPS_CHOICE
call inputnum.bat
if %ipnum% neq %num% goto CAPSLED
GOTO PASS

::-------------------------Result--------------------------------------
:FAIL
set spec1=0000
set spec2=0000
set spec3=0000
call D:\ERR_CODE\Set_Error.bat
call D:\ERR_CODE\ERR_CODE.bat %ERR_CODE%
if not "%errorlevel%"=="0" goto start
call D:\log\testlog.bat FAIL %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 1

:PASS
::--------------------------Creat MTDL INI------------------------------------------
set name=%~n0
CD /D D:\BURNIN\MTDL2020\AFT
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
::--------------------------Creat MTDL INI------------------------------------------

cd /d %~dp0
::--------------Recovery------
if exist num.ini DEL NUM.ini
if exist inputnum.bat del inputnum.bat
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0
