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

REM =============================================
REM LoadFAXML.bat / V1.0 / 2021/12/14 / Sumner sun
REM USAGE: Choose modelname.xml by line
REM =============================================

set acount=0

:CheckLine
set /p Line=<D:\TEST_UI\Line.dat
set Line=%Line: =%
set Line=%Line:~0,3%


rem IF @%SFCSPPID:~0,3%==@481 GOTO ALL

:ChooseXML
ping 127.0.0.1 -n 1

:A1
if @%Line%==@A1A call :ReloadXml A3_LED_IO   	& goto pass
if @%Line%==@A1B call :ReloadXml A3_LED_IO   	& goto pass
if @%Line%==@A1C call :ReloadXml A3_LED_IO   	& goto pass              
if @%Line%==@A1D call :ReloadXml A3_LED_IO   	& goto pass

:A2
if @%Line%==@A2A call :ReloadXml A4_LED_IO  	& goto pass          
if @%Line%==@A2B call :ReloadXml FAManuf_A2  	& goto pass           
if @%Line%==@A2C call :ReloadXml A4_LED_IO	& goto pass
if @%Line%==@A2D call :ReloadXml A4_LED_IO	& goto pass

:A3
if @%Line%==@A3A call :ReloadXml A3_HY_IO  	& goto pass      
if @%Line%==@A3B call :ReloadXml A3_HY_IO  	& goto pass      

:A4
if @%Line%==@A4A call :ReloadXml A4_LED_IO  	& goto pass               
if @%Line%==@A4B call :ReloadXml A4_LED_IO	& goto pass
if @%Line%==@A4C call :ReloadXml A4_LED_IO	& goto pass     
if @%Line%==@A4D call :ReloadXml A4_LED_IO	& goto pass

:A5
if @%Line%==@A5A call :ReloadXml A5_NTP_IO	& goto pass            
if @%Line%==@A5B call :ReloadXml A5_NTP_IO   	& goto pass
if @%Line%==@A5C call :ReloadXml A4_NTP_IO	& goto pass
if @%Line%==@A5D call :ReloadXml A4_NTP_IO  	& goto pass              

:ATL
if @%Line%==@ACL call :ReloadXml ATL_NTP_IO  & goto pass           
if @%Line%==@ATL call :ReloadXml FAMANUF  	& goto pass           

:BTL
if @%Line%==@BCL call :ReloadXml FAMANUF   	& goto pass          
if @%Line%==@BTL call :ReloadXml FAMANUF   	& goto pass

:B1
if @%Line%==@B1A call :ReloadXml B1_TP_IO    	& goto pass           
if @%Line%==@B1B call :ReloadXml B1_TP_IO    	& goto pass      
if @%Line%==@B1C call :ReloadXml A3_LED_IO   	& goto pass
if @%Line%==@B1D call :ReloadXml A3_LED_IO   	& goto pass

:B2
if @%Line%==@B2A call :ReloadXml B1_TP_IO   	& goto pass            
if @%Line%==@B2B call :ReloadXml B1_TP_IO   	& goto pass

:B3
if @%Line%==@B3A call :ReloadXml FAMANUFB3    	& goto pass            
if @%Line%==@B3B call :ReloadXml FAMANUFB3    	& goto pass

:B4
if @%Line%==@B4A call :ReloadXml B4_NTP_IO   	& goto pass           
if @%Line%==@B4B call :ReloadXml B4_NTP_IO   	& goto pass

:B5
if @%Line%==@B5A call :ReloadXml FAMANUF   	& goto pass              
if @%Line%==@B5B call :ReloadXml B5_NTP_IO   	& goto pass
if @%Line%==@B5C call :ReloadXml FAMANUF   	& goto pass
if @%Line%==@B5D call :ReloadXml FAMANUF   	& goto pass

:B6
if @%Line%==@B6A call :ReloadXml FAMANUF     	& goto pass
if @%Line%==@B6B call :ReloadXml FAMANUF     	& goto pass
if @%Line%==@B6C call :ReloadXml FAMANUF     	& goto pass
if @%Line%==@B6D call :ReloadXml FAMANUF     	& goto pass

:E1
if @%Line%==@E1A call :ReloadXml A3_LED_IO   	& goto pass                     
if @%Line%==@E1B call :ReloadXml A3_LED_IO   	& goto pass

:E2
if @%Line%==@E2A call :ReloadXml A3_LED_IO   	& goto pass                     
if @%Line%==@E2B call :ReloadXml A3_LED_IO   	& goto pass

:E3
if @%Line%==@E3A call :ReloadXml FAMANUF     	& goto pass                          
if @%Line%==@E3B call :ReloadXml FAMANUF     	& goto pass

:T1
if @%Line%==@T1A call :ReloadXml FAMANUF     	& goto pass 
if @%Line%==@T1B call :ReloadXml FAMANUF     	& goto pass                  
if @%Line%==@TDL call :ReloadXml FAMANUF        & goto pass

:ALL
call :ReloadXml FAMANUF                     	& goto pass


:ReloadXml
if @%1==@ goto :eof
cd D:\TEST_UI
COPY %1.XML ModelName.XML /Y
SendMsg.exe 1 reloadxml
goto :eof

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