import os

if __name__ == '__main__':
    sfcs_log = r'D:\SFCS\SFCS_Log_Stage.bat'
    LED_RETEST = []
    with open(sfcs_log, 'r', encoding='utf-8')as fp:
        lines = fp.readlines()
    for i in lines:
        i = i.strip('\n').strip(' ').upper()
        if 'LEDTEST' in i and not 'PASS' in i.split('=')[-1]:
            if 'F4' in i:
                LED_RETEST.append('F4')
            if 'NUM' in i:
                LED_RETEST.append('NUM')
            if 'CAPS' in i:
                LED_RETEST.append('CAPS')
            if 'CHARGE' in i:
                LED_RETEST.append('CHARGE')
            if 'POWER' in i:
                LED_RETEST.append('POWER')
            if 'WHITE' in i:
                LED_RETEST.append('CHARGEW')
            if 'YELLOW' in i:
                LED_RETEST.append('CHARGEY')
            if 'KBLIGHT' in i:
                LED_RETEST.append('KBBL')
            if 'IR' in i:
                LED_RETEST.append('IR')
            if 'N-CAMERA' in i:
                LED_RETEST.append('CAMERA')
    LED_RETEST = set(LED_RETEST)
    if os.path.exists(r'D:\FA_PRO\LED_Test\retest_item.log'):
        os.remove(r'D:\FA_PRO\LED_Test\retest_item.log')
    if LED_RETEST:
        with open(r'D:\FA_PRO\LED_Test\retest_item.log', 'a+', encoding='utf-8')as fd:
            for i in LED_RETEST:
                fd.write(i+'\n')
