import cv2
from PyQt5.QtMultimedia import QCameraInfo
import time
import ctypes
import os
class Camera:
    def __init__(self):
        self.isopen = False
        self.id = 0
        # self.cycleTime = 5
        ctypes.windll.kernel32.SetConsoleTitleW("Open Camera Led")
        cameras = QCameraInfo.availableCameras()
        for n, camera in enumerate(cameras):
            if camera:
                if 'Integrated Webcam' == camera.description():
                    self.id = n

    def openCamera(self):
        self.cam = cv2.VideoCapture(self.id, cv2.CAP_DSHOW)
        if not self.cam.isOpened():
            print('camera open fail!')
            return
        self.isopen = True

    def showCamera(self):
        # timeStart = time.time()
        # while time.time() - timeStart < 5:
        while 1:
            if self.isopen:
                try:
                    if os.path.isfile(r'D:\FA_PRO\TouchPad\TP_Program\lefttest.ok'):
                        break
                    ret, img = self.cam.read()
                    if ret:
                        # cv2.namedWindow('cam', cv2.WINDOW_NORMAL)
                        # cv2.imshow('cam', img)
                        pass
                    cv2.waitKey(10)
                except Exception as e:
                    print(e)

if __name__ == '__main__':
    cam = Camera()
    cam.openCamera()
    cam.showCamera()
