import 'dart:convert';
import 'dart:io';

import 'auto_test_hook.dart';
import 'id2Postion_manager.dart';

// UI自动化测试服务
class FutService {
  static ServerSocket server;
  static List<ChatClient> clients = [];

  static String severAddress; //获取ID过程中，远端的Socket地址
  static int serverPort = 5678; //获取ID过程中默认端口

  /// 服务初始化，在App初始化时调用
  static Future<void> initService({int port: 4567}) async {
    InjectWidgetInspectorService();
    Future.delayed(Duration(seconds: 0)).then((value) {
      ServerSocket.bind(InternetAddress.anyIPv4, port)
          .then((ServerSocket socket) {
        server = socket;
        server.listen((client) {
          handleConnection(client);
        });
      });
    });
  }

  static void handleConnection(Socket client) {
    print('Connection from '
        '${client.remoteAddress.address}:${client.remotePort}');
    clients.add(ChatClient(client));
  }

  static close() {
    server.close();
  }

  static void distributeMessage(ChatClient client, String message) {
    if (message != null) {
      Map params = json.decode(message);
      switch (params['method']) {
        case 'getPosition':
          Map position = Id2PositionManager.instance.id2Position(params['id']);
          client.write(json.encode(position));
          break;
        case 'assertText':
          bool exist = Id2PositionManager.instance
              .assetText(params['id'], params['text']);
          client.write('$exist');
          break;
        case 'setText':
          Id2PositionManager.instance.setText(params['id'], params['text']);
          client.write('');
          break;
        case 'getPositionByText':
          Map position =
              Id2PositionManager.instance.text2Position(params['text']);
          client.write(json.encode(position));
          break;
        default:
          client.write('');
          break;
      }
    }
  }

  static void removeClient(ChatClient client) {
    clients.remove(client);
  }

  static void sendID(String elementId) {
    if (severAddress != null && severAddress.isNotEmpty) {
      Socket.connect(severAddress, serverPort).then((Socket sock) {
        sock.write(elementId);
        sock.close();
      }).catchError((e) {
        print("Unable to connect: $e");
        exit(1);
      });
    }
  }
}

class ChatClient {
  Socket _socket;
  String _address;
  int _port;

  ChatClient(Socket s) {
    _socket = s;
    _address = _socket.remoteAddress.address;
    _port = _socket.remotePort;

    _socket.listen(messageHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void messageHandler(List<int> data) {
    String message = String.fromCharCodes(data.getRange(0, data.length)).trim();
    FutService.distributeMessage(this, message);
  }

  void errorHandler(error) {
    print('$_address:$_port Error: $error');
    FutService.removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    print('$_address:$_port Disconnected');
    FutService.removeClient(this);
    _socket.close();
  }

  void write(String message) {
    _socket.write(message);
  }
}
