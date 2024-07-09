import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';

import '../res/colors.dart';
import '../util/image_utils.dart';

class AgreementDialog extends StatefulWidget {
  final VoidCallback _confirmPress;

  const AgreementDialog(this._confirmPress, {Key? key}) : super(key: key);

  @override
  State<AgreementDialog> createState() => _AgreementDialogState();
}

class _AgreementDialogState extends State<AgreementDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const Expanded(child: Gaps.empty),
            Container(
              // color: Colors.white,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(
                  top: 30, bottom: 30, left: 20, right: 20),
              // width: 330,
              // height: 330,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //       image: ImageUtils.getAssetImage("agreement_dialog_bg"),
              //       fit: BoxFit.fitHeight),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "欢迎来到口语嘟嘟",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.vGap16,
                  RichText(
                      // RichText
                      text: TextSpan(
                          text: '在您使用口语嘟嘟之前，请认真阅读并了解',
                          style: const TextStyle(
                            color: Colours.color_333333,
                            fontSize: 14.0,
                          ),
                          children: <TextSpan>[
                        TextSpan(
                            text: '《使用协议和版权声明》',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                NavigatorUtils.goWebViewPage(
                                    context,
                                    "使用协议和版权声明",
                                    "http://www.shenmo-ai.com/tos/");
                              },
                            style: const TextStyle(
                              color: Colours.color_0047FF,
                              fontSize: 14.0,
                            )),
                        const TextSpan(
                            text: '和',
                            style: TextStyle(
                              color: Colours.color_333333,
                              fontSize: 14.0,
                            )),
                        TextSpan(
                            text: '《用户隐私保护指引》',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                NavigatorUtils.goWebViewPage(
                                    context,
                                    "用户隐私保护指引",
                                    "http://www.shenmo-ai.com/privacy_policy/");
                              },
                            style: const TextStyle(
                              color: Colours.color_0047FF,
                              fontSize: 14.0,
                            )),
                        const TextSpan(
                            text:
                                '。如您未满14周岁，您还需要通知您的监护人共同阅读《儿童隐私政策》。点击“同意”即表示您和您的监护人已阅读并同意前述协议和政策。',
                            style: TextStyle(
                              color: Colours.color_333333,
                              fontSize: 14.0,
                            )),
                        TextSpan(
                            text: '《儿童隐私政策》',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                NavigatorUtils.goWebViewPage(context, "儿童隐私政策",
                                    "http://www.shenmo-ai.com/bubble-ai_kids/");
                              },
                            style: const TextStyle(
                              color: Colours.color_0047FF,
                              fontSize: 14.0,
                            )),
                        const TextSpan(
                            text: '。点击“同意”即表示您和您的监护人已阅读并同意前述协议和政策。',
                            style: TextStyle(
                              color: Colours.color_333333,
                              fontSize: 14.0,
                            )),
                      ])),
                  Gaps.vGap24,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          NavigatorUtils.goBack(context);
                          // await SystemNavigator.pop();

                          widget._confirmPress();
                        },
                        child: Container(
                          width: 280,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colours.color_8003FD,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //       image: ImageUtils.getAssetImage(
                          //         "cancel_bg1",
                          //       ),
                          //       fit: BoxFit.fill),
                          // ),
                          child: const Center(
                            child: Text(
                              "我已阅读并同意",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gaps.vGap12,
                      GestureDetector(
                        onTap: () {
                          exit(0);
                        },
                        child: const Center(
                          child: Text(
                            "暂不使用",
                            style: TextStyle(
                                fontSize: 13, color: Colours.color_999999),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
