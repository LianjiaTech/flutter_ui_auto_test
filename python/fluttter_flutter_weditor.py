import socket
import os
import re
port = 5678


def kill_process():
    pid = os.popen("lsof -i:5678").read()
    print("pid", pid)
    ret = os.popen("lsof -i:" + str(port))
    # 注意解码方式和cmd要相同，即为"gbk"，否则输出乱码
    str_list = ret.read()
    ret_list = re.split('', str_list)
    try:
        process_pid = list(ret_list[0].split())[-1]
        print("=====", process_pid)
        # os.popen('taskkill /pid ' + str(process_pid) + ' /F')
    except:
        print('端口未被使用')


def get_host_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(('8.8.8.8', 80))
        ip = s.getsockname()[0]
        print("------", ip)
    finally:
        s.close()
    return ip

sk = socket.socket()
hostIp = get_host_ip()

sk.bind((hostIp, port))  # 把地址绑定到套接字
sk.listen()  # 监听链接

while True:
    conn, addr = sk.accept()  ##接受客户端链接
    # 一般默认1024
    ret = conn.recv(1024)  # 接收客户端信息
    print(str(ret, encoding='utf-8'))  # 打印客户端信息
    # conn.send(b'hi')  # 必须是一个byte类型的一个数据,向客户端发送信息

# conn.close()  # 关闭客户端套接字

# sk.close()  # 关闭服务器套接字
