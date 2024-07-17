import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PushShowView extends StatefulWidget {
  final VoidCallback _cancelPress;
  const PushShowView(this._cancelPress, {Key? key}) : super(key: key);

  @override
  State<PushShowView> createState() => _PushShowViewState();
}

class _PushShowViewState extends State<PushShowView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            // height: 220,
            // width: 290,
            margin: EdgeInsets.all(40),
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.vGap24,
                const Text(
                  "开启通知权限",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Gaps.vGap10,
                const Text(
                  "开启推送，不再错过伙伴的信息、老师的重要通知和好玩的活动",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Colors.black),
                ),
                Gaps.vGap26,
                GestureDetector(
                  onTap: () async {
                    NavigatorUtils.goBack(context);
                    widget._cancelPress();
                  },
                  child: Container(
                    width: 280,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colours.color_8003FD,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Center(
                      child: Text(
                        "去开启",
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
                    EventUMStatistics.umengCommonMapEvent(
                        "layer_click_message_skip");
                    NavigatorUtils.goBack(context);
                  },
                  child: const Center(
                    child: Text(
                      "下次再说",
                      style:
                          TextStyle(fontSize: 13, color: Colours.color_999999),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
