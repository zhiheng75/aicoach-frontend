import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/colors.dart';
import 'example.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final ScreenUtil _screenUtil = ScreenUtil();

  void getExample() {
    String text = 'Hello, I would like to ask what preparations need to be made for traveling abroad.';
    String textZh = '你好，可以告诉我国外旅游需要做哪些准备吗？';
    String audio = '';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: false,
      clipBehavior: Clip.none,
      builder: (_) => Example(
        text: text,
        textZh: textZh,
        audio: audio,
      ),
    );
  }

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
    Widget iconButtom({
      required Widget child,
      required Function() onPress,
    }) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPress,
        child: Container(
          width: 48.0,
          height: 48.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: const Color(0xFF001652).withOpacity(0.23)
          ),
          alignment: Alignment.center,
          child: child,
        ),
      );
    }

    return Container(
      width: _screenUtil.screenWidth,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: iconButtom(
              onPress: () {},
              child: const LoadAssetImage(
                'yanjing_kai',
                width: 24.0,
                height: 17.9,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: () {},
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  border: Border.all(
                    width: 1.0,
                    style: BorderStyle.solid,
                    color: Colours.color_001652,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colours.color_9AC3FF,
                      Colours.color_FF71E0,
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    LoadAssetImage(
                      'maikefeng',
                      width: 24.0,
                      height: 24.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '按住说话',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        color: Colours.color_001652,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: iconButtom(
              onPress: getExample,
              child: const LoadAssetImage(
                'tishi',
                width: 17.5,
                height: 24.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}