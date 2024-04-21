import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JoinCommunityPage extends StatefulWidget {
  const JoinCommunityPage({super.key});

  @override
  State<JoinCommunityPage> createState() => _JoinCommunityPageState();
}

class _JoinCommunityPageState extends State<JoinCommunityPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "添加辅导老师",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: Column(
        children: [
          const Text("添加辅导老师微信,否则无法正常上课"),
          const Text("L1口语训练营"),
          const Text("时间"),
          Row(
            children: [
              SizedBox(
                width: 80.0,
                height: 80.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: const LoadImage(
                    "https://statics.shenmo-ai.com/sophia.jpg",
                    width: 80.0,
                  ),
                ),
              ),
              const Column(
                children: [
                  Text("橙子老师"),
                  Text("口语嘟嘟  辅导老师"),
                ],
              ),
            ],
          ),
          const LoadImage(
            "https://statics.shenmo-ai.com/sophia.jpg",
            width: 200.0,
            height: 200,
          ),
          const Text("添加辅导老师微信\n第一时间获取科恒信息和辅导"),
        ],
      ))),
    );
  }
}
