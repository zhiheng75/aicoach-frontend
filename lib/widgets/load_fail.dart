import 'package:Bubble/res/colors.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

class LoadFail extends StatelessWidget {
  const LoadFail({
    Key? key,
    required this.reload
  }) : super(key: key);

  final Function() reload;

  @override
  Widget build(BuildContext context) {
    Color color = Colours.hex2color('#546092');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const LoadAssetImage(
          'jiazaishibai',
          width: 73.0,
          height: 73.0,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          '加载失败，请重新加载！',
          style: TextStyle(
            fontSize: 15.0,
            color: color,
            height: 25.0 / 15.0,
            letterSpacing: 17.0 / 15.0,
          ),
        ),
        const SizedBox(
          height: 27.0,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: reload,
          child: Container(
            width: 100.0,
            height: 23.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23.0),
              border: Border.all(
                width: 0.3,
                style: BorderStyle.solid,
                color: color,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const LoadAssetImage(
                  'chongxinhuoqu',
                  width: 10.0,
                  height: 10.0,
                ),
                const SizedBox(
                  width: 2.0,
                ),
                Text(
                  '刷新加载',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: color,
                    height: 18.0 / 13.0,
                    letterSpacing: 17.0 / 13.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
