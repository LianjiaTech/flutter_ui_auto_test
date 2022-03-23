import base64
import socket

import simplejson as simplejson


class FlutterClient:
    ip: str
    port: str
    client: socket

    def __init__(self, ip, port):
        self.ip = ip
        self.port = port

    def __set__(self, ip, port):
        self.ip = ip
        self.port = port

    def __close__(self):
        self.client.close()

    """
    创建 socket 对象
    """
    def connection_flutter(self):
        # 创建 socket 对象
        print('connection start')
        self.client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # 连接服务，指定主机和端口
        if not self.port:
            self.client.connect((self.ip, '4567'))  # 默认端口
        else:
            print("port", self.port)
            self.client.connect((self.ip, int(self.port)))

    """
    根据text获取元素位置
    [text] 页面文案
    [:return] 返回x、y坐标:{'x':x,'y':y}
    """
    def get_position_by_text(self, text: str) -> dict:
        text_en = text.encode("utf-8")
        base64_text = base64.b64encode(text_en)
        tem_map = {'method': 'getPositionByText', 'text': base64_text}
        json_map = simplejson.dumps(tem_map)
        self.client.send(json_map.encode('utf-8'))
        while True:
            data = self.client.recv(1024)  # 读取消息
            if not data:
                break
            position_map = simplejson.loads(data.decode('utf-8'))
            return position_map
        return None

    """
     根据ID获取元素位置
     [id] 元素id
     [:returns] 返回x、y坐标:{'x':x,'y':y}
    """
    def get_position(self, id: str) -> dict:
        tem_map = {'method': 'getPosition', 'id': id}
        json_map = simplejson.dumps(tem_map)
        self.client.send(json_map.encode('utf-8'))
        while True:
            data = self.client.recv(1024)  # 读取消息
            if not data:
                break
            position_map = simplejson.loads(data.decode('utf-8'))
            return position_map
        return None

    """
     根据ID操作点击
     [id] 元素id
     [:returns] 无
    """
    def click_id(self, id: str):
        tem_map = {'method': 'id2Click', 'id': id}
        json_map = simplejson.dumps(tem_map)
        self.client.send(json_map.encode('utf-8'))


    """
        输入text
        [id] 元素id
        [text] 输入的文本
        [:return] 无
    """
    def set_text(self, id: str, text: str):
        text_en = text.encode("utf-8")
        text_b = base64.b64encode(text_en)
        tem_map = {'method': 'setText', 'id': id, 'text': text_b}
        json_map = simplejson.dumps(tem_map)
        self.client.send(json_map.encode('utf-8'))


    """
     验证text
     [id] 元素id
     [text] 元素文本
     [:return] 返回true or false
    """
    def assert_text(self, id: str, text: str) -> bool:
        text_en = text.encode("utf-8")
        text_b = base64.b64encode(text_en)
        tem_map = {'method': 'assertText', 'id': id, 'text': text_b}
        json_map = simplejson.dumps(tem_map)
        self.client.send(json_map.encode('utf-8'))
        while True:
            data = self.client.recv(1024)  # 读取消息
            if not data:
                break
            if 'true' == data.decode('utf-8'):
                return bool(1)
            else:
                return bool(0)
        return bool(0)
