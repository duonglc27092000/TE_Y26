rem ____Copy File BIOS lost___
rem get name model  on server
rem eg = Arches13MLK_UI
findstr "PARTNO=" D:\FA_PRO\BaseXML\TS_Update\checksumTO.bat > GET_PARTNO.BAT
call GET_PARTNO.BAT
echo %PARTNO%
if not defined PARTNO goto end
if exist D:\Config\BIOSVER.BAT call D:\Config\BIOSVER.BAT
echo %BIOSVER%
if not defined BIOSVER goto end
:Copy_BIOS
if not exist D:\BURNIN\UpdateBIOS\%BIOSVER%.exe copy P:\%PARTNO%\BURNIN\UpdateBIOS\%BIOSVER%.exe D:\BURNIN\UpdateBIOS\ /y
if not exist D:\BURNIN\UpdateBIOS\%BIOSVER%.rom copy P:\%PARTNO%\BURNIN\UpdateBIOS\%BIOSVER%.rom D:\BURNIN\UpdateBIOS\ /y
D:\TEST_UI\SendMsg.exe 1 reloadxml

goto end
:end

rem create by duongluong
rem == fix copy lost file bios
