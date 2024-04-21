//认证学习
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CertifiedLearningPage extends StatefulWidget {
  const CertifiedLearningPage({super.key});

  @override
  State<CertifiedLearningPage> createState() => _CertifiedLearningPageState();
}

class _CertifiedLearningPageState extends State<CertifiedLearningPage> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "获得证书",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: Column(
        children: [
          LoadImage(
            "https://statics.shenmo-ai.com/sophia.jpg",
            width: 200.0,
            height: 200,
          ),
          Text("2121212元"),
          Text("获得条件"),
          Text("必须到达85分以上"),
          Text("获得证书"),
        ],
      ))),
    );
  }
}
