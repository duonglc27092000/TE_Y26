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
::-------------------------Function Test-------------------------------
::--------------Init----------
::----------------------------
set acount=0
:CheckLine
ping 127.0.0.1 -n 1
find /i "A1A" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FA_Legao
find /i "A1B" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FA_Legao
find /i "A2A" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FA_Legao
find /i "A2B" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FA_Legao
find /i "A3A" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FA_Legao
find /i "A3B" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FA_legao
find /i "A4A" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FA_legao
find /i "A4B" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FA_legao
find /i "A5A" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FA_legao
find /i "A5B" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FA_legao
find /i "A5C" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FAManuf
find /i "A5D" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO FAManuf

find /i "ACL" D:\TEST_UI\LINE.DAT
if "%errorlevel%"=="0" GOTO ACL_Legao

:FAManuf
cd D:\TEST_UI
copy FAManuf.XML ModelName.XML /Y
ping 127.0.0.1 -n 2
goto ReloadXml

:FA_legao
cd D:\TEST_UI
copy FA_Legao.xml ModelName.XML /Y
ping 127.0.0.1 -n 2
goto ReloadXml

:ACL_Legao
cd D:\TEST_UI
copy ACL_Legao.xml ModelName.XML /Y
ping 127.0.0.1 -n 2
goto ReloadXml


:ReloadXml
cd D:\TEST_UI
SendMsg.exe 1 reloadxml
goto pass


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
set spec1=0000
set spec2=0000
set spec3=0000
call D:\log\testlog.bat PASS %name% %spec1% %spec2% %spec3% %ERR_CODE%
exit /b 0