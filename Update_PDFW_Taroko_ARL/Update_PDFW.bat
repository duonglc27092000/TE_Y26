PowerShell (Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion >BIOS.LOG
::set /p biosver=<BIOS.LOG
find /i "2.8.1" BIOS.LOG
if @%errorlevel%==@0 goto aaa
find /i "2.9.0" BIOS.LOG
if @%errorlevel%==@0 goto bbb
:aaa
Flash64W.exe /PDonly /forceit /s /r /f /b=2.8.1.EXE
PING 127.0.0.1 -n 180
:bbb
Flash64W.exe /PDonly /forceit /s /r /f /b=2.9.0.EXE
PING 127.0.0.1 -n 180