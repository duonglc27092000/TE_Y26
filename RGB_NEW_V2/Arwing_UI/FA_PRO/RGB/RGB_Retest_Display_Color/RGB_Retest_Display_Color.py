from PyQt5.QtCore import pyqtSignal, Qt
from PyQt5.QtWidgets import QMainWindow, QApplication
from PyQt5.QtGui import QPixmap, QGuiApplication, QImage, QCursor
from RGB_Retest_Display_Color_ui import Ui_MainWindow
from input_result import input_result
import sys
import keyboard
import threading
import time
import os
import cv2
import json
import numpy as np
class RGB_Retest_Display_Color(QMainWindow):
    emitColorImage = pyqtSignal(str)
    def __init__(self,parent = None):
        QMainWindow.__init__(self,parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        self.setWindowTitle('RGB_Retest_Display_Color')
        self.setWindowFlags(Qt.Window | Qt.CustomizeWindowHint | Qt.WindowStaysOnTopHint)
        self.setCursor(QCursor(Qt.BlankCursor))
        self.rootPath = os.getcwd()
        self.jsonPath = r"D:\FA_PRO\RGBAuto\rgb_retest_data.json"
        # self.jsonPath = r"rgb_retest_data.json"
        self.pressTime = 0
        self.emitColorImage.connect(self.showColor)

        self.flag_result = False

        self.employee_id_path = r'./employee_id.log'
        self.result_path = r'./rgb_retest_result.bat'
        if os.path.isfile(self.employee_id_path):
            os.remove(self.employee_id_path)
        if os.path.isfile(self.result_path):
            os.remove(self.result_path)
        self.input_result = input_result(self)
        self.input_result.setWindowModality(Qt.ApplicationModal)

        screen_geometry = QGuiApplication.primaryScreen().availableGeometry()
        self.desktop_width = screen_geometry.width()
        self.desktop_height = screen_geometry.height()
        self.convert_dict_data = self.Parser_Json_Data()
        if self.convert_dict_data['result'] == 'PASS':
            with open(self.result_path, 'w') as file:
                file.writelines(f"SET RGB_RETEST_RESULT=Y")
                quit(0)
        self.retest_color_list = []
        for key, value in self.convert_dict_data.items():
            if key == 'result':
                continue
            if value['result'] == 'FAIL':
                self.retest_color_list.append(key)
        self.time_check_color_start = time.time()
        threading.Thread(target=self.Main, daemon=True).start()

    def Parser_Json_Data(self):
        convert_dict_data={
            'red': {
                'data': [],
                'result': 'FAIL'
            },
            'blue': {
                'data': [],
                'result': 'FAIL'
            },
            'green': {
                'data': [],
                'result': 'FAIL'
            },
            'white': {
                'data': [],
                'result': 'FAIL'
            },
            'black': {
                'data': [],
                'result': 'FAIL'
            },
            'result': 'FAIL'
        }
        try:
            if os.path.isfile(self.jsonPath):
                with open(self.jsonPath) as jsonFile:
                    jsonData = json.load(jsonFile)
                    list_data_NG = self.Conver_Data(jsonData['red'], 'red')
                    convert_dict_data['red']['data'] = list_data_NG
                    convert_dict_data['red']['result'] = jsonData['red']['result_red']

                    list_data_NG = self.Conver_Data(jsonData['blue'], 'blue')
                    convert_dict_data['blue']['data'] = list_data_NG
                    convert_dict_data['blue']['result'] = jsonData['blue']['result_blue']

                    list_data_NG = self.Conver_Data(jsonData['green'], 'green')
                    convert_dict_data['green']['data'] = list_data_NG
                    convert_dict_data['green']['result'] = jsonData['green']['result_green']

                    list_data_NG = self.Conver_Data(jsonData['white'], 'white')
                    convert_dict_data['white']['data'] = list_data_NG
                    convert_dict_data['white']['result'] = jsonData['white']['result_white']

                    list_data_NG = self.Conver_Data(jsonData['black'], 'black')
                    convert_dict_data['black']['data'] = list_data_NG
                    convert_dict_data['black']['result'] = jsonData['black']['result_black']

                    convert_dict_data['result'] = jsonData['result']
        except Exception as e:
            print(e)
        return convert_dict_data

    def Conver_Data(self, color_data, color):
        list_data_NG_handle = []
        try:
            screen_size = color_data[f"screen_size_{color}"]

            min_coord = min(screen_size, key=lambda coord: coord[0] + coord[1])
            max_coord = max(screen_size, key=lambda coord: coord[0] + coord[1])

            list_data_NG = color_data[f"points_ng_coordinate_{color}"] + color_data[f"lines_ng_coordinate_{color}"] + color_data[f"regions_ng_coordinate_{color}"]
            screen_width_in_image = max_coord[0] - min_coord[0]
            screen_height_in_image = max_coord[1] - min_coord[1]
            width_rate = round(self.desktop_width / screen_width_in_image, 2)
            height_rate = round(self.desktop_height / screen_height_in_image, 2)
            for data_NG in list_data_NG:
                data_NG_handle = []
                data_NG_handle.append(round((data_NG[0]-min_coord[0]) * width_rate))
                data_NG_handle.append(round((data_NG[1]-min_coord[1]) * height_rate))
                data_NG_handle.append(round(data_NG[2] * width_rate))
                data_NG_handle.append(round(data_NG[3] * height_rate))
                list_data_NG_handle.append(data_NG_handle)
        except Exception as e:
            print(e)
        return list_data_NG_handle

    def showColor(self, color):
        if color == 'white':
            # self.ui.ShowImage.setPixmap(QPixmap(os.path.join(self.rootPath,"White.jpg")))
            img_path = os.path.join(self.rootPath,"White.jpg")
        elif color == 'black':
            # self.ui.ShowImage.setPixmap(QPixmap(os.path.join(self.rootPath,"Black.jpg")))
            img_path = os.path.join(self.rootPath,"Black.jpg")
        elif color == 'red':
            # self.ui.ShowImage.setPixmap(QPixmap(os.path.join(self.rootPath,"Red.jpg")))
            img_path = os.path.join(self.rootPath,"Red.jpg")
        elif color == 'blue':
            # self.ui.ShowImage.setPixmap(QPixmap(os.path.join(self.rootPath,"Blue.jpg")))
            img_path = os.path.join(self.rootPath,"Blue.jpg")
        else:
            # self.ui.ShowImage.setPixmap(QPixmap(os.path.join(self.rootPath,"Green.jpg")))
            img_path = os.path.join(self.rootPath,"Green.jpg")

        image = cv2.imread(img_path)
        resize_img = cv2.resize(image, (self.desktop_width, self.desktop_height))
        resize_img = self.Mark_NG(resize_img, color)

        resize_img = cv2.cvtColor(resize_img, cv2.COLOR_BGR2RGB)
        h, w, ch = resize_img.shape
        bytes_per_line = ch * w
        qimage = QImage(resize_img.data, w, h, bytes_per_line, QImage.Format_RGB888)
        pixmap = QPixmap.fromImage(qimage)
        scaled_pixmap = pixmap.scaled(self.ui.ShowImage.size(), Qt.KeepAspectRatio, Qt.SmoothTransformation)
        self.ui.ShowImage.setPixmap(scaled_pixmap)
        self.ui.ShowImage.setScaledContents(True)

    def merge_bad_points(self, input_list):
        listAllBPNearly = []
        for n in range(len(input_list)):
            # print('-----------------------------------------------------')
            # (x, y, area, n, l, cont)
            listBPNearly = []
            mainBD = input_list[n]
            mainBP_X_Start = mainBD[0] - 80
            mainBP_Y_Start = mainBD[1] - 80
            mainBP_X_End = mainBD[0] + mainBD[2] + 80
            mainBP_Y_End = mainBD[1] + mainBD[3] + 80
            listBPNearly.append(mainBD)
            listBPFilter = input_list.copy()
            listBPFilter.pop(n)
            for bp in listBPFilter:
                # print(bp[:2])
                distance = abs(np.sqrt((bp[0] - mainBD[0]) ** 2 + (bp[1] - mainBD[1]) ** 2))
                # print(distance)
                bp_X_Start = bp[0] - 80
                bp_Y_Start = bp[1] - 80
                bp_X_End = bp[0] + bp[2] + 80
                bp_Y_End = bp[1] + bp[3] + 80
                # if (-10, -10) < (x, y) < (10, 10):
                if distance < 80 or \
                        ((mainBP_X_Start < bp_X_Start < mainBP_X_End and mainBP_Y_Start < bp_Y_Start < mainBP_Y_End) or
                         (mainBP_X_Start < bp_X_End < mainBP_X_End and mainBP_Y_Start < bp_Y_End < mainBP_Y_End)):
                    # if (mainBP_X_Start<bp_X_Start<mainBP_X_End and mainBP_Y_Start<bp_Y_Start<mainBP_Y_End) or (mainBP_X_Start<bp_X_End<mainBP_X_End and mainBP_Y_Start<bp_Y_End<mainBP_Y_End):
                    # print(x, y)
                    listBPNearly.append(bp)
                    # listBPNearly.append(bp)
            listBPNearly.sort(key=lambda x: (x[0], x[1]))
            listAllBPNearly.append(listBPNearly)
        return listAllBPNearly

    def remove_duplicates(self, input_list):
        output_list = []
        for item in input_list:
            if item not in output_list:
                output_list.append(item)
        return output_list

    def make_list_same_element(self, input_list):
        flag = True
        self.new_list = []
        unique_bp_list = self.remove_duplicates(input_list)
        for unique_bp in unique_bp_list:
            list_same_element = []
            list_same_element = list_same_element + unique_bp
            unique_bp_list1 = unique_bp_list.copy()
            unique_bp_list1.remove(unique_bp)
            for bp in unique_bp:
                for unique_bp1 in unique_bp_list1:
                    if bp in unique_bp1:
                        list_same_element = list_same_element + unique_bp1
                        flag = False
            list_same_element1 = self.remove_duplicates(list_same_element)
            list_same_element1.sort()
            self.new_list.append(list_same_element1)
        if not flag:
            self.make_list_same_element(self.new_list)

    def add_element_in_list(self):
        final_list = []
        for elements in self.new_list:
            sum_x = 0
            sum_y = 0
            sum_width = 0
            sum_height = 0
            for ele in elements:
                sum_x += ele[0]
                sum_y += ele[1]
                sum_width += ele[2]
                sum_height += ele[3]
            x = int(sum_x/len(elements))
            y = int(sum_y/len(elements))
            final_list.append([x, y, sum_width, sum_height])
        return final_list

    def Mark_NG(self, image, color):
        try:
            list_data_NG = self.convert_dict_data[color]['data']

            listAllBlackBPNearly = self.merge_bad_points(list_data_NG)
            self.make_list_same_element(listAllBlackBPNearly)
            final_list = self.add_element_in_list()
            if final_list:
                list_data_NG = final_list

            for data_NG in list_data_NG:
                cv2.rectangle(image, (data_NG[0] - 80, data_NG[1] - 80), (data_NG[0] + data_NG[2] + 80, data_NG[1] + data_NG[3] + 80), (123, 106, 85), 2)
        except Exception as e:
            print(e)
        return image

    def on_press(self,event):
        if self.flag_result:
            if event.name.lower() == 'n' or event.name.lower() == 'y':
                with open(self.result_path, 'w') as file:
                    file.writelines(f"SET RGB_RETEST_RESULT={event.name.upper()}")
                app.quit()
        if time.time() - self.time_check_color_start > 3:
            self.time_check_color_start = time.time()
            if not self.flag_result:
                if event.name and (time.time() - self.last_press_time) >= 0.2:
                    self.pressTime+=1
                    if len(self.retest_color_list) >= self.pressTime + 1:
                        self.emitColorImage.emit(self.retest_color_list[self.pressTime])
                    else:
                        self.input_result.emit_show_dialog.emit()
                        self.flag_result = True
                    self.last_press_time = time.time()

    def Main(self):
        self.emitColorImage.emit(self.retest_color_list[self.pressTime])
        self.last_press_time = time.time()
        keyboard.on_press(self.on_press)
        keyboard.wait()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    W = RGB_Retest_Display_Color()
    W.showFullScreen()
    sys.exit(app.exec_())
