import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

import '../res/colors.dart';
import '../res/dimens.dart';
import '../util/theme_utils.dart';

class MyImgButton extends StatelessWidget {

  const MyImgButton({
    super.key,
    this.minHeight = 20.0,
    this.minWidth = 20.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    required this.onPressed, required this.url,
  });

  final double? minHeight;
  final double? minWidth;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final String url;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: LoadAssetImage(url,width: minWidth,height: minHeight,)
    );
  }
}
