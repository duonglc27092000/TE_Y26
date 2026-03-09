# ===========================================================================================
# Source = LED_Test.py
#
# (C) 2021 Wistron, Inc.
#
# LED_Test
#
# Ver  Date        Programmer          Notes
# ---  ----------  --------------      ---------------------------------------------------------
# 000  07/19/2021  Logan Jiang         Initial Release
# ===========================================================================================
import random
import sys
import time
import os
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

def capsled_flashing():
    __cmd1 = 'CapsLED_API.exe on'
    __cmd2 = 'CapsLED_API.exe off'
    os.system(__cmd1)
    time.sleep(1)
    os.system(__cmd2)
    time.sleep(1)

def powwerled_flashing():
    __cmd1 = 'wDiagLed64.exe /setbt 1'
    __cmd2 = 'wDiagLed64.exe /setbt 0'
    os.system(__cmd1)
    time.sleep(1)
    os.system(__cmd2)
    time.sleep(1)

def chargeled_flashing():
    __cmd1 = 'wDiagLed64.exe /setbt 2'
    __cmd2 = 'wDiagLed64.exe /setbt 0'
    os.system(__cmd1)
    time.sleep(1)
    os.system(__cmd2)
    time.sleep(1)

def Buttonled_flashing():
    __cmd1 = 'wDiagLed64.exe /setpower 1'
    __cmd2 = 'wDiagLed64.exe /setpower 0'
    os.system(__cmd1)
    time.sleep(1)
    os.system(__cmd2)
    time.sleep(1)

def caps_Test():
    __cmd1 = 'CapsLED_API.exe off'
    __cmd2 = 'showerror.exe CAPSLED.JPG'
    __cmd3 = 'ShowInNum.exe ledNum.jpg inputnum.bat'
    acount1 = 0
    while acount1 <3:
        os.system(__cmd1)
        os.system(__cmd2)
        acount2 = random.randint(1, 3)
        i = 0
        while i < acount2:
            capsled_flashing()
            i += 1
        os.system(__cmd3)
        dict_input = TestApi.SfcsFile2Dict('inputnum.bat')
        if dict_input.get('IPNUM') == str(acount2):
            return True
        else:
            acount1 += 1
    TestApi.showerrorNew(TestItem, 'PENG01')
    sys.stdout.flush()
    sys.exit(1)

def powwerled_test():
    __cmd1 = 'wDiagLed64.exe /setbt 0'
    __cmd2 = 'showerror.exe pwrled.jpg'
    __cmd3 = 'ShowInNum.exe ledNum.jpg inputnum.bat'
    acount3 = 0
    while acount3 < 3:
        os.system(__cmd1)
        os.system(__cmd2)
        acount4 = random.randint(1, 3)
        i = 0
        while i < acount4:
            powwerled_flashing()
            i += 1
        os.system(__cmd3)
        dict_input = TestApi.SfcsFile2Dict('inputnum.bat')
        if dict_input.get('IPNUM') == str(acount4):
            return True
        else:
            acount3 += 1
    TestApi.showerrorNew(TestItem, 'PENG02')
    sys.stdout.flush()
    sys.exit(1)

def chargeled_test():
    __cmd1 = 'wDiagLed64.exe /setbt 0'
    __cmd2 = 'showerror.exe chgled.jpg'
    __cmd3 = 'ShowInNum.exe ledNum.jpg inputnum.bat'
    acount5 = 0
    while acount5 < 3:
        os.system(__cmd1)
        os.system(__cmd2)
        acount6 = random.randint(1, 3)
        i = 0
        while i < acount6:
            chargeled_flashing()
            i += 1
        os.system(__cmd3)
        dict_input = TestApi.SfcsFile2Dict('inputnum.bat')
        if dict_input.get('IPNUM') == str(acount6):
            return True
        else:
            acount5 += 1
    TestApi.showerrorNew(TestItem, 'PENG03')
    sys.stdout.flush()
    sys.exit(1)

def buttonled_test():
    __cmd1 = 'wDiagLed64.exe /setpower 0'
    __cmd2 = 'showerror.exe pwrBTled.jpg'
    __cmd3 = 'ShowInNum.exe ledNum.jpg inputnum.bat'
    acount7 = 0
    while acount7 < 3:
        os.system(__cmd1)
        os.system(__cmd2)
        acount8 = random.randint(1, 3)
        i = 0
        while i < acount8:
            Buttonled_flashing()
            i += 1
        os.system(__cmd3)
        dict_input = TestApi.SfcsFile2Dict('inputnum.bat')
        if dict_input.get('IPNUM') == str(acount8):
            return True
        else:
            acount7 += 1
    TestApi.showerrorNew(TestItem, 'PENG04')
    sys.stdout.flush()
    sys.exit(1)

if __name__ == '__main__':
    os.chdir(os.path.abspath(os.path.dirname(sys.argv[0])))
    OS_Version = list(open(r'D:\\Config\\OS_Version.bat', 'r'))[0][15:25]
    # Init MTDL log data
    PathMTDL = "D:\\BURNIN\\NEWMTDL\\AFT"
    TestItem = os.path.basename(__file__).split('.')[0]
    StartTime = (time.strftime("%Y-%m-%dT%H:%M:%S", time.localtime())) + "-05:00"
    iniName = TestItem + '.ini'

    dict_Base = dict()
    dict_Base['StartTime'] = StartTime
    dict_Base['TestItem'] = TestItem
    dict_Base['Cmdline'] = 'CapsLED_API.exe'  # change...
    dict_Base['OS'] = OS_Version
    dict_Base['BatchFile'] = sys.argv[0]
    dict_Base['Function'] = 'test'  # change...
    dict_Base['Process'] = 'mfg'  # change...
    dict_Base['type'] = 'LED'  # change...
    dict_Base['TestResult'] = 'PASS'
    dict_Base['EndTime'] = StartTime
    dict_Base['TestID'] = '0X130B'  # change...
    dict_Base['TestResponse'] = 'ALL LED test pass'  # change...
    dict_Base['TestResponse1'] = 'test pass'  # change...
    # end init MTDL log data

    try:
        InfoName = 'D:\\SFCS\\Info.bat'
        dict_info = TestApi.SfcsFile2Dict(InfoName)
        if dict_info.get('KB_PN') == None and dict_info.get('FINGERPRINT') != None:
            pwrres = powwerled_test()
            chares = chargeled_test()
            if pwrres and chares:
                EndTime = (time.strftime("%Y-%m-%dT%H:%M:%S", time.localtime())) + "-05:00"
                dict_Base["EndTime"] = EndTime
                if os.path.exists(iniName):
                    os.remove(iniName)
                else:
                    pass
                FileApi.DoIni4MTDL(iniName, dict_Base)
                os.system('copy ' + iniName + ' ' + PathMTDL + ' /y')
                # MTDL end
                sys.exit(0)
            else:
                TestApi.showerrorNew(TestItem, 'PENG01')
                sys.stdout.flush()
                sys.exit(1)

        elif dict_info.get('KB_PN') == None and dict_info.get('FINGERPRINT') == None:
            pwrres = powwerled_test()
            chares = chargeled_test()
            butres = buttonled_test()
            if pwrres and chares and butres:
                EndTime = (time.strftime("%Y-%m-%dT%H:%M:%S", time.localtime())) + "-05:00"
                dict_Base["EndTime"] = EndTime
                if os.path.exists(iniName):
                    os.remove(iniName)
                else:
                    pass
                FileApi.DoIni4MTDL(iniName, dict_Base)
                os.system('copy ' + iniName + ' ' + PathMTDL + ' /y')
                # MTDL end
                sys.exit(0)
            else:
                TestApi.showerrorNew(TestItem, 'PENG01')
                sys.stdout.flush()
                sys.exit(1)

        elif dict_info.get('KB_PN') != None and dict_info.get('FINGERPRINT') == None:
            capsres = caps_Test()
            pwrres = powwerled_test()
            chares = chargeled_test()
            butres = buttonled_test()
            if capsres and pwrres and chares:
                EndTime = (time.strftime("%Y-%m-%dT%H:%M:%S", time.localtime())) + "-05:00"
                dict_Base["EndTime"] = EndTime
                if os.path.exists(iniName):
                    os.remove(iniName)
                else:
                    pass
                FileApi.DoIni4MTDL(iniName, dict_Base)
                os.system('copy ' + iniName + ' ' + PathMTDL + ' /y')
                # MTDL end
                sys.exit(0)
            else:
                TestApi.showerrorNew(TestItem, 'PENG01')
                sys.stdout.flush()
                sys.exit(1)

        elif dict_info.get('KB_PN') != None and dict_info.get('FINGERPRINT') != None:
            capsres = caps_Test()
            pwrres = powwerled_test()
            chares = chargeled_test()
            if capsres and pwrres and chares:
                EndTime = (time.strftime("%Y-%m-%dT%H:%M:%S", time.localtime())) + "-05:00"
                dict_Base["EndTime"] = EndTime
                if os.path.exists(iniName):
                    os.remove(iniName)
                else:
                    pass
                FileApi.DoIni4MTDL(iniName, dict_Base)
                os.system('copy ' + iniName + ' ' + PathMTDL + ' /y')
                # MTDL end
                sys.exit(0)
            else:
                TestApi.showerrorNew(TestItem, 'PENG01')
                sys.stdout.flush()
                sys.exit(1)
    except Exception as e:
        sys.stdout.flush()
        FileApi.CreateNewFile('ERROR.INI', '[TENG99]', str(e))
        TestApi.showerrorNew(TestItem, 'TENG99', 'ERROR.INI')
        sys.exit(1)