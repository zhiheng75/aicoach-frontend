//课程详情
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseDetailsPage extends StatefulWidget {
  const CourseDetailsPage({super.key});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "课程介绍",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: Column(
        children: [
          Text("介绍"),
          Text("好的"),
        ],
      ))),
    );
  }
}
