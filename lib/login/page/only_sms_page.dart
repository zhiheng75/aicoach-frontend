import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spokid/res/dimens.dart';
import 'package:spokid/res/gaps.dart';

import '../../res/colors.dart';
import '../../res/styles.dart';
import '../../widgets/my_app_bar.dart';

class OnlySmsPage extends StatefulWidget {
  const OnlySmsPage({Key? key}) : super(key: key);

  @override
  State<OnlySmsPage> createState() => _OnlySmsPageState();
}

class _OnlySmsPageState extends State<OnlySmsPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child:Scaffold(
          body: Container(
            padding:const EdgeInsets.only(left: 20,right: 20),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colours.color_00FFB4,
                    Colours.color_0E90FF,
                    Colours.color_DA2FFF,
                  ],
                )
            ),
            child: Column(
              children: [
                const MyAppBar(
                  backgroundColor: Colours.transflate,
                ),
                Gaps.vGap50,
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Bubble",
                    style: TextStyles.textBold26,
                  ),
                ),
                Gaps.vGap50,
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "请输入验证码",
                    style: TextStyle(fontSize: Dimens.font_sp18, color: Colors.white),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child:  Text(
                    "已发送短信到",
                    style: TextStyle(fontSize: Dimens.font_sp18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
