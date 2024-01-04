// ignore_for_file: sized_box_for_whitespace

import 'dart:async';

import 'package:Bubble/login/view/verification_box.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/widgets/my_only_img_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckCodePage extends StatefulWidget {
  final String phoneNumber;

  const CheckCodePage({super.key, required this.phoneNumber});

  @override
  State<CheckCodePage> createState() => _CheckCodePageState();
}

class _CheckCodePageState extends State<CheckCodePage> {
  ///计时器
  Timer? _timer;

  ///当前倒计时秒数
  int? _seconds;

  ///能否重新发送
  bool canResend = false;

  final String _verfiCode = "";

  ///启动倒计时器
  void _startTimer() {
    _seconds = 30;
    canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        if (mounted) {
          setState(() {
            canResend = true;
          });
        }
        return;
      }
      _seconds = _seconds! - 1;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    _startTimer();

    super.initState();
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ImageUtils.getAssetImage("splash_bg"),
                    fit: BoxFit.fill)),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyOnlyImgBar(
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colours.transflate,
                    width: 32.0,
                    height: 32.0,
                    actionUrl: "white_close_img",
                    onActionPress: () {
                      NavigatorUtils.goBack(context);
                    }),
                const Padding(
                  padding: EdgeInsets.only(top: 108, left: 30, right: 16),
                  child: Text(
                    "请输入验证码:",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colours.color_001652,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                      ),
                      child: Text(
                        "已发送验证码到 ${widget.phoneNumber} ",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colours.color_001652,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  canResend
                      ? GestureDetector(
                          onTap: () {
                            if (canResend) {
                              resendCode();
                            }
                          },
                          child: const Text(
                            "重新发送",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF4884F3),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              "$_seconds",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF4884F3),
                              ),
                            ),
                            const Text("秒"),
                          ],
                        ),
                  const SizedBox(
                    width: 20,
                  ),
                ]),
                _verificationBox()
              ],
            )),
      ),
    );
  }

  Widget _verificationBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 32),
      child: Container(
        height: 45,
        child: VerificationBox(
          count: 6,
          onSubmitted: (code) {
            verifyCode(code);
          },
          itemWidget: 45,
          borderWidth: 1,
          borderColor: Colours.color_001652,
          borderRadius: 4,
          textStyle: const TextStyle(color: Color(0xFF666666), fontSize: 27),
          showCursor: true,
          unfocus: false,
        ),
      ),
    );
  }

  void verifyCode(String code) async {}

  ///重新发送验证码
  void resendCode() {
    _startTimer();
  }
}
