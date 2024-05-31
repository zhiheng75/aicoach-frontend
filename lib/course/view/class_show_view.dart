import 'dart:async';

import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:flutter/material.dart';

class ClassShowView extends StatefulWidget {
  final VoidCallback _confirmPress;
  final VoidCallback _cancelPress;

  const ClassShowView(this._confirmPress, this._cancelPress, {Key? key})
      : super(key: key);

  @override
  State<ClassShowView> createState() => _ClassShowViewState();
}

class _ClassShowViewState extends State<ClassShowView> {
  late Timer _timer;
  late int _secondsRemaining = 5; // 倒计时10秒

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_secondsRemaining < 1) {
        // 倒计时结束的操作
        NavigatorUtils.goBack(context);
        widget._confirmPress();
        timer.cancel();
        _secondsRemaining = 0;
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            height: 310,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: ImageUtils.getAssetImage("tanchuang"),
                  fit: BoxFit.fitHeight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gaps.vGap168,
                Container(
                  height: 235,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigatorUtils.goBack(context);
                        widget._cancelPress();
                      },
                      child: Container(
                        width: 114,
                        height: 53,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ImageUtils.getAssetImage(
                                "quxiao_img",
                              ),
                              fit: BoxFit.fill),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Restart",
                              style: TextStyle(
                                  fontSize: 17, color: Colours.color_875EFF),
                            ),
                            Text(
                              "重新开始",
                              style: TextStyle(
                                  fontSize: 11, color: Colours.color_875EFF),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gaps.hGap15,
                    GestureDetector(
                      onTap: () async {
                        NavigatorUtils.goBack(context);
                        widget._confirmPress();
                      },
                      child: Container(
                        width: 114,
                        height: 53,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ImageUtils.getAssetImage(
                                "queding_img",
                              ),
                              fit: BoxFit.fill),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${_secondsRemaining.toString()}s Next",
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.white),
                            ),
                            const Text(
                              "下一环节",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
