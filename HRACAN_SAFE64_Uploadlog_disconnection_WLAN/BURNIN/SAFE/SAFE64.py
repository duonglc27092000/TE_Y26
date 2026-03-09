# ===========================================================================================
# Source = WDLSAFE.py
#
# (C) 2021 Wistron, Inc.
#
# Do safe in WDL by wlan
#
# Ver  Date        Programmer      Notes
# ---  ----------  --------------  ---------------------------------------------------------
# 000  05/31/2021  salam cui         Initial Release
# 001  11/06/2024  Robert Pham         Network Exception
# ===========================================================================================

import sys
import time
import os
import shutil
import subprocess
import re

sys.path.append("D://pythonPyc")
import TestApi
import FileApi

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
        if os.path.isdir('P:'):
            bReturn = True
        else:
            write_log('net maping is fail.....\n')
            bReturn = False

    except:
        bReturn = False

    return bReturn


# =================================================================
#  Function:  Setmode
# input:
# output: bool
#
# ================================================================
def Setmode():
    try:
        strcmd = 'MfgMode64W.exe +SFMM +FAMM +OSMM -CMM'
        time.sleep(1)
        subprocess.run(strcmd, check=True)
        # os.system(strcmd)
        time.sleep(2)
    except:
        write_log('Set Mode fail....')


# =================================================================
#  Function:  Check safe status if OK
# input:  None
# output: bool 
# 
# ================================================================

# =================================================================
#  Function:  DoSafe
# input:  None
# output: bool
#
# ================================================================
def DoSafe(safe_ip_list):
    bReturn = False
    for safeIP in safe_ip_list:
        try:
            strCMD = 'SafeAuthClient64w.exe -log test.log -safe %s' % safeIP
            doSAFE = subprocess.run(strCMD, check=True)
            if doSAFE.returncode == 0:
                bReturn = True
                if os.path.exists('test.log'):
                    f = open('test.log', 'r')
                    strT = f.read()
                    f.close()
                    write_log(strT)
                return True
        except:
            bReturn = False
    return bReturn


# =================================================================
#  Function:  GETSAFE_IP
# input: GateWay IP and Safe IP list file
# output: Safe IP
#
# ================================================================
def GETSAFE_IP(GateWayIP, safe_ip_txt):
    safe_ip_list = []
    try:
        with open(safe_ip_txt, 'r') as file: #read all content safe_ip.txt
            lines = file.readlines() #give result
        GatewayList = GateWayIP.split('.')
        del GatewayList[-1]
        strSpecIP = '.'.join(GatewayList)

        for line in lines:
            if "RUNIN" in line and "=" in line:
                    _, ip = line.split('=')
                    ip = ip.strip()
                    if ip.startswith(strSpecIP):#check presafeip
                        safe_ip_list.append(ip)
    except:
        safe_ip_list = []
    return safe_ip_list


# =========================__name__ == '__main__'=======================================

if __name__ == '__main__':
    os.chdir(os.path.abspath(os.path.dirname(sys.argv[0])))
    TestItem = os.path.basename(__file__).split('.')[0]

    while True:  # check net
        try:
            disconnect_wifi()
            renew_dhcp()
            time.sleep(5)
            strGatewayIP = get_DFGW_address()  # Get Gateway IP
            if bool(strGatewayIP) and MapingNet(strGatewayIP):
                write_log('Runin Net check OK!')
                if os.path.exists('P:\\SAFE_IP\\safe_ip.txt'):
                    time.sleep(3)
                    shutil.copy('P:\\SAFE_IP\\safe_ip.txt', os.path.abspath(os.path.dirname(sys.argv[0])))
                    strSafeIP = GETSAFE_IP(strGatewayIP, 'safe_ip.txt')
                    print(strSafeIP)
                    if bool(strSafeIP):
                        retry = 5
                        for iTest in range(retry):  # for retry test
                            write_log('safe retry.....' + str(iTest))
                            if DoSafe(strSafeIP):  # Do Safe  ok
                                write_log('Do safe ok')
                                Setmode()
                                write_log('Set Mode OK')
                                sys.stdout.flush()
                                sys.exit(0)
                            else:
                                write_log('Do Safe is fail...')
                                continue
                        else:  # retry end
                            write_log('retry end.....Do Safe NG')
                            sys.stdout.flush()
                            os.system('start /min D:\FA_PRO\ShowRes\ShowResult.bat SAFE_NG FAIL 500 700')
                            # sys.exit(1)
                            continue
                    else:
                        write_log('Get Safe IP fail or safe_ip.txt file is error!!.....')
                        sys.stdout.flush()
                        os.system('start /min D:\FA_PRO\ShowRes\ShowResult.bat SAFE_NG FAIL 500 700')
                        # TestApi.showerrorNew(TestItem, 'TENG03')  # safe_ip.txt is error
                        continue
                else:
                    write_log('not found P:\\SAFE_IP\\safe_ip.txt')
                    sys.stdout.flush()
                    os.system('start /min D:\FA_PRO\ShowRes\ShowResult.bat SAFE_NG FAIL 500 700')
                    # TestApi.showerrorNew(TestItem, 'TENG03')  # safe_ip.txt is error
                    continue
            else:
                os.system('call ControlRJ45.bat')
                # TestApi.showerrorNew(TestItem, 'PDNG01')  # net is fail
                os.system('start /min D:\FA_PRO\ShowRes\ShowResult.bat SAFE_NG FAIL 500 700')
                renew_dhcp()  # Get local ip again
                continue
        except Exception as e:
            os.system('call ControlRJ45.bat')
            write_log('except error:' + str(e))
            sys.stdout.flush()
            os.system('start /min D:\FA_PRO\ShowRes\ShowResult.bat SAFE_NG FAIL 500 700')
            # FileApi.CreateNewFile('ERROR.INI', '[TENG99]', str(e))
            # TestApi.showerrorNew(TestItem, 'TENG99', 'ERROR.INI')
            # sys.exit(1)
            continue


