::-------------------------Set Env-------------------------------------
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

::------------------------------------------Get KB Infomation-------------------------------------
:GetKBInf
echo =================================
echo Waitting Hit Keyboard ...........
echo =================================
if exist KeyVkCode.Bat del KeyVkCode.Bat
tasklist|Find /I "KB_HookTest.exe" & if not errorlevel 1 taskkill /F /T /IM "KB_HookTest.exe"
KB_HookTest.exe
if not exist KeyVkCode.Bat goto GetKBInf
call KeyVkCode.Bat
set VkCode=%VkCode: =%

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