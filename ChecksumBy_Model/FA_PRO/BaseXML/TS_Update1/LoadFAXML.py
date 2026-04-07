import sys
import time
import os
import traceback
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

def ReadLineDat(LineFile):
    strR=''
    try:
        f = open(LineFile, 'r', encoding="utf-8")  # 以UTF-8编码格式打开文件
        strR = f.read().upper().strip()
        f.close()
    except:
        strings = traceback.format_exc()
        print(strings)
        sys.stdout.flush()
        strR=''
    return strR
    
def findkeyInMsg(msg, *strkey):
    bR=False
    try:       
        for strk in strkey:
            if msg.find(strk.upper()) != -1: # 有find到關鍵字
                bR = True
                break
    except:
        strings = traceback.format_exc()
        print(strings)
        sys.stdout.flush()
        bR = False
    return bR

def GetModelNameXmlByLine(line):
    dict_lineXml = dict()
    dict_lineXml['A1A'] = 'FA.XML'
    dict_lineXml['A1B'] = 'FA.XML'
    dict_lineXml['A1C'] = 'FA.XML'
    dict_lineXml['A1D'] = 'FA.XML'

    dict_lineXml['A2A'] = 'FA.XML'
    dict_lineXml['A2B'] = 'FA.XML'
    dict_lineXml['A2C'] = 'FA.XML'
    dict_lineXml['A2D'] = 'FA.XML'

    dict_lineXml['A3A'] = 'FA.XML'
    dict_lineXml['A3B'] = 'FA.XML'

    dict_lineXml['A4A'] = 'FA.XML'
    dict_lineXml['A4B'] = 'FA.XML'
    dict_lineXml['A4C'] = 'FA.XML'
    dict_lineXml['A4D'] = 'FA.XML'

    dict_lineXml['A5A'] = 'FA.XML'
    dict_lineXml['A5B'] = 'FA.XML'
    dict_lineXml['A5C'] = 'FA.XML'
    dict_lineXml['A5D'] = 'A4_HCB_IO.XML'

    dict_lineXml['ATL'] = 'FA.XML'
    dict_lineXml['ACL'] = 'FA.XML'

    dict_lineXml['BTL'] = 'FA.XML'
    dict_lineXml['BCL'] = 'FA.XML'

    dict_lineXml['B1A'] = 'FA.XML'
    dict_lineXml['B1B'] = 'FA.XML'
    dict_lineXml['B1C'] = 'FA.XML'
    dict_lineXml['B1D'] = 'FA.XML'

    dict_lineXml['B2A'] = 'FA.XML'
    dict_lineXml['B2B'] = 'FA.XML'

    dict_lineXml['B3A'] = 'FA.XML'
    dict_lineXml['B3B'] = 'FA.XML'

    dict_lineXml['B4A'] = 'FA.XML'
    dict_lineXml['B4B'] = 'FA.XML'

    dict_lineXml['B5A'] = 'FA.XML'
    dict_lineXml['B5B'] = 'FA.XML'
    dict_lineXml['B5C'] = 'FA.XML'
    dict_lineXml['B5D'] = 'FA.XML'

    dict_lineXml['B6A'] = 'FA.XML'
    dict_lineXml['B6B'] = 'FA.XML'
    dict_lineXml['B6C'] = 'FA.XML'
    dict_lineXml['B6D'] = 'FA.XML'

    dict_lineXml['E1A'] = 'FA.XML'
    dict_lineXml['E1B'] = 'FA.XML'

    dict_lineXml['E2A'] = 'FA.XML'
    dict_lineXml['E2B'] = 'FA.XML'

    dict_lineXml['E3A'] = 'FA.XML'
    dict_lineXml['E3B'] = 'FA.XML'

    dict_lineXml['T1'] = 'FA.XML'
    
    return dict_lineXml.get(line)


if __name__ == '__main__':
    os.chdir(os.path.abspath(os.path.dirname(sys.argv[0])))
    TestItem=os.path.basename(__file__).split('.')[0]
    LinePath='D:\\TEST_UI\\LINE.DAT'
    print(TestItem)
    try:
        strLine = ''
        if not os.path.exists(LinePath):
            print('Not Found :' + LinePath)
            sys.stdout.flush()
            FileApi.CreateNewFile('ERROR.INI', '[TENG99]', 'Not Found :' + LinePath)
            TestApi.showerrorNew(TestItem, 'TENG99', 'ERROR.INI')
            sys.exit(1)
        else:
            strLine = ReadLineDat(LinePath)
            if not bool(strLine):
                print(LinePath + ' file is error or null')
                sys.stdout.flush()
                FileApi.CreateNewFile('ERROR.INI', '[TENG99]', LinePath + ' file is error or null')
                TestApi.showerrorNew(TestItem, 'TENG99', 'ERROR.INI')
                sys.exit(1)
            else:
                strSourceXml = GetModelNameXmlByLine(strLine)
                if not bool(strSourceXml):
                    print('No XML file for ' + strLine+ ', Please call TE!!')
                    FileApi.CreateNewFile('ERROR.INI', '[TENG99]', 'No XML file for ' + strLine+ ', Please call TE!!')
                    TestApi.showerrorNew(TestItem, 'TENG99', 'ERROR.INI')
                    sys.exit(1)
                else:
                    pass
        
    except Exception as e:
        print(str(e))
        sys.stdout.flush()
        FileApi.CreateNewFile('ERROR.INI', '[TENG99]', str(e))
        TestApi.showerrorNew(TestItem, 'TENG99', 'ERROR.INI')
        sys.exit(1)

    if not os.path.exists('D:\\TEST_UI\\'+strSourceXml):
        print(strSourceXml + ' is not exist in D:\\TEST_UI!!')
        FileApi.CreateNewFile('ERROR.INI', '[TENG99]', strSourceXml + ' is not exist in D:\\TEST_UI!!')
        TestApi.showerrorNew(TestItem, 'TENG99', 'ERROR.INI')
        sys.exit(1)
    else:
        os.chdir('D:\\TEST_UI')
        os.system('copy ' + strSourceXml + ' ModelName.xml /y') # copy FA_IO.XML ModelName.XML /Y
        strCMD='SendMsg.exe 1 reloadxml'
        os.system(strCMD)
    print('Load modelname.xml end!!')
    sys.exit(0)
