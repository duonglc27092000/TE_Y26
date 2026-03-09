@ECHO OFF
SET DRV=D:
PATH %SYSTEMROOT%\SYSTEM32;%SYSTEMROOT%;%DRV%\WINFUNC\WTOOL;%DRV%\TOOLS;%DRV%\SCRIPT;%DRV%\
color 0A
type CAPSLED.ANS
echo.
echo.
echo 请按任意键开始测试大小写灯！！
echo please key to anykey start test capLED!!
pause>nul

:START
color 0A
random.exe
for /f "skip=1 tokens=2 delims==" %%i in (num.ini) do set num=%%i
set time=0

:TEST
%DRV%
CD \WINFUNC\WLED
CapsLED_API.exe off >NUL
CapsLED_API.exe on >NUL
timeout 1 >NUL
CapsLED_API.exe off >NUL
timeout 1 >NUL
set /a time+=1
if %time% LSS %num% goto TEST

:CHOICE
cls
ECHO 请输入充电灯闪烁的次数！！
ECHO Please Input CAPSLED light number of times!!

CHOICE0.EXE /C 12345 >NUL
IF @%ERRORLEVEL%==@%num% GOTO END

:CHCE
cls
ECHO 请输入大小写灯闪烁的次数！！
ECHO Please Input capLED light number of times!!

CHOICE0.EXE /C 12345 >NUL
IF @%ERRORLEVEL%==@%num% GOTO END



:NG
cls
COLOR 4A
ECHO 大小写灯测试NG,输入数字不等于闪烁次数，请按任意键重测！！
ECHO cap LED TEST NG!!
PAUSE>NUL
cls
GOTO START


:END


