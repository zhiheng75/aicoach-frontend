//课程流程
import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/course/view/course_flow_item.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseFlowPage extends StatefulWidget {
  const CourseFlowPage({super.key});

  @override
  State<CourseFlowPage> createState() => _CourseFlowPageState();
}

class _CourseFlowPageState extends State<CourseFlowPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "课程流程",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  if (index == 0) {
                    NavigatorUtils.push(
                      context,
                      CourseRouter.courseDetailsPage,
                    );
                  } else if (index == 1) {
                    NavigatorUtils.push(
                      context,
                      CourseRouter.courseReportPage,
                    );
                  }
                },
                child: const CourseFlowItem(),
              );
            },
            itemCount: 10,
          )
        ],
      ))),
    );
  }
}
