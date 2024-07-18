import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyShowView extends StatefulWidget {
  final VoidCallback _cancelPress;

  const PrivacyShowView(this._cancelPress, {super.key});

  @override
  State<PrivacyShowView> createState() => _PrivacyShowViewState();
}

class _PrivacyShowViewState extends State<PrivacyShowView> {
  bool get isIPad {
    return MediaQuery.of(context).size.width > 500;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            // height: 220,
            // width: 290,
            margin: EdgeInsets.all(30.w),
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.vGap24,
                const Text(
                  "同意隐私条款",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Gaps.vGap10,
                RichText(
                    // RichText
                    text: TextSpan(
                        text: '登录注册需您阅读并同意我们的',
                        style: const TextStyle(
                          color: Colours.color_333333,
                          fontSize: 14.0,
                          height: 1.5,
                        ),
                        children: <TextSpan>[
                      TextSpan(
                          text: '《服务协议》',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              NavigatorUtils.goWebViewPage(context, "服务协议",
                                  "http://www.shenmo-ai.com/tos/");
                            },
                          style: const TextStyle(
                            color: Colours.color_007AFF,
                            fontSize: 14.0,
                            height: 1.5,
                          )),
                      TextSpan(
                          text: '《隐私协议》',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              NavigatorUtils.goWebViewPage(context, "隐私协议",
                                  "http://www.shenmo-ai.com/privacy_policy/");
                            },
                          style: const TextStyle(
                            color: Colours.color_007AFF,
                            fontSize: 14.0,
                            height: 1.5,
                          )),
                      TextSpan(
                          text: '《儿童个人信息保护声明》',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              NavigatorUtils.goWebViewPage(
                                  context,
                                  "儿童个人信息保护声明",
                                  "http://www.shenmo-ai.com/bubble-ai_kids/");
                            },
                          style: const TextStyle(
                            color: Colours.color_007AFF,
                            fontSize: 14.0,
                            height: 1.5,
                          )),
                    ])),
                Gaps.vGap26,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        EventUMStatistics.umengCommonMapEvent(
                            "layer_click_agreement_no");

                        NavigatorUtils.goBack(context);
                      },
                      child: Container(
                        width: 100.w,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colours.color_F2F3F5,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            "不同意",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    // Gaps.hGap10,
                    GestureDetector(
                      onTap: () async {
                        NavigatorUtils.goBack(context);
                        widget._cancelPress();
                      },
                      child: Container(
                        width: 150.w,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colours.color_8003FD,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            "同意",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
