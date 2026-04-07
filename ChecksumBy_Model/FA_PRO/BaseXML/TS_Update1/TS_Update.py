# ===========================================================================================
# Source = TS_Update.py
#
# (C) 2021 Wistron, Inc.
#
# Update test program in WDL by wlan
#
# Ver  Date        Programmer      Notes
# ---  ----------  --------------  ---------------------------------------------------------
# 000  05/28/2021  salam cui         Initial Release
# ===========================================================================================


import sys
import time
import os

sys.path.append("D:\\pythonPyc")
import TestApi
import FileApi

if __name__ == '__main__':
    os.chdir(os.path.abspath(os.path.dirname(sys.argv[0])))
    TestItem=os.path.basename(__file__).split('.')[0]
    Model='SentryNVRPL_UI' # change
    
    try:
        WLancopyVer='1.0.0'
        LocalVer='1.0.0'
        if not os.path.exists('P:\\'):
            os.system('python D:\\FA_PRO\\BaseXML\\LinkAP\\LinkAP.py') 
        else:
            pass
            
        if not os.path.exists('P:\\'):
            print('update fail...not found P:\\ exit(1)')
            TestApi.showerrorNew(TestItem,'TENG01')
            sys.exit(1)  
        else: # P: \  is exist !!!           
            SourceHddVer = 'P:\\'+ Model + '\\WLANCOPY\hddver.BAT'
            os.system('copy ' + SourceHddVer + ' D:\\config\\ /y')
            
            # read D:\\config\\HDDVER.BAT--start
            if (os.path.exists('D:\\config\\hddver.BAT')): 
                bError, MsgConfig = FileApi.find_string_inlog_byline(r'd:\config\hddver.bat', 'ver')
                if bError:
                    WLancopyVer=MsgConfig.split('=')[1].strip()                    
                else:
                    print('Read d:\\config\\hddver.bat fail')
                    TestApi.showerrorNew(TestItem,'TENG02')
                    sys.exit(1)
            else:
                print('Not found D:\\config\\hddver.BAT file')
                TestApi.showerrorNew(TestItem,'TENG03')
                sys.exit(1)
             # read D:\\config\\HDDVER.BAT--end
            
            # Read D:\hddver.bat---start
            if (os.path.exists('D:\\hddver.BAT')): 
                bError, MsgConfig = FileApi.find_string_inlog_byline(r'd:\hddver.bat', 'ver')
                if bError:
                    LocalVer=MsgConfig.split('=')[1].strip()                    
                else:
                    print('Read d:\\Hddver.bat fail')
                    TestApi.showerrorNew(TestItem,'TENG04')
                    sys.exit(1)
            else:
                print('Not found D:\\HDDVER.BAT file')
                TestApi.showerrorNew(TestItem,'TENG05')
                sys.exit(1)   
            # Read D:\hddver.bat---end 

            # compare HddVer..............
            if (WLancopyVer==LocalVer):
                sys.stdout.flush()
                sys.exit(0)
            else:
                #XCOPY P:\%Model%\WLANCOPY\. %DRV%\. /E /Y /F /D
                SourceFile = 'P:\\'+ Model + '\\WLANCOPY\\.'
                os.system('xcopy ' + SourceFile + ' d:\\. /E /Y /F /D')
                sys.stdout.flush()
                sys.exit(0)
        
    except Exception as e:
        print(str(e))
        sys.stdout.flush()
        sys.exit(1)
