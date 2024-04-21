import 'package:flutter/material.dart';

class CourseFlowItem extends StatefulWidget {
  const CourseFlowItem({super.key});

  @override
  State<CourseFlowItem> createState() => _CourseFlowItemState();
}

class _CourseFlowItemState extends State<CourseFlowItem> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 40, child: Text("先导视频学习"));
  }
}
