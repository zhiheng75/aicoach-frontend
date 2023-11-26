import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spokid/res/gaps.dart';
import 'package:spokid/routers/fluro_navigator.dart';

import '../res/colors.dart';

class AgreementDialog extends StatefulWidget {

  final VoidCallback _confirmPress;

  const AgreementDialog(this._confirmPress,{Key? key}) : super(key: key);

  @override
  State<AgreementDialog> createState() => _AgreementDialogState();
}

class _AgreementDialogState extends State<AgreementDialog> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child:
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 15, left: 20, right: 20),
            width: 300,
            height: 120,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colours.color_5B8BD2,
                    Colours.color_00E6D0,
                  ],
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("请阅读并同意", style: TextStyle(fontSize: 12),),
                GestureDetector(
                  onTap: () {
                    NavigatorUtils.goWebViewPage(context, "隐私政策",
                        "http://www.shenmo-ai.com/privacy_policy/");
                  },
                  child: const Text("隐私政策", style: TextStyle(
                      fontSize: 12, decoration: TextDecoration.underline)),
                ),
                Text("和", style: TextStyle(fontSize: 12),),
                GestureDetector(
                  onTap: () {
                    NavigatorUtils.goWebViewPage(
                        context, "服务协议", "http://www.shenmo-ai.com/tos/");
                  },
                  child: const Text("服务协议", style: TextStyle(
                      fontSize: 12, decoration: TextDecoration.underline),),
                ),
              ],
            ),
            Gaps.vGap24,
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                GestureDetector(
                onTap: ()
            {
            NavigatorUtils.goBack(context);
            widget._confirmPress();
            },
            child: Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50)),
                  border: Border.all(
                    width: 1,
                    color: Colours.bg_color,
                  )
              ),

              child:const Center(
                child:Text("确定", style: TextStyle(fontSize: 10),) ,
              ) ,
            ),
          ),
          Gaps.hGap15,
          GestureDetector(
            onTap: () async {
              NavigatorUtils.goBack(context);
              await SystemNavigator.pop();
            },
            child: Container(
              width: 80,
              height: 30,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colours.color_0EF4D1,
                        Colours.color_53C5FF,
                        Colours.color_E0AEFF,
                      ],
                    ),
                    border: Border.all(
                      width: 1,
                      color: Colours.bg_color,
                    )
                ),
                child:const Center(
                  child: Text("再想一想",style: TextStyle(fontSize: 10),),
                ),
        ),
      ),
    ],
    )
    ],
    ),
    ),
    )
    );
  }
}
