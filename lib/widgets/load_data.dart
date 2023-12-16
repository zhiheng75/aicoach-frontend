import 'package:Bubble/res/colors.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

class LoadData extends StatefulWidget {
  const LoadData({
    Key? key,
  }) : super(key: key);

  @override
  State<LoadData> createState() => _LoadDataState();

}

class _LoadDataState extends State<LoadData> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    controller.repeat();
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
  }

  @override
  void dispose() {
    if (controller.isAnimating) {
      controller.stop();
    }
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    Color color = Colours.hex2color('#546092');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RotationTransition(
          turns: animation,
          child: const LoadAssetImage(
            'nulijiazaizhong',
            width: 73.0,
            height: 73.0,
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          '努力加载中...',
          style: TextStyle(
            fontSize: 15.0,
            color: color,
            height: 25.0 / 15.0,
            letterSpacing: 50.0 / 15.0,
          ),
        ),
      ],
    );
  }
}
