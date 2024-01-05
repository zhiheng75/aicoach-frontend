import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/load_image.dart';

class Record extends StatefulWidget {
  const Record({
    Key? key,
    required this.show,
    required this.controller,
  }) : super(key: key);

  final bool show;
  final RecordController controller;

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {

  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) {
      return const SizedBox();
    }

    return Container(
      width: _screenUtil.screenWidth,
      height: _screenUtil.screenHeight,
      color: Colors.black.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 56.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/shengbo_pink.png',
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          const SizedBox(
            height: 62.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ValueListenableBuilder(
                valueListenable: widget.controller.isInSendButton,
                builder: (_, isInSendButton, __) => Text(
                  isInSendButton ? '松开发送' : '松开取消',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFCCCCCC),
                    height: 18.0 / 14.0,
                    letterSpacing: 0.05,
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              SizedBox(
                width: 64.0,
                height: 64.0,
                child: ValueListenableBuilder(
                  valueListenable: widget.controller.isInSendButton,
                  builder: (_, isInSendButton, __) => isInSendButton ? const SizedBox() : const LoadAssetImage(
                    'quxiaofasong',
                    width: 64.0,
                    height: 64.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              SizedBox(
                key: widget.controller.sendButtonGlobalKey,
                width: _screenUtil.screenWidth,
                height: 112.0,
                child: ValueListenableBuilder(
                  valueListenable: widget.controller.isInSendButton,
                  builder: (_, isInSendButton, __) {
                    return Container(
                      width: _screenUtil.screenWidth,
                      height: 112.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            isInSendButton ? 'assets/images/fasong_active.png' : 'assets/images/fasong_disabled.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: LoadAssetImage(
                        isInSendButton ? 'yuying_333' : 'yuying_999',
                        width: 22.0,
                        height: 16.0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

class RecordController {

  RecordController();

  final GlobalKey _sendButtonGlobalKey = GlobalKey();
  final ValueNotifier<bool> _isInSendButton = ValueNotifier(false);

  GlobalKey get sendButtonGlobalKey => _sendButtonGlobalKey;
  ValueNotifier<bool> get isInSendButton => _isInSendButton;

  void fingerDetection(Offset offset) async {
    int maxTryCount = 5;
    while(_sendButtonGlobalKey.currentContext == null && maxTryCount > 0) {
      await Future.delayed(const Duration(milliseconds: 100));
      maxTryCount--;
    }
    isInSendButton.value = _check(offset, _sendButtonGlobalKey);
  }

  bool _check(Offset offset, GlobalKey globalKey) {
    BuildContext? context = globalKey.currentContext;
    if (context == null) {
      return false;
    }
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset localOffset = renderBox.globalToLocal(offset);
    return renderBox.hitTest(BoxHitTestResult(), position: localOffset);
  }

}