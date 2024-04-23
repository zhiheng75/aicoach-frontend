import 'package:flutter/material.dart';

class CourseOrderItem extends StatelessWidget {
  const CourseOrderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.red,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 26.0,
      ),
      // height: 160,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("课名"),
          Text("课程金额"),
          Text("课程有效期"),
          Text("支付时间"),
          Text("支付方式"),
          // Text("付款方式"),
          Text("赠品"),
        ],
      ),
    );
  }
}
