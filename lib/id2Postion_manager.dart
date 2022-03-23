import 'dart:convert' as convert;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'all_elements.dart';
import 'fut_id_generator.dart';

/// 创建时间：2020/6/23
/// 作者：chenkang007
/// 描述：转化id为position

class Id2PositionManager {
  static Id2PositionManager _instance;

  static Id2PositionManager get instance => _getInstance();

  static Map<String, Element> element2IdMap = Map();

  List<Element> elementList = List();

  static String base64Decode(String data) {
    List<int> bytes = convert.base64Decode(data);
    String result = convert.utf8.decode(bytes);
    return result;
  }

  static Id2PositionManager _getInstance() {
    if (_instance == null) {
      _instance = new Id2PositionManager._internal();
    }
    return _instance;
  }

  Id2PositionManager._internal() {
    // 初始化
    initElement2IdMap();
  }

  initElement2IdMap() {
    elementList = allCandidates.toList().reversed.toList();
    elementList.forEach((var element) {
      if (FutIdGenerator.element2Id.containsKey(element)) {
        element2IdMap.addAll({FutIdGenerator.element2Id[element]: element});
      } else {
        element2IdMap.addAll({
          FutIdGenerator.idGenerator(element, isRemoveInspectorWidget: false):
              element
        });
      }
    });
  }

  Iterable<Element> get allCandidates => _allCandidates();

  ///获取树中所有的element
  Iterable<Element> _allCandidates() {
    return collectAllElementsFrom(
      WidgetsBinding.instance.renderViewElement,
      skipOffstage: true,
    );
  }

  ///通过id获取其在界面中的具体位置[Map]
  ///[id]界面元素id
  Map id2Position(String id) {
    initElement2IdMap();
    if (element2IdMap.containsKey(id)) {
      Element element = element2IdMap[id];
      final RenderObject renderObject = element.renderObject;
      if (renderObject is RenderBox) {
        //偏移
        Offset offset = renderObject.localToGlobal(Offset(0, 0));
        //大小
        Size size = renderObject.size;
        double x = (offset.dx + size.width / 2) * window.devicePixelRatio;
        double y = (offset.dy + size.height / 2) * window.devicePixelRatio;
        if (x > window.physicalSize.width || y > window.physicalSize.height) {
          x = 0;
          y = 0;
        }
        return {'x': x, 'y': y};
      }
    }
    return {'x': 0, 'y': 0};
  }

  ///通过id触发点击事件
  ///[id]界面元素id
  bool id2Click(String id) {
    initElement2IdMap();
    if (element2IdMap.containsKey(id)) {
      Element element = element2IdMap[id];
      final Widget widget = element.widget;
      final RenderObject renderObject = element.renderObject;
      debugPrint(
          'Element=$element,widget=$widget,renderObject=$renderObject:position=$renderObject');
      List<Element> list = FutIdGenerator.debugGetElementCreatorChain(element);
      bool match = false;
      list.forEach((Element element) {
        if (element != null && element.widget is GestureDetector) {
          (element.widget as GestureDetector).onTap();
          match = true;
          return;
        }
      });
      return match;
    }
    return false;
  }

  Map text2Position(String text) {
    initElement2IdMap();
    num x = 0;
    num y = 0;
    element2IdMap.forEach((key, element) {
      final Widget widget = element.widget;
      final RenderObject renderObject = element.renderObject;
      if (renderObject is RenderParagraph) {
        if ((renderObject.text as TextSpan).text == base64Decode(text)) {
          //偏移
          Offset offset = renderObject.localToGlobal(Offset(0, 0));
          //大小
          Size size = renderObject.size;
          num cacheX = (offset.dx + size.width / 2) * window.devicePixelRatio;
          num cacheY = (offset.dy + size.height / 2) * window.devicePixelRatio;
          if (cacheX < window.physicalSize.width &&
              cacheY < window.physicalSize.height) {
            x = cacheX;
            y = cacheY;
          }
        }
      }
    });
    return {'x': x, 'y': y};
  }

  ///通过id获取其在界面中的具体文本内容[Text]
  ///[id]界面元素id
  ///[text]需要验证的元素内容文本
  ///[bool]返回true，如果元素[id]对应的内容为[text];反之返回false
  bool assetText(String id, String text) {
    initElement2IdMap();
    if (element2IdMap.containsKey(id)) {
      Element element = element2IdMap[id];
      return _assetChildText(element, text);
    }
    return false;
  }

  bool _assetChildText(Element element, String text) {
    final RenderObject renderObject = element.renderObject;
    var isEquals = false;
    if (renderObject is RenderParagraph &&
        (renderObject.text as TextSpan).text == base64Decode(text)) {
      isEquals = true;
    } else {
      element.visitChildElements((element) {
        isEquals = _assetChildText(element, text);
      });
    }
    return isEquals;
  }

  void setText(String id, String text) {
    initElement2IdMap();
    if (element2IdMap.containsKey(id)) {
      Element element = element2IdMap[id];
      _setChildText(element, base64Decode(text));
    }
  }

  void _setChildText(Element element, String text) {
    final Widget widget = element.widget;
    if (widget is TextField) {
      widget.controller.text = text;
    } else {
      element.visitChildElements((element) {
        _setChildText(element, text);
      });
    }
  }
}
