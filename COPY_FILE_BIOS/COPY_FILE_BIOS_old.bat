rem ____Copy File BIOS lost___
rem get name model  on server
rem eg = Arches13MLK_UI
findstr "PARTNO=" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat > GET_PARTNO.BAT
call GET_PARTNO.BAT
echo %PARTNO%
if not defined PARTNO goto end

rem _____________________Check Model_____________________

find /i "Arches13MLK_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Arches13MLK_UI

find /i "Arches13_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Arches13_UI

find /i "Arches15MLK_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Arches15MLK_UI

find /i "Arches15_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Arches15_UI

find /i "Arwing_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Arwing_UI

find /i "Diablo_ARL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Diablo_ARL_UI

find /i "Diablo_MTL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Diablo_MTL_UI

find /i "JarvisAMD_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto JarvisAMD_UI

find /i "Jarvis_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Jarvis_UI

find /i "GhostRider_AMD_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto GhostRider_AMD_UI

find /i "GhostRider_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto GhostRider_UI

find /i "QKL_MLK_MTL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto QKL_MLK_MTL_UI

find /i "QKL_MLK_RPL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto QKL_MLK_RPL_UI

find /i "Quake_L_ADL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Quake_L_ADL_UI

find /i "Quake_L_RPL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Quake_L_RPL_UI

find /i "SentryNVRPL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto SentryNVRPL_UI

find /i "SentryNVRPL_R_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto SentryNVRPL_R_UI

find /i "Sentry_AMD_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Sentry_AMD_UI

find /i "Sentry_MLK_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Sentry_MLK_UI

find /i "Taroko_AMD_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Taroko_AMD_UI

find /i "Taroko_ARL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Taroko_ARL_UI

find /i "Taroko_LNL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Taroko_LNL_UI

find /i "Taroko_RPL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Taroko_RPL_UI

find /i "JadeUSH_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto JadeUSH_UI

find /i "Jade1416_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Jade1416_UI

find /i "JadeARL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto JadeARL_UI

find /i "Jade_AMD_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Jade_AMD_UI

find /i "HP_PTL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto HP_PTL_UI

find /i "Diablo_ARL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Diablo_ARL_UI

find /i "Sentry_ARL_UI" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat
if %errorlevel%==0 goto Sentry_ARL_UI
rem _____________________ end_____________________

goto end


:Arches13MLK_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y

D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Arches13_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Arches15MLK_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Arches15_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Arwing_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Diablo_ARL_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Diablo_MTL_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:JarvisAMD_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Jarvis_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:GhostRider_AMD_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:GhostRider_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:QKL_MLK_MTL_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:QKL_MLK_RPL_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Quake_L_ADL_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Quake_L_RPL_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:SentryNVRPL_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:SentryNVRPL_R_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Sentry_AMD_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Sentry_MLK_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Taroko_AMD_UI
if not exist D:\BURNIN\UpdateBIOS\1.10.2.exe copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.10.2.exe D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\1.10.2.rom copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.10.2.rom D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Taroko_ARL_UI
if not exist D:\BURNIN\UpdateBIOS\2.10.1.exe copy P:\%PARTNO%\BURNIN\UpdateBIOS\2.10.1.exe D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\2.10.1.rom copy P:\%PARTNO%\BURNIN\UpdateBIOS\2.10.1.rom D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Taroko_LNL_UI
if not exist D:\BURNIN\UpdateBIOS\2.10.1.exe copy P:\%PARTNO%\BURNIN\UpdateBIOS\2.10.1.exe D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\2.10.1.rom copy P:\%PARTNO%\BURNIN\UpdateBIOS\2.10.1.rom D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Taroko_RPL_UI
if not exist D:\BURNIN\UpdateBIOS\2.10.1.exe copy P:\%PARTNO%\BURNIN\UpdateBIOS\2.10.1.exe D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\2.10.1.rom copy P:\%PARTNO%\BURNIN\UpdateBIOS\2.10.1.rom D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:JadeUSH_UI
if not exist D:\BURNIN\UpdateBIOS\1.13.0.exe copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.13.0.exe D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\1.13.0.rom copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.13.0.rom D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Jade1416_UI
if not exist D:\BURNIN\UpdateBIOS\1.13.0.exe copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.13.0.exe D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\1.13.0.rom copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.13.0.rom D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:JadeARL_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Jade_AMD_UI
if not exist D:\BURNIN\UpdateBIOS\1.11.1.exe copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.11.1.exe D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\1.11.1.rom copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.11.1.exe D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:HP_PTL_UI
if not exist D:\BURNIN\UpdateBIOS\1.3.1.exe copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.3.1.exe D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\1.3.1.rom copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.3.1.rom D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Diablo_ARL_UI
if not exist D:\BURNIN\UpdateBIOS\1.9.1.exe copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.9.1.exe D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\1.9.1.rom copy P:\%PARTNO%\BURNIN\UpdateBIOS\1.9.1.rom D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end

:Sentry_ARL_UI
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\ copy P:\%PARTNO%\BURNIN\UpdateBIOS\ D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end


:end
