import 'package:flutter/material.dart';

class CourseOrderItem extends StatelessWidget {
  const CourseOrderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("课名"),
          Text("时间"),
          Text("订单号"),
          Text("老师"),
          Text("金额"),
          Text("付款方式"),
          Text("赠品"),
        ],
      ),
    );
  }
}
