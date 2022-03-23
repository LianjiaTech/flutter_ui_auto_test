import 'dart:io';

import 'package:flutter/widgets.dart';

///
///优化后的element 映射成 ID 的工具
///
class FutIdGenerator {
  static List<String> listShortName = [];

  static List<Element> listNode = [];

  static Map<Element, String> element2Id = Map();

  static String idGenerator(Element element,
      {bool isRemoveInspectorWidget = true}) {
    if (element == null ||
        !(element is RenderObjectElement) ||
        !(element.widget is RenderObjectWidget)) {
      return '';
    }
    listNode.addAll(debugGetElementCreatorChain(element));
    for (int i = 0; i < listNode.length - 1; i++) {
      if ((listNode[i] is MultiChildRenderObjectElement ||
              listNode[i] is SliverMultiBoxAdaptorElement) &&
          listNode[i].widget is RenderObjectWidget) {
        _multiToId(listNode[i], i);
      }
    }
    //逆序处理最后分叉中存在和待处理节点相同的情况
    int count = 0;
    for (int i = listNode.length - 2; i > 0; i--) {
      if (element.runtimeType.toString() ==
          listNode[i].runtimeType.toString()) {
        count++;
      }
      if ((listNode[i] is MultiChildRenderObjectElement ||
              listNode[i] is SliverMultiBoxAdaptorElement) &&
          listNode[i].widget is RenderObjectWidget) {
        //到达分叉点退出
        break;
      }
    }
    if (count > 0) {
      listShortName.add(element.widget.toStringShort() + "[$count]");
    } else {
      listShortName.add(element.widget.toStringShort());
    }
    //删除widget_inspector的stack导致的ID
    if (isRemoveInspectorWidget) {
      listShortName.removeAt(0);
    }
    //删除IOS中多加的一个无用的Stack
    if (Platform.isIOS && listShortName.length > 1) {
      listShortName.removeAt(1);
    }
    String id = listShortName?.join('/') ?? '';
    element2Id[element] = id;
    listNode.clear();
    listShortName.clear();
    return id;
  }

  static void _multiToId(Element element, int i) {
    int childIndex = 0;
    int finalIndex = 0;
    listNode[i].visitChildren((var element) {
      if (element == listNode[i + 1]) {
        finalIndex = childIndex;
      }
      childIndex++;
    });
    if (childIndex != 1) {
      listShortName.add('${listNode[i].widget.toStringShort()}[$finalIndex]');
    }
  }

  ///获取element构造栈
  static List<Element> debugGetElementCreatorChain(Element node) {
    List<Element> list = List();
    list.add(node);
    node.visitAncestorElements((var element) {
      list.add(element);
      return true;
    });
    return list.reversed.toList();
  }
}
