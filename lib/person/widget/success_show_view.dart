import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessShowView extends StatefulWidget {
  final String titStr;
  final String msgStr;
  final String btnStr;

  const SuccessShowView({
    super.key,
    required this.titStr,
    required this.msgStr,
    required this.btnStr,
  });

  @override
  State<SuccessShowView> createState() => _SuccessShowViewState();
}

class _SuccessShowViewState extends State<SuccessShowView> {
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
            margin:
                isIPad ? const EdgeInsets.all(100) : const EdgeInsets.all(40),
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.vGap24,
                Text(
                  widget.titStr,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Gaps.vGap10,
                Text(
                  widget.msgStr,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Colors.black),
                ),
                Gaps.vGap26,
                GestureDetector(
                  onTap: () async {
                    NavigatorUtils.goBack(context);
                  },
                  child: Container(
                    width: 280,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colours.color_8003FD,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        widget.btnStr,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Gaps.vGap12,
              ],
            ),
          ),
        ));
  }
}
