# -*- coding: utf-8 -*-
"""
   This module contains the Flutter UI Test Core APIs.
"""
import time
import logging
import uiautomator2 as u2

from flutter_service import FlutterClient

class Device():
    """ Device object """

    def __init__(self, ip):
        self.u2_device = u2.connect('ip')
        self.flutter_client = FlutterClient(ip, '4567')
        self.flutter_client.__set__(ip, '4567')

    def connect(self):
        self.flutter_client.connection_flutter()

    def click_id(self, element_id, logtext):
        '''
        根据ID点击
        :return:
        '''
        if element_id:
            self.flutter_client.click_id(element_id)
            logging.info("输入text{}".format(logtext))

    def click_id_by_position(self, element_id, logtext):
        """
        :param element_id: 元素id
        :param logtext: 打印log文案
        """
        if element_id:
            position_map = self.flutter_client.get_position(element_id)
            print("ID-{}的坐标值为:{}".format(logtext, position_map))
            if isinstance(position_map, dict) and position_map.get("x") != 0:
                x = position_map["x"]
                y = position_map["y"]
                self.u2_device.click(x, y)
                logging.info("点击元素:{}".format(logtext))
                time.sleep(2)
            elif position_map.get("x") == 0 and position_map.get("y") == 0:
                logging.info("ID:{}返回坐标值为:{}, 元素不存在! ".format(element_id, position_map))
                raise AssertionError("ID:{}返回坐标值为:{}, 元素不存在! ".format(element_id, position_map))
            else:
                raise AssertionError("元素异常:{}".format(logtext))

    def click_text(self, text, logtext):
        """
        :param text: 元素名称
        :param logtext: 打印log文案
        """
        if text:
            position_map = self.flutter_client.get_position_by_text(text)
            print("text-{}的坐标值为:{}".format(logtext, position_map))
            if isinstance(position_map, dict) and position_map.get("x") != 0:
                x = position_map["x"]
                y = position_map["y"]
                self.u2_device.click(x, y)
                logging.info("点击元素:{}".format(logtext))
                time.sleep(3)
            elif position_map.get("x") == 0 and position_map.get("y") == 0:
                logging.info("ID:{}返回坐标值为:{}, 元素不存在! ".format(text, position_map))
                raise AssertionError("ID:{}返回坐标值为:{}, 元素不存在! ".format(text, position_map))
            else:
                raise AssertionError("元素异常:{}".format(logtext))

    def set_text(self, element_id, text):
        '''
        输入text文案
        :return:
        '''
        self.flutter_client.set_text(element_id, text)
        logging.info("输入text{}".format(text))

    def find_element_by_text(self, element, timeout=5):
        '''
        根据文案元素是否存在当前页面
        :return:
        '''
        is_exited = False
        try:
            while timeout > 0:
                position_map = self.flutter_client.get_position_by_text(element)
                print("text-{}的坐标值为:{}".format(element, position_map))
                if isinstance(position_map, dict) and position_map.get("x") != 0:
                    is_exited = True
                    logging.info("查询到{}".format(element))
                    break
                else:
                    timeout -= 1
        except Exception as e:
            logging.info("{}查找失败!{}".format(element, e))
        finally:
            return is_exited

    def find_element_by_id(self, element, timeout=5):
        '''
        根据ID元素是否存在当前页面
        :return:
        '''
        is_exited = False
        try:
            while timeout > 0:
                position_map = self.flutter_client.get_position(element)
                print("text-{}的坐标值为:{}".format(element, position_map))
                if isinstance(position_map, dict) and position_map.get("x") != 0:
                    is_exited = True
                    logging.info("查询到{}".format(element))
                    break
                else:
                    timeout -= 1
        except Exception as e:
            logging.info("{}查找失败!{}".format(element, e))
        finally:
            return is_exited

    def swip_down_element(self, element):
        '''
        向下滑动到某个元素
        :return:
        '''
        max_count = 5
        while max_count > 0:
            if self.find_element_by_text(element) is True:
                logging.info("向下滑动到:{}".format(element))
                break
            else:
                self.swip_down()
                max_count -= 1
                logging.info("向下滑动")
                time.sleep(2)

    def swip_down(self, time=0.5):
        '''
        向上滑动
        :return:
        '''
        window_size = self.u2_device.window_size()
        width = int(window_size[0])
        height = int(window_size[1])
        self.u2_device.drag(width / 2, height * 3 / 4, width / 2, height / 4, time)
        logging.info("向上滑动")

    def assert_toast(self, message):
        '''
        断言toast
        :return: True or False
        '''
        toast = self.u2_device.toast.get_message(5.0, 3.0, message)
        if message == toast:
            logging.info("断言{}元素存在,成功!".format(message))
            assert True
        else:
            logging.info("断言{}元素存在,失败!".format(message))
            assert False

    def assert_exited_text(self, text):
        '''
        根据文案断言
        '''
        assert self.find_element_by_text(text) == True, "断言：{}text存在,失败!".format(text)
        logging.info("断言text：{}存在,成功!".format(text))

    def assert_exited_id(self, id):
        '''
        根据ID断言
        '''
        assert self.find_element_by_id(id) == True, "断言：{}text存在,失败!".format(id)
        logging.info("断言ID：{}存在,成功!".format(id))

    def assert_equal(self, element_id, text):
        '''
        断言ID与toast是否一致
        '''
        assert self.flutter_client.assert_text(element_id, text) == True, "断言ID:{}与文案:{}一致，失败!".format(element_id, text)
        logging.info("断言ID:{}与文案:{}一致，成功!".format(element_id, text))





