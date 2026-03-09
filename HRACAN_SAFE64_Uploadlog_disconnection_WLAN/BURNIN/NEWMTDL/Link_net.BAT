@ECHO OFF
cd /d %~dp0
RT_LanDongle_SelectiveSuspend.exe "USB\VID_0BDA&PID_8153&REV_3000" "Realtek USB GbE Family Controller" "*SelectiveSuspend" 
ping 127.0.0.1 -n 1

:START
netsh wlan disconnect
ECHO "  PULG IN"
ECHO "  LINE"

ping 127.0.0.1 -n 2

python Link_net.py
if not errorlevel 1 goto end


echo.
echo =========================
echo ===== Link net fail =====
echo.
goto START

:end
ping 127.0.0.1 -n 2
