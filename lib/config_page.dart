import 'package:beike_flutter_ui_auto/fut_service.dart';
import 'package:beike_flutter_ui_auto/fut_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'all_elements.dart';
import 'fut_id_generator.dart';

class FutConfigPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FutConfigState();
}

class FutConfigState extends State<FutConfigPage> {
  final String oStep1 = "在项目中执行flutter_weditor.py ，可在控制台查看到当前IP";
  final String oStep2 =
      "手机端点击业务专区–FlutterUI自动化测试 (若toast提示：当前页面必须是Flutter 页面，则先选择进入任意flutter页面再点击)";
  final String oStep3 = "将控制台IP输入，点击连接，此时即与Service端建立连接";
  final String oStep4 = "点击底部“开启”按钮，左下脚展示搜索图标，则代表开启";
  final String oStep5 = "点击返回，退出配置页面。点击搜索图标，再点击任意按钮，即可在PC端控制台查看到相关ID信息";

  TextEditingController ipInputController = TextEditingController();

  void switchSelectMode(bool isShowWidgetInspectorOverride) {
    if (WidgetsApp.debugShowWidgetInspectorOverride !=
        isShowWidgetInspectorOverride) {
      WidgetsApp.debugShowWidgetInspectorOverride =
          isShowWidgetInspectorOverride;
      // ignore: invalid_use_of_protected_member
      WidgetInspectorService.instance.forceRebuild();
    }
  }

  @override
  void initState() {
    ipInputController.text = FutService.severAddress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter自动化测试配置页面',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getTopTip(),
          _getInputWidget(),
          Expanded(
            flex: 1,
            child: _getOperationStepsWidget(),
          ),
          _getBottomPane()
        ],
      ),
    );
  }

  Widget _getTopTip() {
    return Container(
      color: Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 10),
            child: Icon(
              Icons.notifications_active,
              size: 16,
            ),
          ),
          Text(
            '开启开关，即可点击获取元素ID～',
            style: TextStyle(fontSize: 16, color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _getInputWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 16, bottom: 16, left: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextField(
              controller: ipInputController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请输入电脑端IP地址',
                labelText: 'IP地址',
                prefixIcon: Icon(Icons.network_wifi),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 8, right: 20),
            child: RaisedButton(
              child: Text('连接'),
              onPressed: () {
                FutService.severAddress = ipInputController.text;
                FutToast.show('保存IP', context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _getOperationStepsWidget() {
    return ListView(
      children: <Widget>[
        _getStepWidget(1, oStep1),
        Divider(
          height: 1.0,
          indent: 60.0,
          color: Colors.redAccent,
        ),
        _getStepWidget(2, oStep2),
        Divider(
          height: 1.0,
          indent: 60.0,
          color: Colors.redAccent,
        ),
        _getStepWidget(3, oStep3),
        Divider(
          height: 1.0,
          indent: 60.0,
          color: Colors.redAccent,
        ),
        _getStepWidget(4, oStep4),
        Divider(
          height: 1.0,
          indent: 60.0,
          color: Colors.redAccent,
        ),
        _getStepWidget(5, oStep5),
      ],
    );
  }

  Widget _getStepWidget(int index, String content) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '步骤$index:',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4),
          ),
          Expanded(
            child: Text(
              content,
              maxLines: 100,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBottomPane() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () {
                switchSelectMode(true);
                FutToast.show('已开启', context);
              },
              child: Text(
                '开启',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
          ),
          Expanded(
            flex: 1,
            child: RaisedButton(
              onPressed: () {
                switchSelectMode(false);
                FutToast.show('已关闭', context);
              },
              color: Colors.blue,
              child: Text(
                '关闭',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
