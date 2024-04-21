//课程订单
import 'package:Bubble/person/view/course_order_item.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseOrderPage extends StatefulWidget {
  const CourseOrderPage({super.key});

  @override
  State<CourseOrderPage> createState() => _CourseOrderPageState();
}

class _CourseOrderPageState extends State<CourseOrderPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "课程订单",
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
                onTap: () {},
                child: const CourseOrderItem(),
              );
            },
            itemCount: 10,
          )
        ],
      ))),
    );
  }
}
