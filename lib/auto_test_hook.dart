import 'package:beike_aspectd/aspectd.dart';
import 'package:beike_flutter_ui_auto/fut_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'fut_id_generator.dart';

@Aspect()
@pragma("vm:entry-point")
class InjectWidgetInspectorService {
  @pragma("vm:entry-point")
  InjectWidgetInspectorService();

  //实例方法
  @Execute("package:flutter/src/widgets/widget_inspector.dart",
      "InspectorSelection", "-_computeCurrent")
  @pragma("vm:entry-point")
  void _computeCurrent(PointCut pointcut) {
    print('call _computeCurrent');
    pointcut.proceed();
    if (kDebugMode) {
      final Element current =
          WidgetInspectorService.instance.selection?.currentElement;
      String elementId = FutIdGenerator.idGenerator(current);
      print("ztc >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print("ztc >>>>>>>> elementId = $elementId");
      print("ztc >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      FutService.sendID(elementId);
    }
  }
}
