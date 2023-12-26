// ignore_for_file: prefer_final_fields

import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Background extends StatefulWidget {
  Background({
    Key? key,
    required this.controller,
    required this.characterAvatarList,
  }) : super(key: key);

  final BackgroundController controller;
  final List<String> characterAvatarList;

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  late PageController _controller;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    ScreenUtil screenUtil = ScreenUtil();
    _controller = widget.controller.instance();
    _children = widget.characterAvatarList.map((avatar) {
      return LoadImage(
        avatar,
        width: screenUtil.screenWidth,
        height: screenUtil.screenHeight,
      );
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      children: _children,
    );
  }
}

// controller
class BackgroundController {
  PageController _controller = PageController();

  BackgroundController();

  PageController instance() {
    return _controller;
  }

  void change(int index) {
    _controller.jumpToPage(index);
  }

}