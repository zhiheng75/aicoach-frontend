// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../home/provider/home_provider.dart';
import '../../widgets/load_image.dart';

class Background extends StatefulWidget {
  const Background({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BackgroundController controller;

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {

  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, provider, __) {
        if (provider.chatBackground == null) {
          return const SizedBox();
        }
        return SizedBox(
          width: _screenUtil.screenWidth,
          child: ValueListenableBuilder(
            valueListenable: widget.controller.distance,
            builder: (_, distance, child) {
              return Row(
                children: <Widget>[
                  if (distance > 0 && widget.controller.slideDirection == 'right')
                    LoadImage(
                      widget.controller.leftImageUrl!,
                      width: distance,
                      height: _screenUtil.screenHeight,
                    ),
                  LoadImage(
                    provider.chatBackground!,
                    width: _screenUtil.screenWidth - distance,
                    height: _screenUtil.screenHeight,
                  ),
                  if (distance > 0 && widget.controller.slideDirection == 'left')
                    LoadImage(
                      widget.controller.rightImageUrl!,
                      width: distance,
                      height: _screenUtil.screenHeight,
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class BackgroundController {
  BackgroundController();

  Offset? initialPosition;
  // left-左滑 right-右滑
  String slideDirection = '';
  ValueNotifier<double> distance = ValueNotifier(0);
  String? leftImageUrl;
  String? rightImageUrl;

  void slideStart({
    required Offset position,
    required String leftImage,
    required String rightImage,
  }) {
    initialPosition = position;
    leftImageUrl= leftImage;
    rightImageUrl = rightImage;
  }

  void slideMove(Offset position) {
    if (initialPosition == null) {
      return;
    }
    double initialX = initialPosition!.dx;
    double x = position.dx;
    slideDirection = x == initialX ? '' : x > initialX ? 'right' : 'left';
    double xDistance = (x - initialX).abs();
    distance.value = xDistance;
  }

  void slideEnd(onSlideEnd) {
    if (distance.value > 50) {
      onSlideEnd(slideDirection);
    }
    distance.value = 0;
    slideDirection = '';
    initialPosition = null;
    leftImageUrl = null;
    rightImageUrl = null;
  }

}