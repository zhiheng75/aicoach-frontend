// ignore_for_file: prefer_final_fields

import 'package:Bubble/home/provider/home_provider.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Background extends StatefulWidget {
  const Background({
    Key? key,
  }) : super(key: key);

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
        return LoadImage(
          provider.chatBackground!,
          width: _screenUtil.screenWidth,
          height: _screenUtil.screenHeight,
        );
      },
    );
  }
}