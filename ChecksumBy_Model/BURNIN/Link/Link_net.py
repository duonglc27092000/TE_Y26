# ===========================================================================================
# Source = Link_net.py
#
# (C) 2024 Wistron, Inc.
#
# Connect LAN network
#
# Ver  Date        Programmer      Notes
# ---  ----------  --------------  ---------------------------------------------------------
# 000  11/07/2024  Robert Pham     Link LAN network
# ===========================================================================================

import sys
import time
import os
import shutil
import subprocess
import re

# sys.path.append("D://pythonPyc")
# import TestApi
# import FileApi

def write_log(info, details=None):
    current_time = time.strftime('%m/%d/%Y %X', time.localtime())
    content_log_path = os.path.abspath(os.path.dirname(sys.argv[0]))
    script_name = os.path.basename(__file__).split('.')[0]
    LowDataName = os.path.join(content_log_path, script_name + '.TST')
    print(info)
    if details:
        log = '[%s %s] %s\n%s\n' % (current_time, script_name, info, details)
    else:
        log = '[%s %s] %s\n' % (current_time, script_name, info)
    with open(LowDataName, 'a') as f:
        f.write(log)
        f.flush()
    sys.stdout.flush()
# =================================================================
#  Function:  IPRelese
# input:
# output: bool
#
# ================================================================
def disconnect_wifi():
    try:
        subprocess.run(["netsh", "wlan", "disconnect"])
    except Exception as ex:
        print(f"Diconnect Exception: {ex}")

def renew_dhcp():
    subprocess.run(["ipconfig", "/release"], check=True)
    subprocess.run(["ipconfig", "/renew"], check=True)


# def IPRelese():
#     try:
#         strcmd0 = 'netsh wlan disconnect'
#         strReturncmd0 = TestApi.RunCommandOutStr(strcmd0)
#         write_log(strReturncmd0)
#         time.sleep(1)
#         strcmd1 = 'ipconfig /release'
#         strcmd2 = 'ipconfig /renew'
#         strcmdlog = '%s\n%s' % (strcmd1, strcmd2)
#         write_log(strcmdlog)
#         strReturncmd = TestApi.RunCommandOutStr(strcmd1)
#         time.sleep(1)
#         write_log(strReturncmd)
#         strReturncmd = TestApi.RunCommandOutStr(strcmd2)
#         write_log(strReturncmd)
#         if strReturncmd.find('172.') != -1:
#             bReturn = True
#         else:
#             write_log('IP release and renew fail.....\n')
#             sys.stdout.flush()
#             bReturn = False
#     except:
#         bReturn = False
#
#     return bReturn


# =================================================================
#  Function:  Get GateWayIP by ipconfig
# input: void
# output: GateWay IP
#
# ================================================================
def get_DFGW_address():
    strReturn = ""
    try:
        result = subprocess.run(["ipconfig"], capture_output=True, text=True)
        ipv4_pattern = re.compile(r'Default Gateway[ .:]+([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)')
        # print(ipv4_pattern)
        matches = ipv4_pattern.findall(result.stdout)
        if matches:
            strReturn = matches[0]
    except:
        strReturn = ""
    print(f"Default GateWay: {strReturn}")
    write_log('Default GateWay:', strReturn)
    return strReturn
# =================================================================
#  Function:  Get IPv4
# input:    void
# output: IPV4
#
# ================================================================
def get_ipv4_address():
    strIP = ""
    try:
        result = subprocess.run(["ipconfig"], capture_output=True, text=True)
        ipv4_pattern = re.compile(r'IPv4 Address[ .:]+([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)')
        # print(ipv4_pattern)
        matches = ipv4_pattern.findall(result.stdout)
        print(matches[0])
        if matches:
            strIP = matches[0]
    except:
        strIP = ""
    print(f"IPv4: {strIP}")
    write_log('IPv4:', strIP)
    return strIP
# =================================================================
#  Function:  MapingNet
# input:  server IP
# output: bool
#
# ================================================================
def MapingNet(serverIP):
    bReturn = False
    try:
        strcmd1 = 'net use /d * /y'
        strcmd2 = 'net use P: \\\\%s\\netware\\PDLINE /user:pdline ndk800' % serverIP
        strcmd3 = 'net use M: \\\\%s\\netware\\MESSAGE /user:pdline ndk800' % serverIP
        strcmd4 = 'net time \\\\%s /set /y' % serverIP
        strlog = '%s \n %s' % (strcmd2, strcmd3)
        write_log('cmd line:', strlog)
        kill_net_use = subprocess.run(strcmd1, capture_output=True, text=True)
        time.sleep(1)
        write_log(kill_net_use.stdout)
        netuse_P = subprocess.run(strcmd2, capture_output=True, text=True)
        time.sleep(1)
        write_log(netuse_P.stdout)
        netuse_M = subprocess.run(strcmd3, capture_output=True, text=True)
        time.sleep(1)
        write_log(netuse_M)
        sync_time= subprocess.run(strcmd4, capture_output=True, text=True)
        time.sleep(1)
        write_log(sync_time)
        if os.path.isdir('P:'):
            bReturn = True
        else:
            write_log('net maping is fail.....\n')
            bReturn = False

    except:
        bReturn = False

    return bReturn
# =========================__name__ == '__main__'=======================================

if __name__ == '__main__':
    os.chdir(os.path.abspath(os.path.dirname(sys.argv[0])))
    TestItem = os.path.basename(__file__).split('.')[0]
    while True:  # check net
        try:
            disconnect_wifi()
            renew_dhcp()
            time.sleep(5)
            # os.system('RT_LanDongle_SelectiveSuspend.exe "USB\VID_0BDA&PID_8153&REV_3000" "Realtek USB GbE Family Controller" "*SelectiveSuspend"')
            strGatewayIP = get_DFGW_address()  # Get Gateway IP
            if bool(strGatewayIP):
                ip = get_ipv4_address()
                if ip.startswith("172.") and MapingNet(strGatewayIP):
                    write_log('Runin Net check OK!')
                    time.sleep(5)
                    sys.stdout.flush()
                    sys.exit(0)
                else:
                    write_log('IP start with 172 FAIL.....\n')
                    os.system('call ControlRJ45.bat')
                    sys.stdout.flush()
                    continue

            else:
                write_log('IP start with 172 FAIL.....\n')
                os.system('call ControlRJ45.bat')
                # TestApi.showerrorNew(TestItem, 'PDNG01')  # net is fail
                os.system('start /min D:\FA_PRO\ShowRes\ShowResult.bat LoiMang FAIL 500 700')
                renew_dhcp()  # Get local ip again
                continue
        except Exception as e:
            write_log('except error:' + str(e))
            sys.stdout.flush()
            os.system('start /min D:\FA_PRO\ShowRes\ShowResult.bat NetworkNG FAIL 500 700')
            os.system('call ControlRJ45.bat')
            # FileApi.CreateNewFile('ERROR.INI', '[TENG99]', str(e))
            # TestApi.showerrorNew(TestItem, 'TENG99', 'ERROR.INI')
            # sys.exit(1)
            continue



