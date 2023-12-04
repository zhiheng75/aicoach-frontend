import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

class RoundPictureWidget extends StatelessWidget {
  final String url;
  final double radiu;
  final double width;
  final double height;
  final BoxFit fit;
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;
  final String holderImg;

  const RoundPictureWidget({
    Key? key,
    required this.url,
    this.radiu = 0.0,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.topLeft = 10,
    this.topRight = 10,
    this.bottomRight = 10,
    this.bottomLeft = 10, required this.holderImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return radiu == 0
        ? ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeft),
                topRight: Radius.circular(topRight),
                bottomLeft: Radius.circular(bottomLeft),
                bottomRight: Radius.circular(bottomRight)),
            child: LoadImage(
              url,
              holderImg: holderImg,
              width: width,
              height: height,
            ))
        : ClipRRect(
            borderRadius: BorderRadius.circular(radiu),
            child: LoadImage(
              url,
              holderImg: holderImg,
              width: width,
              height: height,
            ));
  }
}
