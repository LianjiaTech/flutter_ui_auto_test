import 'package:flutter/material.dart';

class FutToast {
  static const LENGTH_SHORT = 1;
  static const LENGTH_LONG = 2;
  static const BOTTOM = 0;
  static const CENTER = 1;
  static const TOP = 2;

  static ToastView preToastView;

  ///
  /// 显示Toast
  ///
  static void show(String text, BuildContext context,
      {int duration = 1,
      int gravity = 0,
      Color backgroundColor = const Color(0xFF222222),
      textStyle = const TextStyle(fontSize: 16, color: Colors.white),
      double backgroundRadius = 5,
      Image preIcon}) {
    if (text == null || context == null) {
      return;
    }
    preToastView?._dismiss();
    preToastView = null;

    ToastView toastView = ToastView();
    toastView.overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = new OverlayEntry(builder: (context) {
      return _buildToastLayout(context, backgroundColor, backgroundRadius,
          preIcon, text, textStyle, gravity);
    });
    toastView._overlayEntry = overlayEntry;
    preToastView = toastView;
    toastView._show(duration);
  }
}

ToastWidget _buildToastLayout(
    BuildContext context,
    Color background,
    double backgroundRadius,
    Image preIcon,
    String msg,
    TextStyle textStyle,
    int gravity) {
  return ToastWidget(
      widget: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(backgroundRadius),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: RichText(
                text: TextSpan(children: <InlineSpan>[
                  preIcon != null
                      ? WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: preIcon,
                          ))
                      : TextSpan(text: ""),
                  TextSpan(text: msg, style: textStyle),
                ]),
              ),
            )),
      ),
      gravity: gravity);
}

class ToastView {
  OverlayState overlayState;
  OverlayEntry _overlayEntry;
  bool _isVisible = false;

  _show(int duration) async {
    _isVisible = true;
    overlayState.insert(_overlayEntry);
    await new Future.delayed(
        Duration(seconds: duration == null ? 1 : duration));
    _dismiss();
  }

  _dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class ToastWidget extends StatelessWidget {
  final Widget widget;
  final int gravity;

  ToastWidget({
    Key key,
    @required this.widget,
    @required this.gravity,
  }) : super(key: key);

  ///
  /// 使用IgnorePointer，方便手势透传过去
  ///
  @override
  Widget build(BuildContext context) {
    return new Positioned(
        top: gravity == 2 ? MediaQuery.of(context).viewInsets.top + 50 : null,
        bottom:
            gravity == 0 ? MediaQuery.of(context).viewInsets.bottom + 50 : null,
        child: IgnorePointer(
          child: Material(
            color: Colors.transparent,
            child: widget,
          ),
        ));
  }
}
