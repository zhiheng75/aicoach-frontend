//课程报告
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseReportPage extends StatefulWidget {
  const CourseReportPage({super.key});

  @override
  State<CourseReportPage> createState() => _CourseReportPageState();
}

class _CourseReportPageState extends State<CourseReportPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "课程报告",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Column(
              children: [
                Text("L1学习班"),
                Text("认识动物"),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: Text("用户相关信息"),
          ),
          const SliverToBoxAdapter(
            child: Text("口语评测结果"),
          ),
          const SliverToBoxAdapter(
            child: Text("优秀表达"),
          ),
          SliverList.builder(
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {},
                child: const Text("boagao"),
              );
            },
            itemCount: 3,
          ),
          const SliverToBoxAdapter(
            child: Text("我的优秀表达"),
          ),
          SliverList.builder(
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {},
                child: const Text("boagao"),
              );
            },
            itemCount: 3,
          ),
          const SliverToBoxAdapter(
            child: Text("本节课收货"),
          ),
          const SliverToBoxAdapter(
            child: Text("举行学习学习"),
          ),
          SliverList.builder(
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {},
                child: const Text("boagao"),
              );
            },
            itemCount: 3,
          ),
          const SliverToBoxAdapter(
            child: Text("给本节课打个分"),
          ),
        ],
      ))),
    );
  }
}
