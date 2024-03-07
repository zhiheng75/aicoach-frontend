import 'dart:io';

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
        body: Center(
          child: Container(
            padding:
                const EdgeInsets.only(top: 30, bottom: 15, left: 20, right: 20),
            // width: 330,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: ImageUtils.getAssetImage("agreement_dialog_bg"),
                  fit: BoxFit.fitHeight),

              // borderRadius: BorderRadius.all(Radius.circular(30)),
              // gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     colors: [
              //       Colours.color_300EF4D1,
              //       Colours.color_3053C5FF,
              //       Colours.color_30E0AEFF,
              //     ],
              //     stops: [0,0.7,0.9]
              // )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.vGap30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "请阅读并同意",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colours.color_111B44,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigatorUtils.goWebViewPage(context, "隐私政策",
                            "http://www.shenmo-ai.com/privacy_policy/");
                      },
                      child: const Text("隐私政策",
                          style: TextStyle(
                              color: Colours.color_111B44,
                              fontSize: 17,
                              decoration: TextDecoration.underline)),
                    ),
                    const Text(
                      "和",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colours.color_111B44,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigatorUtils.goWebViewPage(
                            context, "服务协议", "http://www.shenmo-ai.com/tos/");
                      },
                      child: const Text(
                        "服务协议",
                        style: TextStyle(
                            color: Colours.color_111B44,
                            fontSize: 17,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                Gaps.vGap24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        exit(0);
                        NavigatorUtils.goBack(context);
                      },
                      child: Container(
                        width: 125,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ImageUtils.getAssetImage(
                                "confirm_bg1",
                              ),
                              fit: BoxFit.fill),
                        ),
                        child: const Center(
                          child: Text(
                            "不同意",
                            style: TextStyle(
                                fontSize: 13, color: Colours.color_3389FF),
                          ),
                        ),
                      ),
                    ),
                    Gaps.hGap15,
                    GestureDetector(
                      onTap: () async {
                        NavigatorUtils.goBack(context);
                        // await SystemNavigator.pop();

                        widget._confirmPress();
                      },
                      child: Container(
                        width: 125,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ImageUtils.getAssetImage(
                                "cancel_bg1",
                              ),
                              fit: BoxFit.fill),
                        ),
                        child: const Center(
                          child: Text(
                            "确定",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
          // Stack(
          //   children: [
          //     // Container(
          //     //   padding:const EdgeInsets.only(top: 30, bottom: 15, left: 20, right: 20),
          //     //   width: 330,
          //     //   height: 180,
          //     //   decoration: const BoxDecoration(
          //     //       borderRadius: BorderRadius.all(Radius.circular(30)),
          //     //       color: Colors.white
          //     //   ),
          //     // ),
          //     Container(
          //       padding:const EdgeInsets.only(top: 30, bottom: 15, left: 20, right: 20),
          //       width: 330,
          //       height: 180,
          //       decoration:  BoxDecoration(
          //
          //         image:DecorationImage(
          //             image: ImageUtils.getAssetImage("agreement_dialog_bg"),
          //             fit: BoxFit.fitHeight),
          //
          //           // borderRadius: BorderRadius.all(Radius.circular(30)),
          //           // gradient: LinearGradient(
          //           //     begin: Alignment.topRight,
          //           //     end: Alignment.bottomLeft,
          //           //     colors: [
          //           //       Colours.color_300EF4D1,
          //           //       Colours.color_3053C5FF,
          //           //       Colours.color_30E0AEFF,
          //           //     ],
          //           //     stops: [0,0.7,0.9]
          //           // )
          //       ),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Gaps.vGap30,
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               const Text("请阅读并同意", style: TextStyle(fontSize: 17, color: Colours.color_111B44,),),
          //               GestureDetector(
          //                 onTap: () {
          //                   NavigatorUtils.goWebViewPage(context, "隐私政策",
          //                       "http://www.shenmo-ai.com/privacy_policy/");
          //                 },
          //                 child: const Text("隐私政策", style: TextStyle(
          //                     color: Colours.color_111B44,
          //                     fontSize: 17, decoration: TextDecoration.underline)),
          //               ),
          //               const Text("和", style: TextStyle(fontSize: 17, color: Colours.color_111B44,),),
          //               GestureDetector(
          //                 onTap: () {
          //                   NavigatorUtils.goWebViewPage(
          //                       context, "服务协议", "http://www.shenmo-ai.com/tos/");
          //                 },
          //                 child: const Text("服务协议", style: TextStyle(
          //                     color: Colours.color_111B44,
          //                     fontSize: 17, decoration: TextDecoration.underline),),
          //               ),
          //             ],
          //           ),
          //           Gaps.vGap24,
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               GestureDetector(
          //                 onTap: () {
          //                   NavigatorUtils.goBack(context);
          //
          //                 },
          //                 child: Container(
          //                   width: 125,
          //                   height: 40,
          //                   decoration: BoxDecoration(
          //                     image: DecorationImage(
          //                         image: ImageUtils.getAssetImage(
          //                           "confirm_bg1",),
          //                         fit: BoxFit.fill
          //                     ),
          //                   ),
          //
          //                   child:const Center(
          //                     child:Text("再想一想", style: TextStyle(fontSize: 13,color: Colours.color_3389FF),) ,
          //                   ) ,
          //                 ),
          //               ),
          //               Gaps.hGap15,
          //               GestureDetector(
          //                 onTap: () async {
          //                   NavigatorUtils.goBack(context);
          //                   // await SystemNavigator.pop();
          //
          //                   widget._confirmPress();
          //                 },
          //                 child: Container(
          //                   width: 125,
          //                   height:40,
          //                   decoration: BoxDecoration(
          //                     image: DecorationImage(
          //                         image: ImageUtils.getAssetImage(
          //                           "cancel_bg1",),
          //                         fit: BoxFit.fill
          //                     ),
          //                   ),
          //                   child:const Center(
          //                     child: Text("确定",style: TextStyle(fontSize: 13,color: Colors.white),),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           )
          //         ],
          //       ),
          //     )
          //   ],
          // )
          ,
        ));
  }
}
