import pyautogui
import ctypes
import os
import sys
import time
import win32api

VK_NUMLOCK = 0x90
KEYEVENTF_EXTENDEDKEY = 0x1
KEYEVENTF_KEYUP = 0x2
# WinAPI中的常量和结构体
VK_CAPITAL = 0x14


# 调用WinAPI函数获取Num Lock状态
def get_numlock_state():
    return ctypes.windll.user32.GetKeyState(VK_NUMLOCK)


# 调用WinAPI函数获取Caps Lock状态
def get_capslock_state():
    return ctypes.windll.user32.GetKeyState(VK_CAPITAL)


# 判断Num Lock状态是否被打开
def is_numlock_on():
    state = get_numlock_state()
    return state & 0x1


# 判断Caps Lock状态是否被打开
def is_capslock_on():
    state = get_capslock_state()
    return state & 0x1


def move_tp(x, y):
    win32api.SetCursorPos([x, y])
    time.sleep(0)


def LED_ON():
    if not is_capslock_on():
        move_tp(10,10)
        try:
            pyautogui.press('capslock')
        except:
            move_tp(10, 10)
            LED_ON()

    if not is_numlock_on():
        move_tp(10,10)
        try:
            pyautogui.press('numlock')
        except:
            move_tp(10, 10)
            LED_ON()
        # 模拟按下和释放Caps Lock键
    os.system('SetVol_X64.exe MIC Mute')


def LED_OFF():
    if is_capslock_on():
        move_tp(10,10)
        try:
            pyautogui.press('capslock')
        except:
            move_tp(10, 10)
            LED_OFF()
    if is_numlock_on():
        move_tp(10,10)
        try:
            pyautogui.press('numlock')
        except:
            move_tp(10, 10)
            LED_OFF()
        # 模拟按下和释放Caps Lock键
    os.system('SetVol_X64.exe MIC Unmute')

if __name__ == '__main__':
    # 记录开始时间
    start_time = time.time()
    ditigs = sys.argv[1].upper()
    print('Start :  ', 'capslock:', is_capslock_on(), 'numlock:', is_numlock_on())
    if ditigs == 'ON':
        LED_ON()
        print('LED ON END')
    elif ditigs == 'OFF':
        LED_OFF()
        print('LED OFF END')
    else:
        print('''
        传参错误
        The parameters are incorrect
        ''')
    print('END :  ', 'capslock:', is_capslock_on(), 'numlock:', is_numlock_on())
    # 记录结束时间
    end_time = time.time()
    # 计算运行时间
    runtime = round(end_time - start_time, 2)
    print('''
    run time: %s s
    ''' % (runtime))