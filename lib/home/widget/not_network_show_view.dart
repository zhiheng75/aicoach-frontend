import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:flutter/material.dart';

class NotNetworkShowView extends StatefulWidget {
  final VoidCallback _cancelPress;

  const NotNetworkShowView(this._cancelPress, {super.key});

  @override
  State<NotNetworkShowView> createState() => _NotNetworkShowViewState();
}

class _NotNetworkShowViewState extends State<NotNetworkShowView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            // height: 220,
            // width: 290,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.vGap24,
                const Text(
                  "网络连接失败",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Gaps.vGap10,
                const Text(
                  "检测到网络权限可能未开启,您可以在${"设置"}中检查蜂窝移动网络",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                Gaps.vGap26,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigatorUtils.goBack(context);
                      },
                      child: Container(
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colours.color_F2F3F5,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Center(
                          child: Text(
                            "取消",
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
                        width: 100,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colours.color_8003FD,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Center(
                          child: Text(
                            "设置",
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
